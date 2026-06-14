class FerforjeMetalHesaplayici {
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

    final String isKapsami = findValue('is_kapsami', 'Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet');
    final String urunTipi = findValue('urun_tipi', 'Pencere / Balkon Korkuluğu (Standart Profil ve Dekoratif Ferforje Serisi)');
    final String alanSegmenti = findValue('alan_segmenti', '5-12 Metre / m² Arası (Standart Konut / Çevre Korkuluk Ölçüsü)');
    final String metreKareSecim = findValue('metre_kare', 'Net 8 Metre / m² (Orta Ölçekli Alan)');
    final String kapiMekanizmasi = findValue('kapi_mekanizmasi', 'Yana Kayar Sürgülü Sistem (Ray Üzerinde Çalışan Tek Kanat)');
    final String motorOtomasyonu = findValue('motor_otomasyonu', 'Manuel Kullanım (El İle Açılır / Otomasyonsuz Standart Mekanizma)');
    final String tasarimModeli = findValue('tasarim_modeli', 'Standart / Düz Profil Tasarımı (Modern ve Minimalist Ekonomik Düz Hatlar)');
    final String yuzeyIslem = findValue('yuzey_islem', 'Elektrostatik Toz Boya Uygulaması (Endüstriyel Fırın Boyama)');

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

    double metraj = 0.0;

    if (metreKareSecim.contains('Net 3') || metreKareSecim.contains('Küçük Ölçekli')) {
      metraj = 3.0;
    } else if (metreKareSecim.contains('Net 8') || metreKareSecim.contains('Orta Ölçekli')) {
      metraj = 8.5;
    } else if (metreKareSecim.contains('Net 15') || metreKareSecim.contains('Geniş Ölçekli')) {
      metraj = 15.0;
    } else if (metreKareSecim.contains('Net 30') || metreKareSecim.contains('Çok Geniş')) {
      metraj = 30.0;
    } else if (metreKareSecim.contains('Net 50') || metreKareSecim.contains('Endüstriyel')) {
      metraj = 50.0;
    } else {
      if (alanSegmenti.contains('0-5')) metraj = 3.0;
      else if (alanSegmenti.contains('5-12')) metraj = 8.5;
      else if (alanSegmenti.contains('12-25')) metraj = 18.0;
      else if (alanSegmenti.contains('25+')) metraj = 40.0;
    }

    double birimMetreFiyati = 0.0;
    double ekMaliyet = 0.0;

    if (isKapsami.contains('Lokal Onarım') || isKapsami.contains('Tadilat')) {
      birimMetreFiyati = 950.0;
    } else {
      birimMetreFiyati = 3200.0;

      if (urunTipi.contains('Kapı') || urunTipi.contains('Bahçe') || urunTipi.contains('Garaj')) {
        birimMetreFiyati = 4800.0;

        if (kapiMekanizmasi.contains('Yana Kayar') || kapiMekanizmasi.contains('Sürgülü')) {
          ekMaliyet += 6000.0;
        } else if (kapiMekanizmasi.contains('Çift Kanat') || kapiMekanizmasi.contains('Dairesel')) {
          ekMaliyet += 4500.0;
        }

        if (motorOtomasyonu.contains('Otomatik') || motorOtomasyonu.contains('Motorlu')) {
          ekMaliyet += 24000.0;
        }
      } else if (urunTipi.contains('Yangın') || urunTipi.contains('Merdiven')) {
        birimMetreFiyati = 7800.0;
      }

      if (tasarimModeli.contains('Özel Motifli') || tasarimModeli.contains('CNC Kesim')) {
        birimMetreFiyati *= 1.65;
      } else if (tasarimModeli.contains('Klasik') || tasarimModeli.contains('Kavisli')) {
        birimMetreFiyati *= 1.25;
      }

      if (yuzeyIslem.contains('Sıcak Daldırma') || yuzeyIslem.contains('Galvaniz')) {
        birimMetreFiyati += 1300.0;
      } else if (yuzeyIslem.contains('Patina') || yuzeyIslem.contains('Bakır')) {
        birimMetreFiyati += 400.0;
      }
    }

    if (!isKapsami.contains('Lokal Onarım')) {
      for (var ozellik in ekstralar) {
        final String o = ozellik.toString();
        if ((o.contains('Motor Otomasyon') || o.contains('Motorlu')) && !motorOtomasyonu.contains('Otomatik')) {
          ekMaliyet += 24000.0;
        }
        if (o.contains('Sürme Ray') && !kapiMekanizmasi.contains('Yana Kayar')) {
          ekMaliyet += 6000.0;
        }
        if (o.contains('Akıllı Kilit') || o.contains('Otomat')) {
          ekMaliyet += 4800.0;
        }
        if (o.contains('Kalın Profil') || o.contains('Et Kalınlığı') || o.contains('İçi Dolu')) {
          birimMetreFiyati *= 1.30;
        }
      }
    }

    double toplamFiyat = (metraj * birimMetreFiyati) + ekMaliyet;

    double asgariBaraj = 14000.0;
    if (urunTipi.contains('Yangın')) {
      asgariBaraj = 48000.0;
    } else if (isKapsami.contains('Lokal Onarım')) {
      asgariBaraj = 4500.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananMetraj": metraj,
      "birimMetreFiyati": birimMetreFiyati,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}