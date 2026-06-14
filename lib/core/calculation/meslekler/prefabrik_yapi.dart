// lib/core/calculation/meslekler/prefabrik_yapi_hesaplayici.dart

class PrefabrikYapiHesaplayici {

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

    final String isKapsami = findValue('is_kapsami', 'Sıfırdan İmalat / Anahtar Teslim Kurulum Hizmeti');
    final String yapiTipi = findValue('yapi_tipi', 'Prefabrik Konut (Galvaniz Hafif Çelik Profil ve Standart Panel Yapı Tabanlı)');
    final String katSayisi = findValue('kat_sayisi', 'Tek Katlı Mimari Yapı Planyası');
    final String alanM2Secim = findValue('alan_m2', 'Standart Konut Alanı (45 - 85 m² Arası)');
    final String nakliyeKmSecim = findValue('nakliye_mesafesi_km', 'Orta Mesafe Sevk (50 - 150 KM Arası)');

    List<dynamic> ekstralar = [];
    List<dynamic> tamirDetaylari = [];

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_ozellikler' && element['cevap'] is List) {
          ekstralar = element['cevap'];
        } else if (element.containsKey('ekstra_ozellikler') && element['ekstra_ozellikler'] is List) {
          ekstralar = element['ekstra_ozellikler'];
        }

        if (element['id'] == 'tamir_detay' && element['cevap'] is List) {
          tamirDetaylari = element['cevap'];
        } else if (element.containsKey('tamir_detay') && element['tamir_detay'] is List) {
          tamirDetaylari = element['tamir_detay'];
        }
      }
    }

    double m2 = 65.0;

    if (alanM2Secim.contains('0-45') || alanM2Secim.contains('Küçük Ölçekli')) {
      m2 = 30.0;
    } else if (alanM2Secim.contains('45-85') || alanM2Secim.contains('Standart Konut')) {
      m2 = 65.0;
    } else if (alanM2Secim.contains('85-130') || alanM2Secim.contains('Geniş Aile')) {
      m2 = 100.0;
    } else if (alanM2Secim.contains('130+') || alanM2Secim.contains('Endüstriyel')) {
      m2 = 160.0;
    }

    double nakliyeKm = 0.0;

    if (nakliyeKmSecim.contains('0-50') || nakliyeKmSecim.contains('Yakın Mesafe')) {
      nakliyeKm = 35.0;
    } else if (nakliyeKmSecim.contains('50-150') || nakliyeKmSecim.contains('Orta Mesafe')) {
      nakliyeKm = 100.0;
    } else if (nakliyeKmSecim.contains('150-350') || nakliyeKmSecim.contains('Uzak Mesafe')) {
      nakliyeKm = 250.0;
    } else if (nakliyeKmSecim.contains('350+') || nakliyeKmSecim.contains('Şehirler Arası')) {
      nakliyeKm = 500.0;
    }

    double birimM2Fiyati = 0.0;
    double ekMaliyet = 0.0;
    double lojistikMaliyeti = 0.0;
    double sabitIs_KapsamiMaliyeti = 0.0;

    if (isKapsami.contains('Sıfırdan') || isKapsami.contains('Anahtar Teslim')) {
      birimM2Fiyati = 18500.0;

      if (yapiTipi.contains('Bungalov') || yapiTipi.contains('Ahşap') || yapiTipi.contains('Lambri')) {
        birimM2Fiyati = 28000.0;
      } else if (yapiTipi.contains('Çelik Konstrüksiyon') || yapiTipi.contains('Ağır Çelik')) {
        birimM2Fiyati = 34000.0;
      }

      if (katSayisi.contains('Dubleks') || katSayisi.contains('İki Katlı') || katSayisi.contains('Şase')) {
        birimM2Fiyati *= 1.45;
      }

    } else if (isKapsami.contains('Onarım') || isKapsami.contains('Tamir') || isKapsami.contains('Tadilat')) {
      birimM2Fiyati = 0.0;

      for (var tamir in tamirDetaylari) {
        final String t = tamir.toString();
        if (t.contains('Çatı Akması') || t.contains('İzolasyon') || t.contains('Membran')) {
          ekMaliyet += (m2 * 450.0) + 12000.0;
        }
        if (t.contains('Taban Çürümesi') || t.contains('Şase') || t.contains('Alt Seç')) {
          ekMaliyet += 28000.0;
        }
        if (t.contains('Dış Cephe') || t.contains('Boya') || t.contains('Betopan')) {
          ekMaliyet += (m2 * 380.0) + 15000.0;
        }
        if (t.contains('Sıhhi Tesisat') || t.contains('Elektrik') || t.contains('Arıza')) {
          ekMaliyet += 18000.0;
        }
        if (t.contains('Sandviç Panel') || t.contains('Duvar İçi') || t.contains('Deforme')) {
          ekMaliyet += (m2 * 650.0);
        }
      }

    } else if (isKapsami.contains('Lojistik') || isKapsami.contains('Nakliye') || isKapsami.contains('Yer Değiştirme')) {
      birimM2Fiyati = 0.0;
      sabitIs_KapsamiMaliyeti = 45000.0;
      ekMaliyet += (m2 * 400.0);
    }

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Taş Yünü') || o.contains('Ekstra Yalıtım') || o.contains('Duvar İçi')) {
        if (birimM2Fiyati > 0) {
          birimM2Fiyati += 2200.0;
        } else {
          ekMaliyet += (m2 * 2200.0);
        }
      }
      if (o.contains('Yerden Isıtma') || o.contains('Strafor') || o.contains('Borulama')) {
        ekMaliyet += (m2 * 1850.0);
      }
      if (o.contains('Alüminyum') || o.contains('Konfor Cam') || o.contains('Sinerji')) {
        ekMaliyet += 32000.0;
      }
      if (o.contains('Subasman') || o.contains('Beton Zemin') || o.contains('Hasırlı Zemin')) {
        ekMaliyet += (m2 * 3500.0);
      }
      if (o.contains('Veranda') || o.contains('Sundurma')) {
        ekMaliyet += 55000.0;
      }
      if (o.contains('Zor Arazi') || o.contains('Dik Eğim') || o.contains('Vinç') || o.contains('Çift Bom')) {
        ekMaliyet += 35000.0;
      }
    }

    if (nakliyeKm > 0) {
      lojistikMaliyeti = nakliyeKm * 240.0;
      if (lojistikMaliyeti < 18000.0) lojistikMaliyeti = 18000.0;
    }

    double toplamFiyat = (m2 * birimM2Fiyati) + sabitIs_KapsamiMaliyeti + ekMaliyet + lojistikMaliyeti;

    double asgariBaraj = 180000.0;
    if (isKapsami.contains('Onarım') || isKapsami.contains('Tamir')) {
      asgariBaraj = 20000.0;
    } else if (isKapsami.contains('Lojistik') || isKapsami.contains('Nakliye')) {
      asgariBaraj = 65000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "sabitIs_KapsamiMaliyeti": sabitIs_KapsamiMaliyeti,
      "ekMaliyet": ekMaliyet,
      "lojistikMaliyeti": lojistikMaliyeti,
      "durum": "BAŞARILI"
    };
  }
}