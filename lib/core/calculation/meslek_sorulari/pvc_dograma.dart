// lib/core/calculation/meslek_sorulari/pvc_dograma.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class PvcDogramaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
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

    // ========== SIFIR VE DEĞİŞİM YOLU ==========
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
      "id": "marka_segmenti",
      "label": "Profil Marka ve Kalite Sınıfı Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "profil_serisi",
      "dependsOnValue": [
        "60'lık Seri (4 Odacıklı - Standart Yalıtımlı Ekonomik Profil)",
        "70'lik Seri (5 Odacıklı - Çift Conta Sistemli İdeal Ara Segment)",
        "80'lik Seri (7 Odacıklı - Triple 3 Kat Contalı Akustik Premium Profil)"
      ],
      "options": [
        "A Plus Marka Segmenti (Winsa, Egepen, Rehau vb. Yüksek Et Kalınlığı)",
        "B Sınıfı Marka Segmenti (Adopen, Fıratpen vb. Standart Yerli)",
        "Ekonomik Projeler İçin Yerli Seri Profil"
      ]
    },
    {
      "id": "metraj_metretul_secim",
      "label": "Yaklaşık Toplam Profil Uzunluğu (Metretül)",
      "type": "single",
      "required": true,
      "dependsOnId": "marka_segmenti",
      "dependsOnValue": [
        "A Plus Marka Segmenti (Winsa, Egepen, Rehau vb. Yüksek Et Kalınlığı)",
        "B Sınıfı Marka Segmenti (Adopen, Fıratpen vb. Standart Yerli)",
        "Ekonomik Projeler İçin Yerli Seri Profil"
      ],
      "options": [
        "1 - 10 Metretül Arası (Küçük Projeler / 1-2 Pencere)",
        "11 - 25 Metretül Arası (Standart Daire / 3-5 Pencere)",
        "26 - 50 Metretül Arası (Büyük Daire veya Komple Kat)",
        "50 Metretül Üzeri (Villa / Toplu Proje)"
      ]
    },

    // ========== SADECE CAM YOLU ==========
    {
      "id": "cam_metraj_m2_secim",
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

    // ADIM: ORTAK CAM TİPİ - Sıfır/Değişim'de metraj sonrası, Cam Değişim'de cam metraj sonrası gelsin
    {
      "id": "cam_tipi",
      "label": "Kombinasyon Cam Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": ["metraj_metretul_secim", "cam_metraj_m2_secim"],
      "dependsOnValue": [
        "1 - 10 Metretül Arası (Küçük Projeler / 1-2 Pencere)",
        "11 - 25 Metretül Arası (Standart Daire / 3-5 Pencere)",
        "26 - 50 Metretül Arası (Büyük Daire veya Komple Kat)",
        "50 Metretül Üzeri (Villa / Toplu Proje)",
        "1 - 3 m² Arası (Az Sayıda Cam Değişimi)",
        "4 - 8 m² Arası (Standart Ev Camları Yenileme)",
        "9 - 15 m² Arası (Geniş Salon / Komple Balkon Camları)",
        "15 m² Üzeri (Büyük Cephe / Yoğun Değişim)"
      ],
      "options": [
        "Çift Cam (4+12+4 Standart Yalıtımlı Klasik Cam)",
        "Isıcam Konfor (Sinerji Isı Kontrol Kaplamalı Enerji Tasarruflu Seri)",
        "Argon Gazlı Akustik Lamine Cam (Yüksek Ses Yalıtımlı Ağır Akustik Seri)"
      ]
    },

    // ADIM: ÜRÜN TİPİ - cam tipi sonrası gelsin
    {
      "id": "urun_tipi_kırılımı",
      "label": "İmalatı/Onarımı Yapılacak Ürün Tipleri",
      "type": "multi",
      "required": true,
      "dependsOnId": "cam_tipi",
      "dependsOnValue": [
        "Çift Cam (4+12+4 Standart Yalıtımlı Klasik Cam)",
        "Isıcam Konfor (Sinerji Isı Kontrol Kaplamalı Enerji Tasarruflu Seri)",
        "Argon Gazlı Akustik Lamine Cam (Yüksek Ses Yalıtımlı Ağır Akustik Seri)"
      ],
      "options": [
        "Standart Pencere",
        "Balkon Kapısı",
        "Balkon Seti (Kapı ve Pencere Yan Yana Kombinasyon)",
        "Sürgülü (Voswos) Sürme Sistem Kapı/Pencere",
        "WC / Banyo Menfezli Penceresi"
      ]
    },

    // ADIM FİNAL: EKSTRA - sadece Sıfır ve Değişim'de ve ürün tipi sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Mekanizma, Renk Lamine ve Aksesuar Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "urun_tipi_kırılımı",
      "visibleIf": {
        "is_kapsami": [
          "Sıfırdan İmalat ve Montaj (Yeni Yapı / Kaba İnşaat)",
          "Mevcut Doğrama Değişimi (Eski Pencerelerin Sökülüp Yenilenmesi)"
        ]
      },
      "dependsOnValue": [
        "Standart Pencere",
        "Balkon Kapısı",
        "Balkon Seti (Kapı ve Pencere Yan Yana Kombinasyon)",
        "Sürgülü (Voswos) Sürme Sistem Kapı/Pencere",
        "WC / Banyo Menfezli Penceresi"
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