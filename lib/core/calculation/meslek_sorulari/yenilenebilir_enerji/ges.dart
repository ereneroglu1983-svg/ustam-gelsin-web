// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/ges.dart

class GesSorulari{
    static final List<Map<String, dynamic>> sorular = [
        {
            "id": "is_turu",
            "label": "Yapılacak Güneş Enerji Sistemi Türü",
            "type": "single",
            "required": true,
            "options": [
                "Güneş Paneli Kurulumu",
                "Arazi GES Kurulumu",
                "Tarımsal Sulama GES Kurulumu",
                "Güneş Paneli Söküm ve Taşıma",
                "Güneş Paneli Bakım ve Temizliği",
                "Güneş Paneli Arıza Tespiti",
                "Güneş Paneli Performans Kontrolü",
                "İnverter Montajı",
                "İnverter Arıza ve Değişimi",
                "Solar Kablo ve Elektrik Tesisatı",
                "Panel Taşıyıcı Konstrüksiyon Montajı",
                "GES Projelendirme ve Danışmanlık"
            ]
        },

        // ==========================================
        // 1) GÜNEŞ PANELİ KURULUMU
        // ==========================================
        {
            "id": "kurulum_alan_turu",
            "label": "Kurulum Yapılacak Alan Türü Nedir?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "Konut Çatısı",
                "Villa / Müstakil Ev Çatısı",
                "İş Yeri / Fabrika Çatısı",
                "Tarımsal Arazi",
                "Açık Arazi",
                "Otopark Üstü GES",
                "Diğer"
            ]
        },
        {
            "id": "sistem_gucu",
            "label": "Yaklaşık Kurulmak İstenen Sistem Gücü Nedir?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "3 kW'a Kadar",
                "3 - 5 kW Arası",
                "5 - 10 kW Arası",
                "10 - 25 kW Arası",
                "25 - 50 kW Arası",
                "50 kW ve Üzeri",
                "Uzman Keşfi Gerekiyor"
            ]
        },
        {
            "id": "elektrik_abonelik",
            "label": "Elektrik Abonelik Tipi Nedir?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "Monofaze (Tek Faz)",
                "Trifaze (Üç Faz)",
                "Henüz Elektrik Aboneliği Yok",
                "Bilmiyorum"
            ]
        },
        {
            "id": "yapi_yuksekligi",
            "label": "Kurulum Yapılacak Yapı Yüksekliği Nedir?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "Tek Katlı Yapı",
                "2 Katlı Yapı",
                "3 - 5 Katlı Yapı",
                "5 Kat Üzeri Yapı",
                "Arazi Kurulumu Yapılacak"
            ]
        },
        {
            "id": "kurulum_sekli",
            "label": "Kurulum Şekli Nasıl Olacak?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "Sıfırdan Komple Sistem Kurulacak",
                "Mevcut Sisteme İlave Panel Eklenecek",
                "Eski Sistem Yenilenecek",
                "Uzman Keşfi Sonrası Belirlenecek"
            ]
        },
        {
            "id": "aku_sistemi",
            "label": "Enerji Depolama (Akü) Sistemi İstiyor Musunuz?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "Evet, Akülü Sistem İstiyorum",
                "Hayır, Şebeke Destekli Sistem İstiyorum",
                "Hibrit Sistem İstiyorum",
                "Ustanın Önerisine Göre Karar Vereceğim"
            ]
        },
        {
            "id": "inverter_tercihi",
            "label": "İnverter Tercihiniz Nedir?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "Standart On-Grid İnverter",
                "Hibrit İnverter",
                "Off-Grid İnverter",
                "Mevcut İnverter Kullanılacak",
                "Ustanın Önerisine Göre Belirlenecek"
            ]
        },
        {
            "id": "kesif_istegi",
            "label": "Kurulum Öncesi Keşif Yapılmasını İstiyor Musunuz?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "Evet Yerinde Keşif Yapılsın",
                "Hayır Fotoğraf Üzerinden Teklif Almak İstiyorum",
                "Önce Telefon Görüşmesi Yapmak İstiyorum"
            ]
        },
        {
            "id": "ek_hizmetler",
            "label": "Ek Olarak Hangi Hizmetlere İhtiyacınız Var?",
            "type": "multi",
            "required": false,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "Projelendirme Hizmeti",
                "Resmi Başvuru İşlemleri",
                "TEDAŞ Süreç Desteği",
                "Çağrı Mektubu Danışmanlığı",
                "Teşvik / Hibe Danışmanlığı",
                "Panel Temizlik Hizmeti",
                "Periyodik Bakım Hizmeti",
                "Sigorta Danışmanlığı"
            ]
        },
        {
            "id": "arac_erisim",
            "label": "Kurulum Alanına Araç Erişimi Nasıldır?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": [
                "Araç Doğrudan Alana Ulaşabiliyor",
                "Kısmi Erişim Var",
                "Vinç veya Özel Ekipman Gerekiyor",
                "Bilmiyorum"
            ]
        },

        // ==========================================
        // 2) ARAZİ GES KURULUMU
        // ==========================================
        {
            "id": "arazi_buyuklugu",
            "label": "Arazi Büyüklüğü",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Arazi GES Kurulumu"],
            "options": [
                "0 - 500 m²",
                "500 - 1.000 m²",
                "1.000 - 5.000 m²",
                "5.000 - 10.000 m²",
                "10.000 m² ve Üzeri",
                "Bilmiyorum"
            ]
        },
        {
            "id": "zemin_tipi",
            "label": "Zemin Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Arazi GES Kurulumu"],
            "options": [
                "Toprak",
                "Kayalık",
                "Beton",
                "Stabilize Dolgu Zemin",
                "Bilmiyorum"
            ]
        },
        {
            "id": "elektrik_hatti",
            "label": "Elektrik Hattı Mevcut mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Arazi GES Kurulumu"],
            "options": [
                "Evet, elektrik hattı mevcut",
                "Hayır, yeni hat çekilecek",
                "Bilmiyorum"
            ]
        },
        {
            "id": "cevre_citi",
            "label": "Çevre Çiti Gerekiyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Arazi GES Kurulumu"],
            "options": [
                "Evet",
                "Hayır",
                "Ustanın Değerlendirmesine Göre"
            ]
        },
        {
            "id": "trafo_ihtiyaci",
            "label": "Trafo İhtiyacı Var mı?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Arazi GES Kurulumu"],
            "options": [
                "Evet",
                "Hayır",
                "Bilmiyorum",
                "Ustanın Belirlemesini İstiyorum"
            ]
        },

        // ==========================================
        // 3) TARIMSAL SULAMA GES KURULUMU
        // ==========================================
        {
            "id": "sulama_yontemi",
            "label": "Sulama Yöntemi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Tarımsal Sulama GES Kurulumu"],
            "options": [
                "Damlama Sulama",
                "Yağmurlama Sulama",
                "Salma Sulama",
                "Damla + Yağmurlama Karma Sistem",
                "Bilmiyorum"
            ]
        },
        {
            "id": "pompa_gucu",
            "label": "Pompa Gücü",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Tarımsal Sulama GES Kurulumu"],
            "options": [
                "1 - 5 HP",
                "5 - 10 HP",
                "10 - 20 HP",
                "20 HP ve Üzeri",
                "Bilmiyorum"
            ]
        },
        {
            "id": "kuyu_derinligi",
            "label": "Kuyu Derinliği",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Tarımsal Sulama GES Kurulumu"],
            "options": [
                "0 - 25 Metre",
                "25 - 50 Metre",
                "50 - 100 Metre",
                "100 Metre ve Üzeri",
                "Kuyu Yok",
                "Bilmiyorum"
            ]
        },
        {
            "id": "elektrik_hatti_sulama",
            "label": "Elektrik Hattı Mevcut mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Tarımsal Sulama GES Kurulumu"],
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
            "dependsOnValue": ["Tarımsal Sulama GES Kurulumu"],
            "options": [
                "Sadece Yaz Sezonunda",
                "İlkbahar - Yaz Döneminde",
                "Tüm Yıl Sürekli Kullanım",
                "Ustanın Önerisine Göre"
            ]
        },

        // ==========================================
        // 4) GÜNEŞ PANELİ SÖKÜM VE TAŞIMA
        // ==========================================
        {
            "id": "panel_sayisi_sokum",
            "label": "Kaç Panel Sökülecek?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Söküm ve Taşıma"],
            "options": [
                "1 - 10 Adet",
                "10 - 25 Adet",
                "25 - 50 Adet",
                "50 - 100 Adet",
                "100 Adet ve Üzeri"
            ]
        },
        {
            "id": "tekrar_kurulum",
            "label": "Aynı Adrese Tekrar Kurulacak mı?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Söküm ve Taşıma"],
            "options": [
                "Evet",
                "Hayır",
                "Henüz Belli Değil"
            ]
        },
        {
            "id": "vinc_ihtiyaci",
            "label": "Vinç İhtiyacı Var mı?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Söküm ve Taşıma"],
            "options": [
                "Evet",
                "Hayır",
                "Ustanın Belirlemesini İstiyorum"
            ]
        },
        {
            "id": "cati_yuksekligi_sokum",
            "label": "Çatı Yüksekliği Nedir?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Söküm ve Taşıma"],
            "options": [
                "0 - 5 Metre",
                "5 - 10 Metre",
                "10 - 20 Metre",
                "20 Metre Üzeri",
                "Arazi Kurulumu"
            ]
        },

        // ==========================================
        // 5) GÜNEŞ PANELİ BAKIM VE TEMİZLİĞİ
        // ==========================================
        {
            "id": "panel_sayisi_bakim",
            "label": "Panel Sayısı",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Bakım ve Temizliği"],
            "options": [
                "1 - 10 Adet",
                "10 - 25 Adet",
                "25 - 50 Adet",
                "50 - 100 Adet",
                "100 Adet ve Üzeri"
            ]
        },
        {
            "id": "son_bakim_tarihi",
            "label": "Son Bakım Tarihi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Bakım ve Temizliği"],
            "options": [
                "Son 6 Ay İçinde",
                "Son 1 Yıl İçinde",
                "1 Yıldan Uzun Süredir Yapılmadı",
                "İlk Kez Bakım Yapılacak",
                "Bilmiyorum"
            ]
        },
        {
            "id": "yuksekte_calisma",
            "label": "Yüksekte Çalışma Gerekiyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Bakım ve Temizliği"],
            "options": [
                "Evet",
                "Hayır",
                "Bilmiyorum"
            ]
        },
        {
            "id": "termal_kamera",
            "label": "Termal Kamera Kontrolü İsteniyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Bakım ve Temizliği"],
            "options": [
                "Evet",
                "Hayır",
                "Ustanın Önerisine Göre"
            ]
        },

        // ==========================================
        // 6) GÜNEŞ PANELİ ARIZA TESPİTİ
        // ==========================================
        {
            "id": "ariza_tipi",
            "label": "Sorun Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Arıza Tespiti"],
            "options": [
                "Enerji Üretmiyor",
                "Düşük Enerji Üretiyor",
                "İnverter Hata Veriyor",
                "Sigorta Atıyor",
                "Sistem Sık Sık Kapanıyor",
                "Panel Hasarı Var",
                "Diğer"
            ]
        },
        {
            "id": "ariza_suresi",
            "label": "Arıza Ne Zamandır Mevcut?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Arıza Tespiti"],
            "options": [
                "Son 24 Saat İçinde",
                "Son 1 Hafta İçinde",
                "Son 1 Ay İçinde",
                "Uzun Süredir Devam Ediyor",
                "Bilmiyorum"
            ]
        },

        // ==========================================
        // 7) GÜNEŞ PANELİ PERFORMANS KONTROLÜ
        // ==========================================
        {
            "id": "termal_analiz",
            "label": "Termal Analiz İsteniyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Performans Kontrolü"],
            "options": [
                "Evet",
                "Hayır"
            ]
        },
        {
            "id": "drone_kontrol",
            "label": "Drone ile Kontrol İsteniyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Performans Kontrolü"],
            "options": [
                "Evet",
                "Hayır"
            ]
        },
        {
            "id": "performans_raporu",
            "label": "Performans Raporu İsteniyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Performans Kontrolü"],
            "options": [
                "Evet",
                "Hayır",
                "Detaylı Teknik Rapor İstiyorum"
            ]
        },

        // ==========================================
        // 8) İNVERTER MONTAJI
        // ==========================================
        {
            "id": "inverter_gucu",
            "label": "İnverter Gücü",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["İnverter Montajı"],
            "options": [
                "1 - 3 kW",
                "3 - 5 kW",
                "5 - 10 kW",
                "10 - 25 kW",
                "25 kW ve Üzeri",
                "Bilmiyorum"
            ]
        },
        {
            "id": "inverter_marka",
            "label": "Marka",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["İnverter Montajı"],
            "options": [
                "Huawei",
                "Fronius",
                "GoodWe",
                "Solis",
                "SMA",
                "Growatt",
                "Diğer",
                "Henüz Satın Alınmadı"
            ]
        },
        {
            "id": "inverter_tipi",
            "label": "İnverter Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["İnverter Montajı"],
            "options": [
                "Hibrit",
                "On-Grid",
                "Off-Grid",
                "Bilmiyorum"
            ]
        },
        {
            "id": "montaj_yuzeyi",
            "label": "Montaj Yapılacak Yüzey",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["İnverter Montajı"],
            "options": [
                "Beton Duvar",
                "Tuğla Duvar",
                "Çelik Konstrüksiyon",
                "Pano İçi Montaj",
                "Diğer"
            ]
        },

        // ==========================================
        // 9) İNVERTER ARIZA VE DEĞİŞİMİ
        // ==========================================
        {
            "id": "inverter_calisma_durumu",
            "label": "İnverter Çalışıyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["İnverter Arıza ve Değişimi"],
            "options": [
                "Hiç Çalışmıyor",
                "Çalışıyor Ancak Hata Veriyor",
                "Aralıklı Çalışıyor",
                "Bilmiyorum"
            ]
        },
        {
            "id": "hata_kodu",
            "label": "Hata Kodu Var mı?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["İnverter Arıza ve Değişimi"],
            "options": [
                "Evet",
                "Hayır",
                "Bilmiyorum"
            ]
        },
        {
            "id": "inverter_marka_model",
            "label": "Marka / Model",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["İnverter Arıza ve Değişimi"],
            "options": [
                "Huawei",
                "Fronius",
                "GoodWe",
                "Solis",
                "SMA",
                "Growatt",
                "Diğer",
                "Bilmiyorum"
            ]
        },

        // ==========================================
        // 10) SOLAR KABLO VE ELEKTRİK TESİSATI
        // ==========================================
        {
            "id": "kablo_mesafesi",
            "label": "Kablo Mesafesi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Solar Kablo ve Elektrik Tesisatı"],
            "options": [
                "0 - 10 Metre",
                "10 - 25 Metre",
                "25 - 50 Metre",
                "50 - 100 Metre",
                "100 Metre ve Üzeri"
            ]
        },
        {
            "id": "tesisat_tipi",
            "label": "Tesisat Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Solar Kablo ve Elektrik Tesisatı"],
            "options": [
                "AC Tesisat",
                "DC Tesisat",
                "AC + DC Tesisat",
                "Bilmiyorum"
            ]
        },
        {
            "id": "kanal_acma",
            "label": "Kanal Açılması Gerekiyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Solar Kablo ve Elektrik Tesisatı"],
            "options": [
                "Evet",
                "Hayır",
                "Ustanın Değerlendirmesine Göre"
            ]
        },

        // ==========================================
        // 11) PANEL TAŞIYICI KONSTRÜKSİYON MONTAJI
        // ==========================================
        {
            "id": "konstruksiyon_cati_tipi",
            "label": "Çatı Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Panel Taşıyıcı Konstrüksiyon Montajı"],
            "options": [
                "Kiremit Çatı",
                "Sandviç Panel Çatı",
                "Beton Çatı",
                "Trapez Sac Çatı",
                "Arazi Kurulumu"
            ]
        },
        {
            "id": "konstruksiyon_malzeme",
            "label": "Konstrüksiyon Malzemesi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Panel Taşıyıcı Konstrüksiyon Montajı"],
            "options": [
                "Galvaniz Çelik",
                "Alüminyum",
                "Ustanın Önerisine Göre"
            ]
        },
        {
            "id": "montaj_tipi",
            "label": "Montaj Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Panel Taşıyıcı Konstrüksiyon Montajı"],
            "options": [
                "Çatı Montajı",
                "Arazi Montajı",
                "Otopark Üstü Montaj"
            ]
        },

        // ==========================================
        // 12) GES PROJELENDİRME VE DANIŞMANLIK
        // ==========================================
        {
            "id": "proje_amaci",
            "label": "Proje Amacı",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["GES Projelendirme ve Danışmanlık"],
            "options": [
                "Mahsuplaşmalı Sistem",
                "Öz Tüketim Amaçlı",
                "Tarımsal Sulama",
                "Ticari Amaçlı",
                "Endüstriyel Kullanım"
            ]
        },
        {
            "id": "kesif_isteniyor",
            "label": "Keşif İsteniyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["GES Projelendirme ve Danışmanlık"],
            "options": [
                "Evet",
                "Hayır"
            ]
        },
        {
            "id": "tesvik_danismanligi",
            "label": "Teşvik Danışmanlığı İsteniyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["GES Projelendirme ve Danışmanlık"],
            "options": [
                "Evet",
                "Hayır"
            ]
        },
        {
            "id": "resmi_surec_destegi",
            "label": "Resmi Süreç Desteği İsteniyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["GES Projelendirme ve Danışmanlık"],
            "options": [
                "Evet",
                "Hayır",
                "Tüm Süreç Yönetilsin İstiyorum"
            ]
        },
    ];
}