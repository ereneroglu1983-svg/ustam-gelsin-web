// lib/core/calculation/meslek_sorulari/marangozluk.dart

class MarangozlukSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ EN ANA TETİKLEYİCİ: Yerinde servis ile atölye imalat akışlarını ayıran ana kilit
      "label": "Yapılacak İşlemin Ana Niteliği",
      "type": "single",
      "required": true,
      "options": [
        "Tamirat / Montaj / Kurulum ve Yerinde Servis Hizmeti",
        "Sıfır Özel İmalat (Atölyede Plaka Kesim, Bantlama ve Üretim Projesi)"
      ]
    },

    // ==========================================
    // 🪚 GRUP 1: SIFIR ÖZEL İMALAT ÖZEL SORULARI (Sadece İmalat Seçilirse Açılır)
    // ==========================================
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
      "id": "olcu_segmenti", // 🛠️ TEK ÖLÇÜ KAYNAĞI: Klavye girdisi yerine motorla tam uyumlu temiz sekmeler
      "label": "Üretilecek Ürünün Tahmini Ölçü Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfır Özel İmalat (Atölyede Plaka Kesim, Bantlama ve Üretim Projesi)"],
      "options": [
        "Küçük Ölçekli Alanlar (0 - 2 m² Arası Komodin, Sehpa, Küçük Raf Sistemi vb.)",
        "Orta Ölçekli Alanlar (2 - 5 m² Arası TV Ünitesi, Şifonyer, Kitaplık Blokları vb.)",
        "Büyük Ölçekli Alanlar (5 - 10 m² Arası Gardırop, Geniş Portmanto Üniteleri vb.)",
        "Özel Geniş Mimari Projeler (10 m² ve Üzeri Komple Kurulumlar)"
      ]
    },

    // ==========================================
    // 🔧 GRUP 2: TAMİRAT VE MONTAJ ÖZEL SORULARI (Sadece Tamirat Seçilirse Açılır)
    // ==========================================
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
      "id": "tamir_montaj_detayi", // 🛠️ Bedava marka reklam çağrışımları jenerik terimlerle temizlendi
      "label": "Yapılacak Tamirat ve Montaj Hizmetinin Detayı",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Tamirat / Montaj / Kurulum ve Yerinde Servis Hizmeti"],
      "options": [
        "Menteşe / Ray / Kulp Değişimi ve Donanım Yenileme",
        "Kırık Ayak / Gövde Onarımı ve Ahşap Tutkallama İşlemi",
        "Şişmiş / Nem Almış Kapak Revizyonu veya Yeniden Kesim",
        "Sürgü Kapak Ayarı ve Ray Temizliği",
        "Hazır Paket Mobilya Montajı (İnternet veya Mağaza Demonte Ürünleri)",
        "Taşınma Sebebiyle Mobilya Sök-Tak (Demontaj + Montaj)"
      ]
    },

    // ==========================================
    // 📐 ORTAK YAPISAL FİLTRELER VE EKSTRALAR
    // ==========================================
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami", // 🛠️ İş kapsamı seçilmeden bu ortak sorular da ekrana gelmez
      "dependsOnValue": [
        "Tamirat / Montaj / Kurulum ve Yerinde Servis Hizmeti",
        "Sıfır Özel İmalat (Atölyede Plaka Kesim, Bantlama ve Üretim Projesi)"
      ],
      "options": [
        "Ev İçi Yaşam Alanları",
        "Ofis / Mağaza / Ticari İş Yeri",
        "Bahçe / Dış Mekan Ahşap Yapıları",
        "Tekne / Karavan Marangozluğu (Özel Yatçılık İşçiliği)"
      ]
    },
    {
      "id": "ekstra_ozellikler", // 🛠️ Sponsor dostu jenerik donanım isimleriyle yenilendi
      "label": "Donanım, Yüzey İşlemi ve Aksesuar Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Tamirat / Montaj / Kurulum ve Yerinde Servis Hizmeti",
        "Sıfır Özel İmalat (Atölyede Plaka Kesim, Bantlama ve Üretim Projesi)"
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