// lib/core/services/fiyat_hesaplama_robotu.dart

import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import '../managers/price_calculation_manager.dart';

class FiyatHesaplamaRobotu {
  // Instance'ı statik olarak tutmak performans kazandırır
  static final PriceCalculationManager _manager = PriceCalculationManager();

  static String formatliFiyat(double fiyat) {
    final format = NumberFormat.currency(locale: "tr_TR", symbol: "₺", decimalDigits: 0);
    return format.format(fiyat.round());
  }

  static Future<double> hesapla({
    required String userId,
    required String baslik,
    required String kategori,
    required String kategoriId,
    required Map<String, dynamic> detaylar,
  }) async {
    try {
      final String sonucText = await _manager.orkestraFiyatHesapla(
        userId: userId,
        baslik: baslik,
        kategori: kategori,
        kategoriId: kategoriId,
        detaylar: detaylar,
      );

      final double sonuc = PriceCalculationManager.fiyatTemizle(sonucText);
      debugPrint("💰 Hesaplanan Nihai Maliyet: $sonuc ₺");
      return sonuc;
    } catch (e) {
      debugPrint("❌ Fiyat Hesaplama Hatası: $e");
      return 0.0; // Hata durumunda 0 dönerek uygulamanın çökmesini engelliyoruz
    }
  }
}