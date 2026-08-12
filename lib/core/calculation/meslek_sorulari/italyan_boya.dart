// lib/core/calculation/meslek_sorulari/italyan_boya.dart - FINAL
class ItalyanBoyaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "efekt_tipi",
      "label": "Efekt Doku Model Tipi",
      "type": "single",
      "required": true,
      "options": [
        "Mermer Dokulu Stucco Veneziano Parlatmalı",
        "Kadife Sedef Sand Işıkla Renk Değiştiren",
        "Paslı Metalik Oksit Efekt",
        "Beton Traverten Brüt Efekt Sıva"
      ]
    },
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alan Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "efekt_tipi",
      "options": ["Belirli Duvarlar Salon", "Ofis Ticari Alan", "Tavan Uygulaması", "Kolon Niş Vurgu"]
    },
    {
      "id": "alan_segmenti",
      "label": "Alan Ölçü Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "options": ["0-10 m² Küçük Kolon Niş", "10-30 m² Vurgu Duvar TV Arkası", "30-70 m² Orta Ticari Komple Oda", "70 m² Üzeri Geniş Mimari"]
    },
    {
      "id": "zemin_hazirligi",
      "label": "Mevcut Duvar Altyapı Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "options": ["Saten Alçı Pürüzsüz Hazır Zemin", "Tamir Macun Alçı Altyapı Gerekli"]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Koruyucu ve Artistik Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "zemin_hazirligi",
      "options": [
        "İtalyan Wax Cila Su İtici Derinlik",
        "Altın Gümüş Varak Lokal Kalem",
        "Dış Cephe Nemli Alan Modifikasyon",
        "Yüksek Tavan İskele Kurulum 3m Üzeri",
        "Ekstra İstemiyorum"
      ]
    }
  ];
}