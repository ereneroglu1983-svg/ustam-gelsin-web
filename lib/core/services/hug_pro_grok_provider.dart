// lib/core/services/hug_pro_grok_provider.dart - HUG PRO - %4 CANONICAL - FINAL
// HUG = HEMEN USTAM GELSIN = BÜTÜN PROJE
// HUG PRO = YENİ ÖZELLİK - BU DOSYA SADECE HUG PRO İÇİN!
// ESKİ grok_provider.dart KOPYA ALINDI, YENİ JSON FORMATI İÇİN REVİZE EDİLDİ
// ESKİ SİSTEME DOKUNMA!

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'hug_pro_grok_service.dart';

class HugProGrokProvider {
  final HugProGrokService _grokService = HugProGrokService();

  Future<Map<String, dynamic>> getHugProDegerleme({
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
    try {
      debugPrint("👑 [HUG PRO PROVIDER] Degerleme isteniyor: $yapiTuruId | $il/$ilce | detay:${detaylar.length}");

      final result = await _grokService.hugProDegerlemeAl(
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

      if (result == null) {
        throw Exception("HUG PRO GROK null döndürdü");
      }

      // JSON VALIDATION - Senin prompttaki kurallar
      _validateHugProJson(result);

      debugPrint("👑✅ [HUG PRO PROVIDER BAŞARILI] ${result['services']?.length ?? 0} hizmet | Toplam HUG: ${result['total']?['hug_access_fee_total_tl']} TL");

      return result;
    } catch (e) {
      debugPrint("❌ [HUG PRO PROVIDER HATASI] $e");
      rethrow;
    }
  }

  void _validateHugProJson(Map<String, dynamic> json) {
    // schema_version
    if (json['schema_version'] != '1.0') {
      debugPrint("⚠ [HUG PRO VALIDATION] schema_version 1.0 değil: ${json['schema_version']}");
    }

    // currency
    if (json['currency'] != 'TRY') {
      debugPrint("⚠ [HUG PRO VALIDATION] currency TRY değil: ${json['currency']}");
    }

    // services
    final services = json['services'] as List?;
    if (services == null || services.isEmpty) {
      throw Exception("services boş veya yok");
    }

    for (final svc in services) {
      final min = (svc['min_tl'] as num?)?.toInt() ?? 0;
      final est = (svc['estimated_tl'] as num?)?.toInt() ?? 0;
      final max = (svc['max_tl'] as num?)?.toInt() ?? 0;
      final hugFee = (svc['hug_access_fee_tl'] as num?)?.toInt() ?? 0;
      final rate = (svc['hug_access_rate'] as num?)?.toDouble() ?? 0;

      // min <= est <= max
      if (!(min <= est && est <= max)) {
        debugPrint("⚠ [HUG PRO VALIDATION] ${svc['service_name']}: min<=est<=max ihlali: $min <= $est <= $max");
      }

      // hug_access_fee = est * 0.04
      final expectedFee = (est * 0.04).round();
      if ((hugFee - expectedFee).abs() > 2) {
        debugPrint("⚠ [HUG PRO VALIDATION] ${svc['service_name']}: HUG fee %4 değil: $hugFee vs beklenen $expectedFee, düzeltiliyor");
        svc['hug_access_fee_tl'] = expectedFee;
      }

      // rate 0.04
      if ((rate - 0.04).abs() > 0.001) {
        debugPrint("⚠ [HUG PRO VALIDATION] ${svc['service_name']}: rate 0.04 değil: $rate");
        svc['hug_access_rate'] = 0.04;
      }
    }

    // total
    final total = json['total'] as Map<String, dynamic>?;
    if (total != null) {
      int calcEstTotal = 0;
      int calcFeeTotal = 0;
      for (final svc in services) {
        if (svc['status'] == 'estimated') {
          calcEstTotal += (svc['estimated_tl'] as num?)?.toInt() ?? 0;
          calcFeeTotal += (svc['hug_access_fee_tl'] as num?)?.toInt() ?? 0;
        }
      }
      final jsonEstTotal = (total['estimated_tl'] as num?)?.toInt() ?? 0;
      final jsonFeeTotal = (total['hug_access_fee_total_tl'] as num?)?.toInt() ?? 0;

      if ((calcEstTotal - jsonEstTotal).abs() > 10) {
        debugPrint("⚠ [HUG PRO VALIDATION] total.estimated_tl uyuşmuyor: hesap $calcEstTotal vs json $jsonEstTotal");
      }
      if ((calcFeeTotal - jsonFeeTotal).abs() > 10) {
        debugPrint("⚠ [HUG PRO VALIDATION] total.hug_access_fee_total_tl uyuşmuyor: hesap $calcFeeTotal vs json $jsonFeeTotal, düzeltiliyor");
        total['hug_access_fee_total_tl'] = calcFeeTotal;
      }
    }
  }
}
