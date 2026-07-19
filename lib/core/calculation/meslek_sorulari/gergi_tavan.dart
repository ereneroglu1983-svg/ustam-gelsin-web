// lib/core/calculation/meslek_sorulari/gergi_tavan.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class GergiTavanSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Gergi Tavan Uygulama Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)",
        "Mevcut Sisteme Sadece Yeni Membran/Kumaş Değişimi (LED Hariç)",
        "Sadece Aydınlatma / LED ve Trafo Arıza Onarımı"
      ]
    },

    // ADIM 2: MEMBRAN - Sıfırdan ve Membran Değişiminde gelsin
    {
      "id": "membran_tipi",
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

    // ADIM 3: ALAN - Membran sonrası veya Aydınlatma Onarımda direkt kökten gelsin
    {
      "id": "alan_segmenti",
      "label": "Uygulama Yapılacak Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": ["membran_tipi", "is_kapsami"],
      "dependsOnValue": [
        "Transparan (Işık Geçirgen) Standart Beyaz Doku",
        "Dijital Baskılı / UV Mürekkep Desenli Membran",
        "Lake / Ayna Etkili (Yüksek Yansıtıcılı Premium Yüzey)",
        "3D / Formlu Gergi Tavan (Özel Bükümlü Karkas Yapılı)",
        "Sadece Aydınlatma / LED ve Trafo Arıza Onarımı"
      ],
      "options": [
        "0-5 m² Arası (Küçük Alan / Koridor / WC)",
        "5-15 m² Arası (Standart Oda / Salon)",
        "15-30 m² Arası (Büyük Salon / Mağaza)",
        "30 m² ve Üzeri (Geniş Ofis / Havuz Üstü)"
      ]
    },

    // ADIM 4: NET ALAN - alan seçilince gelsin
    {
      "id": "metre_kare",
      "label": "Net Alan Ölçüsü Girin (m² - Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 18",
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-5 m² Arası (Küçük Alan / Koridor / WC)",
        "5-15 m² Arası (Standart Oda / Salon)",
        "15-30 m² Arası (Büyük Salon / Mağaza)",
        "30 m² ve Üzeri (Geniş Ofis / Havuz Üstü)"
      ]
    },

    // ADIM 5: AYDINLATMA - sadece Sıfırdan'da ve net alan sonrası gelsin
    {
      "id": "aydinlatma_tipi",
      "label": "Aydınlatma Altyapı Seçimi",
      "type": "single",
      "required": true,
      "dependsOnId": "metre_kare",
      "visibleIf": {
        "is_kapsami": "Sıfırdan Komple Gergi Tavan Sistemi (Karkas + LED + Membran)"
      },
      "dependsOnValue": [
        "0-5 m² Arası (Küçük Alan / Koridor / WC)",
        "5-15 m² Arası (Standart Oda / Salon)",
        "15-30 m² Arası (Büyük Salon / Mağaza)",
        "30 m² ve Üzeri (Geniş Ofis / Havuz Üstü)"
      ],
      "options": [
        "Full Modül LED Paketi (Aydınlatma Altyapısı Dahil)",
        "Sadece Gergi Tavan Kumaşı (LED Aydınlatma Hariç)"
      ]
    },

    // ADIM 6: YÜKSEKLİK - Sıfırdan'da aydınlatma sonrası, Membran Değişimde direkt net alan sonrası
    {
      "id": "yukseklik",
      "label": "Tavan Yüksekliği Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": ["aydinlatma_tipi", "metre_kare"],
      "dependsOnValue": [
        "Full Modül LED Paketi (Aydınlatma Altyapısı Dahil)",
        "Sadece Gergi Tavan Kumaşı (LED Aydınlatma Hariç)",
        "0-5 m² Arası (Küçük Alan / Koridor / WC)",
        "5-15 m² Arası (Standart Oda / Salon)",
        "15-30 m² Arası (Büyük Salon / Mağaza)",
        "30 m² ve Üzeri (Geniş Ofis / Havuz Üstü)"
      ],
      "options": [
        "Standart (2.5 - 3m)",
        "Yüksek Tavan (3 - 4.5m)",
        "Endüstriyel (4.5m+)"
      ]
    },

    // ADIM 7: FİNAL - sadece Sıfırdan'da yükseklik sonrası yeşil kutuda açılsın
    {
      "id": "ekstra_ozellikler",
      "label": "Tasarım Geometrisi ve Donanım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "yukseklik",
      "dependsOnValue": [
        "Standart (2.5 - 3m)",
        "Yüksek Tavan (3 - 4.5m)",
        "Endüstriyel (4.5m+)"
      ],
      "options": [
        "RGB / Uzaktan Kumandalı Renk Değiştiren Işık Sistemi",
        "Daire / Oval / Kavisli Özel Geometrik Tasarım Uygulaması",
        "Lake Fitil Uygulaması (Kenar Bitişleri İçin Estetik Dekoratif Fitil)",
        "Teleskopik Karkas Askı Sistemi (Yüksek Kot Farkı ve Taşıyıcı İskelet Kurulumu)"
      ]
    }
  ];
}