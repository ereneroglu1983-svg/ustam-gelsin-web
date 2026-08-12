// lib/core/calculation/meslek_sorulari/pvc_dograma.dart - FINAL
class PvcDogramaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Doğrama İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Sıfırdan İmalat Montaj Yeni Kaba", "Mevcut Doğrama Değişim Söküm Yenileme", "Sadece Cam Değişim Profil Sabit", "Tamir Fitil Aksesuar Onarım"]
    },
    // İMALAT + DEĞİŞİM ORTAK ZİNCİR
    {
      "id": "profil_serisi",
      "label": "Profil Genişlik Odacık Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan İmalat Montaj Yeni Kaba", "Mevcut Doğrama Değişim Söküm Yenileme"],
      "options": ["60lık 4 Odacık Standart Ekonomik", "70lik 5 Odacık Çift Conta İdeal", "80lik 7 Odacık Triple Conta Akustik Premium"]
    },
    {
      "id": "marka_segmenti",
      "label": "Profil Marka Kalite Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "profil_serisi",
      "options": ["A Plus Yüksek Et Kalınlığı", "B Sınıfı Standart Yerli", "Ekonomik Yerli Seri"]
    },
    {
      "id": "metraj_profil",
      "label": "Toplam Profil Uzunluk Metretül",
      "type": "single",
      "required": true,
      "dependsOnId": "marka_segmenti",
      "options": ["1-10 Metretül 1-2 Pencere", "11-25 Metretül Standart 3-5 Pencere", "26-50 Metretül Büyük Daire Kat", "50 Metretül Üzeri Villa Toplu"]
    },
    {
      "id": "cam_tipi_profil",
      "label": "Cam Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "metraj_profil",
      "options": ["Çift Cam 4+12+4 Standart", "Isıcam Konfor Sinerji Enerji Tasarruf", "Argon Akustik Lamine Ağır Ses Yalıtımlı"]
    },
    {
      "id": "urun_tipi_profil",
      "label": "Ürün Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "cam_tipi_profil",
      "options": ["Standart Pencere", "Balkon Kapısı", "Balkon Seti Kapı Pencere Kombin", "Sürgülü Sürme Vosvos", "WC Banyo Menfezli"]
    },
    // CAM DEĞİŞİM DALI
    {
      "id": "cam_alan",
      "label": "Değişim Cam Alanı m²",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sadece Cam Değişim Profil Sabit"],
      "options": ["1-3 m² Az Sayı", "4-8 m² Standart Ev", "9-15 m² Geniş Salon Balkon", "15 m² Üzeri Büyük Cephe"]
    },
    {
      "id": "cam_tipi_cam",
      "label": "Cam Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "cam_alan",
      "options": ["Çift Cam Standart", "Isıcam Konfor Sinerji", "Argon Akustik Lamine"]
    },
    {
      "id": "urun_tipi_cam",
      "label": "Ürün Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "cam_tipi_cam",
      "options": ["Standart Pencere", "Balkon Kapısı", "Balkon Seti", "Sürgülü Vosvos", "WC Menfezli"]
    },
    // TAMİR DALI
    {
      "id": "tamir_kapsam",
      "label": "Tamir Kapsamı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Tamir Fitil Aksesuar Onarım"],
      "options": ["Fitil Değişim", "Kol Mekanizma Ayar", "Cam Çıta Değişim", "Komple Bakım Ayar"]
    },
    // EKSTRALAR
    {
      "id": "ekstra_profil",
      "label": "Mekanizma Renk Aksesuar Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "urun_tipi_profil",
      "options": [
        "Çift Açılım Vasistas Mekanizma",
        "Antrasit Renkli Lamine Kaplama",
        "Pileli Sineklik Akordeon",
        "Otomatik Manuel Alüminyum Panjur",
        "Eski Doğrama Söküm Moloz Temizlik",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_cam",
      "label": "Ekstra",
      "type": "multi",
      "required": true,
      "dependsOnId": "urun_tipi_cam",
      "options": ["Çift Açılım Vasistas", "Sineklik", "Ekstra İstemiyorum"]
    },
    {
      "id": "ekstra_tamir",
      "label": "Ekstra",
      "type": "multi",
      "required": true,
      "dependsOnId": "tamir_kapsam",
      "options": ["Fitil Conta Yenileme", "Mekanizma Yağlama", "Ekstra İstemiyorum"]
    }
  ];
}