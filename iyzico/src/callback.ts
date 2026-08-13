import { onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { defineSecret } from "firebase-functions/params";

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const API_KEY = defineSecret("IYZICO_API_KEY");
const SECRET_KEY = defineSecret("IYZICO_SECRET_KEY");

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
        const failUrl = platform === "web"
          ? "https://hemenustamgelsin.com/odeme-basarisiz?reason=no_uid"
          : "hemenustam://payment-fail?reason=no_uid";
        res.redirect(302, failUrl);
        return;
      }

      const apiKey = API_KEY.value()?.trim() || "";
      const secretKey = SECRET_KEY.value()?.trim() || "";
      if (!apiKey || !secretKey) throw new Error("API Key missing");

      const IyzipayModule: any = await import("iyzipay");
      const Iyzipay = IyzipayModule.default || IyzipayModule;

      const iyzipay = new Iyzipay({
        apiKey,
        secretKey,
        uri: "https://api.iyzipay.com",
      });

      const requestData = {
        locale: Iyzipay.LOCALE.TR,
        conversationId: pendingData.conversationId || `cb_${Date.now()}`,
        token: token,
      };

      iyzipay.checkoutForm.retrieve(requestData, async (err: any, result: any) => {
        console.log("IYZICO DETAIL SDK:", JSON.stringify(result));

        if (err || result.status!== "success" || result.paymentStatus!== "SUCCESS") {
          console.error("IYZICO BASARISIZ:", result?.errorMessage, result?.errorCode, err);
          await db.collection("pending_payments").doc(token).update({
            status: "failed",
            error: result?.errorMessage || err,
            errorCode: result?.errorCode,
            fullResult: result,
            failedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
          const failUrl = platform === "web"
            ? `https://hemenustamgelsin.com/odeme-basarisiz?reason=${result?.errorCode || "fail"}`
            : `hemenustam://payment-fail?reason=${result?.errorCode || "fail"}`;
          res.redirect(302, failUrl);
          return;
        }

        const paidPrice = parseFloat(result.paidPrice || pendingData.amount?.toString() || "0");
        const paymentId = result.paymentId?.toString();

        if (!paymentId) {
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
          await db.runTransaction(async (t) => {
            const walletDoc = await t.get(walletRef);
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
              paymentId,
              token,
              provider: "iyzico",
              status: "SUCCESS",
              platform,
              createdAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            t.set(paymentRef, {
              uid,
              amount: paidPrice,
              price: result.price,
              paidPrice: result.paidPrice,
              currency: result.currency || "TRY",
              paymentId,
              token,
              conversationId: result.conversationId,
              basketId: result.basketId,
              platform,
              status: "SUCCESS",
              createdAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            t.update(db.collection("pending_payments").doc(token), {
              status: "completed",
              paidPrice,
              paymentId,
              completedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
          });
        }

        if (platform === "web") {
          res.redirect(302, `https://hemenustamgelsin.com/odeme-basarili?amount=${paidPrice}&paymentId=${paymentId}`);
        } else {
          res.redirect(302, `hemenustam://payment-success?amount=${paidPrice}&paymentId=${paymentId}`);
        }
      });
    } catch (e: any) {
      console.error("CALLBACK HATA:", e?.message, e?.stack);
      const platformFallback = (req.query?.platform as string) || "mobile";
      const failUrl = platformFallback === "web"
        ? "https://hemenustamgelsin.com/odeme-basarisiz?reason=exception"
        : "hemenustam://payment-fail?reason=exception";
      res.redirect(302, failUrl);
    }
  }
);