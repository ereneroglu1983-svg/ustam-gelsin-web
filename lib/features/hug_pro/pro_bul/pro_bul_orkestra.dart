// lib/features/hug_pro/pro_bul/pro_bul_orkestra.dart
// KİLİTLİ v1.0 - PRO_BUL ÖZEL ORKESTRA
// Eski genel orkestraya dokunmaz, sadece pro_bul akışını yönetir

import 'pro_bul_hugai_provider.dart';

class ProBulOrkestra {
  static Future<Map<String, dynamic>> silsileYurut({
    required String yapiTuru,
    required List<String> ihtiyacIds,
    required Map<String, dynamic> detaylar,
    required String il,
    required String ilce,
  }) async {
    print("🎼 [PRO_BUL ORKESTRA BAŞLADI] $yapiTuru | ${ihtiyacIds.length} meslek | $il/$ilce");

    // SADECE HUGAI - başka provider yok, fatura şişmesin!
    try {
      final result = await ProBulHugAiProvider.degerle(
        yapiTuru: yapiTuru,
        ihtiyacIds: ihtiyacIds,
        detaylar: detaylar,
        il: il,
        ilce: ilce,
      );
      print("✅ [PRO_BUL HUGAI BAŞARILI] ${result['services'].length} hizmet | Toplam: ${result['total']['estimated_tl']} TL");
      print("🎼 [PRO_BUL ORKESTRA BİTTİ - HUGAI]");
      return result;
    } catch (e) {
      print("❌ [PRO_BUL ORKESTRA HATA] $e");
      rethrow;
    }
  }
}