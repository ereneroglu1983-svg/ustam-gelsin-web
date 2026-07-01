const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");

admin.initializeApp();

// 0. KRİTİK SİSTEM ALARM FONKSİYONU
exports.adminKritikAlarm = onDocumentCreated('system_alerts/{alertId}', async (event) => {
    try {
        const alertData = event.data.data();
        const message = {
            token: functions.config().admin?.phone_token,
            notification: { title: '⚠️ KRİTİK SİSTEM ALARMI', body: alertData.message || 'Sistemde müdahale gerektiren bir durum var!' },
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
        let ustalarSnapshot = await admin.firestore().collection('users')
            .where('role', '==', 'usta')
            .where('ilce_id', '==', gelenIlceId)
            .get();

        if (ustalarSnapshot.empty) {
            ustalarSnapshot = await admin.firestore().collection('users')
                .where('role', '==', 'usta')
                .where('sehir_id', '==', gelenIlId)
                .get();
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
                notification: {
                    title: '🚨 ACİL İŞ ÇAĞRISI!',
                    body: 'Bölgenizde yeni bir acil çağrı var.'
                },
                android: {
                    priority: 'high',
                    notification: {
                        channelId: 'high_importance_channel',
                        sound: 'default',
                        visibility: 'public',
                        clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                },
                data: {
                    type: 'acil_cagri',
                    ilanId: String(cagriId),
                    actionType: 'odeme_ekrani',
                    lat: String(cagriData.latitude || 0),
                    lng: String(cagriData.longitude || 0)
                }
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
exports.sendNotificationOnMessage = onDocumentCreated('chats/{chatId}', async (event) => {
    try {
        const mesajData = event.data.data();
        const aliciId = mesajData.aliciId;
        const userDoc = await admin.firestore().collection('users').doc(aliciId).get();
        if (!userDoc.exists || !userDoc.data().fcmToken) return null;
        return await admin.messaging().send({
            token: userDoc.data().fcmToken,
            notification: { title: 'Yeni Mesaj', body: mesajData.mesajMetni || "Yeni mesajınız var" },
            data: { type: 'chat', ilanId: String(mesajData.ilanId || ''), ustaId: String(mesajData.gonderenId || '') }
        });
    } catch (e) {
        console.error("Mesaj bildirim hatası:", e);
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
        const upload = await axios.post(`https://graph.facebook.com/v20.0/${functions.config().ig.user_id}/media`, {
            image_url: "https://hemenustamgelsin.com/default-image.jpg",
            caption: caption,
            access_token: token
        });
        await axios.post(`https://graph.facebook.com/v20.0/${functions.config().ig.user_id}/media_publish`, {
            creation_id: upload.data.id,
            access_token: token
        });
    } catch (e) {
        console.error("❌ Paylaşım Hatası:", e.message);
    }
});

// 7. Destek Mesajları İçin Bildirim Tetikleyicisi
exports.sendSupportNotification = onDocumentCreated('admin_messages/{messageId}', async (event) => {
    try {
        const messageData = event.data.data();
        return await admin.messaging().send({
            notification: { title: 'Yeni Destek Mesajı Geldi!', body: messageData.msg || 'Bir kullanıcıdan mesaj var.' },
            topic: 'admin_notifications'
        });
    } catch (e) {
        console.error("Destek bildirimi hatası:", e);
    }
});

// 8. Usta İşi Kabul Edince Müşteriye Bildirim Gönderen Fonksiyon (Robust Mantık)
exports.ustaIsiKabulEdinceMusteriyeBildir = onDocumentUpdated('acil_cagri/{cagriId}', async (event) => {
    const newData = event.data.after.data();
    const previousData = event.data.before.data();

    if (previousData.durum !== 'atandi' && newData.durum === 'atandi') {
        const customerId = newData.userId;
        // Eğer ustaAd boş gelirse "Ustanız" olarak göster
        const ustaAd = (newData.ustaAd && newData.ustaAd.length > 0) ? newData.ustaAd : "Ustanız";
        const ustaTel = newData.ustaTelefon || "bilinmiyor";

        try {
            const userDoc = await admin.firestore().collection('users').doc(customerId).get();
            if (!userDoc.exists || !userDoc.data().fcmToken) return null;

            const fcmToken = userDoc.data().fcmToken;
            const message = {
                token: fcmToken,
                notification: {
                    title: 'İlanınız Kabul Edildi!',
                    body: `İlanınız ${ustaAd} tarafından kabul edildi. Az sonra sizi ${ustaTel} numarasıyla arayacak. Lütfen telefon sesinizin açık olduğundan emin olun.`
                },
                android: {
                    priority: 'high',
                    notification: { channelId: 'high_importance_channel', sound: 'default' }
                },
                data: { type: 'usta_kabul', cagriId: event.params.cagriId }
            };
            await admin.messaging().send(message);
        } catch (e) {
            console.error("❌ Müşteri bildirim hatası:", e);
        }
    }
    return null;
});