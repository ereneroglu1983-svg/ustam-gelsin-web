// lib/core/calculation/meslek_sorulari/alci_siva.dart - FINAL
class AlciSivaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "Uygulama Alanı Tipi",
      "type": "single",
      "required": true,
      "options": [
        "İç Mekan Alçı Sıva",
        "Dış Cephe Alçı Sıva",
        "Dekoratif Alçı Sıva"
      ]
    },
    {
      "id": "alan_segmenti",
      "label": "Toplam Uygulama Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "options": ["0-50 m²", "50-100 m²", "100-200 m²", "200-500 m²", "500 m² Üzeri"]
    },
    {
      "id": "zemin_durumu",
      "label": "Mevcut Yüzey Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "options": ["Tuğla Bims Beton Kaba İnşaat", "Alçıpan Üzeri Derz Yoklama", "Eski Boyalı Çatlaklı Yüzey Kazınacak"]
    },
    {
      "id": "ekstra_islemler",
      "label": "Ekstra İşlemler",
      "type": "multi",
      "required": true,
      "dependsOnId": "zemin_durumu",
      "options": [
        "Sıva Filesi Uygulaması",
        "Köşe Profili Montajı",
        "İskele Kurulumu Gerekli",
        "Mevcut Hasar Tamiri",
        "Ekstra İşlem İstemiyorum"
      ]
    }
  ];
}