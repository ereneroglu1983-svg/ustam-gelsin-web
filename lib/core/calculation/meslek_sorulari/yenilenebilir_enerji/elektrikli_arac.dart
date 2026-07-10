// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/elektrikli_arac.dart

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
    // 1) EV TİPİ ŞARJ İSTASYONU KURULUMU
    // ==========================================
    {
      "id": "kurulum_yeri_ev",
      "label": "Kurulum Yapılacak Yer",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Şarj İstasyonu Kurulumu"],
      "options": [
        "Müstakil Ev",
        "Villa",
        "Apartman Otoparkı",
        "Kapalı Garaj",
        "Açık Otopark",
        "Diğer"
      ]
    },
    {
      "id": "arac_sayisi_ev",
      "label": "Araç Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Şarj İstasyonu Kurulumu"],
      "options": [
        "1 araç",
        "2 araç",
        "3+ araç"
      ]
    },
    {
      "id": "sarj_gucu_ev",
      "label": "Şarj Gücü İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Şarj İstasyonu Kurulumu"],
      "options": [
        "3.7 kW (Standart)",
        "7.4 kW (Hızlı ev tipi)",
        "11 kW",
        "22 kW",
        "Bilmiyorum"
      ]
    },
    {
      "id": "elektrik_altyapisi_ev",
      "label": "Elektrik Altyapısı Hazır mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Şarj İstasyonu Kurulumu"],
      "options": [
        "Evet hazır",
        "Kısmen hazır",
        "Yeni tesisat gerekli"
      ]
    },
    {
      "id": "sayac_durumu",
      "label": "Sayaç Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Şarj İstasyonu Kurulumu"],
      "options": [
        "Tek faz",
        "Trifaze",
        "Bilmiyorum"
      ]
    },
    {
      "id": "akilli_sarj",
      "label": "İnternet / Akıllı Şarj İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Şarj İstasyonu Kurulumu"],
      "options": [
        "Evet (App kontrollü)",
        "Hayır",
        "Ustanın önerisi"
      ]
    },

    // ==========================================
    // 2) SİTE VE APARTMAN ŞARJ İSTASYONU KURULUMU
    // ==========================================
    {
      "id": "kurulum_tipi_site",
      "label": "Kurulum Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Site ve Apartman Şarj İstasyonu Kurulumu"],
      "options": [
        "Ortak kullanım istasyonu",
        "Bireysel kullanıcı noktaları",
        "Her ikisi"
      ]
    },
    {
      "id": "arac_kapasitesi_site",
      "label": "Araç Kapasitesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Site ve Apartman Şarj İstasyonu Kurulumu"],
      "options": [
        "1–5 araç",
        "5–10 araç",
        "10–20 araç",
        "20+ araç"
      ]
    },
    {
      "id": "load_balancing",
      "label": "Güç Yönetimi Sistemi (Load Balancing)",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Site ve Apartman Şarj İstasyonu Kurulumu"],
      "options": [
        "Evet istiyorum",
        "Hayır",
        "Bilmiyorum"
      ]
    },
    {
      "id": "olcum_sistemi",
      "label": "Ölçüm Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Site ve Apartman Şarj İstasyonu Kurulumu"],
      "options": [
        "Kişisel sayaçlı",
        "Ortak sayaç",
        "Kart / RFID sistemli"
      ]
    },
    {
      "id": "yetkilendirme_sistemi",
      "label": "Yetkilendirme Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Site ve Apartman Şarj İstasyonu Kurulumu"],
      "options": [
        "Mobil uygulama",
        "Kart sistemi",
        "Şifreli kullanım",
        "Serbest kullanım"
      ]
    },

    // ==========================================
    // 3) TİCARİ ŞARJ İSTASYONU KURULUMU
    // ==========================================
    {
      "id": "isletme_tipi_ticari",
      "label": "İşletme Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ticari Şarj İstasyonu Kurulumu"],
      "options": [
        "AVM",
        "Akaryakıt istasyonu",
        "Otopark işletmesi",
        "Otel",
        "Restoran / Kafe",
        "Diğer"
      ]
    },
    {
      "id": "sarj_kapasitesi_ticari",
      "label": "Şarj Kapasitesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ticari Şarj İstasyonu Kurulumu"],
      "options": [
        "1–2 araç",
        "3–5 araç",
        "5–10 araç",
        "10+ araç"
      ]
    },
    {
      "id": "gelir_modeli",
      "label": "Gelir Modeli",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ticari Şarj İstasyonu Kurulumu"],
      "options": [
        "Ücretli şarj",
        "Ücretsiz (müşteri çekme amaçlı)",
        "Karma model"
      ]
    },
    {
      "id": "odeme_sistemi",
      "label": "Ödeme Sistemi",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ticari Şarj İstasyonu Kurulumu"],
      "options": [
        "Kart",
        "Mobil uygulama",
        "QR ödeme",
        "Abonelik sistemi"
      ]
    },

    // ==========================================
    // 4) OTOPARK ŞARJ ALTYAPISI KURULUMU
    // ==========================================
    {
      "id": "otopark_tipi",
      "label": "Otopark Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Otopark Şarj Altyapısı Kurulumu"],
      "options": [
        "Açık otopark",
        "Kapalı otopark",
        "AVM otoparkı",
        "Site otoparkı"
      ]
    },
    {
      "id": "altyapi_durumu",
      "label": "Altyapı Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Otopark Şarj Altyapısı Kurulumu"],
      "options": [
        "Elektrik hazır",
        "Kısmen hazır",
        "Komple altyapı kurulacak"
      ]
    },
    {
      "id": "kablo_altyapisi",
      "label": "Kablo Altyapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Otopark Şarj Altyapısı Kurulumu"],
      "options": [
        "Yer altı",
        "Kanal üstü",
        "Karışık sistem"
      ]
    },
    {
      "id": "gelecek_genisleme",
      "label": "Gelecek Genişleme Planı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Otopark Şarj Altyapısı Kurulumu"],
      "options": [
        "Evet (ölçeklenebilir sistem)",
        "Hayır",
        "Bilmiyorum"
      ]
    },

    // ==========================================
    // 5) AC ŞARJ ÜNİTESİ KURULUMU
    // ==========================================
    {
      "id": "kullanim_amaci_ac",
      "label": "Kullanım Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["AC Şarj Ünitesi Kurulumu"],
      "options": [
        "Ev",
        "İş yeri",
        "Site",
        "Otopark"
      ]
    },
    {
      "id": "guc_seviyesi_ac",
      "label": "Güç Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["AC Şarj Ünitesi Kurulumu"],
      "options": [
        "3.7 kW",
        "7.4 kW",
        "11 kW",
        "22 kW"
      ]
    },
    {
      "id": "baglanti_tipi",
      "label": "Bağlantı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["AC Şarj Ünitesi Kurulumu"],
      "options": [
        "Type 2",
        "Type 1",
        "Bilmiyorum"
      ]
    },
    {
      "id": "akilli_ozellikler",
      "label": "Akıllı Özellikler",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["AC Şarj Ünitesi Kurulumu"],
      "options": [
        "Zamanlama",
        "Uygulama kontrolü",
        "Enerji takibi",
        "Basit sistem"
      ]
    },

    // ==========================================
    // 6) DC HIZLI ŞARJ ÜNİTESİ KURULUMU
    // ==========================================
    {
      "id": "kurulum_amaci_dc",
      "label": "Kurulum Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["DC Hızlı Şarj Ünitesi Kurulumu"],
      "options": [
        "Ticari kullanım",
        "Kamu alanı",
        "Otoyol / geçiş noktası",
        "Kurumsal filo"
      ]
    },
    {
      "id": "guc_seviyesi_dc",
      "label": "Güç Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["DC Hızlı Şarj Ünitesi Kurulumu"],
      "options": [
        "30 kW",
        "60 kW",
        "120 kW",
        "150 kW+",
        "300 kW+"
      ]
    },
    {
      "id": "sarj_suresi_hedefi",
      "label": "Şarj Süresi Hedefi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["DC Hızlı Şarj Ünitesi Kurulumu"],
      "options": [
        "20–30 dakika",
        "30–60 dakika",
        "1 saat+"
      ]
    },
    {
      "id": "ayni_anda_arac",
      "label": "Aynı Anda Şarj Araç Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["DC Hızlı Şarj Ünitesi Kurulumu"],
      "options": [
        "1",
        "2",
        "3+"
      ]
    },

    // ==========================================
    // 7) ŞARJ İSTASYONU ARIZA VE SERVİSİ
    // ==========================================
    {
      "id": "ariza_tipi_sarj",
      "label": "Sorun Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Arıza ve Servisi"],
      "options": [
        "Şarj başlamıyor",
        "Bağlantı hatası",
        "Güç vermiyor",
        "Kart / uygulama çalışmıyor",
        "Fiziksel hasar",
        "Diğer"
      ]
    },
    {
      "id": "cihaz_durumu",
      "label": "Cihaz Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Arıza ve Servisi"],
      "options": [
        "Tam çalışmıyor",
        "Aralıklı çalışıyor",
        "Performans düşüklüğü"
      ]
    },
    {
      "id": "acil_durum",
      "label": "Acil Durum mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Arıza ve Servisi"],
      "options": [
        "Evet",
        "Hayır"
      ]
    },

    // ==========================================
    // 8) ŞARJ İSTASYONU BAKIMI
    // ==========================================
    {
      "id": "bakim_tipi",
      "label": "Bakım Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Bakımı"],
      "options": [
        "Periyodik bakım",
        "Arıza sonrası kontrol",
        "Kurulum sonrası kontrol"
      ]
    },
    {
      "id": "yapilacak_islemler_bakim",
      "label": "Yapılacak İşlemler",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Bakımı"],
      "options": [
        "Kablo kontrolü",
        "Yazılım güncelleme",
        "Güç testi",
        "Bağlantı kontrolü",
        "Güvenlik testi"
      ]
    },
    {
      "id": "sistem_yogunlugu",
      "label": "Sistem Yoğunluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Bakımı"],
      "options": [
        "Az kullanım",
        "Orta kullanım",
        "Yoğun kullanım"
      ]
    },

    // ==========================================
    // 9) ŞARJ ALTYAPISI PROJELENDİRME
    // ==========================================
    {
      "id": "proje_tipi",
      "label": "Proje Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj Altyapısı Projelendirme"],
      "options": [
        "Bireysel",
        "Site / apartman",
        "Ticari",
        "Endüstriyel"
      ]
    },
    {
      "id": "planlama_icerigi",
      "label": "Planlama İçeriği",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj Altyapısı Projelendirme"],
      "options": [
        "Güç dağılımı",
        "Kablo güzergahı",
        "İstasyon yerleşimi",
        "Yük hesaplaması"
      ]
    },
    {
      "id": "resmi_surec",
      "label": "Resmi Süreç Gerekiyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj Altyapısı Projelendirme"],
      "options": [
        "Evet",
        "Hayır",
        "Bilmiyorum"
      ]
    },
    {
      "id": "gelecek_kapasite",
      "label": "Gelecek Kapasite Planı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj Altyapısı Projelendirme"],
      "options": [
        "Sabit sistem",
        "Genişletilebilir sistem"
      ]
    },

    // ==========================================
    // 10) ŞARJ İSTASYONU ELEKTRİK TESİSATI
    // ==========================================
    {
      "id": "mevcut_durum_tesisat",
      "label": "Mevcut Durum",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Elektrik Tesisatı"],
      "options": [
        "Elektrik hazır",
        "Kısmen hazır",
        "Komple yeni tesisat"
      ]
    },
    {
      "id": "hat_tipi",
      "label": "Hat Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Elektrik Tesisatı"],
      "options": [
        "Tek faz",
        "Trifaze",
        "Bilmiyorum"
      ]
    },
    {
      "id": "kablo_mesafesi",
      "label": "Kablo Mesafesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Elektrik Tesisatı"],
      "options": [
        "0–10 metre",
        "10–30 metre",
        "30–100 metre",
        "100+ metre"
      ]
    },
    {
      "id": "guc_ihtiyaci",
      "label": "Güç İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Şarj İstasyonu Elektrik Tesisatı"],
      "options": [
        "Düşük",
        "Orta",
        "Yüksek"
      ]
    },
  ];
}