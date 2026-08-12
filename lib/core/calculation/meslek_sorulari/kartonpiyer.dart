// lib/core/calculation/meslek_sorulari/kartonpiyer.dart - FINAL
class KartonpiyerSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alanı",
      "type": "single",
      "required": true,
      "options": ["Oda Salon Tavanı", "Duvar Çıtalama Dekoratif", "Tavan Göbeği", "Perdelik Bölümü"]
    },
    {
      "id": "malzeme_tipi",
      "label": "Malzeme Profil Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "options": ["Stropiyer Köpük Ekonomik", "Alçı Klasik Ağır Döküm Fileli", "Poliüretan Polimer Lüks Darbeye Dayanıklı"]
    },
    {
      "id": "metraj_tavan",
      "label": "Toplam Uzunluk Metretül",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "dependsOnValue": ["Oda Salon Tavanı", "Tavan Göbeği", "Perdelik Bölümü"],
      "options": ["0-10 Metretül", "10-30 Metretül", "30-70 Metretül", "70 Metretül Üzeri"]
    },
    {
      "id": "metraj_duvar",
      "label": "Duvar Çıtalama Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "dependsOnValue": ["Duvar Çıtalama Dekoratif"],
      "options": ["1-10 m²", "10-25 m²", "25-50 m²", "50 m² Üzeri"]
    },
    {
      "id": "tasarim_tavan",
      "label": "Tasarım Desen Kombinasyonu",
      "type": "single",
      "required": true,
      "dependsOnId": "metraj_tavan",
      "options": ["Düz Standart Hat", "Kareli Baklava Klasik Kuşak"]
    },
    {
      "id": "tasarim_duvar",
      "label": "Tasarım Desen",
      "type": "single",
      "required": true,
      "dependsOnId": "metraj_duvar",
      "options": ["Düz Standart Çıta", "Kareli Baklava Kuşaklı"]
    },
    {
      "id": "yukseklik_tavan",
      "label": "Tavan Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "tasarim_tavan",
      "options": ["Standart 2.5-3m", "Yüksek 3m Üzeri", "Çok Yüksek 4.5m Üzeri"]
    },
    {
      "id": "yukseklik_duvar",
      "label": "Tavan Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "tasarim_duvar",
      "options": ["Standart 2.5-3m", "Yüksek 3m Üzeri"]
    },
    {
      "id": "ekstra_tavan",
      "label": "Ek İşçilik Boya Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "yukseklik_tavan",
      "options": [
        "İnce Kestirme Boya Astar 2 Kat",
        "Köşe Motif Orta Göbek Montaj",
        "LED Kanallı Gizli Işık Profil",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_duvar",
      "label": "Ek İşçilik Boya",
      "type": "multi",
      "required": true,
      "dependsOnId": "yukseklik_duvar",
      "options": ["Boya Astar 2 Kat", "Köşe Motif Montaj", "Ekstra İstemiyorum"]
    }
  ];
}