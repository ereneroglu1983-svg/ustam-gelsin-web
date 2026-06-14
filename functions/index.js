const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");

admin.initializeApp();

// --- TÜM SİSTEM AYARLARI VE API KİMLİK BİLGİLERİ ---
const IG_CONFIG = {
    userId: '17841426706020594',
    token: 'IGAAUWQgSs3T1BZAGFuamZATQ0E5UlNCSXRST0VEbDFvNFF0cndkWEF1TkJOM08wNlVOMGZACdUhEdW0wc293ak10NXUyRnJab2puZA0FNSTVjbjFMNHg2YVZAuM3pMMXZA5eTBSZAnZALT2FGZAUtENzRnT1ZAvTzhybnItZAFhVcFdKSjBHZAwZDZD',
    appId: '1431847685643581',
    appSecret: '66b8676e6c67e3eb762eaa2f44264907'
};

// 0. KRİTİK SİSTEM ALARM FONKSİYONU
exports.adminKritikAlarm = onDocumentCreated('system_alerts/{alertId}', async (event) => {
    const alertData = event.data.data();
    const adminToken = 'ADMİN_TELEFON_TOKENIN';
    const message = {
        token: adminToken,
        notification: { title: '⚠️ KRİTİK SİSTEM ALARMI', body: alertData.message || 'Sistemde müdahale gerektiren bir durum var!' },
        android: { priority: 'high', notification: { channelId: 'high_importance_channel', sound: 'default', visibility: 'public' } },
    };
    return admin.messaging().send(message);
});

// 1. Ödeme Callback Fonksiyonu
exports.akbankCallback = functions.https.onRequest(async (req, res) => {
    try {
        const status = req.body.status;
        const offerId = req.body.offerId;
        if (!status || !offerId) return res.status(400).send("Missing data");
        const offerRef = admin.firestore().collection("offers").doc(offerId);
        if (status === "SUCCESS") {
            await offerRef.update({ paymentStatus: "paid", isUnlocked: true, status: "accepted" });
            return res.status(200).send("PAYMENT SUCCESS");
        }
        if (status === "FAIL") {
            await offerRef.update({ paymentStatus: "failed", isUnlocked: false });
            return res.status(200).send("PAYMENT FAILED");
        }
        return res.status(400).send("INVALID STATUS");
    } catch (error) {
        return res.status(500).send("SERVER ERROR");
    }
});

// 2. Acil Çağrı Bildirim Fonksiyonu
exports.acilUstaBildirimiGonder = onDocumentCreated('acil_cagri/{cagriId}', async (event) => {
    const cagriData = event.data.data();
    const cagriId = event.params.cagriId;
    const musteriGeohash = cagriData.teknikDetaylar?.musteriKonumGeohash;
    const isKolu = cagriData.kategoriId;
    if (!musteriGeohash) return null;
    const ustalarSnapshot = await admin.firestore().collection('users')
        .where('userRole', '==', 'usta')
        .where('is724Active', '==', true)
        .where('uzmanlikAlani', '==', isKolu)
        .where('geohash', '>=', musteriGeohash)
        .where('geohash', '<', musteriGeohash + '{').get();
    const tokens = [];
    ustalarSnapshot.forEach(doc => { if (doc.data().fcmToken) tokens.push(doc.data().fcmToken); });
    if (tokens.length > 0) {
        await admin.messaging().sendEachForMulticast({
            tokens: tokens,
            notification: { title: '🚨 ACİL İŞ ÇAĞRISI!', body: 'Bölgenizde yeni bir acil çağrı var.' },
            data: { type: 'offer', cagriId: String(cagriId), ilanId: String(cagriId) }
        });
    }
});

// 3. Yeni Mesaj Bildirim Fonksiyonu
exports.sendNotificationOnMessage = onDocumentCreated('chats/{chatId}', async (event) => {
    const mesajData = event.data.data();
    const aliciId = mesajData.aliciId;
    const mesajMetni = mesajData.mesajMetni || "Yeni mesajınız var";
    const userDoc = await admin.firestore().collection('users').doc(aliciId).get();
    if (!userDoc.exists || !userDoc.data().fcmToken) return null;
    return admin.messaging().send({
        token: userDoc.data().fcmToken,
        notification: { title: 'Yeni Mesaj', body: mesajMetni },
        data: { type: 'chat', ilanId: String(mesajData.ilanId || ''), ustaId: String(mesajData.gonderenId || '') }
    });
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

    const caption = `UstamGelsin'de Yeni İş Fırsatı!\n\nİş Tanımı: ${ilan.baslik || 'Belirtilmemiş'}\nKategori: ${ilan.kategori || 'Belirtilmemiş'}\nBölge: ${ilan.konumMetni || 'Belirtilmemiş'}\n\nDetaylar için uygulamayı indir!`;
    const imageUrl = "https://hemenustamgelsin.com/default-image.jpg";

    try {
        const upload = await axios.post(`https://graph.facebook.com/v20.0/${IG_CONFIG.userId}/media`, {
            image_url: imageUrl,
            caption: caption,
            access_token: IG_CONFIG.token
        });

        await axios.post(`https://graph.facebook.com/v20.0/${IG_CONFIG.userId}/media_publish`, {
            creation_id: upload.data.id,
            access_token: IG_CONFIG.token
        });

        console.log("✅ İlan başarıyla paylaşıldı!");
    } catch (e) {
        console.error("❌ Paylaşım Hatası:", e.response ? JSON.stringify(e.response.data) : e.message);
    }
});

// 7. YENİ: Destek Mesajları İçin Bildirim Tetikleyicisi
exports.sendSupportNotification = onDocumentCreated('admin_messages/{messageId}', async (event) => {
    const messageData = event.data.data();
    // Admin'in cihazı için bildirim
    const message = {
        notification: {
            title: 'Yeni Destek Mesajı Geldi!',
            body: messageData.msg || 'Bir kullanıcıdan yeni bir mesaj var.'
        },
        topic: 'admin_notifications'
    };
    return admin.messaging().send(message);
});