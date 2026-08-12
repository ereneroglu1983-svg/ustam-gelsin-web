// lib/core/calculation/meslek_sorulari/bahce_peyzaj.dart - FINAL
class BahcePeyzajSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "Hizmet Türü",
      "type": "single",
      "required": true,
      "options": ["Sadece Çim Ekimi Serimi", "Komple Anahtar Teslim Peyzaj"]
    },
    {
      "id": "yapi_tip",
      "label": "Alan Mimari Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "options": ["Müstakil Ev Villa Bahçesi", "Site Apartman Ortak Alan", "İş Yeri Fabrika Çevresi", "Teras Çatı Bahçesi"]
    },
    {
      "id": "alan_segmenti",
      "label": "Bahçe Alan Büyüklüğü",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "options": ["0-50 m² Küçük", "51-100 m² Standart", "100-250 m² Geniş Villa", "250-500 m² Çok Geniş", "500 m² Üzeri Büyük Ticari"]
    },
    {
      "id": "zemin_durumu",
      "label": "Mevcut Zemin ve Eğim",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "options": ["Normal Düz Temiz Zemin", "Sert Taşlı Zemin Çapa Gerekli", "Eğimli Arazi Tesviye Gerekli"]
    },
    {
      "id": "cim_turu",
      "label": "Çim Uygulama Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durumu",
      "options": ["Hazır Rulo Çim Serimi", "Tohum Çim Ekimi", "Yapay Sentetik Çim"]
    },
    {
      "id": "sulama_detay",
      "label": "Sulama Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "cim_turu",
      "dependsOnValue": ["Hazır Rulo Çim Serimi", "Tohum Çim Ekimi", "Yapay Sentetik Çim"],
      "options": ["Pop-up Fıskiye Sistemi", "Damlama Sulama Sistemi", "Akıllı Zamanlayıcılı Otomatik", "Sadece Manuel Vana Hat", "Sulama İstemiyorum"]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Ekstra Altyapı ve Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "sulama_detay",
      "options": [
        "Drenaj Hattı Yapımı",
        "Yürüyüş Yolu Taş Döşeme",
        "Bahçe Aydınlatma Sistemi",
        "Organik Gübre Toprak İyileştirme",
        "Ekstra İstemiyorum"
      ]
    }
  ];
}