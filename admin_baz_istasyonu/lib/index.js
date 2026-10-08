"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.sistemMesajBildirimi = exports.cozumOrtakligiBildirimi = exports.normalIlanBildirimi = exports.acilCagriIlanBildirimi = exports.paymentsBildirimi = exports.paraGirisiBildirimi = exports.yeniMusteriBildirimi = exports.yeniUstaBildirimi = void 0;
const admin = __importStar(require("firebase-admin"));
const firestore_1 = require("firebase-functions/v2/firestore");
admin.initializeApp();
const TOPIC = "admin_notifications";
async function sendToAdmin(title, body, data = {}) {
    try {
        const message = {
            topic: TOPIC,
            notification: { title, body },
            android: {
                priority: "high",
                notification: {
                    channelId: "admin_baz_channel",
                    priority: "high",
                    visibility: "public",
                    sound: "default",
                },
            },
            data: Object.assign(Object.assign({}, data), { click_action: "FLUTTER_NOTIFICATION_CLICK", timestamp: Date.now().toString() }),
        };
        const res = await admin.messaging().send(message);
        console.log(`📡 [BAZ] ${title} -> ${res}`);
        return res;
    }
    catch (e) {
        console.error("❌ [BAZ] HATA:", e);
        return null;
    }
}
exports.yeniUstaBildirimi = (0, firestore_1.onDocumentCreated)({ document: "users/{userId}", region: "europe-west3" }, async (event) => {
    var _a;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    if (data.role !== "usta")
        return;
    const ad = data.firstName || data.displayName || "Usta";
    const soyad = data.lastName || "";
    const tel = data.phone || data.phoneNumber || "";
    await sendToAdmin("🔧 YENİ USTA!", `${ad} ${soyad} - ${tel}`.substring(0, 100), { type: "yeni_usta", userId: event.params.userId });
});
exports.yeniMusteriBildirimi = (0, firestore_1.onDocumentCreated)({ document: "users/{userId}", region: "europe-west3" }, async (event) => {
    var _a;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    if (data.role === "usta")
        return;
    const ad = data.firstName || data.displayName || "Müşteri";
    const soyad = data.lastName || "";
    await sendToAdmin("👤 YENİ MÜŞTERİ!", `${ad} ${soyad} kayıt oldu`, { type: "yeni_musteri", userId: event.params.userId });
});
exports.paraGirisiBildirimi = (0, firestore_1.onDocumentCreated)({ document: "wallets/{userId}/transactions/{transId}", region: "europe-west3" }, async (event) => {
    var _a;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    if (data.type !== "topup" && data.type !== "deposit" && data.type !== "bakiye_yukleme")
        return;
    const miktar = data.amount || 0;
    if (miktar <= 0)
        return;
    await sendToAdmin("💰 PARA GİRİŞİ!", `${miktar} TL - ${event.params.userId.substring(0, 6)}...`, { type: "para_girisi", userId: event.params.userId, amount: String(miktar) });
});
exports.paymentsBildirimi = (0, firestore_1.onDocumentCreated)({ document: "payments/{paymentId}", region: "europe-west3" }, async (event) => {
    var _a;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    const miktar = data.amount || data.tutar || 0;
    const userId = data.userId || data.uid || "bilinmiyor";
    await sendToAdmin("💳 ÖDEME ALINDI!", `${miktar} TL ödeme - ${userId.substring(0, 6)}`, { type: "odeme", paymentId: event.params.paymentId });
});
exports.acilCagriIlanBildirimi = (0, firestore_1.onDocumentCreated)({ document: "acil_cagri/{cagriId}", region: "europe-west3" }, async (event) => {
    var _a;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    const baslik = data.baslik || data.kategori || "Acil Çağrı";
    const ilce = data.ilceAdi || data.konumMetni || "";
    await sendToAdmin("📢 YENİ ACİL İLAN!", `${baslik} - ${ilce}`.substring(0, 100), { type: "yeni_ilan", cagriId: event.params.cagriId, kaynak: "acil_cagri" });
});
exports.normalIlanBildirimi = (0, firestore_1.onDocumentCreated)({ document: "ilanlar/{ilanId}", region: "europe-west3" }, async (event) => {
    var _a;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    const baslik = data.baslik || data.kategori || "Yeni İlan";
    await sendToAdmin("📄 YENİ İLAN!", `${baslik}`.substring(0, 100), { type: "yeni_ilan", ilanId: event.params.ilanId, kaynak: "ilanlar" });
});
exports.cozumOrtakligiBildirimi = (0, firestore_1.onDocumentCreated)({ document: "corporate_leads/{leadId}", region: "europe-west3" }, async (event) => {
    var _a;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    const firma = data.firma || "Firma";
    const kategori = (data.kategoriler || [])[0] || "";
    await sendToAdmin("🤝 ÇÖZÜM ORTAKLIĞI!", `${firma} - ${kategori}`.substring(0, 100), { type: "cozum_ortakligi", leadId: event.params.leadId });
});
exports.sistemMesajBildirimi = (0, firestore_1.onDocumentCreated)({ document: "admin_messages/{messageId}", region: "europe-west3" }, async (event) => {
    var _a;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    if (data.type === "broadcast_success")
        return;
    const msg = data.msg || data.message || "Yeni mesaj";
    await sendToAdmin("💬 SİSTEM MESAJI!", msg.substring(0, 80), { type: "sistem_mesaj", messageId: event.params.messageId });
});
//# sourceMappingURL=index.js.map