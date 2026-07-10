// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/enerji_depolama.dart

class EnerjiDepolamaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_turu",
      "label": "Yapılacak Enerji Depolama Sistemi Türü",
      "type": "single",
      "required": true,
      "options": [
        "Solar Akü Sistemi Kurulumu",
        "Lityum Akü Sistemi Kurulumu",
        "Akü Değişimi",
        "Akü Bakım ve Test Hizmeti",
        "Enerji Depolama Ünitesi Kurulumu",
        "BMS (Batarya Yönetim Sistemi) Kurulumu",
        "UPS Sistemleri Kurulumu",
        "Off-Grid Enerji Sistemi Kurulumu",
        "Hibrit Enerji Sistemi Kurulumu",
        "Yedek Güç Sistemi Kurulumu"
      ]
    },

    // ==========================================
    // 1) SOLAR AKÜ SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "kullanim_yeri",
      "label": "Sistem Nerede Kullanılacak?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Solar Akü Sistemi Kurulumu"],
      "options": [
        "Konut (Ev / Villa)",
        "Yazlık",
        "Çiftlik",
        "İşletme",
        "Karavan / Tiny House",
        "Off-grid arazi",
        "Diğer"
      ]
    },
    {
      "id": "gunluk_enerji_ihtiyaci",
      "label": "Günlük Enerji İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Solar Akü Sistemi Kurulumu"],
      "options": [
        "Düşük (Temel cihazlar)",
        "Orta (Buzdolabı + elektronikler)",
        "Yüksek (Klima + yoğun kullanım)",
        "Bilmiyorum / Keşif gerekli"
      ]
    },
    {
      "id": "mevcut_sistem",
      "label": "Mevcut Sistem Var mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Solar Akü Sistemi Kurulumu"],
      "options": [
        "Güneş paneli var",
        "Yeni kurulum yapılacak",
        "Hibrit sisteme dönüşüm"
      ]
    },
    {
      "id": "aku_tipi",
      "label": "Akü Tipi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Solar Akü Sistemi Kurulumu"],
      "options": [
        "Jel Akü",
        "AGM Akü",
        "Lityum Akü",
        "Ustanın belirlemesi"
      ]
    },

    // ==========================================
    // 2) LİTYUM AKÜ SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "kullanim_amaci_lityum",
      "label": "Kullanım Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Lityum Akü Sistemi Kurulumu"],
      "options": [
        "Ev sistemi",
        "Güneş enerji sistemi",
        "Endüstriyel kullanım",
        "UPS destek sistemi",
        "Off-grid sistem"
      ]
    },
    {
      "id": "sistem_voltaj",
      "label": "Sistem Voltajı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Lityum Akü Sistemi Kurulumu"],
      "options": [
        "12V",
        "24V",
        "48V",
        "Bilmiyorum"
      ]
    },

    // ==========================================
    // 3) AKÜ DEĞİŞİMİ
    // ==========================================
    {
      "id": "mevcut_sistem_tipi",
      "label": "Mevcut Sistem Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü Değişimi"],
      "options": [
        "Solar sistem",
        "UPS sistemi",
        "Off-grid sistem",
        "Hibrit sistem",
        "Bilmiyorum"
      ]
    },
    {
      "id": "sorun_durumu",
      "label": "Sorun Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü Değişimi"],
      "options": [
        "Şarj tutmuyor",
        "Hızlı bitiyor",
        "Isınma sorunu",
        "Voltaj düşüklüğü",
        "Tamamen arızalı"
      ]
    },

    // ==========================================
    // 4) AKÜ BAKIM VE TEST HİZMETİ
    // ==========================================
    {
      "id": "test_nedeni",
      "label": "Test Nedeni",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü Bakım ve Test Hizmeti"],
      "options": [
        "Periyodik bakım",
        "Performans düşüklüğü",
        "Arıza şüphesi",
        "Kurulum sonrası kontrol"
      ]
    },

    // ==========================================
    // 5) ENERJİ DEPOLAMA ÜNİTESİ KURULUMU
    // ==========================================
    {
      "id": "sistem_tipi",
      "label": "Sistem Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Enerji Depolama Ünitesi Kurulumu"],
      "options": [
        "Ev tipi",
        "Ticari",
        "Endüstriyel",
        "Tarımsal"
      ]
    },

    // ==========================================
    // 6) BMS (BATARYA YÖNETİM SİSTEMİ) KURULUMU
    // ==========================================
    {
      "id": "batarya_tipi_bms",
      "label": "Batarya Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["BMS (Batarya Yönetim Sistemi) Kurulumu"],
      "options": [
        "Lityum",
        "Jel",
        "AGM",
        "Bilmiyorum"
      ]
    },

    // ==========================================
    // 7) UPS SİSTEMLERİ KURULUMU
    // ==========================================
    {
      "id": "kullanim_alani_ups",
      "label": "Kullanım Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["UPS Sistemleri Kurulumu"],
      "options": [
        "Ev",
        "Ofis",
        "Server odası",
        "Hastane / Klinik",
        "Endüstriyel tesis"
      ]
    },

    // ==========================================
    // 8) OFF-GRID ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "sebeke_durumu",
      "label": "Şebeke Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Off-Grid Enerji Sistemi Kurulumu"],
      "options": [
        "Hiç yok",
        "Zayıf / kesintili",
        "Tam bağımsız isteniyor"
      ]
    },

    // ==========================================
    // 9) HİBRİT ENERJİ SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "enerji_kaynaklari",
      "label": "Enerji Kaynakları",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Hibrit Enerji Sistemi Kurulumu"],
      "options": [
        "Güneş + Akü",
        "Şebeke + Akü",
        "Güneş + Şebeke + Akü",
        "Jeneratör destekli"
      ]
    },

    // ==========================================
    // 10) YEDEK GÜÇ SİSTEMİ KURULUMU
    // ==========================================
    {
      "id": "yedekleme_amaci",
      "label": "Kullanım Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Yedek Güç Sistemi Kurulumu"],
      "options": [
        "Elektrik kesintisi koruması",
        "Kritik cihazlar",
        "Tüm ev sistemi",
        "İşletme yedekleme"
      ]
    },
  ];
}