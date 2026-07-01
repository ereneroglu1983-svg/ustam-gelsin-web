// lib/core/calculation/meslek_sorulari/gergi_tavan.dart

class GergiTavanSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ ANA TETİKLEYİCİ: İş kapsamını belirleyerek alt akışları kilitler
      "label": "Gergi Tavan Uygulama Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)",
        "Mevcut Sisteme Sadece Yeni Membran/Kumaş Değişimi (LED Hariç)",
        "Sadece Aydınlatma / LED ve Trafo Arıza Onarımı"
      ]
    },
    {
      "id": "membran_tipi", // Hesaplayıcıda m² fiyatını ve asgari barajı belirler
      "label": "Kullanılacak Membran Dokusu ve Baskı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)",
        "Mevcut Sisteme Sadece Yeni Membran/Kumaş Değişimi (LED Hariç)"
      ],
      "options": [
        "Transparan (Işık Geçirgen) Standart Beyaz Doku",
        "Dijital Baskılı / UV Mürekkep Desenli Membran",
        "Lake / Ayna Etkili (Yüksek Yansıtıcılı Premium Yüzey)",
        "3D / Formlu Gergi Tavan (Özel Bükümlü Karkas Yapılı)"
      ]
    },
    {
      "id": "alan_segmenti", // Hesaplayıcıda m² aralıklarını kontrol ederek otomatik m² atar
      "label": "Uygulama Yapılacak Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)",
        "Mevcut Sisteme Sadece Yeni Membran/Kumaş Değişimi (LED Hariç)",
        "Sadece Aydınlatma / LED ve Trafo Arıza Onarımı"
      ],
      "options": [
        "0-5 m² Arası (Küçük Alan / Koridor / WC)",
        "5-15 m² Arası (Standart Oda / Salon)",
        "15-30 m² Arası (Büyük Salon / Mağaza)",
        "30 m² ve Üzeri (Geniş Ofis / Havuz Üstü)"
      ]
    },
    {
      "id": "metre_kare", // Net m² girilirse robot segment yerine doğrudan bu sayıyı çarpar
      "label": "Net Alan Ölçüsü Girin (m² - Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 18",
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)",
        "Mevcut Sisteme Sadece Yeni Membran/Kumaş Değişimi (LED Hariç)",
        "Sadece Aydınlatma / LED ve Trafo Arıza Onarımı"
      ]
    },
    {
      "id": "aydinlatma_tipi", // Hesaplayıcıda m² başına Samsung/Osram altyapı maliyeti ekler
      "label": "Aydınlatma Altyapı Seçimi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)"],
      "options": [
        "Full Modül LED Paketi (Aydınlatma Altyapısı Dahil)",
        "Sadece Gergi Tavan Kumaşı (LED Aydınlatma Hariç)"
      ]
    },
    {
      "id": "ekstra_ozellikler", // 🛠️ REVIZE: Senkronizasyon hatasına neden olan kelimeler uyarlandı
      "label": "Tasarım Geometrisi ve Donanım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)"],
      "options": [
        "RGB / Uzaktan Kumandalı Renk Değiştiren Işık Sistemi",
        "Daire / Oval / Kavisli Özel Geometrik Tasarım Uygulaması",
        "Lake Fitil Uygulaması (Kenar Bitişleri İçin Estetik Dekoratif Fitil)",
        "Teleskopik Karkas Askı Sistemi (Yüksek Kot Farkı ve Taşıyıcı İskelet Kurulumu)"
      ]
    },
    {
      "id": "yukseklik", // Ustanın iskele/çalışma zorluğunu görmesi için kalan tek yardımcı alan
      "label": "Tavan Yüksekliği Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)",
        "Mevcut Sisteme Sadece Yeni Membran/Kumaş Değişimi (LED Hariç)"
      ],
      "options": [
        "Standart (2.5 - 3m)",
        "Yüksek Tavan (3 - 4.5m)",
        "Endüstriyel (4.5m+)"
      ]
    }
  ];
}