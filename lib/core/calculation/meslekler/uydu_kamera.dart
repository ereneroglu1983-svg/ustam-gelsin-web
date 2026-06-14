// lib/core/calculation/meslekler/uydu_kamera_hesaplayici.dart

class UyduKameraHesaplayici {

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

    final String isTuru = findValue('is_turu', 'Güvenlik Kamerası Sistemi (IP Tabanlı NVR Altyapısı)');
    final String kameraDetay = findValue('kamera_detay', 'NOT_SELECTED');
    final String uyduAltyapi = findValue('uydu_altyapi_tipi', 'NOT_SELECTED');
    final String mekanTipi = findValue('mekan_tipi', 'Daire Standart İç Mekan');
    final String kablolamaTipi = findValue('kablolama_tipi', 'UTP Kablolama');
    final String cihazAdedi = findValue('cihaz_adedi', '4 - 8 Arası Nokta / Hat Dağıtımı (Standart Konut / Ofis)');

    List<dynamic> networkEkipmanlari = [];
    List<dynamic> ekstralar = [];

    for (var element in gelenCevaplar) {
      if (element is Map && element['id'] == 'network_ekipman_detay' && element['cevap'] is List) {
        networkEkipmanlari = element['cevap'];
      }
      if (element is Map && element['id'] == 'ekstra_ozellikler' && element['cevap'] is List) {
        ekstralar = element['cevap'];
      }
    }

    double nihaiAdet = 4.0;

    if (cihazAdedi.contains('1-4') || cihazAdedi.contains('Küçük Ölçekli')) {
      nihaiAdet = 2.0;
    } else if (cihazAdedi.contains('4-8') || cihazAdedi.contains('Standart Konut')) {
      nihaiAdet = 6.0;
    } else if (cihazAdedi.contains('8-16') || cihazAdedi.contains('Geniş Yapı')) {
      nihaiAdet = 12.0;
    } else if (cihazAdedi.contains('16-32') || cihazAdedi.contains('Büyük İşletme')) {
      nihaiAdet = 24.0;
    } else if (cihazAdedi.contains('32+') || cihazAdedi.contains('Endüstriyel Proje')) {
      nihaiAdet = 48.0;
    }

    double tabanFiyat = 0.0;
    double cihazMaliyeti = 0.0;

    if (isTuru.contains('Uydu') || isTuru.contains('TV')) {
      tabanFiyat = 4500.0;
      double terminalBirimFiyati = 600.0;

      if (uyduAltyapi.contains('Merkezi') || uyduAltyapi.contains('Santral') || uyduAltyapi.contains('Multiswitch')) {
        tabanFiyat += 9500.0;
        terminalBirimFiyati = 950.0;
      } else if (uyduAltyapi.contains('Bireysel') || uyduAltyapi.contains('Çanak')) {
        tabanFiyat += 3200.0;
      } else if (uyduAltyapi.contains('Sinyal') || uyduAltyapi.contains('Ayar') || uyduAltyapi.contains('Frekans')) {
        tabanFiyat = 3000.0;
        terminalBirimFiyati = 0.0;
      } else if (uyduAltyapi.contains('Splitter') || uyduAltyapi.contains('Değişimi')) {
        tabanFiyat = 3800.0;
        terminalBirimFiyati = 450.0;
      }

      cihazMaliyeti = nihaiAdet * terminalBirimFiyati;

    } else if (isTuru.contains('İnternet') || isTuru.contains('Network') || isTuru.contains('Kabin')) {
      tabanFiyat = 5500.0;
      double dataUcuBirimFiyati = 1200.0;

      for (var ekipman in networkEkipmanlari) {
        final String e = ekipman.toString();
        if (e.contains('Access') || e.contains('Mesh') || e.contains('Kablosuz')) {
          tabanFiyat += 5800.0;
        }
        if (e.contains('Sistem Odası') || e.contains('Rack') || e.contains('Switch')) {
          tabanFiyat += 8500.0;
        }
        if (e.contains('Kurumsal') || e.contains('Router') || e.contains('VLAN') || e.contains('Firewall')) {
          tabanFiyat += 1400.0;
        }
      }

      cihazMaliyeti = nihaiAdet * dataUcuBirimFiyati;

    } else {
      tabanFiyat = 9800.0;
      double kameraBirimFiyati = 3400.0;

      if (kameraDetay.contains('4K') || kameraDetay.contains('Ultra HD') || kameraDetay.contains('Premium')) {
        kameraBirimFiyati = 5600.0;
      } else if (kameraDetay.contains('AI') || kameraDetay.contains('Yapay Zeka') || kameraDetay.contains('Plaka') || kameraDetay.contains('Yüz')) {
        kameraBirimFiyati = 7800.0;
      } else if (kameraDetay.contains('Color') || kameraDetay.contains('Renkli') || kameraDetay.contains('Ses')) {
        kameraBirimFiyati = 4800.0;
      }

      final String ekstralarString = ekstralar.toString();
      if (ekstralarString.contains('4K Ultra')) kameraBirimFiyati += 2200.0;
      if (ekstralarString.contains('AI Yapay')) kameraBirimFiyati += 3000.0;
      if (ekstralarString.contains('PTZ') || ekstralarString.contains('Motorize') || ekstralarString.contains('Takip')) {
        kameraBirimFiyati += 8500.0;
      }

      cihazMaliyeti = nihaiAdet * kameraBirimFiyati;
    }

    double mekanCarpani = 1.0;
    if (mekanTipi.contains('Villa') || mekanTipi.contains('Müstakil')) {
      mekanCarpani = 1.40;
    } else if (mekanTipi.contains('Fabrika') || mekanTipi.contains('Depo') || mekanTipi.contains('Site')) {
      mekanCarpani = 1.95;
    }

    double kabloMaliyeti = 0.0;
    if (kablolamaTipi.contains('Fiber') || kablolamaTipi.contains('Pigtail') || kablolamaTipi.contains('Füzyon')) {
      kabloMaliyeti = nihaiAdet * 1500.0;
    } else if (kablolamaTipi.contains('Sıva Altı') || kablolamaTipi.contains('Kırım') || kablolamaTipi.contains('Spiral')) {
      kabloMaliyeti = nihaiAdet * 1200.0;
    } else {
      kabloMaliyeti = nihaiAdet * 550.0;
    }

    double zorlukEkstra = 0.0;
    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Platform') || o.contains('Vinç') || o.contains('İrtifa') || o.contains('Çatı')) {
        zorlukEkstra += 6500.0;
      }
      if (o.contains('Kesintisiz') || o.contains('UPS') || o.contains('Akü')) {
        zorlukEkstra += 4800.0;
      }
    }

    double toplamFiyat = (tabanFiyat + cihazMaliyeti + kabloMaliyeti + zorlukEkstra) * mekanCarpani;

    double asgariBaraj = 8500.0;
    if (isTuru.contains('Uydu') && uyduAltyapi.contains('Sinyal')) {
      asgariBaraj = 3500.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananCihazAdedi": nihaiAdet,
      "tabanFiyat": tabanFiyat,
      "cihazMaliyeti": cihazMaliyeti,
      "kabloMaliyeti": kabloMaliyeti,
      "zorlukEkstra": zorlukEkstra,
      "mekanCarpani": mekanCarpani,
      "durum": "BAŞARILI"
    };
  }
}