// lib/core/calculation/meslek_sorulari/italyan_boya.dart

class ItalyanBoyaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "efekt_tipi", // Hesaplayıcıda taban fiyatları ve sanatsal atölye barajlarını set eder
      "label": "Tasarım, Efekt Doku ve Model Tipi",
      "type": "single",
      "required": true,
      "options": [
        "Mermer Dokulu (Stucco Veneziano - Yoğun Parlatmalı Lüks)",
        "Kadife Doku / Sedef / Sand Efekti (Işık Açısına Göre Renk Değiştiren)",
        "Paslı / Metalik Oksit Dokulu Efekt Boya",
        "Beton / Traverten Görünümlü Brüt Efekt Sıva"
      ]
    },
    {
      "id": "alan_segmenti", // Hesaplayıcıda m² aralıklarını kontrol eder
      "label": "Uygulama Yapılacak Alan Ölçü Segmenti",
      "type": "single",
      "required": true,
      "options": [
        "0-10 m² (Küçük Ünite / Tek Kolon veya Niş)",
        "10-30 m² (Vurgu Duvarı / TV Arkası / Salon Bloğu)",
        "30-70 m² (Orta Ölçek Ticari Alan / Komple Odalar)",
        "70 m² ve Üzeri (Geniş Çaplı Mimari Projeler)"
      ]
    },
    {
      "id": "metre_kare", // Net m² ölçüsü girilirse robot segment yerine bunu çarpar
      "label": "Net Alan Ölçüsü Girin - m² (Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 15"
    },
    {
      "id": "zemin_hazirligi", // Pürüzsüz macunlama ve astar için altyapı maliyetini tetikler
      "label": "Mevcut Duvar Altyapı ve Zemin Durumu",
      "type": "single",
      "required": true,
      "options": [
        "Saten Alçı / Kusursuz Pürüzsüz Hazır Zemin",
        "Tamir / Macun / Alçı Altyapı Gerekiyor (Eski Duvar Hazırlığı)"
      ]
    },
    {
      "id": "ekstra_ozellikler", // Döngüyle dönüp cila, varak, iskele arayan havuz
      "label": "Koruyucu Katmanlar ve Artistik Detay Ekstraları",
      "type": "multi",
      "required": false,
      "options": [
        "İtalyan Wax / Cila Uygulaması (Su İticilik ve Derinlik)",
        "Altın / Gümüş Varak Detayları (Lokal Kalem İşçiliği)",
        "Dış Cephe / Nemli Alan Modifikasyonu (Banyo ve Dış Ortam)",
        "Yüksek Tavan / İskele Kurulumu (3 Metreyi Aşan Alanlar)"
      ]
    },
    {
      "id": "uygulama_alan", // Ustanın keşif öncesi lokasyonu kafasında canlandırması için yapısal bilgi
      "label": "Uygulama Alanı Tipi",
      "type": "single",
      "required": true,
      "options": [
        "Belirli Duvarlar / Salon",
        "Ofis / Ticari Alan",
        "Tavan Uygulaması"
      ]
    }
  ];
}