// lib/core/services/fiyat_hesaplama_robotu.dart

import 'package:flutter/foundation.dart';

class FiyatHesaplamaRobotu {

  static double hesapla({
    required Map<String, dynamic> kategoriVerisi,
    required Map<String, dynamic> secilenler,
    required String sehir,
  }) {
    try {
      // 1. BAZ FİYAT
      double malzemeM2 = (kategoriVerisi['malzeme']?['m2'] as num?? 0).toDouble();
      double malzemeMt = (kategoriVerisi['malzeme']?['mt'] as num?? 0).toDouble();
      double iscilikM2 = (kategoriVerisi['iscilik']?['m2'] as num?? 0).toDouble();
      double iscilikMt = (kategoriVerisi['iscilik']?['mt'] as num?? 0).toDouble();

      double bazFiyat = malzemeM2 + iscilikM2;
      if (bazFiyat == 0) bazFiyat = malzemeMt + iscilikMt;
      if (bazFiyat == 0) bazFiyat = malzemeM2!=0? malzemeM2 : iscilikM2;

      double _toDouble(dynamic v, double def) {
        if (v == null) return def;
        if (v is num) return v.toDouble();
        return double.tryParse('$v')?? def;
      }

      double miktar = _toDouble(secilenler['miktar']?? secilenler['alan']?? secilenler['alan_m2']?? secilenler['m2']?? 1, 1);
      double adet = _toDouble(secilenler['adet'], 1);
      double mt = _toDouble(secilenler['mt'], miktar);
      double m3 = _toDouble(secilenler['m3'], miktar);

      // 2. ALAN KATSAYILARI - RES için kule, donum vb hepsi burada
      double alanKatsayi = 1.0;
      Map<String, dynamic> alanKatsayilari = kategoriVerisi['alanKatsayilari']?? {};
      secilenler.forEach((k, v) {
        String val = '$v';
        if (alanKatsayilari.containsKey(val)) {
          alanKatsayi *= (alanKatsayilari[val] as num).toDouble();
        }
        // kule_20_30 gibi alan anahtarı direkt secilenler key'i ise
        if (alanKatsayilari.containsKey(k) && v == true) {
          alanKatsayi *= (alanKatsayilari[k] as num).toDouble();
        }
      });

      // 3. ÇARPANLAR
      double toplamCarpan = 1.0 * alanKatsayi;
      Map<String, dynamic> carpanlar = kategoriVerisi['carpanlar']?? {};
      secilenler.forEach((k, v) {
        if (carpanlar.containsKey(v)) {
          toplamCarpan *= (carpanlar[v] as num).toDouble();
        }
      });

      // 4. EKSTRALAR - m2, mt, m3, adet, sabit, carpan
      double ekstraToplam = 0;
      Map<String, dynamic> ekstralar = kategoriVerisi['ekstralar']?? {};

      void _ekstraEkle(String eKey) {
        if (!ekstralar.containsKey(eKey)) return;
        var data = ekstralar[eKey] as Map<String, dynamic>;
        double fiyat = (data['fiyat'] as num).toDouble();
        String tip = '${data['tip']?? 'sabit'}'.toLowerCase();

        if (tip == 'm2') {
          ekstraToplam += fiyat * miktar;
        } else if (tip == 'mt') {
          ekstraToplam += fiyat * mt;
        } else if (tip == 'm3') {
          ekstraToplam += fiyat * m3;
        } else if (tip == 'adet') {
          ekstraToplam += fiyat * adet;
        } else if (tip == 'carpan') {
          toplamCarpan *= fiyat;
        } else {
          // sabit - negatif indirimler dahil
          ekstraToplam += fiyat;
        }
      }

      secilenler.forEach((k, v) {
        if (v is List) {
          for (var e in v) _ekstraEkle('$e');
        } else {
          _ekstraEkle('$v');
        }
      });

      // 5. KAT FARKI / KULE / ZOR ARAZİ / VİNC
      double katFarkiToplam = 0;
      Map<String, dynamic> katFarki = kategoriVerisi['katFarki']?? {};
      secilenler.forEach((k, v) {
        String val = '$v';
        if (katFarki.containsKey(val) && val!= 'kaynak') {
          katFarkiToplam += (katFarki[val] as num).toDouble();
        }
      });
      if (secilenler.containsKey('katFarki') && katFarki.containsKey('${secilenler['katFarki']}')) {
        katFarkiToplam += (katFarki['${secilenler['katFarki']}'] as num).toDouble();
      }
      if (secilenler.containsKey('kat') && katFarki.containsKey('${secilenler['kat']}')) {
        katFarkiToplam += (katFarki['${secilenler['kat']}'] as num).toDouble();
      }

      // 6. ŞEHİR ÇARPANI
      double sehirCarpani = _getSehirCarpani(kategoriVerisi['sehirCarpani'], sehir);

      // 7. FİNAL
      double araToplam = 0;
      if (bazFiyat > 0) {
        araToplam = (bazFiyat * miktar * toplamCarpan) + ekstraToplam + katFarkiToplam;
      } else {
        // bazFiyat 0 olan kategoriler: RES, sihhi_tesisat, uydu_kamera vb - sadece ekstralar+carpanlar
        if (ekstraToplam > 0) {
          araToplam = (ekstraToplam * toplamCarpan) + katFarkiToplam;
          // ekstraToplam zaten carpan uygulandıysa çift çarpma olmaması için
          if (toplamCarpan!= alanKatsayi) {
            // ekstra içinde carpan tipi yoksa normal hesap
            araToplam = (ekstraToplam * (toplamCarpan / alanKatsayi) * alanKatsayi) + katFarkiToplam;
          }
        } else {
          araToplam = katFarkiToplam;
        }
      }

      double finalFiyat = araToplam * sehirCarpani;

      // 8. ASGARİ FİYAT KORUMASI
      double asgariKucuk = (kategoriVerisi['iscilik']?['asgariKucuk'] as num?? 0).toDouble();
      double asgariBuyuk = (kategoriVerisi['iscilik']?['asgariBuyuk'] as num?? 0).toDouble();

      if (finalFiyat > 0) {
        bool buyukIs = miktar >= 10 || finalFiyat >= asgariBuyuk && asgariBuyuk > 0;
        double esik = buyukIs && asgariBuyuk > 0? asgariBuyuk : asgariKucuk;
        if (esik > 0 && finalFiyat < esik) {
          finalFiyat = esik * sehirCarpani;
        }
      }

      return finalFiyat;
    } catch (e) {
      debugPrint("Hesaplama Robotu Hatası: $e");
      return 0.0;
    }
  }

  static double _getSehirCarpani(Map<String, dynamic>? sehirMap, String sehir) {
    if (sehirMap == null) return 1.0;
    String s = sehir.toLowerCase().trim();
    if (s == 'istanbul') return (sehirMap['istanbul'] as num?? 1.0).toDouble();
    if (['ankara', 'izmir', 'antalya', 'bursa'].contains(s)) {
      return (sehirMap['ankara_izmir_antalya_bursa'] as num?? 1.0).toDouble();
    }
    return (sehirMap['diger_iller']?? 1.0).toDouble();
  }
}