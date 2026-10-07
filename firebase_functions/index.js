const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { defineSecret } = require("firebase-functions/params");
const nodemailer = require("nodemailer");

admin.initializeApp();

// ===================== YENI EKLENEN - TOPLU MESAJ BROADCAST (FRANKFURT EURO 3) =====================
exports.sendBroadcastNotification = onDocumentCreated({ document: 'config/broadcasts/queue/{docId}', region: 'europe-west3' }, async (event) => {
  const data = event.data?.data();
  if (!data) return null;
  const title = data.title || "Hemen Ustam Gelsin";
  const body = data.message || "";
  const docId = event.params.docId;
  const db = admin.firestore();
  try {
    const usersSnap = await db.collection("users").get();
    const tokens = [];
    usersSnap.forEach((doc) => {
      const d = doc.data();
      const t = d.fcmToken || d.fcm_token || d.token;
      if (!t) return;
      if (Array.isArray(t)) tokens.push(...t);
      else tokens.push(t);
    });

    if (tokens.length === 0) {
      console.log("Broadcast: Token yok");
      await event.data.ref.update({ status: "no_tokens", checkedAt: admin.firestore.FieldValue.serverTimestamp() });
      return null;
    }

    const messaging = admin.messaging();
    let totalSuccess = 0;
    // FCM max 500
    for (let i = 0; i < tokens.length; i += 500) {
      const batch = tokens.slice(i, i + 500);
      const resp = await messaging.sendEachForMulticast({
        tokens: batch,
        notification: { title: title, body: body },
        android: { priority: 'high', notification: { channelId: 'high_importance_channel', clickAction: 'FLUTTER_NOTIFICATION_CLICK' } },
        data: { type: "broadcast", broadcastId: String(docId), click_action: 'FLUTTER_NOTIFICATION_CLICK' }
      });
      totalSuccess += resp.successCount;
      console.log(`Broadcast part ${i/500 + 1}: ${resp.successCount} success, ${resp.failureCount} fail`);
    }

    await event.data.ref.update({ status: "sent", sentAt: admin.firestore.FieldValue.serverTimestamp(), sentCount: totalSuccess });
    await db.collection("admin_messages").add({
      type: "broadcast_success",
      broadcastId: docId,
      title: title,
      message: body,
      sentCount: totalSuccess,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`✅ Broadcast tamamlandi: ${totalSuccess} kisiye - ${docId}`);
    return null;
  } catch (e) {
    console.error("❌ Broadcast hatasi:", e);
    try {
      await event.data.ref.update({ status: "failed", error: e.toString(), failedAt: admin.firestore.FieldValue.serverTimestamp() });
    } catch (_) {}
    return null;
  }
});
// ===================== TOPLU MESAJ BITIS =====================

// ===================== ÖZEL GÜNLER - OTOMATİK TOPLU MESAJ (FRANKFURT - DİNAMİK YILLI) =====================
const OZEL_GUNLER = [
  { gun: 1, ay: 1, type: "yilbasi" },
  { gun: 23, ay: 4, type: "23nisan" },
  { gun: 19, ay: 5, type: "19mayis" },
  { gun: 30, ay: 8, type: "30agustos" },
  { gun: 29, ay: 10, type: "29ekim" },
  { gun: 10, ay: 11, type: "10kasim" },
];

function getOzelGunMesaji(type, yil) {
  const cumhuriyetYili = yil - 1923;
  const zaferYili = yil - 1922;
  switch(type) {
    case "yilbasi":
      return { baslik: `🎉 ${yil} Yılınız Kutlu Olsun!`, mesaj: `Hemen Ustam Gelsin ailesi olarak ${yil} yılının size ve sevdiklerinize sağlık, mutluluk ve bol kazanç getirmesini dileriz!` };
    case "23nisan":
      return { baslik: "🇹🇷 23 Nisan Ulusal Egemenlik ve Çocuk Bayramı Kutlu Olsun!", mesaj: `Gazi Mustafa Kemal Atatürk'ün tüm dünya çocuklarına armağanı 23 Nisan Ulusal Egemenlik ve Çocuk Bayramımız kutlu olsun!` };
    case "19mayis":
      return { baslik: "🇹🇷 19 Mayıs Atatürk'ü Anma, Gençlik ve Spor Bayramı Kutlu Olsun!", mesaj: "19 Mayıs Atatürk'ü Anma, Gençlik ve Spor Bayramımız kutlu olsun! Gençlerimizin ve milletimizin bayramı kutlu olsun." };
    case "30agustos":
      return { baslik: "🇹🇷 30 Ağustos Zafer Bayramımız Kutlu Olsun!", mesaj: `30 Ağustos Zafer Bayramımızın ${zaferYili}. yılı kutlu olsun! Başta Gazi Mustafa Kemal Atatürk olmak üzere tüm kahramanlarımızı saygıyla anıyoruz.` };
    case "29ekim":
      return { baslik: "🇹🇷 29 Ekim Cumhuriyet Bayramımız Kutlu Olsun!", mesaj: `Cumhuriyetimizin ${cumhuriyetYili}. yılı kutlu olsun! Hemen Ustam Gelsin ailesi olarak Cumhuriyet coşkusunu hep birlikte yaşıyoruz! Yaşasın Cumhuriyet!` };
    case "10kasim":
      return { baslik: "♾ Saygı ve Özlemle Anıyoruz", mesaj: `Cumhuriyetimizin kurucusu Gazi Mustafa Kemal Atatürk'ü ebediyete intikalinin ${yil - 1938}. yılında saygı, sevgi ve özlemle anıyoruz. Saat 09:05` };
    default:
      return { baslik: "Hemen Ustam Gelsin", mesaj: "" };
  }
}

exports.ozelGunKontrol = onSchedule({
  schedule: "every day 09:05",
  timeZone: "Europe/Istanbul",
  region: "europe-west3",
  memory: "256MiB",
  timeoutSeconds: 300
}, async () => {
  const now = new Date();
  const trDate = new Date(now.toLocaleString("en-US", { timeZone: "Europe/Istanbul" }));
  const gun = trDate.getDate();
  const ay = trDate.getMonth() + 1;
  const yil = trDate.getFullYear();

  const bugunConfig = OZEL_GUNLER.find(o => o.gun === gun && o.ay === ay);
  if (!bugunConfig) {
    console.log(`[OZEL-GUN] Bugun ozel gun yok: ${gun}/${ay}/${yil}`);
    return null;
  }

  const bugun = getOzelGunMesaji(bugunConfig.type, yil);
  console.log(`[OZEL-GUN] TETIKLENDI: ${gun}/${ay}/${yil} - ${bugun.baslik}`);

  const db = admin.firestore();
  try {
    // Ayni gun 2 kere gondermesin
    const logId = `${ay}-${gun}-${yil}`;
    const logRef = db.collection("config").doc("broadcasts").collection("ozelGunLogs").doc(logId);
    const logDoc = await logRef.get();
    if (logDoc.exists) {
      console.log(`[OZEL-GUN] Zaten gonderilmis: ${logId}, atlaniyor`);
      return null;
    }

    const usersSnap = await db.collection("users").get();
    const tokens = [];
    usersSnap.forEach((doc) => {
      const d = doc.data();
      const t = d.fcmToken || d.fcm_token || d.token;
      if (!t) return;
      if (Array.isArray(t)) tokens.push(...t);
      else tokens.push(t);
    });

    if (tokens.length === 0) return null;

    const messaging = admin.messaging();
    for (let i = 0; i < tokens.length; i += 500) {
      const batch = tokens.slice(i, i + 500);
      await messaging.sendEachForMulticast({
        tokens: batch,
        notification: { title: bugun.baslik, body: bugun.mesaj },
        android: { priority: 'high', notification: { channelId: 'high_importance_channel', clickAction: 'FLUTTER_NOTIFICATION_CLICK' } },
        data: { type: "ozel_gun", gun: String(gun), ay: String(ay), click_action: 'FLUTTER_NOTIFICATION_CLICK' }
      });
    }

    await logRef.set({
      baslik: bugun.baslik,
      mesaj: bugun.mesaj,
      gonderimTarihi: admin.firestore.FieldValue.serverTimestamp(),
      gonderilenKisi: tokens.length,
      gun, ay, yil
    }, { merge: true });

    console.log(`✅ OZEL GUN GONDERILDI: ${bugun.baslik} - ${tokens.length} kisiye - ${yil}`);
    return null;
  } catch (e) {
    console.error("❌ Ozel gun hatasi:", e);
    return null;
  }
});
// ===================== ÖZEL GÜNLER BİTİŞ =====================



// ===================== FİNANS ÖZET - V4 KESİN ÇÖZÜM (onRequest - PUBLIC) =====================
const { onRequest } = require("firebase-functions/v2/https");

exports.finansOzet = onRequest({
  region: "europe-west3",
  memory: "512MiB",
  timeoutSeconds: 60,
  cors: true,
  invoker: "public",
}, async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  const startTime = Date.now();
  const db = admin.firestore();
  const now = new Date();
  const trNow = new Date(now.toLocaleString("en-US", { timeZone: "Europe/Istanbul" }));
  const yil = trNow.getFullYear();
  const ay = trNow.getMonth() + 1;

  const yearStart = new Date(yil, 0, 1);
  const todayStart = new Date(yil, trNow.getMonth(), trNow.getDate(), 0,0,0);
  const todayEnd = new Date(yil, trNow.getMonth(), trNow.getDate(), 23,59,59,999);

  const monday = new Date(trNow);
  monday.setDate(trNow.getDate() - (trNow.getDay() === 0 ? 6 : trNow.getDay() - 1));
  monday.setHours(0,0,0,0);
  const sunday = new Date(monday); sunday.setDate(monday.getDate()+6); sunday.setHours(23,59,59,999);

  const monthStart = new Date(yil, trNow.getMonth(), 1);
  const monthEnd = new Date(yil, trNow.getMonth()+1, 0, 23,59,59,999);

  try {
    // Index gerektirmeyen versiyon - tüm transactions çekip JS'de filtrele
    const snapAll = await db.collectionGroup('transactions').get();
    const filteredDocs = snapAll.docs.filter(d => {
      const data = d.data();
      if (!data.date) return false;
      try { return data.date.toDate() >= yearStart; } catch(e){ return false; }
    });
    // filteredDocs'u snap gibi kullanacağız
    const snap = { size: filteredDocs.length, forEach: (cb) => filteredDocs.forEach(cb), docs: filteredDocs };


    let gunlukK=0, gunlukC=0, haftalikK=0, haftalikC=0, aylikK=0, aylikC=0, yillikK=0, yillikC=0;
    const haftalikDetay = [];
    for(let i=0;i<7;i++){ const d=new Date(monday); d.setDate(monday.getDate()+i); haftalikDetay.push({ gunAdi: ["Pazartesi","Salı","Çarşamba","Perşembe","Cuma","Cumartesi","Pazar"][i], tarih: `${d.getDate()}/${d.getMonth()+1}`, k:0, c:0, date: d }); }
    const yillikDetay = [];
    const ayAdlari = ["Ocak","Şubat","Mart","Nisan","Mayıs","Haziran","Temmuz","Ağustos","Eylül","Ekim","Kasım","Aralık"];
    for(let i=0;i<12;i++){ yillikDetay.push({ ayAdi: ayAdlari[i], k:0, c:0, islem:0 }); }

    snap.forEach(doc => {
      const data = doc.data();
      const amount = Number(data.amount || 0);
      const type = data.type;
      const ts = data.date;
      if (!ts) return;
      const d = ts.toDate();

      if (d >= yearStart) {
        if (type === 'withdrawal') yillikK += amount; else if (type === 'deposit') yillikC += amount;
        yillikDetay[d.getMonth()].islem++;
        if (type === 'withdrawal') yillikDetay[d.getMonth()].k += amount; else yillikDetay[d.getMonth()].c += amount;
      }
      if (d >= monthStart && d <= monthEnd) {
        if (type === 'withdrawal') aylikK += amount; else aylikC += amount;
      }
      if (d >= monday && d <= sunday) {
        if (type === 'withdrawal') haftalikK += amount; else haftalikC += amount;
        const dayIdx = d.getDay() === 0 ? 6 : d.getDay() - 1;
        if (dayIdx >=0 && dayIdx <7) {
          if (type === 'withdrawal') haftalikDetay[dayIdx].k += amount; else haftalikDetay[dayIdx].c += amount;
        }
      }
      if (d >= todayStart && d <= todayEnd) {
        if (type === 'withdrawal') gunlukK += amount; else gunlukC += amount;
      }
    });

    const sureMs = Date.now() - startTime;
    res.status(200).json({
      gunluk: { k: gunlukK, c: gunlukC },
      haftalik: { k: haftalikK, c: haftalikC },
      aylik: { k: aylikK, c: aylikC },
      yillik: { k: yillikK, c: yillikC },
      haftalikDetay: haftalikDetay.map(x=>({ gunAdi: x.gunAdi, tarih: x.tarih, k: x.k, c: x.c })),
      yillikDetay,
      meta: {
        yil, ay, ayAdi: ayAdlari[ay-1],
        bugunStr: `${trNow.getDate().toString().padStart(2,'0')}/${(trNow.getMonth()+1).toString().padStart(2,'0')}/${yil}`,
        haftaStr: `${monday.getDate()}/${monday.getMonth()+1} - ${sunday.getDate()}/${sunday.getMonth()+1}`,
        ayStr: `1 - ${monthEnd.getDate()} ${ayAdlari[ay-1]}`,
        toplamIslem: snap.size,
        okunanDokuman: snap.size,
        maliyet: `${(snap.size * 0.00006).toFixed(4)} $`,
        sureMs
      }
    });
  } catch (e) {
    console.error("finansOzet hatasi", e);
    res.status(500).json({ error: e.toString() });
  }
});
// ===================== FİNANS ÖZET V4 BİTİŞ =====================







// ===================== YENİ EKLENEN - B2B BİLDİRİM =====================
exports.onB2BLeadCreated = onDocumentCreated({ document: 'corporate_leads/{leadId}', region: 'europe-west3' }, async (event) => {
    try {
        const data = event.data.data();
        const leadId = event.params.leadId;
        if (!data) return null;

        const firma = data.firma || 'Bilinmeyen Firma';
        const yetkili = data.yetkili || '';
        const kategoriler = (data.kategoriler || []).join(', ');
        const isBirlikleri = (data.isBirlikleri || []).join(', ');

        const title = `Yeni B2B Başvurusu: ${firma}`;
        const body = `${kategoriler} • ${isBirlikleri} • ${yetkili}`.substring(0, 150);

        const message = {
            topic: 'b2b_admin',
            notification: { title, body },
            data: {
                leadId: String(leadId),
                firma: String(firma),
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            android: {
                priority: 'high',
                notification: { channelId: 'b2b_leads_channel', priority: 'high', visibility: 'public' },
            },
            apns: {
                payload: { aps: { sound: 'default', badge: 1 } },
            },
        };

        await admin.messaging().send(message);
        console.log(`✅ B2B bildirim gönderildi: ${leadId} - ${firma}`);

        await admin.firestore().collection('admin_notifications').add({
            type: 'b2b_lead',
            leadId,
            firma,
            yetkili,
            kategoriler: data.kategoriler || [],
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            read: false,
        });

        return null;
    } catch (e) {
        console.error("❌ B2B bildirim hatası:", e);
        return null;
    }
});
// ===================== B2B BİTİŞ =====================

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

exports.ustaIsiKabulEdinceMusteriyeBildir = onDocumentUpdated({ document: 'acil_cagri/{cagriId}', region: 'europe-west3' }, async (event) => {
    const newData = event.data.after.data();
    const previousData = event.data.before.data();
    const cagriId = event.params.cagriId;
    console.log(`>>> [TETIKLENDI] ${cagriId} onceki:${previousData.durum} yeni:${newData.durum}`);
    if (previousData.durum === newData.durum) return null;
    if (newData.durum !== 'atandi') return null;
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

// ===================== YENI EKLENEN - KATEGORI MUNHASIR TEKLIF MAIL (PRODUCTION SECURE V3 - FINAL) =====================
const smtpPass = defineSecret("SMTP_APP_PASSWORD");

const escapeHtml = (value) =>
  String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");

const sanitizeEmail = (email) => {
  const trimmed = String(email || "").trim();
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!regex.test(trimmed)) throw new HttpsError("invalid-argument", "Gecersiz e-posta formati");
  if (trimmed.length > 254) throw new HttpsError("invalid-argument", "E-posta cok uzun");
  return trimmed;
};

const TIER_PRICING = {
  "TIER A": { p3: 300000, p6: 550000, p12: 950000 },
  "TIER A • Premium": { p3: 300000, p6: 550000, p12: 950000 },
  "TIER B": { p3: 250000, p6: 450000, p12: 800000 },
  "TIER B • Güçlü": { p3: 250000, p6: 450000, p12: 800000 },
  "TIER C": { p3: 200000, p6: 375000, p12: 675000 },
  "TIER C • Orta": { p3: 200000, p6: 375000, p12: 675000 },
  "TIER D": { p3: 150000, p6: 275000, p12: 500000 },
  "TIER D • Niş": { p3: 150000, p6: 275000, p12: 500000 },
};

function getTamFiyat(tierLabel, sureAy) {
  const pricing = TIER_PRICING[tierLabel];
  if (!pricing) {
    throw new HttpsError("invalid-argument", `Gecersiz tier: ${tierLabel}. Izin verilen tier'lar: TIER A/B/C/D ve tanımlı label'lar`);
  }
  if (sureAy === 3) return pricing.p3;
  if (sureAy === 6) return pricing.p6;
  if (sureAy === 12) return pricing.p12;
  throw new HttpsError("invalid-argument", "Sure sadece 3, 6 veya 12 olabilir");
}

exports.sendTeklifMail = onCall(
  { region: "europe-west3", secrets: [smtpPass] },
  async (request) => {
    if (!request.auth || request.auth.token.admin !== true) {
      throw new HttpsError("permission-denied", "Bu islem icin admin yetkisi gerekli");
    }

    const { firma, yetkili, email, kategori, altAlanlar, puan, sureAy, tier } = request.data;

    if (!firma || typeof firma !== "string" || firma.trim().length < 2 || firma.trim().length > 200) {
      throw new HttpsError("invalid-argument", "Firma unvani gecersiz (2-200 karakter)");
    }
    if (yetkili && (typeof yetkili !== "string" || yetkili.length > 150)) {
      throw new HttpsError("invalid-argument", "Yetkili ismi cok uzun");
    }
    if (!kategori || typeof kategori !== "string" || kategori.length > 100) {
      throw new HttpsError("invalid-argument", "Kategori gecersiz");
    }
    if (!Array.isArray(altAlanlar) || altAlanlar.length === 0 || altAlanlar.length > 20) {
      throw new HttpsError("invalid-argument", "Alt alanlar gecersiz");
    }

    const numPuan = Number(puan);
    if (!Number.isFinite(numPuan) || numPuan < 1 || numPuan > 100) {
      throw new HttpsError("invalid-argument", "Puan 1-100 arasinda olmali");
    }

    const numSureAy = Number(sureAy);
    if (![3, 6, 12].includes(numSureAy)) {
      throw new HttpsError("invalid-argument", "Sure sadece 3, 6 veya 12 olabilir");
    }

    if (!tier || typeof tier !== "string" || tier.length > 50) {
      throw new HttpsError("invalid-argument", "Tier gecersiz");
    }

    const safeEmailTo = sanitizeEmail(email);
    const safeFirma = escapeHtml(firma.trim());
    const safeYetkili = escapeHtml((yetkili || "").trim());
    const safeKategori = escapeHtml(kategori.trim());
    const safeTier = escapeHtml(tier.trim());
    const safeAltAlanlar = altAlanlar.map((a) => escapeHtml(String(a).trim())).filter((a) => a.length > 0 && a.length < 100);

    if (safeAltAlanlar.length === 0) {
      throw new HttpsError("invalid-argument", "Alt alan listesi bos");
    }

    const tamFiyatServer = getTamFiyat(tier, numSureAy);
    const finalFiyat = Math.round((tamFiyatServer * numPuan) / 100);

    const transporter = nodemailer.createTransport({
      host: "smtp.gmail.com",
      port: 465,
      secure: true,
      auth: {
        user: "info@hemenustamgelsin.com",
        pass: smtpPass.value(),
      },
    });

    const html = `
    <div style="font-family:Poppins,Arial,sans-serif; max-width:600px; margin:0 auto; background:#fff; border-radius:16px; overflow:hidden; border:1px solid #eee;">
      <div style="background:#000; color:#fff; padding:20px; display:flex; justify-content:space-between; align-items:center;">
        <div>
          <h2 style="margin:0; font-size:18px;">HEMEN USTAM GELSİN</h2>
          <p style="margin:4px 0 0; font-size:12px; color:#aaa;">©HUG Market • Kategori Münhasır Çözüm Ortaklığı</p>
        </div>
        <div style="text-align:right; font-size:10px; color:#aaa;">
          Sağlık Mh. Kurudere Cad. No:76/9 Salihli-MANİSA<br/>
          0532 163 59 66 • info@hemenustamgelsin.com<br/>
          D-U-N-S®: 751176741
        </div>
      </div>
      <div style="padding:24px;">
        <h3 style="margin:0 0 8px;">Merhaba ${safeYetkili || safeFirma},</h3>
        <p style="color:#555; font-size:13px;">${safeKategori} kategorisinde talebiniz için özel çözüm ortaklığı teklifimiz aşağıdadır.</p>

        <div style="background:#f8f8f7; border-radius:12px; padding:16px; margin:16px 0;">
          <table style="width:100%; font-size:13px; border-collapse:collapse;">
            <tr><td style="color:#888; padding:6px 0;">Kategori</td><td style="font-weight:700; text-align:right;">${safeKategori}</td></tr>
            <tr><td style="color:#888; padding:6px 0;">Tier</td><td style="font-weight:600; text-align:right;">${safeTier}</td></tr>
            <tr><td style="color:#888; padding:6px 0;">Kapsam</td><td style="text-align:right;">%${numPuan} • ${safeAltAlanlar.join(", ")}</td></tr>
            <tr><td style="color:#888; padding:6px 0;">Süre</td><td style="font-weight:600; text-align:right;">${numSureAy} Ay • 81 İl</td></tr>
            <tr style="border-top:1px solid #ddd;"><td style="padding:12px 0; font-weight:800;">Teklif Bedeli</td><td style="font-weight:900; font-size:18px; text-align:right;">${finalFiyat} TL</td></tr>
          </table>
          <p style="font-size:10px; color:#999; margin:8px 0 0;">Formül: ${numPuan}/100 x ${tamFiyatServer} = ${finalFiyat} • Aylık: ${Math.round(finalFiyat / numSureAy)} TL • Hesaplama sunucu tarafında doğrulandı</p>
        </div>

        <p style="font-size:11px; color:#888;">Dış açıklama metni: Çözüm ortaklığı bedeli; seçilen kategori/ürün alanları, münhasırlık kapsamı, süre ve entegrasyon kapsamına göre belirlenir.</p>

        <div style="margin:20px 0; padding:12px; background:#fff; border:1px solid #eee; border-radius:8px; font-size:11px; color:#666;">
          <strong>Ödeme:</strong> TR79 0086 4011 0000 8503 0670 04 • Eren EROĞLU<br/>
          <strong>Geçerlilik:</strong> 15 gün • ©HUG Market • © Hemen Ustam Gelsin
        </div>

        <a href="https://hemenustamgelsin.com" style="display:inline-block; background:#000; color:#fff; padding:12px 20px; border-radius:10px; text-decoration:none; font-weight:700; font-size:13px;">Detaylar için görüşelim</a>
      </div>
    </div>
    `;

    await transporter.sendMail({
      from: '"Hemen Ustam Gelsin • HUG MARKET" <info@hemenustamgelsin.com>',
      to: safeEmailTo,
      cc: "info@hemenustamgelsin.com",
      subject: `HUG MARKET • ${safeKategori} • Kategori Münhasır Teklif - ${safeFirma}`,
      html: html,
    });

    return { success: true, message: "Mail gönderildi", serverPrice: finalFiyat, validated: true };
  }
);
// ===================== KATEGORI MUNHASIR TEKLIF MAIL BITIS =====================