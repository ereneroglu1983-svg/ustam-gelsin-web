// lib/core/calculation/meslekler/pvc_dograma_hesaplayici.dart

class PvcDogramaHesaplayici {

  static Map<String, dynamic> hesapla(List<dynamic> gelenCevaplar) {

    String findValue(String anahtar, String varsayilan) {
      if (gelenCevaplar.isEmpty) return varsayilan;

      for (var element in gelenCevaplar) {
        if (element is Map && element.containsKey('id') && element['id'] == anahtar) {
          return element['cevap']?.toString() ?? varsayilan;
        }
        if (element is Map && element.containsKey(anahtar)) {
          return element[anahtar]?.toString() ?? varsayilan;
        }
      }
      return varsayilan;
    }

    final String isKapsami = findValue('is_kapsami', 'Sıfırdan İmalat ve Montaj (Yeni Yapı / Kaba İnşaat)');
    final String profilSerisi = findValue('profil_serisi', '70\'lik Seri (5 Odacıklı - Çift Conta Sistemli İdeal Ara Segment)');
    final String markaSegmenti = findValue('marka_segmenti', 'B Sınıfı Marka Segmenti (Adopen, Fıratpen vb. Standart Yerli)');
    final String camTipi = findValue('cam_tipi', 'Çift Cam (4+12+4 Standart Yalıtımlı Klasik Cam)');
    final String metretulSecim = findValue('metraj_metretul_secim', '11 - 25 Metretül Arası (Standart Daire / 3-5 Pencere)');
    final String camM2Secim = findValue('cam_metraj_m2_secim', '4 - 8 m² Arası (Standart Ev Camları Yenileme)');

    List<dynamic> ekstralar = [];
    List<dynamic> urunTipleri = [];

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_ozellikler' && element['cevap'] is List) {
          ekstralar = element['cevap'];
        } else if (element.containsKey('ekstra_ozellikler') && element['ekstra_ozellikler'] is List) {
          ekstralar = element['ekstra_ozellikler'];
        }

        if ((element['id'] == 'urun_tipi_kırılımı' || element['id'] == 'urun_tipi_kirilimi') && element['cevap'] is List) {
          urunTipleri = element['cevap'];
        } else if (element.containsKey('urun_tipi_kırılımı') && element['urun_tipi_kırılımı'] is List) {
          urunTipleri = element['urun_tipi_kırılımı'];
        } else if (element.containsKey('urun_tipi_kirilimi') && element['urun_tipi_kirilimi'] is List) {
          urunTipleri = element['urun_tipi_kirilimi'];
        }
      }
    }

    double toplamMetretul = 0.0;
    double camM2 = 0.0;
    double birimMetretulFiyati = 0.0;
    double camBirimM2Fiyati = 0.0;
    double ekMaliyet = 0.0;
    double markaKatsayisi = 1.0;
    double renkCarpani = 1.0;

    if (markaSegmenti.contains('A Plus') || markaSegmenti.contains('Winsa') || markaSegmenti.contains('Rehau')) {
      markaKatsayisi = 1.35;
    } else if (markaSegmenti.contains('B Sınıfı') || markaSegmenti.contains('Adopen') || markaSegmenti.contains('Fıratpen')) {
      markaKatsayisi = 1.00;
    } else if (markaSegmenti.contains('Ekonomik')) {
      markaKatsayisi = 0.85;
    }

    if (isKapsami.contains('Sıfırdan') || isKapsami.contains('Mevcut Doğrama') || isKapsami.contains('Değişimi')) {
      if (metretulSecim.contains('1-10') || metretulSecim.contains('Küçük')) {
        toplamMetretul = 6.0;
      } else if (metretulSecim.contains('11-25') || metretulSecim.contains('Standart')) {
        toplamMetretul = 18.0;
      } else if (metretulSecim.contains('26-50') || metretulSecim.contains('Büyük')) {
        toplamMetretul = 38.0;
      } else if (metretulSecim.contains('50 Üzeri') || metretulSecim.contains('Villa')) {
        toplamMetretul = 65.0;
      }

      birimMetretulFiyati = 950.0;
      if (profilSerisi.contains('70')) {
        birimMetretulFiyati = 1350.0;
      } else if (profilSerisi.contains('80')) {
        birimMetretulFiyati = 1900.0;
      }

      if (camTipi.contains('Konfor') || camTipi.contains('Sinerji')) {
        birimMetretulFiyati += 520.0;
      } else if (camTipi.contains('Argon') || camTipi.contains('Akustik') || camTipi.contains('Lamine')) {
        birimMetretulFiyati += 980.0;
      }

    } else if (isKapsami.contains('Sadece Cam')) {
      if (camM2Secim.contains('1-3') || camM2Secim.contains('Az Sayıda')) {
        camM2 = 2.0;
      } else if (camM2Secim.contains('4-8') || camM2Secim.contains('Standart')) {
        camM2 = 6.0;
      } else if (camM2Secim.contains('9-15') || camM2Secim.contains('Geniş')) {
        camM2 = 12.0;
      } else if (camM2Secim.contains('15 Üzeri') || camM2Secim.contains('Büyük')) {
        camM2 = 22.0;
      }

      camBirimM2Fiyati = 1400.0;
      if (camTipi.contains('Konfor') || camTipi.contains('Sinerji')) {
        camBirimM2Fiyati = 2100.0;
      } else if (camTipi.contains('Argon') || camTipi.contains('Akustik')) {
        camBirimM2Fiyati = 3200.0;
      }

    } else if (isKapsami.contains('Tamir') || isKapsami.contains('Fitil') || isKapsami.contains('Aksesuar')) {
      ekMaliyet += 3500.0;
    }

    for (var urun in urunTipleri) {
      final String o = urun.toString();
      if (o.contains('Balkon Kapısı')) ekMaliyet += 1800.0;
      if (o.contains('Balkon Seti')) ekMaliyet += 2900.0;
      if (o.contains('Sürgülü') || o.contains('Vosvos')) ekMaliyet += 6500.0;
      if (o.contains('Menfez')) ekMaliyet += 850.0;
    }

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Çift Açılım') || o.contains('Kanat') || o.contains('Vasistas')) {
        ekMaliyet += 1950.0;
      }
      if (o.contains('Antrasit') || o.contains('Renkli') || o.contains('Lamine')) {
        renkCarpani = 1.40;
      }
      if (o.contains('Sineklik') || o.contains('Pileli')) {
        ekMaliyet += 1200.0;
      }
      if (o.contains('Panjur')) {
        if (toplamMetretul > 0) {
          ekMaliyet += (toplamMetretul * 2100.0);
        } else {
          ekMaliyet += 14000.0;
        }
      }
      if (o.contains('Söküm') || o.contains('Moloz') || o.contains('Mevcut Doğrama')) {
        if (toplamMetretul > 0) {
          ekMaliyet += (toplamMetretul * 200.0);
        } else {
          ekMaliyet += 2500.0;
        }
      }
    }

    double toplamFiyat = 0.0;
    if (isKapsami.contains('Sıfırdan') || isKapsami.contains('Mevcut Doğrama') || isKapsami.contains('Değişimi')) {
      toplamFiyat = ((toplamMetretul * birimMetretulFiyati) * markaKatsayisi * renkCarpani) + ekMaliyet;
    } else if (isKapsami.contains('Sadece Cam')) {
      toplamFiyat = (camM2 * camBirimM2Fiyati) + ekMaliyet;
    } else {
      toplamFiyat = ekMaliyet;
    }

    double asgariBaraj = 11000.0;
    if (isKapsami.contains('Tamir') || isKapsami.contains('Fitil')) {
      asgariBaraj = 4000.0;
    } else if (isKapsami.contains('Sadece Cam')) {
      asgariBaraj = 55000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananMetretul": toplamMetretul,
      "hesaplananCamM2": camM2,
      "birimMetretulFiyati": birimMetretulFiyati,
      "camBirimM2Fiyati": camBirimM2Fiyati,
      "markaKatsayisi": markaKatsayisi,
      "renkChang": renkCarpani,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}