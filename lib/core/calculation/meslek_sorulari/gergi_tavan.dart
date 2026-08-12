// lib/core/calculation/meslek_sorulari/gergi_tavan.dart - FINAL
class GergiTavanSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Uygulama Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Sıfırdan Komple Gergi Tavan Karkas LED Membran", "Mevcut Sisteme Membran Değişimi", "Sadece LED Trafo Arıza Onarım"]
    },
    {
      "id": "alan_segmenti",
      "label": "Uygulama Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["0-5 m² Küçük Koridor WC", "5-15 m² Standart Oda", "15-30 m² Büyük Salon Mağaza", "30 m² Üzeri Geniş Ofis"]
    },
    {
      "id": "membran_tipi",
      "label": "Membran Dokusu Baskı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan Komple Gergi Tavan Karkas LED Membran", "Mevcut Sisteme Membran Değişimi"],
      "options": ["Transparan Işık Geçirgen Beyaz", "Dijital Baskılı UV Desenli", "Lake Ayna Etkili Premium", "3D Formlu Bükümlü Karkaslı"]
    },
    {
      "id": "yukseklik",
      "label": "Tavan Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "membran_tipi",
      "options": ["Standart 2.5-3m", "Yüksek 3-4.5m", "Endüstriyel 4.5m Üzeri"]
    },
    {
      "id": "aydinlatma_tipi",
      "label": "Aydınlatma Altyapı Seçimi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan Komple Gergi Tavan Karkas LED Membran"],
      "options": ["Full Modül LED Paket Dahil", "Sadece Membran LED Hariç"]
    },
    {
      "id": "ekstra_sifirdan",
      "label": "Tasarım ve Donanım Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "aydinlatma_tipi",
      "options": [
        "RGB Uzaktan Kumandalı Renk Değiştiren",
        "Daire Oval Kavisli Geometrik Tasarım",
        "Lake Fitil Estetik Kenar Bitiş",
        "Teleskopik Askı Taşıyıcı İskelet",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "led_ariza",
      "label": "LED Arıza Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sadece LED Trafo Arıza Onarım"],
      "options": ["LED Modül Arızası Yanmıyor", "Trafo Arızası", "Kumanda Alıcı Arızası", "Kısmi Kararma Titreme"]
    }
  ];
}