// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/off_grid_mobil_enerji.dart

class OffGridMobilEnerjiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_turu",
      "label": "Yapılacak Off-Grid / Mobil Enerji Sistemi Türü",
      "type": "single",
      "required": true,
      "options": [
        "Karavan Güneş Enerji Sistemi Kurulumu",
        "Tiny House Güneş Enerji Sistemi Kurulumu",
        "Bağ Evi Güneş Enerji Sistemi Kurulumu",
        "Yayla Evi Enerji Sistemi Kurulumu",
        "Tekne ve Yat Solar Sistemi Kurulumu",
        "Mobil Enerji Sistemleri Kurulumu",
        "Off-Grid Sistem Bakım ve Onarımı",
        "Akü ve İnverter Entegrasyonu"
      ]
    },

    // ==========================================
    // 1) KARAVAN GÜNEŞ ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "karavan_tipi",
      "label": "Karavan Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Karavan Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Çekme Karavan",
        "Motokaravan",
        "Camper Van",
        "Tiny Camper",
        "Diğer"
      ]
    },
    {
      "id": "karavan_uzunlugu",
      "label": "Karavan Uzunluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Karavan Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "0 - 4 Metre",
        "4 - 6 Metre",
        "6 - 8 Metre",
        "8 Metre ve Üzeri"
      ]
    },
    {
      "id": "gunluk_enerji_tuketim",
      "label": "Günlük Enerji Tüketim Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Karavan Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Düşük (Aydınlatma, Telefon, Laptop)",
        "Orta (Buzdolabı, TV, Küçük Cihazlar)",
        "Yüksek (Klima, Kahve Makinesi vb.)",
        "Bilmiyorum"
      ]
    },
    {
      "id": "kullanilacak_cihazlar",
      "label": "Kullanılacak Cihazlar",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Karavan Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Aydınlatma",
        "Buzdolabı",
        "Televizyon",
        "Klima",
        "Laptop / Bilgisayar",
        "Kahve Makinesi",
        "Su Pompası",
        "Diğer"
      ]
    },
    {
      "id": "aku_tercihi_karavan",
      "label": "Akü Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Karavan Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Jel Akü",
        "AGM Akü",
        "Lityum Akü",
        "Ustanın Önerisine Göre"
      ]
    },
    {
      "id": "karavan_kullanim_suresi",
      "label": "Karavan Yılın Ne Kadarında Kullanılıyor?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Karavan Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Sadece Yaz Dönemi",
        "Mevsimsel",
        "Yıl Boyu",
        "Sürekli Seyahat"
      ]
    },

    // ==========================================
    // 2) TINY HOUSE GÜNEŞ ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "tiny_house_kullanim",
      "label": "Tiny House Kullanım Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tiny House Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Sürekli Yaşam",
        "Yazlık Kullanım",
        "Kiralama Amaçlı",
        "Dönemsel Kullanım"
      ]
    },
    {
      "id": "yapi_buyuklugu",
      "label": "Yapı Büyüklüğü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tiny House Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "0 - 20 m²",
        "20 - 40 m²",
        "40 - 60 m²",
        "60 m² ve Üzeri"
      ]
    },
    {
      "id": "elektrik_sebekesi_mevcut",
      "label": "Elektrik Şebekesi Mevcut mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tiny House Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Yakında Var",
        "Bilmiyorum"
      ]
    },
    {
      "id": "sistem_tipi_tiny",
      "label": "Sistem Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tiny House Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Tam Bağımsız (Off-Grid)",
        "Şebeke Destekli (Hibrit)",
        "Ustanın Belirlemesini İstiyorum"
      ]
    },
    {
      "id": "enerji_depolama_isteniyor",
      "label": "Enerji Depolama Sistemi İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tiny House Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Bilmiyorum"
      ]
    },
    {
      "id": "yerinde_kesif_tiny",
      "label": "Yerinde Keşif Gerekli mi?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tiny House Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Evet",
        "Hayır"
      ]
    },

    // ==========================================
    // 3) BAĞ EVİ GÜNEŞ ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "bag_evi_kullanim",
      "label": "Bağ Evi Kullanım Sıklığı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Bağ Evi Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Hafta Sonları",
        "Yaz Dönemi",
        "Tüm Yıl",
        "Nadiren Kullanılıyor"
      ]
    },
    {
      "id": "elektrik_hatti_bag",
      "label": "Elektrik Hattı Mevcut mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Bağ Evi Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Yakın Mesafede Var",
        "Bilmiyorum"
      ]
    },
    {
      "id": "enerji_kullanim_amaci",
      "label": "Enerji Kullanım Amacı",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Bağ Evi Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Aydınlatma",
        "Buzdolabı",
        "Sulama Sistemi",
        "Televizyon",
        "Klima",
        "Güvenlik Sistemi",
        "Su Pompası",
        "Genel Kullanım"
      ]
    },
    {
      "id": "tahmini_gunluk_tuketim",
      "label": "Tahmini Günlük Tüketim",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Bağ Evi Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Düşük",
        "Orta",
        "Yüksek",
        "Bilmiyorum"
      ]
    },
    {
      "id": "jenerator_destegi",
      "label": "Jeneratör Desteği Düşünüyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Bağ Evi Güneş Enerji Sistemi Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Kararsızım"
      ]
    },

    // ==========================================
    // 4) YAYLA EVİ ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "yayla_ulasim",
      "label": "Yayla Evi Ulaşım Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Yayla Evi Enerji Sistemi Kurulumu"],
      "options": [
        "Kolay Ulaşılabilir",
        "Zor Ulaşılabilir",
        "Arazi Aracı Gerekiyor"
      ]
    },
    {
      "id": "yayla_kullanim_sekli",
      "label": "Kullanım Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Yayla Evi Enerji Sistemi Kurulumu"],
      "options": [
        "Mevsimlik",
        "Yaz Dönemi",
        "Sürekli Kullanım"
      ]
    },
    {
      "id": "iklim_kosullari",
      "label": "Bölgenin İklim Koşulları",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Yayla Evi Enerji Sistemi Kurulumu"],
      "options": [
        "Sert Kış Şartları",
        "Yoğun Kar Yağışı",
        "Rüzgarlı Bölge",
        "Ilıman Bölge"
      ]
    },
    {
      "id": "sistemden_beklenti",
      "label": "Sistemden Beklenti",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Yayla Evi Enerji Sistemi Kurulumu"],
      "options": [
        "Temel Elektrik İhtiyacı",
        "Kesintisiz Enerji",
        "Tam Bağımsız Yaşam"
      ]
    },
    {
      "id": "enerji_kaynagi_tercihi",
      "label": "Enerji Kaynağı Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Yayla Evi Enerji Sistemi Kurulumu"],
      "options": [
        "Güneş Enerjisi",
        "Güneş + Rüzgar",
        "Güneş + Jeneratör",
        "Ustanın Önerisine Göre"
      ]
    },

    // ==========================================
    // 5) TEKNE VE YAT SOLAR SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "arac_tipi_tekne",
      "label": "Araç Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tekne ve Yat Solar Sistemi Kurulumu"],
      "options": [
        "Balıkçı Teknesi",
        "Yelkenli",
        "Motor Yat",
        "Katamaran",
        "Diğer"
      ]
    },
    {
      "id": "tekne_boyu",
      "label": "Tekne Boyu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tekne ve Yat Solar Sistemi Kurulumu"],
      "options": [
        "0 - 8 Metre",
        "8 - 15 Metre",
        "15 - 25 Metre",
        "25 Metre ve Üzeri"
      ]
    },
    {
      "id": "kullanim_amaci_tekne",
      "label": "Kullanım Amacı",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tekne ve Yat Solar Sistemi Kurulumu"],
      "options": [
        "Aydınlatma",
        "Navigasyon Sistemleri",
        "Buzdolabı",
        "Klima",
        "Haberleşme Sistemleri",
        "Yaşam Alanı Enerjisi"
      ]
    },
    {
      "id": "denizde_kalis_suresi",
      "label": "Denizde Kalış Süresi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tekne ve Yat Solar Sistemi Kurulumu"],
      "options": [
        "Günlük Kullanım",
        "Birkaç Gün",
        "Haftalarca",
        "Uzun Süreli Seyir"
      ]
    },
    {
      "id": "aku_sistemi_mevcut",
      "label": "Akü Sistemi Mevcut mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tekne ve Yat Solar Sistemi Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Bilmiyorum"
      ]
    },

    // ==========================================
    // 6) MOBİL ENERJİ SİSTEMLERİ KURULUMU
    // ==========================================
    {
      "id": "mobil_kullanim_yeri",
      "label": "Sistem Nerede Kullanılacak?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Mobil Enerji Sistemleri Kurulumu"],
      "options": [
        "Karavan",
        "Tiny House",
        "Mobil Ofis",
        "Etkinlik Alanı",
        "Şantiye",
        "Tarımsal Arazi",
        "Diğer"
      ]
    },
    {
      "id": "tasinabilirlik_onceligi",
      "label": "Taşınabilirlik Önceliği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Mobil Enerji Sistemleri Kurulumu"],
      "options": [
        "Çok Önemli",
        "Orta Seviye",
        "Sabit Sistem de Olabilir"
      ]
    },
    {
      "id": "enerji_ihtiyaci_mobil",
      "label": "Enerji İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Mobil Enerji Sistemleri Kurulumu"],
      "options": [
        "Düşük",
        "Orta",
        "Yüksek",
        "Bilmiyorum"
      ]
    },
    {
      "id": "sistemin_kullanim_amaci",
      "label": "Sistemin Kullanım Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Mobil Enerji Sistemleri Kurulumu"],
      "options": [
        "Acil Durum Enerjisi",
        "Sürekli Kullanım",
        "Yedek Enerji",
        "Ticari Kullanım"
      ]
    },

    // ==========================================
    // 7) OFF-GRID SİSTEM BAKIM VE ONARIMI
    // ==========================================
    {
      "id": "sorun_tipi_offgrid",
      "label": "Sistemde Yaşanan Sorun",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Off-Grid Sistem Bakım ve Onarımı"],
      "options": [
        "Enerji Üretmiyor",
        "Aküler Şarj Olmuyor",
        "İnverter Çalışmıyor",
        "Düşük Performans",
        "Sistem Sık Sık Kapanıyor",
        "Hata Kodu Veriyor",
        "Diğer"
      ]
    },
    {
      "id": "sistem_yasi",
      "label": "Sistem Yaşı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Off-Grid Sistem Bakım ve Onarımı"],
      "options": [
        "0 - 2 Yıl",
        "2 - 5 Yıl",
        "5 - 10 Yıl",
        "10 Yıl ve Üzeri",
        "Bilmiyorum"
      ]
    },
    {
      "id": "sorun_suresi",
      "label": "Sorun Ne Zamandır Mevcut?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Off-Grid Sistem Bakım ve Onarımı"],
      "options": [
        "Son 24 Saat",
        "Son 1 Hafta",
        "Son 1 Ay",
        "Uzun Süredir Devam Ediyor"
      ]
    },
    {
      "id": "acil_servis",
      "label": "Acil Servis Gerekiyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Off-Grid Sistem Bakım ve Onarımı"],
      "options": [
        "Evet",
        "Hayır"
      ]
    },

    // ==========================================
    // 8) AKÜ VE İNVERTER ENTEGRASYONU
    // ==========================================
    {
      "id": "mevcut_ekipman",
      "label": "Mevcut Ekipman Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü ve İnverter Entegrasyonu"],
      "options": [
        "Sadece Akü Var",
        "Sadece İnverter Var",
        "Her İkisi de Var",
        "Yeni Sistem Kurulacak"
      ]
    },
    {
      "id": "aku_tipi_entegrasyon",
      "label": "Akü Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü ve İnverter Entegrasyonu"],
      "options": [
        "Jel",
        "AGM",
        "Lityum",
        "Bilmiyorum"
      ]
    },
    {
      "id": "inverter_tipi",
      "label": "İnverter Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü ve İnverter Entegrasyonu"],
      "options": [
        "Tam Sinüs",
        "Modifiye Sinüs",
        "Hibrit İnverter",
        "Bilmiyorum"
      ]
    },
    {
      "id": "sistem_amaci_entegrasyon",
      "label": "Sistem Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü ve İnverter Entegrasyonu"],
      "options": [
        "Yedek Enerji",
        "Off-Grid Kullanım",
        "Mobil Kullanım",
        "Hibrit Sistem"
      ]
    },
    {
      "id": "uzaktan_izleme",
      "label": "Uzaktan İzleme Özelliği İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü ve İnverter Entegrasyonu"],
      "options": [
        "Evet",
        "Hayır",
        "Ustanın Önerisine Göre"
      ]
    },
  ];
}