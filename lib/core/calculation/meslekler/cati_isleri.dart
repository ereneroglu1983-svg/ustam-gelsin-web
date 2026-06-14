class CatiIsleriHesaplayici {
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

    final String hizmetTuru = findValue('hizmet_turu', 'Sıfırdan Çatı Yapımı (Yeni Çatı Konstrüksiyonu ve Kaplama)');
    final String alanSegmenti = findValue('alan_segmenti', '100-200 m² Arası Geniş Bina / Apartman Bloğu');
    final String karkasTipi = findValue('karkas_tipi', 'Ahşap Karkas (1. Sınıf Kereste İskelet Kurulumu)');
    final String kaplamaTipi = findValue('kaplama_tipi', 'Kiremit Kaplama (Geleneksel Kil Kiremit Örtüsü)');
    final String yapiTip = findValue('yapi_tip', 'Müstakil Ev / Villa / Bungalov');
    final String malzemeTedarik = findValue('malzeme_tedarik', 'Malzeme Dahil (Tüm Sarf Malzemeleri ve Nakliye Ustaya Ait)');

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

    double m2 = 150.0;

    if (alanSegmenti.contains('0-50')) {
      m2 = 35.0;
    } else if (alanSegmenti.contains('50-100')) {
      m2 = 75.0;
    } else if (alanSegmenti.contains('100-200')) {
      m2 = 150.0;
    } else if (alanSegmenti.contains('200-400')) {
      m2 = 300.0;
    } else if (alanSegmenti.contains('400+')) {
      m2 = 550.0;
    }

    double birimM2Fiyati = 1600.0;
    bool isSifirdan = hizmetTuru.contains('Sıfırdan') || hizmetTuru.contains('Yeni');
    bool isAktarma = hizmetTuru.contains('Aktarma') || hizmetTuru.contains('Onarım');
    bool isKaplamaYenileme = hizmetTuru.contains('Sandviç') || hizmetTuru.contains('Shingle') || hizmetTuru.contains('Üst Örtü');
    bool isSadeceYalitir = hizmetTuru.contains('İzolasyon') || hizmetTuru.contains('Yalıtım');
    bool isOlukDere = hizmetTuru.contains('Oluk') || hizmetTuru.contains('Dere') || hizmetTuru.contains('Drenaj');

    if (isAktarma) {
      birimM2Fiyati = 750.0;
    } else if (isKaplamaYenileme) {
      birimM2Fiyati = 1100.0;
    } else if (isSadeceYalitir) {
      birimM2Fiyati = 550.0;
    } else if (isOlukDere) {
      birimM2Fiyati = 350.0;
    }

    if (isSifirdan) {
      if (karkasTipi.contains('Çelik') || karkasTipi.contains('Metal') || karkasTipi.contains('Profil')) {
        birimM2Fiyati += 950.0;
      } else {
        birimM2Fiyati += 350.0;
      }
    }

    if (isSifirdan || isAktarma || isKaplamaYenileme) {
      if (kaplamaTipi.contains('Sandviç') || kaplamaTipi.contains('Panel')) {
        birimM2Fiyati += 650.0;
      } else if (kaplamaTipi.contains('Shingle') || kaplamaTipi.contains('OSB')) {
        birimM2Fiyati += 450.0;
      } else if (kaplamaTipi.contains('Eternit') || kaplamaTipi.contains('Trapez') || kaplamaTipi.contains('Sac')) {
        birimM2Fiyati += 250.0;
      } else {
        birimM2Fiyati += 150.0;
      }
    }

    if (yapiTip.contains('Villa') || yapiTip.contains('Müstakil')) {
      birimM2Fiyati *= 1.05;
    } else if (yapiTip.contains('Fabrika') || yapiTip.contains('Depo') || yapiTip.contains('Endüstriyel')) {
      birimM2Fiyati *= 0.95;
    } else if (yapiTip.contains('Apartman') || yapiTip.contains('Site')) {
      birimM2Fiyati *= 1.10;
    }

    bool sadeceIscilikMi = malzemeTedarik.contains('Sadece İşçilik') || malzemeTedarik.contains('Müşteriye Ait');
    if (sadeceIscilikMi) {
      birimM2Fiyati *= 0.40;
    }

    double ekMaliyet = 0.0;
    double zorlukCarpani = 1.0;

    for (var detay in ekstralar) {
      final String d = detay.toString();

      if (d.contains('Isı Yalıtım') || d.contains('Taşyünü') || d.contains('İzocam')) {
        ekMaliyet += (m2 * (sadeceIscilikMi ? 100.0 : 420.0));
      }
      if (d.contains('Su Yalıtım') || d.contains('Membran') || d.contains('Saloma')) {
        ekMaliyet += (m2 * (sadeceIscilikMi ? 90.0 : 340.0));
      }
      if (d.contains('Gizli Dere') || d.contains('Asma Oluk') || d.contains('Oluk Sistemi')) {
        ekMaliyet += (m2 * (sadeceIscilikMi ? 70.0 : 260.0));
      }
      if (d.contains('Baca Kenarı') || d.contains('Baca Tamiri') || d.contains('Çinko')) {
        ekMaliyet += (sadeceIscilikMi ? 1500.0 : 6000.0);
      }

      if (d.contains('Dik Eğim') || d.contains('Halatlı') || d.contains('Zorlu İşçilik')) {
        zorlukCarpani += 0.20;
      }
      if (d.contains('Yüksek Kat') || d.contains('Vinç') || d.contains('İskele')) {
        zorlukCarpani += 0.15;
      }
    }

    double toplamFiyat = ((m2 * birimM2Fiyati) + ekMaliyet) * zorlukCarpani;

    double asgariBaraj = sadeceIscilikMi ? 15000.0 : 45000.0;
    if (isAktarma || isKaplamaYenileme) {
      asgariBaraj = sadeceIscilikMi ? 10000.0 : 25000.0;
    } else if (isSadeceYalitir || isOlukDere) {
      asgariBaraj = sadeceIscilikMi ? 7500.0 : 16000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "ekMaliyet": ekMaliyet,
      "zorlukCarpani": zorlukCarpani,
      "durum": "BAŞARILI"
    };
  }
}