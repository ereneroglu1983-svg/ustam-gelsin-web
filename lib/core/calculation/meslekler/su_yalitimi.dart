// lib/core/calculation/meslekler/su_yalitimi_hesaplayici.dart

class SuYalitimiHesaplayici {

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

    final String yapiDurumu = findValue('yapi_durumu', 'Yeni İnşaat (Temel Aşamasında Komple Bohçalama Sistemi)');
    final String yalitimiTipi = findValue('yalitimi_tipi', 'Bitümlü Membran (Bohçalama - Çift Kat Şaloma Alevli Standart Eritme Sistem)');

    final String alanM2Secim = findValue('alan_m2', '101 - 250 m² Arası Standart Müstakil Yapı / Bina Temeli');
    final String perdeUzunlukSecim = findValue('perde_uzunluk_m', '26 - 60 Metre Arası Standart Çevre Uzunluğu');
    final String bodrumYukseklikSecim = findValue('bodrum_yukseklik_m', '2.6 - 3.5 Metre Arası Standart Kat Yüksekliği');
    final String yapiDerinlikSecim = findValue('yapi_derinlik_m', '1.6 - 3.5 Metre Tek Kat Bodrum Derinliği');

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

    double temelM2 = 0.0;
    if (alanM2Secim.contains('0-100') || alanM2Secim.contains('Küçük Ölçekli')) {
      temelM2 = 60.0;
    } else if (alanM2Secim.contains('101-250') || alanM2Secim.contains('Standart Müstakil')) {
      temelM2 = 175.0;
    } else if (alanM2Secim.contains('251-500') || alanM2Secim.contains('Geniş Apartman')) {
      temelM2 = 380.0;
    } else if (alanM2Secim.contains('501+') || alanM2Secim.contains('Büyük Endüstriyel')) {
      temelM2 = 750.0;
    }

    double perdeUzunluk = 0.0;
    if (perdeUzunlukSecim.contains('1-25') || perdeUzunlukSecim.contains('Kısa Hat')) {
      perdeUzunluk = 15.0;
    } else if (perdeUzunlukSecim.contains('26-60') || perdeUzunlukSecim.contains('Standart Çevre')) {
      perdeUzunluk = 45.0;
    } else if (perdeUzunlukSecim.contains('61-120') || perdeUzunlukSecim.contains('Geniş Bina')) {
      perdeUzunluk = 90.0;
    } else if (perdeUzunlukSecim.contains('121+') || perdeUzunlukSecim.contains('Uzun Ticari')) {
      perdeUzunluk = 180.0;
    }

    double bodrumYukseklik = 0.0;
    if (bodrumYukseklikSecim.contains('0.0-2.5') || bodrumYukseklikSecim.contains('Alçak Bodrum')) {
      bodrumYukseklik = 2.2;
    } else if (bodrumYukseklikSecim.contains('2.6-3.5') || bodrumYukseklikSecim.contains('Standart Kat')) {
      bodrumYukseklik = 3.0;
    } else if (bodrumYukseklikSecim.contains('3.6-5.0') || bodrumYukseklikSecim.contains('Yüksek Perde')) {
      bodrumYukseklik = 4.2;
    } else if (bodrumYukseklikSecim.contains('5.0+') || bodrumYukseklikSecim.contains('Çift Katlı')) {
      bodrumYukseklik = 6.5;
    }

    double yapiDerinligi = 0.0;
    if (yapiDerinlikSecim.contains('0.0-1.5') || yapiDerinlikSecim.contains('Yüzeysel')) {
      yapiDerinligi = 1.0;
    } else if (yapiDerinlikSecim.contains('1.6-3.5') || yapiDerinlikSecim.contains('Tek Kat Bodrum')) {
      yapiDerinligi = 2.8;
    } else if (yapiDerinlikSecim.contains('3.6-6.0') || yapiDerinlikSecim.contains('Çift Kat Bodrum')) {
      yapiDerinligi = 4.8;
    } else if (yapiDerinlikSecim.contains('6.0+') || yapiDerinlikSecim.contains('Çok Katlı Derin')) {
      yapiDerinligi = 8.0;
    }

    double tabanMaliyeti = 0.0;
    double perdeMaliyeti = 0.0;
    double perdeAlan = 0.0;
    double derinlikEkstrasi = 0.0;
    double birimFiyat = 0.0;

    if (yalitimiTipi.contains('Poliüretan') || yalitimiTipi.contains('Sürme')) {
      birimFiyat = 1250.0;
    } else if (yalitimiTipi.contains('Polyurea') || yalitimiTipi.contains('Püskürtme') || yalitimiTipi.contains('Poliüre')) {
      birimFiyat = 2100.0;
    } else {
      birimFiyat = 900.0;
    }

    if (yapiDurumu.contains('Yeni İnşaat') || yapiDurumu.contains('Bohçalama')) {
      if (temelM2 <= 0) {
        return {"tahminiButce": 0.0, "hesaplananTemelM2": 0.0, "durum": "HATA", "mesaj": "Geçersiz temel metrekare verisi"};
      }
      tabanMaliyeti = temelM2 * birimFiyat;
    } else {
      if (perdeUzunluk <= 0 || bodrumYukseklik <= 0) {
        return {"tahminiButce": 0.0, "hesaplananTemelM2": 0.0, "durum": "HATA", "mesaj": "Geçersiz perde uzunluğu veya yükseklik verisi"};
      }

      perdeAlan = perdeUzunluk * bodrumYukseklik;
      perdeMaliyeti = perdeAlan * (birimFiyat * 1.20);

      if (yapiDerinligi > 3.0) {
        derinlikEkstrasi = perdeAlan * ((yapiDerinligi - 3.0) * 180.0);
      }
    }

    double ekMaliyet = 0.0;
    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();

      if (o.contains('Drenaj') || o.contains('Mıcır') || o.contains('Tahliye')) {
        if (perdeUzunluk > 0) {
          ekMaliyet += (perdeUzunluk * 650.0);
        } else if (temelM2 > 0) {
          ekMaliyet += (temelM2 * 250.0);
        }
      }
      if (o.contains('Pah Bandı') || o.contains('Köşe Güçlendirmesi') || o.contains('Pah')) {
        ekMaliyet += 9500.0;
      }
      if (o.contains('XPS') || o.contains('Isı Yalıtım') || o.contains('Koruma')) {
        if (perdeAlan > 0) {
          ekMaliyet += (perdeAlan * 380.0);
        }
      }
      if (o.contains('Su Tutucu') || o.contains('Şerit') || o.contains('Şişen Bant')) {
        ekMaliyet += 7500.0;
      }
    }

    double toplamFiyat = tabanMaliyeti + perdeMaliyeti + derinlikEkstrasi + ekMaliyet;

    double asgariBaraj = 50000.0;
    if (yapiDurumu.contains('Mevcut Bina') || yapiDurumu.contains('İstinat')) {
      asgariBaraj = 25000.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananTemelM2": temelM2,
      "hesaplananPerdeAlan": perdeAlan,
      "tabanMaliyeti": tabanMaliyeti,
      "perdeMaliyeti": perdeMaliyeti,
      "derinlikEkstrasi": derinlikEkstrasi,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}