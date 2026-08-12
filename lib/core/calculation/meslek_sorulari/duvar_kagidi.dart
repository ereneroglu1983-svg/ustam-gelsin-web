// lib/core/calculation/meslek_sorulari/duvar_kagidi.dart - FINAL
class DuvarKagidiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Komple Oda Ev Kaplama", "Tek Duvar Fon Poster", "Sadece Eski Kağıt Söküm Kazıma"]
    },
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alan Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["Oda Salon", "Ofis Ticari Alan", "Tek Duvar Fon"]
    },
    {
      "id": "alan_segmenti",
      "label": "Uygulanacak Yaklaşık Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "options": ["0-20 m²", "20-50 m²", "50-100 m²", "100 m² Üzeri"]
    },
    {
      "id": "kagit_turu",
      "label": "Duvar Kağıdı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Oda Ev Kaplama", "Tek Duvar Fon Poster"],
      "options": ["Vinil Silinebilir", "Tekstil Kumaş Premium", "Elyaf Non-woven", "3D Poster Manzara Özel Baskı"]
    },
    {
      "id": "zemin_durumu",
      "label": "Duvar Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "kagit_turu",
      "options": ["Boya Saten Alçı Düz Hazır", "Eski Kağıt Var Söküm Gerekli", "Pürüzlü Çatlaklı Tamir Zımpara Gerekli"]
    },
    {
      "id": "malzeme_tedarik",
      "label": "Malzeme Tedarik Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durumu",
      "options": ["Malzeme Dahil Usta Tedarik", "Sadece İşçilik Malzeme Müşteride"]
    },
    {
      "id": "ekstra_sokum",
      "label": "Ekstra Durum",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sadece Eski Kağıt Söküm Kazıma"],
      "options": ["Sadece Söküm Kazıma", "Söküm Sonrası Duvar Teslim Temiz"]
    }
  ];
}