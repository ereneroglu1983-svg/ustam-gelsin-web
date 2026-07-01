// lib/core/calculation/meslekler/hesap_enerji_depolama.dart

class EnerjiDepolamaHesaplayici {

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

    final String isTuru = findValue('is_turu', 'Solar Akü Sistemi Kurulumu');

    double tabanFiyat = 0.0;
    double cihazMaliyeti = 0.0;
    double akuMaliyeti = 0.0;
    double tesisatMaliyeti = 0.0;
    double projeHizmetMaliyeti = 0.0;
    double zorlukEkstra = 0.0;
    double mekanCarpani = 1.0;
    double nihaiKapasiteKwh = 5.0;

    // ==========================================
    // 1) SOLAR AKÜ SİSTEMİ KURULUMU
    // ==========================================
    if (isTuru == "Solar Akü Sistemi Kurulumu") {
      final String kullanimYeri = findValue('kullanim_yeri', 'Konut (Ev / Villa)');
      final String enerjiIhtiyaci = findValue('gunluk_enerji_ihtiyaci', 'Orta (Buzdolabı + elektronikler)');
      final String mevcutSistem = findValue('mevcut_sistem', 'Yeni kurulum yapılacak');
      final String akuTipi = findValue('aku_tipi', 'Lityum Akü');

      // Günlük ihtiyaç kWh - 2026 TR ortalamalar
      if (enerjiIhtiyaci.contains('Düşük')) nihaiKapasiteKwh = 3.0;
      else if (enerjiIhtiyaci.contains('Orta')) nihaiKapasiteKwh = 6.0;
      else if (enerjiIhtiyaci.contains('Yüksek')) nihaiKapasiteKwh = 12.0;
      else nihaiKapasiteKwh = 6.0;

      tabanFiyat = 15000.0; // Keşif + proje

      // Akü Tipi Maliyeti - 2026 TR【339530508077777751†L91-L92】【4557350308106645754†L9-L11】
      if (akuTipi.contains('Jel')) {
        // 200Ah Jel = 2.4kWh = 10-15k TL
        akuMaliyeti = (nihaiKapasiteKwh / 2.4) * 12500.0;
      } else if (akuTipi.contains('AGM')) {
        akuMaliyeti = (nihaiKapasiteKwh / 2.4) * 11000.0;
      } else if (akuTipi.contains('Lityum')) {
        // 100Ah 12.8V = 1.28kWh = 28-38k TL
        akuMaliyeti = (nihaiKapasiteKwh / 1.28) * 33000.0;
        zorlukEkstra += 5000.0; // BMS zorunlu
      } else { // Ustanın belirlemesi
        akuMaliyeti = (nihaiKapasiteKwh / 1.28) * 33000.0; // Lityum baz al
        zorlukEkstra += 5000.0;
      }

      // Mevcut sistem
      if (mevcutSistem.contains('Güneş paneli var')) {
        tesisatMaliyeti = 8000.0; // Sadece akü bağlantı
      } else if (mevcutSistem.contains('Yeni kurulum')) {
        tesisatMaliyeti = 25000.0; // Panel + inverter + tesisat
        cihazMaliyeti = 35000.0; // 5kW inverter ort
      } else { // Hibrit dönüşüm
        tesisatMaliyeti = 15000.0;
        cihazMaliyeti = 20000.0;
      }

      // Mekan çarpanı
      if (kullanimYeri.contains('Çiftlik') || kullanimYeri.contains('Off-grid')) mekanCarpani = 1.50;
      else if (kullanimYeri.contains('Yazlık')) mekanCarpani = 1.25;
      else if (kullanimYeri.contains('Karavan')) mekanCarpani = 1.40;
      else if (kullanimYeri.contains('İşletme')) mekanCarpani = 1.35;
    }

    // ==========================================
    // 2) LİTYUM AKÜ SİSTEMİ KURULUMU
    // ==========================================
    else if (isTuru == "Lityum Akü Sistemi Kurulumu") {
      final String kullanimAmaci = findValue('kullanim_amaci_lityum', 'Ev sistemi');
      final String sistemVoltaj = findValue('sistem_voltaj', '48V');

      tabanFiyat = 20000.0; // Mühendislik

      // Voltaj bazlı sistem - PowerEnerji 2026
      if (sistemVoltaj.contains('12V')) {
        nihaiKapasiteKwh = 5.0;
        akuMaliyeti = 33000.0 * 4; // 4x 100Ah 12V = 5.12kWh
      } else if (sistemVoltaj.contains('24V')) {
        nihaiKapasiteKwh = 7.5;
        akuMaliyeti = 33000.0 * 6;
      } else if (sistemVoltaj.contains('48V')) {
        nihaiKapasiteKwh = 10.0;
        akuMaliyeti = 320000.0; // 10kWh ev tipi paket【4557350308106645754†L9-L10】
      } else { // Bilmiyorum
        nihaiKapasiteKwh = 7.5;
        akuMaliyeti = 198000.0;
      }

      // Kullanım amacı
      if (kullanimAmaci.contains('Endüstriyel')) mekanCarpani = 1.80;
      else if (kullanimAmaci.contains('UPS')) mekanCarpani = 1.40;
      else if (kullanimAmaci.contains('Off-grid')) mekanCarpani = 1.60;

      tesisatMaliyeti = 15000.0;
      zorlukEkstra = 9900.0; // BMS dahil【7045251278839454065†L112-L113】
    }

    // ==========================================
    // 3) AKÜ DEĞİŞİMİ
    // ==========================================
    else if (isTuru == "Akü Değişimi") {
      final String sistemTipi = findValue('mevcut_sistem_tipi', 'Solar sistem');
      final String sorunDurumu = findValue('sorun_durumu', 'Şarj tutmuyor');

      tabanFiyat = 3000.0; // Servis geliş
      // Varsayılan 48V 100Ah Lityum değişim
      akuMaliyeti = 33000.0; // Tek akü【4557350308106645754†L9-L11】

      if (sorunDurumu.contains('Tamamen')) zorlukEkstra = 5000.0; // Sök-tak zorluk
      if (sorunDurumu.contains('Isınma')) zorlukEkstra = 8000.0; // BMS kontrol
      tesisatMaliyeti = 2000.0; // Bağlantı kontrol

      if (sistemTipi.contains('UPS') || sistemTipi.contains('Hibrit')) mekanCarpani = 1.20;
    }

    // ==========================================
    // 4) AKÜ BAKIM VE TEST HİZMETİ
    // ==========================================
    else if (isTuru == "Akü Bakım ve Test Hizmeti") {
      final String testNedeni = findValue('test_nedeni', 'Periyodik bakım');

      tabanFiyat = 2500.0;
      if (testNedeni.contains('Periyodik')) cihazMaliyeti = 1500.0;
      else if (testNedeni.contains('Performans')) cihazMaliyeti = 4000.0; // Yük testi
      else if (testNedeni.contains('Arıza')) cihazMaliyeti = 6000.0; // Detaylı analiz
      else cihazMaliyeti = 3000.0;
    }

    // ==========================================
    // 5) ENERJİ DEPOLAMA ÜNİTESİ KURULUMU
    // ==========================================
    else if (isTuru == "Enerji Depolama Ünitesi Kurulumu") {
      final String sistemTipi = findValue('sistem_tipi', 'Ev tipi');

      tabanFiyat = 30000.0;
      if (sistemTipi.contains('Ev')) {
        nihaiKapasiteKwh = 10.0;
        akuMaliyeti = 320000.0; // 14.6k-320k aralığı【4557350308106645754†L9-L10】
        mekanCarpani = 1.20;
      } else if (sistemTipi.contains('Ticari')) {
        nihaiKapasiteKwh = 50.0;
        akuMaliyeti = 900000.0; // Ticari 50kWh
        mekanCarpani = 1.60;
      } else if (sistemTipi.contains('Endüstriyel')) {
        nihaiKapasiteKwh = 200.0;
        akuMaliyeti = 2200000.0; // 240kW DC baz【7467951832880309440†L47-L48】
        mekanCarpani = 2.20;
      } else { // Tarımsal
        nihaiKapasiteKwh = 30.0;
        akuMaliyeti = 600000.0;
        mekanCarpani = 1.50;
      }
      tesisatMaliyeti = nihaiKapasiteKwh * 3000.0; // kWh başı 3k
      projeHizmetMaliyeti = 25000.0;
    }

    // ==========================================
    // 6) BMS KURULUMU
    // ==========================================
    else if (isTuru == "BMS (Batarya Yönetim Sistemi) Kurulumu") {
      final String bataryaTipi = findValue('batarya_tipi_bms', 'Lityum');

      tabanFiyat = 2000.0; // İşçilik
      // BMS Fiyatları Setapower 2026
      if (bataryaTipi.contains('Lityum')) {
        cihazMaliyeti = 9900.0; // 48V 100A BMS【7045251278839454065†L112-L113】
      } else {
        cihazMaliyeti = 3050.0; // 12V basit BMS【7045251278839454065†L144-L145】
      }
      tesisatMaliyeti = 1500.0; // Kablo + montaj
    }

    // ==========================================
    // 7) UPS SİSTEMLERİ KURULUMU
    // ==========================================
    else if (isTuru == "UPS Sistemleri Kurulumu") {
      final String kullanimAlani = findValue('kullanim_alani_ups', 'Ofis');

      tabanFiyat = 5000.0;
      if (kullanimAlani.contains('Ev')) {
        cihazMaliyeti = 8000.0; // 1KVA Line-interactive
        mekanCarpani = 1.0;
      } else if (kullanimAlani.contains('Ofis')) {
        cihazMaliyeti = 25000.0; // 3KVA Online
        mekanCarpani = 1.20;
      } else if (kullanimAlani.contains('Server')) {
        cihazMaliyeti = 65000.0; // 10KVA
        mekanCarpani = 1.50;
      } else if (kullanimAlani.contains('Hastane')) {
        cihazMaliyeti = 180000.0; // 30KVA
        mekanCarpani = 1.80;
      } else { // Endüstriyel
        cihazMaliyeti = 350000.0; // 60KVA+
        mekanCarpani = 2.00;
      }
      tesisatMaliyeti = 5000.0;
    }

    // ==========================================
    // 8) OFF-GRID ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    else if (isTuru == "Off-Grid Enerji Sistemi Kurulumu") {
      final String sebekeDurumu = findValue('sebeke_durumu', 'Hiç yok');

      tabanFiyat = 40000.0; // Proje + keşif
      // 5kWp + 10kWh Lityum baz - Piagrid 2026
      cihazMaliyeti = 190000.0; // 5kWp: 150-230k【6268463505036093951†L9-L10】
      akuMaliyeti = 320000.0; // 10kWh Lityum【4557350308106645754†L9-L10】
      tesisatMaliyeti = 40000.0;

      if (sebekeDurumu.contains('Hiç yok')) mekanCarpani = 1.70; // Zor arazi
      else if (sebekeDurumu.contains('Zayıf')) mekanCarpani = 1.40;
      else mekanCarpani = 1.50;
    }

    // ==========================================
    // 9) HİBRİT ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    else if (isTuru == "Hibrit Enerji Sistemi Kurulumu") {
      final String enerjiKaynaklari = findValue('enerji_kaynaklari', 'Güneş + Şebeke + Akü');

      tabanFiyat = 35000.0;
      // 10kWp Hibrit + 10kWh
      cihazMaliyeti = 330000.0; // 10kWp: 280-380k【6268463505036093951†L9-L10】
      akuMaliyeti = 320000.0;

      if (enerjiKaynaklari.contains('Jeneratör')) {
        zorlukEkstra = 45000.0; // Jeneratör entegrasyon
        mekanCarpani = 1.60;
      } else if (enerjiKaynaklari.contains('Güneş + Şebeke + Akü')) {
        mekanCarpani = 1.40;
      } else {
        mekanCarpani = 1.30;
      }
      tesisatMaliyeti = 30000.0;
    }

    // ==========================================
    // 10) YEDEK GÜÇ SİSTEMİ KURULUMU
    // ==========================================
    else if (isTuru == "Yedek Güç Sistemi Kurulumu") {
      final String yedeklemeAmaci = findValue('yedekleme_amaci', 'Kritik cihazlar');

      tabanFiyat = 15000.0;
      if (yedeklemeAmaci.contains('Kritik')) {
        nihaiKapasiteKwh = 5.0;
        akuMaliyeti = 160000.0; // 5kWh Lityum
        mekanCarpani = 1.30;
      } else if (yedeklemeAmaci.contains('Tüm ev')) {
        nihaiKapasiteKwh = 10.0;
        akuMaliyeti = 320000.0;
        mekanCarpani = 1.50;
      } else if (yedeklemeAmaci.contains('İşletme')) {
        nihaiKapasiteKwh = 30.0;
        akuMaliyeti = 600000.0;
        mekanCarpani = 1.80;
      } else { // Elektrik kesintisi koruması
        nihaiKapasiteKwh = 3.0;
        akuMaliyeti = 96000.0;
        mekanCarpani = 1.10;
      }
      cihazMaliyeti = 25000.0; // İnverter
      tesisatMaliyeti = 10000.0;
    }

    // TOPLAM HESAP
    double toplamFiyat = (tabanFiyat + cihazMaliyeti + akuMaliyeti + tesisatMaliyeti + projeHizmetMaliyeti + zorlukEkstra) * mekanCarpani;

    // Asgari baraj - 2026
    double asgariBaraj = 25000.0; // Solar akü en düşük
    if (isTuru.contains('Lityum') || isTuru.contains('Enerji Depolama Ünitesi')) asgariBaraj = 50000.0;
    if (isTuru.contains('UPS') || isTuru.contains('BMS')) asgariBaraj = 5000.0;
    if (isTuru.contains('Bakım')) asgariBaraj = 2500.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj? asgariBaraj : toplamFiyat;

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananKapasiteKwh": nihaiKapasiteKwh,
      "tabanFiyat": tabanFiyat,
      "cihazMaliyeti": cihazMaliyeti,
      "akuMaliyeti": akuMaliyeti,
      "tesisatMaliyeti": tesisatMaliyeti,
      "projeHizmetMaliyeti": projeHizmetMaliyeti,
      "zorlukEkstra": zorlukEkstra,
      "mekanCarpani": mekanCarpani,
      "durum": "BAŞARILI"
    };
  }
}