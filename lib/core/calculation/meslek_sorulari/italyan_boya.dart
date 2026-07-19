// lib/core/calculation/meslek_sorulari/italyan_boya.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class ItalyanBoyaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK - Efekt seçimi tüm fiyatı kilitler
    {
      "id": "efekt_tipi",
      "label": "Tasarım, Efekt Doku ve Model Tipi",
      "type": "single",
      "required": true,
      "options": [
        "Mermer Dokulu (Stucco Veneziano - Yoğun Parlatmalı Lüks)",
        "Kadife Doku / Sedef / Sand Efekti (Işık Açısına Göre Renk Değiştiren)",
        "Paslı / Metalik Oksit Dokulu Efekt Boya",
        "Beton / Traverten Görünümlü Brüt Efekt Sıva"
      ]
    },

    // ADIM 2: ALAN - efekt sonrası gelsin
    {
      "id": "alan_segmenti",
      "label": "Uygulama Yapılacak Alan Ölçü Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "efekt_tipi",
      "dependsOnValue": [
        "Mermer Dokulu (Stucco Veneziano - Yoğun Parlatmalı Lüks)",
        "Kadife Doku / Sedef / Sand Efekti (Işık Açısına Göre Renk Değiştiren)",
        "Paslı / Metalik Oksit Dokulu Efekt Boya",
        "Beton / Traverten Görünümlü Brüt Efekt Sıva"
      ],
      "options": [
        "0-10 m² (Küçük Ünite / Tek Kolon veya Niş)",
        "10-30 m² (Vurgu Duvarı / TV Arkası / Salon Bloğu)",
        "30-70 m² (Orta Ölçek Ticari Alan / Komple Odalar)",
        "70 m² ve Üzeri (Geniş Çaplı Mimari Projeler)"
      ]
    },

    // ADIM 3: NET METRE - alan sonrası gelsin
    {
      "id": "metre_kare",
      "label": "Net Alan Ölçüsü Girin - m² (Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 15",
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-10 m² (Küçük Ünite / Tek Kolon veya Niş)",
        "10-30 m² (Vurgu Duvarı / TV Arkası / Salon Bloğu)",
        "30-70 m² (Orta Ölçek Ticari Alan / Komple Odalar)",
        "70 m² ve Üzeri (Geniş Çaplı Mimari Projeler)"
      ]
    },

    // ADIM 4: ZEMİN HAZIRLIĞI - net metre sonrası gelsin
    {
      "id": "zemin_hazirligi",
      "label": "Mevcut Duvar Altyapı ve Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-10 m² (Küçük Ünite / Tek Kolon veya Niş)",
        "10-30 m² (Vurgu Duvarı / TV Arkası / Salon Bloğu)",
        "30-70 m² (Orta Ölçek Ticari Alan / Komple Odalar)",
        "70 m² ve Üzeri (Geniş Çaplı Mimari Projeler)"
      ],
      "options": [
        "Saten Alçı / Kusursuz Pürüzsüz Hazır Zemin",
        "Tamir / Macun / Alçı Altyapı Gerekiyor (Eski Duvar Hazırlığı)"
      ]
    },

    // ADIM 5: UYGULAMA ALANI - zemin sonrası gelsin
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alanı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_hazirligi",
      "dependsOnValue": [
        "Saten Alçı / Kusursuz Pürüzsüz Hazır Zemin",
        "Tamir / Macun / Alçı Altyapı Gerekiyor (Eski Duvar Hazırlığı)"
      ],
      "options": [
        "Belirli Duvarlar / Salon",
        "Ofis / Ticari Alan",
        "Tavan Uygulaması"
      ]
    },

    // ADIM 6: FİNAL - uygulama alanı sonrası yeşil kutuda açılsın
    {
      "id": "ekstra_ozellikler",
      "label": "Koruyucu Katmanlar ve Artistik Detay Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "uygulama_alan",
      "dependsOnValue": [
        "Belirli Duvarlar / Salon",
        "Ofis / Ticari Alan",
        "Tavan Uygulaması"
      ],
      "options": [
        "İtalyan Wax / Cila Uygulaması (Su İticilik ve Derinlik)",
        "Altın / Gümüş Varak Detayları (Lokal Kalem İşçiliği)",
        "Dış Cephe / Nemli Alan Modifikasyonu (Banyo ve Dış Ortam)",
        "Yüksek Tavan / İskele Kurulumu (3 Metreyi Aşan Alanlar)"
      ]
    }
  ];
}