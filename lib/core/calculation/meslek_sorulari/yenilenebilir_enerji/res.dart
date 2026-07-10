// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/res.dart

class RESSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_turu",
      "label": "Yapılacak Rüzgar Enerji Sistemi Türü",
      "type": "single",
      "required": true,
      "options": [
        "Rüzgar Türbini Kurulumu",
        "Küçük Ölçekli Rüzgar Türbini Kurulumu",
        "Ev Tipi Rüzgar Türbini Kurulumu",
        "Tarımsal Amaçlı Rüzgar Türbini Kurulumu",
        "Türbin Bakımı",
        "Türbin Arıza Tespiti",
        "Türbin Söküm ve Taşıma",
        "Jeneratör ve Kontrol Ünitesi Servisi",
        "Direk ve Kule Montajı",
        "RES Danışmanlık Hizmetleri"
      ]
    },

    // ==========================================
    // 1) RÜZGAR TÜRBİNİ KURULUMU
    // ==========================================
    {
      "id": "kurulum_alan_tipi",
      "label": "Kurulum Yapılacak Alan Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Rüzgar Türbini Kurulumu"],
      "options": [
        "Konut Alanı",
        "Villa / Müstakil Ev",
        "Tarımsal Arazi",
        "İşletme / Fabrika",
        "Açık Arazi",
        "Dağlık / Yüksek Rakımlı Bölge",
        "Diğer"
      ]
    },
    {
      "id": "sistem_gucu",
      "label": "Kurulması Planlanan Sistem Gücü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Rüzgar Türbini Kurulumu"],
      "options": [
        "1 kW'a Kadar",
        "1 - 5 kW Arası",
        "5 - 10 kW Arası",
        "10 - 50 kW Arası",
        "50 kW ve Üzeri",
        "Uzman Keşfi Gerekiyor"
      ]
    },
    {
      "id": "elektrik_baglanti_tipi",
      "label": "Elektrik Bağlantı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Rüzgar Türbini Kurulumu"],
      "options": [
        "Şebeke Bağlantılı (On-Grid)",
        "Akülü Sistem (Off-Grid)",
        "Hibrit Sistem",
        "Bilmiyorum"
      ]
    },
    {
      "id": "kule_yuksekligi",
      "label": "Kule Yüksekliği Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Rüzgar Türbini Kurulumu"],
      "options": [
        "5 - 10 Metre",
        "10 - 20 Metre",
        "20 - 30 Metre",
        "30 Metre ve Üzeri",
        "Ustanın Belirlemesini İstiyorum"
      ]
    },
    {
      "id": "kesif_talebi",
      "label": "Keşif Yapılmasını İstiyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Rüzgar Türbini Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Ustanın Değerlendirmesine Göre"
      ]
    },

    // ==========================================
    // 2) KÜÇÜK ÖLÇEKLİ RÜZGAR TÜRBİNİ KURULUMU
    // ==========================================
    {
      "id": "kullanım_yeri",
      "label": "Türbin Nerede Kullanılacak?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Küçük Ölçekli Rüzgar Türbini Kurulumu"],
      "options": [
        "Ev",
        "Yazlık",
        "Çiftlik",
        "Karavan",
        "Tiny House",
        "Tekne / Yat"
      ]
    },
    {
      "id": "gunluk_enerji_ihtiyaci",
      "label": "Günlük Enerji İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Küçük Ölçekli Rüzgar Türbini Kurulumu"],
      "options": [
        "Düşük Tüketim",
        "Orta Tüketim",
        "Yüksek Tüketim",
        "Bilmiyorum"
      ]
    },
    {
      "id": "aku_sistemi",
      "label": "Akü Sistemi İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Küçük Ölçekli Rüzgar Türbini Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Ustanın Önerisine Göre"
      ]
    },
    {
      "id": "hibrit_sistem",
      "label": "Güneş Paneli ile Hibrit Sistem Düşünüyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Küçük Ölçekli Rüzgar Türbini Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Kararsızım"
      ]
    },

    // ==========================================
    // 3) EV TİPİ RÜZGAR TÜRBİNİ KURULUMU
    // ==========================================
    {
      "id": "yapi_tipi",
      "label": "Kurulum Yapılacak Yapı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Rüzgar Türbini Kurulumu"],
      "options": [
        "Müstakil Ev",
        "Villa",
        "Yazlık",
        "Çiftlik Evi"
      ]
    },
    {
      "id": "yapi_yuksekligi",
      "label": "Yapı Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Rüzgar Türbini Kurulumu"],
      "options": [
        "Tek Katlı",
        "2 Katlı",
        "3 Katlı",
        "4 Kat ve Üzeri"
      ]
    },
    {
      "id": "montaj_yeri",
      "label": "Türbin Montaj Yeri",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Rüzgar Türbini Kurulumu"],
      "options": [
        "Çatı Üzeri",
        "Bahçe Alanı",
        "Direk Üzeri",
        "Ustanın Önerisine Göre"
      ]
    },
    {
      "id": "depolama_sistemi",
      "label": "Enerji Depolama Sistemi İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Rüzgar Türbini Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Bilmiyorum"
      ]
    },

    // ==========================================
    // 4) TARIMSAL AMAÇLI RÜZGAR TÜRBİNİ KURULUMU
    // ==========================================
    {
      "id": "tarimsal_kullanim_amaci",
      "label": "Kullanım Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tarımsal Amaçlı Rüzgar Türbini Kurulumu"],
      "options": [
        "Sulama Sistemi",
        "Hayvancılık Tesisi",
        "Tarımsal Depo",
        "Sera Enerjisi",
        "Genel Elektrik İhtiyacı"
      ]
    },
    {
      "id": "tarim_alani",
      "label": "Tarım Alanı Büyüklüğü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tarımsal Amaçlı Rüzgar Türbini Kurulumu"],
      "options": [
        "0 - 5 Dönüm",
        "5 - 20 Dönüm",
        "20 - 50 Dönüm",
        "50 Dönüm ve Üzeri"
      ]
    },
    {
      "id": "elektrik_hatti",
      "label": "Elektrik Hattı Mevcut mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tarımsal Amaçlı Rüzgar Türbini Kurulumu"],
      "options": [
        "Evet",
        "Hayır",
        "Bilmiyorum"
      ]
    },
    {
      "id": "kullanim_sekli",
      "label": "Kullanım Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tarımsal Amaçlı Rüzgar Türbini Kurulumu"],
      "options": [
        "Mevsimlik",
        "Tüm Yıl Sürekli",
        "Dönemsel"
      ]
    },

    // ==========================================
    // 5) TÜRBİN BAKIMI
    // ==========================================
    {
      "id": "turbin_tipi_bakim",
      "label": "Türbin Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Bakımı"],
      "options": [
        "Yatay Eksenli Türbin",
        "Dikey Eksenli Türbin",
        "Bilmiyorum"
      ]
    },
    {
      "id": "son_bakim_tarihi",
      "label": "Son Bakım Tarihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Bakımı"],
      "options": [
        "Son 6 Ay İçinde",
        "Son 1 Yıl İçinde",
        "1 Yıldan Uzun Süredir Yapılmadı",
        "İlk Defa Bakım Yapılacak",
        "Bilmiyorum"
      ]
    },
    {
      "id": "bakim_islemleri",
      "label": "Bakım Kapsamında Hangi İşlemler Yapılsın?",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Bakımı"],
      "options": [
        "Kanat Kontrolü",
        "Jeneratör Kontrolü",
        "Elektrik Kontrolü",
        "Mekanik Kontrol",
        "Yağlama İşlemleri",
        "Genel Periyodik Bakım"
      ]
    },
    {
      "id": "yuksekte_calisma",
      "label": "Yüksekte Çalışma Gerekiyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Bakımı"],
      "options": [
        "Evet",
        "Hayır",
        "Bilmiyorum"
      ]
    },

    // ==========================================
    // 6) TÜRBİN ARIZA TESPİTİ
    // ==========================================
    {
      "id": "ariza_turu",
      "label": "Arıza Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Arıza Tespiti"],
      "options": [
        "Türbin Dönmüyor",
        "Düşük Enerji Üretiyor",
        "Aşırı Ses Yapıyor",
        "Titreşim Oluşuyor",
        "Elektrik Üretmiyor",
        "Kontrol Ünitesi Hata Veriyor",
        "Jeneratör Arızası",
        "Diğer"
      ]
    },
    {
      "id": "ariza_suresi",
      "label": "Arıza Ne Zamandır Mevcut?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Arıza Tespiti"],
      "options": [
        "Son 24 Saat İçinde",
        "Son 1 Hafta İçinde",
        "Son 1 Ay İçinde",
        "Uzun Süredir Devam Ediyor"
      ]
    },
    {
      "id": "turbin_durumu",
      "label": "Türbin Tamamen Durmuş Durumda mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Arıza Tespiti"],
      "options": [
        "Evet",
        "Hayır",
        "Kısmen Çalışıyor"
      ]
    },

    // ==========================================
    // 7) TÜRBİN SÖKÜM VE TAŞIMA
    // ==========================================
    {
      "id": "turbin_tipi_sokum",
      "label": "Türbin Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Söküm ve Taşıma"],
      "options": [
        "Küçük Ev Tipi Türbin",
        "Tarımsal Türbin",
        "Ticari Türbin",
        "Endüstriyel Türbin"
      ]
    },
    {
      "id": "tekrar_kurulum",
      "label": "Türbin Tekrar Kurulacak mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Söküm ve Taşıma"],
      "options": [
        "Evet",
        "Hayır",
        "Henüz Karar Verilmedi"
      ]
    },
    {
      "id": "vinc_ihtiyaci",
      "label": "Vinç İhtiyacı Var mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Söküm ve Taşıma"],
      "options": [
        "Evet",
        "Hayır",
        "Ustanın Belirlemesini İstiyorum"
      ]
    },
    {
      "id": "kule_yuksekligi_sokum",
      "label": "Kule Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Söküm ve Taşıma"],
      "options": [
        "0 - 10 Metre",
        "10 - 20 Metre",
        "20 - 30 Metre",
        "30 Metre ve Üzeri"
      ]
    },

    // ==========================================
    // 8) JENERATÖR VE KONTROL ÜNİTESİ SERVİSİ
    // ==========================================
    {
      "id": "servis_ekipman",
      "label": "Servis Talep Edilen Ekipman",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Jeneratör ve Kontrol Ünitesi Servisi"],
      "options": [
        "Jeneratör",
        "Şarj Kontrol Cihazı",
        "İnverter",
        "Akü Sistemi",
        "Fren Sistemi",
        "Kontrol Panosu"
      ]
    },
    {
      "id": "sorun_tipi_servis",
      "label": "Sorun Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Jeneratör ve Kontrol Ünitesi Servisi"],
      "options": [
        "Çalışmıyor",
        "Hata Veriyor",
        "Performans Düşüklüğü",
        "Periyodik Bakım Gerekiyor"
      ]
    },
    {
      "id": "ekipman_yasi",
      "label": "Ekipman Yaşı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Jeneratör ve Kontrol Ünitesi Servisi"],
      "options": [
        "0 - 2 Yıl",
        "2 - 5 Yıl",
        "5 - 10 Yıl",
        "10 Yıl ve Üzeri",
        "Bilmiyorum"
      ]
    },

    // ==========================================
    // 9) DİREK VE KULE MONTAJI
    // ==========================================
    {
      "id": "montaj_tipi",
      "label": "Montaj Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Direk ve Kule Montajı"],
      "options": [
        "Yeni Kule Montajı",
        "Mevcut Kule Değişimi",
        "Kule Güçlendirme",
        "Direk Değişimi"
      ]
    },
    {
      "id": "kule_tipi",
      "label": "Kule Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Direk ve Kule Montajı"],
      "options": [
        "Galvaniz Çelik Kule",
        "Boru Tip Direk",
        "Kafes Tip Kule",
        "Ustanın Önerisine Göre"
      ]
    },
    {
      "id": "kule_yuksekligi_montaj",
      "label": "Kule Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Direk ve Kule Montajı"],
      "options": [
        "5 - 10 Metre",
        "10 - 20 Metre",
        "20 - 30 Metre",
        "30 Metre ve Üzeri"
      ]
    },
    {
      "id": "zemin_tipi",
      "label": "Zemin Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Direk ve Kule Montajı"],
      "options": [
        "Toprak",
        "Beton",
        "Kayalık",
        "Bilmiyorum"
      ]
    },

    // ==========================================
    // 10) RES DANIŞMANLIK HİZMETLERİ
    // ==========================================
    {
      "id": "danismanlik_konusu",
      "label": "Danışmanlık Konusu",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["RES Danışmanlık Hizmetleri"],
      "options": [
        "Sistem Tasarımı",
        "Yer Seçimi Analizi",
        "Rüzgar Ölçümü ve Fizibilite",
        "Projelendirme",
        "Resmi Süreç Desteği",
        "Teşvik ve Hibe Danışmanlığı",
        "Hibrit Sistem Danışmanlığı"
      ]
    },
    {
      "id": "proje_amaci",
      "label": "Proje Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["RES Danışmanlık Hizmetleri"],
      "options": [
        "Konut Kullanımı",
        "Tarımsal Kullanım",
        "Ticari Kullanım",
        "Endüstriyel Kullanım"
      ]
    },
    {
      "id": "yerinde_kesif",
      "label": "Yerinde Keşif İstiyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["RES Danışmanlık Hizmetleri"],
      "options": [
        "Evet",
        "Hayır"
      ]
    },
    {
      "id": "resmi_surec_destegi",
      "label": "Resmi Süreç Desteği İstiyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["RES Danışmanlık Hizmetleri"],
      "options": [
        "Evet",
        "Hayır"
      ]
    },
    {
      "id": "tesvik_danismanligi",
      "label": "Teşvik Danışmanlığı İstiyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["RES Danışmanlık Hizmetleri"],
      "options": [
        "Evet",
        "Hayır"
      ]
    },
  ];
}