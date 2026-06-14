class AlciSivaHesaplayici {
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

    final String uygulamaTipi = findValue('uygulama_tipi', 'İç Mekan Alçı Sıva');
    final String zeminDurumu = findValue('zemin_durumu', 'Tuğla / Bims / Beton (Kaba İnşaat)');
    final String alanSegmenti = findValue('alan_segmenti', '50-100 m²');

    List<dynamic> ekstralar = [];
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_islemler' && element['cevap'] is List) {
          ekstralar = element['cevap'];
          break;
        } else if (element.containsKey('ekstra_islemler') && element['ekstra_islemler'] is List) {
          ekstralar = element['ekstra_islemler'];
          break;
        }
      }
    }

    double m2 = 75.0;
    String m2String = '0';

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

    double? parsedM2 = double.tryParse(m2String);
    if (parsedM2 != null && parsedM2 > 0) {
      m2 = parsedM2;
    } else {
      if (alanSegmenti.contains('0-50')) m2 = 30.0;
      else if (alanSegmenti.contains('50-100')) m2 = 75.0;
      else if (alanSegmenti.contains('100-200')) m2 = 150.0;
      else if (alanSegmenti.contains('200-500')) m2 = 350.0;
      else if (alanSegmenti.contains('500')) m2 = 600.0;
    }

    double birimM2Fiyati = 280.0;

    if (zeminDurumu.contains('Alçıpan')) {
      birimM2Fiyati = 210.0;
    } else if (zeminDurumu.contains('Eski Boyalı') || zeminDurumu.contains('Kazımalı')) {
      birimM2Fiyati = 340.0;
    } else if (zeminDurumu.contains('Tuğla') || zeminDurumu.contains('Bims') || zeminDurumu.contains('Kaba İnşaat')) {
      birimM2Fiyati = 310.0;
    }

    if (uygulamaTipi.contains('Dış Cephe')) {
      birimM2Fiyati *= 1.45;
    } else if (uygulamaTipi.contains('Dekoratif')) {
      birimM2Fiyati *= 1.35;
    }

    double ekMaliyet = 0.0;

    for (var islem in ekstralar) {
      final String i = islem.toString();
      if (i.contains('Sıva Filesi')) {
        ekMaliyet += (m2 * 65.0);
      }
      if (i.contains('Köşe Profili')) {
        ekMaliyet += (m2 * 45.0);
      }
      if (i.contains('İskele')) {
        ekMaliyet += 9500.0;
      }
      if (i.contains('Tamir')) {
        ekMaliyet += (m2 * 40.0);
      }
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + ekMaliyet;

    double asgariBaraj = 12000.0;
    if (m2 > 100) asgariBaraj = 18000.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}