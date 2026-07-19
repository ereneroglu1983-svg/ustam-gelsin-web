// lib/core/services/groq_service.dart

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:cloud_functions/cloud_functions.dart';

class GroqService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'europe-west3');

  Future<String> getFiyatTahmini({
    required String musteriId,
    required String isAdi,
    required String kategoriAdi,
    required String kategoriId,
    Map<String, dynamic>? detaylar,
  }) async {

    String teknikDetaylar = detaylar?.entries
        .map((e) => "${e.key.toUpperCase()}: ${e.value}")
        .join(", ") ??
        "Belirtilmedi";

    try {
      // Artık direkt Groq'a değil, SENİN GÜVENLİ FUNCTION'INA vuruyoruz
      final callable = _functions.httpsCallable(
        'hesaplaFiyat',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 20)), // Groq hızlı, 60sn gerek yok
      );

      final result = await callable.call(<String, dynamic>{
        'isAdi': isAdi,
        'kategoriAdi': kategoriAdi,
        'kategori': kategoriId,
        'teknikDetaylar': teknikDetaylar,
        'ilanMetni': isAdi,
        'motor': 'groq_llama31' // index.js'e "ben Groq istiyorum" sinyali
      });

      String rawText = result.data['fiyat']?.toString().trim() ?? "";
      final formatli = _formatSafePrice(rawText);
      if (formatli == null) throw Exception("Function geçersiz döndü: $rawText");

      debugPrint("✅ [GROQ-FUNCTION BAŞARILI] $kategoriAdi -> $formatli");
      return formatli;

    } on FirebaseFunctionsException catch (e) {
      debugPrint("❌ FUNCTION HATASI ${e.code}: ${e.message} - Yerel robota düşülecek");
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