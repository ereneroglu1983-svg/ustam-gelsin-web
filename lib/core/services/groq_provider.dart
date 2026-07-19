// lib/core/services/groq_provider.dart
import 'package:intl/intl.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'ai_price_provider.dart';

class GroqProvider implements AiPriceProvider {
  @override
  String get providerName => "groq_llama31_8b";

  final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(region: 'europe-west3');

  @override
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

    final callable = _functions.httpsCallable(
      'hesaplaFiyat',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 20)),
    );

    final result = await callable.call(<String, dynamic>{
      'isAdi': isAdi,
      'kategoriAdi': kategoriAdi,
      'kategori': kategoriId,
      'teknikDetaylar': teknikDetaylar,
      'ilanMetni': isAdi,
    });

    String rawText = result.data['fiyat']?.toString().trim() ?? "";
    final formatli = _formatSafePrice(rawText);
    if (formatli == null) throw Exception("Geçersiz fiyat: $rawText");
    return formatli;
  }

  String? _formatSafePrice(String text) {
    String cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
    int? price = int.tryParse(cleaned);
    if (price == null || price < 1000 || price > 100000000) return null;
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} ₺";
  }
}