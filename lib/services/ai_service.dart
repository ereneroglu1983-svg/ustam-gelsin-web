// lib/services/ai_service.dart

import 'package:cloud_functions/cloud_functions.dart';

class AIService {
  // Console'da europe-west3 yazdığı için buraya MUTLAKA ekliyoruz
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'europe-west3');

  Future<String?> uzmanAnaliziAl({
    required String isTipi,
    required int metrekare,
    required String sehir,
    required String detay,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('hesaplauzmanai');

      final results = await callable.call(<String, dynamic>{
        'is_tipi': isTipi,
        'metrekare': metrekare,
        'sehir': sehir,
        'detay': detay,
      });

      if (results.data['success'] == true) {
        return results.data['analiz'] as String;
      } else {
        return "Analiz yapılamadı: ${results.data['error']}";
      }
    } catch (e) {
      print("DETAYLI HATA: $e");
      return "Bağlantı kurulamadı. Lütfen internetinizi kontrol edip tekrar deneyin.";
    }
  }

  // YENİ EKLENEN METOT
  Future<String?> uzmanAnaliziAlDinamik({
    required String isTipi,
    required String sehir,
    required Map<String, dynamic> detaylar,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('hesaplauzmanai');

      final results = await callable.call(<String, dynamic>{
        'is_tipi': isTipi,
        'sehir': sehir,
        'detaylar': detaylar,
      });

      if (results.data['success'] == true) {
        return results.data['analiz'] as String;
      } else {
        return "Analiz yapılamadı: ${results.data['error']}";
      }
    } catch (e) {
      print("DETAYLI HATA: $e");
      return "Bağlantı kurulamadı. Lütfen internetinizi kontrol edip tekrar deneyin.";
    }
  }
}