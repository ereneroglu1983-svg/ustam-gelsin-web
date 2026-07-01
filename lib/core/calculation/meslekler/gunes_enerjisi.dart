class GunesEnerjisiHesaplayici {
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

    final String hizmetTuru = findValue('hizmet_turu', 'Güneş Enerjisi Sistemi Sıfırdan Kurulum');
    final String sistemTipi = findValue('sistem_tipi', 'Vakum Tüplü (Açık Devre) Standart Sistem');
    final String depoMalzemesi = findValue('depo_malzemesi', '304 Kalite Krom Paslanmaz Depo Malzemesi (Uzun Ömürlü High-End)');
    final String montajZemini = findValue('montaj_zemini', 'Düz Beton Teras Zemini');
    final String tamirBakimDetayi = findValue('tamir_bakim_detayi', 'Şamandıra, Vana veya Tesisat Borusu Kaçak Onarımı');
    final String termosifonDetayi = findValue('termosifon_detayi', 'Sadece Montaj İşçiliği (Cihaz Müşteriye Ait)');
    final String kapasiteSegmenti = findValue('kapasite_segmenti', '1-2 Dairelik / Küçük Aile Tipi (Standart Tank)');

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

    double sistemKatsayisi = 1.0;
    if (kapasiteSegmenti.contains('3-5 Dairelik') || kapasiteSegmenti.contains('Orta Ölçek')) {
      sistemKatsayisi = 2.2;
    } else if (kapasiteSegmenti.contains('Merkezi') || kapasiteSegmenti.contains('Apartman') || kapasiteSegmenti.contains('Otel')) {
      sistemKatsayisi = 4.8;
    }

    double tabanMaliyet = 0.0;
    double montajFarki = 0.0;
    double ekMaliyet = 0.0;

    if (hizmetTuru.contains('Tamir') || hizmetTuru.contains('Bakım') || hizmetTuru.contains('Arıza')) {
      if (tamirBakimDetayi.contains('Vakum Tüp') || tamirBakimDetayi.contains('Cam Kırılması')) {
        tabanMaliyet = 3500.0;
      } else if (tamirBakimDetayi.contains('Sızıntı') || tamirBakimDetayi.contains('Kazan') || tamirBakimDetayi.contains('Kaynak')) {
        tabanMaliyet = 7500.0;
      } else if (tamirBakimDetayi.contains('Şamandıra') || tamirBakimDetayi.contains('Vana') || tamirBakimDetayi.contains('Kaçak')) {
        tabanMaliyet = 2800.0;
      } else if (tamirBakimDetayi.contains('Kışlık Bakım') || tamirBakimDetayi.contains('Antifriz')) {
        tabanMaliyet = 3200.0;
      }
    } else if (hizmetTuru.contains('Termosifon')) {
      if (termosifonDetayi.contains('Sadece Montaj')) {
        tabanMaliyet = 2200.0;
      } else if (termosifonDetayi.contains('Cihaz Dahil') || termosifonDetayi.contains('Satış')) {
        tabanMaliyet = 14500.0;
      } else if (termosifonDetayi.contains('Eski Sökümü') || termosifonDetayi.contains('Değişim')) {
        tabanMaliyet = 2900.0;
      }
    } else {
      tabanMaliyet = 18500.0;

      if (sistemTipi.contains('Basınçlı') || sistemTipi.contains('Kapalı Devre')) {
        tabanMaliyet = 34000.0;
      }

      if (depoMalzemesi.contains('304 Kalite') || depoMalzemesi.contains('Krom') || depoMalzemesi.contains('Paslanmaz')) {
        tabanMaliyet += 4500.0;
      } else if (depoMalzemesi.contains('Galvaniz')) {
        tabanMaliyet -= 1500.0;
      }

      if (montajZemini.contains('Eğimli') || montajZemini.contains('Kiremit')) {
        montajFarki = 5000.0;
      } else if (montajZemini.contains('Sandviç') || montajZemini.contains('Sac')) {
        montajFarki = 3000.0;
      }

      for (var ozellik in ekstralar) {
        final String o = ozellik.toString();
        if (o.contains('Rezistans') || o.contains('Isıtıcı')) {
          ekMaliyet += 2800.0;
        }
        if (o.contains('Pompa') || o.contains('Hidrofor')) {
          ekMaliyet += 6500.0;
        }
        if (o.contains('Yalıtım') || o.contains('İzolasyon')) {
          ekMaliyet += 3500.0;
        }
      }
    }

    double toplamFiyat = 0.0;
    if (hizmetTuru.contains('Kurulum')) {
      toplamFiyat = (tabanMaliyet * sistemKatsayisi) + montajFarki + ekMaliyet;
    } else {
      toplamFiyat = tabanMaliyet + (ekMaliyet * (sistemKatsayisi > 1.0 ? 1.3 : 1.0));
    }

    double asgariBaraj = 12000.0;
    if (hizmetTuru.contains('Kurulum') && (sistemTipi.contains('Basınçlı') || sistemTipi.contains('Kapalı'))) {
      asgariBaraj = 28000.0;
    } else if (hizmetTuru.contains('Tamir')) {
      asgariBaraj = 2800.0;
    } else if (hizmetTuru.contains('Termosifon')) {
      asgariBaraj = 2200.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "sistemKatsayisi": sistemKatsayisi,
      "tabanMaliyet": tabanMaliyet,
      "montajFarki": montajFarki,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}