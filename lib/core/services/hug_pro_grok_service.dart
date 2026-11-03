// lib/core/services/hug_pro_grok_service.dart - HUG PRO - %4 CANONICAL - FINAL
// HUG = HEMEN USTAM GELSIN = BÜTÜN PROJE
// HUG PRO = YENİ ÖZELLİK - BU DOSYA SADECE HUG PRO İÇİN!
// ESKİ SİSTEME (grok_service.dart, grok_provider.dart, butce_orkestra_servisi.dart) DOKUNMA!
// KOPYA MANTIK: grok_service.dart'dan kopyalandı, prompt değiştirildi

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:http/http.dart' as http;
import 'hug_pro_system_prompt.dart';

class HugProGrokService {
  static const String _apiUrl = "https://api.x.ai/v1/chat/completions";
  static const String _model = "grok-4.5";

  String get _apiKey {
    try {
      final raw = Env.xaiApiKey;
      return raw.trim().replaceAll('"', '').replaceAll("'", "").trim();
    } catch (_) {
      return '';
    }
  }

  Future<Map<String, dynamic>?> hugProDegerlemeAl({
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
    debugPrint("👑 [HUG PRO GROK] Key var mı=${_apiKey.isNotEmpty} | len=${_apiKey.length}");

    if (_apiKey.isEmpty) {
      throw Exception("XAI_API_KEY .env'de bulunamadı!");
    }

    final userPayload = """
PROJE BİLGİLERİ (GERÇEK MÜŞTERİ VERİSİ - HUG PRO):

yapiTuruId: $yapiTuruId
sablonBaslik: ${sablonBaslik ?? ""}
asama: $asama
il: $il, ilce: $ilce
olcek: ${jsonEncode(olcek)}
detaylar: ${jsonEncode(detaylar)}
aciklama: $aciklama
ihtiyacIds: ${ihtiyacIds.join(", ")}

Bu verilere göre profesyonel hizmet bedellerini ve %4 HUG PRO erişim bedellerini hesapla.
Yalnızca geçerli JSON döndür. Markdown yazma.
""";

    try {
      debugPrint("👑 [HUG PRO GROK İSTEK] Model: $_model | yapiTuru: $yapiTuruId | detay: ${detaylar.length} alan");

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": _model,
          "messages": [
            {"role": "system", "content": HugProSystemPrompt.prompt},
            {"role": "user", "content": userPayload}
          ],
          "temperature": 0.2,
          "response_format": {"type": "json_object"},
          "stream": false,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        String content = data['choices'][0]['message']['content'].toString().trim();
        debugPrint("👑✅ [HUG PRO GROK BAŞARILI] RAW: ${content.substring(0, content.length > 600 ? 600 : content.length)}...");

        try {
          final Map<String, dynamic> valuation = jsonDecode(content);

          // %4 KONTROL + DÜZELTME - GROK YANLIŞ HESAPLARSA
          if (valuation['services'] != null) {
            for (final svc in valuation['services']) {
              if (svc['estimated_tl'] != null) {
                final est = (svc['estimated_tl'] is num) ? svc['estimated_tl'] as num : 0;
                final expected = (est * 0.04).round();
                if (svc['hug_access_fee_tl'] == null || (svc['hug_access_fee_tl'] - expected).abs() > 2) {
                  svc['hug_access_fee_tl'] = expected;
                }
                svc['hug_access_rate'] = 0.04;
              }
            }
            // total.hug_access_fee_total_tl düzelt
            if (valuation['total'] != null) {
              int totalFee = 0;
              for (final svc in valuation['services']) {
                if (svc['status'] == 'estimated' && svc['hug_access_fee_tl'] != null) {
                  totalFee += (svc['hug_access_fee_tl'] as num).toInt();
                }
              }
              valuation['total']['hug_access_fee_total_tl'] = totalFee;
              valuation['total']['hug_access_rate'] = 0.04;
            }
          }

          return valuation;
        } catch (e) {
          debugPrint("👑❌ [HUG PRO GROK JSON PARSE HATA] $e | RAW: $content");
          return null;
        }
      } else {
        debugPrint("👑❌ [HUG PRO GROK HATA] ${response.statusCode}: ${response.body}");
        if (response.statusCode == 401) throw Exception("GROK KEY HATALI (401)");
        if (response.statusCode == 429) throw Exception("GROK BAKİYE BİTTİ (429)");
        throw Exception("HUG PRO GROK Hata: ${response.statusCode} - ${response.body}");
      }
    } catch (e, s) {
      debugPrint("👑❌ [HUG PRO GROK EXCEPTION] $e");
      debugPrint("👑 [STACK] ${s.toString().substring(0, 400)}");
      rethrow;
    }
  }
}
