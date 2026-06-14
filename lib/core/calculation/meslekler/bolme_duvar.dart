class BolmeDuvarHesaplayici {
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

    final String uygulamaTipi = findValue('uygulama_tipi', 'Alçıpan Bölme Duvar Sistemleri');
    final String alanSegmenti = findValue('alan_segmenti', '20-50 m² Arası');
    final String malzemeDetayi = findValue('malzeme_detayi', 'Standart Beyaz Alçıpan / Panel');
    final String duvarKalinlik = findValue('duvar_kalinlik', '10 cm (Standart)');
    final String duvarYukseklik = findValue('duvar_yukseklik', 'Standart (2.50m - 3.00m)');
    final String kapiDurum = findValue('kapi_durum', 'Kapı İstemiyorum');
    final String alanTip = findValue('alan_tip', 'Ev / Oda Bölme');

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
      if (alanSegmenti.contains('0-20')) m2 = 12.0;
      else if (alanSegmenti.contains('20-50')) m2 = 35.0;
      else if (alanSegmenti.contains('50-100')) m2 = 75.0;
      else if (alanSegmenti.contains('100-300')) m2 = 200.0;
      else if (alanSegmenti.contains('300')) m2 = 450.0;
    }

    double birimM2Fiyati = 700.0;
    bool isCamBolme = uygulamaTipi.contains('Cam') || uygulamaTipi.contains('Ofis');

    if (isCamBolme) {
      birimM2Fiyati = 5200.0;
    } else if (uygulamaTipi.contains('Betopan')) {
      birimM2Fiyati = 1250.0;
    } else if (uygulamaTipi.contains('Akustik')) {
      birimM2Fiyati = 1600.0;
    }

    if (!isCamBolme) {
      if (malzemeDetayi.contains('Yeşil') || malzemeDetayi.contains('Suya')) {
        birimM2Fiyati += 160.0;
      } else if (malzemeDetayi.contains('Kırmızı') || malzemeDetayi.contains('Yangın')) {
        birimM2Fiyati += 240.0;
      }

      if (duvarKalinlik.contains('12.5 cm') || duvarKalinlik.contains('Çift Kat')) {
        birimM2Fiyati += 210.0;
      } else if (duvarKalinlik.contains('15 cm')) {
        birimM2Fiyati += 380.0;
      }
    }

    if (duvarYukseklik.contains('Yüksek Duvar') || duvarYukseklik.contains('3.00m - 4.50m')) {
      birimM2Fiyati *= 1.20;
    } else if (duvarYukseklik.contains('Endüstriyel') || duvarYukseklik.contains('4.50m')) {
      birimM2Fiyati *= 1.45;
    }

    if (alanTip.contains('Ofis') || alanTip.contains('Çalışma')) {
      birimM2Fiyati *= 1.05;
    } else if (alanTip.contains('Mağaza') || alanTip.contains('Depo')) {
      birimM2Fiyati *= 1.10;
    }

    double ekMaliyet = 0.0;

    if (kapiDurum.contains('Menteşeli')) {
      ekMaliyet += 6500.0;
    } else if (kapiDurum.contains('Sürgülü')) {
      ekMaliyet += 9500.0;
    }

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Taşyünü') || o.contains('Ses Yalıtımı')) {
        if (!isCamBolme) {
          ekMaliyet += (m2 * 240.0);
        }
      }
      if (o.contains('Kapı Boşluğu') || o.contains('Lentolama') || o.contains('Karkas Güçlendirme')) {
        ekMaliyet += 3200.0;
      }
      if (o.contains('Elektrik') || o.contains('Buat') || o.contains('Kanal')) {
        ekMaliyet += (m2 * 120.0);
      }
      if (o.contains('Alçı Sıva') || o.contains('Boya') || o.contains('Bitiş Paketi')) {
        if (!isCamBolme) {
          ekMaliyet += (m2 * 260.0);
        }
      }
      if (o.contains('Jaluzi') || o.contains('Cam Bölme Arası')) {
        if (isCamBolme) {
          ekMaliyet += (m2 * 1150.0);
        }
      }
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + ekMaliyet;

    double asgariBaraj = 14000.0;
    if (isCamBolme) asgariBaraj = 35000.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}