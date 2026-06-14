import { onCall } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { GoogleGenerativeAI } from "@google/generative-ai";

// Firebase sistemini başlatıyoruz
admin.initializeApp();

// Senin Gemini API Anahtarın
const GEMINI_API_KEY = "AIzaSyCkiYtJ_-2kU3ksJ6vomSxDNA6n8KxEvOM";
const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);

// İŞTE ASIL "BEYİN" FONKSİYONU - V2 formatında ve Bölge ayarlı
export const hesaplauzmanai = onCall({ region: "europe-west3" }, async (request) => {
    // Flutter'dan gelecek verileri karşılıyoruz
    const { isTipi, metrekare, sehir, detay } = request.data;

    try {
        // 1. CAN SUYU: Firestore'daki "referans_isler" koleksiyonuna bakıyoruz
        const snapshot = await admin.firestore()
            .collection("referans_isler")
            .where("is_tipi", "==", isTipi)
            .limit(5)
            .get();

        let referansBilgisi = "";
        snapshot.forEach(doc => {
            const data = doc.data();
            referansBilgisi += `- ${data.metrekare}m2 ${data.is_tipi} (${data.sehir}): ${data.fiyat} TL\n`;
        });

        // 2. GEMINI ANALİZİ
        const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

        const prompt = `
        Sen Türkiye piyasasına hakim profesyonel bir tadilat uzmanısın.

        ELİNDEKİ GERÇEK REFERANS VERİLERİ:
        ${referansBilgisi || "Henüz referans veri yok, genel piyasa bilgini kullan."}

        YENİ ANALİZ TALEBİ:
        - İş Türü: ${isTipi}
        - Metrekare: ${metrekare} m2
        - Şehir: ${sehir}
        - Detaylar: ${detay}

        GÖREVİN:
        Bu verileri kullanarak 2026 Türkiye şartlarında mantıklı bir fiyat aralığı ver.
        Formatın şunları içermeli:
        1. Tahmini Fiyat Aralığı
        2. Bu fiyatın sebebi (Analiz)
        3. Kullanıcıya usta tavsiyesi.
        `;

        const result = await model.generateContent(prompt);
        const response = await result.response;
        const text = response.text();

        return { success: true, analiz: text };

    } catch (error) {
        console.error("AI Hatası:", error);
        return { success: false, error: "AI şu an hesaplama yapamadı." };
    }
});