class GergiTavanHesaplayici {
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

    final String isKapsami = findValue('is_kapsami', 'Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)');
    final String membranTipi = findValue('membran_tipi', 'Transparan (Işık Geçirgen) Standart Beyaz Doku');
    final String alanSegmenti = findValue('alan_segmenti', '5-15 m² Arası (Standart Oda / Salon)');
    final String aydinlatmaTipi = findValue('aydinlatma_tipi', 'Full Modül LED Paketi (Aydınlatma Altyapısı Dahil)');
    final String yukseklik = findValue('yukseklik', 'Standart (2.5 - 3m)');

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

    double m2 = 10.0;
    String m2String = '0';

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'metre_kare' && element['cevap'] != null) {
          m2String = element['cevap'].toString();
          break;
        } else if (element.containsKey('metre_kare') && element['metre_kare'] != null) {
          m2String = element['metre_kare'].toString();
          break;
        }
      }
    }

    double? parsedM2 = double.tryParse(m2String);
    if (parsedM2 != null && parsedM2 > 0) {
      m2 = parsedM2;
    } else {
      if (alanSegmenti.contains('0-5')) m2 = 3.5;
      else if (alanSegmenti.contains('5-15')) m2 = 10.0;
      else if (alanSegmenti.contains('15-30')) m2 = 22.0;
      else if (alanSegmenti.contains('30+')) m2 = 45.0;
    }

    double birimM2Fiyati = 0.0;
    double aydinlatmaMaliyeti = 0.0;
    double ekMaliyet = 0.0;
    double zorlukCarpani = 1.0;

    if (isKapsami.contains('Sadece Aydınlatma') || isKapsami.contains('Arıza')) {
      birimM2Fiyati = 0.0;
      aydinlatmaMaliyeti = m2 * 450.0;
    } else if (isKapsami.contains('Sadece Membran') || isKapsami.contains('Kumaş Değişimi')) {
      birimM2Fiyati = 450.0;
      if (membranTipi.contains('Baskılı') || membranTipi.contains('UV')) birimM2Fiyati = 750.0;
      if (membranTipi.contains('Lake') || membranTipi.contains('Ayna')) birimM2Fiyati = 600.0;
      if (membranTipi.contains('3D') || membranTipi.contains('Formlu')) birimM2Fiyati = 1100.0;
    } else {
      birimM2Fiyati = 600.0;

      if (membranTipi.contains('Baskılı') || membranTipi.contains('UV')) {
        birimM2Fiyati = 950.0;
      } else if (membranTipi.contains('Lake') || membranTipi.contains('Ayna')) {
        birimM2Fiyati = 780.0;
      } else if (membranTipi.contains('3D') || membranTipi.contains('Formlu')) {
        birimM2Fiyati = 1450.0;
      }

      if (aydinlatmaTipi.contains('LED') || aydinlatmaTipi.contains('Aydınlatma')) {
        aydinlatmaMaliyeti = m2 * 550.0;
      }
    }

    if (isKapsami.contains('Sıfırdan Komple')) {
      for (var ozellik in ekstralar) {
        final String o = ozellik.toString();

        if (o.contains('RGB') || o.contains('Uzaktan Kumandalı')) {
          aydinlatmaMaliyeti *= 1.60;
        }
        if (o.contains('Daire') || o.contains('Oval') || o.contains('Kavisli')) {
          zorlukCarpani *= 1.25;
        }
        if (o.contains('Lake Fitil')) {
          ekMaliyet += (m2 * 90.0);
        }
        if (o.contains('Teleskopik') || o.contains('Karkas Askı')) {
          ekMaliyet += 4500.0;
        }
      }
    }

    if (yukseklik.contains('Yüksek Tavan') || yukseklik.contains('3-4.5m')) {
      zorlukCarpani *= 1.15;
    } else if (yukseklik.contains('Endüstriyel') || yukseklik.contains('4.5m+')) {
      ekMaliyet += 3500.0;
    }

    double toplamFiyat = ((m2 * birimM2Fiyati) + aydinlatmaMaliyeti + ekMaliyet) * zorlukCarpani;

    double asgariBaraj = 7500.0;
    if (membranTipi.contains('Baskılı')) {
      asgariBaraj = 9000.0;
    } else if (isKapsami.contains('Sadece Aydınlatma')) {
      asgariBaraj = 4000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "aydinlatmaMaliyeti": aydinlatmaMaliyeti,
      "ekMaliyet": ekMaliyet,
      "zorlukCarpani": zorlukCarpani,
      "durum": "BAŞARILI"
    };
  }
}