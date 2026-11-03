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

  // YENİ - HUGAI PROFESYONEL HİZMET DEĞERLEME MOTORU (v1.0 - %4 SABİT)
  Future<Map<String, dynamic>?> hugAiDegerlemeAl({
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
      final HttpsCallable callable = _functions.httpsCallable('hugAiDegerleme');

      final results = await callable.call(<String, dynamic>{
        'yapiTuruId': yapiTuruId,
        'asama': asama,
        'olcek': olcek,
        'detaylar': detaylar,
        'il': il,
        'ilce': ilce,
        'aciklama': aciklama,
        'ihtiyacIds': ihtiyacIds,
        'sablonBaslik': sablonBaslik ?? '',
        'schema_version': '1.0',
      });

      if (results.data['success'] == true) {
        // Grok JSON döndürüyor
        final data = results.data['valuation'] ?? results.data['analiz'];
        if (data is Map<String, dynamic>) {
          return data;
        }
        // String geldiyse parse etmeyi backend yapacak, burada Map dönmüyorsa null
        return null;
      } else {
        print("HUGAI HATA: ${results.data['error']}");
        return null;
      }
    } catch (e) {
      print("HUGAI DETAYLI HATA: $e");
      return null;
    }
  }
}
