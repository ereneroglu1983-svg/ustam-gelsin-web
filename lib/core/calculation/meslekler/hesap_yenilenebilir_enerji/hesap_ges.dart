// lib/core/calculation/meslekler/hesap_ges.dart

class GESHesaplayici {

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

    final String isTuru = findValue('is_turu', 'Güneş Paneli Kurulumu');

    double tabanFiyat = 0.0;
    double sistemGucuKw = 0.0;
    double panelMaliyeti = 0.0;
    double inverterMaliyeti = 0.0;
    double konstruksiyonMaliyeti = 0.0;
    double kabloTesisatMaliyeti = 0.0;
    double iscilikMaliyeti = 0.0;
    double ekHizmetMaliyeti = 0.0;
    double zorlukCarpani = 1.0;
    double projeMaliyeti = 0.0;

    // ==========================================
    // 1) GÜNEŞ PANELİ KURULUMU
    // ==========================================
    if (isTuru == "Güneş Paneli Kurulumu") {
      final String kurulumAlanTuru = findValue('kurulum_alan_turu', 'Konut Çatısı');
      final String sistemGucu = findValue('sistem_gucu', '5 - 10 kW Arası');
      final String elektrikAbonelik = findValue('elektrik_abonelik', 'Trifaze (Üç Faz)');
      final String yapiYuksekligi = findValue('yapi_yuksekligi', '2 Katlı Yapı');
      final String kurulumSekli = findValue('kurulum_sekli', 'Sıfırdan Komple Sistem Kurulacak');
      final String akuSistemi = findValue('aku_sistemi', 'Hayır, Şebeke Destekli Sistem İstiyorum');
      final String inverterTercihi = findValue('inverter_tercihi', 'Standart On-Grid İnverter');
      final String kesifIstegi = findValue('kesif_istegi', 'Evet Yerinde Keşif Yapılsın');
      final List<String> ekHizmetler = findMultiValue('ek_hizmetler');
      final String aracErisim = findValue('arac_erisim', 'Araç Doğrudan Alana Ulaşabiliyor');

      // Sistem gücü hesaplama
      if (sistemGucu.contains('3 kW\'a Kadar')) sistemGucuKw = 3.0;
      else if (sistemGucu.contains('3 - 5')) sistemGucuKw = 5.0;
      else if (sistemGucu.contains('5 - 10')) sistemGucuKw = 10.0;
      else if (sistemGucu.contains('10 - 25')) sistemGucuKw = 20.0;
      else if (sistemGucu.contains('25 - 50')) sistemGucuKw = 40.0;
      else if (sistemGucu.contains('50 kW ve Üzeri')) sistemGucuKw = 60.0;
      else sistemGucuKw = 10.0; // Uzman keşfi

      // 2026 TR Panel + İnverter + İşçilik - Enerjiseyir baz
      if (sistemGucuKw <= 3) tabanFiyat = 100000.0;
      else if (sistemGucuKw <= 5) tabanFiyat = 155000.0;
      else if (sistemGucuKw <= 7) tabanFiyat = 205000.0;
      else if (sistemGucuKw <= 10) tabanFiyat = 280000.0;
      else if (sistemGucuKw <= 15) tabanFiyat = 400000.0;
      else if (sistemGucuKw <= 20) tabanFiyat = 540000.0;
      else tabanFiyat = sistemGucuKw * 28000.0;

      // Kurulum alanı zorluğu
      if (kurulumAlanTuru.contains('Fabrika')) zorlukCarpani = 1.15;
      else if (kurulumAlanTuru.contains('Tarımsal') || kurulumAlanTuru.contains('Açık')) zorlukCarpani = 1.25;
      else if (kurulumAlanTuru.contains('Otopark')) zorlukCarpani = 1.35;

      // Yapı yüksekliği
      if (yapiYuksekligi.contains('3 - 5')) ekHizmetMaliyeti += 15000.0;
      else if (yapiYuksekligi.contains('5 Kat Üzeri')) ekHizmetMaliyeti += 35000.0;
      else if (yapiYuksekligi.contains('Arazi')) zorlukCarpani *= 1.20;

      // Kurulum şekli
      if (kurulumSekli.contains('İlave Panel')) {
        tabanFiyat *= 0.60; // Mevcut sistem var
      } else if (kurulumSekli.contains('Eski Sistem Yenilenecek')) {
        ekHizmetMaliyeti += 25000.0; // Söküm maliyeti
      }

      // Akü sistemi - Munda Solar 2026
      if (akuSistemi.contains('Akülü Sistem')) {
        ekHizmetMaliyeti += 165000.0; // 5kWh Lityum ort 165k
        zorlukCarpani *= 1.15;
      } else if (akuSistemi.contains('Hibrit')) {
        ekHizmetMaliyeti += 180000.0; // Hibrit inverter + akü
        zorlukCarpani *= 1.20;
      }

      // İnverter tercihi
      if (inverterTercihi.contains('Hibrit')) inverterMaliyeti = 45000.0;
      else if (inverterTercihi.contains('Off-Grid')) inverterMaliyeti = 55000.0;
      else if (inverterTercihi.contains('Mevcut')) inverterMaliyeti = 0.0;
      else inverterMaliyeti = 25000.0; // On-Grid standart

      // Abonelik tipi - Trifaze zorunluluğu 6kW+
      if (elektrikAbonelik.contains('Monofaze') && sistemGucuKw > 6) {
        ekHizmetMaliyeti += 35000.0; // Trifazeye geçiş
        zorlukCarpani *= 1.25;
      }

      // Keşif
      if (kesifIstegi.contains('Fotoğraf')) tabanFiyat -= 5000.0;

      // Ek hizmetler - multi
      if (ekHizmetler.contains('Projelendirme Hizmeti')) projeMaliyeti += 15000.0;
      if (ekHizmetler.contains('Resmi Başvuru İşlemleri')) projeMaliyeti += 10000.0;
      if (ekHizmetler.contains('TEDAŞ Süreç Desteği')) projeMaliyeti += 12000.0;
      if (ekHizmetler.contains('Çağrı Mektubu Danışmanlığı')) projeMaliyeti += 8000.0;
      if (ekHizmetler.contains('Teşvik / Hibe Danışmanlığı')) projeMaliyeti += 20000.0;
      if (ekHizmetler.contains('Panel Temizlik Hizmeti')) ekHizmetMaliyeti += 3000.0;
      if (ekHizmetler.contains('Periyodik Bakım Hizmeti')) ekHizmetMaliyeti += 5000.0;
      if (ekHizmetler.contains('Sigorta Danışmanlığı')) projeMaliyeti += 5000.0;

      // Araç erişim
      if (aracErisim.contains('Kısmi')) ekHizmetMaliyeti += 8000.0;
      else if (aracErisim.contains('Vinç')) ekHizmetMaliyeti += 25000.0;
    }

    // ==========================================
    // 2) ARAZİ GES KURULUMU
    // ==========================================
    else if (isTuru == "Arazi GES Kurulumu") {
      final String araziBuyuklugu = findValue('arazi_buyuklugu', '1.000 - 5.000 m²');
      final String zeminTipi = findValue('zemin_tipi', 'Toprak');
      final String elektrikHatti = findValue('elektrik_hatti', 'Evet, elektrik hattı mevcut');
      final String cevreCiti = findValue('cevre_citi', 'Evet');
      final String trafoIhtiyaci = findValue('trafo_ihtiyaci', 'Hayır');

      // Arazi büyüklüğüne göre kW - 1 dönüm ~100kW
      if (araziBuyuklugu.contains('0 - 500')) sistemGucuKw = 50.0;
      else if (araziBuyuklugu.contains('500 - 1.000')) sistemGucuKw = 100.0;
      else if (araziBuyuklugu.contains('1.000 - 5.000')) sistemGucuKw = 500.0;
      else if (araziBuyuklugu.contains('5.000 - 10.000')) sistemGucuKw = 1000.0;
      else sistemGucuKw = 2000.0;

      // 2026 Arazi GES - kW başı 25.5k TL
      if (sistemGucuKw <= 50) tabanFiyat = 2025000.0;
      else if (sistemGucuKw <= 100) tabanFiyat = 3150000.0;
      else if (sistemGucuKw <= 500) tabanFiyat = 12825000.0;
      else tabanFiyat = 22500000.0;

      // Zemin tipi
      if (zeminTipi.contains('Kayalık')) zorlukCarpani = 1.25;
      else if (zeminTipi.contains('Beton')) zorlukCarpani = 1.35;
      else if (zeminTipi.contains('Stabilize')) zorlukCarpani = 1.10;

      // Elektrik hattı
      if (elektrikHatti.contains('Hayır')) ekHizmetMaliyeti += 500000.0;
      else if (elektrikHatti.contains('Bilmiyorum')) ekHizmetMaliyeti += 100000.0;

      // Çevre çiti - 1000m² için ~180k
      if (cevreCiti.contains('Evet')) {
        double citiMetre = sistemGucuKw * 2; // kW başı 2m çit
        ekHizmetMaliyeti += citiMetre * 180.0;
      }

      // Trafo - 100kW+ için genelde gerekir
      if (trafoIhtiyaci.contains('Evet') || sistemGucuKw >= 100) ekHizmetMaliyeti += 850000.0;
      else if (trafoIhtiyaci.contains('Ustanın')) ekHizmetMaliyeti += 200000.0;
    }

    // ==========================================
    // 3) TARIMSAL SULAMA GES KURULUMU
    // ==========================================
    else if (isTuru == "Tarımsal Sulama GES Kurulumu") {
      final String sulamaYontemi = findValue('sulama_yontemi', 'Damlama Sulama');
      final String pompaGucu = findValue('pompa_gucu', '5 - 10 HP');
      final String kuyuDerinligi = findValue('kuyu_derinligi', '25 - 50 Metre');
      final String elektrikHatti = findValue('elektrik_hatti_sulama', 'Evet');
      final String kullanimSekli = findValue('kullanim_sekli', 'Sadece Yaz Sezonunda');

      // HP to kW: 1 HP = 0.746 kW
      if (pompaGucu.contains('1 - 5')) sistemGucuKw = 7.5;
      else if (pompaGucu.contains('5 - 10')) sistemGucuKw = 15.0;
      else if (pompaGucu.contains('10 - 20')) sistemGucuKw = 30.0;
      else sistemGucuKw = 50.0;

      if (sistemGucuKw <= 7.5) tabanFiyat = 135000.0;
      else if (sistemGucuKw <= 15) tabanFiyat = 275000.0;
      else if (sistemGucuKw <= 30) tabanFiyat = 475000.0;
      else tabanFiyat = 800000.0;

      // Kuyu derinliği
      if (kuyuDerinligi.contains('50 - 100')) ekHizmetMaliyeti = 25000.0;
      else if (kuyuDerinligi.contains('100 Metre')) ekHizmetMaliyeti = 50000.0;
      else if (kuyuDerinligi.contains('Kuyu Yok')) zorlukCarpani *= 0.70; // Yüzey pompası

      // Sulama yöntemi
      if (sulamaYontemi.contains('Yağmurlama') || sulamaYontemi.contains('Karma')) {
        ekHizmetMaliyeti += 60000.0; // Daha güçlü pompa
      }

      // Kullanım şekli
      if (kullanimSekli.contains('Tüm Yıl')) zorlukCarpani = 1.30;

      // Elektrik hattı yoksa off-grid
      if (elektrikHatti.contains('Hayır')) {
        ekHizmetMaliyeti += 165000.0; // Akü sistemi
        zorlukCarpani *= 1.40;
      }
    }

    // ==========================================
    // 4) GÜNEŞ PANELİ SÖKÜM VE TAŞIMA
    // ==========================================
    else if (isTuru == "Güneş Paneli Söküm ve Taşıma") {
      final String panelSayisi = findValue('panel_sayisi_sokum', '10 - 25 Adet');
      final String tekrarKurulum = findValue('tekrar_kurulum', 'Hayır');
      final String vincIhtiyaci = findValue('vinc_ihtiyaci', 'Hayır');
      final String catiYuksekligi = findValue('cati_yuksekligi_sokum', '5 - 10 Metre');

      if (panelSayisi.contains('1 - 10')) tabanFiyat = 2500.0;
      else if (panelSayisi.contains('10 - 25')) tabanFiyat = 5000.0;
      else if (panelSayisi.contains('25 - 50')) tabanFiyat = 10000.0;
      else if (panelSayisi.contains('50 - 100')) tabanFiyat = 20000.0;
      else tabanFiyat = 35000.0;

      if (tekrarKurulum.contains('Evet')) ekHizmetMaliyeti = tabanFiyat * 1.5;
      if (vincIhtiyaci.contains('Evet')) ekHizmetMaliyeti += 12000.0;
      if (catiYuksekligi.contains('10 - 20')) zorlukCarpani = 1.25;
      else if (catiYuksekligi.contains('20 Metre Üzeri')) zorlukCarpani = 1.50;
    }

    // ==========================================
    // 5) GÜNEŞ PANELİ BAKIM VE TEMİZLİĞİ
    // ==========================================
    else if (isTuru == "Güneş Paneli Bakım ve Temizliği") {
      final String panelSayisi = findValue('panel_sayisi_bakim', '25 - 50 Adet');
      final String sonBakim = findValue('son_bakim_tarihi', '1 Yıldan Uzun Süredir Yapılmadı');
      final String yuksekteCalisma = findValue('yuksekte_calisma', 'Evet');
      final String termalKamera = findValue('termal_kamera', 'Evet');

      if (panelSayisi.contains('1 - 10')) tabanFiyat = 400.0;
      else if (panelSayisi.contains('10 - 25')) tabanFiyat = 750.0;
      else if (panelSayisi.contains('25 - 50')) tabanFiyat = 1500.0;
      else if (panelSayisi.contains('50 - 100')) tabanFiyat = 3000.0;
      else tabanFiyat = 6000.0;

      if (sonBakim.contains('1 Yıldan Uzun') || sonBakim.contains('İlk Kez')) {
        zorlukCarpani = 1.50;
      }
      if (yuksekteCalisma.contains('Evet')) ekHizmetMaliyeti += 3000.0;
      if (termalKamera.contains('Evet')) ekHizmetMaliyeti += 12000.0;
    }

    // ==========================================
    // 6) GÜNEŞ PANELİ ARIZA TESPİTİ
    // ==========================================
    else if (isTuru == "Güneş Paneli Arıza Tespiti") {
      final String arizaTipi = findValue('ariza_tipi', 'Düşük Enerji Üretiyor');
      final String arizaSuresi = findValue('ariza_suresi', 'Son 1 Ay İçinde');

      tabanFiyat = 3500.0;

      if (arizaTipi.contains('Panel Hasarı')) ekHizmetMaliyeti = 8000.0;
      else if (arizaTipi.contains('İnverter')) ekHizmetMaliyeti = 5000.0;
      else if (arizaTipi.contains('Enerji Üretmiyor')) ekHizmetMaliyeti = 6000.0;

      if (arizaSuresi.contains('Uzun Süredir')) zorlukCarpani = 1.30;
    }

    // ==========================================
    // 7) GÜNEŞ PANELİ PERFORMANS KONTROLÜ
    // ==========================================
    else if (isTuru == "Güneş Paneli Performans Kontrolü") {
      final String termalAnaliz = findValue('termal_analiz', 'Evet');
      final String droneKontrol = findValue('drone_kontrol', 'Hayır');
      final String performansRaporu = findValue('performans_raporu', 'Evet');

      tabanFiyat = 5000.0;
      if (termalAnaliz.contains('Evet')) ekHizmetMaliyeti += 12000.0;
      if (droneKontrol.contains('Evet')) ekHizmetMaliyeti += 25000.0;
      if (performansRaporu.contains('Detaylı')) projeMaliyeti = 8000.0;
    }

    // ==========================================
    // 8) İNVERTER MONTAJI
    // ==========================================
    else if (isTuru == "İnverter Montajı") {
      final String inverterGucu = findValue('inverter_gucu', '5 - 10 kW');
      final String inverterMarka = findValue('inverter_marka', 'Huawei');
      final String inverterTipi = findValue('inverter_tipi', 'Hibrit');

      tabanFiyat = 5000.0;

      if (inverterGucu.contains('1 - 3')) inverterMaliyeti = 14400.0;
      else if (inverterGucu.contains('3 - 5')) inverterMaliyeti = 20500.0;
      else if (inverterGucu.contains('5 - 10')) inverterMaliyeti = 32000.0;
      else if (inverterGucu.contains('10 - 25')) inverterMaliyeti = 55000.0;
      else inverterMaliyeti = 95000.0;

      if (inverterMarka.contains('Fronius') || inverterMarka.contains('SMA')) {
        inverterMaliyeti *= 1.30;
      }
      if (inverterTipi.contains('Hibrit')) inverterMaliyeti *= 1.40;
      else if (inverterTipi.contains('Off-Grid')) inverterMaliyeti *= 1.60;
    }

    // ==========================================
    // 9) İNVERTER ARIZA VE DEĞİŞİMİ
    // ==========================================
    else if (isTuru == "İnverter Arıza ve Değişimi") {
      final String calismaDurumu = findValue('inverter_calisma_durumu', 'Hiç Çalışmıyor');
      final String hataKodu = findValue('hata_kodu', 'Evet');

      tabanFiyat = 3000.0;

      if (calismaDurumu.contains('Hiç Çalışmıyor')) {
        inverterMaliyeti = 32000.0;
        ekHizmetMaliyeti = 4000.0;
      } else if (calismaDurumu.contains('Hata Veriyor')) {
        ekHizmetMaliyeti = 8000.0;
      } else {
        ekHizmetMaliyeti = 5000.0;
      }

      if (hataKodu.contains('Evet')) zorlukCarpani = 0.90; // Teşhis kolay
    }

    // ==========================================
    // 10) SOLAR KABLO VE ELEKTRİK TESİSATI
    // ==========================================
    else if (isTuru == "Solar Kablo ve Elektrik Tesisatı") {
      final String kabloMesafesi = findValue('kablo_mesafesi', '25 - 50 Metre');
      final String tesisatTipi = findValue('tesisat_tipi', 'AC + DC Tesisat');
      final String kanalAcma = findValue('kanal_acma', 'Evet');

      if (kabloMesafesi.contains('0 - 10')) tabanFiyat = 2050.0;
      else if (kabloMesafesi.contains('10 - 25')) tabanFiyat = 4100.0;
      else if (kabloMesafesi.contains('25 - 50')) tabanFiyat = 8200.0;
      else if (kabloMesafesi.contains('50 - 100')) tabanFiyat = 16400.0;
      else tabanFiyat = 30750.0;

      kabloTesisatMaliyeti = tabanFiyat;
      tabanFiyat = 2000.0;

      if (tesisatTipi.contains('AC + DC')) kabloTesisatMaliyeti *= 1.50;
      else if (tesisatTipi.contains('DC')) kabloTesisatMaliyeti *= 1.20;

      if (kanalAcma.contains('Evet')) ekHizmetMaliyeti = 15000.0;
    }

    // ==========================================
    // 11) PANEL TAŞIYICI KONSTRÜKSİYON MONTAJI
    // ==========================================
    else if (isTuru == "Panel Taşıyıcı Konstrüksiyon Montajı") {
      final String catiTipi = findValue('konstruksiyon_cati_tipi', 'Trapez Sac Çatı');
      final String konstruksiyonMalzeme = findValue('konstruksiyon_malzeme', 'Galvaniz Çelik');
      final String montajTipi = findValue('montaj_tipi', 'Çatı Montajı');

      sistemGucuKw = 10.0; // Varsayılan 10kW
      konstruksiyonMaliyeti = sistemGucuKw * 3500.0;

      if (catiTipi.contains('Kiremit')) zorlukCarpani = 1.20;
      else if (catiTipi.contains('Beton')) zorlukCarpani = 1.35;
      else if (catiTipi.contains('Arazi')) zorlukCarpani = 1.40;
      else zorlukCarpani = 1.0;

      if (konstruksiyonMalzeme.contains('Alüminyum')) konstruksiyonMaliyeti *= 1.25;
      if (montajTipi.contains('Otopark')) zorlukCarpani *= 1.50;
      else if (montajTipi.contains('Arazi')) zorlukCarpani *= 1.30;
    }

    // ==========================================
    // 12) GES PROJELENDİRME VE DANIŞMANLIK
    // ==========================================
    else if (isTuru == "GES Projelendirme ve Danışmanlık") {
      final String projeAmaci = findValue('proje_amaci', 'Öz Tüketim Amaçlı');
      final String kesifIsteniyor = findValue('kesif_isteniyor', 'Evet');
      final String tesvikDanismanligi = findValue('tesvik_danismanligi', 'Evet');
      final String resmiSurecDestegi = findValue('resmi_surec_destegi', 'Evet');

      tabanFiyat = 15000.0;

      if (projeAmaci.contains('Mahsuplaşmalı')) projeMaliyeti = 25000.0;
      else if (projeAmaci.contains('Tarımsal')) projeMaliyeti = 20000.0;
      else if (projeAmaci.contains('Ticari')) projeMaliyeti = 35000.0;
      else if (projeAmaci.contains('Endüstriyel')) projeMaliyeti = 50000.0;
      else projeMaliyeti = 18000.0;

      if (kesifIsteniyor.contains('Evet')) ekHizmetMaliyeti += 5000.0;
      if (tesvikDanismanligi.contains('Evet')) projeMaliyeti += 20000.0;
      if (resmiSurecDestegi.contains('Tüm Süreç')) projeMaliyeti += 35000.0;
      else if (resmiSurecDestegi.contains('Evet')) projeMaliyeti += 15000.0;
    }

    // TOPLAM HESAP
    double toplamFiyat = (tabanFiyat + panelMaliyeti + inverterMaliyeti + konstruksiyonMaliyeti + kabloTesisatMaliyeti + iscilikMaliyeti + ekHizmetMaliyeti + projeMaliyeti) * zorlukCarpani;

    double asgariBaraj = 15000.0;
    if (isTuru.contains('GES Kurulumu')) asgariBaraj = 80000.0;
    if (isTuru.contains('Arazi GES')) asgariBaraj = 2000000.0;
    if (isTuru.contains('Projelendirme')) asgariBaraj = 15000.0;
    if (isTuru.contains('İnverter')) asgariBaraj = 10000.0;

    double nihaiSonuc = toplamFiyat < asgariBaraj? asgariBaraj : toplamFiyat;

    return {
      "tahminiButce": nihaiSonuc,
      "hesaplananSistemGucuKw": sistemGucuKw,
      "tabanFiyat": tabanFiyat,
      "panelMaliyeti": panelMaliyeti,
      "inverterMaliyeti": inverterMaliyeti,
      "konstruksiyonMaliyeti": konstruksiyonMaliyeti,
      "kabloTesisatMaliyeti": kabloTesisatMaliyeti,
      "iscilikMaliyeti": iscilikMaliyeti,
      "ekHizmetMaliyeti": ekHizmetMaliyeti,
      "projeMaliyeti": projeMaliyeti,
      "zorlukCarpani": zorlukCarpani,
      "durum": "BAŞARILI"
    };
  }
}