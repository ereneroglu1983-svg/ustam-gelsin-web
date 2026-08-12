// lib/core/services/grok_service.dart - FINAL V13 - MÜHÜRLÜ - ICON LOG
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:http/http.dart' as http;

class GrokService {
  static const String _apiUrl = "https://api.x.ai/v1/chat/completions";
  static const String _model = "grok-4.5";

  String get _apiKey {
    try {
      // ✅ ENVIED'DEN AL - GROQ İLE AYNI - TIRNAK, BOŞLUK TEMİZLİĞİ
      final raw = Env.xaiApiKey;
      return raw.trim().replaceAll('"', '').replaceAll("'", "").trim();
    } catch (_) {
      return '';
    }
  }

  Future<String> sendPrompt({
    required String prompt,
  }) async {
    debugPrint("👑 [GROK SERVICE] Key kontrol: var mı=${_apiKey.isNotEmpty} | len=${_apiKey.length} | start=${_apiKey.isNotEmpty? _apiKey.substring(0, 15) : 'YOK'}...");
    debugPrint("👑 [GROK SERVICE] Env.xaiApiKey yüklendi");

    if (_apiKey.isEmpty) {
      throw Exception("XAI_API_KEY.env dosyasında bulunamadı!.env kökte mi? Env.dart'ta @EnviedField var mı? build_runner çalıştı mı?");
    }

    try {
      debugPrint("👑 [GROK İSTEK] Model: $_model | Prompt: ${prompt.substring(0, prompt.length > 120? 120 : prompt.length)}...");

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": _model,
          "messages": [
            {
              "role": "system",
              "content": "Sen bir fiyat tahmin uzmanısın. Sadece JSON döndür: {\"fiyat\": 12345}. Açıklama yazma."
            },
            {"role": "user", "content": prompt}
          ],
          "temperature": 0.1,
          "max_tokens": 100,
          "stream": false,
        }),
      ).timeout(const Duration(seconds: 25));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        String content = data['choices'][0]['message']['content'].toString().trim();
        debugPrint("👑✅ [GROK SERVICE BAŞARILI] RAW: $content");
        return content;
      } else {
        debugPrint("👑❌ [GROK SERVICE HATA] ${response.statusCode}: ${response.body}");
        // 401 = Key hatalı, 429 = Bakiye bitti, 400 = Model hatalı
        if (response.statusCode == 401) throw Exception("GROK KEY HATALI (401) -.env'deki key'i kontrol et");
        if (response.statusCode == 429) throw Exception("GROK BAKİYE BİTTİ (429)");
        throw Exception("Grok Hata: ${response.statusCode} - ${response.body}");
      }
    } catch (e, s) {
      debugPrint("👑❌ [GROK SERVICE EXCEPTION] $e");
      debugPrint("👑 [STACK] ${s.toString().substring(0, 400)}");
      rethrow;
    }
  }
}