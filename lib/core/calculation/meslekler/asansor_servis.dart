class AsansorHesaplayici {
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

    final String hizmetTuru = findValue('hizmet_turu', 'Periyodik Aylık Bakım');

    String asansorTipiKontrol = findValue('asansor_tipi', '');
    if (asansorTipiKontrol.isEmpty) {
      asansorTipiKontrol = findValue('asansör_tipi', 'Halatlı (Makine Daireli)');
    }
    final String asansorTipi = asansorTipiKontrol;

    final String durakSegmenti = findValue('durak_sayisi', '2-4 Durak');
    final String binaTipi = findValue('bina_tipi', 'Konut / Apartman');
    final String etiketDurumu = findValue('etiket_durumu', 'Mavi (Hafif Kusurlu)');
    final String parcaGaranti = findValue('parca_garanti', 'CE Belgeli / Yerli Üretim');
    final String katSecimi = findValue('kat', 'Standart Apartman Segmenti (5 - 8 Kat)');

    List<dynamic> arizaBelirtileri = [];
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ariza_belirtisi' && element['cevap'] is List) {
          arizaBelirtileri = element['cevap'];
          break;
        } else if (element.containsKey('ariza_belirtisi') && element['ariza_belirtisi'] is List) {
          arizaBelirtileri = element['ariza_belirtisi'];
          break;
        }
      }
    }

    List<dynamic> modernizasyonUniteleri = [];
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'modernizasyon_kapsami' && element['cevap'] is List) {
          modernizasyonUniteleri = element['cevap'];
          break;
        } else if (element.containsKey('modernizasyon_kapsami') && element['modernizasyon_kapsami'] is List) {
          modernizasyonUniteleri = element['modernizasyon_kapsami'];
          break;
        }
      }
    }

    double durak = 3.0;

    if (katSecimi.contains('2-4') || katSecimi.contains('Zemin')) {
      durak = 3.0;
    } else if (katSecimi.contains('5-8') || katSecimi.contains('Standart Apartman')) {
      durak = 7.0;
    } else if (katSecimi.contains('9-15') || katSecimi.contains('Yüksek Katlı')) {
      durak = 12.0;
    } else if (katSecimi.contains('16+') || katSecimi.contains('Çok Yüksek')) {
      durak = 20.0;
    } else {
      if (durakSegmenti.contains('2-4')) durak = 3.0;
      else if (durakSegmenti.contains('5-8')) durak = 7.0;
      else if (durakSegmenti.contains('9-15')) durak = 12.0;
      else if (durakSegmenti.contains('16+')) durak = 20.0;
    }

    double tabanFiyat = 3800.0;

    if (hizmetTuru.contains('Acil Arıza')) {
      tabanFiyat = 5500.0;
    } else if (hizmetTuru.contains('Revizyon')) {
      tabanFiyat = 24000.0;
    } else if (hizmetTuru.contains('Modernizasyon')) {
      tabanFiyat = 165000.0;
    }

    if (binaTipi.contains('Hastane') || binaTipi.contains('Kamu')) {
      tabanFiyat *= 1.45;
    } else if (binaTipi.contains('Ticari') || binaTipi.contains('Otel')) {
      tabanFiyat *= 1.30;
    }

    if (asansorTipi.contains('MRL') || asansorTipi.contains('Makine Dairesiz')) {
      tabanFiyat *= 1.35;
    } else if (asansorTipi.contains('Hidrolik')) {
      tabanFiyat *= 1.25;
    } else if (asansorTipi.contains('Yük') || asansorTipi.contains('Araç')) {
      tabanFiyat *= 1.50;
    } else if (asansorTipi.contains('Panoramik')) {
      tabanFiyat *= 1.40;
    }

    if (parcaGaranti.contains('Global Marka') || parcaGaranti.contains('Orijinal')) {
      tabanFiyat *= 1.35;
    }

    double ekMaliyet = 0.0;

    if (hizmetTuru.contains('Revizyon')) {
      if (etiketDurumu.contains('Kırmızı')) {
        ekMaliyet += 18000.0;
      } else if (etiketDurumu.contains('Sarı')) {
        ekMaliyet += 8500.0;
      }
    }

    if (hizmetTuru.contains('Acil Arıza')) {
      for (var belirti in arizaBelirtileri) {
        final String b = belirti.toString();
        if (b.contains('Halat') || b.contains('Fren')) ekMaliyet += 22000.0;
        if (b.contains('Kapı')) ekMaliyet += 9500.0;
        if (b.contains('Sarsıntı') || b.contains('Gürültü')) ekMaliyet += 7000.0;
        if (b.contains('Pano')) ekMaliyet += 32000.0;
        if (b.contains('Sinyalizasyon') || b.contains('Buton')) ekMaliyet += 4500.0;
      }
    }

    if (hizmetTuru.contains('Modernizasyon')) {
      for (var unite in modernizasyonUniteleri) {
        final String u = unite.toString();
        if (u.contains('Motor')) ekMaliyet += 95000.0;
        if (u.contains('Kabin') || u.contains('Kapı')) ekMaliyet += 68000.0;
        if (u.contains('Halat')) ekMaliyet += 18000.0;
        if (u.contains('Pano') || u.contains('Inverter')) ekMaliyet += 48000.0;
        if (u.contains('Fotosel') || u.contains('Sensör')) ekMaliyet += 8000.0;
      }
    }

    if (hizmetTuru.contains('Bakım') && durak > 5) {
      ekMaliyet += (durak - 5) * 600.0;
    }

    double toplamFiyat = tabanFiyat + ekMaliyet;

    double asgariBaraj = 4500.0;
    if (hizmetTuru.contains('Modernizasyon')) asgariBaraj = 200000.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananDurak": durak,
      "tabanFiyat": tabanFiyat,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}