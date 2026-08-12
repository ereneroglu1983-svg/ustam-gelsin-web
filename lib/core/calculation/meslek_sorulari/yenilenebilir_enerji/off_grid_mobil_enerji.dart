// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/off_grid_mobil_enerji.dart - FINAL ZİNCİRLİ
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

    // 1) KARAVAN - ZİNCİR
    {
      "id": "karavan_tipi",
      "label": "Karavan Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Karavan Güneş Enerji Sistemi Kurulumu"],
      "options": ["Çekme Karavan", "Motokaravan", "Camper Van", "Tiny Camper"]
    },
    {
      "id": "karavan_uzunlugu",
      "label": "Karavan Uzunluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "karavan_tipi",
      "options": ["0-4 Metre", "4-6 Metre", "6-8 Metre", "8 Metre ve Üzeri"]
    },
    {
      "id": "panel_montaj_karavan",
      "label": "Panel Montaj Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "karavan_uzunlugu",
      "options": ["Tavan Üstü Sabit Montaj", "Portatif Katlanır Panel", "Hem Sabit Hem Portatif"]
    },
    {
      "id": "gunluk_enerji_tuketim",
      "label": "Günlük Tüketim Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "panel_montaj_karavan",
      "options": ["Düşük Aydınlatma Telefon Laptop", "Orta Buzdolabı TV", "Yüksek Klima Kahve Makinesi"]
    },
    {
      "id": "kullanilacak_cihazlar",
      "label": "Kullanılacak Cihazlar",
      "type": "multi",
      "required": true,
      "dependsOnId": "gunluk_enerji_tuketim",
      "options": ["Aydınlatma", "Buzdolabı", "Televizyon", "Klima", "Laptop", "Kahve Makinesi", "Su Pompası"]
    },
    {
      "id": "inverter_gucu_karavan",
      "label": "İstenen İnverter Gücü",
      "type": "single",
      "required": true,
      "dependsOnId": "kullanilacak_cihazlar",
      "options": ["1000W Altı", "1000W-2000W", "2000W-3000W", "3000W Üzeri", "Hesaplansın"]
    },
    {
      "id": "aku_kapasite_karavan",
      "label": "Akü Kapasitesi",
      "type": "single",
      "required": true,
      "dependsOnId": "inverter_gucu_karavan",
      "options": ["100Ah", "100-200Ah", "200-400Ah", "400Ah Üzeri", "Hesaplansın"]
    },
    {
      "id": "aku_tercihi_karavan",
      "label": "Akü Tipi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "aku_kapasite_karavan",
      "options": ["Jel Akü", "AGM Akü", "Lityum Akü"]
    },

    // 2) TINY HOUSE
    {
      "id": "tiny_house_kullanim",
      "label": "Kullanım Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tiny House Güneş Enerji Sistemi Kurulumu"],
      "options": ["Sürekli Yaşam", "Yazlık Kullanım", "Kiralama Amaçlı", "Dönemsel Kullanım"]
    },
    {
      "id": "yapi_buyuklugu",
      "label": "Yapı Büyüklüğü",
      "type": "single",
      "required": true,
      "dependsOnId": "tiny_house_kullanim",
      "options": ["0-20 m²", "20-40 m²", "40-60 m²", "60 m² Üzeri"]
    },
    {
      "id": "elektrik_sebekesi_mevcut",
      "label": "Şebeke Elektriği Mevcut mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_buyuklugu",
      "options": ["Evet Şebeke Var", "Hayır Şebeke Yok", "Yakın Mesafede Var Ama Bağlı Değil"]
    },
    {
      "id": "sistem_tipi_tiny",
      "label": "Sistem Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "elektrik_sebekesi_mevcut",
      "options": ["Tam Bağımsız Off-Grid", "Şebeke Destekli Hibrit"]
    },
    {
      "id": "enerji_depolama_isteniyor",
      "label": "Enerji Depolama İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "sistem_tipi_tiny",
      "options": ["Evet Akü Sistemi Olsun", "Hayır Sadece Gündüz Kullanım"]
    },

    // 3) BAĞ EVİ
    {
      "id": "bag_evi_kullanim",
      "label": "Kullanım Sıklığı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Bağ Evi Güneş Enerji Sistemi Kurulumu"],
      "options": ["Hafta Sonları", "Yaz Dönemi", "Tüm Yıl", "Nadiren"]
    },
    {
      "id": "elektrik_hatti_bag",
      "label": "Elektrik Hattı Var mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "bag_evi_kullanim",
      "options": ["Evet Var", "Hayır Yok", "Yakın Mesafede Var"]
    },
    {
      "id": "enerji_kullanim_amaci",
      "label": "Enerji Kullanım Amacı",
      "type": "multi",
      "required": true,
      "dependsOnId": "elektrik_hatti_bag",
      "options": ["Aydınlatma", "Buzdolabı", "Sulama", "Televizyon", "Klima", "Güvenlik Sistemi", "Su Pompası"]
    },
    {
      "id": "tahmini_gunluk_tuketim",
      "label": "Günlük Tüketim",
      "type": "single",
      "required": true,
      "dependsOnId": "enerji_kullanim_amaci",
      "options": ["Düşük Tüketim", "Orta Tüketim", "Yüksek Tüketim"]
    },
    {
      "id": "jenerator_destegi",
      "label": "Jeneratör Desteği Olsun mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "tahmini_gunluk_tuketim",
      "options": ["Evet Jeneratör Destekli Olsun", "Hayır Jeneratör İstemiyorum"]
    },

    // 4) YAYLA EVİ
    {
      "id": "yayla_ulasim",
      "label": "Ulaşım Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Yayla Evi Enerji Sistemi Kurulumu"],
      "options": ["Kolay Ulaşılabilir", "Zor Ulaşılabilir", "Arazi Aracı Gerekiyor"]
    },
    {
      "id": "yayla_kullanim_sekli",
      "label": "Kullanım Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": "yayla_ulasim",
      "options": ["Mevsimlik", "Yaz Dönemi", "Sürekli Kullanım"]
    },
    {
      "id": "iklim_kosullari",
      "label": "İklim Koşulları",
      "type": "single",
      "required": true,
      "dependsOnId": "yayla_kullanim_sekli",
      "options": ["Sert Kış Şartları", "Yoğun Kar Yağışı", "Rüzgarlı Bölge", "Ilıman Bölge"]
    },
    {
      "id": "enerji_kaynagi_tercihi",
      "label": "Enerji Kaynağı Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "iklim_kosullari",
      "options": ["Sadece Güneş", "Güneş + Rüzgar Hibrit", "Güneş + Jeneratör Hibrit"]
    },
    {
      "id": "sistemden_beklenti",
      "label": "Sistemden Beklenti",
      "type": "single",
      "required": true,
      "dependsOnId": "enerji_kaynagi_tercihi",
      "options": ["Temel Elektrik İhtiyacı", "Kesintisiz Enerji", "Tam Bağımsız Yaşam"]
    },

    // 5) TEKNE YAT
    {
      "id": "arac_tipi_tekne",
      "label": "Araç Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Tekne ve Yat Solar Sistemi Kurulumu"],
      "options": ["Balıkçı Teknesi", "Yelkenli", "Motor Yat", "Katamaran"]
    },
    {
      "id": "tekne_boyu",
      "label": "Tekne Boyu",
      "type": "single",
      "required": true,
      "dependsOnId": "arac_tipi_tekne",
      "options": ["0-8 Metre", "8-15 Metre", "15-25 Metre", "25 Metre Üzeri"]
    },
    {
      "id": "panel_montaj_tekne",
      "label": "Panel Montaj Yeri",
      "type": "single",
      "required": true,
      "dependsOnId": "tekne_boyu",
      "options": ["Güverte Üstü Sabit", "Tente Üstü Esnek Panel", "Portatif Panel"]
    },
    {
      "id": "kullanim_amaci_tekne",
      "label": "Kullanım Amacı",
      "type": "multi",
      "required": true,
      "dependsOnId": "panel_montaj_tekne",
      "options": ["Aydınlatma", "Navigasyon", "Buzdolabı", "Klima", "Haberleşme", "Yaşam Alanı"]
    },
    {
      "id": "aku_sistemi_mevcut",
      "label": "Mevcut Akü Sistemi Var mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "kullanim_amaci_tekne",
      "options": ["Evet Mevcut", "Hayır Yok Yeni Kurulacak"]
    },

    // 6) MOBİL ENERJİ
    {
      "id": "mobil_kullanim_yeri",
      "label": "Sistem Nerede Kullanılacak?",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Mobil Enerji Sistemleri Kurulumu"],
      "options": ["Karavan", "Tiny House", "Mobil Ofis", "Etkinlik Alanı", "Şantiye", "Tarımsal Arazi"]
    },
    {
      "id": "tasinabilirlik_onceligi",
      "label": "Taşınabilirlik Önceliği",
      "type": "single",
      "required": true,
      "dependsOnId": "mobil_kullanim_yeri",
      "options": ["Çok Önemli Taşınabilir Olsun", "Orta Seviye Yarı Mobil", "Sabit Sistem Olabilir"]
    },
    {
      "id": "enerji_ihtiyaci_mobil",
      "label": "Enerji İhtiyacı",
      "type": "single",
      "required": true,
      "dependsOnId": "tasinabilirlik_onceligi",
      "options": ["Düşük İhtiyaç", "Orta İhtiyaç", "Yüksek İhtiyaç"]
    },
    {
      "id": "sistemin_kullanim_amaci",
      "label": "Kullanım Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "enerji_ihtiyaci_mobil",
      "options": ["Acil Durum Enerjisi", "Sürekli Kullanım", "Yedek Enerji", "Ticari Kullanım"]
    },

    // 7) BAKIM ONARIM
    {
      "id": "sorun_tipi_offgrid",
      "label": "Yaşanan Sorun",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Off-Grid Sistem Bakım ve Onarımı"],
      "options": ["Enerji Üretmiyor", "Aküler Şarj Olmuyor", "İnverter Çalışmıyor", "Düşük Performans", "Sistem Kapanıyor", "Hata Kodu Veriyor"]
    },
    {
      "id": "sistem_yasi",
      "label": "Sistem Yaşı",
      "type": "single",
      "required": true,
      "dependsOnId": "sorun_tipi_offgrid",
      "options": ["0-2 Yıl", "2-5 Yıl", "5-10 Yıl", "10 Yıl Üzeri"]
    },
    {
      "id": "acil_servis",
      "label": "Acil Servis Gerekli mi?",
      "type": "single",
      "required": true,
      "dependsOnId": "sistem_yasi",
      "options": ["Evet Acil Servis Gerekli", "Hayır Normal Servis Yeterli"]
    },

    // 8) AKÜ İNVERTER ENTEGRASYON
    {
      "id": "mevcut_ekipman",
      "label": "Mevcut Ekipman",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Akü ve İnverter Entegrasyonu"],
      "options": ["Sadece Akü Var", "Sadece İnverter Var", "Her İkisi de Var", "Yeni Sistem Kurulacak"]
    },
    {
      "id": "aku_tipi_entegrasyon",
      "label": "Akü Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "mevcut_ekipman",
      "options": ["Jel Akü", "AGM Akü", "Lityum Akü"]
    },
    {
      "id": "inverter_tipi",
      "label": "İnverter Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "aku_tipi_entegrasyon",
      "options": ["Tam Sinüs İnverter", "Modifiye Sinüs", "Hibrit İnverter"]
    },
    {
      "id": "sistem_amaci_entegrasyon",
      "label": "Sistem Amacı",
      "type": "single",
      "required": true,
      "dependsOnId": "inverter_tipi",
      "options": ["Yedek Enerji", "Off-Grid Kullanım", "Mobil Kullanım", "Hibrit Sistem"]
    },
    {
      "id": "uzaktan_izleme",
      "label": "Uzaktan İzleme İsteniyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "sistem_amaci_entegrasyon",
      "options": ["Evet İzleme Olsun", "Hayır İzleme İstemiyorum"]
    },
  ];
}