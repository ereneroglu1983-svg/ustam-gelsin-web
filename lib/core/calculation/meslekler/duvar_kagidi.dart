// lib/core/calculation/meslekler/duvar_kagidi_hesaplayici.dart

class DuvarKagidiHesaplayici {

  // 🛠️ GÜVENLİK ENTEGRASYONU: Türkçe karakter, büyük/küçük harf ve boşluk risklerini sıfırlar
  static String _metniYalinHaleGetir(dynamic input) {
    if (input == null) return "";
    String metin = input.toString().toLowerCase().trim();
    return metin
        .replaceAll('_', '')
        .replaceAll('-', '')
        .replaceAll(',', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('/', '')
        .replaceAll(' ', '')
        .replaceAll('ş', 's')
        .replaceAll('ı', 'i')
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('+', '');
  }

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

    // 1. UI Formu ile Tam Uyumlu Veri Çekimi ve Yalınlaştırma
    final String isKapsamiRaw = findValue('is_kapsami', 'Komple Oda / Ev Duvar Kağıdı Kaplama');
    final String kagitTuruRaw = findValue('kagit_turu', 'Vinil / Silinebilir Kağıt (Neme Dayanıklı)');
    final String malzemeTedarikRaw = findValue('malzeme_tedarik', 'Malzemeyi Ben Tedarik Edeceğim (Sadece İşçilik)');
    final String alanSegmentiRaw = findValue('alan_segmenti', '20-50 m² Arası');
    final String zeminDurumuRaw = findValue('zemin_durumu', 'Boya / Saten Alçı (Düz ve Pürüzsüz Hazır Zemin)');

    final String isKapsami = _metniYalinHaleGetir(isKapsamiRaw);
    final String kagitTuru = _metniYalinHaleGetir(kagitTuruRaw);
    final String malzemeTedarik = _metniYalinHaleGetir(malzemeTedarikRaw);
    final String alanSegmenti = _metniYalinHaleGetir(alanSegmentiRaw);
    final String zeminDurumu = _metniYalinHaleGetir(zeminDurumuRaw);

    // Multi-select (Hazırlık ve Ekstralar) - Tip güvenliği sağlandı
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

    // 2. Metrekare Tahmini (Önce gerçek metraja bak, yoksa segmente düş)
    double m2 = 35.0;
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
      if (alanSegmenti.contains('020')) m2 = 12.0;
      else if (alanSegmenti.contains('2050')) m2 = 35.0;
      else if (alanSegmenti.contains('50100')) m2 = 75.0;
      else if (alanSegmenti.contains('100')) m2 = 200.0;
    }

    // 3. İş Durumu ve Taban Birim Fiyat (2026 İthal/Yerli Kağıt ve Polimer Tutkal Endeksi)
    double birimM2Fiyati = 0.0;
    double hazirlikMaliyeti = 0.0;

    if (isKapsami.contains('sadeceeskiduvarkagidi') || isKapsami.contains('sokum')) {
      birimM2Fiyati = 150.0; // Sadece söküm, temizlik ve kazıma m² birim fiyatı
    } else {
      // Standart Sadece İşçilik Taban Fiyatı
      birimM2Fiyati = 180.0;

      if (kagitTuru.contains('vinil') || kagitTuru.contains('elyaf')) {
        birimM2Fiyati = 240.0; // Kalın segment işçilik katsayısı
      } else if (kagitTuru.contains('tekstil') || kagitTuru.contains('kumas')) {
        birimM2Fiyati = 450.0; // Hassas Premium tekstil kağıdı işçilik katsayısı
      } else if (kagitTuru.contains('poster') || kagitTuru.contains('3d')) {
        birimM2Fiyati = 350.0; // Desen hizalamalı poster işçiliği
      }

      // 🛠️ MALZEME DAHİL ENTEGRASYONU: Malzemeyi usta tedarik ediyorsa 2026 malzeme rayici eklenir
      if (malzemeTedarik.contains('ustatedarik') || malzemeTedarik.contains('malzemeisclik')) {
        if (kagitTuru.contains('vinil') || kagitTuru.contains('elyaf')) {
          birimM2Fiyati += 310.0; // Vinil rulo ve polimer özel tutkal maliyeti
        } else if (kagitTuru.contains('tekstil') || kagitTuru.contains('kumas')) {
          birimM2Fiyati += 650.0; // İthal tekstil kumaş tabanlı lüks rulo maliyeti
        } else if (kagitTuru.contains('poster') || kagitTuru.contains('3d')) {
          birimM2Fiyati += 400.0; // Özel HD dikey baskılı poster malzeme maliyeti
        } else {
          birimM2Fiyati += 200.0; // Standart silinebilir kağıt rulo maliyeti
        }
      }

      // 4. Zemin Hazırlığı ve Zorluk Farkları (Yalın string araması ile %100 güvenli)
      if (zeminDurumu.contains('eskikagit')) {
        hazirlikMaliyeti += (m2 * 120.0); // Buharlı söküm, duvar kazıma ve yüzey temizliği
      } else if (zeminDurumu.contains('puruzlu') || zeminDurumu.contains('catlakli')) {
        hazirlikMaliyeti += (m2 * 180.0); // Saten alçı tamiratı ve zımpara işlemi
      }
    }

    // 5. Ekstralar ve Desen Fireleri (Multi-Select)
    double ekMaliyet = 0.0;
    double fireCarpani = 1.10; // Standart %10 fire (Köşe dönüşleri vb.)

    if (!isKapsami.contains('sokum')) {
      for (var ozellik in ekstralar) {
        final String ozellikYalin = _metniYalinHaleGetir(ozellik);

        if (ozellikYalin.contains('buyukdesen')) {
          fireCarpani = 1.25; // Desen eşleştirme sebebiyle artan rulo firesi
        }
        if (ozellikYalin.contains('donusumastari')) {
          ekMaliyet += (m2 * 60.0); // Kağıdın tutunmasını artıran geçiş astarı
        }
        if (ozellikYalin.contains('tavanuygulamasi')) {
          birimM2Fiyati *= 1.40; // Tavanda çalışma zorluğu ve yerçekimi işçilik farkı
        }
        if (ozellikYalin.contains('koruyucuvernik')) {
          ekMaliyet += (m2 * 80.0); // Posterler için sıvı laminasyon uygulaması
        }
      }
    }

    // 6. Nihai Hesaplama
    double toplamFiyat = ((m2 * birimM2Fiyati) + hazirlikMaliyeti + ekMaliyet) * fireCarpani;

    // 7. Usta Seferberlik Barajı (Yol, tezgah kurulumu ve özel tutkal sarfiyatı)
    double asgariBaraj = 6000.0;
    if (kagitTuru.contains('poster') || isKapsami.contains('sokum')) asgariBaraj = 4000.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj ? asgariBaraj.toDouble() : toplamFiyat.toDouble();

    // Orkestranın ve Firebase havuzunun beklediği standart nihai Map raporu
    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananM2": m2,
      "birimM2Fiyati": birimM2Fiyati,
      "hazirlikMaliyeti": hazirlikMaliyeti,
      "ekMaliyet": ekMaliyet,
      "fireCarpani": fireCarpani,
      "durum": "BAŞARILI"
    };
  }
}