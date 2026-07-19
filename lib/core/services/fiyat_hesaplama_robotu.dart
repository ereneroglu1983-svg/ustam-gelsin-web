// lib/core/services/fiyat_hesaplama_robotu.dart

import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import '../managers/price_calculation_manager.dart';

class FiyatHesaplamaRobotu {
  static final PriceCalculationManager _manager = PriceCalculationManager();

  static String formatliFiyat(double fiyat) {
    final format = NumberFormat.currency(locale: "tr_TR", symbol: "₺", decimalDigits: 0);
    return format.format(fiyat.round());
  }

  static String formatliAralik(double min, double max) {
    final format = NumberFormat("#,##0", "tr_TR");
    return "${format.format(min.toInt())} - ${format.format(max.toInt())} ₺";
  }

  static Future<double> hesapla({
    required String userId,
    required String baslik,
    required String kategori,
    required String kategoriId,
    required Map<String, dynamic> detaylar,
    String talepId = "",
    String bolgeKodu = "diger",
  }) async {
    try {
      final Map<String, dynamic> sonucMap = await _manager.orkestraFiyatHesapla(
        userId: userId,
        talepId: talepId.isEmpty ? userId : talepId,
        baslik: baslik,
        kategori: kategori,
        kategoriId: kategoriId,
        detaylar: detaylar,
        bolgeKodu: bolgeKodu,
      );
      final double ort = (sonucMap['muhtemelButce'] as num).toDouble();
      debugPrint("Hesaplanan Nihai Maliyet (Ort): $ort");
      return ort;
    } catch (e) {
      debugPrint("Fiyat Hesaplama Hatasi: $e");
      return 5000.0;
    }
  }

  static Future<Map<String, dynamic>> aralikliHesapla({
    required String userId,
    required String talepId,
    required String baslik,
    required String kategori,
    required String kategoriId,
    required Map<String, dynamic> detaylar,
    required String bolgeKodu,
  }) async {
    try {
      final Map<String, dynamic> sonucMap = await _manager.orkestraFiyatHesapla(
        userId: userId,
        talepId: talepId,
        baslik: baslik,
        kategori: kategori,
        kategoriId: kategoriId,
        detaylar: detaylar,
        bolgeKodu: bolgeKodu,
      );

      double min = (sonucMap['minimumButce'] as num).toDouble();
      double max = (sonucMap['maksimumButce'] as num).toDouble();
      double ort = (sonucMap['muhtemelButce'] as num).toDouble();
      double komisyon = (sonucMap['komisyonTutari'] as num).toDouble();

      return {
        "min": min,
        "ort": ort,
        "max": max,
        "komisyon": komisyon,
        "aralikliMetin": formatliAralik(min, max),
        "tekilMetin": formatliFiyat(ort),
        "tamMap": sonucMap,
      };
    } catch (e) {
      debugPrint("Aralikli Hesaplama Hatasi: $e");
      return {
        "min": 3500.0,
        "ort": 5000.0,
        "max": 7500.0,
        "komisyon": 55.0,
        "aralikliMetin": "3.500 - 7.500 ₺",
        "tekilMetin": "5.000 ₺",
        "hata": e.toString()
      };
    }
  }
}