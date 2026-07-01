// lib/core/calculation/meslekler/mutfak_dolabi_hesaplayici.dart

class MutfakDolabiHesaplayici {

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

    final String isKapsami = findValue('is_kapsami', 'Komple Mutfak Yenileme (Hem Dolap Hem Tezgah İmalat ve Montajı)');
    final String kapakTipi = findValue('kapak_tipi', 'Akrilik Kapak (Parlak / Mat Çizilmeye Dayanıklı Pürüzsüz Yüzey)');
    final String tezgahTipi = findValue('tezgah_tipi', 'Kuvars Tezgah (Çimstone / Belenco Yüksek Mukavemetli Kompoze Taş)');
    final String mutfakFormu = findValue('mutfak_formu', 'Düz Mutfak (Tek Hat Duvar Boyu Yerleşim)');
    final String metrajSegmenti = findValue('metraj_segmenti', '3 - 5 Metretül Arası Orta Ölçek Daire Mutfağı');

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

    double metretul = 4.0;

    if (metrajSegmenti.contains('0-3') || metrajSegmenti.contains('Standart Küçük')) {
      metretul = 2.0;
    } else if (metrajSegmenti.contains('3-5') || metrajSegmenti.contains('Orta Ölçek')) {
      metretul = 4.0;
    } else if (metrajSegmenti.contains('5-8') || metrajSegmenti.contains('Geniş Mutfak')) {
      metretul = 6.5;
    } else if (metrajSegmenti.contains('8+') || metrajSegmenti.contains('Büyük Villa') || metrajSegmenti.contains('Ticari')) {
      metretul = 10.0;
    }

    bool dolapDahil = isKapsami.contains('Komple') || isKapsami.contains('Sadece Mutfak Dolabı');
    bool tezgahDahil = isKapsami.contains('Komple') || isKapsami.contains('Sadece Mutfak Tezgahı');
    bool sadeceKapak = isKapsami.contains('Kapak Yenileme') || isKapsami.contains('Boyama');

    double dolapBirimFiyati = 0.0;

    if (dolapDahil) {
      dolapBirimFiyati = 13500.0;
      if (kapakTipi.contains('Lake')) {
        dolapBirimFiyati = 22500.0;
      } else if (kapakTipi.contains('Membran') || kapakTipi.contains('Mdflam')) {
        dolapBirimFiyati = 10500.0;
      } else if (kapakTipi.contains('Masif') || kapakTipi.contains('Ahşap')) {
        dolapBirimFiyati = 32000.0;
      }
    } else if (sadeceKapak) {
      dolapBirimFiyati = 5500.0;
      if (kapakTipi.contains('Lake')) {
        dolapBirimFiyati = 9500.0;
      } else if (kapakTipi.contains('Membran') || kapakTipi.contains('Mdflam')) {
        dolapBirimFiyati = 4200.0;
      } else if (kapakTipi.contains('Masif') || kapakTipi.contains('Ahşap')) {
        dolapBirimFiyati = 14500.0;
      }
    }

    double tezgahBirimFiyati = 0.0;

    if (tezgahDahil) {
      tezgahBirimFiyati = 11500.0;
      if (tezgahTipi.contains('Porselen')) {
        tezgahBirimFiyati = 24500.0;
      } else if (tezgahTipi.contains('Granit')) {
        tezgahBirimFiyati = 9500.0;
      } else if (tezgahTipi.contains('Ahşap') || tezgahTipi.contains('Masif')) {
        tezgahBirimFiyati = 13000.0;
      }
    }

    double formCarpani = 1.0;
    if (mutfakFormu.contains('L Mutfak')) {
      formCarpani = 1.15;
    } else if (mutfakFormu.contains('U Mutfak') || mutfakFormu.contains('Ada')) {
      formCarpani = 1.25;
    }

    double ekMaliyet = 0.0;

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Frenli Ray') || o.contains('Blum') || o.contains('Hettich')) {
        ekMaliyet += (metretul * 2800.0);
      }
      if (o.contains('Kör Köşe') || o.contains('Kiler')) {
        ekMaliyet += 13500.0;
      }
      if (o.contains('Kulpsuz') || o.contains('Gola')) {
        ekMaliyet += (metretul * 1600.0);
      }
      if (o.contains('Tezgah Arası') || o.contains('Cam') || o.contains('Seramik')) {
        ekMaliyet += (metretul * 3800.0);
      }
      if (o.contains('Led') || o.contains('Aydınlatma')) {
        ekMaliyet += 5500.0;
      }
    }

    double toplamFiyat = ((metretul * dolapBirimFiyati) + (metretul * tezgahBirimFiyati)) * formCarpani + ekMaliyet;

    double asgariBaraj = 85000.0;
    if (sadeceKapak) {
      asgariBaraj = 25000.0;
    } else if (tezgahDahil && !dolapDahil) {
      asgariBaraj = 35000.0;
    } else if (dolapDahil && !tezgahDahil) {
      asgariBaraj = 55000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananMetretul": metretul,
      "dolapBirimFiyati": dolapBirimFiyati,
      "tezgahBirimFiyati": tezgahBirimFiyati,
      "formCarpani": formCarpani,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}