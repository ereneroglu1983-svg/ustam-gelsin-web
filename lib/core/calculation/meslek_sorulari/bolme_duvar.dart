// lib/core/calculation/meslek_sorulari/bolme_duvar.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class BolmeDuvarSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
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

    // ADIM 2: METRAJ - kök seçilince gelsin
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
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-20 m² Arası",
        "20-50 m² Arası",
        "50-100 m² Arası",
        "100-300 m² Arası",
        "300 m² ve Üzeri"
      ]
    },

    // ADIM 3: MALZEME DALLARI - sadece 3 tipte gelir, Cam'da gelmez (zaten doğruydu)
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
      "dependsOnId": "malzeme_detayi",
      "dependsOnValue": [
        "Standart Beyaz Alçıpan / Panel",
        "Yeşil Alçıpan (Suya Dayanıklı / Islak Hacim)",
        "Kırmızı Alçıpan (Yangın Dayanımlı)"
      ],
      "options": [
        "7.5 cm (Dar Alanlar)",
        "10 cm (Standart)",
        "12.5 cm (Yalıtımlı / Çift Kat)",
        "15 cm+ (Özel Tesisat/Akustik)"
      ]
    },

    // ADIM 4: YÜKSEKLİK - metraj seçilince gelsin (Cam'da da gelsin diye alan_segmenti'ne bağlı)
    {
      "id": "duvar_yukseklik",
      "label": "Duvar Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-20 m² Arası",
        "20-50 m² Arası",
        "50-100 m² Arası",
        "100-300 m² Arası",
        "300 m² ve Üzeri"
      ],
      "options": [
        "Standart (2.50m - 3.00m)",
        "Yüksek Duvar (3.00m - 4.50m)",
        "Endüstriyel (4.50m+)"
      ]
    },

    // ADIM 5: KAPI - yükseklik seçilince gelsin
    {
      "id": "kapi_durum",
      "label": "Talep Edilen Kapı Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "duvar_yukseklik",
      "dependsOnValue": [
        "Standart (2.50m - 3.00m)",
        "Yüksek Duvar (3.00m - 4.50m)",
        "Endüstriyel (4.50m+)"
      ],
      "options": [
        "Menteşeli Kapı Eklenecek",
        "Sürgülü Kapı Eklenecek",
        "Kapı İstemiyorum"
      ]
    },

    // ADIM 6: ALAN TÜRÜ - kapı seçilince gelsin
    {
      "id": "alan_tip",
      "label": "Uygulama Alanı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_durum",
      "dependsOnValue": [
        "Menteşeli Kapı Eklenecek",
        "Sürgülü Kapı Eklenecek",
        "Kapı İstemiyorum"
      ],
      "options": [
        "Ev / Oda Bölme",
        "Ofis / Çalışma Alanı",
        "Mağaza / Depo"
      ]
    },

    // ADIM 7: FİNAL - alan türü seçilince yeşil kutuda açılsın
    {
      "id": "ekstra_ozellikler",
      "label": "Teknik Özellikler ve Ekstralar",
      "type": "multi",
      "required": false,
      "dependsOnId": "alan_tip",
      "dependsOnValue": [
        "Ev / Oda Bölme",
        "Ofis / Çalışma Alanı",
        "Mağaza / Depo"
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