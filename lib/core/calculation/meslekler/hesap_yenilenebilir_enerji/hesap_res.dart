// lib/core/calculation/meslekler/hesap_res.dart

class RESHesaplayici {

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

    final String isTuru = findValue('is_turu', 'Rüzgar Türbini Kurulumu');

    double tabanFiyat = 0.0;
    double sistemGucuKw = 0.0;
    double turbinMaliyeti = 0.0;
    double kuleMaliyeti = 0.0;
    double temelMaliyeti = 0.0;
    double inverterMaliyeti = 0.0;
    double akuMaliyeti = 0.0;
    double montajMaliyeti = 0.0;
    double ekHizmetMaliyeti = 0.0;
    double zorlukCarpani = 1.0;
    double projeMaliyeti = 0.0;

    // ==========================================
    // 1) RÜZGAR TÜRBİNİ KURULUMU
    // ==========================================
    if (isTuru == "Rüzgar Türbini Kurulumu") {
      final String kurulumAlani = findValue('kurulum_alan_tipi', 'Tarımsal Arazi');
      final String sistemGucu = findValue('sistem_gucu', '5 - 10 kW Arası');
      final String baglantiTipi = findValue('elektrik_baglanti_tipi', 'Akülü Sistem (Off-Grid)');
      final String kuleYuksekligi = findValue('kule_yuksekligi', '10 - 20 Metre');

      // Sistem gücü - Gezegen Solar 2026
      if (sistemGucu.contains('1 kW')) {
        sistemGucuKw = 1.0;
        tabanFiyat = 38000.0; // 2kW 38k TL baz
      } else if (sistemGucu.contains('1 - 5')) {
        sistemGucuKw = 3.0;
        tabanFiyat = 55000.0;
      } else if (sistemGucu.contains('5 - 10')) {
        sistemGucuKw = 7.5;
        tabanFiyat = 120000.0; // 5kW her şey dahil
      } else if (sistemGucu.contains('10 - 50')) {
        sistemGucuKw = 30.0;
        tabanFiyat = 300000.0; // Armut 30kW 300k
      } else if (sistemGucu.contains('50 kW')) {
        sistemGucuKw = 100.0;
        tabanFiyat = 1500000.0; // Tahmini
      } else { // Uzman Keşfi
        sistemGucuKw = 10.0;
        tabanFiyat = 250000.0;
      }

      // Kule yüksekliği - maliyet +20% her 10m
      if (kuleYuksekligi.contains('10 - 20')) kuleMaliyeti = 35000.0;
      else if (kuleYuksekligi.contains('20 - 30')) kuleMaliyeti = 60000.0;
      else if (kuleYuksekligi.contains('30 Metre')) kuleMaliyeti = 95000.0;
      else kuleMaliyeti = 25000.0; // 5-10m

      // Alan tipi zorluk
      if (kurulumAlani.contains('Dağlık')) zorlukCarpani = 1.40;
      else if (kurulumAlani.contains('Açık')) zorlukCarpani = 1.10;
      else if (kurulumAlani.contains('Konut')) zorlukCarpani = 1.25; // İzin + vinç

      // Bağlantı tipi - akü/inverter
      if (baglantiTipi.contains('Akülü')) akuMaliyeti = 55000.0; // 200Ah Lityum
      if (baglantiTipi.contains('Hibrit')) inverterMaliyeti = 32000.0; // 5kW hibrit

      temelMaliyeti = 20000.0;
      montajMaliyeti = sistemGucuKw * 2000.0; // kW başı 2k montaj
    }

    // ==========================================
    // 2) KÜÇÜK ÖLÇEKLİ RÜZGAR TÜRBİNİ KURULUMU
    // ==========================================
    else if (isTuru == "Küçük Ölçekli Rüzgar Türbini Kurulumu") {
      final String kullanimYeri = findValue('kullanım_yeri', 'Ev');
      final String enerjiIhtiyaci = findValue('gunluk_enerji_ihtiyaci', 'Orta Tüketim');
      final String akuSistemi = findValue('aku_sistemi', 'Evet');
      final String hibritSistem = findValue('hibrit_sistem', 'Hayır');

      // GunesDukkan 2026 - küçük ölçek
      if (enerjiIhtiyaci.contains('Düşük')) {
        sistemGucuKw = 0.5;
        turbinMaliyeti = 17180.0; // IstaBreeze 500W
      } else if (enerjiIhtiyaci.contains('Orta')) {
        sistemGucuKw = 1.0;
        turbinMaliyeti = 51793.0; // IstaBreeze 1000W
      } else if (enerjiIhtiyaci.contains('Yüksek')) {
        sistemGucuKw = 2.0;
        turbinMaliyeti = 85000.0; // Tahmini 2kW
      } else {
        sistemGucuKw = 0.7;
        turbinMaliyeti = 31038.0; // IstaBreeze 700W
      }

      // Kullanım yeri montaj farkı
      if (kullanimYeri.contains('Karavan') || kullanimYeri.contains('Tekne')) {
        zorlukCarpani = 1.20; // Mobil montaj
        ekHizmetMaliyeti = 5000.0; // Braket
      } else if (kullanimYeri.contains('Çiftlik')) {
        zorlukCarpani = 1.10;
      }

      // Akü sistemi
      if (akuSistemi.contains('Evet')) {
        akuMaliyeti = 25000.0; // 100Ah Lityum
      }

      // Hibrit
      if (hibritSistem.contains('Evet')) {
        ekHizmetMaliyeti += 15000.0; // Güneş paneli entegrasyon
      }

      montajMaliyeti = 8000.0;
    }

    // ==========================================
    // 3) EV TİPİ RÜZGAR TÜRBİNİ KURULUMU
    // ==========================================
    else if (isTuru == "Ev Tipi Rüzgar Türbini Kurulumu") {
      final String yapiTipi = findValue('yapi_tipi', 'Müstakil Ev');
      final String yapiYuksekligi = findValue('yapi_yuksekligi', '2 Katlı');
      final String montajYeri = findValue('montaj_yeri', 'Çatı Üzeri');

      sistemGucuKw = 3.0; // Ev tipi standart
      tabanFiyat = 95000.0; // 2kW 38k + kule + işçilik

      // Yapı yüksekliği - kule ihtiyacı
      if (yapiYuksekligi.contains('Tek Katlı')) kuleMaliyeti = 45000.0; // 20m kule
      else if (yapiYuksekligi.contains('2 Katlı')) kuleMaliyeti = 35000.0; // 15m
      else if (yapiYuksekligi.contains('3 Katlı')) kuleMaliyeti = 25000.0; // 10m
      else kuleMaliyeti = 20000.0; // 4+ kat, çatı yeterli

      // Montaj yeri
      if (montajYeri.contains('Bahçe')) {
        zorlukCarpani = 1.10;
        temelMaliyeti = 15000.0;
      } else if (montajYeri.contains('Direk')) {
        zorlukCarpani = 1.25;
      }

      if (yapiTipi.contains('Villa') || yapiTipi.contains('Yazlık')) {
        zorlukCarpani *= 1.15; // Estetik montaj
      }

      inverterMaliyeti = 20500.0; // 3kW On-Grid
    }

    // ==========================================
    // 4) TARIMSAL AMAÇLI RÜZGAR TÜRBİNİ KURULUMU
    // ==========================================
    else if (isTuru == "Tarımsal Amaçlı Rüzgar Türbini Kurulumu") {
      final String kullanimAmaci = findValue('tarimsal_kullanim_amaci', 'Sulama Sistemi');
      final String tarimAlani = findValue('tarim_alani', '5 - 20 Dönüm');
      final String elektrikHatti = findValue('elektrik_hatti', 'Hayır');

      // Tarımsal 5-10kW - sulama pompası
      sistemGucuKw = 7.5;
      tabanFiyat = 120000.0; // 5kW her şey dahil

      // Tarım alanı
      if (tarimAlani.contains('0 - 5')) sistemGucuKw = 3.0;
      else if (tarimAlani.contains('20 - 50')) sistemGucuKw = 15.0;
      else if (tarimAlani.contains('50 Dönüm')) sistemGucuKw = 30.0;

      // Kullanım amacı ek
      if (kullanimAmaci.contains('Sulama')) {
        ekHizmetMaliyeti = 60000.0; // Pompa entegrasyon
      } else if (kullanimAmaci.contains('Hayvancılık')) {
        ekHizmetMaliyeti = 25000.0; // Yem karma + aydınlatma
      } else if (kullanimAmaci.contains('Sera')) {
        ekHizmetMaliyeti = 40000.0; // Havalandırma + ısıtma
      }

      // Elektrik hattı yoksa off-grid
      if (elektrikHatti.contains('Hayır')) {
        akuMaliyeti = 110000.0; // 10kWh Lityum
        zorlukCarpani = 1.30;
      }

      kuleMaliyeti = 45000.0; // 20m kule
      temelMaliyeti = 25000.0;
      montajMaliyeti = 20000.0;
    }

    // ==========================================
    // 5) TÜRBİN BAKIMI
    // ==========================================
    else if (isTuru == "Türbin Bakımı") {
      final String turbinTipi = findValue('turbin_tipi_bakim', 'Yatay Eksenli Türbin');
      final String sonBakim = findValue('son_bakim_tarihi', '1 Yıldan Uzun Süredir Yapılmadı');

      tabanFiyat = 8500.0; // Periyodik bakım - küçük türbin

      if (turbinTipi.contains('Dikey')) zorlukCarpani = 1.30; // Erişim zor

      // Uzun süre bakımsız
      if (sonBakim.contains('1 Yıldan Uzun') || sonBakim.contains('İlk Defa')) {
        ekHizmetMaliyeti = 12000.0; // Kapsamlı bakım + yağ
      }
    }

    // ==========================================
    // 6) TÜRBİN ARIZA TESPİTİ
    // ==========================================
    else if (isTuru == "Türbin Arıza Tespiti") {
      final String arizaTuru = findValue('ariza_turu', 'Düşük Enerji Üretiyor');

      tabanFiyat = 6500.0; // Arıza tespit + rapor

      if (arizaTuru.contains('Dönmüyor')) ekHizmetMaliyeti = 15000.0; // Rulman/şanzıman
      else if (arizaTuru.contains('Jeneratör')) ekHizmetMaliyeti = 25000.0; // Jeneratör sarım
      else if (arizaTuru.contains('Kontrol Ünitesi')) ekHizmetMaliyeti = 18000.0; // Kart değişim
      else if (arizaTuru.contains('Titreşim')) ekHizmetMaliyeti = 12000.0; // Balans
    }

    // ==========================================
    // 7) TÜRBİN SÖKÜM VE TAŞIMA
    // ==========================================
    else if (isTuru == "Türbin Söküm ve Taşıma") {
      final String turbinTipi = findValue('turbin_tipi_sokum', 'Küçük Ev Tipi Türbin');
      final String vincIhtiyaci = findValue('vinc_ihtiyaci', 'Hayır');

      if (turbinTipi.contains('Küçük Ev')) {
        tabanFiyat = 15000.0; // Vinç + işçilik
      } else if (turbinTipi.contains('Tarımsal')) {
        tabanFiyat = 35000.0;
      } else if (turbinTipi.contains('Ticari')) {
        tabanFiyat = 120000.0;
      } else { // Endüstriyel
        tabanFiyat = 500000.0; // Vinç + nakliye + vinç
      }

      if (vincIhtiyaci.contains('Evet')) ekHizmetMaliyeti = 25000.0;
    }

    // ==========================================
    // 8) JENERATÖR VE KONTROL ÜNİTESİ SERVİSİ
    // ==========================================
    else if (isTuru == "Jeneratör ve Kontrol Ünitesi Servisi") {
      final String servisEkipman = findValue('servis_ekipman', 'Jeneratör');

      tabanFiyat = 5000.0; // Servis geliş

      if (servisEkipman.contains('Jeneratör')) ekHizmetMaliyeti = 20000.0; // Sarım/bakım
      if (servisEkipman.contains('İnverter')) ekHizmetMaliyeti += 15000.0;
      if (servisEkipman.contains('Şarj Kontrol')) ekHizmetMaliyeti += 8000.0;
      if (servisEkipman.contains('Akü')) ekHizmetMaliyeti += 10000.0; // Test + dengeleme
      if (servisEkipman.contains('Fren')) ekHizmetMaliyeti += 12000.0;
    }

    // ==========================================
    // 9) DİREK VE KULE MONTAJI
    // ==========================================
    else if (isTuru == "Direk ve Kule Montajı") {
      final String montajTipi = findValue('montaj_tipi', 'Yeni Kule Montajı');
      final String kuleYuksekligi = findValue('kule_yuksekligi_montaj', '10 - 20 Metre');

      if (montajTipi.contains('Yeni Kule')) {
        tabanFiyat = 60000.0; // 15m kule + temel
        if (kuleYuksekligi.contains('20 - 30')) tabanFiyat = 85000.0;
        else if (kuleYuksekligi.contains('30 Metre')) tabanFiyat = 120000.0;
      } else if (montajTipi.contains('Mevcut Kule Değişimi')) {
        tabanFiyat = 45000.0;
        ekHizmetMaliyeti = 20000.0; // Söküm
      } else if (montajTipi.contains('Güçlendirme')) {
        tabanFiyat = 35000.0;
      } else { // Direk Değişimi
        tabanFiyat = 25000.0;
      }
    }

    // ==========================================
    // 10) RES DANIŞMANLIK HİZMETLERİ
    // ==========================================
    else if (isTuru == "RES Danışmanlık Hizmetleri") {
      final String danismanlikKonusu = findValue('danismanlik_konusu', 'Sistem Tasarımı');

      tabanFiyat = 25000.0; // Ön fizibilite

      if (danismanlikKonusu.contains('Yer Seçimi')) projeMaliyeti = 40000.0;
      if (danismanlikKonusu.contains('Rüzgar Ölçümü')) projeMaliyeti += 75000.0; // 1 yıllık ölçüm
      if (danismanlikKonusu.contains('Projelendirme')) projeMaliyeti += 50000.0;
      if (danismanlikKonusu.contains('Resmi Süreç')) projeMaliyeti += 35000.0;
      if (danismanlikKonusu.contains('Teşvik')) projeMaliyeti += 20000.0;
    }

    // TOPLAM HESAP
    double toplamFiyat = (tabanFiyat + turbinMaliyeti + kuleMaliyeti + temelMaliyeti + inverterMaliyeti + akuMaliyeti + montajMaliyeti + ekHizmetMaliyeti + projeMaliyeti) * zorlukCarpani;

    // Asgari baraj - 2026
    double asgariBaraj = 10000.0; // En düşük servis
    if (isTuru.contains('Kurulumu') && isTuru.contains('Türbini')) asgariBaraj = 38000.0; // 2kW en düşük
    if (isTuru.contains('Tarımsal')) asgariBaraj = 120000.0;
    if (isTuru.contains('Rüzgar Türbini Kurulumu') && sistemGucuKw >= 30) asgariBaraj = 300000.0;
    if (isTuru.contains('Rüzgar Türbini Kurulumu') && sistemGucuKw >= 1000) asgariBaraj = 25000000.0; // 1MW

    double nihaiSonuc = toplamFiyat < asgariBaraj? asgariBaraj : toplamFiyat;

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananSistemGucuKw": sistemGucuKw,
      "tabanFiyat": tabanFiyat,
      "turbinMaliyeti": turbinMaliyeti,
      "kuleMaliyeti": kuleMaliyeti,
      "temelMaliyeti": temelMaliyeti,
      "inverterMaliyeti": inverterMaliyeti,
      "akuMaliyeti": akuMaliyeti,
      "montajMaliyeti": montajMaliyeti,
      "ekHizmetMaliyeti": ekHizmetMaliyeti,
      "projeMaliyeti": projeMaliyeti,
      "zorlukCarpani": zorlukCarpani,
      "durum": "BAŞARILI"
    };
  }
}