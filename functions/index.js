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

// 2. Acil Çağrı Bildirim Fonksiyonu - REVİZE EDİLDİ
exports.acilUstaBildirimiGonder = onDocumentCreated('acil_cagri/{cagriId}', async (event) => {
    const snapshot = event.data;
    if (!snapshot) return null;
    const cagriData = snapshot.data();
    const cagriId = event.params.cagriId;

    const rawKategori = (cagriData.kategoriId || cagriData.kategori || cagriData.acilDurumTipi || "").toString();
    const gelenKategori = rawKategori.toLowerCase()
       .replace(/💧|🚨|🔧|⚡|🧹|❄|🏠/g, '')
       .replace(/ı/g, 'i').replace(/ş/g, 's').replace(/ğ/g, 'g').replace(/ü/g, 'u').replace(/ö/g, 'o').replace(/ç/g, 'c')
       .trim();

    const gelenIlceId = String(cagriData.ilceId || cagriData.ilce_id || "").trim();
    const gelenIlId = String(cagriData.ilId || cagriData.il_id || cagriData.sehir_id || "").trim();

    console.log(`🚨 ACIL GELDI id:${cagriId} il:${gelenIlId} ilce:${gelenIlceId} kat:${gelenKategori}`);

    try {
        const ustalarSnapshot = await admin.firestore().collection('users').where('role', '==', 'usta').get();
        console.log(`Toplam usta sayısı: ${ustalarSnapshot.size}`);

        const tokens = [];
        ustalarSnapshot.forEach(doc => {
            const ustaData = doc.data();
            if (!ustaData.fcmToken) return;

            const ustaIlce = String(ustaData.ilce_id || ustaData.ilceId || "").trim();
            const ustaIl = String(ustaData.sehir_id || ustaData.ilId || ustaData.il_id || "").trim();

            const ilceUyusuyor =!gelenIlceId || ustaIlce === "" || ustaIlce === gelenIlceId;
            const ilUyusuyor =!gelenIlId || ustaIl === "" || ustaIl === gelenIlId;
            if (!ilceUyusuyor &&!ilUyusuyor) return;

            const ustaUzmanliklari = (ustaData.uzmanliklar || []).map(u => u.toString().toLowerCase()
               .replace(/ı/g, 'i').replace(/ş/g, 's').replace(/ğ/g, 'g').replace(/ü/g, 'u').replace(/ö/g, 'o').replace(/ç/g, 'c')
               .trim());

            let eslesiyor = false;
            if (ustaUzmanliklari.length === 0) {
                eslesiyor = true;
            } else {
                eslesiyor = ustaUzmanliklari.some(u => {
                    return u.includes(gelenKategori) || gelenKategori.includes(u) ||
                        (u.includes("tesisat") && gelenKategori.includes("tesisat")) ||
                        (u.includes("sihhi") && gelenKategori.includes("sihhi"));
                });
            }

            if (eslesiyor) {
                console.log(`EŞLEŞTİ usta:${doc.id} uzmanlik:${ustaUzmanliklari}`);
                tokens.push(ustaData.fcmToken);
            }
        });

        console.log(`SONUÇ: ${tokens.length} token bulundu`);

        if (tokens.length > 0) {
            const message = {
                tokens: tokens,
                notification: { title: '🚨 ACİL İŞ ÇAĞRISI!', body: cagriData.baslik || 'Bölgenizde yeni bir acil çağrı var.' },
                android: { priority: 'high', notification: { channelId: 'high_importance_channel', sound: 'default', visibility: 'public', clickAction: 'FLUTTER_NOTIFICATION_CLICK' } },
                data: { type: 'acil_cagri', ilanId: String(cagriId), actionType: 'odeme_ekrani', lat: String(cagriData.latitude || 0), lng: String(cagriData.longitude || 0) }
            };
            const res = await admin.messaging().sendEachForMulticast(message);
            console.log(`GÖNDERİLDİ: ${res.successCount} başarılı, ${res.failureCount} fail`);
            if (res.failureCount > 0) console.log(res.responses.filter(r =>!r.success).map(r => r.error?.message));
        }
        return null;
    } catch (e) {
        console.error("❌ Acil Hata:", e);
        return null;
    }
});

// 3. Yeni Mesaj Bildirim Fonksiyonu - REVİZE EDİLDİ
exports.sendNotificationOnMessage = onDocumentCreated('chats/{chatId}/mesajlar/{mesajId}', async (event) => {
    try {
        const chatId = event.params.chatId;
        const mesajId = event.params.mesajId;
        const mesajData = event.data.data();
        if (!mesajData ||!mesajData.gonderenId) {
            console.log("Mesaj data yok veya gonderenId yok");
            return null;
        }

        const chatRef = event.data.ref.parent.parent;
        const chatDoc = await chatRef.get();
        if (!chatDoc.exists) {
            console.log(`Chat dokümanı yok: ${chatId}`);
            return null;
        }
        const chatData = chatDoc.data();
        const katilimcilar = chatData.katilimcilar || [];
        const ilanId = chatData.ilanId || "";
        const aliciId = katilimcilar.find(id => id!== mesajData.gonderenId);

        if (!aliciId) {
            console.log("Alıcı bulunamadı, katilimcilar:", katilimcilar);
            return null;
        }

        console.log(`MESAJ GELDI chat:${chatId} mesaj:${mesajId} gonderen:${mesajData.gonderenId} alici:${aliciId}`);

        let fcmToken = null;
        let aliciName = "Yeni Mesaj";

        const userDoc = await admin.firestore().collection('users').doc(aliciId).get();
        if (userDoc.exists && userDoc.data().fcmToken) {
            fcmToken = userDoc.data().fcmToken;
            aliciName = userDoc.data().firstName || aliciName;
        } else {
            const ustaDoc = await admin.firestore().collection('ustalar').doc(aliciId).get();
            if (ustaDoc.exists && ustaDoc.data().fcmToken) {
                fcmToken = ustaDoc.data().fcmToken;
            }
        }

        if (!fcmToken) {
            console.log(`❌ TOKEN YOK Alıcı:${aliciId} - users ve ustalar koleksiyonunda token bulunamadı`);
            return null;
        }

        console.log(`✅ TOKEN BULUNDU, gönderiliyor alici:${aliciId}`);

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

// 8. Usta İşi Kabul Edince Müşteriye Bildirim - REVİZE EDİLDİ - SADECE BURASI DÜZELTİLDİ
exports.ustaIsiKabulEdinceMusteriyeBildir = onDocumentUpdated(
  {
    document: 'acil_cagri/{cagriId}',
    region: 'europe-west3',
  },
  async (event) => {
    const newData = event.data.after.data();
    const previousData = event.data.before.data();

    console.log(`🔄 ACIL GUNCELLEME id:${event.params.cagriId} eski_durum:${previousData.durum} yeni_durum:${newData.durum}`);

    const yeniDurum = (newData.durum || '').toLowerCase();
    const eskiDurum = (previousData.durum || '').toLowerCase();

    if (eskiDurum === yeniDurum) {
      console.log("Durum değişmedi, bildirim atılmıyor");
      return null;
    }

    if (yeniDurum !== 'atandi') {
      console.log(`Durum ${yeniDurum} atandi değil, atlandı`);
      return null;
    }

    // Senin SS'e göre userId alanı müşteri ID'si, garanti olsun diye tüm ihtimalleri deniyoruz
    const customerId = newData.userId || newData.musteriId || newData.musteri_id || newData.olusturanId;
    const ustaAd = (newData.ustaAd && newData.ustaAd.length > 0) ? newData.ustaAd : "Ustanız";
    const ustaTel = newData.ustaTelefon || newData.ustaTel || "bilinmiyor";

    console.log(`Müşteri ID: ${customerId} Usta: ${ustaAd} Tel: ${ustaTel}`);

    if (!customerId) {
      console.log("❌ Müşteri ID bulunamadı");
      return null;
    }

    try {
      const userDoc = await admin.firestore().collection('users').doc(customerId).get();
      if (!userDoc.exists) {
        console.log(`❌ users/${customerId} dokümanı yok`);
        return null;
      }

      const userData = userDoc.data();
      const fcmToken = userData.fcmToken || userData.fcm_token;

      if (!fcmToken) {
        console.log(`❌ TOKEN YOK müşteri:${customerId} - fcmToken alanı boş`);
        return null;
      }

      console.log(`✅ TOKEN BULUNDU müşteriye bildirim gönderiliyor alici:${customerId}`);

      const message = {
        token: fcmToken,
        notification: { title: 'İlanınız Kabul Edildi!', body: `İlanınız ${ustaAd} tarafından kabul edildi. Az sonra sizi ${ustaTel} numarasıyla arayacak.` },
        android: { priority: 'high', notification: { channelId: 'high_importance_channel', sound: 'default', visibility: 'public', clickAction: 'FLUTTER_NOTIFICATION_CLICK' } },
        apns: { payload: { aps: { sound: 'default', badge: 1 } } },
        data: { type: 'usta_kabul', cagriId: event.params.cagriId, ilanId: event.params.cagriId, click_action: 'FLUTTER_NOTIFICATION_CLICK' }
      };

      const res = await admin.messaging().send(message);
      console.log(`✅ MÜŞTERİ BİLDİRİMİ GÖNDERİLDİ: ${res}`);
      return res;
    } catch (e) {
      console.error("❌ Müşteri bildirim hatası:", e);
      return null;
    }
  }
);

// 9. ADMİN MANUEL BAKİYE YÜKLEME
exports.adminBakiyeYukle = onCall({ region: "europe-west3" }, async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Giriş yapmalısın');
  if (request.auth.token.admin!== true) throw new HttpsError('permission-denied', 'Admin yetkin yok');
  const { hedefUid, amount, note } = request.data;
  if (!hedefUid ||!amount || amount <= 0) throw new HttpsError('invalid-argument', 'hedefUid ve amount zorunlu');
  const db = admin.firestore();
  const walletRef = db.collection('wallets').doc(hedefUid);
  const transRef = walletRef.collection('transactions').doc();
  try {
    await db.runTransaction(async (transaction) => {
      const walletDoc = await transaction.get(walletRef);
      const currentBalance = walletDoc.exists? (walletDoc.data().balance || 0) : 0;
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
Sen artık Hemen Ustam Gelsin Yapay Zekâ Maliyet Motoru olarak görev yapıyorsun.
Amacın, Türkiye'de hizmet almak isteyen müşterilere gerçek piyasa koşullarına uygun tek bir yaklaşık toplam maliyet üretmektir.
Sen profesyonel bir inşaat maliyet uzmanı gibi düşünürsün.
Verilen bilgilerden;
işin kapsamını,
işçilik ihtiyacını,
malzeme ihtiyacını,
ekipman gereksinimini,
nakliye maliyetini,
saha zorluğunu,
iş süresini,
riskleri
analiz ederek tek bir toplam maliyet hesaplamalısın.
GÖREVİN
Kullanıcı sana yalnızca şu bilgileri gönderir:
İş Adı
Kategori
Teknik Detaylar
Bu bilgilerden yola çıkarak tek bir toplam fiyat hesaplayacaksın.
Bu fiyat;
Türkiye'de aynı işe teklif verecek deneyimli ustaların büyük çoğunluğunun vereceği yaklaşık teklif fiyatını temsil etmelidir.
ZORUNLU ARAŞTIRMA KURALI
İnternet erişimin varsa;
cevap üretmeden önce güncel Türkiye piyasasını değerlendir.
Fiyat uydurma.
Türkiye'deki güncel ekonomik şartları dikkate al.
İnternet erişimin yoksa;
elindeki güncel bilgiye göre en gerçekçi fiyatı üret.
KULLANILACAK VERİLER
Maliyet hesabında gerektiğinde aşağıdaki unsurları dikkate al.
Malzeme fiyatları
İşçilik ücretleri
Nakliye
Yakıt
Ekip maliyeti
Araç giderleri
Bölgesel işçilik farkları
Fire oranı
Zor çalışma koşulları
İskele
Vinç
Moloz
Kat farkı
Risk
Sezon etkisi
Güncel ekonomik koşullar
REFERANS KAYNAKLAR
Öncelikli olarak Türkiye kaynaklarını esas al.
Örneğin;
Koçtaş
Bauhaus
Türkiye yapı marketleri
Bölgesel yapı malzemesi satıcıları
Armut
UstasıBurada
SGK işçilik verileri
TÜİK
Çevre Şehircilik ve İklim Değişikliği Bakanlığı
Türkiye Müteahhitler Birliği
Türkiye dışındaki fiyatları referans alma.
MALİYET FELSEFESİ
Amaç en ucuz fiyatı vermek değildir.
Amaç en pahalı fiyatı vermek değildir.
Amaç;
Türkiye'deki gerçek piyasa tekliflerine mümkün olduğunca yakın tek bir maliyet üretmektir.
Ürettiğin fiyat;
müşteriye mantıklı,
ustaya uygulanabilir,
piyasa şartlarına uygun olmalıdır.
USTA VİCDAN TESTİ
Fiyatı oluşturmadan önce kendine şu soruyu sor:
"15 yıllık profesyonel bir usta olsaydım bu işi bu fiyata gerçekten yapar mıydım?"
Eğer cevap hayır ise fiyatı yeniden değerlendir.
BÖLGESEL FİYAT UYGULAMA KURALI - KRİTİK
Teknik Detaylar içinde BOLGE bilgisini MUTLAKA uygula:
- BOLGE: 34, 06, 35, 07, 16, 41, 34/ISTANBUL, 06/ANKARA, 35/IZMIR, 07/ANTALYA ise fiyatı %25-30 artır
- BOLGE bilgisi büyükşehir ise bölgesel işçilik ve nakliye farkını hesaba kat
- Anadolu / diğer iller için baz Türkiye fiyatını ver
ÇIKTI KURALLARI (EN KRİTİK KISIM)
Bu kurallar kesinlikle ihlal edilemez.
Sadece tek bir tamsayı üret.
Açıklama yazma.
Gerekçe yazma.
Liste yazma.
Markdown kullanma.
JSON üretme.
Kod üretme.
Nokta kullanma.
Virgül kullanma.
TL yazma.
₺ yazma.
Yaklaşık kelimesini yazma.
En düşük, en yüksek veya fiyat aralığı üretme.
Minimum, Muhtemel veya Maksimum fiyat üretme.
Birden fazla sayı üretme.
DOĞRU ÇIKTI ÖRNEKLERİ
45000
8750
162500
YANLIŞ ÇIKTI ÖRNEKLERİ
45.000 TL
Yaklaşık 45000 TL
40000 - 50000
Minimum: 40000
45000 ₺
{"price":45000}
Bu iş yaklaşık 45000 TL tutar.
SON KURAL
Üreteceğin cevap yalnızca tek bir tamsayı olmalıdır.
Cevabında tek sayı dışında hiçbir karakter bulunmamalıdır.
KULLANICI VERİLERİ:
İş: ${isAdi}
Kategori: ${kategoriAdi}
Teknik Detaylar: ${teknikDetaylar}
`;
  try {
    const response = await axios.post("https://api.groq.com/openai/v1/chat/completions", {
      model: "llama-3.1-8b-instant",
      messages: [{ role: "user", content: masterPrompt }],
      temperature: 0.2,
      max_tokens: 20
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
    if (count > 0) await batch.commit();
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