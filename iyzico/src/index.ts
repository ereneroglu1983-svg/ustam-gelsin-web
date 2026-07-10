import { onCall, onRequest, HttpsError } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";

admin.initializeApp();
setGlobalOptions({ region: "europe-west3", maxInstances: 10 });

export const iyzicoCheckout = onCall(async (request) => {
  const data = request.data;
  const context = request.auth;

  if (!context) {
    throw new HttpsError("unauthenticated", "Giriş yapmanız gerekiyor.");
  }

  logger.info("iyzicoCheckout çağrıldı", { uid: context.uid, data: data });

  try {
    // TODO: İyzico API çağrısı buraya gelecek
    const result = {
      success: true,
      message: "Checkout başlatıldı",
      uid: context.uid,
    };
    return result;
  } catch (error) {
    logger.error("iyzicoCheckout hatası", error);
    throw new HttpsError("internal", "Ödeme başlatılamadı.");
  }
});

export const iyzicoCallback = onRequest(async (req, res) => {
  logger.info("iyzicoCallback çağrıldı", { body: req.body });

  try {
    // TODO: İyzico callback doğrulama buraya gelecek
    res.status(200).send("OK");
  } catch (error) {
    logger.error("iyzicoCallback hatası", error);
    res.status(500).send("ERROR");
  }
});