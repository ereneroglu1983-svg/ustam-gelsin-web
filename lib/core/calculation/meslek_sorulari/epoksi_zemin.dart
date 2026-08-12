// lib/core/calculation/meslek_sorulari/epoksi_zemin.dart - FINAL
class EpoksiZeminSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Uygulama İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Komple Sıfırdan Epoksi Kaplama", "Mevcut Epoksi Lokal Onarım"]
    },
    {
      "id": "alan_segmenti",
      "label": "Uygulanacak Toplam Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["0-50 m²", "50-100 m²", "100-250 m²", "250-500 m²", "500 m² Üzeri"]
    },
    {
      "id": "kaplama_tipi",
      "label": "Epoksi Kaplama Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Sıfırdan Epoksi Kaplama"],
      "options": ["Self-Leveling Düz", "Portakal Kabuğu Kaymaz", "Metalik Dekoratif Mermer", "3D Görsel Grafik Likit Cam"]
    },
    {
      "id": "zemin_durumu",
      "label": "Mevcut Zemin Yapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "kaplama_tipi",
      "options": ["Eski Beton Elmas Silim Gerekli", "Seramik Fayans Pürüzlendirme Gerekli", "Helikopter Şap Hazır Yüzey"]
    },
    {
      "id": "zemin_hasar_durumu",
      "label": "Zemin Hasar Durumu",
      "type": "multi",
      "required": true,
      "dependsOnId": "zemin_durumu",
      "options": [
        "Derin Çatlak Kırık Var Tamir Gerekli",
        "Yoğun Tozuma Problemi Var",
        "Yağlanma Kimyasal Atık Var Solvent Yıkama",
        "Hasar Yok Temiz Zemin"
      ]
    },
    {
      "id": "onarim_detay",
      "label": "Onarım Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mevcut Epoksi Lokal Onarım"],
      "options": ["Çatlak Tamiri", "Kalkma Kabarma Tamiri", "Renk Solması Yenileme", "Komple Zımpara Yeniden Kaplama"]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Teknik Katman ve Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "zemin_hasar_durumu",
      "options": [
        "Nem Bariyeri Katmanı",
        "Anti-Statik Sistem Bakır Şeritli",
        "Ekstra Koruyucu Poliüretan Vernik",
        "Kaymaz Kum Katkısı",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_onarim",
      "label": "Ekstra İşlem",
      "type": "multi",
      "required": true,
      "dependsOnId": "onarim_detay",
      "options": ["Çatlak Enjeksiyon", "Derz Dolgu Yenileme", "Parlaklık Vernik", "Ekstra İstemiyorum"]
    }
  ];
}