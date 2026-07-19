// lib/core/managers/price_calculation_manager.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../calculation/butce_orkestra_servisi.dart';

class PriceCalculationManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sadece gösterim için - Orkestra zaten 35.000 - 45.000 aralığını veriyor
  static double fiyatTemizle(String fiyat) => double.tryParse(fiyat.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;

  /// TEK GİRİŞ NOKTASI - Tüm hesaplama buradan yürüyecek
  /// Eski tek String yerine artık aralıklı String döndürür: "35.000 - 45.000 ₺"
  Future<Map<String, dynamic>> orkestraFiyatHesapla({
    required String userId,
    required String talepId,
    required String baslik,
    required String kategori,
    required String kategoriId,
    required Map<String, dynamic> detaylar,
    required String bolgeKodu,
  }) async {
    // Detayları orkestranın beklediği formata çevir
    // detaylar: { "soru_id": "cevap" } -> [ {id, cevap}, ... ]
    List<Map<String, dynamic>> cevapListesi = detaylar.entries.map((e) => {
      "id": e.key,
      "cevap": e.value
    }).toList();

    // Yerel hafıza için geçici map - Silsile 1 için
    Map<String, dynamic> yerelHafiza = {};

    try {
      // TEK SİLSİLE - Orkestraya devret
      final Map<String, dynamic> orkestraRapor = await ButceOrkestraServisi.silsileYurut(
        talepId: talepId,
        kategoriAdi: kategori,
        kategoriId: kategoriId,
        kullaniciCevaplari: cevapListesi,
        yerelHafizaVerisi: yerelHafiza,
        anlikBolgeKodu: bolgeKodu,
        anlikKullaniciSegmenti: "standart",
      );

      final Map<String, dynamic> robotSonuc = Map<String, dynamic>.from(orkestraRapor['robotSonucu'] ?? {});

      double min = (robotSonuc['minimumButce'] as num?)?.toDouble() ?? 3000;
      double ort = (robotSonuc['muhtemelButce'] as num?)?.toDouble() ?? 5000;
      double max = (robotSonuc['maksimumButce'] as num?)?.toDouble() ?? 8000;

      // SENİN İSTEDİĞİN MANTIK: Komisyon = (min+max)/2 * %1
      double komisyonTabani = (min + max) / 2;
      double komisyon = komisyonTabani * 0.01;

      // Müşteriye gösterilecek metin
      String aralikliFiyat = "${min.toInt()} - ${max.toInt()} ₺";
      String tekilFiyat = "${ort.toInt()} ₺"; // Eski kodlar için geriye uyumlu

      debugPrint("✅ [ORKESTRA BAŞARILI] $kategoriId | $aralikliFiyat | Komisyon: $komisyon");

      return {
        "basarili": true,
        "kaynak": robotSonuc['kaynak'] ?? 'ORKESTRA',
        "minimumButce": min,
        "muhtemelButce": ort,
        "maksimumButce": max,
        "fiyatBilgisi": tekilFiyat, // Eski IlanModel için
        "aralikliFiyatBilgisi": aralikliFiyat, // Yeni gösterim için - FIX: ı -> i
        "komisyonTutari": komisyon,
        "komisyonTabani": komisyonTabani,
        "tamRapor": orkestraRapor,
      };
    } catch (e, stack) {
      debugPrint("❌ [ORKESTRA HATA] $e\n$stack");
      // En kötü senaryoda bile sistem çökmesin, sabit bir aralık ver
      return {
        "basarili": false,
        "minimumButce": 3500.0,
        "muhtemelButce": 5000.0,
        "maksimumButce": 7500.0,
        "fiyatBilgisi": "5000 ₺",
        "aralikliFiyatBilgisi": "3500 - 7500 ₺", // FIX: ı -> i
        "komisyonTutari": 55.0, // (3500+7500)/2 * 0.01
        "komisyonTabani": 5500.0,
        "hata": e.toString(),
      };
    }
  }

  /// ESKİ KODLARIN ÇAĞIRDIĞI String döndüren fonksiyon - Geriye uyum için duruyor
  /// Yeni kodlar Map döndüren üstteki fonksiyonu kullanmalı
  @Deprecated("Yerine orkestraFiyatHesapla(Map döndüren) kullan")
  Future<String> eski_orkestraFiyatHesapla_String({
    required String userId,
    required String baslik,
    required String kategori,
    required String kategoriId,
    required Map<String, dynamic> detaylar,
  }) async {
    final sonuc = await orkestraFiyatHesapla(
      userId: userId,
      talepId: userId,
      baslik: baslik,
      kategori: kategori,
      kategoriId: kategoriId,
      detaylar: detaylar,
      bolgeKodu: "diger",
    );
    return sonuc['aralikliFiyatBilgisi'] as String;
  }

  String formatFiyatGosterim(String text) {
    if (text.contains('₺')) return "Tahmini: $text";
    return "Tahmini: $text ₺";
  }
}