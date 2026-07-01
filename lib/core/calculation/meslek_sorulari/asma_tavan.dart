// lib/core/calculation/meslek_sorulari/asma_tavan.dart

class AsmaTavanSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "tavan_tipi",
      "label": "Tavan Tipi ve Malzemesi",
      "type": "single",
      "required": true,
      "options": [
        "Standart Alçıpan Tavan (Düz)",
        "Metal Tavan (Clip-in / Modüler)",
        "Akustik Tavan veya Taşyünü Tavan",
        "Vektörel Tavan / Alüminyum Petek Tavan"
      ]
    },
    {
      "id": "alan_segmenti",
      "label": "Toplam Metrekare (m²) Aralığı",
      "type": "single",
      "required": true,
      "dependsOnId": "tavan_tipi",
      "dependsOnValue": [
        "Standart Alçıpan Tavan (Düz)",
        "Metal Tavan (Clip-in / Modüler)",
        "Akustik Tavan veya Taşyünü Tavan",
        "Vektörel Tavan / Alüminyum Petek Tavan"
      ],
      "options": [
        "0-20 m²",
        "20-50 m²",
        "50-100 m²",
        "100-300 m²",
        "300 m² +"
      ]
    },
    {
      "id": "metre_kare",
      "label": "Net Metrekare Girin (Opsiyonel)",
      "type": "text",
      "keyboardType": "number",
      "hint": "Örn: 45",
      "dependsOnId": "tavan_tipi",
      "dependsOnValue": [
        "Standart Alçıpan Tavan (Düz)",
        "Metal Tavan (Clip-in / Modüler)",
        "Akustik Tavan veya Taşyünü Tavan",
        "Vektörel Tavan / Alüminyum Petek Tavan"
      ]
    },
    {
      "id": "kat_yuksekligi",
      "label": "Kat / Çalışma Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "tavan_tipi",
      "dependsOnValue": [
        "Standart Alçıpan Tavan (Düz)",
        "Metal Tavan (Clip-in / Modüler)",
        "Akustik Tavan veya Taşyünü Tavan",
        "Vektörel Tavan / Alüminyum Petek Tavan"
      ],
      "options": [
        "Standart (2.5 - 3 mt)",
        "Yüksek Tavan (3.5 - 4.5 mt)",
        "Endüstriyel Tavan (5 mt ve Üzeri)"
      ]
    },
    {
      "id": "ekstra_detaylar",
      "label": "Ekstra Teknik ve Dekoratif Detaylar",
      "type": "multi",
      "dependsOnId": "tavan_tipi",
      "dependsOnValue": [
        "Standart Alçıpan Tavan (Düz)",
        "Metal Tavan (Clip-in / Modüler)",
        "Akustik Tavan veya Taşyünü Tavan",
        "Vektörel Tavan / Alüminyum Petek Tavan"
      ],
      "options": [
        "Işık Bandı / Gölgelik Kanalı Yapımı",
        "Spot Delikleri ve Elektrik Altyapısı",
        "Isı Yalıtım Levhası (Tavan Arası İzocam/Taşyünü)",
        "Alçı Sıva ve Boya Uygulaması Dahil"
      ]
    },
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alanı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "tavan_tipi",
      "dependsOnValue": [
        "Standart Alçıpan Tavan (Düz)",
        "Metal Tavan (Clip-in / Modüler)",
        "Akustik Tavan veya Taşyünü Tavan",
        "Vektörel Tavan / Alüminyum Petek Tavan"
      ],
      "options": [
        "Oda / Salon",
        "Ofis / Ticari Alan",
        "Mağaza / Showroom",
        "Hastane / Kamusal Alan"
      ]
    }
  ];
}