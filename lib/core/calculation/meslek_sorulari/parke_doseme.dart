// lib/core/calculation/meslek_sorulari/parke_doseme.dart - FINAL
class ParkeDosemeSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Parke Malzeme Teknolojisi",
      "type": "single",
      "required": true,
      "options": ["Laminat 8-10mm Kilitli Standart", "Lamine Doğal Üst Katman Hassas Klik", "Masif Tutkallı Sistre Cila Ağır Zanaat", "LVP Vinil Suya Dayanıklı PVC Klik"]
    },
    {
      "id": "metre_kare",
      "label": "Net Zemin Alanı m²",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["0-40 m²", "40-60 m²", "60-80 m²", "80-100 m²", "100-120 m²", "120-150 m²", "150+ m²"]
    },
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "metre_kare",
      "options": ["Ev Oda Salon", "Ofis Ticari Alan", "Spor Salonu"]
    },
    {
      "id": "zemin_durum",
      "label": "Mevcut Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "options": ["Şap Düzgün Pürüzsüz", "Zemin Bozuk Tesviye Gerekli", "Eski Parke Üzerine"]
    },
    {
      "id": "kalinlik",
      "label": "Kalınlık Derz Seçimi",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durum",
      "options": ["8 mm Standart Derzsiz", "10 mm Standart", "12 mm Derzli Premium"]
    },
    {
      "id": "alt_dolgu",
      "label": "Parke Altı Şilte Yalıtım",
      "type": "single",
      "required": true,
      "dependsOnId": "kalinlik",
      "options": ["Standart 2mm Beyaz Köpük Şilte", "Kapron XPS Yerden Isıtma Uyumlu", "Mantar Doğal Akustik Rulo"]
    },
    {
      "id": "supurgelik",
      "label": "Süpürgelik Model Yükseklik",
      "type": "single",
      "required": true,
      "dependsOnId": "alt_dolgu",
      "options": ["MDF Standart PVC İnce", "Lake Yüksek 8-10 cm CNC Gönyeli", "Alüminyum Metal Minimal Klipsli"]
    },
    // MASİF DALI EK
    {
      "id": "cila_masif",
      "label": "Masif Cila Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Masif Tutkallı Sistre Cila Ağır Zanaat"],
      "options": ["Çift Bileşen Poliüretan Parlak Dayanımlı", "Su Bazlı Ekolojik Mat İpek Mat", "Doğal Yağ Mat Dokulu"]
    },
    {
      "id": "ekstra_genel",
      "label": "Zemin Hazırlık Kapı Profil Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "supurgelik",
      "options": ["Kapı Altı Kesim Tıraşlama", "Eşik Kot Farkı Profili", "Eski Parke Halı Söküm Temizlik", "Şap Düzeltme Tesviye", "Ekstra İstemiyorum"]
    },
    {
      "id": "ekstra_masif",
      "label": "Zemin Hazırlık Profil Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "cila_masif",
      "options": ["Kapı Altı Kesim", "Eşik Profil", "Eski Söküm Temizlik", "Şap Tesviye", "Ekstra İstemiyorum"]
    }
  ];
}