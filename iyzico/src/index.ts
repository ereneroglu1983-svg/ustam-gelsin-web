import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import * as fs from "fs";
import * as path from "path";

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const API_KEY = defineSecret("IYZICO_API_KEY");
const SECRET_KEY = defineSecret("IYZICO_SECRET_KEY");

let cachedSehirler: any[] | null = null;
let cachedIlceler: any[] | null = null;

function loadSehirler(): any[] {
  if (cachedSehirler) return cachedSehirler;
  const p = path.join(__dirname, "data", "sehirler.json");
  const raw = fs.readFileSync(p, "utf8");
  cachedSehirler = JSON.parse(raw);
  return cachedSehirler!;
}
function loadIlceler(): any[] {
  if (cachedIlceler) return cachedIlceler;
  const p = path.join(__dirname, "data", "ilceler.json");
  const raw = fs.readFileSync(p, "utf8");
  cachedIlceler = JSON.parse(raw);
  return cachedIlceler!;
}
function getSehirIsim(sehir_id: any): string {
  if (!sehir_id) return "Istanbul";
  try {
    const sehirler = loadSehirler();
    const s = sehirler.find((x) => x.sehir_id.toString().trim() === sehir_id.toString().trim());
    return s? s.sehir_adi : "Istanbul";
  } catch { return "Istanbul"; }
}
function getIlceIsim(ilce_id: any): string {
  if (!ilce_id) return "";
  try {
    const ilceler = loadIlceler();
    const i = ilceler.find((x) => x.ilce_id.toString().trim() === ilce_id.toString().trim());
    return i? i.ilce_adi : "";
  } catch { return ""; }
}
function formatPhone(phone: string): string {
  if (!phone) return "+905000000000";
  let p = phone.replace(/\D/g, "");
  if (p.startsWith("0")) p = p.substring(1);
  if (!p.startsWith("90")) p = "90" + p;
  if (p.length < 12) return "+905000000000";
  return `+${p}`;
}

export const checkout = onCall(
  { region: "europe-west3", secrets: [API_KEY, SECRET_KEY], enforceAppCheck: false },
  async (request) => {
    if (!request.auth) throw new HttpsError("unauthenticated", "Giris gerekli");
    const uid = request.auth.uid;
    const { amount, platform } = request.data as { amount: number; platform?: string };
    if (typeof amount!== "number" || amount < 10) throw new HttpsError("invalid-argument", "Gecersiz tutar");

    const apiKey = API_KEY.value()?.trim();
    const secretKey = SECRET_KEY.value()?.trim();
    if (!apiKey ||!secretKey) throw new HttpsError("failed-precondition", "API anahtari yok");

    const userSnap = await db.collection("users").doc(uid).get();
    if (!userSnap.exists) throw new HttpsError("not-found", "Kullanici bulunamadi");
    const userData = userSnap.data()!;

    const firstName = (userData.firstName || userData.name?.split(" ")[0] || "Usta").substring(0, 50);
    const lastName = (userData.lastName || userData.name?.split(" ").slice(1).join(" ") || "Kullanici").substring(0, 50);
    const email = userData.email || request.auth.token.email || `user_${uid}@example.com`;
    const phone = formatPhone(userData.phone || "");
    let adresRaw = (userData.faturaAdresi || userData.adres || "").trim();
    if (!adresRaw) adresRaw = "Manisa Salihli Merkez Mah. Ataturk Cad. No:1";
    const adres = adresRaw.substring(0, 200);
    const identityNumberRaw = (userData.vergiNo || userData.tcVergiNo || userData.mernisNo || userData.tcKimlikNo || userData.vkn || "").toString().trim();
    const cleanId = identityNumberRaw.replace(/\D/g, "");
    const city = getSehirIsim(userData.sehir_id);
    const district = getIlceIsim(userData.ilce_id);
    if (!/^\d{10,11}$/.test(cleanId)) throw new HttpsError("failed-precondition", `Gecerli TCKN/VKN bulunamadi (Gelen: ${identityNumberRaw})`);

    let realIp = (request.rawRequest as any)?.headers?.["x-forwarded-for"]?.toString().split(",")[0]?.trim() || (request.rawRequest as any)?.ip || "85.34.78.112";
    if (!realIp || realIp.includes(":") || realIp.length < 7 || realIp === "::1") realIp = "85.34.78.112";

    const IyzipayModule: any = await import("iyzipay");
    const Iyzipay = IyzipayModule.default || IyzipayModule;
    const iyzipay = new Iyzipay({ apiKey, secretKey, uri: "https://api.iyzipay.com" });

    const conversationId = `${uid.substring(0, 8)}_${Date.now()}`.substring(0, 30);
    const basketId = `WALLET_${uid.substring(0, 5)}_${Date.now()}`;
    const priceStr = amount.toFixed(2);
    const incomingPlatform = (platform || "mobile").toString();
    const callbackUrl = `https://europe-west3-device-streaming-6f29b03c.cloudfunctions.net/callback?platform=${incomingPlatform}`;
    const createdAt = userData.createdAt?.toDate? userData.createdAt.toDate() : new Date("2023-01-01");
    const formatDate = (d: Date) => d.toISOString().slice(0, 19).replace("T", " ");

    const requestData = {
      locale: Iyzipay.LOCALE.TR,
      conversationId,
      price: priceStr,
      paidPrice: priceStr,
      currency: Iyzipay.CURRENCY.TRY,
      basketId,
      paymentGroup: Iyzipay.PAYMENT_GROUP.PRODUCT,
      callbackUrl,
      enabledInstallments: [1],
      buyer: {
        id: uid.substring(0, 30),
        name: firstName,
        surname: lastName,
        gsmNumber: phone,
        email: email,
        identityNumber: cleanId,
        lastLoginDate: formatDate(new Date()),
        registrationDate: formatDate(createdAt),
        registrationAddress: adres,
        ip: realIp,
        city: city,
        country: "Turkey",
        zipCode: "34000",
      },
      shippingAddress: {
        contactName: `${firstName} ${lastName}`.substring(0, 100),
        city: city,
        country: "Turkey",
        address: adres,
        zipCode: "34000",
      },
      billingAddress: {
        contactName: `${firstName} ${lastName}`.substring(0, 100),
        city: city,
        country: "Turkey",
        address: adres,
        zipCode: "34000",
      },
      basketItems: [{ id: "WALLET_TOPUP", name: "Cuzdan Bakiye Yukleme", category1: "Cuzdan", itemType: Iyzipay.BASKET_ITEM_TYPE.VIRTUAL, price: priceStr }],
    };

    return new Promise((resolve, reject) => {
      iyzipay.checkoutFormInitialize.create(requestData, async (err: any, result: any) => {
        if (err) return reject(new HttpsError("internal", `Iyzico SDK: ${err}`));
        if (result.status!== "success") return reject(new HttpsError("internal", `Iyzico: ${result.errorMessage} (${result.errorCode})`));

        console.log("========== IYZICO RESULT ==========");
        console.log("RESULT KEYS =", Object.keys(result));
        console.log("paymentPageUrl =", result.paymentPageUrl);
        console.log("token =", result.token);
        console.log("checkoutFormContent =",!!result.checkoutFormContent);
        console.log(JSON.stringify(result, null, 2));
        console.log("===================================");

        await db.collection("pending_payments").doc(result.token).set({
          uid, amount, conversationId, basketId, city, district, realIp, platform: incomingPlatform, status: "initialized", createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        resolve({
          token: result.token,
          checkoutFormContent: result.checkoutFormContent,
          paymentPageUrl: result.paymentPageUrl,
          conversationId,
          basketId,
          orderId: conversationId,
        });
      });
    });
  }
);

export { callback } from "./callback";