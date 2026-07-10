// lib/core/calculation/temizlik_hesaplayici.dart

class TemizlikHesaplayici {
  static Map<String, dynamic> hesapla(List<dynamic> gelenCevaplar) {
    String getVal(String id) => gelenCevaplar.firstWhere((i) => i['id'] == id, orElse: () => {'cevap': ''})['cevap'].toString();
    List<dynamic> getList(String id) => gelenCevaplar.firstWhere((i) => i['id'] == id, orElse: () => {'cevap': []})['cevap']?? [];

    final String hTipi = getVal('hizmet_tipi');
    double toplamFiyat = 0.0;
    double minLimit = 2500.0; // GÜNCEL 2026 - Min genel 2.5K

    // 1. İNŞAAT / GENEL / TAŞINMA
    if (["İnşaat Sonrası Temizlik", "Genel Ev ve Derin Temizlik", "Taşınma Öncesi/Sonrası Temizlik"].contains(hTipi)) {
      minLimit = (hTipi == "İnşaat Sonrası Temizlik")? 6000.0 : (hTipi == "Taşınma Öncesi/Sonrası Temizlik"? 3500.0 : 2500.0);
      double m2 = _getM2Degeri(getVal('m2'));
      double bazFiyat = (hTipi == "İnşaat Sonrası Temizlik")? 90.0 : (hTipi == "Taşınma Öncesi/Sonrası Temizlik"? 45.0 : 35.0); // GÜNCEL 2026

      double zorluk = 1.0;
      String tadilat = getVal('tadilat_tipi');
      if (tadilat.contains('Komple')) zorluk = 1.7;
      else if (tadilat.contains('Yeni İnşaat')) zorluk = 1.3;

      toplamFiyat = m2 * bazFiyat * zorluk;
      for (var ek in getList('ekipman')) {
        String ekStr = ek.toString();
        if (ekStr.contains('Sanayi')) toplamFiyat += 750.0; // GÜNCEL 2026
        else if (ekStr.contains('Zemin Kazıma')) toplamFiyat += 2000.0; // GÜNCEL 2026
        else if (ekStr.contains('Buharlı')) toplamFiyat += 750.0; // GÜNCEL 2026
      }
    }

    // 2. CAM VE CEPHE
    else if (hTipi == "Cam ve Cephe Temizliği") {
      minLimit = 5000.0; // GÜNCEL 2026 - Min cam 5K
      double yCarpani = getVal('yükseklik').contains('Yüksek')? 2.5 : 1.0;
      double kCarpani = getVal('kirlilik').contains('Ağır')? 1.5 : 1.0;

      String kat = getVal('kat');
      if (kat.isEmpty) kat = '1-3';
      double katCarpani = kat.contains('4-8')? 1.5 : (kat.contains('9+')? 2.5 : 1.0);

      toplamFiyat = 5000.0 * yCarpani * kCarpani * katCarpani; // GÜNCEL 2026 - Baz 5K
    }

    // 3. MUTFAK VE BANYO
    else if (hTipi == "Mutfak ve Banyo Temizliği") {
      minLimit = 3000.0; // GÜNCEL 2026 - Min mutfak 3K
      double hacim = getVal('hacim').contains('Komple')? 2.0 : 1.0;
      double hijyen = getVal('dezenfeksiyon').contains('Derin')? 1.4 : 1.0;
      toplamFiyat = 3000.0 * hacim * hijyen; // GÜNCEL 2026 - Baz 3K
    }

    // 4. BAHÇE VE DIŞ ALAN (m²)
    else if (hTipi == "Bahçe ve Dış Alan Temizliği") {
      minLimit = 3500.0; // GÜNCEL 2026 - Min bahçe 3.5K
      toplamFiyat = 3500.0 * _getAlanOlcek(getVal('alan_tipi'), false); // GÜNCEL 2026 - Baz 3.5K
    }

    // 5. HAVUZ TEMİZLİĞİ (m³)
    else if (hTipi == "Havuz Temizliği ve Bakımı") {
      minLimit = 5000.0; // GÜNCEL 2026 - Min havuz 5K
      toplamFiyat = 5000.0 * _getAlanOlcek(getVal('alan_tipi'), true); // GÜNCEL 2026 - Baz 5K
      for (var ek in getList('kapsam')) {
        String ekStr = ek.toString();
        if (ekStr.contains('Kimyasallar')) toplamFiyat *= 1.15; // GÜNCEL 2026
        if (ekStr.contains('Yeşil')) toplamFiyat *= 1.30; // GÜNCEL 2026 - Yosun
        if (ekStr.contains('Dip Çamuru')) toplamFiyat *= 1.20; // GÜNCEL 2026
      }
    }

    // 6. MERDİVEN VE ORTAK ALAN
    else if (hTipi == "Merdiven ve Ortak Alan Temizliği") {
      minLimit = 2500.0; // GÜNCEL 2026 - Min merdiven 2.5K
      int kat = _getKatDegeri(getVal('kat'));
      double periyot = getVal('periyot').contains('15')? 0.85 : (getVal('periyot').contains('Hafta')? 0.70 : 1.0);
      toplamFiyat = (kat * 750.0) * periyot; // GÜNCEL 2026 - 750 TL/kat
    }

    if (toplamFiyat <= 0) return {"tahminiButce": 0, "durum": "HATA"};

    // 3 SENARYO ÜRETİMİ - Yüzdelik yasak, bağımsız hesap
    double minimumButce = minLimit; // 🟢 Ekonomik
    double muhtemelButce = toplamFiyat < minLimit? minLimit : toplamFiyat; // ⭐ Türkiye ortalaması
    double maksimumButce = muhtemelButce * 1.42; // 🔴 Zor koşul + ek hizmet

    return {
      "minimumButce": minimumButce.round(),
      "muhtemelButce": muhtemelButce.round(),
      "maksimumButce": maksimumButce.round(),
      "tahminiButce": muhtemelButce.round(), // Geriye dönük uyumluluk
      "birim": "TRY",
      "durum": "BAŞARILI"
    };
  }

  static double _getM2Degeri(String m2) {
    if (m2.contains('0-50')) return 30.0;
    if (m2.contains('51-100')) return 75.0;
    if (m2.contains('101-150')) return 125.0;
    if (m2.contains('151-200')) return 175.0;
    if (m2.contains('201-300')) return 250.0;
    if (m2.contains('300+')) return 350.0;
    return 75.0;
  }

  static double _getAlanOlcek(String alan, bool isHavuz) {
    if (alan.contains('Orta')) return 1.5;
    if (alan.contains('Büyük')) return 2.5;
    if (alan.contains('Çok Büyük')) return 4.0;
    return 1.0;
  }

  static int _getKatDegeri(String kat) {
    if (kat.contains('1-5')) return 5;
    if (kat.contains('6-10')) return 10;
    if (kat.contains('11-15')) return 15;
    return 20;
  }
}