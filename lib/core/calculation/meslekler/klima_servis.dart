class KlimaServisHesaplayici {
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

    final String isKapsami = findValue('is_kapsami', 'Periyodik Bakım (İlaçlı İç / Dış Ünite Temizliği ve Filtre Dezenfeksiyonu)');
    final String montajYuzeyi = findValue('montaj_yuzeyi', 'Dış Cephe Duvarı (Konsol Bağlantılı)');
    final String katDurumu = findValue('kat_durumu', 'Zemin Kat / Kolay Erişilebilir Bahçe-Balkon');
    final String cihazKapasitesi = findValue('cihaz_kapasitesi', '9.000 - 12.000 BTU (Standart Duvar Tipi Split)');
    final String cihazSayisiSegmenti = findValue('cihaz_sayisi', '1 Cihaz');
    final String elektrikHat = findValue('elektrik_hat', 'Hat Hazır (Klima Yanında Priz veya Şalter Sigortası Mevcut)');

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

    double adet = 1.0;
    String adetString = '1';

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'adet' && element['cevap'] != null) {
          adetString = element['cevap'].toString();
          break;
        } else if (element.containsKey('adet') && element['adet'] != null) {
          adetString = element['adet'].toString();
          break;
        }
      }
    }

    double? parsedAdet = double.tryParse(adetString);
    if (parsedAdet != null && parsedAdet > 0) {
      adet = parsedAdet;
    } else {
      if (cihazSayisiSegmenti.contains('2-3')) adet = 2.5;
      else if (cihazSayisiSegmenti.contains('4-10')) adet = 6.0;
      else if (cihazSayisiSegmenti.contains('10+')) adet = 12.0;
    }

    double birimIslemFiyati = 1400.0;
    bool isMontajGrubu = false;

    if (isKapsami.contains('Montaj') && !isKapsami.contains('Sökme')) {
      birimIslemFiyati = 3600.0;
      isMontajGrubu = true;
    } else if (isKapsami.contains('Sökme') && isKapsami.contains('Montaj')) {
      birimIslemFiyati = 5800.0;
      isMontajGrubu = true;
    } else if (isKapsami.contains('Gaz') || isKapsami.contains('Şarj') || isKapsami.contains('Basımı')) {
      birimIslemFiyati = 3200.0;
    }

    if (cihazKapasitesi.contains('18.000') || cihazKapasitesi.contains('24.000')) {
      birimIslemFiyati *= 1.35;
    } else if (cihazKapasitesi.contains('Salon') || cihazKapasitesi.contains('Kaset') || cihazKapasitesi.contains('Tavan')) {
      birimIslemFiyati *= 1.70;
    }

    if (isMontajGrubu) {
      if (montajYuzeyi.contains('Dış Cephe') || montajYuzeyi.contains('Konsol')) {
        birimIslemFiyati += 850.0;
      } else if (montajYuzeyi.contains('Çatı') || montajYuzeyi.contains('Teras')) {
        birimIslemFiyati += 300.0;
      }

      if (katDurumu.contains('1-3. Kat')) {
        birimIslemFiyati += 500.0;
      } else if (katDurumu.contains('4. Kat') || katDurumu.contains('Vinç') || katDurumu.contains('Sepetli')) {
        birimIslemFiyati += 4500.0;
      }
    }

    if (elektrikHat.contains('Çekilmesi') || elektrikHat.contains('Panodan')) {
      birimIslemFiyati += 1400.0;
    }

    double toplamKapiBasiEkMaliyet = 0.0;

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Bakır Boru') || o.contains('Ekstra Bakır')) {
        toplamKapiBasiEkMaliyet += 3800.0;
      }
      if (o.contains('Konsol Seti') || o.contains('Paslanmaz')) {
        toplamKapiBasiEkMaliyet += 950.0;
      }
      if (o.contains('Kaçak Tespiti') || o.contains('Azot Test')) {
        toplamKapiBasiEkMaliyet += 1600.0;
      }
      if (o.contains('Drenaj') || o.contains('Pompa')) {
        toplamKapiBasiEkMaliyet += 4800.0;
      }
    }

    double toplamFiyat = (birimIslemFiyati + toplamKapiBasiEkMaliyet) * adet;

    double asgariBaraj = 2200.0;
    if (isMontajGrubu) {
      asgariBaraj = 4800.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananAdet": adet,
      "birimIslemFiyati": birimIslemFiyati,
      "ekMaliyet": toplamKapiBasiEkMaliyet * adet,
      "durum": "BAŞARILI"
    };
  }
}