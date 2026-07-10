// lib/core/payment/iyzico/iyzico_manager.dart

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IyzicoManager {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'europe-west3');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Ödeme başlatır. Backend'e amount yollar, iyzico ödeme sayfası URL'ini alır.
  Future<({String url, String orderId})> triggerPaymentProcess({
    required double amount,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Ödeme için giriş yapmalısınız.");
    }
    if (amount <= 0) {
      throw Exception("Geçersiz tutar.");
    }

    try {
      final callable = _functions.httpsCallable('iyzicoCheckout');
      final result = await callable.call<Map<String, dynamic>>({
        'amount': amount,
      });

      final data = result.data;
      final String paymentPageUrl = data['paymentPageUrl'] as String? ?? '';
      final String orderId = data['orderId'] as String? ?? '';

      if (paymentPageUrl.isEmpty) {
        throw Exception("Ödeme sayfası URL'i alınamadı.");
      }

      return (url: paymentPageUrl, orderId: orderId);
    } on FirebaseFunctionsException catch (e) {
      throw Exception("Ödeme başlatılamadı: ${e.message}");
    } catch (e) {
      throw Exception("Beklenmedik hata: $e");
    }
  }

// SİLİNDİ: verifyAndCompletePayment
// Sebep: Doğrulamayı backend iyzicoCallback yapıyor.
// Frontend manuel bakiye yükleyemez. Güvenlik riski.
// Bakiye güncellenince Firestore'dan dinleyip UI'ı güncelleyeceksin.
}