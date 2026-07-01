// lib/core/calculation/meslekler/hesap_elektrikli_arac.dart

class ElektrikliAracHesaplayici {

  static Map<String, dynamic> hesapla(List<dynamic> gelenCevaplar) {

    String findValue(String anahtar, String varsayilan) {
      if (gelenCevaplar.isEmpty) return varsayilan;
      for (var element in gelenCevaplar) {
        if (element is Map && element.containsKey('id') && element['id'] == anahtar) {
          return element['cevap']?.toString()?? varsayilan;
        }
        if (element is Map && element.containsKey(anahtar)) {
          return element[anahtar]?.toString()?? varsayilan;
        }
      }
      return varsayilan;
    }

    List<String> findMultiValue(String anahtar) {
      if (gelenCevaplar.isEmpty) return [];
      for (var element in gelenCevaplar) {
        if (element is Map && element.containsKey('id') && element['id'] == anahtar) {
          var cevap = element['cevap'];
          if (cevap is List) return cevap.map((e) => e.toString()).toList();
          if (cevap is String) return [cevap];
        }
      }
      return [];
    }

    final String isTuru = findValue('is_turu', 'Ev Tipi Şarj İstasyonu Kurulumu');

    // Ortak değişkenler
    double tabanFiyat = 0.0;
    double cihazMaliyeti = 0.0;
    double tesisatMaliyeti = 0.0;
    double projeHizmetMaliyeti = 0.0;
    double zorlukEkstra = 0.0;
    double mekanCarpani = 1.0;
    double nihaiAdet = 1.0;

    // ==========================================
    // 1) EV TİPİ ŞARJ İSTASYONU KURULUMU
    // ==========================================
    if (isTuru == "Ev Tipi Şarj İstasyonu Kurulumu") {
      final String kurulumYeri = findValue('kurulum_yeri_ev', 'Müstakil Ev');
      final String aracSayisi = findValue('arac_sayisi_ev', '1 araç');
      final String sarjGucu = findValue('sarj_gucu_ev', '7.4 kW (Hızlı ev tipi)');
      final String elektrikAltyapi = findValue('elektrik_altyapisi_ev', 'Yeni tesisat gerekli');
      final String sayacDurumu = findValue('sayac_durumu', 'Tek faz');
      final String akilliSarj = findValue('akilli_sarj', 'Hayır');

      // Araç sayısı çarpanı
      if (aracSayisi.contains('2')) nihaiAdet = 2.0;
      if (aracSayisi.contains('3+')) nihaiAdet = 3.0;

      // Şarj gücü + cihaz maliyeti - 2026 TR
      if (sarjGucu.contains('3.7')) {
        tabanFiyat = 20000.0;
        cihazMaliyeti = 25000.0 * nihaiAdet;
      } else if (sarjGucu.contains('7.4')) {
        tabanFiyat = 25000.0;
        cihazMaliyeti = 37500.0 * nihaiAdet; // 25-50k ort
      } else if (sarjGucu.contains('11')) {
        tabanFiyat = 30000.0;
        cihazMaliyeti = 60000.0 * nihaiAdet; // 40-80k ort
      } else if (sarjGucu.contains('22')) {
        tabanFiyat = 35000.0;
        cihazMaliyeti = 60000.0 * nihaiAdet;
      } else { // Bilmiyorum
        tabanFiyat = 25000.0;
        cihazMaliyeti = 37500.0 * nihaiAdet;
      }

      // Elektrik altyapısı
      if (elektrikAltyapi.contains('Yeni tesisat')) {
        tesisatMaliyeti = 12500.0; // 35m ort
      } else if (elektrikAltyapi.contains('Kısmen')) {
        tesisatMaliyeti = 5000.0;
      } else {
        tesisatMaliyeti = 2500.0;
      }

      // Sayaç durumu ek maliyet
      if (sayacDurumu.contains('Trifaze') && sarjGucu.contains('22')) {
        tesisatMaliyeti += 8000.0; // Trifaze pano upgrade
      }

      // Akıllı şarj ek maliyet
      if (akilliSarj.contains('Evet')) {
        cihazMaliyeti += 5000.0 * nihaiAdet; // App modül
      }

      // Mekan çarpanı
      if (kurulumYeri.contains('Villa')) mekanCarpani = 1.20;
      if (kurulumYeri.contains('Apartman')) mekanCarpani = 1.35;
      if (kurulumYeri.contains('Açık')) mekanCarpani = 1.15;
      if (kurulumYeri.contains('Kapalı Garaj')) mekanCarpani = 1.10;
    }

    // ==========================================
    // 2) SİTE VE APARTMAN ŞARJ İSTASYONU
    // ==========================================
    else if (isTuru == "Site ve Apartman Şarj İstasyonu Kurulumu") {
      final String kurulumTipi = findValue('kurulum_tipi_site', 'Ortak kullanım istasyonu');
      final String kapasite = findValue('arac_kapasitesi_site', '5–10 araç');
      final String loadBalancing = findValue('load_balancing', 'Evet istiyorum');
      final String olcumSistemi = findValue('olcum_sistemi', 'Kişisel sayaçlı');
      final String yetkilendirme = findValue('yetkilendirme_sistemi', 'Mobil uygulama');

      // Kapasite adedi
      if (kapasite.contains('1–5')) nihaiAdet = 3.0;
      else if (kapasite.contains('5–10')) nihaiAdet = 7.0;
      else if (kapasite.contains('10–20')) nihaiAdet = 15.0;
      else nihaiAdet = 25.0;

      // Taban + cihaz - 11-22kW site tipi
      tabanFiyat = 40000.0;
      if (kurulumTipi.contains('Bireysel')) {
        cihazMaliyeti = 60000.0 * nihaiAdet; // Her kullanıcıya ayrı 22kW
        tesisatMaliyeti = 8000.0 * nihaiAdet; // Her nokta ayrı hat
      } else if (kurulumTipi.contains('Ortak')) {
        cihazMaliyeti = 80000.0 * 2; // 2 adet ortak 22kW
        tesisatMaliyeti = 25000.0; // Ortak pano
      } else { // Her ikisi
        cihazMaliyeti = (60000.0 * nihaiAdet) + 160000.0;
        tesisatMaliyeti = (8000.0 * nihaiAdet) + 25000.0;
      }

      // Load balancing ek maliyet
      if (loadBalancing.contains('Evet')) projeHizmetMaliyeti += 20000.0;

      // Ölçüm sistemi
      if (olcumSistemi.contains('Kişisel sayaçlı')) tesisatMaliyeti += 3000.0 * nihaiAdet;
      if (olcumSistemi.contains('Kart / RFID')) cihazMaliyeti += 5000.0 * nihaiAdet;

      // Yetkilendirme
      if (yetkilendirme.contains('Mobil') || yetkilendirme.contains('Kart')) {
        projeHizmetMaliyeti += 10000.0;
      }

      mekanCarpani = 1.50; // Site zorluğu
    }

    // ==========================================
    // 3) TİCARİ ŞARJ İSTASYONU KURULUMU
    // ==========================================
    else if (isTuru == "Ticari Şarj İstasyonu Kurulumu") {
      final String isletmeTipi = findValue('isletme_tipi_ticari', 'AVM');
      final String sarjKapasitesi = findValue('sarj_kapasitesi_ticari', '3–5 araç');
      final String gelirModeli = findValue('gelir_modeli', 'Ücretli şarj');
      final List<String> odemeSistemi = findMultiValue('odeme_sistemi');

      // Kapasite adedi
      if (sarjKapasitesi.contains('1–2')) nihaiAdet = 2.0;
      else if (sarjKapasitesi.contains('3–5')) nihaiAdet = 4.0;
      else if (sarjKapasitesi.contains('5–10')) nihaiAdet = 7.0;
      else nihaiAdet = 12.0;

      // Ticari AC 22kW
      tabanFiyat = 60000.0;
      cihazMaliyeti = 105000.0 * nihaiAdet; // 60-150k ort
      tesisatMaliyeti = 35000.0 * (nihaiAdet / 2); // Ortak altyapı

      // İşletme tipine göre ek
      if (isletmeTipi.contains('Akaryakıt') || isletmeTipi.contains('AVM')) {
        zorlukEkstra += 50000.0; // Ruhsat + özel proje
        mekanCarpani = 2.00;
      } else if (isletmeTipi.contains('Otel') || isletmeTipi.contains('Restoran')) {
        mekanCarpani = 1.60;
      } else {
        mekanCarpani = 1.80;
      }

      // Gelir modeli + ödeme sistemi
      if (gelirModeli.contains('Ücretli') && odemeSistemi.isNotEmpty) {
        projeHizmetMaliyeti = 25000.0 + (odemeSistemi.length * 5000.0);
      }
    }

    // ==========================================
    // 4) OTOPARK ŞARJ ALTYAPISI KURULUMU
    // ==========================================
    else if (isTuru == "Otopark Şarj Altyapısı Kurulumu") {
      final String otoparkTipi = findValue('otopark_tipi', 'Kapalı otopark');
      final String altyapiDurumu = findValue('altyapi_durumu', 'Elektrik hazır');
      final String kabloAltyapisi = findValue('kablo_altyapisi', 'Yer altı');
      final String gelecekGenisleme = findValue('gelecek_genisleme', 'Evet (ölçeklenebilir sistem)');

      tabanFiyat = 50000.0; // Projelendirme dahil
      nihaiAdet = 8.0; // Başlangıç 8 nokta
      cihazMaliyeti = 80000.0 * nihaiAdet; // 4 adet 22kW başlangıç
      tesisatMaliyeti = 60000.0; // Ana omurga

      // Altyapı durumu
      if (altyapiDurumu.contains('Komple')) {
        tesisatMaliyeti += 100000.0;
        zorlukEkstra += 30000.0;
      } else if (altyapiDurumu.contains('Kısmen')) {
        tesisatMaliyeti += 40000.0;
      }

      // Kablo altyapısı
      if (kabloAltyapisi.contains('Yer altı')) tesisatMaliyeti += 50000.0;
      if (kabloAltyapisi.contains('Karışık')) tesisatMaliyeti += 25000.0;

      // Genişleme
      if (gelecekGenisleme.contains('Evet')) projeHizmetMaliyeti = 30000.0;

      if (otoparkTipi.contains('AVM')) mekanCarpani = 2.10;
      else if (otoparkTipi.contains('Site')) mekanCarpani = 1.60;
      else if (otoparkTipi.contains('Açık')) mekanCarpani = 1.40;
      else mekanCarpani = 1.70;
    }

    // ==========================================
    // 5) AC ŞARJ ÜNİTESİ KURULUMU
    // ==========================================
    else if (isTuru == "AC Şarj Ünitesi Kurulumu") {
      final String kullanimAmaci = findValue('kullanim_amaci_ac', 'Ev');
      final String gucSeviyesi = findValue('guc_seviyesi_ac', '7.4 kW');
      final String baglantiTipi = findValue('baglanti_tipi', 'Type 2');
      final List<String> akilliOzellikler = findMultiValue('akilli_ozellikler');

      // Güç bazlı
      if (gucSeviyesi.contains('3.7')) {
        tabanFiyat = 20000.0;
        cihazMaliyeti = 25000.0;
      } else if (gucSeviyesi.contains('7.4')) {
        tabanFiyat = 25000.0;
        cihazMaliyeti = 37500.0;
      } else if (gucSeviyesi.contains('11')) {
        tabanFiyat = 30000.0;
        cihazMaliyeti = 60000.0;
      } else { // 22kW
        tabanFiyat = 35000.0;
        cihazMaliyeti = 60000.0;
      }

      tesisatMaliyeti = 8000.0; // Standart tesisat

      // Akıllı özellikler
      if (akilliOzellikler.contains('Uygulama kontrolü')) cihazMaliyeti += 5000.0;
      if (akilliOzellikler.contains('Enerji takibi')) cihazMaliyeti += 3000.0;
      if (akilliOzellikler.contains('Zamanlama')) cihazMaliyeti += 2000.0;

      if (kullanimAmaci.contains('İş') || kullanimAmaci.contains('Site')) mekanCarpani = 1.30;
      if (kullanimAmaci.contains('Otopark')) mekanCarpani = 1.40;
    }

    // ==========================================
    // 6) DC HIZLI ŞARJ ÜNİTESİ KURULUMU
    // ==========================================
    else if (isTuru == "DC Hızlı Şarj Ünitesi Kurulumu") {
      final String kurulumAmaci = findValue('kurulum_amaci_dc', 'Ticari kullanım');
      final String gucSeviyesi = findValue('guc_seviyesi_dc', '60 kW');
      final String sarjSuresi = findValue('sarj_suresi_hedefi', '30–60 dakika');
      final String ayniAndaArac = findValue('ayni_anda_arac', '2');

      // DC fiyatları
      if (gucSeviyesi.contains('30')) {
        tabanFiyat = 450000.0;
        cihazMaliyeti = 650000.0;
      } else if (gucSeviyesi.contains('60')) {
        tabanFiyat = 500000.0;
        cihazMaliyeti = 650000.0;
      } else if (gucSeviyesi.contains('120')) {
        tabanFiyat = 750000.0;
        cihazMaliyeti = 950000.0;
      } else if (gucSeviyesi.contains('150')) {
        tabanFiyat = 1000000.0;
        cihazMaliyeti = 1200000.0;
      } else { // 300kW+
        tabanFiyat = 1400000.0;
        cihazMaliyeti = 1800000.0;
      }

      // Aynı anda araç
      if (ayniAndaArac == '2') cihazMaliyeti *= 1.8;
      if (ayniAndaArac == '3+') cihazMaliyeti *= 2.5;

      tesisatMaliyeti = 150000.0; // Trafo + güçlü hat
      projeHizmetMaliyeti = 50000.0; // EPDK + Proje

      if (kurulumAmaci.contains('Otoyol')) {
        zorlukEkstra = 200000.0;
        mekanCarpani = 3.00;
      } else if (kurulumAmaci.contains('Kamu')) {
        zorlukEkstra = 100000.0;
        mekanCarpani = 2.80;
      } else {
        mekanCarpani = 2.50;
      }
    }

    // ==========================================
    // 7) ŞARJ İSTASYONU ARIZA VE SERVİSİ
    // ==========================================
    else if (isTuru == "Şarj İstasyonu Arıza ve Servisi") {
      final String arizaTipi = findValue('ariza_tipi_sarj', 'Şarj başlamıyor');
      final String cihazDurumu = findValue('cihaz_durumu', 'Tam çalışmıyor');
      final String acilDurum = findValue('acil_durum', 'Hayır');

      tabanFiyat = 2500.0; // Servis geliş
      if (arizaTipi.contains('Fiziksel')) {
        cihazMaliyeti = 15000.0; // Parça değişim
        zorlukEkstra = 5000.0;
      } else if (arizaTipi.contains('Kart') || arizaTipi.contains('uygulama')) {
        cihazMaliyeti = 8000.0; // Yazılım/kart
      } else if (arizaTipi.contains('Güç')) {
        cihazMaliyeti = 12000.0; // Güç kartı
        tesisatMaliyeti = 3000.0;
      } else {
        cihazMaliyeti = 5000.0; // Genel arıza
      }

      if (cihazDurumu.contains('Tam çalışmıyor')) zorlukEkstra += 3000.0;
      if (acilDurum.contains('Evet')) zorlukEkstra += 5000.0;
    }

    // ==========================================
    // 8) ŞARJ İSTASYONU BAKIMI
    // ==========================================
    else if (isTuru == "Şarj İstasyonu Bakımı") {
      final String bakimTipi = findValue('bakim_tipi', 'Periyodik bakım');
      final List<String> yapilacakIslemler = findMultiValue('yapilacak_islemler_bakim');
      final String sistemYogunlugu = findValue('sistem_yogunlugu', 'Orta kullanım');

      tabanFiyat = 3500.0; // Bakım ücreti
      if (bakimTipi.contains('Periyodik')) {
        cihazMaliyeti = 2500.0;
      } else if (bakimTipi.contains('Arıza sonrası')) {
        cihazMaliyeti = 5000.0;
        zorlukEkstra = 2000.0;
      } else {
        cihazMaliyeti = 4000.0;
      }

      // İşlem sayısı
      cihazMaliyeti += yapilacakIslemler.length * 1000.0;

      if (sistemYogunlugu.contains('Yoğun')) mekanCarpani = 1.30;
      if (sistemYogunlugu.contains('Az')) mekanCarpani = 0.85;
    }

    // ==========================================
    // 9) ŞARJ ALTYAPISI PROJELENDİRME
    // ==========================================
    else if (isTuru == "Şarj Altyapısı Projelendirme") {
      final String projeTipi = findValue('proje_tipi', 'Bireysel');
      final List<String> planlamaIcerigi = findMultiValue('planlama_icerigi');
      final String resmiSurec = findValue('resmi_surec', 'Evet');
      final String gelecekKapasite = findValue('gelecek_kapasite', 'Sabit sistem');

      tabanFiyat = 15000.0; // Proje çizim
      if (projeTipi.contains('Bireysel')) {
        projeHizmetMaliyeti = 10000.0;
      } else if (projeTipi.contains('Site')) {
        projeHizmetMaliyeti = 35000.0;
        mekanCarpani = 1.40;
      } else if (projeTipi.contains('Ticari')) {
        projeHizmetMaliyeti = 75000.0;
        mekanCarpani = 1.80;
      } else { // Endüstriyel
        projeHizmetMaliyeti = 120000.0;
        mekanCarpani = 2.20;
      }

      // Planlama içeriği
      projeHizmetMaliyeti += planlamaIcerigi.length * 5000.0;

      // Resmi süreç
      if (resmiSurec.contains('Evet')) projeHizmetMaliyeti += 25000.0;

      // Genişletilebilir
      if (gelecekKapasite.contains('Genişletilebilir')) zorlukEkstra = 15000.0;
    }

    // ==========================================
    // 10) ŞARJ İSTASYONU ELEKTRİK TESİSATI
    // ==========================================
    else if (isTuru == "Şarj İstasyonu Elektrik Tesisatı") {
      final String mevcutDurum = findValue('mevcut_durum_tesisat', 'Komple yeni tesisat');
      final String hatTipi = findValue('hat_tipi', 'Tek faz');
      final String kabloMesafesi = findValue('kablo_mesafesi', '10–30 metre');
      final String gucIhtiyaci = findValue('guc_ihtiyaci', 'Orta');

      tabanFiyat = 5000.0;

      // Mesafe bazlı
      if (kabloMesafesi.contains('0–10')) tesisatMaliyeti = 3500.0;
      else if (kabloMesafesi.contains('10–30')) tesisatMaliyeti = 7500.0;
      else if (kabloMesafesi.contains('30–100')) tesisatMaliyeti = 20000.0;
      else tesisatMaliyeti = 40000.0; // 100+

      // Durum
      if (mevcutDurum.contains('Komple yeni')) {
        tesisatMaliyeti += 5000.0;
        cihazMaliyeti = 8000.0; // Sigorta + kaçak akım
      } else if (mevcutDurum.contains('Kısmen')) {
        cihazMaliyeti = 4000.0;
      } else {
        cihazMaliyeti = 2000.0;
      }

      // Hat tipi
      if (hatTipi.contains('Trifaze')) tesisatMaliyeti += 8000.0;

      // Güç ihtiyacı
      if (gucIhtiyaci.contains('Yüksek')) tesisatMaliyeti += 10000.0;
    }

    // TOPLAM HESAP
    double toplamFiyat = (tabanFiyat + cihazMaliyeti + tesisatMaliyeti + projeHizmetMaliyeti + zorlukEkstra) * mekanCarpani;

    // Asgari baraj - 2026 piyasa
    double asgariBaraj = 25000.0; // AC ev tipi en düşük
    if (isTuru.contains('DC')) asgariBaraj = 500000.0; // DC en düşük
    if (isTuru.contains('Servis') || isTuru.contains('Bakım')) asgariBaraj = 2500.0;
    if (isTuru.contains('Projelendirme')) asgariBaraj = 15000.0;
    if (isTuru.contains('Tesisat')) asgariBaraj = 5000.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj? asgariBaraj : toplamFiyat;

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananCihazAdedi": nihaiAdet,
      "tabanFiyat": tabanFiyat,
      "cihazMaliyeti": cihazMaliyeti,
      "tesisatMaliyeti": tesisatMaliyeti,
      "projeHizmetMaliyeti": projeHizmetMaliyeti,
      "zorlukEkstra": zorlukEkstra,
      "mekanCarpani": mekanCarpani,
      "durum": "BAŞARILI"
    };
  }
}