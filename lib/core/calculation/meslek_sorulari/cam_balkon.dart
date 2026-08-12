// lib/core/calculation/meslek_sorulari/cam_balkon.dart - FINAL
class CamBalkonSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "sistem_tipi",
      "label": "Cam Balkon Sistem Türü",
      "type": "single",
      "required": true,
      "options": ["Katlanır Cam 8mm Temperli", "Sürgülü Cam Eşikli Eşiksiz", "Giyotin Cam Motorlu", "Isıcamlı Yüksek Yalıtımlı"]
    },
    {
      "id": "alan_segmenti",
      "label": "Kapatılacak Cam Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "sistem_tipi",
      "options": ["0-5 m² Küçük Balkon", "5-10 m² Standart", "10-20 m² Geniş Teras", "20-40 m² Büyük Kış Bahçesi", "40 m² Üzeri Ticari Cephe"]
    },
    {
      "id": "motor_marka_secimi",
      "label": "Motor Teknoloji Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "sistem_tipi",
      "dependsOnValue": ["Giyotin Cam Motorlu"],
      "options": ["Somfy Motor Avrupa Üst Segment", "Becker Cherubini Orta Üst", "Yerli Ekonomik Motor", "Fark Etmez Standart Garantili"]
    },
    {
      "id": "cam_rengi",
      "label": "Cam Renk Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "options": ["Şeffaf Standart", "Füme Güneş Kırıcı", "Bronz Mimari", "Mavi Mimari"]
    },
    {
      "id": "profil_rengi",
      "label": "Alüminyum Profil Rengi",
      "type": "single",
      "required": true,
      "dependsOnId": "cam_rengi",
      "options": ["Eloksal Naturel Gri", "Antrasit Gri", "Siyah RAL", "Beyaz Boyalı", "Ahşap Desenli Transfer"]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Mimari ve Donanım Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "profil_rengi",
      "options": [
        "Kavisli Açılı Balkon Dönüş İşçiliği",
        "Plise Perde Sistemi",
        "Çocuk Kilit Sistemi",
        "Pileli Sineklik Sistemi",
        "Ekstra İstemiyorum"
      ]
    }
  ];
}