const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");

admin.initializeApp();

// 0. KRİTİK SİSTEM ALARM FONKSİYONU
exports.adminKritikAlarm = onDocumentCreated('system_alerts/{alertId}', async (event) => {
    try {
        const alertData = event.data.data();
        const message = {
            token: functions.config().admin?.phone_token,
            notification: { title: '⚠ KRİTİK SİSTEM ALARMI', body: alertData.message || 'Sistemde müdahale gerektiren bir durum var!' },
            android: { priority: 'high', notification: { channelId: 'high_importance_channel', sound: 'default', visibility: 'public' } },
        };
        return await admin.messaging().send(message);
    } catch (e) {
        console.error("Alarm hatası:", e);
    }
});

// 2. Acil Çağrı Bildirim Fonksiyonu
exports.acilUstaBildirimiGonder = onDocumentCreated('acil_cagri/{cagriId}', async (event) => {
    const snapshot = event.data;
    if (!snapshot) return null;
    const cagriData = snapshot.data();
    const cagriId = event.params.cagriId;
    const gelenKategori = (cagriData.kategoriId || "").toString().trim().toUpperCase();
    const gelenIlceId = cagriData.ilceId;
    const gelenIlId = cagriData.ilId;
    try {
        let ustalarSnapshot = await admin.firestore().collection('users').where('role', '==', 'usta').where('ilce_id', '==', gelenIlceId).get();
        if (ustalarSnapshot.empty) {
            ustalarSnapshot = await admin.firestore().collection('users').where('role', '==', 'usta').where('sehir_id', '==', gelenIlId).get();
        }
        const tokens = [];
        ustalarSnapshot.forEach(doc => {
            const ustaData = doc.data();
            const ustaUzmanliklari = (ustaData.uzmanliklar || []).map(u => u.toString().trim().toUpperCase());
            if (ustaUzmanliklari.includes(gelenKategori) && ustaData.fcmToken) {
                tokens.push(ustaData.fcmToken);
            }
        });
        if (tokens.length > 0) {
            const message = {
                tokens: tokens,
                notification: { title: '🚨 ACİL İŞ ÇAĞRISI!', body: 'Bölgenizde yeni bir acil çağrı var.' },
                android: { priority: 'high', notification: { channelId: 'high_importance_channel', sound: 'default', visibility: 'public', clickAction: 'FLUTTER_NOTIFICATION_CLICK' } },
                data: { type: 'acil_cagri', ilanId: String(cagriId), actionType: 'odeme_ekrani', lat: String(cagriData.latitude || 0), lng: String(cagriData.longitude || 0) }
            };
            await admin.messaging().sendEachForMulticast(message);
        }
        return null;
    } catch (e) {
        console.error("❌ Hata:", e);
        return null;
    }
});

// 3. Yeni Mesaj Bildirim Fonksiyonu
exports.sendNotificationOnMessage = onDocumentCreated('chats/{chatId}/mesajlar/{mesajId}', async (event) => {
    try {
        const chatId = event.params.chatId;
        const mesajData = event.data.data();
        if (!mesajData || !mesajData.gonderenId) return null;
        const chatDoc = await admin.firestore().collection('chats').doc(chatId).get();
        if (!chatDoc.exists) return null;
        const chatData = chatDoc.data();
        const katilimcilar = chatData.katilimcilar || [];
        const ilanId = chatData.ilanId || "";
        const aliciId = katilimcilar.find(id => id !== mesajData.gonderenId);
        if (!aliciId) return null;
        const userDoc = await admin.firestore().collection('users').doc(aliciId).get();
        if (!userDoc.exists || !userDoc.data().fcmToken) return null;
        const fcmToken = userDoc.data().fcmToken;
        return await admin.messaging().send({
            token: fcmToken,
            notification: { title: 'Yeni Mesajınız Var', body: (mesajData.mesajMetni || "Yeni mesajınız var").substring(0, 100) },
            android: { priority: 'high', notification: { channelId: 'high_importance_channel', sound: 'default', priority: 'high', visibility: 'public', clickAction: 'FLUTTER_NOTIFICATION_CLICK' } },
            apns: { payload: { aps: { sound: 'default', badge: 1 } } },
            data: { type: 'chat', chatId: String(chatId), ilanId: String(ilanId), gonderenId: String(mesajData.gonderenId || ''), click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        });
    } catch (e) {
        console.error("Mesaj bildirim hatası:", e);
        return null;
    }
});

// 4. Fatura Tetikleyici
exports.onOfferInvoiceTrigger = onDocumentCreated('teklifler/{offerId}', async (event) => {
    const offerData = event.data.data();
    if (offerData.durum === 'onaylandi') console.log(`Fatura kesme süreci başlatıldı: ${event.params.offerId}`);
    return null;
});

// 5. Robot Otomatik Log Kayıt
exports.robotAutoLog = onDocumentCreated('users/{userId}', async (event) => {
    const userData = event.data.data();
    if (userData.role === 'usta') {
        await admin.firestore().collection('robot_logs').add({
            message: `Yeni Usta Kaydı: ${userData.firstName || 'İsimsiz'}`,
            status: "Tamamlandı",
            timestamp: admin.firestore.FieldValue.serverTimestamp()
        });
    }
});

// 6. Sosyal Medya İlan Paylaşım Fonksiyonu
exports.ilanYayimlanincaPaylas = onDocumentCreated('ilanlar/{ilanId}', async (event) => {
    const ilan = event.data.data();
    if (ilan.durum === 'onay_bekliyor') return null;
    try {
        const configDoc = await admin.firestore().collection("settings").doc("sosyal_medya_config").get();
        const token = configDoc.data()?.long_lived_token;
        if (!token) throw new Error("Token bulunamadı!");
        const caption = `UstamGelsin'de Yeni İş Fırsatı!\n\nİş Tanımı: ${ilan.baslik || 'Belirtilmemiş'}\nKategori: ${ilan.kategori || 'Belirtilmemiş'}\nBölge: ${ilan.konumMetni || 'Belirtilmemiş'}`;
        const upload = await axios.post(`https://graph.facebook.com/v20.0/${functions.config().ig.user_id}/media`, { image_url: "https://hemenustamgelsin.com/default-image.jpg", caption: caption, access_token: token });
        await axios.post(`https://graph.facebook.com/v20.0/${functions.config().ig.user_id}/media_publish`, { creation_id: upload.data.id, access_token: token });
    } catch (e) {
        console.error("❌ Paylaşım Hatası:", e.message);
    }
});

// 7. Destek Mesajları İçin Bildirim Tetikleyicisi
exports.sendSupportNotification = onDocumentCreated('admin_messages/{messageId}', async (event) => {
    try {
        const messageData = event.data.data();
        return await admin.messaging().send({ notification: { title: 'Yeni Destek Mesajı Geldi!', body: messageData.msg || 'Bir kullanıcıdan mesaj var.' }, topic: 'admin_notifications' });
    } catch (e) {
        console.error("Destek bildirimi hatası:", e);
    }
});

// 8. Usta İşi Kabul Edince Müşteriye Bildirim
exports.ustaIsiKabulEdinceMusteriyeBildir = onDocumentUpdated('acil_cagri/{cagriId}', async (event) => {
    const newData = event.data.after.data();
    const previousData = event.data.before.data();
    if (previousData.durum !== 'atandi' && newData.durum === 'atandi') {
        const customerId = newData.userId;
        const ustaAd = (newData.ustaAd && newData.ustaAd.length > 0) ? newData.ustaAd : "Ustanız";
        const ustaTel = newData.ustaTelefon || "bilinmiyor";
        try {
            const userDoc = await admin.firestore().collection('users').doc(customerId).get();
            if (!userDoc.exists || !userDoc.data().fcmToken) return null;
            const fcmToken = userDoc.data().fcmToken;
            const message = {
                token: fcmToken,
                notification: { title: 'İlanınız Kabul Edildi!', body: `İlanınız ${ustaAd} tarafından kabul edildi. Az sonra sizi ${ustaTel} numarasıyla arayacak.` },
                android: { priority: 'high', notification: { channelId: 'high_importance_channel', sound: 'default' } },
                data: { type: 'usta_kabul', cagriId: event.params.cagriId }
            };
            await admin.messaging().send(message);
        } catch (e) {
            console.error("❌ Müşteri bildirim hatası:", e);
        }
    }
    return null;
});

// 9. ADMİN MANUEL BAKİYE YÜKLEME
exports.adminBakiyeYukle = onCall({ region: "europe-west3" }, async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Giriş yapmalısın');
  if (request.auth.token.admin !== true) throw new HttpsError('permission-denied', 'Admin yetkin yok');
  const { hedefUid, amount, note } = request.data;
  if (!hedefUid || !amount || amount <= 0) throw new HttpsError('invalid-argument', 'hedefUid ve amount zorunlu');
  const db = admin.firestore();
  const walletRef = db.collection('wallets').doc(hedefUid);
  const transRef = walletRef.collection('transactions').doc();
  try {
    await db.runTransaction(async (transaction) => {
      const walletDoc = await transaction.get(walletRef);
      const currentBalance = walletDoc.exists ? (walletDoc.data().balance || 0) : 0;
      transaction.set(walletRef, { balance: currentBalance + amount, lastUpdated: admin.firestore.FieldValue.serverTimestamp() }, { merge: true });
      transaction.set(transRef, { amount: amount, type: 'deposit', description: note || 'Admin Manuel Yükleme', date: admin.firestore.FieldValue.serverTimestamp(), adminUid: request.auth.uid });
    });
    return { success: true, message: 'Bakiye yüklendi' };
  } catch (error) {
    throw new HttpsError('internal', 'Bakiye yüklenemedi');
  }
});

// 10. FİYAT HESAPLAMA MOTORU: GROQ LLAMA 3.1 8B
exports.hesaplaFiyat = onCall({
  region: "europe-west3",
  timeoutSeconds: 20,
  memory: "256MiB",
  enforceAppCheck: false,
  secrets: ["GROQ_API_KEY"]
}, async (request) => {
  console.log(">>> [GROQ] hesaplaFiyat ÇAĞRILDI Data:", request.data);
  const { isAdi, kategoriAdi, teknikDetaylar } = request.data || {};
  if (!isAdi || isAdi.trim().length < 2) {
    throw new HttpsError('invalid-argument', 'İş adı en az 2 karakter olmalı');
  }

  const GROQ_API_KEY = process.env.GROQ_API_KEY;
  if (!GROQ_API_KEY) {
    console.error(">>> GROQ_API_KEY tanımlı değil! firebase functions:secrets:set GROQ_API_KEY yap");
    throw new HttpsError('internal', 'Sunucu yapılandırma hatası');
  }

  const masterPrompt = `
Sen Hemen Ustam Gelsin Yapay Zekâ Maliyet Motorusun. Türkiye piyasası uzmanısın.
GÖREV: Tek bir tamsayı fiyat üret. Açıklama, sembol, TL, ₺, nokta, virgül YAZMA.
İş: ${isAdi}
Kategori: ${kategoriAdi}
Detaylar: ${teknikDetaylar}
Kural: 15 yıllık usta bu fiyata yapar mı? Gerçekçi ol. 2026 Türkiye fiyatları.
Sadece rakam: örnek 45000
`;

  try {
    const response = await axios.post("https://api.groq.com/openai/v1/chat/completions", {
      model: "llama-3.1-8b-instant",
      messages: [{ role: "user", content: masterPrompt }],
      temperature: 0.2,
      max_tokens: 10
    }, {
      headers: { "Authorization": `Bearer ${GROQ_API_KEY}`, "Content-Type": "application/json" },
      timeout: 15000
    });

    const rawText = response.data?.choices?.[0]?.message?.content?.trim() || "";
    console.log(">>> [GROQ] ham yanıt:", rawText);
    const fiyat = parseInt(rawText.replace(/[^0-9]/g, ""), 10);

    if (!isNaN(fiyat) && fiyat >= 1000 && fiyat <= 100000000) {
      console.log(`>>> [GROQ] BAŞARILI -> ${fiyat}`);
      return { success: true, fiyat: fiyat, kaynak: "groq_llama31_8b" };
    }
    throw new Error(`Geçersiz fiyat: ${rawText}`);

  } catch (e) {
    console.error(">>> [GROQ] HATA:", e.response?.data || e.message);
    throw new HttpsError('internal', 'Fiyat motoru şu an meşgul, lütfen tekrar deneyin.');
  }
});

// 11. HAFTALIK FIYAT GUNCELLEME ROBOTU - HER CUMARTESI 03:00
exports.haftalikFiyatGuncelle = onSchedule({
  schedule: "every saturday 03:00",
  timeZone: "Europe/Istanbul",
  region: "europe-west3",
  memory: "512MiB",
  timeoutSeconds: 540
}, async () => {
  console.log(">>> [CRON] Haftalik fiyat guncelleme basladi - Cumartesi 03:00");
  const db = admin.firestore();
  try {
    const snapshot = await db.collection("meslek_fiyat_tarifeleri").get();
    if (snapshot.empty) {
      console.log(">>> [CRON] meslek_fiyat_tarifeleri bos, islem yok");
      return null;
    }

    let guncellenen = 0;
    const batchSize = 400;
    let batch = db.batch();
    let count = 0;

    const birHaftaOnce = new Date();
    birHaftaOnce.setDate(birHaftaOnce.getDate() - 7);
    const birHaftaOnceTimestamp = admin.firestore.Timestamp.fromDate(birHaftaOnce);

    for (const doc of snapshot.docs) {
      const data = doc.data();
      const kategoriAnahtar = data.kategori || doc.id;

      const aiSnap = await db.collection("app_ai_data")
        .where("kategori", "==", kategoriAnahtar)
        .where("timestamp", ">", birHaftaOnceTimestamp)
        .get();

      if (!aiSnap.empty) {
        let toplamMin = 0;
        let toplamMax = 0;
        let adet = 0;

        aiSnap.forEach((d) => {
          const v = d.data();
          if (v.minimumButce && v.maksimumButce) {
            toplamMin += Number(v.minimumButce) || 0;
            toplamMax += Number(v.maksimumButce) || 0;
            adet++;
          } else if (v.muhtemelButce) {
            const tahminiMin = Number(v.muhtemelButce) * 0.85;
            const tahminiMax = Number(v.muhtemelButce) * 1.15;
            toplamMin += tahminiMin;
            toplamMax += tahminiMax;
            adet++;
          }
        });

        if (adet > 0) {
          const yeniMin = Math.round(toplamMin / adet);
          const yeniMax = Math.round(toplamMax / adet);
          const yeniMuhtemel = Math.round((yeniMin + yeniMax) / 2);

          batch.update(doc.ref, {
            minimumButce: yeniMin,
            maksimumButce: yeniMax,
            muhtemelButce: yeniMuhtemel,
            sonGuncelleme: admin.firestore.FieldValue.serverTimestamp(),
            guncellemeKaynagi: "haftalik_robot_cumartesi"
          });

          count++;
          guncellenen++;

          if (count >= batchSize) {
            await batch.commit();
            batch = db.batch();
            count = 0;
            console.log(`>>> [CRON] ${guncellenen} ara commit yapildi`);
          }
        }
      }
    }

    if (count > 0) {
      await batch.commit();
    }

    console.log(`>>> [CRON] BITTI - Toplam ${guncellenen} meslek guncellendi`);

    await db.collection("robot_logs").add({
      message: `Haftalik Fiyat Guncelleme Tamamlandi: ${guncellenen} meslek`,
      status: "Tamamlandı",
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      type: "haftalik_fiyat_guncelle"
    });

    return null;
  } catch (e) {
    console.error(">>> [CRON] HATA:", e);
    await db.collection("robot_logs").add({
      message: `Haftalik Fiyat Guncelleme HATASI: ${e.message}`,
      status: "Hata",
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      type: "haftalik_fiyat_guncelle"
    });
    return null;
  }
});