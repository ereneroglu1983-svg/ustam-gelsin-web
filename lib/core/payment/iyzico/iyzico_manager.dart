import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IyzicoManager {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'europe-west3');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<({String checkoutFormContent, String token, String paymentPageUrl})> triggerPaymentProcess({
    required double amount,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Giriş yapmalısınız.");

    try {
      final callable = _functions.httpsCallable('checkout');
      final result = await callable.call<Map<String, dynamic>>({'amount': amount});
      final data = result.data as Map<String, dynamic>;

      final String checkoutFormContent = data['checkoutFormContent'] as String? ?? '';
      final String token = data['token'] as String? ?? '';
      final String paymentPageUrl = data['paymentPageUrl'] as String? ?? '';

      if (checkoutFormContent.isEmpty && paymentPageUrl.isEmpty) {
        throw Exception("Ödeme formu alınamadı.");
      }

      return (checkoutFormContent: checkoutFormContent, token: token, paymentPageUrl: paymentPageUrl);
    } on FirebaseFunctionsException catch (e) {
      // ARTIK GERÇEK HATAYI GÖRECEKSİN
      throw Exception("Ödeme hatası: ${e.message} - Detay: ${e.details}");
    }
  }
}