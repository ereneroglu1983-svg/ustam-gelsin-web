import { onCall, onRequest, HttpsError } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2";
import { defineSecret } from "firebase-functions/params";
import * as admin from "firebase-admin";
import Iyzipay from "iyzipay";

const IYZICO_API_KEY = defineSecret("IYZICO_SANDBOX_API_KEY");
const IYZICO_SECRET_KEY = defineSecret("IYZICO_SANDBOX_SECRET_KEY");
const IYZICO_BASE_URL = defineSecret("IYZICO_SANDBOX_BASE_URL");

if (!admin.apps.length) admin.initializeApp();
setGlobalOptions({ region: "europe-west3", maxInstances: 10, secrets: [IYZICO_API_KEY, IYZICO_SECRET_KEY, IYZICO_BASE_URL] });

function safeGsm(phoneRaw: string): string {
  const digits = (phoneRaw || "").replace(/\D/g, "");
  const last10 = digits.length >= 10? digits.slice(-10) : "5550000000";
  return `+90${last10}`;
}
function normalizeText(s: string): string { return s? s.trim() : s; }

export const checkout = onCall({ cors: true }, async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "Giriş yapmalısınız.");
  const uid = request.auth.uid;
  const { amount, city, district, address, payWithIyzico } = request.data as { amount: number; city?: string; district?: string; address?: string; payWithIyzico?: boolean; };
  if (!amount || typeof amount!== "number" || amount < 10) throw new HttpsError("invalid-argument", "Min 10 TL");

  const userSnap = await admin.firestore().collection("users").doc(uid).get();
  if (!userSnap.exists) throw new HttpsError("not-found", "User yok");
  const u = userSnap.data() as any;

  const finalCity = normalizeText((city || u.sehir_adi || u.sehir || "Manisa").toString());
  const finalDistrict = normalizeText((district || u.ilce_adi || u.ilce || "Merkez").toString());
  const finalAddress = (address || u.faturaAdresi || u.adres || `${finalDistrict} / ${finalCity}`).toString().substring(0, 180);

  const firstName = (u.firstName || u.ad?.split(" ")[0] || "Ali").toString().trim();
  const lastName = (u.lastName || u.ad?.split(" ").slice(1).join(" ") || "Koc").toString().trim();
  const email = (u.email || `test_${uid.substring(0, 6)}@hemenustamgelsin.com`).toString();
  const identityNumber = u.tcVergiNo && u.tcVergiNo.toString().length === 11? u.tcVergiNo.toString() : "11111111111";
  const ip = u.ipKaydi || request.rawRequest.headers["x-forwarded-for"]?.toString().split(",")[0]?.trim() || "85.34.78.112";

  const iyzipay = new Iyzipay({ apiKey: IYZICO_API_KEY.value(), secretKey: IYZICO_SECRET_KEY.value(), uri: IYZICO_BASE_URL.value() });

  const shortUid = uid.replace(/[^a-zA-Z0-9]/g, "").substring(0, 8);
  const conversationId = `${shortUid}${Date.now()}${Math.random().toString(36).substring(2, 7)}`;
  const basketId = `B${Date.now()}`;
  const priceStr = amount.toFixed(2);

  // Önce pending oluştur
  await admin.firestore().collection("pending_payments").doc(conversationId).set({
    uid, amount, price: priceStr, basketId, conversationId,
    city: finalCity, district: finalDistrict, address: finalAddress,
    payWithIyzico: payWithIyzico?? false,
    status: "pending", createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const reqBody = {
    locale: Iyzipay.LOCALE.TR, conversationId, price: priceStr, paidPrice: priceStr, currency: Iyzipay.CURRENCY.TRY, basketId,
    paymentGroup: Iyzipay.PAYMENT_GROUP.PRODUCT,
    callbackUrl: "https://europe-west3-device-streaming-6f29b03c.cloudfunctions.net/callback",
    buyer: { id: shortUid, name: firstName, surname: lastName, gsmNumber: safeGsm(u.phone || u.telefon), email, identityNumber, registrationAddress: finalAddress, ip, city: finalCity, country: "Turkey", zipCode: "34000" },
    shippingAddress: { contactName: `${firstName} ${lastName}`, city: finalCity, country: "Turkey", address: finalAddress, zipCode: "34000" },
    billingAddress: { contactName: `${firstName} ${lastName}`, city: finalCity, country: "Turkey", address: finalAddress, zipCode: "34000" },
    basketItems: [{ id: "BI001", name: "Bakiye Yükleme", category1: "Cüzdan", itemType: Iyzipay.BASKET_ITEM_TYPE.VIRTUAL, price: priceStr }],
  };

  const result: any = await new Promise((res, rej) => iyzipay.checkoutFormInitialize.create(reqBody, (e: any, r: any) => e? rej(e) : res(r)));
  if (result?.status!== "success") {
    await admin.firestore().collection("pending_payments").doc(conversationId).update({ status: "iyzico_init_failed", error: result?.errorMessage });
    throw new HttpsError("internal", result?.errorMessage || "Iyzico init failed");
  }
  await admin.firestore().collection("pending_payments").doc(conversationId).update({ iyzicoToken: result.token, status: "form_created" });
  return { checkoutFormContent: result.checkoutFormContent, token: result.token, conversationId };
});

export const callback = onRequest({ cors: true }, async (req, res) => {
  if (req.method === "GET") { res.status(200).send("OK"); return; }
  const { token } = req.body;
  if (!token) { res.status(400).send("Token yok"); return; }

  console.log("CALLBACK BODY:", JSON.stringify(req.body));
  const iyzipay = new Iyzipay({ apiKey: IYZICO_API_KEY.value(), secretKey: IYZICO_SECRET_KEY.value(), uri: IYZICO_BASE_URL.value() });

  // Token'dan conversationId bulma helper - iyzico conversationId dönmediği için bu şart
  async function findConversationIdByToken(tkn: string): Promise<string | null> {
    try {
      const q = await admin.firestore().collection("pending_payments").where("iyzicoToken", "==", tkn).limit(1).get();
      if (!q.empty) return q.docs[0].id;
    } catch (e: any) {
      // Index yoksa where patlar, o zaman tüm son 20 kaydı tara (geçici çözüm)
      console.warn("where index hatası, fallback tarama yapılıyor", e?.message);
      const snap = await admin.firestore().collection("pending_payments").orderBy("createdAt", "desc").limit(20).get();
      const found = snap.docs.find(d => d.data()?.iyzicoToken === tkn);
      if (found) return found.id;
    }
    return null;
  }

  try {
    const result: any = await new Promise((res, rej) => iyzipay.checkoutForm.retrieve({ token }, (e: any, r: any) => e? rej(e) : res(r)));
    console.log("CALLBACK IYZICO RESULT:", JSON.stringify(result));

    if (result?.status!== "success" || result?.paymentStatus!== "SUCCESS") {
      const failId = await findConversationIdByToken(token) || String(result?.conversationId || "").trim();
      if (failId) await admin.firestore().collection("pending_payments").doc(failId).set({ status: "failed", raw: result, failedAt: admin.firestore.FieldValue.serverTimestamp() }, { merge: true });
      res.status(200).send(`<html><body><script>window.location.href="hemenustam://payment-fail?reason=${encodeURIComponent(result?.errorMessage || "failed")}";</script></body></html>`);
      return;
    }

    // 1. conversationId -> önce result, yoksa token'dan bul
    let conversationId = String(result.conversationId || result.conversation_id || "").trim();
    if (!conversationId) {
      const found = await findConversationIdByToken(token);
      if (found) {
        conversationId = found;
        console.log(`conversationId token'dan bulundu: ${conversationId}`);
      }
    }
    if (!conversationId) throw new Error(`conversationId bulunamadı. token: ${token}`);

    // 2. Güvenli tutar - Her zaman iyzico'nun çektiği gerçek tutar
    const paymentId = String(result.paymentId || result.token || `pay_${Date.now()}`).trim();
    const paidPrice = parseFloat(String(result.paidPrice?? result.price?? "0"));

    if (isNaN(paidPrice) || paidPrice <= 0) throw new Error(`paidPrice geçersiz. result.paidPrice=${result.paidPrice}`);
    // Ek güvenlik: iyzico ne çektiyse onu yaz, pending'deki amount'ı asla kullanma

    const pendingRef = admin.firestore().collection("pending_payments").doc(conversationId);
    const pendingSnap = await pendingRef.get();
    if (!pendingSnap.exists) throw new Error(`Pending yok: ${conversationId}`);
    const uid = String(pendingSnap.data()?.uid || "").trim();
    if (!uid) throw new Error(`pending içinde uid boş`);

    const walletRef = admin.firestore().collection("wallets").doc(uid);
    const newTxRef = walletRef.collection("transactions").doc();

    console.log(`TRANSACTION başlıyor uid=${uid} amount=${paidPrice}`);

    await admin.firestore().runTransaction(async (t) => {
      const p = await t.get(pendingRef);
      if (p.data()?.status === "success") { console.log("Zaten success, idempotent"); return; }
      const w = await t.get(walletRef);
      const cur = w.exists? Number(w.data()?.balance || 0) : 0;
      t.set(walletRef, { balance: cur + paidPrice, lastUpdated: admin.firestore.FieldValue.serverTimestamp() }, { merge: true });
      t.set(newTxRef, { amount: paidPrice, date: admin.firestore.FieldValue.serverTimestamp(), description: "Bakiye Yükleme - iyzico", type: "topup", paymentId, conversationId });
      t.set(pendingRef, { status: "success", completedAt: admin.firestore.FieldValue.serverTimestamp(), paymentId, paidPrice }, { merge: true });
    });

    console.log("TRANSACTION BAŞARILI");
    res.status(200).send(`<html><head><meta name="viewport" content="width=device-width,initial-scale=1"></head><body><script>window.location.href="hemenustam://payment-success?amount=${paidPrice}&conversationId=${conversationId}";</script><p>Ödeme başarılı</p></body></html>`);

  } catch (e: any) {
    console.error("CALLBACK HATA DETAY:", e, e?.stack);
    res.status(200).send(`<html><body><script>window.location.href="hemenustam://payment-fail?reason=${encodeURIComponent(e.message)}";</script><p>Hata: ${e.message}</p></body></html>`);
  }
});