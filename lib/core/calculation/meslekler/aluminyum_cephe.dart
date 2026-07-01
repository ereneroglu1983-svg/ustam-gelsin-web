class AluminyumCepheHesaplayici {
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

    final String uygulamaTipi = findValue('uygulama_tipi', 'Alüminyum Doğrama Kapı/Pencere (Korkuluk / Küpeşte ve Sürme Sistemler)');
    final String cepheSistemDetayi = findValue('cephe_sistem_detayi', 'Kapaklı Giydirme Cephe (Dışarıdan Alüminyum Çizgisel Profiller Belirgin)');
    final String dogramaProfilSerisi = findValue('dograma_profil_serisi', 'Aldoks Serisi (Ekonomik İnce Seri Doğrama)');
    final String alanSegmenti = findValue('alan_segmenti', '0-10 m² / mt Arası Küçük Ölçek');
    final String profilRenk = findValue('profil_renk', 'Eloksal Kaplama (Gümüş / Parlak Standart Korozyon Dirençli)');
    final String zeminMontaj = findValue('zemin_montaj', 'Beton Zemin (Standart Ankrajlı Kolay Montaj)');

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

    double m2 = 5.0;
    String m2String = '0';

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

    double? parsedM2 = double.tryParse(m2String);
    if (parsedM2 != null && parsedM2 > 0) {
      m2 = parsedM2;
    } else {
      if (alanSegmenti.contains('0-10')) m2 = 5.0;
      else if (alanSegmenti.contains('10-30')) m2 = 20.0;
      else if (alanSegmenti.contains('30-100')) m2 = 65.0;
      else if (alanSegmenti.contains('100-300')) m2 = 200.0;
      else if (alanSegmenti.contains('300')) m2 = 450.0;
    }

    double birimFiyat = 2200.0;

    if (uygulamaTipi.contains('Giydirme Cephe')) {
      birimFiyat = 7800.0;
      if (cepheSistemDetayi.contains('Struktürel Silikon')) {
        birimFiyat += 1200.0;
      } else if (cepheSistemDetayi.contains('Yarı Kapak') || cepheSistemDetayi.contains('Badem Kapak')) {
        birimFiyat += 600.0;
      }
    } else if (uygulamaTipi.contains('Kompozit Panel')) {
      birimFiyat = 5100.0;
    } else if (uygulamaTipi.contains('Ofis Bölme')) {
      birimFiyat = 3900.0;
    } else if (uygulamaTipi.contains('Alüminyum Doğrama') || uygulamaTipi.contains('Korkuluk')) {
      birimFiyat = 2600.0;
      if (dogramaProfilSerisi.contains('C60')) {
        birimFiyat += 400.0;
      } else if (dogramaProfilSerisi.contains('HBSB') || dogramaProfilSerisi.contains('Hebeschiebe')) {
        birimFiyat += 3800.0;
      } else if (dogramaProfilSerisi.contains('Aldoks')) {
        birimFiyat -= 300.0;
      }
    }

    if (profilRenk.contains('Antrasit') || profilRenk.contains('Siyah')) {
      birimFiyat *= 1.15;
    } else if (profilRenk.contains('Bronz') || profilRenk.contains('Altın')) {
      birimFiyat *= 1.25;
    } else if (profilRenk.contains('Ahşap')) {
      birimFiyat *= 1.40;
    }

    double ekMaliyet = 0.0;
    if (zeminMontaj.contains('Mermer') || zeminMontaj.contains('Basamak')) {
      ekMaliyet += (m2 * 350.0);
    }
    if (zeminMontaj.contains('Yüksek') || zeminMontaj.contains('İskele')) {
      ekMaliyet += (m2 * 950.0);
    }

    for (var ozellik in ekstralar) {
      final String o = ozellik.toString();
      if (o.contains('Isı Yalıtım')) {
        birimFiyat += 1100.0;
      }
      if (o.contains('Lamine Cam')) {
        birimFiyat += 1600.0;
      }
      if (o.contains('Akıllı Cam')) {
        birimFiyat += 6500.0;
      }
    }

    double toplamFiyat = (m2 * birimFiyat) + ekMaliyet;

    double asgariBaraj = 12000.0;
    if (uygulamaTipi.contains('Giydirme Cephe')) asgariBaraj = 35000.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimFiyat,
      "ekMaliyet": ekMaliyet,
      "durum": "BAŞARILI"
    };
  }
}