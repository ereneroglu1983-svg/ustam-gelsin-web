// lib/core/calculation/meslekler/parke_doseme_hesaplayici.dart

class ParkeDosemeHesaplayici {

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

    final String isKapsami = findValue('is_kapsami', 'Laminat Parke (8mm-10mm Kilitli Sistem Standart)');
    final String ahsapCilaTipi = findValue('ahsap_cila_tipi', 'Çift Bileşenli Poliüretan Cila (Yüksek Parlaklık ve Aşınma Dayanımı)');
    final String supurgelikTipi = findValue('supurgelik_tipi', 'MDF Standart Süpürgelik (PVC veya İnce MDF Serisi)');
    final String altDolguTipi = findValue('alt_dolgu_tipi', 'Standart Şilte (2mm Beyaz Köpük Şilte)');

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

    double toplamM2 = 0.0;
    String m2String = '';

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'metre_kare' && element['cevap'] != null) {
          m2String = element['cevap'].toString();
          break;
        } else if (element.containsKey('metre_kare') && element['metre_kare'] != null) {
          m2String = element['metre_kare'].toString();
          break;
        }
      }
    }

    if (m2String.isNotEmpty) {
      if (m2String.contains('0-40')) {
        toplamM2 = 30.0;
      } else if (m2String.contains('40-60')) {
        toplamM2 = 50.0;
      } else if (m2String.contains('60-80')) {
        toplamM2 = 70.0;
      } else if (m2String.contains('80-100')) {
        toplamM2 = 90.0;
      } else if (m2String.contains('100-120')) {
        toplamM2 = 110.0;
      } else if (m2String.contains('120-150')) {
        toplamM2 = 135.0;
      } else if (m2String.contains('150+')) {
        toplamM2 = 180.0;
      } else {
        toplamM2 = double.tryParse(m2String.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      }
    }

    if (toplamM2 <= 0) {
      return {
        "tahminiButce": 0.0,
        "hesaplananM2": 0.0,
        "durum": "HATA",
        "mesaj": "Geçersiz metrekare verisi"
      };
    }

    double birimM2Fiyati = 260.0;
    bool isMasif = isKapsami.contains('Masif') || isKapsami.contains('Ahşap');

    if (isKapsami.contains('Lamine')) {
      birimM2Fiyati = 620.0;
    } else if (isMasif) {
      birimM2Fiyati = 1200.0;

      if (ahsapCilaTipi.contains('Su Bazlı') || ahsapCilaTipi.contains('Ekolojik')) {
        birimM2Fiyati += 280.0;
      } else if (ahsapCilaTipi.contains('Yağ') || ahsapCilaTipi.contains('Doğal Parke')) {
        birimM2Fiyati += 190.0;
      } else {
        birimM2Fiyati += 150.0;
      }
    } else if (isKapsami.contains('LVP') || isKapsami.contains('Vinil') || isKapsami.contains('PVC')) {
      birimM2Fiyati = 340.0;
    }

    double metretulTahmini = toplamM2 * 0.7;
    double supurgelikBirimFiyati = 95.0;

    if (supurgelikTipi.contains('Lake') || supurgelikTipi.contains('10cm')) {
      supurgelikBirimFiyati = 240.0;
    } else if (supurgelikTipi.contains('Alüminyum') || supurgelikTipi.contains('Metal')) {
      supurgelikBirimFiyati = 310.0;
    }

    double silteBirimFiyati = 45.0;
    if (altDolguTipi.contains('Kapron') || altDolguTipi.contains('Yerden Isıtma')) {
      silteBirimFiyati = 110.0;
    } else if (altDolguTipi.contains('Mantar') || altDolguTipi.contains('Akustik')) {
      silteBirimFiyati = 220.0;
    }

    double ekMaliyet = 0.0;
    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Kapı Altı') || o.contains('Kesimi') || o.contains('Tıraşlanması')) {
        ekMaliyet += 2000.0;
      }
      if (o.contains('Eşik') || o.contains('Kot Farkı') || o.contains('Profil')) {
        ekMaliyet += 2800.0;
      }
      if (o.contains('Eski Parke') || o.contains('Halı Sökümü') || o.contains('Söküm')) {
        ekMaliyet += (toplamM2 * 120.0);
      }
      if (o.contains('Zemin Şap') || o.contains('Akıllı Şap') || o.contains('Tesviye')) {
        ekMaliyet += (toplamM2 * 260.0);
      }
    }

    double toplamFiyat = (toplamM2 * (birimM2Fiyati + silteBirimFiyati)) +
        (metretulTahmini * supurgelikBirimFiyati) +
        ekMaliyet;

    double asgariBaraj = 9500.0;
    if (toplamM2 < 20) {
      asgariBaraj = 6000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": toplamM2,
      "hesaplananSupurgelikMetretul": metretulTahmini,
      "birimM2Fiyati": birimM2Fiyati,
      "silteBirimFiyati": silteBirimFiyati,
      "supurgelikBirimFiyati": supurgelikBirimFiyati,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}