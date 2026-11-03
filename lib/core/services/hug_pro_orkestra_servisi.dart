// lib/core/calculation/hug_pro_orkestra_servisi.dart - HUG PRO - %4 CANONICAL - FINAL v2.0
// HUG = HEMEN USTAM GELSIN = BÜTÜN PROJE (eski sistem - 5 katmanlı)
// HUG PRO = YENİ ÖZELLİK - BU DOSYA SADECE HUG PRO İÇİN! (2 katmanlı - GROK -> LLAMA)
// ESKİ ButceOrkestraServisi KOPYA ALINDI, SADECE AI'LAR KALDI
// ESKİ SİSTEME DOKUNMA!

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../services/hug_pro_grok_provider.dart';

class HugProOrkestraServisi {
  static final HugProGrokProvider _grok = HugProGrokProvider();

  // HUG PRO - 2 KATMANLI WATERFALL (GROK -> LLAMA)
  static Future<Map<String, dynamic>> silsileYurut({
    required String projeId,
    required String yapiTuruId,
    required String asama,
    required Map<String, String> olcek,
    required Map<String, dynamic> detaylar,
    required String il,
    required String ilce,
    required String aciklama,
    required List<String> ihtiyacIds,
    String? sablonBaslik,
  }) async {
    debugPrint("🎼 ========== [HUG PRO ORKESTRA BAŞLADI] ==========");
    debugPrint("📋 [GİREN] PROJE: $projeId | YAPI: $yapiTuruId | AŞAMA: $asama | İL: $il/$ilce | DETAY: ${detaylar.length} alan");

    // 1. KATMAN: GROK (ANA - %4 PROMPTLU)
    try {
      debugPrint("👑 [1.HUG PRO GROK DENENİYOR] $yapiTuruId | ${detaylar.length} detay");
      final result = await _grok.getHugProDegerleme(
        yapiTuruId: yapiTuruId,
        asama: asama,
        olcek: olcek,
        detaylar: detaylar,
        il: il,
        ilce: ilce,
        aciklama: aciklama,
        ihtiyacIds: ihtiyacIds,
        sablonBaslik: sablonBaslik,
      );

      debugPrint("👑✅ [1.HUG PRO GROK BAŞARILI!] ${result['services']?.length ?? 0} hizmet | HUG Toplam: ${result['total']?['hug_access_fee_total_tl']} TL | KAYNAK: HUG_PRO_GROK");
      debugPrint("🎼 ========== [HUG PRO ORKESTRA BİTTİ - GROK] ==========");

      return {
        "valuation": result,
        "kaynak": "HUG_PRO_GROK",
        "projeId": projeId,
        "durum": "BASARILI",
      };
    } catch (e, stack) {
      debugPrint("👑❌ [1.HUG PRO GROK HATA] $e | Stack: ${stack.toString().substring(0, 300)}");
      debugPrint("👑➡ [1.HUG PRO GROK] Hata, 🦙 LLAMA'ya geçiliyor");
    }

    // 2. KATMAN: LLAMA (YEDEK - SON KALE)
    try {
      debugPrint("🦙 [2.HUG PRO LLAMA DENENİYOR] $yapiTuruId");

      final llamaResult = await _llamaHugProYedek(
        yapiTuruId: yapiTuruId,
        asama: asama,
        olcek: olcek,
        detaylar: detaylar,
        il: il,
        aciklama: aciklama,
      );

      debugPrint("🦙✅ [2.HUG PRO LLAMA BAŞARILI!] HUG Toplam: ${llamaResult['total']?['hug_access_fee_total_tl']} TL | KAYNAK: HUG_PRO_LLAMA");
      debugPrint("🎼 ========== [HUG PRO ORKESTRA BİTTİ - LLAMA] ==========");

      return {
        "valuation": llamaResult,
        "kaynak": "HUG_PRO_LLAMA",
        "projeId": projeId,
        "durum": "BASARILI",
      };
    } catch (e, stack) {
      debugPrint("🦙❌ [2.HUG PRO LLAMA HATA] $e | Stack: ${stack.toString().substring(0, 300)}");
      debugPrint("🦙💥 [HUG PRO ORKESTRA TAMAMEN ÇÖKTÜ!]");
      debugPrint("🎼 ========== [HUG PRO ORKESTRA BİTTİ - ÇÖKÜŞ] ==========");
      rethrow;
    }
  }

  // LLAMA YEDEK - HUG PRO İÇİN BASİT JSON ÜRETİMİ - SABİT YOK!
  static Future<Map<String, dynamic>> _llamaHugProYedek({
    required String yapiTuruId,
    required String asama,
    required Map<String, String> olcek,
    required Map<String, dynamic> detaylar,
    required String il,
    required String aciklama,
  }) async {
    const apiKey = String.fromEnvironment('OPENROUTER_API_KEY');
    if (apiKey.isEmpty) throw Exception("OPENROUTER_API_KEY_YOK - --dart-define ile verilmedi");

    final detayStr = detaylar.entries.map((e) => "${e.key}:${e.value}").join(", ");
    final prompt = """
HUG PRO - Profesyonel hizmet değerleme. Sadece JSON döndür. Sabit fiyat kullanma, piyasadan hesapla!

yapiTuruId: $yapiTuruId
asama: $asama
olcek: ${jsonEncode(olcek)}
detaylar: $detayStr
il: $il
aciklama: $aciklama

GÖREV:
- Türkiye 2025-2026 güncel piyasa rayiçlerine göre profesyonel hizmet bedelini hesapla
- Her hizmet için min = estimated * 0.85, max = estimated * 1.15 olacak şekilde makas %30'u geçmesin
- hug_access_fee_tl = estimated * 0.04 olarak hesapla
- Sadece JSON döndür, açıklama yazma, sabit örnek kopyalama!

DÖNÜŞ FORMATI:
{
  "schema_version": "1.0",
  "currency": "TRY",
  "project_summary": {"building_type": "$yapiTuruId", "stage": "$asama", "location": {"city": "$il", "district": ""}, "construction_area_m2": 0, "land_area_m2": 0, "floor_count": 0, "summary": "$aciklama"},
  "services": [
    {"service_id": "MIMARI_PROJE", "service_name": "Mimar", "status": "estimated", "min_tl": 0, "estimated_tl": 0, "max_tl": 0, "hug_access_fee_tl": 0, "hug_access_rate": 0.04, "vat_included": false, "scope": "", "pricing_basis": "2025-2026 piyasa rayici", "assumptions": [], "missing_information": [], "confidence": "medium"}
  ],
  "total": {"min_tl": 0, "estimated_tl": 0, "max_tl": 0, "hug_access_fee_total_tl": 0},
  "general_assumptions": [],
  "market_research_date": "${DateTime.now().toIso8601String()}"
}

Yukarıdaki 0 değerlerini gerçek piyasa verisiyle doldur, sabit bırakma!
""";

    final res = await http.post(
      Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://hemenustamgelsin.com",
        "X-Title": "HemenUstamGelsin-HUG-PRO",
      },
      body: jsonEncode({
        "model": "meta-llama/llama-3.3-70b:free",
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.2,
        "max_tokens": 2000
      }),
    );

    if (res.statusCode != 200) throw Exception("LLAMA_HUG_PRO_HATA ${res.statusCode}: ${res.body}");

    final raw = jsonDecode(res.body)['choices'][0]['message']['content'].toString();
    debugPrint("🦙 [HUG PRO LLAMA RAW] $raw");

    final jsonStart = raw.indexOf('{');
    final jsonEnd = raw.lastIndexOf('}');
    if (jsonStart == -1 || jsonEnd == -1) throw Exception("LLAMA HUG PRO JSON yok: $raw");

    final jsonStr = raw.substring(jsonStart, jsonEnd + 1);
    final Map<String, dynamic> valuation = jsonDecode(jsonStr);

    if (valuation['services'] != null) {
      for (final svc in valuation['services']) {
        if (svc['estimated_tl'] != null) {
          svc['hug_access_fee_tl'] = ((svc['estimated_tl'] as num) * 0.04).round();
          svc['hug_access_rate'] = 0.04;
        }
      }
    }

    return valuation;
  }
}