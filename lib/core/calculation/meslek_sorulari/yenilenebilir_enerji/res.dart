// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/res.dart - FINAL
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

    // 1) RÜZGAR TÜRBİNİ KURULUMU
    {
      "id": "kurulum_alan_tipi",
      "label": "Kurulum Alan Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Rüzgar Türbini Kurulumu"],
      "options": ["Konut Alanı", "Villa Müstakil", "Tarımsal Arazi", "İşletme Fabrika", "Açık Arazi", "Dağlık Yüksek Rakım"]
    },
    {
      "id": "sistem_gucu",
      "label": "Planlanan Sistem Gücü",
      "type": "single",
      "required": true,
      "dependsOnId": "kurulum_alan_tipi",
      "options": ["1 kW'a Kadar", "1-5 kW", "5-10 kW", "10-50 kW", "50 kW Üzeri"]
    },
    {
      "id": "elektrik_baglanti_tipi",
      "label": "Elektrik Bağlantı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "sistem_gucu",
      "options": ["On-Grid Şebeke Bağlantılı", "Off-Grid Akülü Sistem", "Hibrit Sistem"]
    },
    {
      "id": "kule_yuksekligi",
      "label": "Kule Yüksekliği Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "elektrik_baglanti_tipi",
      "options": ["5-10 Metre", "10-20 Metre", "20-30 Metre", "30 Metre Üzeri"]
    },
    {
      "id": "zemin_etudu",
      "label": "Zemin Etüdü / Ruhsat Var mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "kule_yuksekligi",
      "options": ["Evet Mevcut", "Hayır Yok Yeni Yapılacak", "Gerek Yok"]
    },
    {
      "id": "kesif_talebi",
      "label": "Yerinde Keşif İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_etudu",
      "options": ["Evet Keşif Yapılsın", "Hayır Fotoğraf Üzerinden Teklif"]
    },

    // 2) KÜÇÜK ÖLÇEKLİ
    {
      "id": "kullanim_yeri",
      "label": "Türbin Nerede Kullanılacak?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Küçük Ölçekli Rüzgar Türbini Kurulumu"],
      "options": ["Ev", "Yazlık", "Çiftlik", "Karavan", "Tiny House", "Tekne Yat"]
    },
    {
      "id": "gunluk_enerji_ihtiyaci",
      "label": "Günlük Enerji İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "kullanim_yeri",
      "options": ["Düşük Tüketim", "Orta Tüketim", "Yüksek Tüketim"]
    },
    {
      "id": "aku_sistemi",
      "label": "Akü Sistemi İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "gunluk_enerji_ihtiyaci",
      "options": ["Evet Akü Olsun", "Hayır Akü İstemiyorum"]
    },
    {
      "id": "hibrit_sistem",
      "label": "Güneş ile Hibrit Olsun mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "aku_sistemi",
      "options": ["Evet Hibrit Olsun", "Hayır Sadece Rüzgar"]
    },

    // 3) EV TİPİ
    {
      "id": "yapi_tipi",
      "label": "Yapı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Ev Tipi Rüzgar Türbini Kurulumu"],
      "options": ["Müstakil Ev", "Villa", "Yazlık", "Çiftlik Evi"]
    },
    {
      "id": "yapi_yuksekligi",
      "label": "Yapı Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tipi",
      "options": ["Tek Katlı", "2 Katlı", "3 Katlı", "4 Kat ve Üzeri"]
    },
    {
      "id": "montaj_yeri",
      "label": "Montaj Yeri",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_yuksekligi",
      "options": ["Çatı Üzeri", "Bahçe Alanı", "Direk Üzeri"]
    },
    {
      "id": "depolama_sistemi",
      "label": "Depolama İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_yeri",
      "options": ["Evet Depolama Olsun", "Hayır Depolama İstemiyorum"]
    },

    // 4) TARIMSAL
    {
      "id": "tarimsal_kullanim_amaci",
      "label": "Kullanım Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tarımsal Amaçlı Rüzgar Türbini Kurulumu"],
      "options": ["Sulama Sistemi", "Hayvancılık Tesisi", "Tarımsal Depo", "Sera Enerjisi", "Genel Elektrik"]
    },
    {
      "id": "tarim_alani",
      "label": "Tarım Alanı Büyüklüğü",
      "type": "single",
      "required": true,
      "dependsOnId": "tarimsal_kullanim_amaci",
      "options": ["0-5 Dönüm", "5-20 Dönüm", "20-50 Dönüm", "50 Dönüm Üzeri"]
    },
    {
      "id": "elektrik_hatti",
      "label": "Elektrik Hattı Var mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "tarim_alani",
      "options": ["Evet Var", "Hayır Yok"]
    },
    {
      "id": "kullanim_sekli",
      "label": "Kullanım Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": "elektrik_hatti",
      "options": ["Mevsimlik", "Tüm Yıl Sürekli", "Dönemsel"]
    },

    // 5) BAKIM
    {
      "id": "turbin_tipi_bakim",
      "label": "Türbin Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Bakımı"],
      "options": ["Yatay Eksenli", "Dikey Eksenli"]
    },
    {
      "id": "son_bakim_tarihi",
      "label": "Son Bakım Ne Zaman?",
      "type": "single",
      "required": true,
      "dependsOnId": "turbin_tipi_bakim",
      "options": ["Son 6 Ay", "Son 1 Yıl", "1 Yıldan Uzun Süre", "Hiç Yapılmadı"]
    },
    {
      "id": "bakim_islemleri",
      "label": "Yapılacak Bakım İşlemleri",
      "type": "multi",
      "required": true,
      "dependsOnId": "son_bakim_tarihi",
      "options": ["Kanat Kontrolü", "Jeneratör Kontrolü", "Elektrik Kontrolü", "Mekanik Kontrol", "Yağlama", "Genel Periyodik Bakım"]
    },
    {
      "id": "yuksekte_calisma",
      "label": "Yüksekte Çalışma Var mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "bakim_islemleri",
      "options": ["Evet Yüksekte Çalışma Var", "Hayır Yok"]
    },

    // 6) ARIZA
    {
      "id": "ariza_turu",
      "label": "Arıza Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Arıza Tespiti"],
      "options": ["Dönmüyor", "Düşük Enerji Üretiyor", "Aşırı Ses", "Titreşim Var", "Elektrik Üretmiyor", "Kontrol Ünitesi Hata", "Jeneratör Arızası"]
    },
    {
      "id": "turbin_durumu",
      "label": "Türbin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "ariza_turu",
      "options": ["Tamamen Durdu", "Kısmen Çalışıyor", "Çalışıyor Ama Verimsiz"]
    },
    {
      "id": "ariza_suresi",
      "label": "Arıza Süresi",
      "type": "single",
      "required": true,
      "dependsOnId": "turbin_durumu",
      "options": ["Son 24 Saat", "Son 1 Hafta", "Son 1 Ay", "Uzun Süredir"]
    },

    // 7) SÖKÜM TAŞIMA
    {
      "id": "turbin_tipi_sokum",
      "label": "Türbin Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Türbin Söküm ve Taşıma"],
      "options": ["Küçük Ev Tipi", "Tarımsal Türbin", "Ticari Türbin", "Endüstriyel Türbin"]
    },
    {
      "id": "kule_yuksekligi_sokum",
      "label": "Kule Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "turbin_tipi_sokum",
      "options": ["0-10 Metre", "10-20 Metre", "20-30 Metre", "30 Metre Üzeri"]
    },
    {
      "id": "tekrar_kurulum",
      "label": "Tekrar Kurulacak mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "kule_yuksekligi_sokum",
      "options": ["Evet Aynı Adrese", "Evet Farklı Adrese", "Hayır Sadece Söküm"]
    },
    {
      "id": "vinc_ihtiyaci",
      "label": "Vinç Gerekiyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "tekrar_kurulum",
      "options": ["Evet Vinç Gerekiyor", "Hayır Gerekmez"]
    },

    // 8) JENERATÖR KONTROL
    {
      "id": "servis_ekipman",
      "label": "Servis Edilecek Ekipman",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Jeneratör ve Kontrol Ünitesi Servisi"],
      "options": ["Jeneratör", "Şarj Kontrol Cihazı", "İnverter", "Akü Sistemi", "Fren Sistemi", "Kontrol Panosu"]
    },
    {
      "id": "sorun_tipi_servis",
      "label": "Sorun Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "servis_ekipman",
      "options": ["Çalışmıyor", "Hata Veriyor", "Performans Düşük", "Periyodik Bakım Gerekli"]
    },
    {
      "id": "ekipman_yasi",
      "label": "Ekipman Yaşı",
      "type": "single",
      "required": true,
      "dependsOnId": "sorun_tipi_servis",
      "options": ["0-2 Yıl", "2-5 Yıl", "5-10 Yıl", "10 Yıl Üzeri"]
    },

    // 9) DİREK KULE
    {
      "id": "montaj_tipi",
      "label": "Montaj Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Direk ve Kule Montajı"],
      "options": ["Yeni Kule Montajı", "Mevcut Kule Değişimi", "Kule Güçlendirme", "Direk Değişimi"]
    },
    {
      "id": "kule_tipi",
      "label": "Kule Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_tipi",
      "options": ["Galvaniz Çelik Kule", "Boru Tip Direk", "Kafes Tip Kule"]
    },
    {
      "id": "kule_yuksekligi_montaj",
      "label": "Kule Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "kule_tipi",
      "options": ["5-10 Metre", "10-20 Metre", "20-30 Metre", "30 Metre Üzeri"]
    },
    {
      "id": "zemin_tipi",
      "label": "Zemin Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "kule_yuksekligi_montaj",
      "options": ["Toprak Zemin", "Beton Zemin", "Kayalık Zemin"]
    },

    // 10) DANIŞMANLIK
    {
      "id": "danismanlik_konusu",
      "label": "Danışmanlık Konusu",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["RES Danışmanlık Hizmetleri"],
      "options": ["Sistem Tasarımı", "Yer Seçimi Analizi", "Rüzgar Ölçümü Fizibilite", "Projelendirme", "Resmi Süreç", "Teşvik Hibe Danışmanlığı", "Hibrit Sistem Danışmanlığı"]
    },
    {
      "id": "proje_amaci",
      "label": "Proje Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "danismanlik_konusu",
      "options": ["Konut Kullanımı", "Tarımsal Kullanım", "Ticari Kullanım", "Endüstriyel Kullanım"]
    },
    {
      "id": "yerinde_kesif",
      "label": "Yerinde Keşif",
      "type": "single",
      "required": true,
      "dependsOnId": "proje_amaci",
      "options": ["Evet Keşif İstiyorum", "Hayır İstemiyorum"]
    },
    {
      "id": "resmi_surec_destegi",
      "label": "Resmi Süreç + Teşvik İstiyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "yerinde_kesif",
      "options": ["Evet Her İkisi de Olsun", "Sadece Resmi Süreç", "Sadece Teşvik Danışmanlığı", "Hayır İkisi de İstenmiyor"]
    },
  ];
}