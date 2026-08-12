// lib/core/providers/grok_provider.dart - FINAL V6 - DERLENİR 10/10
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../services/grok_service.dart';

class GrokProvider {
  final GrokService _grokService = GrokService();

  Future<String> getFiyatTahmini({
    required String isAdi,
    required String kategoriAdi,
    required String kategoriId,
    Map<String, dynamic>? detaylar,
  }) async {
    String teknikDetaylar = detaylar?.entries
        .map((e) => "${e.key.toUpperCase()}: ${e.value}")
        .join(", ") ??
        "Belirtilmedi";

    final prompt = """
Sen Türkiye'de inşaat, tadilat ve teknik hizmetlerin piyasa fiyatlarını bilen uzman bir maliyet analiz motorusun.

Kategori:
$kategoriAdi

Kategori ID:
$kategoriId

İş Tanımı:
$isAdi

Teknik Detaylar:
$teknikDetaylar

Görev:

Türkiye 2026 piyasa koşullarına göre bu iş için tek bir gerçekçi ortalama fiyat hesapla.

Kurallar:

- Sadece Türkiye fiyatlarını kullan.
- USD, EUR veya yabancı piyasa kullanma.
- Açıklama yazma.
- Gerekçe yazma.
- Metin yazma.
- Tahmin aralığı verme.
- Sadece tek fiyat üret.
- Fiyat 1000 ile 100000000 arasında olmalı.

SADECE aşağıdaki JSON'u döndür.

{
  "price": 35000
}
""";

    try {
      String rawText = await _grokService.sendPrompt(prompt: prompt);

      final data = jsonDecode(rawText) as Map<String, dynamic>;

      if (!data.containsKey("price")) {
        throw Exception("price alanı bulunamadı. Gelen JSON: $rawText");
      }

      final rawPrice = data["price"];
      // ✅ PARANTEZ FIXLENDİ - SENİN DEDİĞİN GİBİ
      final intPrice = rawPrice is num
          ? rawPrice.toInt()
          : (int.tryParse(
        rawPrice.toString().replaceAll(RegExp(r'[^0-9]'), ''),
      ) ??
          0);

      if (intPrice == 0) {
        throw Exception("price parse edilemedi: $rawPrice");
      }

      final priceStr = intPrice.toString();

      final formatli = _formatSafePrice(priceStr);
      if (formatli == null) {
        throw Exception("Grok geçersiz fiyat döndü: $rawText");
      }

      debugPrint("✅ [GROK PROVIDER BAŞARILI] $kategoriAdi -> $formatli");
      return formatli;
    } catch (e) {
      debugPrint("❌ GROK PROVIDER HATASI: $e");
      rethrow;
    }
  }

  String? _formatSafePrice(String text) {
    String cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
    int? price = int.tryParse(cleaned);
    if (price == null || price < 1000 || price > 100000000) return null;
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} ₺";
  }
}