// lib/core/constants/yorum_motoru.dart

import 'package:ustam_gelsin/services/yorum_service.dart';

class YorumMotoru {
  /// Meslek ismine göre her zaman tutarlı, rastgele görünse de
  /// mesleğe özel aynı verileri döndüren motor.
  static List<Map<String, String>> yorumlariGetir(String meslekIsmi) {
    // 1. Meslek isminden benzersiz bir sayısal imza (seed) oluştur
    int seed = meslekIsmi.codeUnits.reduce((a, b) => a + b);

    // 2. Rastgele yorum sayısı belirle (1 ile 5 arasında)
    int yorumSayisi = 1 + (seed % 5);

    // 3. Yorum üretme mantığı
    return List.generate(yorumSayisi, (i) {
      // Listelerin boş gelme ihtimaline karşı güvenlik kontrolü
      if (YorumService.isimler.isEmpty ||
          YorumService.yorumlar.isEmpty ||
          YorumService.dogruKonumlar.isEmpty) {
        return {
          "isim": "Müşteri",
          "yorum": "Henüz yorum yapılmadı.",
          "puan": "5.0",
          "sehir": "Türkiye"
        };
      }

      // İndeksleri hesapla
      int isimIdx = (seed + i) % YorumService.isimler.length;
      int yorumIdx = (seed + i * 13) % YorumService.yorumlar.length;
      int konumIdx = (seed + i * 17) % YorumService.dogruKonumlar.length;

      var konum = YorumService.dogruKonumlar[konumIdx];

      // Puan Hesaplama: 3.9 ile 5.0 arasında (39 + rastgele kalan) / 10
      double puan = 3.9 + ((seed + i * 7) % 12) / 10.0;

      return {
        "isim": YorumService.isimler[isimIdx],
        "yorum": YorumService.yorumlar[yorumIdx],
        "puan": puan.toStringAsFixed(1),
        "sehir": "${konum['sehir']} / ${konum['ilce']}"
      };
    });
  }
}