// lib/core/calculation/meslek_sorulari/ray_dolap.dart - FINAL
class RayDolapSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "islem_kapsami",
      "label": "Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Sıfırdan İmalat Montaj Dahil", "Sadece Kapak Yenileme", "İç Raf Düzenleme Tadilat"]
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Alan Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "options": ["Yatak Odası", "Giyinme Odası", "Antre Koridor", "Çocuk Genç Odası", "Ofis Arşiv"]
    },
    {
      "id": "alan_segmenti",
      "label": "Dolap Ölçüsü Alan Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "options": ["0-4 m² Küçük", "4-8 m² Orta", "8-12 m² Geniş Giyinme", "12 m² Üzeri Duvar Kaplama"]
    },
    {
      "id": "yukseklik_tip",
      "label": "Dolap Yükseklik Tavan Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "options": ["Tavana Kadar Tam Boy Pervazlı", "Standart 210-230 cm Üstü Açık", "Özel Alçak Eğim Kesimli"]
    },
    // SIFIRDAN DALI
    {
      "id": "govde_malzemesi",
      "label": "Gövde Raf İskelet Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": ["Sıfırdan İmalat Montaj Dahil"],
      "options": ["Suntalam Ekonomik", "MDF Lam Dayanıklı 1. Kalite", "Masif Kaplama Lake Lüks"]
    },
    {
      "id": "kapak_modeli_sifir",
      "label": "Kapak Teknolojisi Yüzey",
      "type": "single",
      "required": true,
      "dependsOnId": "govde_malzemesi",
      "options": ["Düz Suntalam Ekonomik", "Akrilik Parlak Çizilmez", "Membran Balon Pres PVC", "Lake Boya CNC Desenli Lüks"]
    },
    {
      "id": "ray_mekanizmasi_sifir",
      "label": "Ray Mekanizma Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapak_modeli_sifir",
      "options": ["Standart Alttan Makaralı Manuel", "Menteşeli Frenli Stoplu", "Lüks Üstten Askılı Frenli Sessiz"]
    },
    // KAPAK YENİLEME DALI
    {
      "id": "kapak_modeli_yenileme",
      "label": "Yeni Kapak Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": ["Sadece Kapak Yenileme"],
      "options": ["Düz Suntalam Ekonomik", "Akrilik Parlak Çizilmez", "Membran Balon Pres", "Lake Boya CNC Lüks"]
    },
    {
      "id": "ray_mekanizmasi_yenileme",
      "label": "Ray Mekanizma Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapak_modeli_yenileme",
      "options": ["Standart Alttan Makaralı", "Menteşeli Frenli Stoplu", "Lüks Üstten Askılı Frenli"]
    },
    // İÇ RAF DALI
    {
      "id": "govde_raf",
      "label": "Raf Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": ["İç Raf Düzenleme Tadilat"],
      "options": ["Suntalam Ekonomik", "MDF Lam Dayanıklı", "Masif Kaplama"]
    },
    // EKSTRALAR
    {
      "id": "ekstra_sifir",
      "label": "Fonksiyonel Donanım Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "ray_mekanizmasi_sifir",
      "options": [
        "LED Sensörlü Profil Işık",
        "Ayna Cam Entegrasyonu",
        "Pantolonluk Asansör Askı",
        "Ekstra Derin 70-80 cm Tasarım",
        "Çekmece Modülü 3lü Frenli",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_kapak",
      "label": "Ekstra Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "ray_mekanizmasi_yenileme",
      "options": ["Frenli Stop Yavaşlatıcı", "Ayna Cam Kapak", "Kulp Değişim Gizli Kulp", "Ekstra İstemiyorum"]
    },
    {
      "id": "ekstra_raf",
      "label": "Ekstra Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "govde_raf",
      "options": ["Çekmece Kutusu Frenli", "LED Aydınlatma", "Askılık Pantolonluk", "Ekstra İstemiyorum"]
    }
  ];
}