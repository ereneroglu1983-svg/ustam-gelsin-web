// lib/core/calculation/meslek_sorulari/panel_singil.dart - FINAL
class PanelSingilSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Çatı Kaplama Teknolojisi",
      "type": "single",
      "required": true,
      "options": ["Sandviç Panel Poliüretan Taş Yünü Endüstriyel", "Şingıl Kaplama OSB Altyapılı Dekoratif", "Trapez Sac Yalıtımsız Ekonomik"]
    },
    {
      "id": "alan_m2",
      "label": "Çatı Alanı m²",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["1-50 m² Küçük Kamelya Garaj", "51-120 m² Standart Müstakil Depo", "121-250 m² Geniş Çatı Orta Bina", "251-500 m² Büyük Bina Küçük Fabrika", "500 m² Üzeri Endüstriyel"]
    },
    {
      "id": "yapi_tip",
      "label": "Alan Mimari Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_m2",
      "options": ["Endüstriyel Fabrika Depo", "Müstakil Villa Prefabrik", "Sundurma Garaj Kamelya"]
    },
    {
      "id": "kat_yuksekligi",
      "label": "Kat Yüksekliği Erişim Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "options": ["1-2 Kat Alçak Kolay Erişim", "3-5 Kat Vinç Lojistik Primli", "5 Kat Üzeri Ağır Makine Güvenlik Öncelikli"]
    },
    {
      "id": "cati_egimi",
      "label": "Çatı Eğimi İşçilik Zorluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "kat_yuksekligi",
      "options": ["Normal Eğim Standart Yürüme", "Dik Eğim İSG Kemer Halatlı Zor"]
    },
    // SANDVİÇ DALI
    {
      "id": "panel_dolgu",
      "label": "Panel İçi Yalıtım Dolgu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sandviç Panel Poliüretan Taş Yünü Endüstriyel"],
      "options": ["Poliüretan PUR Yüksek Isı Yalıtımlı", "Taş Yünü A Sınıfı Yangın Dayanımlı", "Polistiren EPS Ekonomik Hafif"]
    },
    {
      "id": "panel_kalinlik",
      "label": "Panel Et Kalınlığı",
      "type": "single",
      "required": true,
      "dependsOnId": "panel_dolgu",
      "options": ["40 mm Standart Sundurma", "50 mm Orta Fabrika Depo", "60 mm Geniş Endüstriyel", "80-100 mm Soğuk Hava Maks İzolasyon"]
    },
    // ŞINGIL DALI
    {
      "id": "shingle_model",
      "label": "Şingıl Tasarım Formu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Şingıl Kaplama OSB Altyapılı Dekoratif"],
      "options": ["Petek Geleneksel Simetrik", "Safir Yuvarlak Balık Sırtı", "Dikdörtgen Ejderha Dişi Modern", "3D Gölgeli Premium"]
    },
    // TRAPEZ DALI
    {
      "id": "trapez_kalinlik",
      "label": "Trapez Sac Kalınlık Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Trapez Sac Yalıtımsız Ekonomik"],
      "options": ["0.40 mm Ekonomik", "0.50 mm Standart", "0.60 mm Ağır Hizmet"]
    },
    // EKSTRALAR DALLARA GÖRE
    {
      "id": "ekstra_sandvic",
      "label": "Ekstra Yalıtım Söküm Kenar Detay",
      "type": "multi",
      "required": true,
      "dependsOnId": "panel_kalinlik",
      "options": [
        "Eski Çatı Söküm Moloz Nakliye",
        "Ekstra Taş Yünü Katman İlave",
        "Mahya Kenar Sacı Kapama Rüzgar Tahtası",
        "Eksiz Oluk Dere Sistem Montaj",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_singil",
      "label": "Ekstra Yalıtım Kenar Detay",
      "type": "multi",
      "required": true,
      "dependsOnId": "shingle_model",
      "options": [
        "Eski Kaplama Söküm Moloz",
        "Çift Kat Membran Su Yalıtım Arduvaz Keçe",
        "Mahya Kenar Sacı Kapama",
        "Eksiz Oluk Dere Montaj",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_trapez",
      "label": "Ekstra Detaylar",
      "type": "multi",
      "required": true,
      "dependsOnId": "trapez_kalinlik",
      "options": ["Eski Çatı Söküm", "Mahya Kenar Kapama", "Oluk Dere Montaj", "Ekstra İstemiyorum"]
    }
  ];
}