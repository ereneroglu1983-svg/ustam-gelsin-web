// lib/core/services/payment_tracking_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PaymentTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'pending_payments';

  /// 1. Ödeme başladığında kayıt aç (Status: pending)
  /// Banka denetimi için provider ve tüm metadata loglanır
  Future<void> createPendingPayment({
    required String orderId,
    required String uid,
    required double amount,
    required String provider, // 'akbank' gibi
  }) async {
    try {
      await _firestore.collection(_collection).doc(orderId).set({
        'uid': uid,
        'amount': amount,
        'provider': provider,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'retryCount': 0,
      });
    } catch (e) {
      debugPrint("Ödeme kaydı oluşturulamadı: $e");
      rethrow;
    }
  }

  /// 2. Bankadan dönen cevabı doğrulamak için veriyi getir
  Future<Map<String, dynamic>?> getPendingPayment(String orderId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(orderId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Ödeme kaydı getirilirken hata oluştu: $e");
      return null;
    }
  }

  /// 3. BANKADAN GELEN HER ŞEYİ KAYDET (Audit Log) - Mahkeme/denetim için
  /// Callback, status query, hata dahil her şey buraya yazılır
  Future<void> logBankResponse(String orderId, Map<String, dynamic> bankData) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(orderId)
          .collection('audit_logs')
          .add({
        'data': bankData,
        'receivedAt': FieldValue.serverTimestamp(),
        'type': bankData['type'] ?? 'callback', // 'callback', 'status_query', 'error'
      });
    } catch (e) {
      debugPrint("Audit log kaydedilemedi: $e");
      // Audit log hatası ödemeyi durdurmasın, sadece logla
    }
  }

  /// 4. İşlemi başarıyla kapat (Bakiye yüklendikten sonra)
  Future<void> completePayment(String orderId) async {
    try {
      await _firestore.collection(_collection).doc(orderId).update({
        'status': 'success',
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Ödeme durumu güncellenemedi: $e");
      rethrow;
    }
  }

  /// 5. YENİ: Ödeme durumunu güncelle - Hata/fail durumları için
  /// Banka red, timeout, hash hatası gibi durumlarda kullanılır
  Future<void> updatePaymentStatus(
      String orderId,
      String status, // 'failed', 'cancelled', 'expired', 'error'
      String? message,
      ) async {
    try {
      await _firestore.collection(_collection).doc(orderId).update({
        'status': status,
        'errorMessage': message,
        'updatedAt': FieldValue.serverTimestamp(),
        'retryCount': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint("Ödeme status güncellenemedi: $e");
      rethrow;
    }
  }

  /// 6. YENİ: Transaction ile güvenli okuma - Çifte işlem engeli
  /// Callback handler bunu kullanırsa race condition olmaz
  Future<Map<String, dynamic>?> getPendingPaymentTransaction(
      Transaction txn,
      String orderId,
      ) async {
    final docRef = _firestore.collection(_collection).doc(orderId);
    final doc = await txn.get(docRef);

    if (!doc.exists || doc.data() == null) return null;
    return doc.data() as Map<String, dynamic>;
  }

  /// 7. YENİ: İşlemi transaction içinde kapat - Atomic işlem
  Future<void> completePaymentTransaction(
      Transaction txn,
      String orderId,
      ) async {
    final docRef = _firestore.collection(_collection).doc(orderId);
    txn.update(docRef, {
      'status': 'success',
      'completedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}