// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/elektrikli_arac.dart - FINAL ZİNCİRLİ
class ElektrikliAracSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_turu",
      "label": "Yapılacak Elektrikli Araç Şarj Sistemi Türü",
      "type": "single",
      "required": true,
      "options": [
        "Ev Tipi Şarj İstasyonu Kurulumu",
        "Site ve Apartman Şarj İstasyonu Kurulumu",
        "Ticari Şarj İstasyonu Kurulumu",
        "Otopark Şarj Altyapısı Kurulumu",
        "AC Şarj Ünitesi Kurulumu",
        "DC Hızlı Şarj Ünitesi Kurulumu",
        "Şarj İstasyonu Arıza ve Servisi",
        "Şarj İstasyonu Bakımı",
        "Şarj Altyapısı Projelendirme",
        "Şarj İstasyonu Elektrik Tesisatı"
      ]
    },

    // ==========================================
    // 1) EV TİPİ - ZİNCİR: yer -> araç sayısı -> güç -> altyapı -> sayaç -> akıllı
    // ==========================================
    {
      "id": "kurulum_yeri_ev",
      "label": "Kurulum Yapılacak Yer",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Şarj İstasyonu Kurulumu"],
      "options": ["Müstakil Ev", "Villa", "Apartman Otoparkı", "Kapalı Garaj", "Açık Otopark"]
    },
    {
      "id": "arac_sayisi_ev",
      "label": "Şarj Edilecek Araç Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "kurulum_yeri_ev",
      "options": ["1 Araç", "2 Araç", "3 ve Üzeri Araç"]
    },
    {
      "id": "sarj_gucu_ev",
      "label": "Şarj Gücü İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "arac_sayisi_ev",
      "options": ["3.7 kW Standart", "7.4 kW Hızlı Ev Tipi", "11 kW", "22 kW"]
    },
    {
      "id": "elektrik_altyapisi_ev",
      "label": "Elektrik Altyapısı Hazır mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "sarj_gucu_ev",
      "options": ["Evet Hazır", "Kısmen Hazır", "Yeni Tesisat Gerekli"]
    },
    {
      "id": "sayac_durumu",
      "label": "Mevcut Sayaç / Hat Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "elektrik_altyapisi_ev",
      "options": ["Tek Faz Hat Mevcut", "Trifaze Hat Mevcut"]
    },
    {
      "id": "akilli_sarj",
      "label": "Akıllı Şarj / Uygulama Kontrolü",
      "type": "single",
      "required": true,
      "dependsOnId": "sayac_durumu",
      "options": ["Evet Uygulama Kontrollü Olsun", "Hayır Basit Şarj Yeterli"]
    },

    // ==========================================
    // 2) SİTE VE APARTMAN - ZİNCİR
    // ==========================================
    {
      "id": "kurulum_tipi_site",
      "label": "Kurulum Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Site ve Apartman Şarj İstasyonu Kurulumu"],
      "options": ["Ortak Kullanım İstasyonu", "Bireysel Kullanıcı Noktaları", "Hem Ortak Hem Bireysel"]
    },
    {
      "id": "arac_kapasitesi_site",
      "label": "Toplam Araç Kapasitesi",
      "type": "single",
      "required": true,
      "dependsOnId": "kurulum_tipi_site",
      "options": ["1-5 Araç", "6-10 Araç", "11-20 Araç", "20+ Araç"]
    },
    {
      "id": "load_balancing",
      "label": "Güç Yönetimi (Load Balancing)",
      "type": "single",
      "required": true,
      "dependsOnId": "arac_kapasitesi_site",
      "options": ["Evet Load Balancing Gerekli", "Hayır Gerekli Değil"]
    },
    {
      "id": "olcum_sistemi",
      "label": "Ölçüm / Faturalandırma Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "load_balancing",
      "options": ["Kişisel Sayaçlı", "Ortak Sayaç", "Kart / RFID Sistemli"]
    },
    {
      "id": "yetkilendirme_sistemi",
      "label": "Yetkilendirme Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "olcum_sistemi",
      "options": ["Mobil Uygulama", "Kart Sistemi", "Şifreli Kullanım", "Serbest Kullanım"]
    },

    // ==========================================
    // 3) TİCARİ - ZİNCİR
    // ==========================================
    {
      "id": "isletme_tipi_ticari",
      "label": "İşletme Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ticari Şarj İstasyonu Kurulumu"],
      "options": ["AVM", "Akaryakıt İstasyonu", "Otopark İşletmesi", "Otel", "Restoran / Kafe"]
    },
    {
      "id": "sarj_kapasitesi_ticari",
      "label": "Aynı Anda Şarj Kapasitesi",
      "type": "single",
      "required": true,
      "dependsOnId": "isletme_tipi_ticari",
      "options": ["1-2 Araç", "3-5 Araç", "6-10 Araç", "10+ Araç"]
    },
    {
      "id": "gelir_modeli",
      "label": "Gelir Modeli",
      "type": "single",
      "required": true,
      "dependsOnId": "sarj_kapasitesi_ticari",
      "options": ["Ücretli Şarj", "Ücretsiz Müşteri Hizmeti", "Karma Model"]
    },
    {
      "id": "odeme_sistemi",
      "label": "Ödeme Sistemi",
      "type": "multi",
      "required": true,
      "dependsOnId": "gelir_modeli",
      "options": ["Kart ile Ödeme", "Mobil Uygulama", "QR Ödeme", "Abonelik Sistemi", "Ödeme Sistemi İstemiyorum"]
    },

    // ==========================================
    // 4) OTOPARK ALTYAPI - ZİNCİR
    // ==========================================
    {
      "id": "otopark_tipi",
      "label": "Otopark Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Otopark Şarj Altyapısı Kurulumu"],
      "options": ["Açık Otopark", "Kapalı Otopark", "AVM Otoparkı", "Site Otoparkı"]
    },
    {
      "id": "altyapi_durumu",
      "label": "Mevcut Elektrik Altyapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "otopark_tipi",
      "options": ["Elektrik Altyapısı Hazır", "Kısmen Hazır", "Komple Yeni Altyapı Kurulacak"]
    },
    {
      "id": "kablo_altyapisi",
      "label": "Kablo Altyapısı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "altyapi_durumu",
      "options": ["Yer Altı Kablo", "Kanal Üstü Kablo", "Karışık Sistem"]
    },
    {
      "id": "gelecek_genisleme",
      "label": "Gelecekte Genişleme Planı Var mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "kablo_altyapisi",
      "options": ["Evet Ölçeklenebilir Olsun", "Hayır Sabit Sistem Yeterli"]
    },

    // ==========================================
    // 5) AC ÜNİTE - ZİNCİR
    // ==========================================
    {
      "id": "kullanim_amaci_ac",
      "label": "Kullanım Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["AC Şarj Ünitesi Kurulumu"],
      "options": ["Ev Kullanımı", "İş Yeri", "Site Ortak Alan", "Otopark"]
    },
    {
      "id": "guc_seviyesi_ac",
      "label": "Güç Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "kullanim_amaci_ac",
      "options": ["3.7 kW", "7.4 kW", "11 kW", "22 kW"]
    },
    {
      "id": "baglanti_tipi",
      "label": "Araç Bağlantı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "guc_seviyesi_ac",
      "options": ["Type 2 Soket", "Type 1 Soket"]
    },
    {
      "id": "akilli_ozellikler",
      "label": "İstenen Akıllı Özellikler",
      "type": "multi",
      "required": true,
      "dependsOnId": "baglanti_tipi",
      "options": ["Zamanlama Özelliği", "Uygulama Kontrolü", "Enerji Takibi", "Akıllı Özellik İstemiyorum"]
    },

    // ==========================================
    // 6) DC HIZLI ŞARJ - ZİNCİR
    // ==========================================
    {
      "id": "kurulum_amaci_dc",
      "label": "Kurulum Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["DC Hızlı Şarj Ünitesi Kurulumu"],
      "options": ["Ticari Kullanım", "Kamu Alanı", "Otoyol Geçiş Noktası", "Kurumsal Filo"]
    },
    {
      "id": "guc_seviyesi_dc",
      "label": "DC Güç Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "kurulum_amaci_dc",
      "options": ["30 kW", "60 kW", "120 kW", "150 kW ve Üzeri", "300 kW ve Üzeri"]
    },
    {
      "id": "sarj_suresi_hedefi",
      "label": "Hedeflenen Şarj Süresi",
      "type": "single",
      "required": true,
      "dependsOnId": "guc_seviyesi_dc",
      "options": ["20-30 Dakika", "30-60 Dakika", "60 Dakika Üzeri"]
    },
    {
      "id": "ayni_anda_arac",
      "label": "Aynı Anda Şarj Edilecek Araç Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "sarj_suresi_hedefi",
      "options": ["1 Araç", "2 Araç", "3 ve Üzeri Araç"]
    },

    // ==========================================
    // 7) ARIZA VE SERVİS - ZİNCİR
    // ==========================================
    {
      "id": "ariza_tipi_sarj",
      "label": "Sorun Tipi Nedir?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Arıza ve Servisi"],
      "options": ["Şarj Başlamıyor", "Bağlantı Hatası", "Güç Vermiyor", "Kart / Uygulama Çalışmıyor", "Fiziksel Hasar Mevcut"]
    },
    {
      "id": "cihaz_durumu",
      "label": "Cihazın Mevcut Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "ariza_tipi_sarj",
      "options": ["Tamamen Çalışmıyor", "Aralıklı Çalışıyor", "Performans Düşüklüğü Var"]
    },
    {
      "id": "acil_durum",
      "label": "Acil Servis Gerekli mi?",
      "type": "single",
      "required": true,
      "dependsOnId": "cihaz_durumu",
      "options": ["Evet Acil Müdahale Gerekli", "Hayır Normal Servis Yeterli"]
    },

    // ==========================================
    // 8) BAKIM - ZİNCİR
    // ==========================================
    {
      "id": "bakim_tipi",
      "label": "Bakım Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Bakımı"],
      "options": ["Periyodik Bakım", "Arıza Sonrası Kontrol", "Kurulum Sonrası İlk Kontrol"]
    },
    {
      "id": "sistem_yogunlugu",
      "label": "Sistem Kullanım Yoğunluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "bakim_tipi",
      "options": ["Az Kullanım", "Orta Yoğunlukta Kullanım", "Yoğun Kullanım"]
    },
    {
      "id": "yapilacak_islemler_bakim",
      "label": "Yapılacak Bakım İşlemleri",
      "type": "multi",
      "required": true,
      "dependsOnId": "sistem_yogunlugu",
      "options": ["Kablo Kontrolü", "Yazılım Güncelleme", "Güç Testi", "Bağlantı Kontrolü", "Güvenlik Testi"]
    },

    // ==========================================
    // 9) PROJELENDİRME - ZİNCİR
    // ==========================================
    {
      "id": "proje_tipi",
      "label": "Proje Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj Altyapısı Projelendirme"],
      "options": ["Bireysel Konut Projesi", "Site / Apartman Projesi", "Ticari Proje", "Endüstriyel Proje"]
    },
    {
      "id": "gelecek_kapasite",
      "label": "Gelecek Kapasite Planı",
      "type": "single",
      "required": true,
      "dependsOnId": "proje_tipi",
      "options": ["Sabit Sistem", "Genişletilebilir Sistem"]
    },
    {
      "id": "planlama_icerigi",
      "label": "Planlama İçeriği Neleri Kapsasın?",
      "type": "multi",
      "required": true,
      "dependsOnId": "gelecek_kapasite",
      "options": ["Güç Dağılımı Hesabı", "Kablo Güzergahı", "İstasyon Yerleşimi", "Yük Hesaplaması"]
    },
    {
      "id": "resmi_surec",
      "label": "Resmi İzin / Başvuru Süreci Gerekiyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "planlama_icerigi",
      "options": ["Evet Resmi Süreç Gerekli", "Hayır Gerekli Değil"]
    },

    // ==========================================
    // 10) ELEKTRİK TESİSATI - ZİNCİR
    // ==========================================
    {
      "id": "mevcut_durum_tesisat",
      "label": "Mevcut Elektrik Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Elektrik Tesisatı"],
      "options": ["Elektrik Altyapısı Hazır", "Kısmen Hazır", "Komple Yeni Tesisat Gerekli"]
    },
    {
      "id": "hat_tipi",
      "label": "Gerekli Hat Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "mevcut_durum_tesisat",
      "options": ["Tek Faz Hat", "Trifaze Hat"]
    },
    {
      "id": "kablo_mesafesi",
      "label": "Pano ile İstasyon Arası Kablo Mesafesi",
      "type": "single",
      "required": true,
      "dependsOnId": "hat_tipi",
      "options": ["0-10 Metre", "10-30 Metre", "30-100 Metre", "100 Metre Üzeri"]
    },
    {
      "id": "guc_ihtiyaci",
      "label": "Toplam Güç İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "kablo_mesafesi",
      "options": ["Düşük Güç", "Orta Güç", "Yüksek Güç"]
    },
  ];
}