class KartonpiyerHesaplayici {
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

    final String malzemeTipi = findValue('malzeme_tipi', 'Stropiyer Köpük (Ekonomik Hafif Seri)');
    final String metrajSegmenti = findValue('metraj_segmenti', '10-30 Metretül Arası');
    final String tasarimKarmasikligi = findValue('tasarim_karmasikligi', 'Düz / Standart Hat');
    final String metrajM2 = findValue('metraj_m2', '10-25 m²');
    final String metrajMetre = findValue('metraj_metre', '15-30 Metre');

    List<dynamic> ekstralar = [];
    List<dynamic> uygulamaAlanlari = [];

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_ozellikler' && element['cevap'] is List) {
          ekstralar = element['cevap'];
        } else if (element.containsKey('ekstra_ozellikler') && element['ekstra_ozellikler'] is List) {
          ekstralar = element['ekstra_ozellikler'];
        }

        if (element['id'] == 'uygulama_alan' && element['cevap'] is List) {
          uygulamaAlanlari = element['cevap'];
        } else if (element.containsKey('uygulama_alan') && element['uygulama_alan'] is List) {
          uygulamaAlanlari = element['uygulama_alan'];
        }
      }
    }

    double metretul = 25.0;
    String netMetrajString = '0';

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'metre_kare' && element['cevap'] != null) {
          netMetrajString = element['cevap'].toString();
          break;
        } else if (element.containsKey('metre_kare') && element['metre_kare'] != null) {
          netMetrajString = element['metre_kare'].toString();
          break;
        }
      }
    }

    double? parsedMetretul = double.tryParse(netMetrajString);
    if (parsedMetretul != null && parsedMetretul > 0) {
      metretul = parsedMetretul;
    } else {
      bool hasCitalama = false;
      bool hasTavanGrup = false;

      for (var alan in uygulamaAlanlari) {
        final String a = alan.toString();
        if (a.contains('Çıtalama')) hasCitalama = true;
        if (a.contains('Tavan') || a.contains('Perdelik') || a.contains('Göbek')) {
          hasTavanGrup = true;
        }
      }

      if (hasCitalama && !hasTavanGrup) {
        if (metrajM2.contains('1-10')) metretul = 25.0;
        else if (metrajM2.contains('10-25')) metretul = 60.0;
        else if (metrajM2.contains('25-50')) metretul = 120.0;
        else if (metrajM2.contains('50+')) metretul = 220.0;
      } else if (hasTavanGrup && !hasCitalama) {
        if (metrajMetre.contains('1-15')) metretul = 10.0;
        else if (metrajMetre.contains('15-30')) metretul = 22.0;
        else if (metrajMetre.contains('30-60')) metretul = 45.0;
        else if (metrajMetre.contains('60+')) metretul = 85.0;
      } else {
        if (metrajSegmenti.contains('0-10')) metretul = 7.0;
        else if (metrajSegmenti.contains('10-30')) metretul = 20.0;
        else if (metrajSegmenti.contains('30-70')) metretul = 50.0;
        else if (metrajSegmenti.contains('70+')) metretul = 100.0;
      }
    }

    double birimMetretulFiyati = 95.0;

    if (malzemeTipi.contains('Alçı') || malzemeTipi.contains('Klasik') || malzemeTipi.contains('Döküm')) {
      birimMetretulFiyati = 220.0;
    } else if (malzemeTipi.contains('Polimer') || malzemeTipi.contains('Poliüretan') || malzemeTipi.contains('Lüks')) {
      birimMetretulFiyati = 340.0;
    }

    if (tasarimKarmasikligi.contains('Kareli') || tasarimKarmasikligi.contains('Baklava') || tasarimKarmasikligi.contains('Klasik')) {
      birimMetretulFiyati *= 1.35;
    }

    double ekMaliyet = 0.0;

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Kestirme') || o.contains('Boya') || o.contains('Boyama')) {
        ekMaliyet += (metretul * 140.0);
      }
      if (o.contains('Motif') || o.contains('Göbek') || o.contains('Montaj')) {
        ekMaliyet += 6000.0;
      }
      if (o.contains('Led') || o.contains('Kanallı') || o.contains('Işık')) {
        birimMetretulFiyati += 130.0;
      }
      if (o.contains('Yüksek') || o.contains('3 Metretül') || o.contains('Tavan')) {
        ekMaliyet += 4500.0;
      }
    }

    double toplamFiyat = (metretul * birimMetretulFiyati) + ekMaliyet;

    double asgariBaraj = 8500.0;
    if (metretul <= 12) {
      asgariBaraj = 5500.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananMetretul": metretul,
      "birimMetretulFiyati": birimMetretulFiyati,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}