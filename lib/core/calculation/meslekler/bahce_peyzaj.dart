class BahcePeyzajHesaplayici {
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

    final String uygulamaTipi = findValue('uygulama_tipi', 'Sadece Çim Ekimi / Serimi Uygulaması');
    final String cimTuru = findValue('cim_turu', 'Tohum Çim Ekimi (Mevsimsel Karışım Tohum ile Ekonomik Çimlendirme)');
    final String sulamaDetay = findValue('sulama_detay', 'Sadece Manuel Vana ve Bahçe Sulama Hat Çekimi');
    final String alanSegmenti = findValue('alan_segmenti', '51-100 m² Arası (Standart Konut / Müstakil Ev Bahçesi)');
    final String zeminDurumu = findValue('zemin_durumu', 'Normal Toprak Yapısı (Düz ve Temiz Zemin)');
    final String yapiTip = findValue('yapi_tip', 'Müstakil Ev / Villa Bahçesi');

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

    double m2 = 75.0;

    if (alanSegmenti.contains('0-50')) {
      m2 = 30.0;
    } else if (alanSegmenti.contains('51-100')) {
      m2 = 75.0;
    } else if (alanSegmenti.contains('100-250')) {
      m2 = 175.0;
    } else if (alanSegmenti.contains('250-500')) {
      m2 = 375.0;
    } else if (alanSegmenti.contains('500+')) {
      m2 = 750.0;
    }

    double birimM2Fiyati = 320.0;

    if (cimTuru.contains('Rulo')) {
      birimM2Fiyati = 680.0;
    } else if (cimTuru.contains('Yapay') || cimTuru.contains('Sentetik')) {
      birimM2Fiyati = 950.0;
    }

    double zeminKatsayisi = 1.0;
    if (zeminDurumu.contains('Sert') || zeminDurumu.contains('Taşlı')) {
      zeminKatsayisi = 1.30;
    } else if (zeminDurumu.contains('Eğimli')) {
      zeminKatsayisi = 1.45;
    }

    if (uygulamaTipi.contains('Komple')) {
      birimM2Fiyati *= 1.85;

      if (sulamaDetay.contains('Pop-up')) {
        birimM2Fiyati += 280.0;
      } else if (sulamaDetay.contains('Damlama')) {
        birimM2Fiyati += 190.0;
      } else if (sulamaDetay.contains('Akıllı Saat') || sulamaDetay.contains('Komple Otomatik')) {
        birimM2Fiyati += 450.0;
      } else if (sulamaDetay.contains('Manuel')) {
        birimM2Fiyati += 90.0;
      }
    }

    if (yapiTip.contains('Site') || yapiTip.contains('Apartman')) {
      birimM2Fiyati *= 1.05;
    } else if (yapiTip.contains('İşyeri') || yapiTip.contains('Fabrika')) {
      birimM2Fiyati *= 1.10;
    } else if (yapiTip.contains('Teras') || yapiTip.contains('Çatı')) {
      birimM2Fiyati *= 1.40;
    }

    double ekMaliyet = 0.0;

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Drenaj')) {
        ekMaliyet += (m2 * 220.0);
      }
      if (o.contains('Yürüyüş Yolu') || o.contains('Kayrak Taşı')) {
        ekMaliyet += (m2 * 550.0);
      }
      if (o.contains('Aydınlatma')) {
        ekMaliyet += 35000.0;
      }
      if (o.contains('Gübre') || o.contains('Toprak İyileştirici')) {
        ekMaliyet += (m2 * 75.0);
      }
    }

    double toplamFiyat = (m2 * birimM2Fiyati * zeminKatsayisi) + ekMaliyet;

    double asgariBaraj = 25000.0;
    if (m2 > 100) asgariBaraj = 45000.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "zeminKatsayisi": zeminKatsayisi,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}