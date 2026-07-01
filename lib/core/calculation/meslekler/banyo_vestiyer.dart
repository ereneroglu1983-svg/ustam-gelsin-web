class BanyoVestiyerHesaplayici {
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

    final String uygulamaTipi = findValue('uygulama_tipi', 'Vestiyer / Portmanto İmalatı (Antre Grubu)');
    final String banyoMalzeme = findValue('banyo_malzeme_tipi', 'Suya Dayanıklı Yeşil MDF Lam (Neme Karşı Dirençli Standart Gövde)');
    final String kuruAlanMalzeme = findValue('kuru_alan_malzemesi', 'Standart MDF Lam Gövde ve Kapak');
    final String dolapOlcusu = findValue('dolap_olcusu', 'Orta Ölçekli Alan (1 - 2 Metre Arası Standart Ölçü)');
    final String kapakModeli = findValue('kapak_modeli', 'Düz / Standart Modern Kapak Tasarımı');
    final String montajDurum = findValue('montaj_durum', 'Boş Alan / Sıfır Duvar Yuvası (Doğrudan Yeni Montaj)');
    final String yapiTip = findValue('yapi_tip', 'Apartman Dairesi');

    List<dynamic> ekstralar = [];
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_donanimlar' && element['cevap'] is List) {
          ekstralar = element['cevap'];
          break;
        } else if (element.containsKey('ekstra_donanimlar') && element['ekstra_donanimlar'] is List) {
          ekstralar = element['ekstra_donanimlar'];
          break;
        }
      }
    }

    double mt = 1.5;

    if (dolapOlcusu.contains('Küçük') || dolapOlcusu.contains('0-1')) {
      mt = 0.8;
    } else if (dolapOlcusu.contains('Orta') || dolapOlcusu.contains('1-2')) {
      mt = 1.5;
    } else if (dolapOlcusu.contains('Geniş') || dolapOlcusu.contains('2-3')) {
      mt = 2.5;
    } else if (dolapOlcusu.contains('Tam Boy') || dolapOlcusu.contains('Blok') || dolapOlcusu.contains('3 ve Üzeri')) {
      mt = 3.5;
    }

    double birimMtFiyati = 8200.0;
    bool isBanyoGrubu = uygulamaTipi.contains('Banyo') || uygulamaTipi.contains('Çamaşır');

    if (isBanyoGrubu) {
      birimMtFiyati = 10500.0;

      if (banyoMalzeme.contains('Lake')) {
        birimMtFiyati *= 1.70;
      } else if (banyoMalzeme.contains('Akrilik') || banyoMalzeme.contains('Highgloss') || banyoMalzeme.contains('Haygloss')) {
        birimMtFiyati *= 1.30;
      }
    } else {
      if (kuruAlanMalzeme.contains('Highgloss') || kuruAlanMalzeme.contains('Akrilik')) {
        birimMtFiyati *= 1.25;
      } else if (kuruAlanMalzeme.contains('Lake')) {
        birimMtFiyati *= 1.60;
      } else if (kuruAlanMalzeme.contains('Masif') || kuruAlanMalzeme.contains('Ahşap')) {
        birimMtFiyati *= 2.10;
      }
    }

    if (kapakModeli.contains('Çitalı') || kapakModeli.contains('Country')) {
      birimMtFiyati *= 1.15;
    }

    if (yapiTip.contains('Villa') || yapiTip.contains('Müstakil')) {
      birimMtFiyati *= 1.05;
    } else if (yapiTip.contains('Ofis') || yapiTip.contains('Ticari')) {
      birimMtFiyati *= 1.10;
    } else if (yapiTip.contains('Otel') || yapiTip.contains('Pansiyon')) {
      birimMtFiyati *= 1.15;
    }

    double ekMaliyet = 0.0;

    if (montajDurum.contains('Sökülecek') || montajDurum.contains('Demontaj')) {
      ekMaliyet += (mt * 650.0) + 1500.0;
    }

    for (var donanim in ekstralar) {
      final String d = donanim.toString();
      if (d.contains('Led') || d.contains('Aydınlatma')) {
        ekMaliyet += (mt * 1500.0);
      }
      if (d.contains('Cam Kapı') || d.contains('Cam Kapak') || d.contains('Alüminyum')) {
        ekMaliyet += (mt * 2400.0);
      }
      if (d.contains('Frenli') || d.contains('Menteşe') || d.contains('Ray')) {
        ekMaliyet += (mt * 950.0);
      }
      if (d.contains('Boy Aynası') || d.contains('Ayna Entegrasyonu')) {
        ekMaliyet += 4800.0;
      }
      if (d.contains('Seramik') || d.contains('Lavabo') || d.contains('Batarya')) {
        if (isBanyoGrubu) {
          ekMaliyet += 8500.0;
        }
      }
    }

    double toplamFiyat = (mt * birimMtFiyati) + ekMaliyet;

    double asgariBaraj = 18000.0;
    if (isBanyoGrubu) asgariBaraj = 13500.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananMt": mt,
      "birimMtFiyati": birimMtFiyati,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}