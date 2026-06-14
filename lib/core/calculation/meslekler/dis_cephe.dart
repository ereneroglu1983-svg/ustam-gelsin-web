class DisCepheHesaplayici {
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

    final String islemTuru = findValue('islem_turu', 'Mantolama ve Boya Paket Uygulaması');
    final String alanSegmenti = findValue('alan_segmenti', '100-250 m² Arası');
    final String malzemeTipi = findValue('malzeme_tipi', 'EPS - Standart');
    final String mantolamaDurum = findValue('mantolama_durum', 'Sıfır Mantolama (Yeni Uygulama)');
    final String binaYuksekligi = findValue('bina_yuksekligi', '1-2 Katlı Müstakil Ev / Villa');
    final String binaTip = findValue('bina_tip', 'Apartman Bloğu');
    final String kalinlikBoya = findValue('kalinlik_boya', '4 cm Kalınlık');

    List<dynamic> ekstralar = [];
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_detaylar' && element['cevap'] is List) {
          ekstralar = element['cevap'];
          break;
        } else if (element.containsKey('ekstra_detaylar') && element['ekstra_detaylar'] is List) {
          ekstralar = element['ekstra_detaylar'];
          break;
        }
      }
    }

    double m2 = 175.0;
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
      if (alanSegmenti.contains('0-100m')) m2 = 65.0;
      else if (alanSegmenti.contains('100-250m')) m2 = 175.0;
      else if (alanSegmenti.contains('250-500m')) m2 = 375.0;
      else if (alanSegmenti.contains('500-1000m')) m2 = 750.0;
      else if (alanSegmenti.contains('1000m+')) m2 = 1350.0;
    }

    double birimM2Fiyati = 450.0;
    bool isMantolama = islemTuru.contains('Mantolama') || islemTuru.contains('Paket');

    if (isMantolama) {
      birimM2Fiyati = 950.0;

      if (malzemeTipi.contains('Taşyünü') || malzemeTipi.contains('Taş')) {
        birimM2Fiyati = 1550.0;
      } else if (malzemeTipi.contains('Karbonlu')) {
        birimM2Fiyati = 1100.0;
      } else if (malzemeTipi.contains('XPS')) {
        birimM2Fiyati = 1250.0;
      }

      if (kalinlikBoya.contains('3 cm')) {
        birimM2Fiyati -= 80.0;
      } else if (kalinlikBoya.contains('5 cm')) {
        birimM2Fiyati += 120.0;
      } else if (kalinlikBoya.contains('8 cm')) {
        birimM2Fiyati += 350.0;
      }

      if (mantolamaDurum.contains('Yenileme') || mantolamaDurum.contains('Revizyon')) {
        birimM2Fiyati += 200.0;
      }
    }

    if (binaTip.contains('Apartman')) {
      birimM2Fiyati *= 1.05;
    } else if (binaTip.contains('Ticari') || binaTip.contains('İşyeri')) {
      birimM2Fiyati *= 1.10;
    }

    double iskeleMaliyeti = 0.0;
    if (binaYuksekligi.contains('3-5 Kat')) {
      iskeleMaliyeti = m2 * 240.0;
    } else if (binaYuksekligi.contains('6 Kat') || binaYuksekligi.contains('Apartman Bloğu')) {
      iskeleMaliyeti = m2 * 380.0;
    } else if (binaYuksekligi.contains('Gökdelen') || binaYuksekligi.contains('Kule') || binaYuksekligi.contains('Hareketli')) {
      iskeleMaliyeti = m2 * 750.0;
    }

    double ekMaliyet = 0.0;

    for (var detay in ekstralar) {
      final String d = detay.toString();

      if (d.contains('Söve') || d.contains('Pencere')) {
        ekMaliyet += (m2 * 180.0);
      }
      if (d.contains('Silikonlu Boya') || d.contains('Temizleyen')) {
        birimM2Fiyati += 90.0;
      }
      if (d.contains('Mozaik') || d.contains('Grenli') || d.contains('Dekoratif Sıva')) {
        birimM2Fiyati += 140.0;
      }
      if (d.contains('Çatlak Tamiri') || d.contains('Fileli')) {
        ekMaliyet += (m2 * 110.0);
      }
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + iskeleMaliyeti + ekMaliyet;

    double asgariBaraj = isMantolama ? 55000.0 : 25000.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "iskeleMaliyeti": iskeleMaliyeti,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}