// lib/core/calculation/meslek_sorulari/sihhi_tesisat.dart - FINAL
class SihhiTesisatSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Tesisat İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Genel Tesisat Yenileme Komple Altyapı", "Kaçak Tespit Tıkanıklık Küçük Onarım"]
    },
    {
      "id": "yapi_tip",
      "label": "Yapı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["Daire", "Villa Müstakil Ev", "İşyeri Ofis Ticari"]
    },
    {
      "id": "tesisat_konumu",
      "label": "Mevcut Tesisat Konum Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "options": ["Duvar İçi Gizli Tesisat", "Zemin Altı Tesisat", "Açıkta Sıva Üstü Tesisat"]
    },
    // YENİLEME DALI
    {
      "id": "boru_tipi",
      "label": "Ana Boru Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Genel Tesisat Yenileme Komple Altyapı"],
      "options": ["PPRC Standart Plastik", "Cam Elyaf Kompozit Sıcak Su Uzama Önleyici", "Sessiz Boru Akustik Kalın Cidarlı"]
    },
    {
      "id": "islak_hacim",
      "label": "Yenilenecek Islak Hacim Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "boru_tipi",
      "options": ["1 Islak Hacim Tek Banyo veya Mutfak", "2 Islak Hacim Banyo Mutfak", "3 Islak Hacim Ebeveyn Ana Mutfak", "4+ Islak Hacim Komple"]
    },
    {
      "id": "armatur_yenileme",
      "label": "Armatür Batarya Musluk Adedi",
      "type": "single",
      "required": true,
      "dependsOnId": "islak_hacim",
      "options": ["İstenmiyor", "1-3 Adet Değişim", "4-6 Adet", "7-10 Adet", "10+ Yoğun Montaj"]
    },
    {
      "id": "ekstra_yenileme",
      "label": "Kırım Kollektör Test Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "armatur_yenileme",
      "options": [
        "Eski Söküm Duvar Kırım Moloz",
        "Gömme Rezervuar Gizli Sarnıç Kurulum",
        "Kollektörlü Mobil Sistem Kutusu",
        "Basınçlı Kaçak Sızdırmazlık Testi",
        "Ekstra İstemiyorum"
      ]
    },
    // ARIZA DALI
    {
      "id": "kacak_durumu",
      "label": "Arıza Kaçak Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Kaçak Tespit Tıkanıklık Küçük Onarım"],
      "options": ["Su Kaçağı Yeri Bilinmiyor Akustik Termal Tespit", "Gider Tıkanıklığı Robot Kameralı Açma", "Onarım Tamirat Musluk Batarya Montaj"]
    },
    {
      "id": "hat_uzunlugu",
      "label": "Müdahale Hat Bölge Uzunluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "kacak_durumu",
      "options": ["Lokal 1-5 Metre", "Bölgesel 5-15 Metre", "Kısmi Hat Yenileme 15-30 Metre"]
    },
    {
      "id": "armatur_ariza",
      "label": "Armatür Adedi",
      "type": "single",
      "required": true,
      "dependsOnId": "hat_uzunlugu",
      "options": ["İstenmiyor", "1-3 Adet", "4-6 Adet", "7-10 Adet", "10+ Adet"]
    }
  ];
}