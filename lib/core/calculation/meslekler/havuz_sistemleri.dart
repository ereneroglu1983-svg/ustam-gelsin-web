class HavuzSistemleriHesaplayici {
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

    final String isKapsami = findValue('is_kapsami', 'Sıfırdan Havuz Yapımı (Komple Anahtar Teslim İnşaat ve Mekanik)');
    final String havuzTipi = findValue('havuz_tipi', 'Betonarme Gövde (Skimmerlı Standart Filtrasyon Sistemi)');
    final String alanSegmenti = findValue('alan_segmenti', '25-50 m² Arası (Orta Boy Standart Bahçe Tipi Aile Havuzu)');
    final String kaplamaTipi = findValue('kaplama_tipi', 'Porselen Mozaik Kaplama (Yüksek Dayanımlı Havuz Seramiği)');
    final String araziSarti = findValue('arazi_sarti', 'Normal Toprak Yapısı (Düz Arazi / Kolay Ekskavatör Kazısı)');

    List<dynamic> ekstralar = [];
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_ozellikler' && element['cevap'] is List) {
          ekstralar = element['cevap'];
          break;
        } else if (element.containsKey('ekstra_ozellikler') && element['ekstra_ozellikler'] is List) {
          ekstralar = element['ekstra_ozellikler'];
          break;
        }
      }
    }

    double m2 = 35.0;

    if (alanSegmenti.contains('0-25')) {
      m2 = 18.0;
    } else if (alanSegmenti.contains('25-50')) {
      m2 = 35.0;
    } else if (alanSegmenti.contains('50-100')) {
      m2 = 75.0;
    } else if (alanSegmenti.contains('100+')) {
      m2 = 150.0;
    }

    double hacimM3 = m2 * 1.5;

    double birimM2Fiyati = 0.0;
    double zorlukEkstrasi = 0.0;
    double donanimMaliyeti = 0.0;

    if (isKapsami.contains('Periyodik') || isKapsami.contains('Bakım')) {
      double aylikKimyasalBedeli = 4500.0;
      if (hacimM3 > 100) aylikKimyasalBedeli = 12000.0;
      else if (hacimM3 > 50) aylikKimyasalBedeli = 8000.0;

      return {
        "tahminiButce": aylikKimyasalBedeli,
        "hesaplananM2": m2,
        "hacimM3": hacimM3,
        "birimM2Fiyati": 0.0,
        "zorlukEkstrasi": 0.0,
        "donanimMaliyeti": aylikKimyasalBedeli,
        "durum": "BAŞARILI"
      };
    } else if (isKapsami.contains('Tadilat') || isKapsami.contains('Yenileme') || isKapsami.contains('Liner Değişimi')) {
      birimM2Fiyati = 12000.0;
      if (kaplamaTipi.contains('Cam Mozaik') || kaplamaTipi.contains('Doğaltaş')) {
        birimM2Fiyati = 19500.0;
      } else if (kaplamaTipi.contains('Liner')) {
        birimM2Fiyati = 9500.0;
      }
    } else if (isKapsami.contains('Kapatma') || isKapsami.contains('Isı Sistemi')) {
      birimM2Fiyati = 0.0;
    } else {
      birimM2Fiyati = 45000.0;

      if (havuzTipi.contains('Fiberglass')) {
        birimM2Fiyati = 32000.0;
      } else if (havuzTipi.contains('Prefabrik') || havuzTipi.contains('Panel')) {
        birimM2Fiyati = 34000.0;
      } else if (havuzTipi.contains('Taşmalı') || havuzTipi.contains('Infinity')) {
        birimM2Fiyati = 68000.0;
      }

      if (kaplamaTipi.contains('Cam Mozaik') || kaplamaTipi.contains('Doğaltaş')) {
        birimM2Fiyati += 8500.0;
      } else if (kaplamaTipi.contains('Liner') && (havuzTipi.contains('Betonarme') || havuzTipi.contains('Taşmalı'))) {
        birimM2Fiyati -= 4000.0;
      }

      if (araziSarti.contains('Kaya') || araziSarti.contains('Sert')) {
        zorlukEkstrasi += 55000.0;
      } else if (araziSarti.contains('Bataklık') || araziSarti.contains('Balçık') || araziSarti.contains('Yeraltı Suyu')) {
        zorlukEkstrasi += 85000.0;
      }
    }

    if (!isKapsami.contains('Kapatma') && !isKapsami.contains('Isı Sistemi')) {
      donanimMaliyeti += (hacimM3 * 650.0);
    }

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Isı Pompası') || o.contains('İnverter')) {
        donanimMaliyeti += 115000.0;
      }
      if (o.contains('Tuz Klorlama') || o.contains('Otomasyon')) {
        donanimMaliyeti += 48000.0;
      }
      if (o.contains('Şelale') || o.contains('Jakuzi') || o.contains('Spa')) {
        donanimMaliyeti += 6000.0 + (m2 * 200.0);
      }
      if (o.contains('Aydınlatma') || o.contains('RGB')) {
        donanimMaliyeti += (m2 * 1400.0);
      }
      if (o.contains('Kapak Sistemi') || o.contains('Lamel')) {
        donanimMaliyeti += 135000.0;
      }
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + zorlukEkstrasi + donanimMaliyeti;

    double asgariBaraj = 50000.0;

    if (isKapsami.contains('Kurulum') || isKapsami.contains('Sıfırdan') || isKapsami.contains('Yapımı')) {
      if (havuzTipi.contains('Prefabrik') || havuzTipi.contains('Panel') || havuzTipi.contains('Fiberglass')) {
        asgariBaraj = 380000.0;
      } else {
        asgariBaraj = 550000.0;
      }
    } else if (isKapsami.contains('Tadilat')) {
      asgariBaraj = 90000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "hacimM3": hacimM3,
      "birimM2Fiyati": birimM2Fiyati,
      "zorlukEkstrasi": zorlukEkstrasi,
      "donanimMaliyeti": donanimMaliyeti,
      "durum": "BAŞARILI"
    };
  }
}