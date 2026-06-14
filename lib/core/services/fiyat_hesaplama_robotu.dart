// lib/core/services/fiyat_hesaplama_robotu.dart

import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
// MerkeziRobot'un yanına, yeni motorumuzu import ediyoruz
import '../managers/price_calculation_manager.dart';

class FiyatHesaplamaRobotu {

  static String formatliFiyat(double fiyat) {
    final format = NumberFormat.currency(locale: "tr_TR", symbol: "₺", decimalDigits: 0);
    return format.format(fiyat.round());
  }

  // ====================== REVIZE MOTOR (PriceCalculationManager Entegrasyonu) ======================
  static Future<double> hesapla({
    required String userId,
    required String baslik,
    required String kategori,
    required String kategoriId,
    required Map<String, dynamic> detaylar,
  }) async {
    debugPrint("🔧 FiyatHesaplamaRobotu Köprüsü Tetiklendi: $kategori");

    // PriceCalculationManager instance'ını oluştur
    final PriceCalculationManager manager = PriceCalculationManager();

    // Yeni motorumuz üzerinden orkestra hesaplamasını çağırıyoruz
    final String sonucText = await manager.orkestraFiyatHesapla(
      userId: userId,
      baslik: baslik,
      kategori: kategori,
      kategoriId: kategoriId,
      detaylar: detaylar,
    );

    // Dönen string ifadeyi double'a çeviriyoruz
    final double sonuc = PriceCalculationManager.fiyatTemizle(sonucText);

    debugPrint("💰 Hesaplanan Nihai Maliyet: $sonuc ₺");
    return sonuc;
  }
}