// lib/core/calculation/meslek_sorulari/marangozluk.dart - FINAL
class MarangozlukSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "İşlem Ana Niteliği",
      "type": "single",
      "required": true,
      "options": ["Tamirat Montaj Yerinde Servis", "Sıfır Özel İmalat Atölye Üretim"]
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Alan Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["Ev İçi Yaşam Alanı", "Ofis Mağaza Ticari", "Bahçe Dış Mekan Ahşap", "Tekne Karavan Yatçılık"]
    },
    // İMALAT DALI
    {
      "id": "malzeme_tipi",
      "label": "Ana Malzeme Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfır Özel İmalat Atölye Üretim"],
      "options": ["Suntalam Ekonomik Panel", "MDF Lam Yüksek Yoğunluk Dayanıklı", "Masif Doğal Ahşap Fırınlanmış Lüks"]
    },
    {
      "id": "olcu_segmenti",
      "label": "Ürün Tahmini Ölçü Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tipi",
      "options": ["Küçük 0-2 m² Komodin Sehpa Raf", "Orta 2-5 m² TV Şifonyer Kitaplık", "Büyük 5-10 m² Gardırop Portmanto", "Özel 10 m² Üzeri Komple Kurulum"]
    },
    {
      "id": "ekstra_imalat",
      "label": "Donanım Yüzey Aksesuar Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "olcu_segmenti",
      "options": [
        "Cila Vernik Lake Boya Gomalak",
        "Premium Frenli Ray Menteşe Stoplu",
        "Renk Değişim Kazıma Zımpara Astar Boya",
        "LED Sensörlü Profil Trafo",
        "Ekstra İstemiyorum"
      ]
    },
    // TAMİRHAT DALI
    {
      "id": "mobilya_kategorisi",
      "label": "Mobilya Grubu Ölçeği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Tamirat Montaj Yerinde Servis"],
      "options": ["Küçük Hacim Kapak Raf Çekmece Kulp Menteşe", "Büyük Gövdeli Gardırop Mutfak Dolap Modül Revizyon"]
    },
    {
      "id": "tamir_detay",
      "label": "Tamirat Montaj Hizmet Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "mobilya_kategorisi",
      "options": [
        "Menteşe Ray Kulp Donanım Değişim",
        "Kırık Ayak Gövde Tutkallama Onarım",
        "Şişmiş Nemli Kapak Revizyon Kesim",
        "Sürgü Kapak Ayar Ray Temizlik",
        "Hazır Paket Demonte Montaj",
        "Taşınma Sök Tak Demontaj Montaj"
      ]
    },
    {
      "id": "ekstra_tamir",
      "label": "Ekstra İşlemler",
      "type": "multi",
      "required": true,
      "dependsOnId": "tamir_detay",
      "options": ["Cila Vernik Uygulama", "Premium Frenli Mekanizma", "Renk Değişim Boya", "LED Entegrasyon", "Ekstra İstemiyorum"]
    }
  ];
}