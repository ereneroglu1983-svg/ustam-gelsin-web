class CamBalkonHesaplayici {
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

    final String sistemTipi = findValue('sistem_tipi', 'Katlanır Cam Balkon (8mm Klasik Temperli Tek Cam)');
    final String motorMarka = findValue('motor_marka_secimi', 'Motor Markası Fark Etmez (Usta Standart Garantili Motor Taksın)');
    final String alanSegmenti = findValue('alan_segmenti', '5 - 10 m² Arası Standart Balkon');
    final String camRengi = findValue('cam_rengi', 'Şeffaf Cam (Standart Şeffaf Temperli)');
    final String profilRengi = findValue('profil_rengi', 'Eloksal Naturel (Gri / Mat Alüminyum)');

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
    if (alanSegmenti.contains('0-5')) {
      m2 = 3.5;
    } else if (alanSegmenti.contains('5-10')) {
      m2 = 7.5;
    } else if (alanSegmenti.contains('10-20')) {
      m2 = 15.0;
    } else if (alanSegmenti.contains('20-40')) {
      m2 = 30.0;
    } else if (alanSegmenti.contains('40+')) {
      m2 = 55.0;
    }

    if (m2 <= 0) {
      return {
        "tahminiButce": 0.0,
        "hesaplananM2": 0.0,
        "durum": "HATA",
        "mesaj": "Geçersiz cam balkon alan seçimi"
      };
    }

    double birimM2Fiyati = 3900.0;
    bool isGiyotin = sistemTipi.contains('Giyotin') || sistemTipi.contains('Motorlu');

    if (sistemTipi.contains('Isıcam') || sistemTipi.contains('Yalıtımlı')) {
      birimM2Fiyati = 5800.0;
    } else if (isGiyotin) {
      birimM2Fiyati = 8900.0;
    } else if (sistemTipi.contains('Sürgülü') || sistemTipi.contains('Sürme')) {
      birimM2Fiyati = 4600.0;
    }

    if (camRengi.contains('Füme') || camRengi.contains('Bronz') || camRengi.contains('Mavi')) {
      birimM2Fiyati += 550.0;
    }

    if (profilRengi.contains('Antrasit') || profilRengi.contains('Siyah') || profilRengi.contains('RAL')) {
      birimM2Fiyati += 650.0;
    } else if (profilRengi.contains('Ahşap') || profilRengi.contains('Transfer')) {
      birimM2Fiyati += 1100.0;
    } else if (profilRengi.contains('Beyaz')) {
      birimM2Fiyati += 400.0;
    }

    double ekMaliyet = 0.0;
    double zorlukCarpani = 1.0;

    if (isGiyotin) {
      if (motorMarka.contains('Somfy')) {
        ekMaliyet += 21000.0;
      } else if (motorMarka.contains('Becker') || motorMarka.contains('Cherubini')) {
        ekMaliyet += 16500.0;
      } else if (motorMarka.contains('Yerli')) {
        ekMaliyet += 10500.0;
      } else {
        ekMaliyet += 13000.0;
      }
    }

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();

      if (o.contains('Kavisli') || o.contains('Açılı') || o.contains('Köşe Dönüş')) {
        zorlukCarpani = 1.25;
      }
      if (o.contains('Plise Perde') || o.contains('Akordeon')) {
        ekMaliyet += (m2 * 1400.0);
      }
      if (o.contains('Çocuk Kilidi') || o.contains('Emniyetli')) {
        ekMaliyet += 1800.0;
      }
      if (o.contains('Pileli Sineklik') || o.contains('Sineklik')) {
        ekMaliyet += (m2 * 950.0);
      }
    }

    double toplamFiyat = ((m2 * birimM2Fiyati) + ekMaliyet) * zorlukCarpani;

    double asgariBaraj = 16500.0;
    if (isGiyotin) asgariBaraj = 40000.0;

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