import { onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { defineSecret } from "firebase-functions/params";
import { createHash } from "crypto";

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const API_KEY = defineSecret("IYZICO_API_KEY");
const SECRET_KEY = defineSecret("IYZICO_SECRET_KEY");
const BASE_URL = "https://api.iyzipay.com";

function createAuthHeader(apiKey: string, secretKey: string, randomStr: string, payload: any) {
  const payloadStr = payload ? JSON.stringify(payload) : "";
  const hashStr = apiKey + randomStr + secretKey + payloadStr;
  const hash = createHash("sha1").update(hashStr).digest("base64");
  const auth = `apiKey:${apiKey}&randomKey:${randomStr}&signature:${hash}`;
  return `IYZWSv2 ${Buffer.from(auth).toString("base64")}`;
}

export const callback = onRequest(
  { region: "europe-west3", secrets: [API_KEY, SECRET_KEY] },
  async (req, res) => {
    try {
      const token = (req.body?.token || req.query?.token || "") as string;
      console.log("CALLBACK GELDI TOKEN:", token);

      if (!token) {
        res.redirect(302, "hemenustam://payment-fail?reason=no_token");
        return;
      }

      // 1. Önce kendi DB'mizden uid'yi al - EN GÜVENLİ YÖNTEM
      const pendingSnap = await db.collection("pending_payments").doc(token).get();
      const pendingData = pendingSnap.data();
      const uidFromPending = pendingData?.uid;

      if (!uidFromPending) {
        console.error("PENDING PAYMENT BULUNAMADI:", token);
        // fallback olarak iyzico'ya yine soracağız
      }

      const apiKey = API_KEY.value();
      const secretKey = SECRET_KEY.value();
      const randomStr = `${Date.now()}${Math.random()}`;
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
        const uid = uidFromPending || result.buyer?.id;
        const paidPrice = parseFloat(result.paidPrice || pendingData?.amount || "0");
        const paymentId = result.paymentId?.toString();

        if (!uid || !paymentId) {
           res.redirect(302, "hemenustam://payment-fail?reason=missing_data");
           return;
        }

        const paymentRef = db.collection("payments").doc(paymentId);
        const existing = await paymentRef.get();

        if (!existing.exists) {
          await db.collection("users").doc(uid).set({
            bakiye: admin.firestore.FieldValue.increment(paidPrice),
          }, { merge: true });

          await paymentRef.set({
            uid,
            amount: paidPrice,
            price: result.price,
            paidPrice: result.paidPrice,
            paymentId: result.paymentId,
            token: token,
            conversationId: result.conversationId,
            basketId: result.basketId,
            status: "SUCCESS",
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          await db.collection("pending_payments").doc(token).update({
            status: "completed",
            completedAt: admin.firestore.FieldValue.serverTimestamp(),
          }).catch(()=>{});

          console.log(`BAKIYE YUKLENDI uid=${uid} amount=${paidPrice}`);
        }

        res.redirect(302, "hemenustam://payment-success");
      } else {
        await db.collection("pending_payments").doc(token).update({
          status: "failed",
          error: result.errorMessage,
        }).catch(()=>{});
        res.redirect(302, "hemenustam://payment-fail");
      }
    } catch (e) {
      console.error("CALLBACK HATA:", e);
      res.redirect(302, "hemenustam://payment-fail?reason=exception");
    }
  }
);