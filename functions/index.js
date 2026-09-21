const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");

admin.initializeApp();

// 0. KRİTİK SİSTEM ALARM
exports.adminKritikAlarm = onDocumentCreated({ document: 'system_alerts/{alertId}', region: 'europe-west3' }, async (event) => {
    try {
        const alertData = event.data.data();
        const message = {
            topic: 'admin_notifications',
            notification: { title: '⚠ KRİTİK SİSTEM ALARMI', body: alertData.message || 'Sistemde müdahale gerektiren bir durum var!' },
            android: { priority: 'high', notification: { channelId: 'high_importance_channel', sound: 'default', visibility: 'public' } },
        };
        return await admin.messaging().send(message);
    } catch (e) {
        console.error("Alarm hatası:", e);
    }
});

// 2. Acil Çağrı Bildirim - Ustalara
exports.acilUstaBildirimiGonder = onDocumentCreated({ document: 'acil_cagri/{cagriId}', region: 'europe-west3' }, async (event) => {
    const snapshot = event.data;
    if (!snapshot) return null;
    const cagriData = snapshot.data();
    const cagriId = event.params.cagriId;
    const rawKategori = (cagriData.kategoriId || cagriData.kategori || cagriData.acilDurumTipi || "").toString();
    const gelenKategori = rawKategori.toLowerCase().replace(/💧|🚨|🔧|⚡|🧹|❄|🏠/g, '').replace(/ı/g, 'i').replace(/ş/g, 's').replace(/ğ/g, 'g').replace(/ü/g, 'u').replace(/ö/g, 'o').replace(/ç/g, 'c').trim();
    const gelenIlceId = String(cagriData.ilceId || cagriData.ilce_id || "").trim();
    const gelenIlId = String(cagriData.ilId || cagriData.il_id || cagriData.sehir_id || "").trim();
    console.log(`🚨 ACIL GELDI id:${cagriId} il:${gelenIlId} ilce:${gelenIlceId} kat:${gelenKategori}`);
    try {
        const ustalarSnapshot = await admin.firestore().collection('users').where('role', '==', 'usta').get();
        const tokens = [];
        ustalarSnapshot.forEach(doc => {
            const ustaData = doc.data();
            if (!ustaData.fcmToken) return;
            const ustaIlce = String(ustaData.ilce_id || ustaData.ilceId || "").trim();
            const ustaIl = String(ustaData.sehir_id || ustaData.ilId || ustaData.il_id || "").trim();
            const ilceUyusuyor = !gelenIlceId || ustaIlce === "" || ustaIlce === gelenIlceId;
            const ilUyusuyor = !gelenIlId || ustaIl === "" || ustaIl === gelenIlId;
            if (!ilceUyusuyor && !ilUyusuyor) return;
            const ustaUzmanliklari = (ustaData.uzmanliklar || []).map(u => u.toString().toLowerCase().replace(/ı/g, 'i').replace(/ş/g, 's').replace(/ğ/g, 'g').replace(/ü/g, 'u').replace(/ö/g, 'o').replace(/ç/g, 'c').trim());
            let eslesiyor = ustaUzmanliklari.length === 0 || ustaUzmanliklari.some(u => u.includes(gelenKategori) || gelenKategori.includes(u) || (u.includes("tesisat") && gelenKategori.includes("tesisat")));
            if (eslesiyor) tokens.push(ustaData.fcmToken);
        });
        console.log(`SONUÇ: ${tokens.length} token bulundu`);
        if (tokens.length > 0) {
            const message = {
                tokens: tokens,
                notification: { title: '🚨 ACİL İŞ ÇAĞRISI!', body: cagriData.baslik || 'Bölgenizde yeni bir acil çağrı var.' },
                android: { priority: 'high', notification: { channelId: 'high_importance_channel', sound: 'default', visibility: 'public', clickAction: 'FLUTTER_NOTIFICATION_CLICK' } },
                data: { type: 'acil_cagri', ilanId: String(cagriId), actionType: 'odeme_ekrani', click_action: 'FLUTTER_NOTIFICATION_CLICK' }
            };
            const res = await admin.messaging().sendEachForMulticast(message);
            console.log(`GÖNDERİLDİ: ${res.successCount} başarılı, ${res.failureCount} fail`);
        }
        return null;
    } catch (e) {
        console.error("❌ Acil Hata:", e);
        return null;
    }
});

// 3. Yeni Mesaj Bildirim
exports.sendNotificationOnMessage = onDocumentCreated({ document: 'chats/{chatId}/mesajlar/{mesajId}', region: 'europe-west3' }, async (event) => {
    try {
        const chatId = event.params.chatId;
        const mesajData = event.data.data();
        if (!mesajData || !mesajData.gonderenId) return null;
        const chatRef = event.data.ref.parent.parent;
        const chatDoc = await chatRef.get();
        if (!chatDoc.exists) return null;
        const chatData = chatDoc.data();
        const katilimcilar = chatData.katilimcilar || [];
        const aliciId = katilimcilar.find(id => id !== mesajData.gonderenId);
        if (!aliciId) return null;
        const userDoc = await admin.firestore().collection('users').doc(aliciId).get();
        if (!userDoc.exists || !userDoc.data().fcmToken) return null;
        return await admin.messaging().send({
            token: userDoc.data().fcmToken,
            notification: { title: 'Yeni Mesajınız Var', body: (mesajData.mesajMetni || "Yeni mesajınız var").substring(0, 100) },
            android: { priority: 'high', notification: { channelId: 'high_importance_channel', clickAction: 'FLUTTER_NOTIFICATION_CLICK' } },
            data: { type: 'chat', chatId: String(chatId), click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        });
    } catch (e) {
        console.error("Mesaj bildirim hatası:", e);
        return null;
    }
});

exports.onOfferInvoiceTrigger = onDocumentCreated({ document: 'teklifler/{offerId}', region: 'europe-west3' }, async (event) => {
    const offerData = event.data.data();
    if (offerData.durum === 'onaylandi') console.log(`Fatura kesme süreci başlatıldı: ${event.params.offerId}`);
    return null;
});

exports.robotAutoLog = onDocumentCreated({ document: 'users/{userId}', region: 'europe-west3' }, async (event) => {
    const userData = event.data.data();
    if (userData.role === 'usta') {
        await admin.firestore().collection('robot_logs').add({
            message: `Yeni Usta Kaydı: ${userData.firstName || 'İsimsiz'}`,
            status: "Tamamlandı",
            timestamp: admin.firestore.FieldValue.serverTimestamp()
        });
    }
});

exports.ilanYayimlanincaPaylas = onDocumentCreated({ document: 'ilanlar/{ilanId}', region: 'europe-west3' }, async (event) => {
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

exports.sendSupportNotification = onDocumentCreated({ document: 'admin_messages/{messageId}', region: 'europe-west3' }, async (event) => {
    try {
        const messageData = event.data.data();
        return await admin.messaging().send({ notification: { title: 'Yeni Destek Mesajı Geldi!', body: messageData.msg || 'Bir kullanıcıdan mesaj var.' }, topic: 'admin_notifications' });
    } catch (e) {
        console.error("Destek bildirimi hatası:", e);
    }
});

// 8. USTA KABUL EDINCE MUSTERIYE BILDIRIM - TAM FIXLENDI
exports.ustaIsiKabulEdinceMusteriyeBildir = onDocumentUpdated({ document: 'acil_cagri/{cagriId}', region: 'europe-west3' }, async (event) => {
    const newData = event.data.after.data();
    const previousData = event.data.before.data();
    const cagriId = event.params.cagriId;
    console.log(`>>> [TETIKLENDI] ${cagriId} onceki:${previousData.durum} yeni:${newData.durum}`);
    if (previousData.durum === newData.durum) return null;
    if (newData.durum !== 'atandi') return null;

    // FIX: musteri ID artik teknikDetaylar icinde de araniyor
    const customerId = newData.userId || newData.teknikDetaylar?.userId || newData.musteriId || newData.musteri_id || newData.olusturanId || newData.createdBy || newData.ownerId;

    const ustaAd = newData.ustaAd || newData.ustaName || "Ustanız";
    const ustaTel = newData.ustaTelefon || newData.ustaTel || newData.ustaPhone || "bilinmiyor";

    if (!customerId) {
        console.error(`❌ MUSTERI ID BULUNAMADI cagriId:${cagriId} keys:`, Object.keys(newData));
        return null;
    }

    console.log(`>>> MUSTERI ID BULUNDU: ${customerId}`);

    try {
      const userDoc = await admin.firestore().collection('users').doc(customerId).get();
      if (!userDoc.exists) {
          console.error(`❌ USER DOC YOK: ${customerId}`);
          return null;
      }
      const userData = userDoc.data();
      const fcmToken = userData.fcmToken || userData.fcm_token || userData.token;
      console.log(`>>> USER ${customerId} token var mi: ${!!fcmToken}`);

      await admin.firestore().collection('bildirimler').add({
        aliciId: customerId, receiverId: customerId, ustaAd, ustaTelefon: ustaTel,
        baslik: 'İlanınız Kabul Edildi!',
        mesaj: `İlanınız ${ustaAd} tarafından kabul edildi. Az sonra sizi ${ustaTel} numarasıyla arayacak.`,
        tip: 'acil_kabul', type: 'acil_kabul', ilanId: cagriId,
        okundu: false, olusturulmaTarihi: admin.firestore.FieldValue.serverTimestamp()
      });
      console.log(`✅ bildirimler koleksiyonuna yazildi`);

      if (!fcmToken) {
          console.log(`>>> TOKEN YOK, PUSH ATLANIYOR AMA DB YAZILDI`);
          return null;
      }

      const message = {
        token: fcmToken,
        notification: { title: 'İlanınız Kabul Edildi!', body: `İlanınız ${ustaAd} tarafından kabul edildi. Az sonra sizi ${ustaTel} numarasıyla arayacak.` },
        android: { priority: 'high', notification: { channelId: 'high_importance_channel', clickAction: 'FLUTTER_NOTIFICATION_CLICK' } },
        data: { type: 'acil_kabul', cagriId: String(cagriId), click_action: 'FLUTTER_NOTIFICATION_CLICK' }
      };
      const res = await admin.messaging().send(message);
      console.log(`✅ MUSTERI BILDIRIMI GONDERILDI: ${res}`);
      return res;
    } catch (e) {
      console.error("❌ Musteri bildirim hatasi:", e);
      return null;
    }
});

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

// 10. FIYAT HESAPLAMA MOTORU: GROQ LLAMA 3.1 8B - FULL PROMPTLU
exports.hesaplaFiyat = onCall({
  region: "europe-west3",
  timeoutSeconds: 20,
  memory: "256MiB",
  enforceAppCheck: false,
  secrets: ["GROQ_API_KEY"]
}, async (request) => {
  console.log(">>> [GROQ] hesaplaFiyat ÇAĞRILDI Data:", request.data);
  const { isAdi, kategoriAdi, teknikDetaylar, ilId, ilceId, sehirIlce, kategoriId } = request.data || {};
  if (!isAdi || isAdi.trim().length < 2) {
    throw new HttpsError('invalid-argument', 'İş adı en az 2 karakter olmalı');
  }
  const GROQ_API_KEY = process.env.GROQ_API_KEY;
  if (!GROQ_API_KEY) {
    console.error(">>> GROQ_API_KEY tanımlı değil!");
    throw new HttpsError('internal', 'Sunucu yapılandırma hatası');
  }

  const detayString = typeof teknikDetaylar === 'string' ? teknikDetaylar : JSON.stringify(teknikDetaylar || {}, null, 2);

  const masterPrompt = `
Sen Türkiye'de inşaat, tadilat, elektrik, tesisat, kombi, klima ve tüm teknik hizmetlerin piyasa fiyatlarını bilen uzman bir maliyet analiz motorusun.
Adın: Hemen Ustam Gelsin Yapay Zeka Maliyet Motoru.

GÖREV:
Aşağıdaki işe göre Türkiye 2026 güncel piyasa koşullarına göre tek bir gerçekçi ortalama fiyat hesapla.

KATEGORİ ID: ${kategoriId || kategoriAdi || 'Belirtilmedi'}
KATEGORİ ADI: ${kategoriAdi || 'Belirtilmedi'}
İŞ ADI / BAŞLIK: ${isAdi}

TEKNİK DETAYLAR (TÜMÜNÜ DİKKATE AL):
${detayString}

KONUM BİLGİSİ:
İl ID: ${ilId || 'Belirtilmedi'}
İlçe ID: ${ilceId || 'Belirtilmedi'}
Bölge Metni: ${sehirIlce || 'Belirtilmedi'}

KURALLAR:
- Sadece Türkiye fiyatlarını kullan, USD/EUR kullanma.
- Açıklama, gerekçe, metin, aralık, TL işareti yazma.
- Sadece TEK bir tamsayı fiyat üret.
- Fiyat 1000 ile 100000000 arasında olmalı.
- Malzeme + işçilik dahil düşün, acil servis ise acil servis farkını ekle.
- Şehir büyükşehir ise %10 artır.
- Sadece rakam döndür, örnek: 65000
`;

  try {
    const response = await axios.post("https://api.groq.com/openai/v1/chat/completions", {
      model: "llama-3.1-8b-instant",
      messages: [
        { role: "system", content: "Sen bir fiyat tahmin uzmanısın. Sadece tek bir sayı döndür, açıklama yazma." },
        { role: "user", content: masterPrompt }
      ],
      temperature: 0.1,
      max_tokens: 50,
      stream: false
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

// 11. HAFTALIK FIYAT GUNCELLEME ROBOTU - GROQ'A BAGLI
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
      const aiSnap = await db.collection("app_ai_data").where("kategori", "==", kategoriAnahtar).where("timestamp", ">", birHaftaOnceTimestamp).get();
      if (!aiSnap.empty) {
        let toplamMin = 0; let toplamMax = 0; let adet = 0;
        aiSnap.forEach((d) => {
          const v = d.data();
          if (v.minimumButce && v.maksimumButce) {
            toplamMin += Number(v.minimumButce) || 0;
            toplamMax += Number(v.maksimumButce) || 0;
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
          count++; guncellenen++;
          if (count >= batchSize) {
            await batch.commit();
            batch = db.batch();
            count = 0;
          }
        }
      }
    }
    if (count > 0) await batch.commit();
    console.log(`>>> [CRON] BITTI - Toplam ${guncellenen} meslek guncellendi`);
    return null;
  } catch (e) {
    console.error(">>> [CRON] HATA:", e);
    return null;
  }
});