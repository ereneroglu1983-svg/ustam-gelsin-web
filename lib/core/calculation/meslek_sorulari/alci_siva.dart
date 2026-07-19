// lib/core/calculation/meslek_sorulari/alci_siva.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi, sadece dependsOn zinciri eklendi.

class AlciSivaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
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

    // ADIM 2: METREKARE - uygulama seçilince gelsin
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
      "dependsOnId": "alan_segmenti", // DEĞİŞTİ: Direkt uygulama_tipi'ne değil, alan_segmenti'ne bağlı - sıra garantisi
      "dependsOnValue": [
        "0-50 m²",
        "50-100 m²",
        "100-200 m²",
        "200-500 m²",
        "500 m² +"
      ]
    },

    // ADIM 3: ZEMİN DURUMU - metrekare netleşince gelsin
    {
      "id": "zemin_durumu",
      "label": "Mevcut Zemin / Yüzey Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti", // DEĞİŞTİ: alan seçilince gelsin, hepsi birden açılmasın
      "dependsOnValue": [
        "0-50 m²",
        "50-100 m²",
        "100-200 m²",
        "200-500 m²",
        "500 m² +"
      ],
      "options": [
        "Tuğla / Bims / Beton (Kaba İnşaat)",
        "Alçıpan Üzeri Derz ve Yoklama",
        "Eski Boyalı / Çatlaklı Yüzey (Kazımalı)"
      ]
    },

    // ADIM 4: EKSTRA - zemin durumu seçilince yeşil kutuda açılsın
    {
      "id": "ekstra_islemler",
      "label": "İhtiyaç Duyulan Ekstra İşlemler",
      "type": "multi",
      "required": false,
      "dependsOnId": "zemin_durumu", // DEĞİŞTİ: Zemin seçilince gelsin, final dokunuşu
      "dependsOnValue": [
        "Tuğla / Bims / Beton (Kaba İnşaat)",
        "Alçıpan Üzeri Derz ve Yoklama",
        "Eski Boyalı / Çatlaklı Yüzey (Kazımalı)"
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