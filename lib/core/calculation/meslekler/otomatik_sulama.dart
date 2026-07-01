class OtomatikSulamaHesaplayici {

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

    final String isKapsami = findValue('is_kapsami', 'Pop-up Sprinkler (Çim Alan İçin Toprak Altı Gömülü Borulama ve Hat Kazısı Hizmeti)');
    final String kontrolUnitesi = findValue('kontrol_unitesi', 'Standart Dijital Panel (İç/Dış Mekan Zamanlayıcılı Programlanabilir Otomatik Saat)');
    final String suKaynagi = findValue('su_kaynagi', 'Şebeke Hattı (Yeterli Statik Basınç ve Dinamik Debi Mevcut)');
    final String araziYapisi = findValue('arazi_yapisi', 'Düz Zemin Yapısı (Standart Yumuşak Toprak / Kolay Kazı)');
    final String alanM2Secim = findValue('alan_m2', '101 - 300 m² Arası (Standart Villa / Müstakil Ev Bahçesi)');

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

    double m2 = 0.0;

    if (alanM2Secim.contains('0-100') || alanM2Secim.contains('Küçük Ölçekli')) {
      m2 = 50.0;
    } else if (alanM2Secim.contains('101-300') || alanM2Secim.contains('Standart Villa')) {
      m2 = 200.0;
    } else if (alanM2Secim.contains('301-600') || alanM2Secim.contains('Geniş Peyzaj')) {
      m2 = 450.0;
    } else if (alanM2Secim.contains('601-1000') || alanM2Secim.contains('Büyük Ticari')) {
      m2 = 800.0;
    } else if (alanM2Secim.contains('1000+') || alanM2Secim.contains('Geniş Tarım')) {
      m2 = 1500.0;
    }

    if (m2 <= 0) {
      return {
        "tahminiButce": 0.0,
        "hesaplananM2": 0.0,
        "durum": "HATA",
        "mesaj": "Geçersiz metrekare verisi"
      };
    }

    double birimM2Fiyati = 85.0;
    bool isPopup = isKapsami.contains('Pop-up') || isKapsami.contains('Sprinkler');

    if (isPopup) {
      birimM2Fiyati = 245.0;
    } else if (isKapsami.contains('Mikro') || isKapsami.contains('Sisleme')) {
      birimM2Fiyati = 160.0;
    }

    double otomasyonMaliyeti = 6500.0;
    if (kontrolUnitesi.contains('Wi-Fi') || kontrolUnitesi.contains('Mobil')) {
      otomasyonMaliyeti = 19500.0;
    } else if (kontrolUnitesi.contains('Hava İstasyonlu') || kontrolUnitesi.contains('Profesyonel')) {
      otomasyonMaliyeti = 29000.0;
    }

    double hidroforMaliyeti = 0.0;
    if (isPopup) {
      if (suKaynagi.contains('Kuyu') || suKaynagi.contains('Depo') || suKaynagi.contains('Basınç Düşük')) {
        hidroforMaliyeti = 26000.0;
      }
    }

    double ekMaliyet = 0.0;
    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Ekstra Selenoid') || o.contains('Vana Montajı')) {
        ekMaliyet += 5200.0;
      }
      if (o.contains('Yağmur') || o.contains('Nem Sensörü')) {
        ekMaliyet += 5800.0;
      }
      if (o.contains('Sert Zemin') || o.contains('Kırımı')) {
        ekMaliyet += (m2 * 60.0);
      }
      if (o.contains('Gübreleme') || o.contains('Venturi')) {
        ekMaliyet += 8800.0;
      }
    }

    double araziCarpani = 1.0;
    if (araziYapisi.contains('Eğimli') || araziYapisi.contains('Kayalık') || araziYapisi.contains('Sert Kayalık')) {
      araziCarpani = 1.35;
    }

    double toplamFiyat = ((m2 * birimM2Fiyati) + otomasyonMaliyeti + hidroforMaliyeti + ekMaliyet) * araziCarpani;

    double asgariBaraj = 22000.0;
    if (!isPopup) {
      asgariBaraj = 14000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "otomasyonMaliyeti": otomasyonMaliyeti,
      "hidroforMaliyeti": hidroforMaliyeti,
      "ekMaliyet": ekMaliyet,
      "araziCarpani": araziCarpani,
      "durum": "BAŞARILI"
    };
  }
}