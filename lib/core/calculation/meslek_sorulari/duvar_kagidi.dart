// lib/core/calculation/meslek_sorulari/duvar_kagidi.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class DuvarKagidiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Duvar Kağıdı İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Oda / Ev Duvar Kağıdı Kaplama",
        "Tek Duvar / Fon / Poster Uygulaması",
        "Sadece Eski Duvar Kağıdı Söküm and Kazıma İşçiliği"
      ]
    },

    // ADIM 2: KAĞIT TÜRÜ - sadece Kaplama ve Fon'da gelsin
    {
      "id": "kagit_turu",
      "label": "Duvar Kağıdı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Oda / Ev Duvar Kağıdı Kaplama",
        "Tek Duvar / Fon / Poster Uygulaması"
      ],
      "options": [
        "Vinil / Silinebilir Kağıt (Neme Dayanıklı)",
        "Tekstil / Kumaş Tabanlı Premium Lüks Kağıt",
        "Elyaf (Non-woven) Kağıt",
        "3D Poster / Manzara / Özel Baskılı Kağıt"
      ]
    },

    // ADIM 3: MALZEME TEDARİK - kağıt seçilince gelsin
    {
      "id": "malzeme_tedarik",
      "label": "Malzeme ve Tedarik Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "kagit_turu",
      "dependsOnValue": [
        "Vinil / Silinebilir Kağıt (Neme Dayanıklı)",
        "Tekstil / Kumaş Tabanlı Premium Lüks Kağıt",
        "Elyaf (Non-woven) Kağıt",
        "3D Poster / Manzara / Özel Baskılı Kağıt"
      ],
      "options": [
        "Malzemeyi Usta Tedarik Etsin (Malzeme + İşçilik)",
        "Malzemeyi Ben Tedarik Edeceğim (Sadece İşçilik)"
      ]
    },

    // ADIM 4: ALAN - Kaplama/Fon için malzeme sonrası, Söküm için direkt kökten gelsin
    {
      "id": "alan_segmenti",
      "label": "Uygulanacak Yaklaşık Alan",
      "type": "single",
      "required": true,
      "dependsOnId": ["malzeme_tedarik", "is_kapsami"],
      "dependsOnValue": [
        "Malzemeyi Usta Tedarik Etsin (Malzeme + İşçilik)",
        "Malzemeyi Ben Tedarik Edeceğim (Sadece İşçilik)",
        "Sadece Eski Duvar Kağıdı Söküm and Kazıma İşçiliği"
      ],
      "options": [
        "0-20 m² Arası",
        "20-50 m² Arası",
        "50-100 m² Arası",
        "100 m² ve Üzeri"
      ]
    },

    // ADIM 5: NET METRE - alan seçilince gelsin (text ama sende single olarak gösteriliyor)
    {
      "id": "metre_kare",
      "label": "Net Ölçü Girin - Duvar Metrekaresi (Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 42",
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-20 m² Arası",
        "20-50 m² Arası",
        "50-100 m² Arası",
        "100 m² ve Üzeri"
      ]
    },

    // ADIM 6: ZEMİN DURUMU - sadece Kaplama/Fon'da gelsin, alan sonrası
    {
      "id": "zemin_durumu",
      "label": "Duvarın Mevcut Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "visibleIf": {
        "is_kapsami": [
          "Komple Oda / Ev Duvar Kağıdı Kaplama",
          "Tek Duvar / Fon / Poster Uygulaması"
        ]
      },
      "dependsOnValue": [
        "0-20 m² Arası",
        "20-50 m² Arası",
        "50-100 m² Arası",
        "100 m² ve Üzeri"
      ],
      "options": [
        "Boya / Saten Alçı (Düz ve Pürüzsüz Hazır Zemin)",
        "Zeminde Eski Kağıt Var (Söküm ve Kazıma Gerekli)",
        "Pürüzlü / Çatlaklı Zemin (Alçı Tamiri ve Zımpara Gerekli)"
      ]
    },

    // ADIM 7: FİNAL - zemin seçilince veya Söküm yolunda alan seçilince gelsin
    {
      "id": "uygulama_alan",
      "label": "Uygulama Yapılacak Alan Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": ["zemin_durumu", "alan_segmenti"],
      "dependsOnValue": [
        "Boya / Saten Alçı (Düz ve Pürüzsüz Hazır Zemin)",
        "Zeminde Eski Kağıt Var (Söküm ve Kazıma Gerekli)",
        "Pürüzlü / Çatlaklı Zemin (Alçı Tamiri ve Zımpara Gerekli)",
        "0-20 m² Arası",
        "20-50 m² Arası",
        "50-100 m² Arası",
        "100 m² ve Üzeri"
      ],
      "options": [
        "Oda / Salon",
        "Ofis / Ticari Alan",
        "Tek Duvar / Fon Uygulaması"
      ]
    }
  ];
}