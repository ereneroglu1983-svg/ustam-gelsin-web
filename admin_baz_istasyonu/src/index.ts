import * as admin from "firebase-admin";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

admin.initializeApp();
const TOPIC = "admin_notifications";

async function sendToAdmin(title: string, body: string, data: any = {}) {
  try {
    const message = {
      topic: TOPIC,
      notification: { title, body },
      android: {
        priority: "high" as const,
        notification: {
          channelId: "admin_baz_channel",
          priority: "high" as const,
          visibility: "public" as const,
          sound: "default",
        },
      },
      data: {
       ...(data as any),
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        timestamp: Date.now().toString(),
      },
    };
    const res = await admin.messaging().send(message);
    console.log(`📡 [BAZ] ${title} -> ${res}`);
    return res;
  } catch (e) {
    console.error("❌ [BAZ] HATA:", e);
    return null;
  }
}

export const yeniUstaBildirimi = onDocumentCreated(
  { document: "users/{userId}", region: "europe-west3" },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    if (data.role!== "usta") return;
    const ad = data.firstName || data.displayName || "Usta";
    const soyad = data.lastName || "";
    const tel = data.phone || data.phoneNumber || "";
    await sendToAdmin("🔧 YENİ USTA!", `${ad} ${soyad} - ${tel}`.substring(0, 100), { type: "yeni_usta", userId: event.params.userId });
  }
);

export const yeniMusteriBildirimi = onDocumentCreated(
  { document: "users/{userId}", region: "europe-west3" },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    if (data.role === "usta") return;
    const ad = data.firstName || data.displayName || "Müşteri";
    const soyad = data.lastName || "";
    await sendToAdmin("👤 YENİ MÜŞTERİ!", `${ad} ${soyad} kayıt oldu`, { type: "yeni_musteri", userId: event.params.userId });
  }
);

export const paraGirisiBildirimi = onDocumentCreated(
  { document: "wallets/{userId}/transactions/{transId}", region: "europe-west3" },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    if (data.type!== "topup" && data.type!== "deposit" && data.type!== "bakiye_yukleme") return;
    const miktar = data.amount || 0;
    if (miktar <= 0) return;
    await sendToAdmin("💰 PARA GİRİŞİ!", `${miktar} TL - ${event.params.userId.substring(0, 6)}...`, { type: "para_girisi", userId: event.params.userId, amount: String(miktar) });
  }
);

export const paymentsBildirimi = onDocumentCreated(
  { document: "payments/{paymentId}", region: "europe-west3" },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    const miktar = data.amount || data.tutar || 0;
    const userId = data.userId || data.uid || "bilinmiyor";
    await sendToAdmin("💳 ÖDEME ALINDI!", `${miktar} TL ödeme - ${userId.substring(0, 6)}`, { type: "odeme", paymentId: event.params.paymentId });
  }
);

export const acilCagriIlanBildirimi = onDocumentCreated(
  { document: "acil_cagri/{cagriId}", region: "europe-west3" },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    const baslik = data.baslik || data.kategori || "Acil Çağrı";
    const ilce = data.ilceAdi || data.konumMetni || "";
    await sendToAdmin("📢 YENİ ACİL İLAN!", `${baslik} - ${ilce}`.substring(0, 100), { type: "yeni_ilan", cagriId: event.params.cagriId, kaynak: "acil_cagri" });
  }
);

export const normalIlanBildirimi = onDocumentCreated(
  { document: "ilanlar/{ilanId}", region: "europe-west3" },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    const baslik = data.baslik || data.kategori || "Yeni İlan";
    await sendToAdmin("📄 YENİ İLAN!", `${baslik}`.substring(0, 100), { type: "yeni_ilan", ilanId: event.params.ilanId, kaynak: "ilanlar" });
  }
);

export const cozumOrtakligiBildirimi = onDocumentCreated(
  { document: "corporate_leads/{leadId}", region: "europe-west3" },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    const firma = data.firma || "Firma";
    const kategori = (data.kategoriler || [])[0] || "";
    await sendToAdmin("🤝 ÇÖZÜM ORTAKLIĞI!", `${firma} - ${kategori}`.substring(0, 100), { type: "cozum_ortakligi", leadId: event.params.leadId });
  }
);

export const sistemMesajBildirimi = onDocumentCreated(
  { document: "admin_messages/{messageId}", region: "europe-west3" },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    if (data.type === "broadcast_success") return;
    const msg = data.msg || data.message || "Yeni mesaj";
    await sendToAdmin("💬 SİSTEM MESAJI!", msg.substring(0, 80), { type: "sistem_mesaj", messageId: event.params.messageId });
  }
);