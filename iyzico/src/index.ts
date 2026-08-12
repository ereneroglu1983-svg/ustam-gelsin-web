import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { createHash, randomBytes } from "crypto";
import * as fs from "fs";
import * as path from "path";

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const API_KEY = defineSecret("IYZICO_API_KEY");
const SECRET_KEY = defineSecret("IYZICO_SECRET_KEY");

const BASE_URL = "https://api.iyzipay.com";
const CALLBACK_URL = "https://europe-west3-device-streaming-6f29b03c.cloudfunctions.net/callback";

// --- JSON DOSYALARINI OKUMA - DİNAMİK ---
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
    return s ? s.sehir_adi : "Istanbul";
  } catch {
    return "Istanbul";
  }
}

function getIlceIsim(ilce_id: any): string {
  if (!ilce_id) return "";
  try {
    const ilceler = loadIlceler();
    const i = ilceler.find((x) => x.ilce_id.toString().trim() === ilce_id.toString().trim());
    return i ? i.ilce_adi : "";
  } catch {
    return "";
  }
}

function formatPhone(phone: string): string {
  if (!phone) return "+905000000000";
  let p = phone.replace(/\D/g, "");
  if (p.startsWith("0")) p = p.substring(1);
  if (!p.startsWith("90")) p = "90" + p;
  // Iyzico bazen + işaretini sevmiyor, ama buyer'da + ile gidiyor
  // Eğer telefon çok kısa ise fallback
  if (p.length < 12) return "+905000000000";
  return `+${p}`;
}

function createAuthHeader(apiKey: string, secretKey: string, randomStr: string, payload: any) {
  const payloadStr = JSON.stringify(payload);
  const hashStr = apiKey + randomStr + secretKey + payloadStr;
  const hash = createHash("sha1").update(hashStr).digest("base64");
  const authString = `apiKey:${apiKey}&randomKey:${randomStr}&signature:${hash}`;
  return `IYZWSv2 ${Buffer.from(authString).toString("base64")}`;
}

export const checkout = onCall(
  { region: "europe-west3", secrets: [API_KEY, SECRET_KEY], enforceAppCheck: false },
  async (request) => {
    if (!request.auth) throw new HttpsError("unauthenticated", "Giris gerekli");

    const uid = request.auth.uid;
    const { amount } = request.data as { amount: number };

    if (typeof amount !== "number" || amount < 10) {
      throw new HttpsError("invalid-argument", "Gecersiz tutar");
    }

    const apiKey = API_KEY.value()?.trim();
    const secretKey = SECRET_KEY.value()?.trim();
    if (!apiKey || !secretKey) throw new HttpsError("failed-precondition", "API anahtari yok");

    const userSnap = await db.collection("users").doc(uid).get();
    if (!userSnap.exists) throw new HttpsError("not-found", "Kullanici bulunamadi");
    const userData = userSnap.data()!;

    const firstName = (userData.firstName || userData.name?.split(" ")[0] || "Usta").substring(0, 50);
    const lastName = (userData.lastName || userData.name?.split(" ").slice(1).join(" ") || "Kullanici").substring(0, 50);
    const email = userData.email || request.auth.token.email || `user_${uid}@example.com`;
    const phone = formatPhone(userData.phone || "");

    // ADRES FIX - Boşsa fallback
    let adresRaw = (userData.faturaAdresi || userData.adres || "").trim();
    if (!adresRaw) adresRaw = "Manisa Salihli Merkez Mah. Ataturk Cad. No:1";
    const adres = adresRaw.substring(0, 200);

    // VERGI NO FIX - Senin alan adın vergiNo, onu başa aldım
    const identityNumberRaw = (
      userData.vergiNo ||
      userData.tcVergiNo ||
      userData.mernisNo ||
      userData.tcKimlikNo ||
      userData.vkn ||
      ""
    ).toString().trim();

    const cleanId = identityNumberRaw.replace(/\D/g, "");

    const city = getSehirIsim(userData.sehir_id);
    const district = getIlceIsim(userData.ilce_id);

    // TCKN 11 hane, VKN 10 hane - ikisini de kabul et
    if (!/^\d{10,11}$/.test(cleanId)) {
      console.error(`[IYZICO] TCKN/VKN HATASI uid:${uid} gelen:${identityNumberRaw} temiz:${cleanId}`);
      throw new HttpsError("failed-precondition", `Gecerli TCKN/VKN bulunamadi (Gelen: ${identityNumberRaw}) - Lutfen profilden vergiNo ekleyin`);
    }

    // IP FIX - Iyzico IPv6 sevmiyor
    let realIp =
      (request.rawRequest as any)?.headers?.["x-forwarded-for"]?.toString().split(",")[0]?.trim() ||
      (request.rawRequest as any)?.ip ||
      userData.ipKaydi ||
      "85.34.78.112";

    if (!realIp || realIp.includes(":") || realIp.length < 7 || realIp === "::1") {
      realIp = "85.34.78.112";
    }

    const conversationId = `${uid.substring(0, 8)}_${Date.now()}`.substring(0, 30);
    const basketId = `WALLET_${uid.substring(0, 5)}_${Date.now()}`;
    const priceStr = amount.toFixed(2);
    const randomStr = randomBytes(16).toString("hex");

    const createdAt = userData.createdAt?.toDate ? userData.createdAt.toDate() : new Date("2023-01-01");
    const formatDate = (d: Date) => d.toISOString().slice(0, 19).replace("T", " ");

    const payload = {
      locale: "tr",
      conversationId,
      price: priceStr,
      paidPrice: priceStr,
      currency: "TRY",
      basketId,
      paymentGroup: "PRODUCT",
      callbackUrl: CALLBACK_URL,
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
      basketItems: [
        {
          id: "WALLET_TOPUP",
          name: "Cuzdan Bakiye Yukleme",
          category1: "Cuzdan",
          itemType: "VIRTUAL",
          price: priceStr,
        },
      ],
    };

    console.log(`[IYZICO] ${uid} - ${city}/${district} - IP:${realIp} - Amount:${priceStr} - ID:${cleanId}`);

    const authHeader = createAuthHeader(apiKey, secretKey, randomStr, payload);

    const res = await fetch(`${BASE_URL}/payment/iyzipos/checkoutform/initialize/auth/ecom`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: authHeader,
        "x-iyzi-rnd": randomStr,
      },
      body: JSON.stringify(payload),
    });

    const result = (await res.json()) as any;
    console.log("IYZICO INIT RESULT:", JSON.stringify(result));

    if (result.status !== "success") {
      throw new HttpsError("internal", `Iyzico: ${result.errorMessage} (${result.errorCode})`);
    }

    await db.collection("pending_payments").doc(result.token).set({
      uid,
      amount,
      conversationId,
      basketId,
      city,
      district,
      realIp,
      status: "initialized",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      token: result.token,
      checkoutFormContent: result.checkoutFormContent,
      paymentPageUrl: result.paymentPageUrl,
    };
  }
);

export { callback } from "./callback";