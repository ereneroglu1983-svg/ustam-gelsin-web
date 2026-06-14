// lib/core/calculation/meslek_sorulari/duvar_kagidi.dart

class DuvarKagidiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ ANA TETİKLEYİCİ: Tüm alt soruları ve akışı kilitler
      "label": "Duvar Kağıdı İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Oda / Ev Duvar Kağıdı Kaplama",
        "Tek Duvar / Fon / Poster Uygulaması",
        "Sadece Eski Duvar Kağıdı Söküm and Kazıma İşçiliği"
      ]
    },
    {
      "id": "kagit_turu", // Hesaplayıcıda taban m² fiyatını ve asgari barajı belirler
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
    {
      "id": "malzeme_tedarik", // Fiyatın işçilik mi malzeme dahil mi olduğunu belirler
      "label": "Malzeme ve Tedarik Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Oda / Ev Duvar Kağıdı Kaplama",
        "Tek Duvar / Fon / Poster Uygulaması"
      ],
      "options": [
        "Malzemeyi Usta Tedarik Etsin (Malzeme + İşçilik)",
        "Malzemeyi Ben Tedarik Edeceğim (Sadece İşçilik)"
      ]
    },
    {
      "id": "alan_segmenti", // Hesaplayıcıda m² aralıklarını kontrol ederek otomatik m² atar
      "label": "Uygulanacak Yaklaşık Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Oda / Ev Duvar Kağıdı Kaplama",
        "Tek Duvar / Fon / Poster Uygulaması",
        "Sadece Eski Duvar Kağıdı Söküm and Kazıma İşçiliği"
      ],
      "options": [
        "0-20 m² Arası",
        "20-50 m² Arası",
        "50-100 m² Arası",
        "100 m² ve Üzeri"
      ]
    },
    {
      "id": "metre_kare", // Net ölçü girilirse robot segment yerine doğrudan bu sayıyı baz alır
      "label": "Net Ölçü Girin - Duvar Metrekaresi (Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 42",
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Oda / Ev Duvar Kağıdı Kaplama",
        "Tek Duvar / Fon / Poster Uygulaması",
        "Sadece Eski Duvar Kağıdı Söküm and Kazıma İşçiliği"
      ]
    },
    {
      "id": "zemin_durumu", // Hesaplayıcıda eski kağıt söküm veya pürüzlü zemin tamir primlerini ekler
      "label": "Duvarın Mevcut Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Oda / Ev Duvar Kağıdı Kaplama",
        "Tek Duvar / Fon / Poster Uygulaması"
      ],
      "options": [
        "Boya / Saten Alçı (Düz ve Pürüzsüz Hazır Zemin)",
        "Zeminde Eski Kağıt Var (Söküm ve Kazıma Gerekli)",
        "Pürüzlü / Çatlaklı Zemin (Alçı Tamiri ve Zımpara Gerekli)"
      ]
    },
    {
      "id": "uygulama_alan", // Ustanın işi kafasında canlandırması için alan tipi
      "label": "Uygulama Yapılacak Alan Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Oda / Ev Duvar Kağıdı Kaplama",
        "Tek Duvar / Fon / Poster Uygulaması",
        "Sadece Eski Duvar Kağıdı Söküm and Kazıma İşçiliği"
      ],
      "options": [
        "Oda / Salon",
        "Ofis / Ticari Alan",
        "Tek Duvar / Fon Uygulaması"
      ]
    }
  ];
}