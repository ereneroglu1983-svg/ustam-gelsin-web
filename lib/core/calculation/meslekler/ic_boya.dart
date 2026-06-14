class IcBoyaHesaplayici {
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

    final String yapiCesidi = findValue('yapi_cesidi', 'Daire');
    final String odaSayisi = findValue('oda_sayisi', '3+1');
    final String alanKademe = findValue('alan_kademe', '80-100 m²');
    final String mekanDurumu = findValue('mekan_durumu', 'Boş');
    final String tavanBoyasi = findValue('tavan_boyasi', 'Evet');
    final String zeminDurumu = findValue('zemin_durumu', 'Gerekmez');
    final String boyaTip = findValue('boya_tip', 'Su Bazlı Silikonlu (Silinebilir)');

    List<dynamic> ekstraIslemler = [];
    for (var element in gelenCevaplar) {
      if (element is Map) {
        if (element['id'] == 'ekstra_islemler' && element['cevap'] is List) {
          ekstraIslemler = element['cevap'];
          break;
        } else if (element.containsKey('ekstra_islemler') && element['ekstra_islemler'] is List) {
          ekstraIslemler = element['ekstra_islemler'];
          break;
        }
      }
    }

    double tabanM2 = 90.0;

    if (alanKademe.contains('0-40')) tabanM2 = 30.0;
    else if (alanKademe.contains('40-60')) tabanM2 = 50.0;
    else if (alanKademe.contains('60-80')) tabanM2 = 70.0;
    else if (alanKademe.contains('80-100')) tabanM2 = 90.0;
    else if (alanKademe.contains('100-120')) tabanM2 = 110.0;
    else if (alanKademe.contains('120-150')) tabanM2 = 135.0;
    else if (alanKademe.contains('150-200')) tabanM2 = 175.0;
    else if (alanKademe.contains('200-250')) tabanM2 = 225.0;
    else if (alanKademe.contains('250-300')) tabanM2 = 275.0;
    else if (alanKademe.contains('300+')) tabanM2 = 350.0;

    double odaEtkiM2 = 0.0;
    if (yapiCesidi.contains('Daire') || yapiCesidi.contains('Müstakil')) {
      if (odaSayisi.contains('1+0') || odaSayisi.contains('1+1')) odaEtkiM2 = 10.0;
      else if (odaSayisi.contains('2+1')) odaEtkiM2 = 25.0;
      else if (odaSayisi.contains('3+1')) odaEtkiM2 = 40.0;
      else if (odaSayisi.contains('4+1') || odaSayisi.contains('5+1') || odaSayisi.contains('6+')) odaEtkiM2 = 65.0;
    }

    double hesaplananDuvarM2 = (tabanM2 * 3.0) + odaEtkiM2;

    double birimM2Fiyati = 120.0;

    if (boyaTip.contains('Su Bazlı') || boyaTip.contains('Silikonlu') || boyaTip.contains('Silinebilir')) {
      birimM2Fiyati = 160.0;
    } else if (boyaTip.contains('Antibakteriyel')) {
      birimM2Fiyati = 195.0;
    } else if (boyaTip.contains('Yağlı')) {
      birimM2Fiyati = 230.0;
    }

    double zorlukCarpani = 1.0;
    if (mekanDurumu.contains('Eşyalı')) {
      zorlukCarpani = 1.30;
    }

    double hazirlikMaliyeti = 0.0;
    if (zeminDurumu.contains('Gerekir')) {
      hazirlikMaliyeti = (hesaplananDuvarM2 * 30.0);
    }

    double ekMaliyet = 0.0;

    if (tavanBoyasi.contains('Evet')) {
      ekMaliyet += (tabanM2 * 95.0);
    }

    for (var islem in ekstraIslemler) {
      final String i = islem.toString();
      if (i.contains('Koyu Renkten') || i.contains('Dönüşüm')) {
        birimM2Fiyati += 35.0;
      }
      if (i.contains('Kazıma') || i.contains('Macunlama')) {
        hazirlikMaliyeti += (hesaplananDuvarM2 * 45.0);
      }
      if (i.contains('Duvar Kağıdı') || i.contains('Sökümü')) {
        ekMaliyet += (hesaplananDuvarM2 * 50.0);
      }
      if (i.contains('Alçı') || i.contains('Sıva')) {
        hazirlikMaliyeti += (hesaplananDuvarM2 * 75.0);
      }
    }

    double toplamFiyat = ((hesaplananDuvarM2 * birimM2Fiyati) + hazirlikMaliyeti + ekMaliyet) * zorlukCarpani;

    double asgariBaraj = 14000.0;
    if (alanKademe.contains('0-40') || alanKademe.contains('40-60')) {
      asgariBaraj = 9500.0;
    }

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananDuvarM2": hesaplananDuvarM2,
      "birimM2Fiyati": birimM2Fiyati,
      "hazirlikMaliyeti": hazirlikMaliyeti,
      "ekMaliyet": ekMaliyet,
      "zorlukCarpani": zorlukCarpani,
      "durum": "BAŞARILI"
    };
  }
}