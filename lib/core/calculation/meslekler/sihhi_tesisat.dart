// lib/core/calculation/meslekler/sihhi_tesisat_hesaplayici.dart

class SihhiTesisatHesaplayici {

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

    final String isKapsami = findValue('is_kapsami', 'Genel Tesisat Yenileme (Sıfırdan Komple Altyapı Kurulumu)');
    final String boruTipi = findValue('boru_tipi', 'PPRC Standart Plastik Tesisat Borusu');
    final String kacakDurumu = findValue('kacak_durumu', 'Onarım / Tamirat / Musluk-Batarya Montajı İstiyorum');
    final String hatUzunlugu = findValue('hat_uzunlugu', 'Lokal Müdahale (1-5 Metre Arası)');
    final String yapiTip = findValue('yapi_tip', 'Daire');
    final String tesisatKonumu = findValue('tesisat_konumu', 'Duvar İçi Gizli Tesisat');

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

    double islakHacimSayisi = 0.0;
    String hacimString = '0';
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'islak_hacim_sayisi' && element['cevap'] != null) {
          hacimString = element['cevap'].toString();
          break;
        } else if (element.containsKey('islak_hacim_sayisi') && element['islak_hacim_sayisi'] != null) {
          hacimString = element['islak_hacim_sayisi'].toString();
          break;
        }
      }
    }
    islakHacimSayisi = double.tryParse(hacimString) ?? 0.0;

    double armaturSayisi = 0.0;
    String armaturString = '0';
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'armatur_sayisi' && element['cevap'] != null) {
          armaturString = element['cevap'].toString();
          break;
        } else if (element.containsKey('armatur_sayisi') && element['armatur_sayisi'] != null) {
          armaturString = element['armatur_sayisi'].toString();
          break;
        }
      }
    }
    armaturSayisi = double.tryParse(armaturString) ?? 0.0;

    double yapiKatsayisi = 1.0;
    if (yapiTip.contains('Villa') || yapiTip.contains('Müstakil')) {
      yapiKatsayisi = 1.30;
    } else if (yapiTip.contains('İşyeri') || yapiTip.contains('Ofis') || yapiTip.contains('Ticari')) {
      yapiKatsayisi = 1.15;
    }

    double konumKatsayisi = 1.0;
    if (tesisatKonumu.contains('Duvar İçi') || tesisatKonumu.contains('Gizli')) {
      konumKatsayisi = 1.10;
    } else if (tesisatKonumu.contains('Zemin Altı')) {
      konumKatsayisi = 1.20;
    } else if (tesisatKonumu.contains('Sıva Üstü') || tesisatKonumu.contains('Açıkta')) {
      konumKatsayisi = 0.90;
    }

    double anaTesisatMaliyeti = 0.0;
    double birimHacimFiyati = 0.0;
    double ekMaliyet = 0.0;

    if (isKapsami.contains('Genel Tesisat') || isKapsami.contains('Yenileme') || isKapsami.contains('Komple')) {
      if (islakHacimSayisi <= 0) {
        return {"tahminiButce": 0.0, "hesaplananHacim": 0.0, "durum": "HATA", "mesaj": "Geçersiz ıslak hacim verisi"};
      }

      birimHacimFiyati = 11000.0;
      if (boruTipi.contains('Kompozit') || boruTipi.contains('Cam Elyaf')) {
        birimHacimFiyati = 14000.0;
      } else if (boruTipi.contains('Sessiz Boru') || boruTipi.contains('Akustik') || boruTipi.contains('Pis Su')) {
        birimHacimFiyati = 18500.0;
      }

      anaTesisatMaliyeti = (islakHacimSayisi * birimHacimFiyati) * yapiKatsayisi * konumKatsayisi;

      for (var ozellik in ekstralar) {
        final String o = ozellik.toString();
        if (o.contains('Söküm') || o.contains('Kırım') || o.contains('Moloz')) {
          ekMaliyet += (islakHacimSayisi * 4500.0);
        }
        if (o.contains('Gömme Rezervuar') || o.contains('Gizli Sarnıç')) {
          ekMaliyet += 5500.0;
        }
        if (o.contains('Kollektörlü') || o.contains('Mobil') || o.contains('Paneli')) {
          ekMaliyet += 9000.0;
        }
        if (o.contains('Test') || o.contains('Sızdırmazlık') || o.contains('Basınçlı')) {
          ekMaliyet += 3500.0;
        }
      }

    } else if (isKapsami.contains('Kaçak') || isKapsami.contains('Tıkanıklık') || isKapsami.contains('Onarım')) {
      double hatKatsayisi = 1.0;
      if (hatUzunlugu.contains('Bölgesel') || hatUzunlugu.contains('5-15')) {
        hatKatsayisi = 1.50;
      } else if (hatUzunlugu.contains('Kısmi') || hatUzunlugu.contains('15-30')) {
        hatKatsayisi = 2.20;
      }

      if (kacakDurumu.contains('Kaçak Var') || kacakDurumu.contains('Akustik') || kacakDurumu.contains('Termal')) {
        anaTesisatMaliyeti = 4500.0 * hatKatsayisi * yapiKatsayisi;
        ekMaliyet += 3000.0;
      } else if (kacakDurumu.contains('Tıkanıklık') || kacakDurumu.contains('Robot') || kacakDurumu.contains('Kamera')) {
        anaTesisatMaliyeti = 4000.0 * hatKatsayisi * yapiKatsayisi;
      } else if (kacakDurumu.contains('Onarım') || kacakDurumu.contains('Tamirat') || kacakDurumu.contains('Musluk')) {
        anaTesisatMaliyeti = 2500.0 * hatKatsayisi;
      }
    }

    double ekMontajMaliyeti = 0.0;
    if (armaturSayisi > 0) {
      ekMontajMaliyeti = armaturSayisi * 750.0;
    }

    double toplamFiyat = anaTesisatMaliyeti + ekMaliyet + ekMontajMaliyeti;

    double asgariBaraj = 16000.0;
    if (isKapsami.contains('Kaçak') || isKapsami.contains('Tıkanıklık') || isKapsami.contains('Onarım')) {
      asgariBaraj = 3500.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananHacim": islakHacimSayisi,
      "birimHacimFiyati": birimHacimFiyati,
      "anaTesisatMaliyeti": anaTesisatMaliyeti,
      "ekMaliyet": ekMaliyet,
      "ekMontajMaliyeti": ekMontajMaliyeti,
      "durum": "BAŞARILI"
    };
  }
}