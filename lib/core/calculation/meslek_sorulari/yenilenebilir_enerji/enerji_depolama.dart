// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/enerji_depolama.dart - KURALA UYGUN ZİNCİRLİ
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
        "BMS Kurulumu",
        "UPS Sistemleri Kurulumu",
        "Off-Grid Sistem Kurulumu",
        "Hibrit Sistem Kurulumu",
        "Yedek Güç Sistemi Kurulumu"
      ]
    },

    // 1) SOLAR AKÜ
    {
      "id": "kullanim_yeri_solar",
      "label": "Sistem Nerede Kullanılacak?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Solar Akü Sistemi Kurulumu"],
      "options": ["Konut Ev Villa", "Yazlık", "Çiftlik", "İşletme", "Karavan Tiny House", "Off-Grid Arazi"]
    },
    {
      "id": "gunluk_ihtiyac_solar",
      "label": "Günlük Enerji İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "kullanim_yeri_solar",
      "options": ["Düşük - Aydınlatma Temel Cihazlar", "Orta - Buzdolabı Elektronik", "Yüksek - Klima Yoğun Kullanım"]
    },
    {
      "id": "mevcut_sistem_solar",
      "label": "Mevcut Güneş Paneli Var mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "gunluk_ihtiyac_solar",
      "options": ["Evet Panel Mevcut", "Hayır Yeni Kurulacak", "Hibrit Sisteme Dönüşecek"]
    },
    {
      "id": "aku_tipi_solar",
      "label": "Akü Tipi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "mevcut_sistem_solar",
      "options": ["Jel Akü", "AGM Akü", "Lityum Akü", "Kurşun Asit Akü"]
    },
    {
      "id": "kapasite_solar",
      "label": "İstenen Akü Kapasitesi",
      "type": "single",
      "required": true,
      "dependsOnId": "aku_tipi_solar",
      "options": ["100Ah ve Altı", "100Ah - 200Ah", "200Ah - 400Ah", "400Ah Üzeri", "Hesaplansın"]
    },

    // 2) LİTYUM
    {
      "id": "kullanim_amaci_lityum",
      "label": "Kullanım Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Lityum Akü Sistemi Kurulumu"],
      "options": ["Ev Sistemi", "Güneş Enerji Depolama", "Endüstriyel Kullanım", "UPS Destek"]
    },
    {
      "id": "voltaj_lityum",
      "label": "Sistem Voltajı",
      "type": "single",
      "required": true,
      "dependsOnId": "kullanim_amaci_lityum",
      "options": ["12V Sistem", "24V Sistem", "48V Sistem", "Yüksek Voltaj 100V+"]
    },
    {
      "id": "kapasite_lityum",
      "label": "Kapasite İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "voltaj_lityum",
      "options": ["5 kWh Altı", "5-10 kWh", "10-20 kWh", "20 kWh Üzeri"]
    },

    // 3) AKÜ DEĞİŞİMİ
    {
      "id": "mevcut_tip_degisim",
      "label": "Mevcut Sistem Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü Değişimi"],
      "options": ["Solar Sistem", "UPS Sistemi", "Off-Grid Sistem", "Hibrit Sistem"]
    },
    {
      "id": "sorun_degisim",
      "label": "Mevcut Akü Sorunu Nedir?",
      "type": "single",
      "required": true,
      "dependsOnId": "mevcut_tip_degisim",
      "options": ["Şarj Tutmuyor", "Hızlı Bitiyor", "Isınma Yapıyor", "Voltaj Düşüklüğü", "Tamamen Arızalı"]
    },
    {
      "id": "adet_degisim",
      "label": "Değişecek Akü Adedi",
      "type": "single",
      "required": true,
      "dependsOnId": "sorun_degisim",
      "options": ["1 Adet", "2 Adet", "4 Adet", "6+ Adet"]
    },

    // 4) BAKIM TEST
    {
      "id": "test_nedeni",
      "label": "Bakım / Test Nedeni",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü Bakım ve Test Hizmeti"],
      "options": ["Periyodik Bakım", "Performans Düşüklüğü", "Arıza Şüphesi", "Kurulum Sonrası Kontrol"]
    },
    {
      "id": "sistem_sayisi_test",
      "label": "Test Edilecek Sistem Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "test_nedeni",
      "options": ["1 Sistem", "2-5 Sistem", "6+ Sistem"]
    },

    // 5) DEPOLAMA ÜNİTESİ
    {
      "id": "tip_depolama",
      "label": "Sistem Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Enerji Depolama Ünitesi Kurulumu"],
      "options": ["Ev Tipi", "Ticari İşletme", "Endüstriyel", "Tarımsal Sulama"]
    },
    {
      "id": "guc_depolama",
      "label": "Kurulu Güç İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "tip_depolama",
      "options": ["3 kW Altı", "3-10 kW", "10-50 kW", "50 kW Üzeri"]
    },

    // 6) BMS
    {
      "id": "batarya_tipi_bms",
      "label": "Batarya Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["BMS Kurulumu"],
      "options": ["Lityum Batarya", "Jel Batarya", "AGM Batarya"]
    },
    {
      "id": "hucre_sayisi_bms",
      "label": "Hücre / Seri Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "batarya_tipi_bms",
      "options": ["4S - 12V", "8S - 24V", "16S - 48V", "32S ve Üzeri"]
    },

    // 7) UPS
    {
      "id": "alan_ups",
      "label": "Kullanım Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["UPS Sistemleri Kurulumu"],
      "options": ["Ev Ofis", "Server Odası", "Hastane Klinik", "Endüstriyel Tesis"]
    },
    {
      "id": "guc_ups",
      "label": "UPS Gücü",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_ups",
      "options": ["1 kVA Altı", "1-3 kVA", "3-10 kVA", "10 kVA Üzeri"]
    },
    {
      "id": "sure_ups",
      "label": "Yedekleme Süresi İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "guc_ups",
      "options": ["15 Dakika", "30 Dakika", "1 Saat", "2 Saat ve Üzeri", "Yedekleme İstemiyorum Sadece Regülasyon"]
    },

    // 8) OFF-GRID
    {
      "id": "sebeke_offgrid",
      "label": "Şebeke Elektriği Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Off-Grid Sistem Kurulumu"],
      "options": ["Şebeke Hiç Yok", "Şebeke Zayıf Kesintili", "Tam Bağımsız Olmak İstiyorum"]
    },
    {
      "id": "kaynak_offgrid",
      "label": "Kullanılacak Enerji Kaynağı",
      "type": "multi",
      "required": true,
      "dependsOnId": "sebeke_offgrid",
      "options": ["Güneş Paneli", "Rüzgar Türbini", "Jeneratör Destekli", "Sadece Akü Sistemi Yok"]
    },

    // 9) HİBRİT
    {
      "id": "kaynak_hibrit",
      "label": "Birleştirilecek Enerji Kaynakları",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Hibrit Sistem Kurulumu"],
      "options": ["Güneş + Akü", "Şebeke + Akü", "Güneş + Şebeke + Akü", "Jeneratör Destekli Hibrit"]
    },
    {
      "id": "gecis_hibrit",
      "label": "Geçiş Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "kaynak_hibrit",
      "options": ["Otomatik Geçişli", "Manuel Geçişli"]
    },

    // 10) YEDEK GÜÇ
    {
      "id": "amac_yedek",
      "label": "Yedekleme Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Yedek Güç Sistemi Kurulumu"],
      "options": ["Elektrik Kesintisi Koruması", "Kritik Cihazlar İçin", "Tüm Ev Sistemi", "İşletme Yedekleme"]
    },
    {
      "id": "sure_yedek",
      "label": "Yedekleme Süresi",
      "type": "single",
      "required": true,
      "dependsOnId": "amac_yedek",
      "options": ["30 Dakikaya Kadar", "1-2 Saat", "4-8 Saat", "24 Saat ve Üzeri"]
    },
  ];
}