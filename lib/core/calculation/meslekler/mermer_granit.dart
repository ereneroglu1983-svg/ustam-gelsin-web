class MermerGranitHesaplayici {

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

    final String isKapsami = findValue('is_kapsami', 'Banyo / Zemin Kaplama');
    final String malzemeTipi = findValue('malzeme_tipi', 'Yerli Mermer (Muğla Beyazı / Marmara Serisi - Standart)');
    final String metrajSegmenti = findValue('metraj_segmenti', '5-10 Metretül / m² Arası');
    final String mezarTipi = findValue('mezar_tipi', 'Tek Kişilik (Standart Blok Kaplama)');

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

    double birimMetraj = 1.0;
    String metrajString = '0';

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'metre_kare' && element['cevap'] != null) {
          metrajString = element['cevap'].toString();
          break;
        } else if (element.containsKey('metre_kare') && element['metre_kare'] != null) {
          metrajString = element['metre_kare'].toString();
          break;
        }
      }
    }

    double? parsedMetraj = double.tryParse(metrajString);
    if (parsedMetraj != null && parsedMetraj > 0) {
      birimMetraj = parsedMetraj;
    } else {
      if (metrajSegmenti.contains('0-5')) birimMetraj = 3.5;
      else if (metrajSegmenti.contains('5-10')) birimMetraj = 7.5;
      else if (metrajSegmenti.contains('10-20')) birimMetraj = 14.5;
      else if (metrajSegmenti.contains('20+')) birimMetraj = 26.0;
    }

    double birimFiyat = 2200.0;
    bool isMezar = isKapsami.contains('Mezar');

    if (!isMezar) {
      if (malzemeTipi.contains('Granit')) {
        birimFiyat = 4800.0;
      } else if (malzemeTipi.contains('Kuvars') || malzemeTipi.contains('Belenco') || malzemeTipi.contains('Coante')) {
        birimFiyat = 6800.0;
      } else if (malzemeTipi.contains('Porselen')) {
        birimFiyat = 9500.0;
      }
    }

    if (!isMezar) {
      if (isKapsami.contains('Mutfak') || isKapsami.contains('Tezgah') || isKapsami.contains('Banyo')) {
        birimFiyat += 1400.0;
      } else if (isKapsami.contains('Merdiven') || isKapsami.contains('Basamak')) {
        birimFiyat += 850.0;
      } else if (isKapsami.contains('Denizlik')) {
        birimFiyat -= 400.0;
      }
    }

    double mezarTabanMaliyeti = 0.0;
    if (isMezar) {
      double mezarMalzemeKatSayisi = 1.0;
      if (malzemeTipi.contains('Granit')) mezarMalzemeKatSayisi = 2.2;
      else if (malzemeTipi.contains('Kuvars') || malzemeTipi.contains('Belenco')) mezarMalzemeKatSayisi = 3.0;

      if (mezarTipi.contains('Tek Kişilik') || mezarTipi.contains('Standart')) {
        mezarTabanMaliyeti = 32000.0 * mezarMalzemeKatSayisi;
      } else if (mezarTipi.contains('Çift') || mezarTipi.contains('Aile')) {
        mezarTabanMaliyeti = 58000.0 * mezarMalzemeKatSayisi;
      } else if (mezarTipi.contains('Katlı') || mezarTipi.contains('Gömme')) {
        mezarTabanMaliyeti = 72000.0 * mezarMalzemeKatSayisi;
      } else if (mezarTipi.contains('Baş Taşı') || mezarTipi.contains('Onarım')) {
        mezarTabanMaliyeti = 8500.0 * (mezarMalzemeKatSayisi * 0.7);
      }
    }

    double ekMaliyet = 0.0;
    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Balıksırtı') || o.contains('Tam Pah')) {
        ekMaliyet += (birimMetraj * 450.0);
      }
      if (o.contains('Alttan Montaj') || o.contains('Evye')) {
        ekMaliyet += 3600.0;
      }
      if (o.contains('L Çıta') || o.contains('Kalınlaştırma') || o.contains('Gönye')) {
        ekMaliyet += (birimMetraj * 950.0);
      }
      if (o.contains('Süpürgelik')) {
        ekMaliyet += (birimMetraj * 320.0);
      }
    }

    double toplamFiyat = 0.0;
    if (isMezar) {
      toplamFiyat = mezarTabanMaliyeti + ekMaliyet;
    } else {
      toplamFiyat = (birimMetraj * birimFiyat) + ekMaliyet;
    }

    double asgariBaraj = 14000.0;
    if (isKapsami.contains('Denizlik')) {
      asgariBaraj = 7500.0;
    } else if (isMezar) {
      asgariBaraj = 12000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananMetraj": birimMetraj,
      "birimFiyat": isMezar ? 0.0 : birimFiyat,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}