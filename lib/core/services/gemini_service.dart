// lib/core/services/gemini_service.dart

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class GeminiService {
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? "";

  GenerativeModel _getModel() {
    return GenerativeModel(
      model: 'models/gemini-3.1-flash-lite',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.0, // Deterministik, yaratıcılık yok.
        maxOutputTokens: 15, // Token'ı 15'e çektik, konuşmasına imkan yok.
        topP: 0.1,
        topK: 1,
      ),
    );
  }

  Future<String> getFiyatTahmini({
    required String musteriId,
    required String isAdi,
    required String kategoriAdi,
    required String kategoriId,
    Map<String, dynamic>? detaylar,
  }) async {
    try {
      final model = _getModel();
      String teknikDetaylar = detaylar?.entries
          .map((e) => "${e.key.toUpperCase()}: ${e.value}")
          .join(", ") ?? "Belirtilmedi";

      final prompt = """
Rol: Türkiye inşaat ve hizmet sektöründe uzman, piyasa birim fiyatlarına hakim bir Maliyet Analistisin.

Görev: $isAdi ($kategoriAdi) işi için malzeme ve işçilik dahil anahtar teslim maliyeti hesapla.

GİRDİLER:
- İş: $isAdi
- Kategori: $kategoriAdi
- Detaylar: $teknikDetaylar

ANALİZ VE HESAPLAMA ADIMLARI:
1. Verilen detayları standart Türkiye piyasa birim fiyatları ile eşleştir.
2. Bölgesel değişkenleri ve malzeme kalitesini (yoksa standart varsay) hesaba kat.
3. Toplam maliyeti tam sayı olarak belirle.

KURALLAR (KESİN UYULACAK):
- SADECE bir tamsayı sonucu döndür.
- Asla açıklama, TL, birim, aralık veya sembol ekleme.
- Çıktı sadece ve sadece rakamlardan oluşmalı.
- Eğer detaylar yetersizse en makul standart piyasa değerini uygula.
- Hesaplaman mantıksal bir birim fiyata dayanmalı.
-GÖNDERİLEN TÜM DETAYLARI KESİN BAZ AL, HİÇBİR VERİYİ GÖZARDI ETME VE HESAPLAMAYI SADECE BU DETAYLARIN TOPLAM MALİYETİ ÜZERİNE KUR.

Örnek Çıktı:
45000

Şimdi sonucu üret:
""";

      final response = await model.generateContent([Content.text(prompt)]);
      String rawText = response.text?.trim() ?? "0";

      final String? formatliFiyat = _formatSafePrice(rawText);

      if (formatliFiyat == null) throw Exception("AI geçersiz veya yasaklı format üretti");

      return formatliFiyat;

    } catch (e) {
      debugPrint("❌ AI SERVİS HATASI: $e");
      throw Exception("AI başarısız");
    }
  }

  String? _formatSafePrice(String text) {
    // Sadece rakamlar kalsın, aradaki her türlü çöpü (boşluk, nokta, vs) temizle
    String clean = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) return null;

    int? price = int.tryParse(clean);

    // 1.000 TL altı (belirsiz) veya 100.000.000 TL üstü (saçmalama) ise hata fırlat.
    if (price == null || price < 1000 || price > 100000000) {
      return null;
    }

    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} ₺";
  }
}