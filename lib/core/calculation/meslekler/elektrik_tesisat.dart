class ElektrikTesisatHesaplayici {
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

    final String uygulamaKapsami = findValue('uygulama_kapsami', 'Komple Tesisat Yenileme / Revizyon (Sıfırdan Kanal ve Kablo Çekimi)');
    final String yapiTipi = findValue('yapi_tipi', 'Daire');
    final String konutTipi = findValue('konut_tipi', '2+1 Konut Düzeni');
    final String ticariM2Alan = findValue('ticari_m2_alan', '100-250 m² Arası Orta Ölçekli Ticari Alan');
    final String aydinlatmaSayi = findValue('aydinlatma_sayi', '10-25 Nokta Arası');
    final String malzemeSegmenti = findValue('malzeme_segmenti', 'Standart Yerli (NYM / Tam Bakır Kablo ve Standart Şalt Grubu)');
    final String tesisatSekli = findValue('tesisat_sekli', 'Duvar İçi / Sıva Altı Tesisat');

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

    double yapiKatsayisi = 1.0;
    double prizAdedi = 0.0;
    String adetString = '';

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'adet' && element['cevap'] != null) {
          adetString = element['cevap'].toString();
          break;
        } else if (element.containsKey('adet') && element['adet'] != null) {
          adetString = element['adet'].toString();
          break;
        }
      }
    }

    if (adetString.isNotEmpty && !adetString.contains('İstenmiyor')) {
      if (adetString.contains('1-15')) {
        prizAdedi = 12.0;
        yapiKatsayisi = 0.8;
      } else if (adetString.contains('15-30')) {
        prizAdedi = 24.0;
        yapiKatsayisi = 1.1;
      } else if (adetString.contains('30-50')) {
        prizAdedi = 40.0;
        yapiKatsayisi = 1.5;
      } else if (adetString.contains('50+')) {
        prizAdedi = 65.0;
        yapiKatsayisi = 2.5;
      } else {
        double? parsedAdet = double.tryParse(adetString);
        if (parsedAdet != null && parsedAdet > 0) {
          prizAdedi = parsedAdet;
          if (prizAdedi <= 18) yapiKatsayisi = 0.8;
          else if (prizAdedi <= 28) yapiKatsayisi = 1.1;
          else if (prizAdedi <= 38) yapiKatsayisi = 1.5;
          else yapiKatsayisi = 2.5;
        }
      }
    }

    if (prizAdedi == 0.0) {
      if (yapiTipi.contains('Daire') || yapiTipi.contains('Konut')) {
        if (konutTipi.contains('1+1')) { yapiKatsayisi = 0.8; prizAdedi = 18.0; }
        else if (konutTipi.contains('2+1')) { yapiKatsayisi = 1.1; prizAdedi = 28.0; }
        else if (konutTipi.contains('3+1')) { yapiKatsayisi = 1.5; prizAdedi = 38.0; }
        else if (konutTipi.contains('4+1')) { yapiKatsayisi = 2.2; prizAdedi = 55.0; }
        else { yapiKatsayisi = 1.1; prizAdedi = 28.0; }
      } else if (yapiTipi.contains('Villa')) {
        yapiKatsayisi = 2.6;
        prizAdedi = 65.0;
      } else if (yapiTipi.contains('Ticari') || yapiTipi.contains('İşyeri')) {
        if (ticariM2Alan.contains('1-100')) { yapiKatsayisi = 1.4; prizAdedi = 30.0; }
        else if (ticariM2Alan.contains('100-250')) { yapiKatsayisi = 2.2; prizAdedi = 50.0; }
        else if (ticariM2Alan.contains('250-500')) { yapiKatsayisi = 3.8; prizAdedi = 90.0; }
        else if (ticariM2Alan.contains('500+')) { yapiKatsayisi = 5.5; prizAdedi = 160.0; }
        else { yapiKatsayisi = 2.2; prizAdedi = 50.0; }
      } else if (yapiTipi.contains('Fabrika') || yapiTipi.contains('Atölye')) {
        if (ticariM2Alan.contains('1-100')) { yapiKatsayisi = 2.0; prizAdedi = 40.0; }
        else if (ticariM2Alan.contains('100-250')) { yapiKatsayisi = 3.2; prizAdedi = 70.0; }
        else if (ticariM2Alan.contains('250-500')) { yapiKatsayisi = 5.0; prizAdedi = 120.0; }
        else if (ticariM2Alan.contains('500+')) { yapiKatsayisi = 7.5; prizAdedi = 220.0; }
        else { yapiKatsayisi = 3.2; prizAdedi = 70.0; }
      } else {
        yapiKatsayisi = 1.0; prizAdedi = 28.0;
      }
    }

    double tabanMaliyet = 26000.0;
    bool isKomple = uygulamaKapsami.contains('Komple') || uygulamaKapsami.contains('Revizyon') || uygulamaKapsami.contains('Sıfırdan');
    bool isAriza = uygulamaKapsami.contains('Arıza') || uygulamaKapsami.contains('Lokal') || uygulamaKapsami.contains('Kısmi');
    bool isMontaj = uygulamaKapsami.contains('Sadece Montaj') || uygulamaKapsami.contains('Montaj İşçiliği');

    if (!isKomple && !isAriza && !isMontaj) {
      isKomple = true;
    }

    if (isAriza) {
      tabanMaliyet = 3800.0;
    } else if (isMontaj) {
      tabanMaliyet = 6500.0;
    }

    if (!isAriza) {
      tabanMaliyet *= yapiKatsayisi;
    }

    if (isKomple) {
      if (tesisatSekli.contains('Duvar İçi') || tesisatSekli.contains('Sıva Altı')) {
        tabanMaliyet += (prizAdedi * 120.0);
      } else if (tesisatSekli.contains('Sıva Üstü') || tesisatSekli.contains('Kanal')) {
        tabanMaliyet += (prizAdedi * 70.0);
      }
    }

    if (isKomple && (malzemeSegmenti.contains('Premium') || malzemeSegmenti.contains('İthal') || malzemeSegmenti.contains('Halogen'))) {
      tabanMaliyet *= 1.50;
    }

    double aydinlatmaMaliyeti = 0.0;
    if (aydinlatmaSayi.contains('1-10')) {
      aydinlatmaMaliyeti = 2500.0;
    } else if (aydinlatmaSayi.contains('10-25')) {
      aydinlatmaMaliyeti = 5500.0;
    } else if (aydinlatmaSayi.contains('25-50')) {
      aydinlatmaMaliyeti = 11000.0;
    }

    double ekMaliyet = 0.0;

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();

      if (o.contains('Klima') || o.contains('Hat Çekimi')) {
        ekMaliyet += 4800.0;
      }
      if (o.contains('Pano Yenileme') || o.contains('Sigorta Kutusu')) {
        double panoFark = yapiKatsayisi > 2.0 ? 14000.0 : 9000.0;
        ekMaliyet += panoFark;
      }
      if (o.contains('Topraklama') || o.contains('Levha')) {
        ekMaliyet += 8000.0;
      }
      if (o.contains('İnternet') || o.contains('Data')) {
        ekMaliyet += 4500.0;
      }
    }

    double toplamFiyat = tabanMaliyet + aydinlatmaMaliyeti + ekMaliyet;

    double asgariBaraj = 5500.0;
    if (isKomple) {
      asgariBaraj = (yapiTipi.contains('Ticari') || yapiTipi.contains('Fabrika')) ? 45000.0 : 28000.0;
    } else if (isAriza) {
      asgariBaraj = 2000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananPrizSayisi": prizAdedi,
      "yapiKatsayisi": yapiKatsayisi,
      "tabanMaliyet": tabanMaliyet,
      "aydinlatmaMaliyeti": aydinlatmaMaliyeti,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}