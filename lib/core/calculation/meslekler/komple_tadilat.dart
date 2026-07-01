class KompleTadilatHesaplayici {
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

    final String isKapsami = findValue('is_kapsami', 'Daire (Eski Yapı Komple İç Mekan Yenileme)');
    final String kaliteSegmenti = findValue('kalite_segmenti', 'Standart / Ekonomik Segment (Kiralık veya Satış Odaklı Optimizasyonlu Malzeme Yapısı)');
    final String binaYasi = findValue('bina_yasi', '0-5 Yıl Arası (Yeni Yapı / Altyapı Revizyonu Kolay)');
    final String esyaliMi = findValue('esyali_mi', 'Mekan Tamamen Boş (Hızlı Kırım ve Moloz Tahliyesine Uygun)');
    final String tasarimDestek = findValue('tasarim_destek', 'Sadece Uygulama Hizmeti (Benim Çizimim ve Planım Hazır)');
    final String alanM2Secim = findValue('alan_m2', '51 - 90 m² Arası (Standart 1+1 / 2+1 Konut)');

    List<String> kapsam = [];
    bool hasKirim = false;
    bool hasTesisat = false;

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'tadilat_kapsami' && element['cevap'] is List) {
          kapsam = (element['cevap'] as List).map((e) => e.toString()).toList();
          break;
        } else if (element.containsKey('tadilat_kapsami') && element['tadilat_kapsami'] is List) {
          kapsam = (element['tadilat_kapsami'] as List).map((e) => e.toString()).toList();
          break;
        }
      }
    }

    for (var isTuru in kapsam) {
      if (isTuru.contains('Kırım') || isTuru.contains('Yıkım')) hasKirim = true;
      if (isTuru.contains('Elektrik') || isTuru.contains('Tesisat') || isTuru.contains('Su')) hasTesisat = true;
    }

    double m2 = 75.0;

    if (alanM2Secim.contains('1-50') || alanM2Secim.contains('Küçük Ölçekli')) {
      m2 = 40.0;
    } else if (alanM2Secim.contains('51-90') || alanM2Secim.contains('Standart 1+1')) {
      m2 = 75.0;
    } else if (alanM2Secim.contains('91-140') || alanM2Secim.contains('Geniş 3+1')) {
      m2 = 120.0;
    } else if (alanM2Secim.contains('141-200') || alanM2Secim.contains('Büyük Daire')) {
      m2 = 170.0;
    } else if (alanM2Secim.contains('200+') || alanM2Secim.contains('Lüks Villa')) {
      m2 = 250.0;
    }

    double birimM2Fiyati = 8500.0;

    if (kaliteSegmenti.contains('Lüks') || kaliteSegmenti.contains('Premium')) {
      birimM2Fiyati = 16500.0;
    } else if (kaliteSegmenti.contains('Ultra') || kaliteSegmenti.contains('Atasarım')) {
      birimM2Fiyati = 26000.0;
    }

    double kapsamMaliyeti = 0.0;

    for (var isTuru in kapsam) {
      if (isTuru.contains('Kırım') || isTuru.contains('Yıkım') || isTuru.contains('Duvar Kaldırma')) {
        kapsamMaliyeti += m2 * 1200.0;
      }
      if (isTuru.contains('Elektrik')) {
        kapsamMaliyeti += m2 * 1850.0;
      }
      if (isTuru.contains('Tesisat') || isTuru.contains('Su')) {
        kapsamMaliyeti += m2 * 2300.0;
      }
      if (isTuru.contains('Mutfak')) {
        kapsamMaliyeti += m2 * 5400.0;
      }
      if (isTuru.contains('Banyo')) {
        kapsamMaliyeti += m2 * 4600.0;
      }
      if (isTuru.contains('Zemin') || isTuru.contains('Parke') || isTuru.contains('Seramik')) {
        kapsamMaliyeti += m2 * 2100.0;
      }
      if (isTuru.contains('Alçı') || isTuru.contains('Boya') || isTuru.contains('Asma Tavan') || isTuru.contains('Çitalama')) {
        kapsamMaliyeti += m2 * 1650.0;
      }
    }

    if (kapsam.isEmpty) {
      kapsamMaliyeti = m2 * 19100.0;
    }

    double altSoruEkMaliyeti = 0.0;

    if (hasTesisat) {
      if (binaYasi.contains('15-30')) {
        altSoruEkMaliyeti += m2 * 450.0;
      } else if (binaYasi.contains('30 Yıl') || binaYasi.contains('Yorgun')) {
        altSoruEkMaliyeti += m2 * 950.0;
      }
    }

    if (hasKirim) {
      if (esyaliMi.contains('Eşyalı')) {
        altSoruEkMaliyeti += m2 * 350.0;
      } else if (esyaliMi.contains('Yaşam Var') || esyaliMi.contains('Kademeli')) {
        altSoruEkMaliyeti += m2 * 750.0;
      }
    }

    if (tasarimDestek.contains('3D') || tasarimDestek.contains('Görselleştirme')) {
      altSoruEkMaliyeti += m2 * 1200.0;
    } else if (tasarimDestek.contains('Usta Tecrübesi') || tasarimDestek.contains('Keşif')) {
      altSoruEkMaliyeti += 2500.0;
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + kapsamMaliyeti + altSoruEkMaliyeti;

    if (isKapsami.contains('Villa') || isKapsami.contains('Müstakil')) {
      toplamFiyat *= 1.25;
    }

    if (m2 > 180) {
      toplamFiyat *= 0.88;
    } else if (m2 < 55) {
      toplamFiyat *= 1.25;
    }

    double asgariBaraj = 95000.0;
    if (isKapsami.contains('Villa') || isKapsami.contains('Müstakil')) {
      asgariBaraj = 220000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "kapsamMaliyeti": kapsamMaliyeti,
      "altSoruEkMaliyeti": altSoruEkMaliyeti,
      "durum": "BAŞARILI"
    };
  }
}