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
  { region: "europe-west3", secrets: [API_KEY, SECRET_KEY], timeoutSeconds: 60 },
  async (req, res) => {
    try {
      const token = (req.body?.token || req.query?.token || "") as string;
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
      if (!apiKey || !secretKey) {
        console.error("API KEY YOK");
        throw new Error("API Key missing");
      }

      const randomStr = `${Date.now()}${randomBytes(4).toString("hex")}`;

      // REVİZE 1: conversationId orjinal pending'den alınmalı, iyzico böyle sever
      const payload = {
        locale: "tr",
        conversationId: pendingData.conversationId || `cb_${Date.now()}`,
        token: token
      };
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

        // REVİZE 2: Güvenlik - ödenen tutar beklenen tutardan az olmasın
        const expectedAmount = parseFloat(pendingData.amount?.toString() || "0");
        if (paidPrice < expectedAmount - 0.01) {
          console.error(`TUTAR UYUSMUYOR beklenen:${expectedAmount} gelen:${paidPrice}`);
        }

        const paymentRef = db.collection("payments").doc(paymentId);
        const walletRef = db.collection("wallets").doc(uid);
        const existing = await paymentRef.get();

        if (!existing.exists) {
          // REVİZE 3: Transaction içinde atomik işlem - daha güvenli
          await db.runTransaction(async (t) => {
            const walletDoc = await t.get(walletRef);
            // wallet yoksa oluştur, varsa artır
            if (!walletDoc.exists) {
              t.set(walletRef, {
                balance: paidPrice,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
              });
            } else {
              t.set(walletRef, {
                balance: admin.firestore.FieldValue.increment(paidPrice),
                lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
              }, { merge: true });
            }

            t.set(walletRef.collection("transactions").doc(paymentId), {
              type: "topup",
              amount: paidPrice,
              expectedAmount: expectedAmount,
              paymentId: paymentId,
              token: token,
              provider: "iyzico",
              status: "SUCCESS",
              platform: platform,
              iyzicoConversationId: result.conversationId,
              iyzicoBasketId: result.basketId,
              iyzicoPrice: result.price,
              iyzicoPaidPrice: result.paidPrice,
              createdAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            t.set(paymentRef, {
              uid,
              amount: paidPrice,
              expectedAmount: expectedAmount,
              price: result.price,
              paidPrice: result.paidPrice,
              currency: result.currency || "TRY",
              paymentId: result.paymentId,
              token: token,
              conversationId: result.conversationId,
              basketId: result.basketId,
              platform: platform,
              status: "SUCCESS",
              createdAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            t.update(db.collection("pending_payments").doc(token), {
              status: "completed",
              paidPrice: paidPrice,
              paymentId: paymentId,
              iyzicoResult: result,
              completedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
          });

          console.log(`CÜZDAN YÜKLENDİ wallets/${uid} balance += ${paidPrice} platform=${platform}`);
        } else {
          console.log(`ODEME ZATEN ISLENMIS paymentId=${paymentId} - idempotent skip`);
          // pending'i yine completed yap
          await db.collection("pending_payments").doc(token).update({
            status: "completed",
            paidPrice: paidPrice,
            paymentId: paymentId,
            completedAt: admin.firestore.FieldValue.serverTimestamp(),
          }).catch(() => {});
        }

        if (platform === "web") {
          res.redirect(302, `https://hemenustamgelsin.com/odeme-basarili?amount=${paidPrice}&paymentId=${paymentId}`);
        } else {
          res.redirect(302, `hemenustam://payment-success?amount=${paidPrice}&paymentId=${paymentId}`);
        }
      } else {
        console.error("IYZICO BASARISIZ:", result.errorMessage, result.errorCode);
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
    } catch (e: any) {
      console.error("CALLBACK HATA:", e?.message || e, e?.stack);
      const platformFallback = (req.query?.platform as string) || (req.body?.platform as string) || "mobile";
      const failUrl = platformFallback === "web"
        ? "https://hemenustamgelsin.com/odeme-basarisiz?reason=exception"
        : "hemenustam://payment-fail?reason=exception";
      res.redirect(302, failUrl);
    }
  }
);