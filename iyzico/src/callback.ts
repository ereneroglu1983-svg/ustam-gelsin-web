import { onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { defineSecret } from "firebase-functions/params";
import { createHash, randomBytes } from "crypto";

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const API_KEY = defineSecret("IYZICO_API_KEY");
const SECRET_KEY = defineSecret("IYZICO_SECRET_KEY");
const BASE_URL = "https://api.iyzipay.com";

function createAuthHeader(apiKey: string, secretKey: string, randomStr: string, payload: any) {
  const payloadStr = payload ? JSON.stringify(payload) : "";
  const hashStr = apiKey + randomStr + secretKey + payloadStr;
  const hash = createHash("sha1").update(hashStr, "utf8").digest("base64");
  const auth = `apiKey:${apiKey}&randomKey:${randomStr}&signature:${hash}`;
  return `IYZWSv2 ${Buffer.from(auth, "utf8").toString("base64")}`;
}

export const callback = onRequest(
  { region: "europe-west3", secrets: [API_KEY, SECRET_KEY] },
  async (req, res) => {
    try {
      const token = (req.body?.token || req.query?.token || "") as string;
      // ADIM 2 - REVİZE: Platform bilgisi
      const platformFromQuery = (req.query?.platform as string) || "";
      console.log("CALLBACK GELDI TOKEN:", token, "PLATFORM_Q:", platformFromQuery);

      if (!token) {
        const failUrl = platformFromQuery === "web"
          ? "https://hemenustamgelsin.com/odeme-basarisiz?reason=no_token"
          : "hemenustam://payment-fail?reason=no_token";
        res.redirect(302, failUrl);
        return;
      }

      const pendingSnap = await db.collection("pending_payments").doc(token).get();
      if (!pendingSnap.exists) {
        console.error("PENDING BULUNAMADI:", token);
        const failUrl = platformFromQuery === "web"
          ? "https://hemenustamgelsin.com/odeme-basarisiz?reason=no_pending"
          : "hemenustam://payment-fail?reason=no_pending";
        res.redirect(302, failUrl);
        return;
      }

      const pendingData = pendingSnap.data()!;
      const uid = pendingData.uid as string;
      const platform = (pendingData.platform as string) || platformFromQuery || "mobile";

      if (!uid) {
        console.error("PENDING'DE UID YOK:", token);
        const failUrl = platform === "web"
          ? "https://hemenustamgelsin.com/odeme-basarisiz?reason=no_uid"
          : "hemenustam://payment-fail?reason=no_uid";
        res.redirect(302, failUrl);
        return;
      }

      const apiKey = API_KEY.value()?.replace(/\s/g, "").trim() || "";
      const secretKey = SECRET_KEY.value()?.replace(/\s/g, "").trim() || "";
      const randomStr = `${Date.now()}${randomBytes(4).toString("hex")}`;

      const payload = { locale: "tr", conversationId: `cb_${Date.now()}`, token };
      const authHeader = createAuthHeader(apiKey, secretKey, randomStr, payload);

      const iyzicoRes = await fetch(`${BASE_URL}/payment/iyzipos/checkoutform/auth/ecom/detail`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: authHeader,
          "x-iyzi-rnd": randomStr,
        },
        body: JSON.stringify(payload),
      });

      const result = (await iyzicoRes.json()) as any;
      console.log("IYZICO DETAIL:", JSON.stringify(result));

      if (result.status === "success" && result.paymentStatus === "SUCCESS") {
        const paidPrice = parseFloat(result.paidPrice || pendingData.amount?.toString() || "0");
        const paymentId = result.paymentId?.toString();

        if (!paymentId) {
          console.error("MISSING paymentId", result);
          const failUrl = platform === "web"
            ? "https://hemenustamgelsin.com/odeme-basarisiz?reason=missing_paymentId"
            : "hemenustam://payment-fail?reason=missing_paymentId";
          res.redirect(302, failUrl);
          return;
        }

        const paymentRef = db.collection("payments").doc(paymentId);
        const walletRef = db.collection("wallets").doc(uid);
        const existing = await paymentRef.get();

        if (!existing.exists) {
          await walletRef.set({
            balance: admin.firestore.FieldValue.increment(paidPrice),
            lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
          }, { merge: true });

          await walletRef.collection("transactions").doc(paymentId).set({
            type: "topup",
            amount: paidPrice,
            paymentId: paymentId,
            token: token,
            provider: "iyzico",
            status: "SUCCESS",
            iyzicoConversationId: result.conversationId,
            iyzicoBasketId: result.basketId,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          await paymentRef.set({
            uid,
            amount: paidPrice,
            price: result.price,
            paidPrice: result.paidPrice,
            currency: result.currency || "TRY",
            paymentId: result.paymentId,
            token: token,
            conversationId: result.conversationId,
            basketId: result.basketId,
            status: "SUCCESS",
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          await db.collection("pending_payments").doc(token).update({
            status: "completed",
            paidPrice: paidPrice,
            paymentId: paymentId,
            completedAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          console.log(`CÜZDAN YÜKLENDİ wallets/${uid} balance += ${paidPrice} platform=${platform}`);
        } else {
          console.log(`ODEME ZATEN ISLENMIS paymentId=${paymentId}`);
        }

        // ADIM 2 - REVİZE: Web ise web sayfasına, mobil ise app'e
        if (platform === "web") {
          res.redirect(302, `https://hemenustamgelsin.com/odeme-basarili?amount=${paidPrice}`);
        } else {
          res.redirect(302, "hemenustam://payment-success");
        }
      } else {
        console.error("IYZICO BASARISIZ:", result.errorMessage);
        await db.collection("pending_payments").doc(token).update({
          status: "failed",
          error: result.errorMessage,
          errorCode: result.errorCode,
          fullResult: result,
          failedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        const failUrl = platform === "web"
          ? `https://hemenustamgelsin.com/odeme-basarisiz?reason=${result.errorCode || "fail"}`
          : `hemenustam://payment-fail?reason=${result.errorCode || "fail"}`;
        res.redirect(302, failUrl);
      }
    } catch (e) {
      console.error("CALLBACK HATA:", e);
      // Hata durumunda da platform'a bakmaya çalış
      const platformFallback = (req.query?.platform as string) || "mobile";
      const failUrl = platformFallback === "web"
        ? "https://hemenustamgelsin.com/odeme-basarisiz?reason=exception"
        : "hemenustam://payment-fail?reason=exception";
      res.redirect(302, failUrl);
    }
  }
);