// lib/core/calculation/meslek_sorulari/marangozluk.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class MarangozlukSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Yapılacak İşlemin Ana Niteliği",
      "type": "single",
      "required": true,
      "options": [
        "Tamirat / Montaj / Kurulum ve Yerinde Servis Hizmeti",
        "Sıfır Özel İmalat (Atölyede Plaka Kesim, Bantlama ve Üretim Projesi)"
      ]
    },

    // ========== SIFIR İMALAT YOLU ==========
    {
      "id": "malzeme_tipi",
      "label": "Kullanılacak Ana Malzeme Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfır Özel İmalat (Atölyede Plaka Kesim, Bantlama ve Üretim Projesi)"],
      "options": [
        "Suntalam (Ekonomik / Hazır Panel Serisi)",
        "MDF Lam (Yüksek Yoğunluklu Dayanıklı Gövde Paneli)",
        "Masif Ahşap / Doğal Ahşap Kereste (Fırınlanmış Planya İşçilikli Lüks Seri)"
      ]
    },
    {
      "id": "olcu_segmenti",
      "label": "Üretilecek Ürünün Tahmini Ölçü Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tipi",
      "dependsOnValue": [
        "Suntalam (Ekonomik / Hazır Panel Serisi)",
        "MDF Lam (Yüksek Yoğunluklu Dayanıklı Gövde Paneli)",
        "Masif Ahşap / Doğal Ahşap Kereste (Fırınlanmış Planya İşçilikli Lüks Seri)"
      ],
      "options": [
        "Küçük Ölçekli Alanlar (0 - 2 m² Arası Komodin, Sehpa, Küçük Raf Sistemi vb.)",
        "Orta Ölçekli Alanlar (2 - 5 m² Arası TV Ünitesi, Şifonyer, Kitaplık Blokları vb.)",
        "Büyük Ölçekli Alanlar (5 - 10 m² Arası Gardırop, Geniş Portmanto Üniteleri vb.)",
        "Özel Geniş Mimari Projeler (10 m² ve Üzeri Komple Kurulumlar)"
      ]
    },

    // ========== TAMİRAT YOLU ==========
    {
      "id": "mobilya_kategorisi",
      "label": "Uygulama Yapılacak Mobilya Grubu / Ölçeği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Tamirat / Montaj / Kurulum ve Yerinde Servis Hizmeti"],
      "options": [
        "Küçük Hacimli Onarım (Kapak, Raf, Çekmece, Kulp veya Menteşe Tamiri)",
        "Büyük Gövdeli Ünite Onarımı (Gardırop Söküm, Mutfak Dolabı Kasa Kasılması, Büyük Modül Revizyonu)"
      ]
    },
    {
      "id": "tamir_montaj_detayi",
      "label": "Yapılacak Tamirat ve Montaj Hizmetinin Detayı",
      "type": "multi",
      "required": true,
      "dependsOnId": "mobilya_kategorisi",
      "dependsOnValue": [
        "Küçük Hacimli Onarım (Kapak, Raf, Çekmece, Kulp veya Menteşe Tamiri)",
        "Büyük Gövdeli Ünite Onarımı (Gardırop Söküm, Mutfak Dolabı Kasa Kasılması, Büyük Modül Revizyonu)"
      ],
      "options": [
        "Menteşe / Ray / Kulp Değişimi ve Donanım Yenileme",
        "Kırık Ayak / Gövde Onarımı ve Ahşap Tutkallama İşlemi",
        "Şişmiş / Nem Almış Kapak Revizyonu veya Yeniden Kesim",
        "Sürgü Kapak Ayarı ve Ray Temizliği",
        "Hazır Paket Mobilya Montajı (İnternet veya Mağaza Demonte Ürünleri)",
        "Taşınma Sebebiyle Mobilya Sök-Tak (Demontaj + Montaj)"
      ]
    },

    // ========== ORTAK ZİNCİR ==========
    // ADIM: YAPI TİP - Sıfır'da ölçü sonrası, Tamirat'ta detay sonrası gelsin
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": ["olcu_segmenti", "tamir_montaj_detayi"],
      "dependsOnValue": [
        "Küçük Ölçekli Alanlar (0 - 2 m² Arası Komodin, Sehpa, Küçük Raf Sistemi vb.)",
        "Orta Ölçekli Alanlar (2 - 5 m² Arası TV Ünitesi, Şifonyer, Kitaplık Blokları vb.)",
        "Büyük Ölçekli Alanlar (5 - 10 m² Arası Gardırop, Geniş Portmanto Üniteleri vb.)",
        "Özel Geniş Mimari Projeler (10 m² ve Üzeri Komple Kurulumlar)",
        "Menteşe / Ray / Kulp Değişimi ve Donanım Yenileme",
        "Kırık Ayak / Gövde Onarımı ve Ahşap Tutkallama İşlemi",
        "Şişmiş / Nem Almış Kapak Revizyonu veya Yeniden Kesim",
        "Sürgü Kapak Ayarı ve Ray Temizliği",
        "Hazır Paket Mobilya Montajı (İnternet veya Mağaza Demonte Ürünleri)",
        "Taşınma Sebebiyle Mobilya Sök-Tak (Demontaj + Montaj)"
      ],
      "options": [
        "Ev İçi Yaşam Alanları",
        "Ofis / Mağaza / Ticari İş Yeri",
        "Bahçe / Dış Mekan Ahşap Yapıları",
        "Tekne / Karavan Marangozluğu (Özel Yatçılık İşçiliği)"
      ]
    },

    // ADIM FİNAL: EKSTRA - yapı tipi sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Donanım, Yüzey İşlemi ve Aksesuar Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "yapi_tip",
      "dependsOnValue": [
        "Ev İçi Yaşam Alanları",
        "Ofis / Mağaza / Ticari İş Yeri",
        "Bahçe / Dış Mekan Ahşap Yapıları",
        "Tekne / Karavan Marangozluğu (Özel Yatçılık İşçiliği)"
      ],
      "options": [
        "Cila / Vernik Uygulaması (İpek Mat Vernik, Lake Boya Boyama veya Gomalak El İşçiliği)",
        "Premium Frenli Ray / Menteşe Donanımı (Yavaşlatıcılı Mekanizma ve Stoplu Ray Setleri)",
        "Renk Değişimi Tasarımı (Eski Boya Kazıma, Pürüzsüz Zımpara, Astar ve Son Kat Akrilik Boyama)",
        "LED Işık Entegrasyonu (Kanal Açma, El Sensörlü Profil ve Trafo Kurulum Tasarımı)"
      ]
    }
  ];
}