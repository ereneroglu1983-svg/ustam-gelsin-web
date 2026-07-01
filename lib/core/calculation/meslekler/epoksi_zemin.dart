class EpoksiZeminHesaplayici {
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

    final String isKapsami = findValue('is_kapsami', 'Komple Sıfırdan Epoksi Zemin Kaplama');
    final String kaplamaTipi = findValue('kaplama_tipi', 'Self-Leveling Epoksi (Düz ve Pürüzsüz Başlangıç)');
    final String alanSegmenti = findValue('alan_segmenti', '50-100 m² Arası');
    final String zeminDurumu = findValue('zemin_durumu', 'Eski Beton (Ağır Elmas Silim ve Vakumlu Toz Emme Gerektirir)');

    List<dynamic> zeminHasarlari = [];
    List<dynamic> ekstralar = [];

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'zemin_hasar_durumu' && element['cevap'] is List) {
          zeminHasarlari = element['cevap'];
        } else if (element.containsKey('zemin_hasar_durumu') && element['zemin_hasar_durumu'] is List) {
          zeminHasarlari = element['zemin_hasar_durumu'];
        }

        if (element['id'] == 'ekstra_ozellikler' && element['cevap'] is List) {
          ekstralar = element['cevap'];
        } else if (element.containsKey('ekstra_ozellikler') && element['ekstra_ozellikler'] is List) {
          ekstralar = element['ekstra_ozellikler'];
        }
      }
    }

    double m2 = 75.0;
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
      if (alanSegmenti.contains('0-50')) m2 = 25.0;
      else if (alanSegmenti.contains('50-100')) m2 = 75.0;
      else if (alanSegmenti.contains('100-250')) m2 = 175.0;
      else if (alanSegmenti.contains('250-500')) m2 = 375.0;
      else if (alanSegmenti.contains('500+')) m2 = 750.0;
    }

    double birimM2Fiyati = 0.0;
    double hazirlikMaliyeti = 0.0;
    double ekMaliyet = 0.0;

    if (isKapsami.contains('Lokal Onarım') || isKapsami.contains('Çatlak Tamiri')) {
      birimM2Fiyati = 280.0;
    } else {
      birimM2Fiyati = 650.0;

      if (kaplamaTipi.contains('3D') || kaplamaTipi.contains('Grafik')) {
        birimM2Fiyati = 2200.0;
      } else if (kaplamaTipi.contains('Portakal') || kaplamaTipi.contains('Textured')) {
        birimM2Fiyati = 520.0;
      } else if (kaplamaTipi.contains('Metalik')) {
        birimM2Fiyati = 950.0;
      }

      if (zeminDurumu.contains('Silim') || zeminDurumu.contains('Beton')) {
        hazirlikMaliyeti = (m2 * 110.0);
      } else if (zeminDurumu.contains('Seramik') || zeminDurumu.contains('Fayans')) {
        hazirlikMaliyeti = (m2 * 140.0);
      }

      for (var hasar in zeminHasarlari) {
        final String h = hasar.toString();
        if (h.contains('Derin Çatlak') || h.contains('Tamir Macunu')) {
          hazirlikMaliyeti += (m2 * 60.0);
        }
        if (h.contains('Tozuma')) {
          hazirlikMaliyeti += (m2 * 40.0);
        }
        if (h.contains('Yağlanma') || h.contains('Solventli')) {
          hazirlikMaliyeti += (m2 * 80.0);
        }
      }
    }

    if (!isKapsami.contains('Lokal Onarım')) {
      for (var ozellik in ekstralar) {
        final String o = ozellik.toString();
        if (o.contains('Nem Bariyeri')) {
          ekMaliyet += (m2 * 160.0);
        }
        if (o.contains('Antistatik')) {
          ekMaliyet += (m2 * 280.0);
        }
        if (o.contains('Ekstra Koruyucu')) {
          ekMaliyet += (m2 * 120.0);
        }
        if (o.contains('Çatlak Tamiri')) {
          ekMaliyet += 6000.0;
        }
      }
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + hazirlikMaliyeti + ekMaliyet;

    double asgariBaraj = 15000.0;
    if (kaplamaTipi.contains('3D')) {
      asgariBaraj = 25000.0;
    } else if (isKapsami.contains('Lokal Onarım')) {
      asgariBaraj = 7000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "hazirlikMaliyeti": hazirlikMaliyeti,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}