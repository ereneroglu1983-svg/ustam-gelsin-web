// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/ges.dart - FINAL KURALA UYGUN
class GesSorulari {
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

        // 1) GÜNEŞ PANELİ KURULUMU - ZİNCİR
        {
            "id": "kurulum_alan_turu",
            "label": "Kurulum Yapılacak Alan Türü",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Kurulumu"],
            "options": ["Konut Çatısı", "Villa Müstakil Çatı", "İş Yeri Fabrika Çatısı", "Tarımsal Arazi", "Açık Arazi", "Otopark Üstü"]
        },
        {
            "id": "cati_kaplama_tipi",
            "label": "Çatı Kaplama Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "kurulum_alan_turu",
            "options": ["Kiremit Çatı", "Trapez Sac Çatı", "Sandviç Panel Çatı", "Beton Düz Çatı", "Membran Kaplı Çatı", "Çatı Yok Arazi Kurulumu"]
        },
        {
            "id": "sistem_gucu",
            "label": "Kurulacak Sistem Gücü",
            "type": "single",
            "required": true,
            "dependsOnId": "cati_kaplama_tipi",
            "options": ["3 kW'a Kadar", "3-5 kW Arası", "5-10 kW Arası", "10-25 kW Arası", "25-50 kW Arası", "50 kW ve Üzeri"]
        },
        {
            "id": "panel_adedi_ges",
            "label": "Panel Adedi",
            "type": "single",
            "required": true,
            "dependsOnId": "sistem_gucu",
            "options": ["10 Adete Kadar", "10-20 Adet", "20-40 Adet", "40-80 Adet", "80 Adet Üzeri", "Adet Hesaplansın"]
        },
        {
            "id": "elektrik_abonelik",
            "label": "Elektrik Abonelik Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "panel_adedi_ges",
            "options": ["Monofaze Tek Faz", "Trifaze Üç Faz", "Henüz Abonelik Mevcut Değil"]
        },
        {
            "id": "yapi_yuksekligi",
            "label": "Yapı Yüksekliği",
            "type": "single",
            "required": true,
            "dependsOnId": "elektrik_abonelik",
            "options": ["Tek Katlı", "2 Katlı", "3-5 Katlı", "5 Kat Üzeri", "Arazi Kurulumu Yüksekliğe Gerek Yok"]
        },
        {
            "id": "kurulum_sekli",
            "label": "Kurulum Şekli",
            "type": "single",
            "required": true,
            "dependsOnId": "yapi_yuksekligi",
            "options": ["Sıfırdan Komple Kurulum", "Mevcut Sisteme İlave", "Eski Sistem Yenilenecek"]
        },
        {
            "id": "aku_sistemi",
            "label": "Akü Sistemi İstiyor musunuz?",
            "type": "single",
            "required": true,
            "dependsOnId": "kurulum_sekli",
            "options": ["Evet Akülü Sistem Olsun", "Hayır Şebeke Destekli Olsun", "Hibrit Sistem Olsun", "Akü İstemiyorum"]
        },
        {
            "id": "inverter_tercihi",
            "label": "İnverter Tercihi",
            "type": "single",
            "required": true,
            "dependsOnId": "aku_sistemi",
            "options": ["On-Grid İnverter", "Hibrit İnverter", "Off-Grid İnverter", "Mevcut İnverter Kullanılacak"]
        },
        {
            "id": "arac_erisim",
            "label": "Alana Araç Erişimi",
            "type": "single",
            "required": true,
            "dependsOnId": "inverter_tercihi",
            "options": ["Araç Doğrudan Ulaşıyor", "Kısmi Erişim Var", "Vinç Gerekiyor", "Erişim Yok El Taşıması Gerekir"]
        },
        {
            "id": "ek_hizmetler",
            "label": "Ek Hizmet İhtiyaçları",
            "type": "multi",
            "required": false,
            "dependsOnId": "arac_erisim",
            "options": ["Projelendirme", "Resmi Başvuru TEDAŞ", "Teşvik Hibe Danışmanlığı", "Bakım Temizlik Anlaşması", "Sigorta Danışmanlığı", "Ek Hizmet İstemiyorum"]
        },

        // 2) ARAZİ GES
        {
            "id": "arazi_buyuklugu",
            "label": "Arazi Büyüklüğü",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Arazi GES Kurulumu"],
            "options": ["0-500 m²", "500-1000 m²", "1000-5000 m²", "5000-10000 m²", "10000 m² Üzeri"]
        },
        {
            "id": "zemin_tipi",
            "label": "Zemin Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "arazi_buyuklugu",
            "options": ["Toprak Zemin", "Kayalık Zemin", "Beton Zemin", "Dolgu Zemin"]
        },
        {
            "id": "elektrik_hatti",
            "label": "Elektrik Hattı Mevcut mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "zemin_tipi",
            "options": ["Evet Hat Mevcut", "Hayır Yeni Hat Çekilecek"]
        },
        {
            "id": "cevre_citi",
            "label": "Çevre Çiti Gerekiyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "elektrik_hatti",
            "options": ["Evet Çit Gerekiyor", "Hayır Çit İstemiyorum", "Çit Mevcut"]
        },
        {
            "id": "trafo_ihtiyaci",
            "label": "Trafo İhtiyacı",
            "type": "single",
            "required": true,
            "dependsOnId": "cevre_citi",
            "options": ["Evet Trafo Gerekiyor", "Hayır Trafo Gerekmez"]
        },

        // 3) TARIMSAL SULAMA
        {
            "id": "sulama_yontemi",
            "label": "Sulama Yöntemi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Tarımsal Sulama GES Kurulumu"],
            "options": ["Damlama Sulama", "Yağmurlama Sulama", "Salma Sulama", "Karma Sistem"]
        },
        {
            "id": "pompa_gucu",
            "label": "Pompa Gücü",
            "type": "single",
            "required": true,
            "dependsOnId": "sulama_yontemi",
            "options": ["1-5 HP", "5-10 HP", "10-20 HP", "20 HP Üzeri"]
        },
        {
            "id": "kuyu_derinligi",
            "label": "Kuyu Derinliği",
            "type": "single",
            "required": true,
            "dependsOnId": "pompa_gucu",
            "options": ["0-25 Metre", "25-50 Metre", "50-100 Metre", "100 Metre Üzeri", "Kuyu Mevcut Değil"]
        },
        {
            "id": "elektrik_hatti_sulama",
            "label": "Elektrik Hattı Var mı?",
            "type": "single",
            "required": true,
            "dependsOnId": "kuyu_derinligi",
            "options": ["Evet Var", "Hayır Yok"]
        },
        {
            "id": "kullanim_sekli",
            "label": "Kullanım Dönemi",
            "type": "single",
            "required": true,
            "dependsOnId": "elektrik_hatti_sulama",
            "options": ["Sadece Yaz", "İlkbahar Yaz", "Yıl Boyu Sürekli"]
        },

        // 4) SÖKÜM TAŞIMA
        {
            "id": "panel_sayisi_sokum",
            "label": "Sökülecek Panel Sayısı",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Söküm ve Taşıma"],
            "options": ["1-10 Adet", "10-25 Adet", "25-50 Adet", "50-100 Adet", "100+ Adet"]
        },
        {
            "id": "cati_yuksekligi_sokum",
            "label": "Mevcut Çatı Yüksekliği",
            "type": "single",
            "required": true,
            "dependsOnId": "panel_sayisi_sokum",
            "options": ["0-5 Metre", "5-10 Metre", "10-20 Metre", "20 Metre Üzeri", "Arazi Kurulumu"]
        },
        {
            "id": "tekrar_kurulum",
            "label": "Tekrar Kurulum Olacak mı?",
            "type": "single",
            "required": true,
            "dependsOnId": "cati_yuksekligi_sokum",
            "options": ["Evet Aynı Adrese Kurulacak", "Evet Farklı Adrese Kurulacak", "Hayır Sadece Söküm"]
        },
        {
            "id": "vinc_ihtiyaci",
            "label": "Vinç İhtiyacı",
            "type": "single",
            "required": true,
            "dependsOnId": "tekrar_kurulum",
            "options": ["Evet Vinç Gerekiyor", "Hayır Vinç Gerekmez"]
        },

        // 5) BAKIM TEMİZLİK
        {
            "id": "panel_sayisi_bakim",
            "label": "Panel Sayısı",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Bakım ve Temizliği"],
            "options": ["1-10 Adet", "10-25 Adet", "25-50 Adet", "50-100 Adet", "100+ Adet"]
        },
        {
            "id": "son_bakim_tarihi",
            "label": "Son Bakım Ne Zaman Yapıldı?",
            "type": "single",
            "required": true,
            "dependsOnId": "panel_sayisi_bakim",
            "options": ["Son 6 Ay İçinde", "Son 1 Yıl İçinde", "1 Yıldan Uzun Süre Önce", "Hiç Bakım Yapılmadı"]
        },
        {
            "id": "yuksekte_calisma",
            "label": "Yüksekte Çalışma Gerekiyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "son_bakim_tarihi",
            "options": ["Evet Yüksekte Çalışma Var", "Hayır Zeminden Erişim Var"]
        },
        {
            "id": "termal_kamera",
            "label": "Termal Kamera Kontrolü",
            "type": "single",
            "required": true,
            "dependsOnId": "yuksekte_calisma",
            "options": ["Evet Termal Kontrol Olsun", "Hayır Sadece Temizlik Yeterli"]
        },

        // 6) ARIZA TESPİTİ
        {
            "id": "ariza_tipi",
            "label": "Sorun Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Arıza Tespiti"],
            "options": ["Enerji Üretmiyor", "Düşük Enerji Üretiyor", "İnverter Hata Veriyor", "Sigorta Atıyor", "Sistem Kapanıyor", "Panel Hasarı Var"]
        },
        {
            "id": "ariza_suresi",
            "label": "Arıza Ne Zamandır Var?",
            "type": "single",
            "required": true,
            "dependsOnId": "ariza_tipi",
            "options": ["Son 24 Saat", "Son 1 Hafta", "Son 1 Ay", "Uzun Süredir Var"]
        },

        // 7) PERFORMANS KONTROL
        {
            "id": "termal_analiz",
            "label": "Termal Analiz İsteniyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Güneş Paneli Performans Kontrolü"],
            "options": ["Evet İsteniyor", "Hayır İstenmiyor"]
        },
        {
            "id": "drone_kontrol",
            "label": "Drone ile Kontrol",
            "type": "single",
            "required": true,
            "dependsOnId": "termal_analiz",
            "options": ["Evet Drone Kullanılsın", "Hayır Gerek Yok"]
        },
        {
            "id": "performans_raporu",
            "label": "Rapor Talebi",
            "type": "single",
            "required": true,
            "dependsOnId": "drone_kontrol",
            "options": ["Sözlü Bilgilendirme Yeterli", "Yazılı Rapor İstiyorum", "Detaylı Teknik Rapor İstiyorum"]
        },

        // 8) İNVERTER MONTAJ
        {
            "id": "inverter_gucu",
            "label": "İnverter Gücü",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["İnverter Montajı"],
            "options": ["1-3 kW", "3-5 kW", "5-10 kW", "10-25 kW", "25 kW Üzeri"]
        },
        {
            "id": "inverter_marka",
            "label": "İnverter Markası",
            "type": "single",
            "required": true,
            "dependsOnId": "inverter_gucu",
            "options": ["Huawei", "Fronius", "GoodWe", "Solis", "SMA", "Growatt", "Marka Mevcut Değil Henüz Alınmadı"]
        },
        {
            "id": "inverter_tipi",
            "label": "İnverter Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "inverter_marka",
            "options": ["Hibrit İnverter", "On-Grid İnverter", "Off-Grid İnverter"]
        },
        {
            "id": "montaj_yuzeyi",
            "label": "Montaj Yüzeyi",
            "type": "single",
            "required": true,
            "dependsOnId": "inverter_tipi",
            "options": ["Beton Duvar", "Tuğla Duvar", "Çelik Konstrüksiyon", "Pano İçi Montaj"]
        },

        // 9) İNVERTER ARIZA
        {
            "id": "inverter_calisma_durumu",
            "label": "İnverter Çalışma Durumu",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["İnverter Arıza ve Değişimi"],
            "options": ["Hiç Çalışmıyor", "Hata Vererek Çalışıyor", "Aralıklı Çalışıyor"]
        },
        {
            "id": "hata_kodu",
            "label": "Ekranda Hata Kodu Var mı?",
            "type": "single",
            "required": true,
            "dependsOnId": "inverter_calisma_durumu",
            "options": ["Evet Hata Kodu Var", "Hayır Hata Kodu Yok"]
        },
        {
            "id": "inverter_marka_model",
            "label": "İnverter Markası",
            "type": "single",
            "required": true,
            "dependsOnId": "hata_kodu",
            "options": ["Huawei", "Fronius", "GoodWe", "Solis", "SMA", "Growatt", "Etiketi Okunmuyor"]
        },

        // 10) KABLO TESİSAT
        {
            "id": "kablo_mesafesi",
            "label": "Kablo Mesafesi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Solar Kablo ve Elektrik Tesisatı"],
            "options": ["0-10 Metre", "10-25 Metre", "25-50 Metre", "50-100 Metre", "100 Metre Üzeri"]
        },
        {
            "id": "tesisat_tipi",
            "label": "Tesisat Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "kablo_mesafesi",
            "options": ["AC Tesisat", "DC Tesisat", "AC + DC Tesisat"]
        },
        {
            "id": "kanal_acma",
            "label": "Kanal Açılması Gerekiyor mu?",
            "type": "single",
            "required": true,
            "dependsOnId": "tesisat_tipi",
            "options": ["Evet Kanal Açılacak", "Hayır Mevcut Kanal Kullanılacak", "Kanal Gerekmiyor"]
        },

        // 11) KONSTRÜKSİYON
        {
            "id": "konstruksiyon_cati_tipi",
            "label": "Çatı Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["Panel Taşıyıcı Konstrüksiyon Montajı"],
            "options": ["Kiremit Çatı", "Sandviç Panel Çatı", "Beton Çatı", "Trapez Sac Çatı", "Arazi Kurulumu"]
        },
        {
            "id": "konstruksiyon_malzeme",
            "label": "Konstrüksiyon Malzeme Tercihi",
            "type": "single",
            "required": true,
            "dependsOnId": "konstruksiyon_cati_tipi",
            "options": ["Galvaniz Çelik", "Alüminyum Konstrüksiyon"]
        },
        {
            "id": "montaj_tipi",
            "label": "Montaj Tipi",
            "type": "single",
            "required": true,
            "dependsOnId": "konstruksiyon_malzeme",
            "options": ["Çatı Montajı", "Arazi Montajı", "Otopark Üstü Montaj"]
        },

        // 12) PROJELENDİRME
        {
            "id": "proje_amaci",
            "label": "Proje Amacı",
            "type": "single",
            "required": true,
            "dependsOnId": "is_turu",
            "dependsOnValue": ["GES Projelendirme ve Danışmanlık"],
            "options": ["Mahsuplaşmalı Sistem", "Öz Tüketim", "Tarımsal Sulama", "Ticari Amaçlı", "Endüstriyel Kullanım"]
        },
        {
            "id": "kesif_isteniyor",
            "label": "Yerinde Keşif",
            "type": "single",
            "required": true,
            "dependsOnId": "proje_amaci",
            "options": ["Evet Keşif İstiyorum", "Hayır Keşif İstemiyorum"]
        },
        {
            "id": "tesvik_danismanligi",
            "label": "Teşvik Danışmanlığı",
            "type": "single",
            "required": true,
            "dependsOnId": "kesif_isteniyor",
            "options": ["Evet Teşvik Danışmanlığı İstiyorum", "Hayır İstemiyorum"]
        },
        {
            "id": "resmi_surec_destegi",
            "label": "Resmi Süreç Desteği",
            "type": "single",
            "required": true,
            "dependsOnId": "tesvik_danismanligi",
            "options": ["Evet Resmi Süreç Desteği İstiyorum", "Hayır İstemiyorum", "Tüm Süreç Yönetilsin"]
        },
    ];
}