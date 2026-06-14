// lib/core/calculation/meslekler/panel_singil_hesaplayici.dart

class PanelSingilHesaplayici {

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

    final String isKapsami = findValue('is_kapsami', 'Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)');
    final String panelDolgu = findValue('panel_dolgu_tipi', 'Poliüretan Dolgu (PUR - Yüksek Isı Yalıtımlı Standart)');
    final String panelKalinlik = findValue('panel_kalinligi', '40 mm (Standart Konut ve Sundurma Tipi)');
    final String shingleModeli = findValue('shingle_modeli', 'Petek Model (Geleneksel Simetrik Hatlar)');
    final String katYuksekligi = findValue('kat_yuksekligi', '1-2 Katlı Bina (Alçak Yapı / İskele ve Erişim Kolay)');
    final String catiEgimi = findValue('cati_egimi', 'Normal Eğimli Çatı Yapısı (Standart Yürüme Alanı)');
    final String alanM2Secim = findValue('alan_m2_secim', '51 - 120 m² Arası (Standart Müstakil Ev / Küçük Depo)');

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
    if (alanM2Secim.contains('1-50') || alanM2Secim.contains('Küçük')) {
      m2 = 35.0;
    } else if (alanM2Secim.contains('51-120') || alanM2Secim.contains('Standart')) {
      m2 = 85.0;
    } else if (alanM2Secim.contains('121-250') || alanM2Secim.contains('Geniş')) {
      m2 = 180.0;
    } else if (alanM2Secim.contains('251-500') || alanM2Secim.contains('Büyük')) {
      m2 = 380.0;
    } else if (alanM2Secim.contains('500 Üzeri') || alanM2Secim.contains('Endüstriyel')) {
      m2 = 650.0;
    }

    if (m2 <= 0) {
      return {
        "tahminiButce": 0.0,
        "hesaplananM2": 0.0,
        "durum": "HATA",
        "mesaj": "Geçersiz çatı metrekare seçimi"
      };
    }

    double birimM2Fiyati = 450.0;

    if (isKapsami.contains('Sandviç') || isKapsami.contains('Panel')) {
      birimM2Fiyati = 850.0;

      if (panelDolgu.contains('Taş Yünü')) {
        birimM2Fiyati += 250.0;
      } else if (panelDolgu.contains('Polistiren') || panelDolgu.contains('EPS')) {
        birimM2Fiyati -= 100.0;
      }

      if (panelKalinlik.contains('50 mm')) {
        birimM2Fiyati += 80.0;
      } else if (panelKalinlik.contains('60 mm')) {
        birimM2Fiyati += 150.0;
      } else if (panelKalinlik.contains('80-100 mm') || panelKalinlik.contains('Soğuk Hava')) {
        birimM2Fiyati += 320.0;
      }

    } else if (isKapsami.contains('Şıngıl') || isKapsami.contains('Shingle')) {
      birimM2Fiyati = 780.0;

      if (shingleModeli.contains('Dikdörtgen') || shingleModeli.contains('Ejderha Dişi')) {
        birimM2Fiyati += 70.0;
      } else if (shingleModeli.contains('3 Gölgeli') || shingleModeli.contains('Premium')) {
        birimM2Fiyati += 140.0;
      }
    }

    double yukseklikCarpani = 1.0;
    if (katYuksekligi.contains('3-5 Kat') || katYuksekligi.contains('Yüksek Bina')) {
      yukseklikCarpani = 1.15;
    } else if (katYuksekligi.contains('5+ Kat') || katYuksekligi.contains('Endüstriyel')) {
      yukseklikCarpani = 1.25;
    }

    double egimCarpani = 1.0;
    if (catiEgimi.contains('Dik') || catiEgimi.contains('Dik Eğimli')) {
      egimCarpani = 1.20;
    }

    double ekMaliyet = 0.0;
    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Eski Çatı') || o.contains('Sökümü') || o.contains('Moloz')) {
        ekMaliyet += (m2 * 180.0);
      }
      if (o.contains('Ekstra Taş Yünü') || o.contains('Çatı Arası')) {
        ekMaliyet += (m2 * 220.0);
      }
      if (o.contains('Çift Kat') || o.contains('Arduvazlı') || o.contains('Su Yalıtımı')) {
        ekMaliyet += (m2 * 140.0);
      }
      if (o.contains('Eksiz Oluk') || o.contains('Dere')) {
        ekMaliyet += (m2 * 110.0);
      }
      if (o.contains('Mahya') || o.contains('Kenar Sacı') || o.contains('Rüzgar Tahtası')) {
        ekMaliyet += 16000.0;
      }
    }

    double toplamFiyat = ((m2 * birimM2Fiyati) * yukseklikCarpani * egimCarpani) + ekMaliyet;

    double asgariBaraj = 55000.0;
    if (m2 < 60) {
      asgariBaraj = 30000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "yukseklikCarpani": yukseklikCarpani,
      "egimCarpani": egimCarpani,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}