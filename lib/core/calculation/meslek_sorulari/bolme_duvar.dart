// lib/core/calculation/meslek_sorulari/bolme_duvar.dart

class BolmeDuvarSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "Duvar Tipi ve Malzemesi",
      "type": "single",
      "required": true,
      "options": [
        "Alçıpan Bölme Duvar Sistemleri",
        "Cam Bölme / Ofis Bölme Sistemleri (Temperli)",
        "Betoban Bölme Duvar (Darbe Dayanımlı)",
        "Akustik Panel Bölme Duvar"
      ]
    },
    {
      "id": "alan_segmenti",
      "label": "Toplam Uygulama Alanı (m²) Aralığı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Alçıpan Bölme Duvar Sistemleri",
        "Cam Bölme / Ofis Bölme Sistemleri (Temperli)",
        "Betoban Bölme Duvar (Darbe Dayanımlı)",
        "Akustik Panel Bölme Duvar"
      ],
      "options": [
        "0-20 m² Arası",
        "20-50 m² Arası",
        "50-100 m² Arası",
        "100-300 m² Arası",
        "300 m² ve Üzeri"
      ]
    },
    {
      "id": "metre_kare",
      "label": "Net Duvar Metrekaresi Girin (Opsiyonel)",
      "type": "text",
      "keyboardType": "number",
      "hint": "Örn: 42",
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Alçıpan Bölme Duvar Sistemleri",
        "Cam Bölme / Ofis Bölme Sistemleri (Temperli)",
        "Betoban Bölme Duvar (Darbe Dayanımlı)",
        "Akustik Panel Bölme Duvar"
      ]
    },
    {
      "id": "malzeme_detayi",
      "label": "Alçıpan / Panel Detay Özelliği",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Alçıpan Bölme Duvar Sistemleri",
        "Betoban Bölme Duvar (Darbe Dayanımlı)",
        "Akustik Panel Bölme Duvar"
      ],
      "options": [
        "Standart Beyaz Alçıpan / Panel",
        "Yeşil Alçıpan (Suya Dayanıklı / Islak Hacim)",
        "Kırmızı Alçıpan (Yangın Dayanımlı)"
      ]
    },
    {
      "id": "duvar_kalinlik",
      "label": "Duvar Kalınlığı / Profil Genişliği",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Alçıpan Bölme Duvar Sistemleri",
        "Betoban Bölme Duvar (Darbe Dayanımlı)",
        "Akustik Panel Bölme Duvar"
      ],
      "options": [
        "7.5 cm (Dar Alanlar)",
        "10 cm (Standart)",
        "12.5 cm (Yalıtımlı / Çift Kat)",
        "15 cm+ (Özel Tesisat/Akustik)"
      ]
    },
    {
      "id": "duvar_yukseklik",
      "label": "Duvar Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Alçıpan Bölme Duvar Sistemleri",
        "Cam Bölme / Ofis Bölme Sistemleri (Temperli)",
        "Betoban Bölme Duvar (Darbe Dayanımlı)",
        "Akustik Panel Bölme Duvar"
      ],
      "options": [
        "Standart (2.50m - 3.00m)",
        "Yüksek Duvar (3.00m - 4.50m)",
        "Endüstriyel (4.50m+)"
      ]
    },
    {
      "id": "kapi_durum",
      "label": "Talep Edilen Kapı Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Alçıpan Bölme Duvar Sistemleri",
        "Cam Bölme / Ofis Bölme Sistemleri (Temperli)",
        "Betoban Bölme Duvar (Darbe Dayanımlı)",
        "Akustik Panel Bölme Duvar"
      ],
      "options": [
        "Menteşeli Kapı Eklenecek",
        "Sürgülü Kapı Eklenecek",
        "Kapı İstemiyorum"
      ]
    },
    {
      "id": "alan_tip",
      "label": "Uygulama Alanı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Alçıpan Bölme Duvar Sistemleri",
        "Cam Bölme / Ofis Bölme Sistemleri (Temperli)",
        "Betoban Bölme Duvar (Darbe Dayanımlı)",
        "Akustik Panel Bölme Duvar"
      ],
      "options": [
        "Ev / Oda Bölme",
        "Ofis / Çalışma Alanı",
        "Mağaza / Depo"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Teknik Özellikler ve Ekstralar",
      "type": "multi",
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Alçıpan Bölme Duvar Sistemleri",
        "Cam Bölme / Ofis Bölme Sistemleri (Temperli)",
        "Betoban Bölme Duvar (Darbe Dayanımlı)",
        "Akustik Panel Bölme Duvar"
      ],
      "options": [
        "Taş Yünü ile Ses Yalıtımı Uygulaması",
        "Kapı Boşluğu Karkas Güçlendirme / Lentolama",
        "Elektrik Altyapı Hazırlığı (Duvar İçi Buat/Kanal)",
        "Alçı Sıva ve Boya Dahil Bitiş Paketi",
        "Cam Bölme Arası Jaluzi Sistemleri"
      ]
    }
  ];
}