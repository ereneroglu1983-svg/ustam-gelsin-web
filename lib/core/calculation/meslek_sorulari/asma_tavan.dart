// lib/core/calculation/meslek_sorulari/asma_tavan.dart - FINAL
class AsmaTavanSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "tavan_tipi",
      "label": "Tavan Tipi ve Malzemesi",
      "type": "single",
      "required": true,
      "options": ["Standart Alçıpan Düz", "Metal Clip-in Modüler", "Akustik Taşyünü", "Vektörel Alüminyum Petek"]
    },
    {
      "id": "alan_segmenti",
      "label": "Toplam Uygulama Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "tavan_tipi",
      "options": ["0-20 m²", "20-50 m²", "50-100 m²", "100-300 m²", "300 m² Üzeri"]
    },
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alan Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "options": ["Oda Salon", "Ofis Ticari Alan", "Mağaza Showroom", "Hastane Kamusal Alan"]
    },
    {
      "id": "kat_yuksekligi",
      "label": "Çalışma Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "options": ["Standart 2.5-3 mt", "Yüksek 3.5-4.5 mt", "Endüstriyel 5 mt Üzeri"]
    },
    {
      "id": "ekstra_detaylar",
      "label": "Ekstra Teknik ve Dekoratif Detaylar",
      "type": "multi",
      "required": true,
      "dependsOnId": "kat_yuksekligi",
      "options": [
        "Işık Bandı Gölgelik Kanalı",
        "Spot Delikleri Elektrik Altyapısı",
        "Isı Yalıtım Levhası Taşyünü",
        "Alçı Sıva Boya Dahil",
        "Ekstra Detay İstemiyorum"
      ]
    }
  ];
}