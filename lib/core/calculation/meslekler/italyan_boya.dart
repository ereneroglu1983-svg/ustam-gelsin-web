class ItalyanBoyaHesaplayici {
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

    final String efektTipi = findValue('efekt_tipi', 'Mermer Dokulu (Stucco Veneziano - Yoğun Parlatmalı Lüks)');
    final String alanSegmenti = findValue('alan_segmenti', '10-30 m² (Vurgu Duvarı / TV Arkası / Salon Bloğu)');
    final String zeminHazirligi = findValue('zemin_hazirligi', 'Saten Alçı / Kusursuz Pürüzsüz Hazır Zemin');

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

    double m2 = 20.0;
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
      if (alanSegmenti.contains('0-10')) m2 = 6.0;
      else if (alanSegmenti.contains('10-30')) m2 = 20.0;
      else if (alanSegmenti.contains('30-70')) m2 = 50.0;
      else if (alanSegmenti.contains('70+')) m2 = 120.0;
    }

    double birimM2Fiyati = 1200.0;

    if (efektTipi.contains('Mermer') || efektTipi.contains('Stucco') || efektTipi.contains('Parlatma')) {
      birimM2Fiyati = 2200.0;
    } else if (efektTipi.contains('Kadife') || efektTipi.contains('Sedef') || efektTipi.contains('Sand')) {
      birimM2Fiyati = 1650.0;
    } else if (efektTipi.contains('Paslı') || efektTipi.contains('Metalik') || efektTipi.contains('Oksit')) {
      birimM2Fiyati = 1950.0;
    }

    double hazirlikMaliyeti = 0.0;
    if (zeminHazirligi.contains('Tamir') || zeminHazirligi.contains('Macun') || zeminHazirligi.contains('Gerekiyor') || zeminHazirligi.contains('Eski')) {
      hazirlikMaliyeti = (m2 * 280.0);
    }

    double ekMaliyet = 0.0;

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Wax') || o.contains('Cila')) {
        ekMaliyet += (m2 * 250.0);
      }
      if (o.contains('Altın') || o.contains('Gümüş') || o.contains('Varak')) {
        ekMaliyet += 12000.0;
      }
      if (o.contains('Dış Cephe') || o.contains('Nemli') || o.contains('Banyo')) {
        birimM2Fiyati *= 1.35;
      }
      if (o.contains('Yüksek Tavan') || o.contains('İskele')) {
        ekMaliyet += 6500.0;
      }
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + hazirlikMaliyeti + ekMaliyet;

    double asgariBaraj = 24000.0;
    if (m2 <= 12) {
      asgariBaraj = 16000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "hazirlikMaliyeti": hazirlikMaliyeti,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}