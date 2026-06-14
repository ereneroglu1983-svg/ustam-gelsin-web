class KapiSistemleriHesaplayici {

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

    final String kapiTipi = findValue('kapi_tipi', 'Melamin Panel Kapı (Standart Oda Kapısı)');
    final String celikKapiYuzeyi = findValue('celik_kapi_yuzeyi', 'Standart Muhafazalı Çelik Kapı Gövdesi');
    final String odaKapiYuzeyi = findValue('oda_kapi_yuzeyi', 'Standart Kaplama / Boya Yüzeyi');
    final String kasaTipi = findValue('kasa_tipi', 'Ayarlı Geçme Kasa (Duvar Kalınlığına Göre Esneyen Teleskopik Pervaz)');
    final String montajDurum = findValue('montaj_durum', 'Sıfır İnşaat / Boş Kasa Yuvası (Söküm Yok Doğrudan Montaj)');
    final String kapiAdediSecim = findValue('kapi_adedi_secim', '5 - 7 Adet Arası (Standart 2+1 / 3+1 Daire Paketi)');

    bool isCelikKapi = kapiTipi.contains('Çelik');

    List<dynamic> birlesikEkstralar = [];
    String hedefEkstraId = isCelikKapi ? 'celik_kapi_ekstralari' : 'oda_kapi_ekstralari';

    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == hedefEkstraId && element['cevap'] is List) {
          birlesikEkstralar = element['cevap'];
          break;
        } else if (element.containsKey(hedefEkstraId) && element[hedefEkstraId] is List) {
          birlesikEkstralar = element[hedefEkstraId];
          break;
        }
      }
    }

    double adet = 1.0;
    if (kapiAdediSecim.contains('1 Adet') || kapiAdediSecim.contains('Tekil')) {
      adet = 1.0;
    } else if (kapiAdediSecim.contains('2-4') || kapiAdediSecim.contains('Küçük Daire')) {
      adet = 3.0;
    } else if (kapiAdediSecim.contains('5-7') || kapiAdediSecim.contains('Standart')) {
      adet = 6.0;
    } else if (kapiAdediSecim.contains('8-12') || kapiAdediSecim.contains('Geniş Daire')) {
      adet = 10.0;
    } else if (kapiAdediSecim.contains('12 Üzeri') || kapiAdediSecim.contains('Toplu')) {
      adet = 16.0;
    }

    double birimKapiFiyati = 7800.0;
    double montajIsciligi = 2200.0;

    if (isCelikKapi) {
      birimKapiFiyati = 26000.0;
      montajIsciligi = 5500.0;
    } else if (kapiTipi.contains('Lake') || kapiTipi.contains('Akrilik')) {
      birimKapiFiyati = 14500.0;
    } else if (kapiTipi.contains('Amerikan') || kapiTipi.contains('Pres')) {
      birimKapiFiyati = 5600.0;
    }

    if (isCelikKapi) {
      if (celikKapiYuzeyi.contains('Zırhlı') || celikKapiYuzeyi.contains('15mm') || celikKapiYuzeyi.contains('Sac')) {
        birimKapiFiyati += 9500.0;
      } else if (celikKapiYuzeyi.contains('Pivot')) {
        birimKapiFiyati += 28000.0;
      }
    } else {
      if (odaKapiYuzeyi.contains('Laminat') || odaKapiYuzeyi.contains('Çizilmez')) {
        birimKapiFiyati += 2500.0;
      }
      if (kasaTipi.contains('Ayarlı') || kasaTipi.contains('Teleskopik')) {
        birimKapiFiyati += 1200.0;
      } else if (kasaTipi.contains('Sadece Kanat') || kasaTipi.contains('Mevcut')) {
        birimKapiFiyati -= 1800.0;
        montajIsciligi -= 600.0;
      }
    }

    if (montajDurum.contains('Eski Kapı') || montajDurum.contains('Sökülecek') || montajDurum.contains('Moloz')) {
      montajIsciligi += 900.0;
    }

    double kapiBasiEkMaliyet = 0.0;
    double toplamTekilEkMaliyet = 0.0;

    for (var ozellik in birlesikEkstralar) {
      final String o = ozellik.toString();

      if (o.contains('Akıllı Kilit') || o.contains('Parmak İzi')) {
        toplamTekilEkMaliyet += 14000.0;
      }
      if (o.contains('Monoblok') || o.contains('Kancalı')) {
        kapiBasiEkMaliyet += 4500.0;
      }

      if (o.contains('Camlı') || o.contains('Temperli')) {
        kapiBasiEkMaliyet += 3200.0;
      }
      if (o.contains('Gizli Menteşe') || o.contains('Manyetik')) {
        kapiBasiEkMaliyet += 4800.0;
      }

      if (o.contains('Söve') || o.contains('Pervaz Genişletme')) {
        kapiBasiEkMaliyet += 1800.0;
      }
    }

    double toplamFiyat = ((birimKapiFiyati + montajIsciligi + kapiBasiEkMaliyet) * adet) + toplamTekilEkMaliyet;

    double asgariBaraj = isCelikKapi ? 32000.0 : 15000.0;
    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananAdet": adet,
      "birimKapiFiyati": birimKapiFiyati,
      "montajIsciligi": montajIsciligi,
      "ekMaliyet": (kapiBasiEkMaliyet * adet) + toplamTekilEkMaliyet,
      "durum": "BAŞARILI"
    };
  }
}