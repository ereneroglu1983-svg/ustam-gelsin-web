// lib/core/calculation/meslek_sorulari/kartonpiyer.dart

class KartonpiyerSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "malzeme_tipi", // Hesaplayıcıda taban fiyatlarını ve minimum barajları set eder
      "label": "Kullanılacak Malzeme ve Profil Tipi",
      "type": "single",
      "required": true,
      "options": [
        "Stropiyer Köpük (Ekonomik Hafif Seri)",
        "Alçı (Klasik Ağır Döküm / Donatı Fileli)",
        "Poliüretan / Polimer (Lüks Darbeye Dayanıklı Çıta Profili)"
      ]
    },
    {
      "id": "metraj_segmenti", // Hesaplayıcıda uzunluk aralıklarını kontrol ederek çarpanı belirler
      "label": "Tahmini Toplam Uzunluk / Metretül Ölçüsü",
      "type": "single",
      "required": true,
      "options": [
        "0-10 Metretül Arası",
        "10-30 Metretül Arası",
        "30-70 Metretül Arası",
        "70 Metretül ve Üzeri"
      ]
    },
    {
      "id": "metre_kare", // Net metretül girilirse robot segment yerine doğrudan bu sayıyı çarpan kabul eder
      "label": "Net Metretül Uzunluğu Girin (Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 25"
    },
    {
      "id": "tasarim_karmasikligi",
      "label": "Tasarım, Desen ve Uygulama Kombinasyonu",
      "type": "single",
      "required": true,
      "options": [
        "Düz / Standart Hat",
        "Kareli / Baklava / Klasik Kuşak Tasarımı"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Ek İşçilikler, Boya ve Donanım Ekstraları",
      "type": "multi",
      "required": false,
      "options": [
        "İnce Kestirme Boya Uygulaması (Akrilik Astar ve 2 Kat Çıta Boyama Hizmeti)",
        "Hazır Köşe Motifi veya Orta Göbek Montajı",
        "LED Kanallı Profil Geçişi (Gizli Işık Geçen Özel Kanallı Kartonpiyer)",
        "Yüksek Duvar / Tavan Çalışma Koşulu (3 Metreyi Aşan Alanlar İçin)"
      ]
    },
    {
      "id": "uygulama_alan", // 🎯 KİLİT ALAN: Alttaki sekmelerin görünürlüğünü tetikleyen ana soru
      "label": "Uygulama Alanı",
      "type": "multi",
      "required": true,
      "options": ["Oda / Salon Tavanı", "Duvar Çıtalama (Dekoratif)", "Tavan Göbeği", "Perdelik Bölümü"]
    },
    {
      "id": "metraj_m2", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue yapısına geçirildi
      "label": "Çıtalama İçin Toplam Duvar Alanı (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "dependsOnValue": ["Duvar Çıtalama (Dekoratif)"],
      "options": ["1-10 m²", "10-25 m²", "25-50 m²", "50 m² +"]
    },
    {
      "id": "metraj_metre", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue yapısına geçirildi
      "label": "Uygulama Uzunluk Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "dependsOnValue": ["Oda / Salon Tavanı", "Tavan Göbeği", "Perdelik Bölümü"],
      "options": ["1-15 Metre", "15-30 Metre", "30-60 Metre", "60 Metre +"]
    },
    {
      "id": "yukseklik",
      "label": "Tavan Yüksekliği Kademe Göstergesi",
      "type": "single",
      "required": true,
      "options": ["Standart (2.5-3m)", "Yüksek (3m+)", "Çok Yüksek"]
    }
  ];
}