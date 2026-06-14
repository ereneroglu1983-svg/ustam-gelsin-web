// lib/core/calculation/meslek_sorulari/epoksi_zemin.dart

class EpoksiZeminSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ ANA TETİKLEYİCİ: Tüm alt soruları ve akışı kilitler
      "label": "Epoksi Uygulama İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Sıfırdan Epoksi Zemin Kaplama",
        "Mevcut Epoksi Zeminin Lokal Onarımı ve Çatlak Tamiri"
      ]
    },
    {
      "id": "kaplama_tipi", // Hesaplayıcıda '3D', 'Portakal/Textured', 'Metalik' ve başlangıç m² fiyatını ve asgari barajı belirler
      "label": "Epoksi Kaplama ve Görsel Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Sıfırdan Epoksi Zemin Kaplama"],
      "options": [
        "Self-Leveling Epoksi (Düz ve Pürüzsüz Başlangıç)",
        "Portakal Kabuğu (Textured - Kaymaz Yüzeyli Endüstriyel)",
        "Metalik Epoksi (Dekoratif Mermer Görünümlü Artistik)",
        "3D Görsel / Grafik Tasarım Kaplama (Likit Cam Korumalı)"
      ]
    },
    {
      "id": "alan_segmenti", // Hesaplayıcıda m² aralıklarını boşluksuz kontrol edip m² belirler
      "label": "Uygulanacak Toplam Alan Aralığı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Sıfırdan Epoksi Zemin Kaplama",
        "Mevcut Epoksi Zeminin Lokal Onarımı ve Çatlak Tamiri"
      ],
      "options": [
        "0-50 m² Arası",
        "50-100 m² Arası",
        "100-250 m² Arası",
        "250-500 m² Arası",
        "500 m² ve Üzeri"
      ]
    },
    {
      "id": "metre_kare", // Kullanıcı tam m² girerse robot segment yerine doğrudan bu sayıyı çarpar
      "label": "Net Alan Ölçüsü Girin (m² - Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 120",
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Sıfırdan Epoksi Zemin Kaplama",
        "Mevcut Epoksi Zeminin Lokal Onarımı ve Çatlak Tamiri"
      ]
    },
    {
      "id": "zemin_durumu", // Hesaplayıcıda 'Silim' veya 'Beton' ya da 'Seramik' için hazırlık bedeli ekler
      "label": "Mevcut Zemin Yapısı ve Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Sıfırdan Epoksi Zemin Kaplama"],
      "options": [
        "Eski Beton (Ağır Elmas Silim ve Vakumlu Toz Emme Gerektirir)",
        "Seramik / Fayans Zemin (Pürüzlendirme ve Özel Geçiş Astarlı)",
        "Helikopter Şap Zemin (Hafif Zımparalı Hazır Yüzey)"
      ]
    },
    {
      "id": "zemin_hasar_durumu", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue yapısına geçirildi
      "label": "Zemin Hasar ve Kusur Durumu",
      "type": "multi",
      "required": false,
      "dependsOnId": "zemin_durumu",
      "dependsOnValue": [
        "Eski Beton (Ağır Elmas Silim ve Vakumlu Toz Emme Gerektirir)",
        "Seramik / Fayans Zemin (Pürüzlendirme ve Özel Geçiş Astarlı)"
      ],
      "options": [
        "Yüzeyde Derin Çatlaklar ve Kırıklar Var (Tamir Macunu İhtiyacı)",
        "Zeminde Yoğun Tozuma Problemi Mevcut",
        "Endüstriyel Yağlanma / Kimyasal Atık Var (Özel Solventli Yıkama Gerekli)"
      ]
    },
    {
      "id": "ekstra_ozellikler", // Teknik katman isimleri korundu
      "label": "Teknik Katmanlar ve Sektörel Ekstralar",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Sıfırdan Epoksi Zemin Kaplama"],
      "options": [
        "Nem Bariyeri Katmanı (Zeminden Su Yürümesini Engelleyen Özel Astar)",
        "Anti-Statik Sistem (Laboratuvar/Data Merkezleri İçin Bakır Şeritli Statik Alıcı)",
        "Ekstra Koruyucu Kat (Çizilmelere Karşı Poliüretan Mat/Parlak Vernik)",
        "Çatlak Tamiri Paketi (V-Yatak Açma ve Epoksi Enjeksiyon Uygulaması)"
      ]
    }
  ];
}