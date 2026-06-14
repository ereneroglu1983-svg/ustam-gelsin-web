// lib/core/calculation/meslekler/asma_tavan_hesaplayici.dart

class AsmaTavanHesaplayici {
  static Map<String, dynamic> hesapla(List<dynamic> gelenCevaplar) {
    String findValue(String anahtar, String varsayilan) {
      for (var element in gelenCevaplar) {
        if (element is Map) {
          if (element['id'] == anahtar && element['cevap'] != null) {
            return element['cevap'].toString();
          }
          if (element.containsKey(anahtar) && element[anahtar] != null) {
            return element[anahtar].toString();
          }
        }
      }
      return varsayilan;
    }

    final String tavanTipi = findValue('tavan_tipi', 'Standart Alçıpan Tavan (Düz)');
    final String alanSegmenti = findValue('alan_segmenti', '20-50 m²');
    final String katYuksekligi = findValue('kat_yuksekligi', 'Standart (2.5 - 3 mt)');
    final String uygulamaAlan = findValue('uygulama_alan', 'Oda / Salon');
    final String m2String = findValue('metre_kare', '0');

    List<dynamic> ekstralar = [];
    for (var element in gelenCevaplar) {
      if (element is Map && (element['id'] == 'ekstra_detaylar' || element.containsKey('ekstra_detaylar'))) {
        var cevap = element['cevap'] ?? element['ekstra_detaylar'];
        if (cevap is List) {
          ekstralar = cevap;
          break;
        }
      }
    }

    double m2 = 35.0;
    double? parsedM2 = double.tryParse(m2String);

    if (parsedM2 != null && parsedM2 > 0) {
      m2 = parsedM2;
    } else {
      if (alanSegmenti.contains('0-20')) m2 = 15.0;
      else if (alanSegmenti.contains('20-50')) m2 = 35.0;
      else if (alanSegmenti.contains('50-100')) m2 = 75.0;
      else if (alanSegmenti.contains('100-300')) m2 = 200.0;
      else if (alanSegmenti.contains('300')) m2 = 450.0;
    }

    double birimM2Fiyati = 720.0;
    if (tavanTipi.contains('Metal') || tavanTipi.contains('Clip-in') || tavanTipi.contains('Modüler')) birimM2Fiyati = 1250.0;
    else if (tavanTipi.contains('Akustik') || tavanTipi.contains('Taşyünü')) birimM2Fiyati = 1050.0;
    else if (tavanTipi.contains('Vektörel') || tavanTipi.contains('Petek')) birimM2Fiyati = 1600.0;

    if (katYuksekligi.contains('Yüksek') || katYuksekligi.contains('3.5')) birimM2Fiyati *= 1.25;
    else if (katYuksekligi.contains('Endüstriyel') || katYuksekligi.contains('5')) birimM2Fiyati *= 1.50;

    if (uygulamaAlan.contains('Ofis') || uygulamaAlan.contains('Ticari')) birimM2Fiyati *= 1.05;
    else if (uygulamaAlan.contains('Mağaza') || uygulamaAlan.contains('Showroom')) birimM2Fiyati *= 1.10;
    else if (uygulamaAlan.contains('Hastane') || uygulamaAlan.contains('Kamusal')) birimM2Fiyati *= 1.15;

    double ekMaliyet = 0.0;
    for (var detay in ekstralar) {
      final String d = detay.toString();
      if (d.contains('Işık Bandı') || d.contains('Gölgelik')) ekMaliyet += (m2 * 380.0);
      else if (d.contains('Spot') || d.contains('Elektrik')) ekMaliyet += (m2 * 90.0);
      else if (d.contains('Isı Yalıtım') || d.contains('İzocam') || d.contains('Taşyünü')) ekMaliyet += (m2 * 180.0);
      else if (d.contains('Alçı Sıva') || d.contains('Boya')) ekMaliyet += (m2 * 240.0);
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + ekMaliyet;
    double asgariBaraj = (m2 > 100) ? 22000.0 : 14000.0;
    double nihaiSonuc = (toplamFiyat < asgariBaraj) ? asgariBaraj : toplamFiyat;

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}