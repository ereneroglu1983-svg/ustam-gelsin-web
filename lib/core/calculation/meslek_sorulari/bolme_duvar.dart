// lib/core/calculation/meslek_sorulari/bolme_duvar.dart - FINAL
class BolmeDuvarSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "Duvar Tipi ve Malzemesi",
      "type": "single",
      "required": true,
      "options": ["Alçıpan Bölme Duvar", "Cam Bölme Temperli", "Betopan Darbe Dayanımlı", "Akustik Panel Bölme"]
    },
    {
      "id": "alan_segmenti",
      "label": "Toplam Uygulama Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "options": ["0-20 m²", "20-50 m²", "50-100 m²", "100-300 m²", "300 m² Üzeri"]
    },
    {
      "id": "alan_tip",
      "label": "Uygulama Alan Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "options": ["Ev Oda Bölme", "Ofis Çalışma Alanı", "Mağaza Depo"]
    },
    {
      "id": "duvar_yukseklik",
      "label": "Duvar Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_tip",
      "options": ["Standart 2.5-3.0m", "Yüksek 3.0-4.5m", "Endüstriyel 4.5m Üzeri"]
    },
    {
      "id": "malzeme_detayi",
      "label": "Panel Detay Özelliği",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Alçıpan Bölme Duvar", "Betopan Darbe Dayanımlı", "Akustik Panel Bölme"],
      "options": ["Standart Beyaz", "Yeşil Suya Dayanıklı", "Kırmızı Yangın Dayanımlı"]
    },
    {
      "id": "duvar_kalinlik",
      "label": "Duvar Kalınlığı",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_detayi",
      "options": ["7.5 cm Dar Alan", "10 cm Standart", "12.5 cm Yalıtımlı Çift Kat", "15 cm Özel Tesisat Akustik"]
    },
    {
      "id": "kapi_durum",
      "label": "Kapı Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "duvar_kalinlik",
      "dependsOnValue": ["7.5 cm Dar Alan", "10 cm Standart", "12.5 cm Yalıtımlı Çift Kat", "15 cm Özel Tesisat Akustik"],
      "options": ["Menteşeli Kapı Eklenecek", "Sürgülü Kapı Eklenecek", "Kapı İstemiyorum"]
    },
    // Cam bölme için kapı direkt
    {
      "id": "kapi_durum_cam",
      "label": "Kapı Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Cam Bölme Temperli"],
      "options": ["Menteşeli Kapı Eklenecek", "Sürgülü Kapı Eklenecek", "Kapı İstemiyorum"]
    },
    {
      "id": "ekstra_ozellikler_alcipan",
      "label": "Teknik Özellikler",
      "type": "multi",
      "required": true,
      "dependsOnId": "kapi_durum",
      "options": [
        "Taş Yünü Ses Yalıtımı",
        "Karkas Güçlendirme Lentolama",
        "Elektrik Altyapı Buat Kanal",
        "Alçı Sıva Boya Bitiş Paketi",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_ozellikler_cam",
      "label": "Teknik Özellikler",
      "type": "multi",
      "required": true,
      "dependsOnId": "kapi_durum_cam",
      "options": ["Cam Arası Jaluzi", "Buzlu Film Kaplama", "Kapı Kilit Sistemi", "Ekstra İstemiyorum"]
    }
  ];
}