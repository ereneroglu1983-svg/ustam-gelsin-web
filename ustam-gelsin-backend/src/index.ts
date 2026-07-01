/* eslint-disable */
import { onSchedule } from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";
import axios from "axios";

// Firebase Admin'i başlat
admin.initializeApp();

// Her Pazartesi saat 00:00'da çalışır, bölge Frankfurt (europe-west3) olarak ayarlandı
export const tokenYenilemeJob = onSchedule({
  schedule: "0 0 * * 1",
  timeZone: "Europe/Istanbul",
  region: "europe-west3",
}, async (event) => {
  const db = admin.firestore();

  try {
    // 1. Firestore'dan config dosyasını oku
    const docRef = db.collection("settings").doc("sosyal_medya_config");
    const doc = await docRef.get();
    
    if (!doc.exists) {
      console.error("Config dokümanı bulunamadı.");
      return;
    }

    const data = doc.data() as any;
    const oldToken = data.long_lived_token;

    if (!oldToken) {
      console.error("Token bilgisi bulunamadı.");
      return;
    }

    // 2. Facebook API üzerinden yeni token al
    const appId = process.env.IG_APP_ID;
    const appSecret = process.env.IG_APP_SECRET;

    const url = `https://graph.facebook.com/v20.0/oauth/access_token?grant_type=fb_exchange_token&client_id=${appId}&client_secret=${appSecret}&fb_exchange_token=${oldToken}`;

    const response = await axios.get(url);
    const newToken = response.data.access_token;

    // 3. Firestore'u güncelle
    await docRef.update({
      "long_lived_token": newToken,
      "son_yenileme": admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log("Token başarıyla yenilendi.");
  } catch (error) {
    console.error("Token yenileme hatası:", error);
  }
});