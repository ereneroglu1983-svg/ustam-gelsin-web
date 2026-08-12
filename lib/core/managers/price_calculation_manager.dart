// lib/core/managers/price_calculation_manager.dart - REVİZE FİNAL V12 - MÜHÜRLÜ - HATASIZ
// GÖREVİ: HESAPLA emriyle ORKESTRA'ya koşar, gelen ham fiyatı süsler, ilan detay ekranına atar
import 'dart:async';
import 'package:flutter/material.dart';
import '../calculation/butce_orkestra_servisi.dart';

class PriceCalculationManager {
  static double fiyatTemizle(String fiyat) {
    if (fiyat.isEmpty) return 0.0;
    try {
      String temizlenmis = fiyat.trim().replaceAll(RegExp(r'[^0-9.,]'), '');
      if (temizlenmis.contains(',') && temizlenmis.contains('.')) {
        temizlenmis = temizlenmis.replaceAll('.', '').replaceAll(',', '.');
      } else if (temizlenmis.contains(',')) {
        temizlenmis = temizlenmis.replaceAll(',', '.');
      } else if (temizlenmis.contains('.')) {
        List<String> parcalar = temizlenmis.split('.');
        if (parcalar.length > 2 || (parcalar.length == 2 && parcalar[1].length == 3)) {
          temizlenmis = temizlenmis.replaceAll('.', '');
        }
      }
      return double.tryParse(temizlenmis)?? 0.0;
    } catch (e) {
      final fallbackTemiz = fiyat.replaceAll(RegExp(r'[^0-9]'), '');
      return double.tryParse(fallbackTemiz)?? 0.0;
    }
  }

  Future<Map<String, dynamic>> orkestraFiyatHesapla({
    required String userId,
    required String talepId,
    required String baslik,
    required String kategori,
    required String kategoriId,
    required Map<String, dynamic> detaylar,
    required String bolgeKodu,
  }) async {
    List<Map<String, dynamic>> cevapListesi = detaylar.entries
        .map((e) => {"id": e.key, "cevap": e.value})
        .toList();

    debugPrint("💲 [PRICE] HESAPLA TETİKLENDİ | başlık:$baslik | kategori:$kategori ($kategoriId) | bölge:$bolgeKodu");

    try {
      final Map<String, dynamic> orkestraRapor = await ButceOrkestraServisi.silsileYurut(
        talepId: talepId,
        kategoriAdi: kategori,
        kategoriId: kategoriId,
        ilanBasligi: baslik, // ✅ 1. KRİTİK FIX - GERÇEK BAŞLIK ARTIK GROK'A GİDİYOR
        kullaniciCevaplari: cevapListesi,
        yerelHafizaVerisi: {"ilId": bolgeKodu}, // ✅ 2. KRİTİK FIX - ilId ARTIK BOŞ GİTMİYOR, CACHE ÇALIŞACAK
        anlikBolgeKodu: bolgeKodu,
        anlikKullaniciSegmenti: "standart",
      );

      final Map<String, dynamic> robotSonuc = Map<String, dynamic>.from(orkestraRapor['robotSonucu']?? {});

      if (robotSonuc['minimumButce'] == null || robotSonuc['maksimumButce'] == null || robotSonuc['muhtemelButce'] == null) {
        throw Exception("Orkestra eksik veri döndü: $robotSonuc");
      }

      double min = (robotSonuc['minimumButce'] as num).toDouble();
      double ort = (robotSonuc['muhtemelButce'] as num).toDouble();
      double max = (robotSonuc['maksimumButce'] as num).toDouble();
      String kaynak = robotSonuc['kaynak']?.toString()?? 'BILINMEYEN';

      String formatla(double n) {
        return n.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
      }

      String aralikliFiyat = "${formatla(min)} - ${formatla(max)} ₺";
      String tekilFiyat = "${formatla(ort)} ₺";

      // İKONLU LOG
      String ikon = "❓";
      if (kaynak.contains("FIREBASE")) ikon = "💾";
      else if (kaynak.contains("GROK")) ikon = "👑";
      else if (kaynak.contains("GROQ")) ikon = "⚡";
      else if (kaynak.contains("LLAMA")) ikon = "🦙";
      else if (kaynak.contains("YEREL")) ikon = "🦾";

      debugPrint("$ikon✅ [PRICE <- ORKESTRA BAŞARILI] $kategoriId | $aralikliFiyat | Kaynak: $kaynak | Başlık: $baslik");

      return {
        "basarili": true,
        "kaynak": kaynak,
        "minimumButce": min,
        "muhtemelButce": ort,
        "maksimumButce": max,
        "fiyatBilgisi": tekilFiyat,
        "aralikliFiyatBilgisi": aralikliFiyat,
        "tamRapor": orkestraRapor,
      };
    } catch (e, stack) {
      debugPrint("❌ [PRICE - ORKESTRA ÇÖKTÜ] $e\n$stack");
      rethrow;
    }
  }

  String formatFiyatGosterim(String text) {
    if (text.contains('₺')) return text;
    return "$text ₺";
  }
}