// lib/core/calculation/meslekler/hesap_off_grid_mobil_enerji.dart

class OffGridMobilEnerjiHesaplayici {

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

    final String isTuru = findValue('is_turu', 'Karavan Güneş Enerji Sistemi Kurulumu');

    double tabanFiyat = 0.0;
    double panelMaliyeti = 0.0;
    double akuMaliyeti = 0.0;
    double inverterMaliyeti = 0.0;
    double konstruksiyonMaliyeti = 0.0;
    double tesisatMaliyeti = 0.0;
    double iscilikMaliyeti = 0.0;
    double ekHizmetMaliyeti = 0.0;
    double zorlukCarpani = 1.0;
    double hesaplananSistemGucuW = 0.0;

    // ==========================================
    // 1) KARAVAN GÜNEŞ ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    if (isTuru == "Karavan Güneş Enerji Sistemi Kurulumu") {
      final String karavanTipi = findValue('karavan_tipi', 'Motokaravan');
      final String karavanUzunlugu = findValue('karavan_uzunlugu', '4 - 6 Metre');
      final String tuketim = findValue('gunluk_enerji_tuketim', 'Orta (Buzdolabı, TV, Küçük Cihazlar)');
      final List<String> cihazlar = findMultiValue('kullanilacak_cihazlar');
      final String akuTercihi = findValue('aku_tercihi_karavan', 'Lityum Akü');
      final String kullanimSuresi = findValue('karavan_kullanim_suresi', 'Mevsimsel');

      // Tüketim bazlı sistem - PowerEnerji 2026
      if (tuketim.contains('Düşük')) {
        hesaplananSistemGucuW = 410;
        tabanFiyat = 56500.0; // Başlangıç Seti 35-78k ort
      } else if (tuketim.contains('Orta')) {
        hesaplananSistemGucuW = 615;
        tabanFiyat = 65000.0; // Popüler Set 45-85k ort
      } else if (tuketim.contains('Yüksek')) {
        hesaplananSistemGucuW = 1200;
        tabanFiyat = 110000.0; // Lüks Konfor Seti 70-150k+ ort
      } else { // Bilmiyorum
        hesaplananSistemGucuW = 615;
        tabanFiyat = 65000.0;
      }

      // Cihaz bazlı ek güç
      if (cihazlar.contains('Klima')) ekHizmetMaliyeti += 15000.0;
      if (cihazlar.contains('Kahve Makinesi')) ekHizmetMaliyeti += 5000.0;
      if (cihazlar.contains('Su Pompası')) ekHizmetMaliyeti += 3000.0;

      // Akü tercihi - Munda Solar 2026
      if (akuTercihi.contains('Jel')) {
        akuMaliyeti = 25000.0; // 200Ah Jel x2
        zorlukCarpani = 1.05; // Ağır
      } else if (akuTercihi.contains('AGM')) {
        akuMaliyeti = 22000.0;
        zorlukCarpani = 1.05;
      } else if (akuTercihi.contains('Lityum')) {
        akuMaliyeti = 55000.0; // 100Ah Lityum x2
      } else { // Ustanın Önerisi
        akuMaliyeti = 55000.0; // Lityum baz al
      }

      // Karavan tipi/uzunluk - alan kısıtı
      if (karavanTipi.contains('Tiny Camper') || karavanUzunlugu.contains('0 - 4')) {
        zorlukCarpani *= 1.20; // Küçük alan montaj zorluğu
      }
      if (karavanTipi.contains('Motokaravan') || karavanTipi.contains('Camper Van')) {
        konstruksiyonMaliyeti = 8000.0; // Tavan güçlendirme
      }

      // Kullanım süresi - akü kapasitesi
      if (kullanimSuresi.contains('Yıl Boyu') || kullanimSuresi.contains('Sürekli')) {
        akuMaliyeti *= 1.5; // Yedek kapasite
        zorlukCarpani *= 1.15;
      }

      inverterMaliyeti = 15000.0; // 2kW Tam Sinüs MPPT
      tesisatMaliyeti = 8000.0;
      iscilikMaliyeti = 12000.0;
    }

    // ==========================================
    // 2) TINY HOUSE GÜNEŞ ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    else if (isTuru == "Tiny House Güneş Enerji Sistemi Kurulumu") {
      final String kullanim = findValue('tiny_house_kullanim', 'Sürekli Yaşam');
      final String yapiBuyuklugu = findValue('yapi_buyuklugu', '20 - 40 m²');
      final String sebekeVar = findValue('elektrik_sebekesi_mevcut', 'Hayır');
      final String sistemTipi = findValue('sistem_tipi_tiny', 'Tam Bağımsız (Off-Grid)');
      final String enerjiDepolama = findValue('enerji_depolama_isteniyor', 'Evet');
      final String kesif = findValue('yerinde_kesif_tiny', 'Evet');

      // Yapı büyüklüğü bazlı - PowerEnerji 2026
      if (yapiBuyuklugu.contains('0 - 20')) {
        hesaplananSistemGucuW = 1500;
        tabanFiyat = 130000.0; // 1.5 kW Güçlü Paket
      } else if (yapiBuyuklugu.contains('20 - 40')) {
        hesaplananSistemGucuW = 2000;
        tabanFiyat = 150000.0; // 2 kW Profesyonel Paket
      } else if (yapiBuyuklugu.contains('40 - 60')) {
        hesaplananSistemGucuW = 3000;
        tabanFiyat = 180000.0; // Tahmini 3kW
      } else {
        hesaplananSistemGucuW = 4000;
        tabanFiyat = 220000.0; // Tahmini 4kW
      }

      // Sistem tipi
      if (sistemTipi.contains('Tam Bağımsız')) {
        akuMaliyeti = 110000.0; // 10kWh Lityum
        inverterMaliyeti = 45000.0; // 5kW Hibrit
        zorlukCarpani = 1.25;
      } else if (sistemTipi.contains('Hibrit')) {
        akuMaliyeti = 55000.0; // 5kWh
        inverterMaliyeti = 45000.0;
        zorlukCarpani = 1.15;
      }

      // Enerji depolama
      if (enerjiDepolama.contains('Evet') &&!sistemTipi.contains('Tam Bağımsız')) {
        akuMaliyeti = 55000.0;
      }

      // Şebeke yoksa ekstra
      if (sebekeVar.contains('Hayır')) zorlukCarpani *= 1.20;
      if (kullanim.contains('Sürekli')) akuMaliyeti *= 1.3; // Yedek kapasite
      if (kesif.contains('Evet')) ekHizmetMaliyeti = 5000.0;

      tesisatMaliyeti = 15000.0;
      iscilikMaliyeti = 20000.0;
    }

    // ==========================================
    // 3) BAĞ EVİ GÜNEŞ ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    else if (isTuru == "Bağ Evi Güneş Enerji Sistemi Kurulumu") {
      final String kullanim = findValue('bag_evi_kullanim', 'Hafta Sonları');
      final String elektrikHatti = findValue('elektrik_hatti_bag', 'Hayır');
      final List<String> enerjiAmaci = findMultiValue('enerji_kullanim_amaci');
      final String tuketim = findValue('tahmini_gunluk_tuketim', 'Orta');
      final String jenerator = findValue('jenerator_destegi', 'Hayır');

      // PowerEnerji 2026 - Bağ Evi Paketleri
      if (kullanim.contains('Hafta Sonları') || kullanim.contains('Nadiren')) {
        tabanFiyat = 65000.0; // Ekonomik Bağ Evi Paketi
        hesaplananSistemGucuW = 1000;
      } else if (kullanim.contains('Yaz Dönemi')) {
        tabanFiyat = 130000.0; // 1.5 kW Güçlü Paket
        hesaplananSistemGucuW = 1500;
      } else { // Tüm Yıl
        tabanFiyat = 158000.0; // Bir Eve Yetecek Paket
        hesaplananSistemGucuW = 2000;
        zorlukCarpani = 1.25;
      }

      // Tüketim
      if (tuketim.contains('Yüksek')) tabanFiyat *= 1.4;
      else if (tuketim.contains('Düşük')) tabanFiyat *= 0.8;

      // Cihaz bazlı ek
      if (enerjiAmaci.contains('Sulama Sistemi')) ekHizmetMaliyeti += 25000.0;
      if (enerjiAmaci.contains('Su Pompası')) ekHizmetMaliyeti += 15000.0;
      if (enerjiAmaci.contains('Klima')) ekHizmetMaliyeti += 20000.0;
      if (enerjiAmaci.contains('Güvenlik Sistemi')) ekHizmetMaliyeti += 8000.0;

      // Elektrik hattı yoksa off-grid
      if (elektrikHatti.contains('Hayır')) {
        akuMaliyeti = 55000.0;
        inverterMaliyeti = 32000.0; // Hibrit
        zorlukCarpani *= 1.30;
      }

      // Jeneratör
      if (jenerator.contains('Evet')) ekHizmetMaliyeti += 35000.0;

      konstruksiyonMaliyeti = 12000.0;
      tesisatMaliyeti = 10000.0;
      iscilikMaliyeti = 15000.0;
    }

    // ==========================================
    // 4) YAYLA EVİ ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    else if (isTuru == "Yayla Evi Enerji Sistemi Kurulumu") {
      final String ulasim = findValue('yayla_ulasim', 'Zor Ulaşılabilir');
      final String kullanimSekli = findValue('yayla_kullanim_sekli', 'Mevsimlik');
      final String iklim = findValue('iklim_kosullari', 'Sert Kış Şartları');
      final String beklenti = findValue('sistemden_beklenti', 'Temel Elektrik İhtiyacı');
      final String enerjiKaynagi = findValue('enerji_kaynagi_tercihi', 'Güneş Enerjisi');

      // Baz: 1.5 kW Güçlü Paket
      tabanFiyat = 130000.0;
      hesaplananSistemGucuW = 1500;

      // Beklenti
      if (beklenti.contains('Kesintisiz')) {
        tabanFiyat = 158000.0;
        hesaplananSistemGucuW = 2000;
        akuMaliyeti = 110000.0; // 10kWh
      } else if (beklenti.contains('Tam Bağımsız')) {
        tabanFiyat = 158000.0;
        hesaplananSistemGucuW = 2000;
        akuMaliyeti = 110000.0;
        zorlukCarpani = 1.35;
      }

      // Enerji kaynağı
      if (enerjiKaynagi.contains('Rüzgar')) ekHizmetMaliyeti += 45000.0; // Rüzgar türbini
      if (enerjiKaynagi.contains('Jeneratör')) ekHizmetMaliyeti += 35000.0;

      // İklim koşulları
      if (iklim.contains('Sert') || iklim.contains('Kar')) {
        konstruksiyonMaliyeti = 25000.0; // Kar yükü güçlendirme
        zorlukCarpani *= 1.25;
      }
      if (iklim.contains('Rüzgarlı')) zorlukCarpani *= 1.15;

      // Ulaşım
      if (ulasim.contains('Zor')) {
        ekHizmetMaliyeti += 20000.0; // Nakliye + konaklama
        zorlukCarpani *= 1.40;
      } else if (ulasim.contains('Arazi Aracı')) {
        ekHizmetMaliyeti += 35000.0;
        zorlukCarpani *= 1.60;
      }

      inverterMaliyeti = 32000.0;
      tesisatMaliyeti = 15000.0;
      iscilikMaliyeti = 20000.0;
    }

    // ==========================================
    // 5) TEKNE VE YAT SOLAR SİSTEMİ KURULUMU
    // ==========================================
    else if (isTuru == "Tekne ve Yat Solar Sistemi Kurulumu") {
      final String aracTipi = findValue('arac_tipi_tekne', 'Motor Yat');
      final String tekneBoyu = findValue('tekne_boyu', '8 - 15 Metre');
      final List<String> kullanimAmaci = findMultiValue('kullanim_amaci_tekne');
      final String denizdeKalis = findValue('denizde_kalis_suresi', 'Birkaç Gün');
      final String akuSistemi = findValue('aku_sistemi_mevcut', 'Hayır');

      // Marin sistem - esnek panel + MPPT
      if (tekneBoyu.contains('0 - 8')) {
        hesaplananSistemGucuW = 400;
        tabanFiyat = 48000.0; // Ekonomik Karavan baz
      } else if (tekneBoyu.contains('8 - 15')) {
        hesaplananSistemGucuW = 800;
        tabanFiyat = 85000.0; // Standart Karavan baz + marin
      } else if (tekneBoyu.contains('15 - 25')) {
        hesaplananSistemGucuW = 1200;
        tabanFiyat = 110000.0; // Lüks Konfor baz
      } else {
        hesaplananSistemGucuW = 1600;
        tabanFiyat = 150000.0;
      }

      // Marin ekipman farkı
      zorlukCarpani = 1.30; // IP67 + paslanmaz
      ekHizmetMaliyeti = 15000.0; // Marin montaj + kablo

      // Kullanım amacı ek
      if (kullanimAmaci.contains('Klima')) ekHizmetMaliyeti += 25000.0;
      if (kullanimAmaci.contains('Navigasyon')) ekHizmetMaliyeti += 8000.0;
      if (kullanimAmaci.contains('Buzdolabı')) ekHizmetMaliyeti += 5000.0;

      // Denizde kalış
      if (denizdeKalis.contains('Haftalarca') || denizdeKalis.contains('Uzun Süreli')) {
        akuMaliyeti = 110000.0; // 10kWh Lityum
        zorlukCarpani *= 1.20;
      } else if (akuSistemi.contains('Hayır')) {
        akuMaliyeti = 55000.0; // 5kWh
      }

      inverterMaliyeti = 25000.0; // Marin MPPT
    }

    // ==========================================
    // 6) MOBİL ENERJİ SİSTEMLERİ KURULUMU
    // ==========================================
    else if (isTuru == "Mobil Enerji Sistemleri Kurulumu") {
      final String kullanimYeri = findValue('mobil_kullanim_yeri', 'Karavan');
      final String tasinabilirlik = findValue('tasinabilirlik_onceligi', 'Çok Önemli');
      final String enerjiIhtiyaci = findValue('enerji_ihtiyaci_mobil', 'Orta');
      final String kullanimAmaci = findValue('sistemin_kullanim_amaci', 'Sürekli Kullanım');

      // PowerEnerji 2026 hazır paketler
      if (kullanimYeri.contains('Karavan')) {
        tabanFiyat = 65000.0; // Popüler Set
        hesaplananSistemGucuW = 615;
      } else if (kullanimYeri.contains('Tiny House')) {
        tabanFiyat = 150000.0; // 2 kW Profesyonel
        hesaplananSistemGucuW = 2000;
      } else if (kullanimYeri.contains('Şantiye') || kullanimYeri.contains('Tarımsal')) {
        tabanFiyat = 130000.0; // 1.5 kW Güçlü
        hesaplananSistemGucuW = 1500;
        zorlukCarpani = 1.20;
      } else if (kullanimYeri.contains('Etkinlik')) {
        tabanFiyat = 158000.0; // Bir Eve Yetecek
        hesaplananSistemGucuW = 2000;
      } else { // Mobil Ofis
        tabanFiyat = 130000.0;
        hesaplananSistemGucuW = 1500;
      }

      // Taşınabilirlik
      if (tasinabilirlik.contains('Çok Önemli')) {
        konstruksiyonMaliyeti = 15000.0; // Katlanabilir panel
        zorlukCarpani *= 1.15;
      }

      // Enerji ihtiyacı
      if (enerjiIhtiyaci.contains('Yüksek')) tabanFiyat *= 1.4;
      else if (enerjiIhtiyaci.contains('Düşük')) tabanFiyat *= 0.7;

      // Kullanım amacı
      if (kullanimAmaci.contains('Ticari')) zorlukCarpani *= 1.25;
    }

    // ==========================================
    // 7) OFF-GRID SİSTEM BAKIM VE ONARIMI
    // ==========================================
    else if (isTuru == "Off-Grid Sistem Bakım ve Onarımı") {
      final List<String> sorunTipi = findMultiValue('sorun_tipi_offgrid');
      final String sistemYasi = findValue('sistem_yasi', '2 - 5 Yıl');
      final String sorunSuresi = findValue('sorun_suresi', 'Son 1 Hafta');
      final String acilServis = findValue('acil_servis', 'Hayır');

      tabanFiyat = 4500.0; // Servis geliş + tespit

      // Sorun tipleri
      if (sorunTipi.contains('Enerji Üretmiyor')) ekHizmetMaliyeti += 8000.0;
      if (sorunTipi.contains('Aküler Şarj Olmuyor')) ekHizmetMaliyeti += 12000.0;
      if (sorunTipi.contains('İnverter Çalışmıyor')) ekHizmetMaliyeti += 15000.0;
      if (sorunTipi.contains('Düşük Performans')) ekHizmetMaliyeti += 5000.0;
      if (sorunTipi.contains('Sistem Sık Sık Kapanıyor')) ekHizmetMaliyeti += 6000.0;
      if (sorunTipi.contains('Hata Kodu')) ekHizmetMaliyeti += 4000.0;

      // Sistem yaşı
      if (sistemYasi.contains('5 - 10')) zorlukCarpani = 1.25;
      else if (sistemYasi.contains('10 Yıl')) zorlukCarpani = 1.50;

      // Acil servis
      if (acilServis.contains('Evet')) ekHizmetMaliyeti += 5000.0;
    }

    // ==========================================
    // 8) AKÜ VE İNVERTER ENTEGRASYONU
    // ==========================================
    else if (isTuru == "Akü ve İnverter Entegrasyonu") {
      final String mevcutEkipman = findValue('mevcut_ekipman', 'Yeni Sistem Kurulacak');
      final String akuTipi = findValue('aku_tipi_entegrasyon', 'Lityum');
      final String inverterTipi = findValue('inverter_tipi', 'Hibrit İnverter');
      final String sistemAmaci = findValue('sistem_amaci_entegrasyon', 'Off-Grid Kullanım');
      final String uzaktanIzleme = findValue('uzaktan_izleme', 'Evet');

      tabanFiyat = 5000.0; // Entegrasyon işçilik

      // Mevcut ekipman
      if (mevcutEkipman.contains('Sadece Akü')) {
        inverterMaliyeti = 32000.0; // 5kW MPPT Akıllı
      } else if (mevcutEkipman.contains('Sadece İnverter')) {
        akuMaliyeti = 55000.0; // 200Ah Lityum
      } else if (mevcutEkipman.contains('Her İkisi')) {
        ekHizmetMaliyeti = 8000.0; // BMS + kablo
      } else { // Yeni Sistem
        akuMaliyeti = 55000.0;
        inverterMaliyeti = 32000.0;
      }

      // Akü tipi
      if (akuTipi.contains('Jel')) akuMaliyeti = 25000.0;
      else if (akuTipi.contains('AGM')) akuMaliyeti = 22000.0;

      // İnverter tipi
      if (inverterTipi.contains('Tam Sinüs')) inverterMaliyeti *= 1.2;
      else if (inverterTipi.contains('Modifiye')) inverterMaliyeti *= 0.6;

      // Uzaktan izleme
      if (uzaktanIzleme.contains('Evet')) ekHizmetMaliyeti += 8000.0;

      tesisatMaliyeti = 10000.0;
    }

    // TOPLAM HESAP
    double toplamFiyat = (tabanFiyat + panelMaliyeti + akuMaliyeti + inverterMaliyeti + konstruksiyonMaliyeti + tesisatMaliyeti + iscilikMaliyeti + ekHizmetMaliyeti) * zorlukCarpani;

    // Asgari baraj - 2026
    double asgariBaraj = 35000.0; // En düşük karavan seti
    if (isTuru.contains('Tiny House') || isTuru.contains('Bağ Evi')) asgariBaraj = 65000.0;
    if (isTuru.contains('Yayla')) asgariBaraj = 130000.0;
    if (isTuru.contains('Tekne')) asgariBaraj = 48000.0;
    if (isTuru.contains('Bakım') || isTuru.contains('Arıza')) asgariBaraj = 4500.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj? asgariBaraj : toplamFiyat;

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananSistemGucuW": hesaplananSistemGucuW,
      "tabanFiyat": tabanFiyat,
      "panelMaliyeti": panelMaliyeti,
      "akuMaliyeti": akuMaliyeti,
      "inverterMaliyeti": inverterMaliyeti,
      "konstruksiyonMaliyeti": konstruksiyonMaliyeti,
      "tesisatMaliyeti": tesisatMaliyeti,
      "iscilikMaliyeti": iscilikMaliyeti,
      "ekHizmetMaliyeti": ekHizmetMaliyeti,
      "zorlukCarpani": zorlukCarpani,
      "durum": "BAŞARILI"
    };
  }
}