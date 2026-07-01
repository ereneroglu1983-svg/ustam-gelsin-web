// lib/core/calculation/meslekler/sineklik_panjur_hesaplayici.dart

class SineklikPanjurHesaplayici {

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

    final String hizmetTuru = findValue('hizmet_turu', 'Sadece Sineklik Sistemleri');
    final String panjurIciSineklikDurum = findValue('panjur_ici_sineklik_durum', 'Hayır, Sadece Panjur İmalatı Yapılsın');

    final String sineklikTipi = findValue('sineklik_tipi', 'Plise (Pileli) Sineklik (Akordeon Katlanır Standart Sistem)');
    final String sineklikTipiPanjurIci = findValue('sineklik_tipi_panjur_ici', 'Plise (Pileli) Sineklik (Akordeon Katlanır Standart Sistem)');

    final String panjurTipi = findValue('panjur_tipi', 'Manuel Makaralı Panjur (Standart İpli / Duvar Makaralı Sistem)');
    final String yapiTip = findValue('yapi_tip', 'Apartman Dairesi');
    final String montajZemin = findValue('montaj_zemin', 'PVC Doğrama Hazır Kasa');

    String aktifSineklikTipi = sineklikTipi;
    if (hizmetTuru.contains('Panjur') && panjurIciSineklikDurum.contains('Evet')) {
      aktifSineklikTipi = sineklikTipiPanjurIci;
    }

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

    String secilenAdetBarem = findValue('dograma_adedi_secim', '1 Adet');
    double adet = 1.0;

    if (secilenAdetBarem.contains('2 - 4')) {
      adet = 3.0;
    } else if (secilenAdetBarem.contains('5 - 8')) {
      adet = 6.0;
    } else if (secilenAdetBarem.contains('9 - 14')) {
      adet = 11.0;
    } else if (secilenAdetBarem.contains('14 Adet Üzeri')) {
      adet = 16.0;
    } else {
      adet = 1.0;
    }

    String secilenM2Barem = findValue('panjur_alani_secim', '3 - 6 m²');
    double alanM2 = 0.0;

    if (hizmetTuru.contains('Panjur')) {
      if (secilenM2Barem.contains('0 - 3')) {
        alanM2 = 2.0;
      } else if (secilenM2Barem.contains('3 - 6')) {
        alanM2 = 4.5;
      } else if (secilenM2Barem.contains('6 - 12')) {
        alanM2 = 9.0;
      } else if (secilenM2Barem.contains('12 - 20')) {
        alanM2 = 16.0;
      } else if (secilenM2Barem.contains('20 m² ve Üzeri')) {
        alanM2 = 25.0;
      }
    }

    double yapiKatsayisi = 1.0;
    if (yapiTip.contains('Villa') || yapiTip.contains('Müstakil') || yapiTip.contains('Yazlık')) {
      yapiKatsayisi = 1.25;
    }

    double zeminKatsayisi = 1.0;
    if (montajZemin.contains('Alüminyum')) {
      zeminKatsayisi = 1.15;
    } else if (montajZemin.contains('Ahşap')) {
      zeminKatsayisi = 1.10;
    } else if (montajZemin.contains('Mermer') || montajZemin.contains('Beton') || montajZemin.contains('Dış Cephe')) {
      zeminKatsayisi = 1.35;
    }

    double sineklikBirimFiyati = 0.0;
    double anaSineklikMaliyeti = 0.0;

    if (hizmetTuru.contains('Sineklik') || (hizmetTuru.contains('Panjur') && panjurIciSineklikDurum.contains('Evet'))) {
      sineklikBirimFiyati = 1500.0;
      if (aktifSineklikTipi.contains('Sabit') || aktifSineklikTipi.contains('Ekonomik')) {
        sineklikBirimFiyati = 850.0;
      } else if (aktifSineklikTipi.contains('Sürgülü') || aktifSineklikTipi.contains('Duble') || aktifSineklikTipi.contains('Rulman')) {
        sineklikBirimFiyati = 2400.0;
      }
      anaSineklikMaliyeti = (adet * sineklikBirimFiyati) * zeminKatsayisi;
    }

    double panjurMaliyeti = 0.0;
    if (hizmetTuru.contains('Panjur')) {
      double panjurBirimFiyati = 4800.0;

      if (panjurTipi.contains('Motorlu') || panjurTipi.contains('Otomatik') || panjurTipi.contains('Kumandalı')) {
        panjurBirimFiyati = 7800.0;
      }
      panjurMaliyeti = (alanM2 * panjurBirimFiyati) * yapiKatsayisi * zeminKatsayisi;
    }

    double ekMaliyet = 0.0;
    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Kedi') || o.contains('Köpek') || o.contains('Çelik Tel')) {
        ekMaliyet += (adet * 1400.0);
      }
      if (o.contains('Akıllı Ev') || o.contains('Otomasyon') || o.contains('Role')) {
        if (hizmetTuru.contains('Panjur')) {
          ekMaliyet += (adet * 3500.0);
        }
      }
      if (o.contains('Antrasit') || o.contains('Özel Renk') || o.contains('Profil')) {
        ekMaliyet += (adet * 600.0) + (alanM2 * 550.0);
      }
      if (o.contains('Söküm') || o.contains('Revizyon') || o.contains('Eski Panjur')) {
        ekMaliyet += (adet * 650.0);
      }
    }

    double toplamFiyat = anaSineklikMaliyeti + panjurMaliyeti + ekMaliyet;

    double asgariBaraj = 5500.0;
    if (hizmetTuru.contains('Panjur')) {
      asgariBaraj = 18000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananAdet": adet,
      "hesaplananM2": alanM2,
      "sineklikBirimFiyati": sineklikBirimFiyati,
      "panjurMaliyeti": panjurMaliyeti,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}