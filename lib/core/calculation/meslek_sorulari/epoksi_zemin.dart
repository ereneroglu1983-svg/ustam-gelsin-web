// lib/core/calculation/meslek_sorulari/epoksi_zemin.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class EpoksiZeminSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Epoksi Uygulama İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Sıfırdan Epoksi Zemin Kaplama",
        "Mevcut Epoksi Zeminin Lokal Onarımı ve Çatlak Tamiri"
      ]
    },

    // ADIM 2: KAPLAMA TİPİ - sadece Komple'de gelsin
    {
      "id": "kaplama_tipi",
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

    // ADIM 3: ALAN - Kaplama sonrası veya Lokal'de direkt kökten gelsin
    {
      "id": "alan_segmenti",
      "label": "Uygulanacak Toplam Alan Aralığı",
      "type": "single",
      "required": true,
      "dependsOnId": ["kaplama_tipi", "is_kapsami"],
      "dependsOnValue": [
        "Self-Leveling Epoksi (Düz ve Pürüzsüz Başlangıç)",
        "Portakal Kabuğu (Textured - Kaymaz Yüzeyli Endüstriyel)",
        "Metalik Epoksi (Dekoratif Mermer Görünümlü Artistik)",
        "3D Görsel / Grafik Tasarım Kaplama (Likit Cam Korumalı)",
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

    // ADIM 4: NET ALAN - alan seçilince gelsin
    {
      "id": "metre_kare",
      "label": "Net Alan Ölçüsü Girin (m² - Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 120",
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-50 m² Arası",
        "50-100 m² Arası",
        "100-250 m² Arası",
        "250-500 m² Arası",
        "500 m² ve Üzeri"
      ]
    },

    // ADIM 5: ZEMİN DURUMU - sadece Komple'de ve alan sonrası gelsin
    {
      "id": "zemin_durumu",
      "label": "Mevcut Zemin Yapısı ve Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "visibleIf": {"is_kapsami": "Komple Sıfırdan Epoksi Zemin Kaplama"},
      "dependsOnValue": [
        "0-50 m² Arası",
        "50-100 m² Arası",
        "100-250 m² Arası",
        "250-500 m² Arası",
        "500 m² ve Üzeri"
      ],
      "options": [
        "Eski Beton (Ağır Elmas Silim ve Vakumlu Toz Emme Gerektirir)",
        "Seramik / Fayans Zemin (Pürüzlendirme ve Özel Geçiş Astarlı)",
        "Helikopter Şap Zemin (Hafif Zımparalı Hazır Yüzey)"
      ]
    },

    // ADIM 6: HASAR DURUMU - zemin seçilince gelsin (sadece 2 zemin tipinde)
    {
      "id": "zemin_hasar_durumu",
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

    // ADIM 7: FİNAL - zemin sonrası veya Helikopter şapta hasar gelmediği için direkt zemin sonrası
    {
      "id": "ekstra_ozellikler",
      "label": "Teknik Katmanlar ve Sektörel Ekstralar",
      "type": "multi",
      "required": false,
      "dependsOnId": ["zemin_durumu", "zemin_hasar_durumu"],
      "dependsOnValue": [
        "Eski Beton (Ağır Elmas Silim ve Vakumlu Toz Emme Gerektirir)",
        "Seramik / Fayans Zemin (Pürüzlendirme ve Özel Geçiş Astarlı)",
        "Helikopter Şap Zemin (Hafif Zımparalı Hazır Yüzey)",
        "Yüzeyde Derin Çatlaklar ve Kırıklar Var (Tamir Macunu İhtiyacı)",
        "Zeminde Yoğun Tozuma Problemi Mevcut",
        "Endüstriyel Yağlanma / Kimyasal Atık Var (Özel Solventli Yıkama Gerekli)"
      ],
      "options": [
        "Nem Bariyeri Katmanı (Zeminden Su Yürümesini Engelleyen Özel Astar)",
        "Anti-Statik Sistem (Laboratuvar/Data Merkezleri İçin Bakır Şeritli Statik Alıcı)",
        "Ekstra Koruyucu Kat (Çizilmelere Karşı Poliüretan Mat/Parlak Vernik)",
        "Çatlak Tamiri Paketi (V-Yatak Açma ve Epoksi Enjeksiyon Uygulaması)"
      ]
    }
  ];
}