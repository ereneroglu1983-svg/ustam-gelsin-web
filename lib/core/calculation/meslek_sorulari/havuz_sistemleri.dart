// lib/core/calculation/meslek_sorulari/havuz_sistemleri.dart - FINAL
class HavuzSistemleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan Havuz Yapımı Anahtar Teslim",
        "Mevcut Havuz Tadilat Liner Değişim",
        "Periyodik Sezonluk Bakım",
        "Kapatma Isı Sistemi Kurulumu"
      ]
    },
    // SIFIRDAN DALI
    {
      "id": "havuz_tipi",
      "label": "Havuz Yapım Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan Havuz Yapımı Anahtar Teslim"],
      "options": ["Betonarme Skimmerlı Standart", "Taşmalı Infinity Denge Tanklı", "Prefabrik Panel Hızlı Kurulum", "Fiberglass Monoblok Hazır"]
    },
    {
      "id": "arazi_sarti",
      "label": "Zemin Yapısı Hafriyat Koşulu",
      "type": "single",
      "required": true,
      "dependsOnId": "havuz_tipi",
      "options": ["Normal Toprak Düz Kolay Kazı", "Kayalık Sert Zemin Kırıcı Gerekli", "Bataklık Yeraltı Suyu Islah Drenaj Gerekli"]
    },
    {
      "id": "kaplama_tipi_sifir",
      "label": "İç Yüzey Kaplama Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "arazi_sarti",
      "options": ["Porselen Mozaik Seramik", "Cam Mozaik Doğal Taş Lüks", "Liner PVC Membran"]
    },
    {
      "id": "alan_sifir",
      "label": "Havuz Yüzey Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "kaplama_tipi_sifir",
      "options": ["0-25 m² Küçük Villa Tipi", "25-50 m² Orta Bahçe Aile", "50-100 m² Geniş Ticari", "100 m² Üzeri Olimpik Otel"]
    },
    // TADİLAT DALI
    {
      "id": "kaplama_tipi_tadilat",
      "label": "Yeni İç Kaplama Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mevcut Havuz Tadilat Liner Değişim"],
      "options": ["Porselen Mozaik Kaplama", "Cam Mozaik Doğal Taş", "Liner PVC Membran Değişim"]
    },
    {
      "id": "alan_tadilat",
      "label": "Havuz Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "kaplama_tipi_tadilat",
      "options": ["0-25 m²", "25-50 m²", "50-100 m²", "100 m² Üzeri"]
    },
    // BAKIM DALI
    {
      "id": "bakim_detay",
      "label": "Bakım Kapsam Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Periyodik Sezonluk Bakım"],
      "options": ["Haftalık Kimyasal Filtrasyon", "Aylık Detaylı Bakım", "Sezon Açılış Bakımı", "Sezon Kapanış Bakımı"]
    },
    {
      "id": "alan_bakim",
      "label": "Havuz Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "bakim_detay",
      "options": ["0-25 m²", "25-50 m²", "50-100 m²", "100 m² Üzeri"]
    },
    // KAPATMA ISI DALI
    {
      "id": "kapatma_tipi",
      "label": "Kapatma Isı Sistemi Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Kapatma Isı Sistemi Kurulumu"],
      "options": ["Otomatik Lamel Kapak", "Teleskopik Kapatma", "Isı Pompası Kurulumu", "Güneş Kolektörü Isıtma"]
    },
    {
      "id": "alan_kapatma",
      "label": "Havuz Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "kapatma_tipi",
      "options": ["0-25 m²", "25-50 m²", "50-100 m²", "100 m² Üzeri"]
    },
    // EKSTRALAR
    {
      "id": "ekstra_sifir",
      "label": "Elektromekanik Konfor Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "alan_sifir",
      "options": [
        "Inverter Isı Pompası Dört Mevsim",
        "Tuz Klorlama Otomasyon pH Dozaj",
        "Şelale Jakuzi SPA Masaj Jet",
        "RGB Akıllı LED Aydınlatma",
        "Otomatik Lamel Örtü",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_tadilat",
      "label": "Ekstra Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "alan_tadilat",
      "options": ["Filtrasyon Pompa Yenileme", "LED Aydınlatma Yenileme", "Merdiven Tutamak", "Ekstra İstemiyorum"]
    },
    {
      "id": "ekstra_bakim",
      "label": "Ekstra Hizmet",
      "type": "multi",
      "required": true,
      "dependsOnId": "alan_bakim",
      "options": ["Yeşil Su Temizleme", "Kum Filtre Değişim", "Robot Süpürge Temizlik", "Ekstra İstemiyorum"]
    },
    {
      "id": "ekstra_kapatma",
      "label": "Ekstra Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "alan_kapatma",
      "options": ["Isı Yalıtım Örtüsü", "Rüzgar Sensörü Otomasyon", "LED Aydınlatma", "Ekstra İstemiyorum"]
    }
  ];
}