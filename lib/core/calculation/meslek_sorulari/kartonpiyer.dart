// lib/core/calculation/meslek_sorulari/kartonpiyer.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class KartonpiyerSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK - Malzeme tüm fiyatı kilitler
    {
      "id": "malzeme_tipi",
      "label": "Kullanılacak Malzeme ve Profil Tipi",
      "type": "single",
      "required": true,
      "options": [
        "Stropiyer Köpük (Ekonomik Hafif Seri)",
        "Alçı (Klasik Ağır Döküm / Donatı Fileli)",
        "Poliüretan / Polimer (Lüks Darbeye Dayanıklı Çıta Profili)"
      ]
    },

    // ADIM 2: TASARIM - malzeme sonrası gelsin
    {
      "id": "tasarim_karmasikligi",
      "label": "Tasarım, Desen ve Uygulama Kombinasyonu",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tipi",
      "dependsOnValue": [
        "Stropiyer Köpük (Ekonomik Hafif Seri)",
        "Alçı (Klasik Ağır Döküm / Donatı Fileli)",
        "Poliüretan / Polimer (Lüks Darbeye Dayanıklı Çıta Profili)"
      ],
      "options": [
        "Düz / Standart Hat",
        "Kareli / Baklava / Klasik Kuşak Tasarımı"
      ]
    },

    // ADIM 3: UYGULAMA ALANI - tasarım sonrası gelsin, dallanmayı burası tetikler
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alanı",
      "type": "multi",
      "required": true,
      "dependsOnId": "tasarim_karmasikligi",
      "dependsOnValue": [
        "Düz / Standart Hat",
        "Kareli / Baklava / Klasik Kuşak Tasarımı"
      ],
      "options": ["Oda / Salon Tavanı", "Duvar Çıtalama (Dekoratif)", "Tavan Göbeği", "Perdelik Bölümü"]
    },

    // ADIM 4: METRAJ SEGMENTİ - uygulama alanı sonrası gelsin
    {
      "id": "metraj_segmenti",
      "label": "Tahmini Toplam Uzunluk / Metretül Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "dependsOnValue": ["Oda / Salon Tavanı", "Duvar Çıtalama (Dekoratif)", "Tavan Göbeği", "Perdelik Bölümü"],
      "options": [
        "0-10 Metretül Arası",
        "10-30 Metretül Arası",
        "30-70 Metretül Arası",
        "70 Metretül ve Üzeri"
      ]
    },

    // ADIM 4B: DAL 1 - Duvar Çıtalama seçildiyse m² kademesi
    {
      "id": "metraj_m2",
      "label": "Çıtalama İçin Toplam Duvar Alanı (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "dependsOnValue": ["Duvar Çıtalama (Dekoratif)"],
      "options": ["1-10 m²", "10-25 m²", "25-50 m²", "50 m² +"]
    },

    // ADIM 4C: DAL 2 - Tavan/perdelik seçildiyse metre kademesi
    {
      "id": "metraj_metre",
      "label": "Uygulama Uzunluk Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "dependsOnValue": ["Oda / Salon Tavanı", "Tavan Göbeği", "Perdelik Bölümü"],
      "options": ["1-15 Metre", "15-30 Metre", "30-60 Metre", "60 Metre +"]
    },

    // ADIM 5: YÜKSEKLİK - metraj seçildikten sonra gelsin (hangi dal gelirse gelsin)
    {
      "id": "yukseklik",
      "label": "Tavan Yüksekliği Kademe Göstergesi",
      "type": "single",
      "required": true,
      "dependsOnId": ["metraj_segmenti", "metraj_m2", "metraj_metre"],
      "dependsOnValue": [
        "0-10 Metretül Arası",
        "10-30 Metretül Arası",
        "30-70 Metretül Arası",
        "70 Metretül ve Üzeri",
        "1-10 m²",
        "10-25 m²",
        "25-50 m²",
        "50 m² +",
        "1-15 Metre",
        "15-30 Metre",
        "30-60 Metre",
        "60 Metre +"
      ],
      "options": ["Standart (2.5-3m)", "Yüksek (3m+)", "Çok Yüksek"]
    },

    // ADIM 6: NET METRETÜL - yükseklik sonrası gelsin
    {
      "id": "metre_kare",
      "label": "Net Metretül Uzunluğu Girin (Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 25",
      "dependsOnId": "yukseklik",
      "dependsOnValue": ["Standart (2.5-3m)", "Yüksek (3m+)", "Çok Yüksek"]
    },

    // ADIM 7: FİNAL - net ölçü sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Ek İşçilikler, Boya ve Donanım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": ["yukseklik", "metre_kare"],
      "dependsOnValue": [
        "Standart (2.5-3m)",
        "Yüksek (3m+)",
        "Çok Yüksek",
        "0-10 Metretül Arası",
        "10-30 Metretül Arası",
        "30-70 Metretül Arası",
        "70 Metretül ve Üzeri"
      ],
      "options": [
        "İnce Kestirme Boya Uygulaması (Akrilik Astar ve 2 Kat Çıta Boyama Hizmeti)",
        "Hazır Köşe Motifi veya Orta Göbek Montajı",
        "LED Kanallı Profil Geçişi (Gizli Işık Geçen Özel Kanallı Kartonpiyer)",
        "Yüksek Duvar / Tavan Çalışma Koşulu (3 Metreyi Aşan Alanlar İçin)"
      ]
    }
  ];
}