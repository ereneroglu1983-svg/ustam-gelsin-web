import { onCall, onRequest, HttpsError } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
const Iyzipay = require('iyzipay');

admin.initializeApp();
setGlobalOptions({ region: "europe-west3", maxInstances: 10 });

// Iyzipay başlatma fonksiyonu (Firebase config'teki özel isimlere göre revize edildi)
const getIyzipay = () => {
  return new Iyzipay({
    apiKey: process.env.IYZICO_SANDBOX_APIKEY,
    secretKey: process.env.IYZICO_SANDBOX_SECRET,
    uri: process.env.IYZICO_SANDBOX_BASE || 'https://sandbox-api.iyzipay.com'
  });
};

export const iyzicoCheckout = onCall(async (request) => {
  const { amount } = request.data;
  const context = request.auth;

  if (!context) throw new HttpsError("unauthenticated", "Giriş yapmanız gerekiyor.");

  const iyzipay = getIyzipay(); // Fonksiyon çalıştığında başlat

  const requestBody = {
    locale: Iyzipay.LOCALE.TR,
    conversationId: context.uid,
    price: amount.toString(),
    paidPrice: amount.toString(),
    currency: Iyzipay.CURRENCY.TRY,
    basketId: 'B' + Date.now(),
    paymentGroup: Iyzipay.PAYMENT_GROUP.PRODUCT,
    callbackUrl: 'https://hemenustamgelsin.com/odeme-basarili',
    buyer: {
        id: context.uid, name: 'User', surname: 'User', email: 'email@email.com',
        identityNumber: '11111111111', registrationAddress: 'Nidakule Göztepe',
        ip: '85.34.78.112', city: 'Istanbul', country: 'Turkey', zipCode: '34732'
    },
    basketItems: [{ id: 'BI101', name: 'Bakiye Yükleme', category1: 'Cüzdan', itemType: Iyzipay.BASKET_ITEM_TYPE.VIRTUAL, price: amount.toString() }]
  };

  return new Promise((resolve, reject) => {
    iyzipay.checkoutFormInitialize.create(requestBody, (err: any, result: any) => {
      if (err || result.status !== 'success') {
        logger.error("İyzico başlatma hatası:", result);
        reject(new HttpsError('internal', result?.errorMessage || 'Ödeme başlatılamadı.'));
      } else {
        resolve({ paymentPageUrl: result.paymentPageUrl });
      }
    });
  });
});

export const iyzicoCallback = onRequest(async (req, res) => {
  const { token } = req.body;
  const iyzipay = getIyzipay(); // Fonksiyon çalıştığında başlat

  iyzipay.checkoutForm.retrieve({ token: token }, async (err: any, result: any) => {
    if (result && result.paymentStatus === 'SUCCESS') {
      const uid = result.conversationId;
      const amount = parseFloat(result.paidPrice);
      const walletRef = admin.firestore().collection('wallets').doc(uid);

      await admin.firestore().runTransaction(async (t) => {
        const doc = await t.get(walletRef);
        const data = doc.data();
        const currentBalance = (doc.exists && data) ? (data.balance || 0) : 0;
        t.set(walletRef, { balance: currentBalance + amount, lastUpdated: admin.firestore.FieldValue.serverTimestamp() }, { merge: true });
      });
      res.status(200).send("OK");
    } else {
      res.status(400).send("Ödeme başarısız");
    }
  });
});