// lib/core/calculation/meslekler/sistre_cila_hesaplayici.dart

class SistreCilaHesaplayici {

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

    final String islemKapsam = findValue('islem_kapsam', 'Komple Sistre (Zımpara) + Cila İşlemi');
    final String yipranmaDurumu = findValue('yipranma_durumu', 'NOT_SELECTED');
    final String cilaTipi = findValue('cila_tipi', 'Poliüretan (Çift Bileşenli Standart Parlak/Mat Cila)');

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

    double birimM2Fiyati = 0.0;
    bool zimparaVarMi = true;

    if (islemKapsam.contains('Sadece Cila') || islemKapsam.contains('Zımparasız')) {
      zimparaVarMi = false;
      birimM2Fiyati = 280.0;

      if (cilaTipi.contains('Su Bazlı') || cilaTipi.contains('Kokusuz') || cilaTipi.contains('İthal')) {
        birimM2Fiyati = 450.0;
      } else if (cilaTipi.contains('Trafik') || cilaTipi.contains('Çift Komponent')) {
        birimM2Fiyati = 580.0;
      }

    } else {
      birimM2Fiyati = 480.0;

      if (cilaTipi.contains('Su Bazlı') || cilaTipi.contains('Kokusuz') || cilaTipi.contains('İthal')) {
        birimM2Fiyati = 690.0;
      } else if (cilaTipi.contains('Trafik') || cilaTipi.contains('Çift Komponent')) {
        birimM2Fiyati = 880.0;
      }

      if (yipranmaDurumu.contains('Çok Derin') || yipranmaDurumu.contains('Yüksek') || yipranmaDurumu.contains('Şişme')) {
        birimM2Fiyati += 140.0;
      }
    }

    double anaSistreMaliyeti = toplamM2 * birimM2Fiyati;

    double ekMaliyet = 0.0;
    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();

      if (o.contains('Macun Dolgu') || o.contains('Toz') || o.contains('Derz')) {
        if (zimparaVarMi) {
          ekMaliyet += (toplamM2 * 110.0);
        }
      }
      if (o.contains('Renk Değişimi') || o.contains('Boyama') || o.contains('Lake')) {
        ekMaliyet += (toplamM2 * 320.0);
      }
      if (o.contains('Süpürgelik') || o.contains('Sökülmesi') || o.contains('Kenar')) {
        ekMaliyet += 4500.0;
      }
      if (o.contains('Lamine Parke') || o.contains('Hassas Zımpara')) {
        ekMaliyet += (toplamM2 * 90.0);
      }
    }

    double toplamFiyat = anaSistreMaliyeti + ekMaliyet;

    double asgariBaraj = 15000.0;
    if (!zimparaVarMi) {
      asgariBaraj = 6000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": toplamM2,
      "birimM2Fiyati": birimM2Fiyati,
      "anaSistreMaliyeti": anaSistreMaliyeti,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}