// lib/core/payment/iyzico/iyzico_manager.dart

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IyzicoManager {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'europe-west3');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Ödeme başlatır. Backend'e amount + dinamik konum gönderir,
  /// iyzico checkout form içeriğini alır.
  /// 1. REVİZE: Fonksiyon ismi 'iyzicoCheckout' -> 'checkout' düzeltildi
  /// 2. REVİZE: city, district, address parametreleri eklendi
  /// 3. REVİZE: Dönüş tipi paymentPageUrl -> checkoutFormContent olarak düzeltildi
  Future<({String checkoutFormContent, String conversationId, String orderId})> triggerPaymentProcess({
    required double amount,
    String? city,
    String? district,
    String? address,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Ödeme için giriş yapmalısınız.");
    }
    if (amount <= 0) {
      throw Exception("Geçersiz tutar.");
    }

    try {
      // 1. REVİZE: Doğru fonksiyon adı
      final callable = _functions.httpsCallable('checkout');

      final Map<String, dynamic> payload = {
        'amount': amount,
      };

      // 2. REVİZE: Dinamik konum varsa ekle
      if (city != null && city.isNotEmpty) payload['city'] = city;
      if (district != null && district.isNotEmpty) payload['district'] = district;
      if (address != null && address.isNotEmpty) payload['address'] = address;

      final result = await callable.call<Map<String, dynamic>>(payload);

      final data = result.data as Map<String, dynamic>;

      // 3. REVİZE: Backend'in gerçek dönüş alanları
      final String checkoutFormContent = data['checkoutFormContent'] as String? ?? '';
      final String conversationId = data['conversationId'] as String? ?? '';
      final String orderId = data['orderId'] as String? ?? data['conversationId'] as String? ?? '';

      if (checkoutFormContent.isEmpty) {
        throw Exception("Ödeme formu alınamadı.");
      }

      return (
      checkoutFormContent: checkoutFormContent,
      conversationId: conversationId,
      orderId: orderId,
      );
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