// lib/core/calculation/meslek_sorulari/pvc_dograma.dart

class PvcDogramaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ ANA TETİKLEYİCİ
      "label": "Yapılacak Doğrama İşleminin Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan İmalat ve Montaj (Yeni Yapı / Kaba İnşaat)",
        "Mevcut Doğrama Değişimi (Eski Pencerelerin Sökülüp Yenilenmesi)",
        "Sadece Cam Değişimi (Profil Sabit, Isıcam veya Çift Cam Yenileme)",
        "Tamir / Fitil Değişimi / Aksesuar Onarımı Hizmeti"
      ]
    },

    // ==========================================
    // 🪟 GRUP 1: KOMPLE PROFİL İMALAT VE MONTAJ SORULARI
    // ==========================================
    {
      "id": "profil_serisi",
      "label": "Profil Genişliği ve Odacık Teknolojisi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat ve Montaj (Yeni Yapı / Kaba İnşaat)",
        "Mevcut Doğrama Değişimi (Eski Pencerelerin Sökülüp Yenilenmesi)"
      ],
      "options": [
        "60'lık Seri (4 Odacıklı - Standart Yalıtımlı Ekonomik Profil)",
        "70'lik Seri (5 Odacıklı - Çift Conta Sistemli İdeal Ara Segment)",
        "80'lik Seri (7 Odacıklı - Triple 3 Kat Contalı Akustik Premium Profil)"
      ]
    },
    {
      "id": "metraj_metretul_secim", // 🛠️ YENİ SEÇMELİ SEKME: Text kaldırıldı, aralık getirildi
      "label": "Yaklaşık Toplam Profil Uzunluğu (Metretül)",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat ve Montaj (Yeni Yapı / Kaba İnşaat)",
        "Mevcut Doğrama Değişimi (Eski Pencerelerin Sökülüp Yenilenmesi)"
      ],
      "options": [
        "1 - 10 Metretül Arası (Küçük Projeler / 1-2 Pencere)",
        "11 - 25 Metretül Arası (Standart Daire / 3-5 Pencere)",
        "26 - 50 Metretül Arası (Büyük Daire veya Komple Kat)",
        "50 Metretül Üzeri (Villa / Toplu Proje)"
      ]
    },
    {
      "id": "marka_segmenti",
      "label": "Profil Marka ve Kalite Sınıfı Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat ve Montaj (Yeni Yapı / Kaba İnşaat)",
        "Mevcut Doğrama Değişimi (Eski Pencerelerin Sökülüp Yenilenmesi)"
      ],
      "options": [
        "A Plus Marka Segmenti (Winsa, Egepen, Rehau vb. Yüksek Et Kalınlığı)",
        "B Sınıfı Marka Segmenti (Adopen, Fıratpen vb. Standart Yerli)",
        "Ekonomik Projeler İçin Yerli Seri Profil"
      ]
    },

    // ==========================================
    // 💎 GRUP 2: SADECE CAM DEĞİŞİMİ SORULARI
    // ==========================================
    {
      "id": "cam_metraj_m2_secim", // 🛠️ YENİ SEÇMELİ SEKME: Text kaldırıldı, aralık getirildi
      "label": "Değişimi Yapılacak Yaklaşık Cam Alanı (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sadece Cam Değişimi (Profil Sabit, Isıcam veya Çift Cam Yenileme)"],
      "options": [
        "1 - 3 m² Arası (Az Sayıda Cam Değişimi)",
        "4 - 8 m² Arası (Standart Ev Camları Yenileme)",
        "9 - 15 m² Arası (Geniş Salon / Komple Balkon Camları)",
        "15 m² Üzeri (Büyük Cephe / Yoğun Değişim)"
      ]
    },

    // ==========================================
    // ⚙️ TEKNİK PARAMETRELER VE EKSTRALAR
    // ==========================================
    {
      "id": "cam_tipi",
      "label": "Kombinasyon Cam Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat ve Montaj (Yeni Yapı / Kaba İnşaat)",
        "Mevcut Doğrama Değişimi (Eski Pencerelerin Sökülüp Yenilenmesi)",
        "Sadece Cam Değişimi (Profil Sabit, Isıcam veya Çift Cam Yenileme)"
      ],
      "options": [
        "Çift Cam (4+12+4 Standart Yalıtımlı Klasik Cam)",
        "Isıcam Konfor (Sinerji Isı Kontrol Kaplamalı Enerji Tasarruflu Seri)",
        "Argon Gazlı Akustik Lamine Cam (Yüksek Ses Yalıtımlı Ağır Akustik Seri)"
      ]
    },
    {
      "id": "urun_tipi_kırılımı",
      "label": "İmalatı/Onarımı Yapılacak Ürün Tipleri",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat ve Montaj (Yeni Yapı / Kaba İnşaat)",
        "Mevcut Doğrama Değişimi (Eski Pencerelerin Sökülüp Yenilenmesi)",
        "Sadece Cam Değişimi (Profil Sabit, Isıcam veya Çift Cam Yenileme)"
      ],
      "options": [
        "Standart Pencere",
        "Balkon Kapısı",
        "Balkon Seti (Kapı ve Pencere Yan Yana Kombinasyon)",
        "Sürgülü (Voswos) Sürme Sistem Kapı/Pencere",
        "WC / Banyo Menfezli Penceresi"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Mekanizma, Renk Lamine ve Aksesuar Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat ve Montaj (Yeni Yapı / Kaba İnşaat)",
        "Mevcut Doğrama Değişimi (Eski Pencerelerin Sökülüp Yenilenmesi)"
      ],
      "options": [
        "Çift Açılım Kanat Mekanizması İlavesi (Vasistas Sistem)",
        "Antrasit / Renkli Lamine Profil (Renk ve Ahşap Desen Kaplama Çarpanı)",
        "Pileli Sineklik Entegrasyonu (Yatay/Dikey Açılır Akordeon Tül Sistemi)",
        "Otomatik / Manuel Alüminyum Panjur Sistemi Entegrasyonu",
        "Mevcut Eski Ahşap/Demir/PVC Doğrama Sökümü ve Moloz Temizliği İşçiliği"
      ]
    }
  ];
}