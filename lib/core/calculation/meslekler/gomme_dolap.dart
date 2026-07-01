class RayDolapHesaplayici {
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

    final String islemKapsami = findValue('islem_kapsami', 'Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)');
    final String govdeMalzemesi = findValue('govde_malzemesi', 'MDF Lam (Dayanıklı ve Yüksek Yoğunluklu 1. Kalite Uzun Ömürlü Panel)');
    final String kapakModeli = findValue('kapak_modeli', 'Düz / Suntalam Kapak (Modern Ekonomik Hatlar)');
    final String alanSegmenti = findValue('alan_segmenti', '4 - 8 m² Arası Orta Boy Odalar İçin İdeal Düzen');
    final String rayMekanizmasi = findValue('ray_mekanizmasi', 'Standart Ray Sistemi (Manuel Açılış Alttan Makaralı)');
    final String yukseklikTip = findValue('yukseklik_tip', 'Standart Ölçü (210 - 230 cm Arası Üstü Açık)');

    List<dynamic> ekstralar = [];
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_donanim' && element['cevap'] is List) {
          ekstralar = element['cevap'];
          break;
        } else if (element.containsKey('ekstra_donanim') && element['ekstra_donanim'] is List) {
          ekstralar = element['ekstra_donanim'];
          break;
        }
      }
    }

    double m2 = 6.0;

    if (alanSegmenti.contains('0-4') || alanSegmenti.contains('Küçük Boy')) {
      m2 = 3.0;
    } else if (alanSegmenti.contains('4-8') || alanSegmenti.contains('Orta Boy')) {
      m2 = 6.0;
    } else if (alanSegmenti.contains('8-12') || alanSegmenti.contains('Geniş Boy')) {
      m2 = 10.0;
    } else if (alanSegmenti.contains('12+') || alanSegmenti.contains('Dev Gömme') || alanSegmenti.contains('Büyük Sistemler')) {
      m2 = 16.0;
    }

    double birimM2Fiyati = 0.0;
    double mekanizmaMaliyeti = 0.0;
    double ekMaliyet = 0.0;
    double isclikZorlukCarpani = 1.0;

    if (islemKapsami.contains('Sadece Kapak Yenileme')) {
      birimM2Fiyati = 2800.0;
      if (kapakModeli.contains('Lake') || kapakModeli.contains('Boya')) birimM2Fiyati = 7600.0;
      if (kapakModeli.contains('Membran') || kapakModeli.contains('Balon')) birimM2Fiyati = 5300.0;
      if (kapakModeli.contains('Akrilik') || kapakModeli.contains('Panel')) birimM2Fiyati = 4600.0;

      if (rayMekanizmasi.contains('Lüks') || rayMekanizmasi.contains('Üstten Askılı')) {
        mekanizmaMaliyeti = 8500.0;
      } else if (rayMekanizmasi.contains('Menteşeli')) {
        mekanizmaMaliyeti = 3000.0;
      } else {
        mekanizmaMaliyeti = 4500.0;
      }
    } else if (islemKapsami.contains('İç Raf Düzenleme') || islemKapsami.contains('Tadilat')) {
      birimM2Fiyati = 2200.0;
      if (govdeMalzemesi.contains('MDF')) birimM2Fiyati = 3400.0;
      if (govdeMalzemesi.contains('Masif')) birimM2Fiyati = 8000.0;
    } else {
      birimM2Fiyati = 5500.0;

      if (govdeMalzemesi.contains('MDF') || govdeMalzemesi.contains('1. Kalite')) {
        birimM2Fiyati = 7800.0;
      } else if (govdeMalzemesi.contains('Masif') || govdeMalzemesi.contains('Ahşap')) {
        birimM2Fiyati = 16500.0;
      }

      if (kapakModeli.contains('Lake') || kapakModeli.contains('Boya')) {
        birimM2Fiyati += 4800.0;
      } else if (kapakModeli.contains('Membran') || kapakModeli.contains('Balon')) {
        birimM2Fiyati += 2500.0;
      } else if (kapakModeli.contains('Akrilik') || kapakModeli.contains('Panel')) {
        birimM2Fiyati += 1800.0;
      }

      if (rayMekanizmasi.contains('Lüks') || rayMekanizmasi.contains('Üstten Askılı') || rayMekanizmasi.contains('Frenli')) {
        mekanizmaMaliyeti = 8500.0;
      } else if (rayMekanizmasi.contains('Menteşeli')) {
        mekanizmaMaliyeti = 3000.0;
      } else {
        mekanizmaMaliyeti = 4000.0;
      }

      for (var detay in ekstralar) {
        final String d = detay.toString();
        if (d.contains('LED Aydınlatma')) {
          ekMaliyet += (m2 * 1100.0);
        }
        if (d.contains('Ayna') || d.contains('Cam') || d.contains('Reflekte')) {
          ekMaliyet += (m2 * 1400.0);
        }
        if (d.contains('Pantolonluk') || d.contains('Asansör')) {
          ekMaliyet += 6500.0;
        }
        if (d.contains('Ekstra Derin')) {
          isclikZorlukCarpani *= 1.25;
        }
        if (d.contains('Çekmece') || d.contains('Tandem')) {
          ekMaliyet += 3500.0;
        }
      }
    }

    if (yukseklikTip.contains('Tavana Kadar') || yukseklikTip.contains('Pervaz')) {
      ekMaliyet += (m2 * 450.0);
    } else if (yukseklikTip.contains('Özel Ölçü') || yukseklikTip.contains('Alçak Tavan') || yukseklikTip.contains('Kiriş')) {
      isclikZorlukCarpani *= 1.20;
    }

    double toplamFiyat = ((m2 * birimM2Fiyati) + mekanizmaMaliyeti + ekMaliyet) * isclikZorlukCarpani;

    double asgariBaraj = 22000.0;
    if (kapakModeli.contains('Lake')) {
      asgariBaraj = 35000.0;
    } else if (islemKapsami.contains('Sadece Kapak Yenileme')) {
      asgariBaraj = 11000.0;
    } else if (islemKapsami.contains('İç Raf Düzenleme')) {
      asgariBaraj = 6500.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "mekanizmaMaliyeti": mekanizmaMaliyeti,
      "ekMaliyet": ekMaliyet,
      "isclikZorlukCarpani": isclikZorlukCarpani,
      "durum": "BAŞARILI"
    };
  }
}