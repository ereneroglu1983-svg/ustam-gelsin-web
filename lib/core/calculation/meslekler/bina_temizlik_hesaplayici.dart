class BinaTemizlikHesaplayici {
  static Map<String, dynamic> hesapla(List<dynamic> gelenCevaplar) {
    String findValue(String anahtar, String varsayilan) {
      for (var element in gelenCevaplar) {
        if (element is Map && element['id'] == anahtar) {
          return element['cevap']?.toString() ?? varsayilan;
        }
      }
      return varsayilan;
    }

    double findDoubleValue(String anahtar) {
      for (var element in gelenCevaplar) {
        if (element is Map && element['id'] == anahtar) {
          return double.tryParse(element['cevap']?.toString() ?? '0') ?? 0.0;
        }
      }
      return 0.0;
    }

    final double toplamM2 = findDoubleValue('alan_m2');
    final double odaSayisi = findDoubleValue('oda_bölüm_sayisi');

    final String temizlikTuru = findValue('temizlik_turu', '');
    final String erisimYontemi = findValue('erisim_yontemi', '');
    final String yapiTip = findValue('yapi_tip', '');
    final String periyot = findValue('periyot', '');

    List<dynamic> ekstralar = [];
    for (var element in gelenCevaplar) {
      if (element is Map && element['id'] == 'ekstra_ozellikler' && element['cevap'] is List) {
        ekstralar = element['cevap'];
        break;
      }
    }

    if (toplamM2 <= 0) {
      return {"tahminiButce": 0.0, "durum": "BAŞARISIZ", "mesaj": "Metrekare değeri girilmelidir."};
    }

    double birimM2Fiyati = 65.0;

    if (temizlikTuru.contains('Dış Cephe')) {
      birimM2Fiyati = 110.0;
    } else if (temizlikTuru.contains('Kaba Temizlik')) {
      birimM2Fiyati = 90.0;
    } else if (temizlikTuru.contains('Detaylı') || temizlikTuru.contains('İnce Temizlik')) {
      birimM2Fiyati = 140.0;
    } else if (temizlikTuru.contains('Merdiven')) {
      birimM2Fiyati = 45.0;
    }

    if (yapiTip.contains('Plaza') || yapiTip.contains('Gökdelen')) birimM2Fiyati *= 1.15;
    else if (yapiTip.contains('Villa')) birimM2Fiyati *= 1.10;
    else if (yapiTip.contains('Otel') || yapiTip.contains('Okul') || yapiTip.contains('Kamu')) birimM2Fiyati *= 1.20;

    double anaTemizlikMaliyeti = toplamM2 * birimM2Fiyati;
    double odaMaliyeti = (odaSayisi > 0 && !temizlikTuru.contains('Dış Cephe')) ? odaSayisi * 950.0 : 0.0;

    double erisimMaliyeti = 0.0;
    if (temizlikTuru.contains('Dış Cephe')) {
      if (erisimYontemi.contains('Vinç') || erisimYontemi.contains('Sepet')) erisimMaliyeti = 24000.0;
      else if (erisimYontemi.contains('Dağcı')) erisimMaliyeti = 32000.0;
      else if (erisimYontemi.contains('Asansör')) erisimMaliyeti = 9000.0;
    }

    double ekMaliyet = 0.0;
    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Zemin Cilalama') || o.contains('Mermer')) ekMaliyet += (toplamM2 * 120.0);
      if (o.contains('Buharlı')) ekMaliyet += 6500.0;
      if (o.contains('Kimyasal')) ekMaliyet += (toplamM2 * 45.0);
      if (o.contains('Cam Silimi')) ekMaliyet += 3500.0;
    }

    double toplamFiyat = anaTemizlikMaliyeti + odaMaliyeti + erisimMaliyeti + ekMaliyet;

    if (periyot.contains('Aylık')) toplamFiyat *= 0.85;
    else if (periyot.contains('3 Aylık')) toplamFiyat *= 0.90;
    else if (periyot.contains('6 Aylık')) toplamFiyat *= 0.95;

    double nihaiSonuc = toplamFiyat < 9000.0 ? 9000.0 : toplamFiyat;

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": toplamM2,
      "durum": "BAŞARILI"
    };
  }
}