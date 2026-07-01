// lib/core/payment/akbank/akbank_manager.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/payment_tracking_service.dart';
import 'package:ustam_gelsin/core/services/wallet_service.dart';
import 'akbank_provider.dart';
import 'akbank_config.dart';

class AkbankManager {
  final AkbankProvider _provider = AkbankProvider();
  final PaymentTrackingService _trackingService = PaymentTrackingService();
  final WalletService _walletService = WalletService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// DÜZELTME: Artık hem url hem orderId dönüyor
  Future<({String url, String orderId})> triggerPaymentProcess({
    required double amount,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Ödeme için giriş yapmalısınız.");
    }

    final String orderId = "${user.uid}_${DateTime.now().millisecondsSinceEpoch}";
    final String amountStr = amount.toStringAsFixed(2);

    await _trackingService.createPendingPayment(
      orderId: orderId,
      uid: user.uid,
      amount: amount,
      provider: 'akbank',
    );

    final response = await _provider.initiatePayment(
      orderId: orderId,
      amount: amountStr,
      userEmail: user.email ?? '',
      userId: user.uid,
    );

    if (response['status'] == 'success') {
      final String payment3DUrl = response['redirectUrl'] ?? response['paymentUrl'] ?? '';

      if (payment3DUrl.isEmpty) {
        await _trackingService.updatePaymentStatus(orderId, 'failed', 'Banka 3D URL dönmedi');
        throw Exception("Banka ödeme sayfası oluşturamadı.");
      }

      return (url: payment3DUrl, orderId: orderId); // DÜZELTME
    } else {
      await _trackingService.updatePaymentStatus(
          orderId,
          'failed',
          response['message']?.toString() ?? 'Bilinmeyen hata'
      );
      throw Exception("Ödeme başlatılamadı: ${response['message']}");
    }
  }

  Future<bool> verifyAndCompletePayment(String orderId) async {
    try {
      final statusResponse = await _provider.queryPaymentStatus(orderId);

      if (statusResponse != null &&
          (statusResponse['status']?.toString().toLowerCase() == 'success' ||
              statusResponse['status']?.toString().toLowerCase() == 'approved')) {

        final pendingDoc = await _trackingService.getPendingPayment(orderId);
        if (pendingDoc != null) {
          final String uid = pendingDoc['uid'] as String;
          final double amount = (pendingDoc['amount'] as num).toDouble();

          await _walletService.bakiyeYukle(uid, amount, 'Akbank Yükleme - $orderId');

          await _trackingService.updatePaymentStatus(orderId, 'completed', 'Manuel doğrulama ile tamamlandı');
          await _trackingService.logBankResponse(orderId, statusResponse);
          return true;
        }
      }

      await _trackingService.updatePaymentStatus(
          orderId,
          'failed',
          statusResponse?['message']?.toString() ?? 'Doğrulama başarısız'
      );
      return false;
    } catch (e) {
      await _trackingService.updatePaymentStatus(orderId, 'error', e.toString());
      return false;
    }
  }
}