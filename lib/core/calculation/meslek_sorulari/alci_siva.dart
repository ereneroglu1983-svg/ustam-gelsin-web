// lib/core/calculation/meslek_sorulari/alci_siva.dart

class AlciSivaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "Uygulama Alanı / Tipi",
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
      "label": "Toplam Metrekare (m²) Aralığı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "İç Mekan Alçı Sıva",
        "Dış Cephe Alçı Sıva",
        "Dekoratif Alçı Sıva"
      ],
      "options": [
        "0-50 m²",
        "50-100 m²",
        "100-200 m²",
        "200-500 m²",
        "500 m² +"
      ]
    },
    {
      "id": "metre_kare",
      "label": "Net Metrekare Ölçüsü Girin (Opsiyonel)",
      "type": "text",
      "keyboardType": "number",
      "hint": "Örn: 85",
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "İç Mekan Alçı Sıva",
        "Dış Cephe Alçı Sıva",
        "Dekoratif Alçı Sıva"
      ]
    },
    {
      "id": "zemin_durumu",
      "label": "Mevcut Zemin / Yüzey Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "İç Mekan Alçı Sıva",
        "Dış Cephe Alçı Sıva",
        "Dekoratif Alçı Sıva"
      ],
      "options": [
        "Tuğla / Bims / Beton (Kaba İnşaat)",
        "Alçıpan Üzeri Derz ve Yoklama",
        "Eski Boyalı / Çatlaklı Yüzey (Kazımalı)"
      ]
    },
    {
      "id": "ekstra_islemler",
      "label": "İhtiyaç Duyulan Ekstra İşlemler",
      "type": "multi",
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "İç Mekan Alçı Sıva",
        "Dış Cephe Alçı Sıva",
        "Dekoratif Alçı Sıva"
      ],
      "options": [
        "SSıva Filesi Uygulaması (Çatlak Önleyici)",
        "Köşe Profili Montajı (Darbe Dayanımlı)",
        "İskele Kurulumu ve Kiralanması",
        "Mevcut Hasarların Tamir / Onarımı"
      ]
    }
  ];
}