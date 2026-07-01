// lib/services/yorum_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';

class YorumService {
  static List<String> isimler = [];
  static List<String> yorumlar = [];
  static List<Map<String, String>> dogruKonumlar = [];

  static Future<void> loadData() async {
    try {
      // 1. İsim ve Yorumları Yükle
      final yorumResponse = await rootBundle.loadString('assets/data/yorumlar.json');
      final yorumData = json.decode(yorumResponse);

      isimler = List<String>.from(yorumData['isimler']);
      yorumlar = List<String>.from(yorumData['yorumlar']);

      // 2. Şehir ve İlçe Dosyalarını Yükle
      final sehirResponse = await rootBundle.loadString('assets/data/sehirler.json');
      final ilceResponse = await rootBundle.loadString('assets/data/ilceler.json');

      final List sehirler = json.decode(sehirResponse);
      final List ilceler = json.decode(ilceResponse);

      // 3. Doğru Eşleşmeyi Kur (Şehir-İlçe ID eşleşmesi)
      dogruKonumlar = ilceler.map((ilce) {
        final sehir = sehirler.firstWhere(
              (s) => s['sehir_id'] == ilce['sehir_id'],
          orElse: () => {'sehir_adi': 'Bilinmiyor'},
        );

        return {
          "sehir": sehir['sehir_adi'].toString(),
          "ilce": ilce['ilce_adi'].toString()
        };
      }).toList();

    } catch (e) {
      // Hata durumunda sistemin çökmemesi için varsayılan değerler
      isimler = ["Müşteri"];
      yorumlar = ["Yorum bulunamadı."];
      dogruKonumlar = [{"sehir": "Türkiye", "ilce": "Genel"}];
    }
  }
}