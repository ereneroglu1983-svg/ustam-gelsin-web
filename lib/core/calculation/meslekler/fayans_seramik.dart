class FayansSeramikHesaplayici {
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

    final String isKapsami = findValue('is_kapsami', 'Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)');
    final String alanSegmenti = findValue('alan_segmenti', '10-30 m² Arası (Banyo / Balkon Zemin)');
    final String seramikEbati = findValue('seramik_ebati', 'Standart (30x60, 60x60) Ölçüleri');
    final String zeminDurumu = findValue('zemin_durumu', 'Şaplı / Düz Zemin (Ham Yapı / Seramiğe Hazır)');
    final String molozDokumDurumu = findValue('moloz_dokum_durumu', 'Moloz Çuvallanıp Kamyona Yüklenecek (Kat Basit / Asansörlü)');
    final String malzemeSinif = findValue('malzeme_sinif', '1. Kalite Malzeme');

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

    double m2 = 20.0;
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
      if (alanSegmenti.contains('0-10')) m2 = 5.0;
      else if (alanSegmenti.contains('10-30')) m2 = 20.0;
      else if (alanSegmenti.contains('30-70')) m2 = 50.0;
      else if (alanSegmenti.contains('70+')) m2 = 120.0;
    }

    double birimM2Fiyati = 0.0;
    double hazirlikMaliyeti = 0.0;
    double ekMaliyet = 0.0;

    if (isKapsami.contains('Sadece Eski Fayans') || isKapsami.contains('Kırım')) {
      birimM2Fiyati = 250.0;
    } else {
      birimM2Fiyati = 450.0;

      if (seramikEbati.contains('60x120') || seramikEbati.contains('Büyük')) {
        birimM2Fiyati = 850.0;
      } else if (seramikEbati.contains('Mozaik') || seramikEbati.contains('Metro')) {
        birimM2Fiyati = 700.0;
      } else if (seramikEbati.contains('Lamine') || seramikEbati.contains('Dev')) {
        birimM2Fiyati = 1400.0;
      }

      if (malzemeSinif.contains('Usta Tedarik')) {
        birimM2Fiyati += 350.0;
      }

      if (zeminDurumu.contains('Eski Fayans')) {
        hazirlikMaliyeti = (m2 * 220.0);

        if (molozDokumDurumu.contains('Kamyona Yüklenecek') || molozDokumDurumu.contains('Asansörlü')) {
          hazirlikMaliyeti += (m2 * 130.0);
        } else if (molozDokumDurumu.contains('Sadece Çuvallanacak')) {
          hazirlikMaliyeti += (m2 * 50.0);
        }
      } else if (zeminDurumu.contains('Üstü Fayans')) {
        hazirlikMaliyeti = (m2 * 90.0);
      }
    }

    if (!isKapsami.contains('Kırım')) {
      for (var ozellik in ekstralar) {
        final String o = ozellik.toString();
        if (o.contains('Su Yalıtımı') || o.contains('İzolasyon')) {
          ekMaliyet += (m2 * 280.0);
        }
        if (o.contains('45 Derece') || o.contains('Jolly')) {
          ekMaliyet += 5000.0;
        }
        if (o.contains('Epoksi Derz')) {
          ekMaliyet += (m2 * 250.0);
        }
        if (o.contains('Tesviye Şapı')) {
          ekMaliyet += (m2 * 180.0);
        }
      }
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + hazirlikMaliyeti + ekMaliyet;

    double asgariBaraj = 12000.0;
    if (m2 < 10) {
      asgariBaraj = 7500.0;
    } else if (isKapsami.contains('Kırım')) {
      asgariBaraj = 5000.0;
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