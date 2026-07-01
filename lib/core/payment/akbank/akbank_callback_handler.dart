// lib/core/payment/akbank/akbank_callback_handler.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/services/payment_tracking_service.dart';
import 'package:ustam_gelsin/core/services/wallet_service.dart';
import 'akbank_hash_service.dart';

class AkbankCallbackHandler {
  final PaymentTrackingService _tracking = PaymentTrackingService();
  final WalletService _wallet = WalletService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Bankadan gelen callback'i işler. TÜM BANKALAR HASH ZORUNLU TUTAR.
  /// ÇİFTE YÜKLEME ENGELLİ - TRANSACTION İLE ATOMİK İŞLEM
  Future<void> handleCallback(String orderId, Map<String, dynamic> bankResponse) async {
    try {
      // 1. Bankadan gelen her şeyi logla - Transaction dışı, fail olsa bile kayıt kalsın
      await _tracking.logBankResponse(orderId, bankResponse);

      // 2. GÜVENLİK: Hash doğrulaması - BANKA ZORUNLU KILAR
      final String incomingHash = bankResponse['hash']?.toString() ?? '';
      final String status = bankResponse['status']?.toString() ?? '';
      final String amountStr = bankResponse['amount']?.toString() ?? '0.00';

      if (incomingHash.isEmpty) {
        await _tracking.logBankResponse(orderId, {'error': 'Hash missing', 'data': bankResponse});
        debugPrint("GÜVENLİK HATASI: Banka hash göndermedi! OrderID: $orderId");
        return;
      }

      final String expectedHash = AkbankHashService.generateCallbackHash(
        orderId: orderId,
        amount: amountStr,
        status: status,
      );

      if (incomingHash.toLowerCase() != expectedHash.toLowerCase()) {
        await _tracking.logBankResponse(orderId, {
          'error': 'Hash mismatch',
          'expected': expectedHash,
          'received': incomingHash,
          'data': bankResponse
        });
        debugPrint("GÜVENLİK HATASI: Hash uyuşmuyor! Saldırı olabilir. OrderID: $orderId");
        return;
      }

      // 3. Tutar parse et
      final double bankAmount = double.tryParse(amountStr) ?? 0.0;
      if (bankAmount <= 0) {
        await _tracking.updatePaymentStatus(orderId, 'error', 'Geçersiz tutar: $amountStr');
        debugPrint("HATA: Geçersiz tutar. OrderID: $orderId");
        return;
      }

      // 4. BAŞARILI MI KONTROL ET
      if (status.toLowerCase() != 'success' && status.toLowerCase() != 'approved') {
        await _tracking.updatePaymentStatus(
            orderId,
            'failed',
            bankResponse['message']?.toString() ?? 'Banka işlemi reddetti'
        );
        debugPrint("HATA: Banka işlemi başarısız. Status: $status, OrderID: $orderId");
        return;
      }

      // 5. KRİTİK: TRANSACTION BAŞLAT - ÇİFTE YÜKLEME ENGELİ
      await _firestore.runTransaction((transaction) async {
        // 5.1. Pending kaydı transaction içinde oku
        final pendingData = await _tracking.getPendingPaymentTransaction(transaction, orderId);

        if (pendingData == null) {
          throw Exception("Ödeme kaydı bulunamadı! OrderID: $orderId");
        }

        // 5.2. ZATEN İŞLENDİYSE DUR - RACE CONDITION ENGELİ
        if (pendingData['status'] != 'pending') {
          throw Exception("Bu işlem zaten işlenmiş. Status: ${pendingData['status']}");
        }

        // 5.3. Tutar uyuşmazlığı kontrolü
        final double pendingAmount = (pendingData['amount'] as num).toDouble();
        if ((pendingAmount - bankAmount).abs() > 0.01) {
          throw Exception("Tutar uyuşmuyor! Beklenen: $pendingAmount, Gelen: $bankAmount");
        }

        // 5.4. UID ve Ref al
        final String uid = pendingData['uid'] as String;
        final String transactionId = bankResponse['transactionId']?.toString() ??
            bankResponse['refNo']?.toString() ??
            orderId;

        // 5.5. CÜZDANA YÜKLE - WalletService içinde de transaction kullanmalı
        await _wallet.bakiyeYukleTransaction(
            transaction,
            uid,
            pendingAmount,
            "Akbank Ödemesi - Ref: $transactionId - Order: $orderId"
        );

        // 5.6. İşlemi transaction içinde kapat
        await _tracking.completePaymentTransaction(transaction, orderId);

        debugPrint("BAŞARILI: $uid kullanıcısına $pendingAmount TL bakiye yüklendi. Ref: $transactionId");
      });

    } catch (e, stack) {
      debugPrint("AkbankCallbackHandler kritik hata: $e");
      debugPrint("Stack: $stack");

      // Hata durumunda da logla ve status güncelle
      await _tracking.logBankResponse(orderId, {
        'critical_error': e.toString(),
        'stack': stack.toString()
      });

      // Eğer transaction hata verdiyse status'u error yap
      if (!e.toString().contains('zaten işlenmiş')) {
        await _tracking.updatePaymentStatus(orderId, 'error', e.toString());
      }

      rethrow;
    }
  }
}