class DogalgazKombiHesaplayici {
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

    final String uygulamaTipi = findValue('uygulama_tipi', 'Sıfırdan Komple Daire İçi Tesisat ve Hat Kurulumu');
    final String daireTipi = findValue('daire_tipi', '2+1 Konut Düzeni');
    final String tesisatMalzemesi = findValue('tesisat_malzemesi', 'PPRC Plastik Boru Tesisatı (Standart Sıva Altı/Üstü Hat)');
    final String kombiTeknolojisi = findValue('kombi_teknolojisi', 'Tam Yoğuşmalı Kombi (Yüksek Tasarruflu Yeni Nesil)');
    final String projeDurumu = findValue('proje_durumu', 'Mühendislik Proje Çizimi ve Dijital Gaz Açma Onayı Dahil Olsun');
    final String montajYeri = findValue('montaj_yeri', 'Mutfak İçi Montaj');
    final String bakimArizaDetayi = findValue('bakim_ariza_detayi', 'Yıllık Periyodik Kombi Bakımı ve Filtre Temizliği');
    final String izolasyonTipi = findValue('izolasyon_tipi', 'Mantarlı Strafor');
    final String sapDurumu = findValue('sap_durumu', 'Şap Atılmamış Ham Beton');
    final String alanM2 = findValue('alan_m2', '71 - 110 m² Arası Standart Daire');
    final String petekAdedi = findValue('petek_adedi', '5 - 7 Adet Arası Standart Petek');

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

    double petekSayisi = 6.0;
    if (petekAdedi.contains('1-4 Adet')) petekSayisi = 3.0;
    else if (petekAdedi.contains('5-7 Adet')) petekSayisi = 6.0;
    else if (petekAdedi.contains('8-10 Adet')) petekSayisi = 9.0;
    else if (petekAdedi.contains('11 Adet')) petekSayisi = 13.0;

    double toplamM2 = 0.0;
    if (alanM2.contains('0-70 m²')) toplamM2 = 60.0;
    else if (alanM2.contains('71-110 m²')) toplamM2 = 90.0;
    else if (alanM2.contains('111-150 m²')) toplamM2 = 130.0;
    else if (alanM2.contains('151-250 m²')) toplamM2 = 200.0;
    else if (alanM2.contains('250 m²')) toplamM2 = 320.0;

    double tabanMaliyet = 8500.0;

    bool isKompleTesisat = uygulamaTipi.contains('Komple') || uygulamaTipi.contains('Sıfırdan') || uygulamaTipi.contains('Daire İçi');
    bool isKombiMontaj = uygulamaTipi.contains('Kombi Montaj');
    bool isYerdenIsitma = uygulamaTipi.contains('Yerden Isıtma');
    bool isBakimAriza = uygulamaTipi.contains('Bakım') || uygulamaTipi.contains('Onarım') || uygulamaTipi.contains('Arıza');

    if (isKompleTesisat) {
      tabanMaliyet = 28000.0;
    } else if (isYerdenIsitma) {
      double birimM2Fiyati = 720.0;
      tabanMaliyet = toplamM2 * birimM2Fiyati;

      if (izolasyonTipi.contains('Düz Folyo')) {
        tabanMaliyet -= (toplamM2 * 80.0);
      } else if (izolasyonTipi.contains('Hariç')) {
        tabanMaliyet -= (toplamM2 * 250.0);
      }

      if (sapDurumu.contains('Mevcut Şap') || sapDurumu.contains('Kırım')) {
        tabanMaliyet += (toplamM2 * 150.0);
      }
    } else if (isBakimAriza) {
      tabanMaliyet = 1200.0;
      if (bakimArizaDetayi.contains('Sıcak Su') || bakimArizaDetayi.contains('Devreye Girmiyor')) {
        tabanMaliyet += 1800.0;
      } else if (bakimArizaDetayi.contains('Hiç Çalışmıyor') || bakimArizaDetayi.contains('Ateşleme')) {
        tabanMaliyet += 3200.0;
      } else if (bakimArizaDetayi.contains('Hata Kodu') || bakimArizaDetayi.contains('Su Eksiltiyor')) {
        tabanMaliyet += 2200.0;
      }
    }

    if (isKompleTesisat || isKombiMontaj || isYerdenIsitma) {
      if (kombiTeknolojisi.contains('Tam Yoğuşmalı')) {
        tabanMaliyet += 26000.0;
      } else if (kombiTeknolojisi.contains('Yarı Yoğuşmalı')) {
        tabanMaliyet += 21000.0;
      } else if (kombiTeknolojisi.contains('Hermetik')) {
        tabanMaliyet += 17000.0;
      }
    }

    if (isKompleTesisat) {
      if (tesisatMalzemesi.contains('Bakır')) {
        tabanMaliyet *= 1.75;
      } else if (tesisatMalzemesi.contains('Mobil') || tesisatMalzemesi.contains('Kollektör')) {
        tabanMaliyet *= 1.25;
      } else if (tesisatMalzemesi.contains('Çelik') || tesisatMalzemesi.contains('Kaynaklı')) {
        tabanMaliyet *= 1.40;
      }
    }

    if (!isBakimAriza) {
      if (projeDurumu.contains('Proje Çizimi') || projeDurumu.contains('Dijital Gaz') || projeDurumu.contains('Dahil')) {
        tabanMaliyet += 9500.0;
      }
    }

    if (!isBakimAriza) {
      if (montajYeri.contains('Balkon')) {
        tabanMaliyet += 3500.0;
      } else if (montajYeri.contains('Kiler') || montajYeri.contains('Hol') || montajYeri.contains('Koridor')) {
        tabanMaliyet += 4000.0;
      } else if (montajYeri.contains('Mevcut Eski Kombi') || montajYeri.contains('Değişim')) {
        tabanMaliyet += 1500.0;
      }
    }

    double ekMaliyet = 0.0;

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();

      if (o.contains('Radyatör Montaj') || o.contains('Petek Askılama')) {
        if (!isYerdenIsitma) ekMaliyet += (petekSayisi * 950.0);
      }
      if (o.contains('Yoğuşma Gideri') || o.contains('Pimaş')) {
        ekMaliyet += 2000.0;
      }
      if (o.contains('Termostat') || o.contains('Senkronizasyon')) {
        if (!o.contains('Oda Bazlı') && !o.contains('Aktüatör')) {
          ekMaliyet += 3500.0;
        }
      }
      if (o.contains('Gaz Alarm') || o.contains('Selenoid')) {
        ekMaliyet += 2500.0;
      }
      if (o.contains('Kollektör') || o.contains('Vana') || o.contains('Dolap')) {
        ekMaliyet += 8500.0;
      }
      if (o.contains('Oda Bazlı') || o.contains('Aktüatör') || o.contains('Akıllı')) {
        ekMaliyet += 6800.0;
      }
      if (o.contains('Yalıtım Bandı') || o.contains('Kenar') || o.contains('Koruma Sütü')) {
        ekMaliyet += (toplamM2 * 65.0);
      }
      if (o.contains('Test') || o.contains('Basınç') || o.contains('Manometre')) {
        ekMaliyet += 2500.0;
      }
    }

    double toplamFiyat = tabanMaliyet + ekMaliyet;

    double asgariBaraj = 10000.0;
    if (isKompleTesisat || isYerdenIsitma) {
      asgariBaraj = isYerdenIsitma ? 16000.0 : 48000.0;
    } else if (isBakimAriza) {
      asgariBaraj = 1500.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananPetekSayisi": isYerdenIsitma ? 0.0 : petekSayisi,
      "hesaplananM2": isYerdenIsitma ? toplamM2 : 0.0,
      "tabanMaliyet": tabanMaliyet,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}