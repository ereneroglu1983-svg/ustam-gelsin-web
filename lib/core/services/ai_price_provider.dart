// lib/core/services/ai_price_provider.dart
// Sigorta Kutusu - Bütün AI sağlayıcılar buna uymak zorunda

abstract class AiPriceProvider {
  Future<String> getFiyatTahmini({
    required String musteriId,
    required String isAdi,
    required String kategoriAdi,
    required String kategoriId,
    Map<String, dynamic>? detaylar,
  });

  String get providerName; // log için: groq, gemini, openai...
}