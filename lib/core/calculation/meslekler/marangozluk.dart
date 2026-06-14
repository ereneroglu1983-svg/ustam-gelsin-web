class MarangozlukHesaplayici {

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

    final String isKapsami = findValue('is_kapsami', 'Tamirat / Montaj / Kurulum ve Yerinde Servis Hizmeti');
    final String malzemeTipi = findValue('malzeme_tipi', 'Suntalam (Ekonomik / Hazır Panel Serisi)');
    final String mobilyaKategorisi = findValue('mobilya_kategorisi', 'Küçük Hacimli Onarım (Kapak, Raf, Çekmece, Kulp veya Menteşe Tamiri)');
    final String olcuSegmenti = findValue('olcu_segmenti', 'Küçük Ölçekli Alanlar (0 - 2 m² Arası Komodin, Sehpa, Küçük Raf Sistemi vb.)');
    final String yapiTip = findValue('yapi_tip', 'Ev İçi Yaşam Alanları');

    List<dynamic> ekstralar = [];
    List<dynamic> tamirDetaylari = [];

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_ozellikler' && element['cevap'] is List) {
          ekstralar = element['cevap'];
        } else if (element.containsKey('ekstra_ozellikler') && element['ekstra_ozellikler'] is List) {
          ekstralar = element['ekstra_ozellikler'];
        }

        if (element['id'] == 'tamir_montaj_detayi' && element['cevap'] is List) {
          tamirDetaylari = element['cevap'];
        } else if (element.containsKey('tamir_montaj_detayi') && element['tamir_montaj_detayi'] is List) {
          tamirDetaylari = element['tamir_montaj_detayi'];
        }
      }
    }

    double birimMetraj = 1.0;

    if (olcuSegmenti.contains('Küçük') || olcuSegmenti.contains('0-2')) {
      birimMetraj = 1.5;
    } else if (olcuSegmenti.contains('Orta') || olcuSegmenti.contains('2-5')) {
      birimMetraj = 3.5;
    } else if (olcuSegmenti.contains('Büyük') || olcuSegmenti.contains('5-10')) {
      birimMetraj = 7.5;
    } else if (olcuSegmenti.contains('Özel') || olcuSegmenti.contains('10m2') || olcuSegmenti.contains('Üzeri')) {
      birimMetraj = 15.0;
    }

    double tabanMaliyet = 0.0;
    bool isImalatGrubu = false;

    if (isKapsami.contains('Sıfır') || isKapsami.contains('İmalat')) {
      isImalatGrubu = true;
      double m2BirimFiyati = 6500.0;

      if (malzemeTipi.contains('MDF')) {
        m2BirimFiyati = 9800.0;
      } else if (malzemeTipi.contains('Masif') || malzemeTipi.contains('Ahşap') || malzemeTipi.contains('Kereste')) {
        m2BirimFiyati = 24000.0;
      }

      tabanMaliyet = birimMetraj * m2BirimFiyati;
    } else {
      tabanMaliyet = 2400.0;

      if (mobilyaKategorisi.contains('Gardirop') || mobilyaKategorisi.contains('Mutfak') || mobilyaKategorisi.contains('Büyük Gövdeli')) {
        tabanMaliyet += 1800.0;
      }

      for (var detayi in tamirDetaylari) {
        final String d = detayi.toString();
        if (d.contains('Menteşe') || d.contains('Ray') || d.contains('Kulp')) {
          tabanMaliyet += 850.0;
        }
        if (d.contains('Kırık Ayak') || d.contains('Tutkallama') || d.contains('Gövde Onarımı')) {
          tabanMaliyet += 1400.0;
        }
        if (d.contains('Şişmiş') || d.contains('Nem Almış') || d.contains('Kesim')) {
          tabanMaliyet += 1900.0;
        }
        if (d.contains('Sürgü') || d.contains('Temizliği')) {
          tabanMaliyet += 1100.0;
        }
        if (d.contains('Hazır Paket') || d.contains('Demonte') || d.contains('Kurulumu')) {
          tabanMaliyet += 2200.0;
        }
        if (d.contains('Taşınma') || d.contains('Sök-Tak')) {
          tabanMaliyet += 3800.0;
        }
      }
    }

    if (yapiTip.contains('Tekne') || yapiTip.contains('Karavan') || yapiTip.contains('Yatch')) {
      tabanMaliyet *= 1.60;
    } else if (yapiTip.contains('Bahçe') || yapiTip.contains('Dış Mekan')) {
      tabanMaliyet *= 1.20;
    }

    double ekMaliyet = 0.0;

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Cila') || o.contains('Vernik') || o.contains('Lake')) {
        ekMaliyet += isImalatGrubu ? (birimMetraj * 2800.0) : 3500.0;
      }
      if (o.contains('Premium') || o.contains('Lüks Ray') || o.contains('Menteşe') || o.contains('Donanım')) {
        ekMaliyet += isImalatGrubu ? (birimMetraj * 2400.0) : 4500.0;
      }
      if (o.contains('Renk Değişimi') || o.contains('Kazıma') || o.contains('Zımpara')) {
        ekMaliyet += isImalatGrubu ? (birimMetraj * 3800.0) : 5800.0;
      }
      if (o.contains('Led') || o.contains('Işık') || o.contains('Trafo')) {
        ekMaliyet += 4200.0;
      }
    }

    double toplamFiyat = tabanMaliyet + ekMaliyet;

    double asgariBaraj = 3500.0;
    if (isImalatGrubu) {
      asgariBaraj = 15000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananMetraj": birimMetraj,
      "tabanMaliyet": tabanMaliyet,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}