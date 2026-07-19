// lib/core/calculation/meslek_sorulari/su_yalitimi.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class SuYalitimiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "yapi_durumu",
      "label": "Yapı ve Uygulama Mevcut Durumu",
      "type": "single",
      "required": true,
      "options": [
        "Yeni İnşaat (Temel Aşamasında Komple Bohçalama Sistemi)",
        "Mevcut Bina (Bodrum Kattan Su Alma / Perde Beton İzolasyon Onarımı)",
        "İstinat Duvarı Yalıtımı (Toprak Altı Dikey Yüzey Koruma)"
      ]
    },

    // ADIM 2: YALITIM TİPİ - kök sonrası gelsin
    {
      "id": "yalitimi_tipi",
      "label": "Uygulanacak Ana İzolasyon ve Yalıtım Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_durumu",
      "dependsOnValue": [
        "Yeni İnşaat (Temel Aşamasında Komple Bohçalama Sistemi)",
        "Mevcut Bina (Bodrum Kattan Su Alma / Perde Beton İzolasyon Onarımı)",
        "İstinat Duvarı Yalıtımı (Toprak Altı Dikey Yüzey Koruma)"
      ],
      "options": [
        "Bitümlü Membran (Bohçalama - Çift Kat Şaloma Alevli Standart Eritme Sistem)",
        "Poliüretan Sürme Esaslı Yalıtım (Ek Yersiz, Lüks Elastikiyetli Likit Kimyasal Kaplama)",
        "Polyurea İzolasyon (Mobil Araçla Reaktörlü Uygulanan, Anında Kürlenen Püskürtme Sistem)"
      ]
    },

    // ========== YENİ İNŞAAT YOLU ==========
    {
      "id": "alan_m2",
      "label": "Yatay Temel Taban Alanı (Net m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "yalitimi_tipi",
      "visibleIf": {"yapi_durumu": "Yeni İnşaat (Temel Aşamasında Komple Bohçalama Sistemi)"},
      "dependsOnValue": [
        "Bitümlü Membran (Bohçalama - Çift Kat Şaloma Alevli Standart Eritme Sistem)",
        "Poliüretan Sürme Esaslı Yalıtım (Ek Yersiz, Lüks Elastikiyetli Likit Kimyasal Kaplama)",
        "Polyurea İzolasyon (Mobil Araçla Reaktörlü Uygulanan, Anında Kürlenen Püskürtme Sistem)"
      ],
      "options": [
        "0 - 100 m² Arası Küçük Ölçekli Temel Tabanı",
        "101 - 250 m² Arası Standart Müstakil Yapı / Bina Temeli",
        "251 - 500 m² Arası Geniş Apartman / Site Bloğu Temeli",
        "501 m² ve Üzeri Büyük Endüstriyel Tesis / Fabrika Tabanı"
      ]
    },

    // ========== MEVCUT / İSTİNAT YOLU ==========
    {
      "id": "perde_uzunluk_m",
      "label": "Çevre Perde Beton Toplam Uzunluğu (Doğrusal Metre)",
      "type": "single",
      "required": true,
      "dependsOnId": "yalitimi_tipi",
      "visibleIf": {
        "yapi_durumu": [
          "Mevcut Bina (Bodrum Kattan Su Alma / Perde Beton İzolasyon Onarımı)",
          "İstinat Duvarı Yalıtımı (Toprak Altı Dikey Yüzey Koruma)"
        ]
      },
      "dependsOnValue": [
        "Bitümlü Membran (Bohçalama - Çift Kat Şaloma Alevli Standart Eritme Sistem)",
        "Poliüretan Sürme Esaslı Yalıtım (Ek Yersiz, Lüks Elastikiyetli Likit Kimyasal Kaplama)",
        "Polyurea İzolasyon (Mobil Araçla Reaktörlü Uygulanan, Anında Kürlenen Püskürtme Sistem)"
      ],
      "options": [
        "1 - 25 Metre Arası Kısa Hat",
        "26 - 60 Metre Arası Standart Çevre Uzunluğu",
        "61 - 120 Metre Arası Geniş Bina Çevresi",
        "121 Metre ve Üzeri Uzun Ticari / Endüstriyel Hat"
      ]
    },
    {
      "id": "bodrum_yukseklik_m",
      "label": "Bodrum Duvarı / Perde Beton Yüksekliği (Metre)",
      "type": "single",
      "required": true,
      "dependsOnId": "perde_uzunluk_m",
      "dependsOnValue": [
        "1 - 25 Metre Arası Kısa Hat",
        "26 - 60 Metre Arası Standart Çevre Uzunluğu",
        "61 - 120 Metre Arası Geniş Bina Çevresi",
        "121 Metre ve Üzeri Uzun Ticari / Endüstriyel Hat"
      ],
      "options": [
        "0.0 - 2.5 Metre Arası Alçak Bodrum Perdesi",
        "2.6 - 3.5 Metre Arası Standart Kat Yüksekliği",
        "3.6 - 5.0 Metre Arası Yüksek Perde Beton",
        "5.0 Metre Üzeri Çift Katlı / Derin İstinat Hattı"
      ]
    },
    {
      "id": "yapi_derinlik_m",
      "label": "Yapı Temel Derinliği (Zemin Altı Kaç Metre Sıfır Noktası?)",
      "type": "single",
      "required": true,
      "dependsOnId": "bodrum_yukseklik_m",
      "dependsOnValue": [
        "0.0 - 2.5 Metre Arası Alçak Bodrum Perdesi",
        "2.6 - 3.5 Metre Arası Standart Kat Yüksekliği",
        "3.6 - 5.0 Metre Arası Yüksek Perde Beton",
        "5.0 Metre Üzeri Çift Katlı / Derin İstinat Hattı"
      ],
      "options": [
        "0.0 - 1.5 Metre Yüzeysel Temel Kotu",
        "1.6 - 3.5 Metre Tek Kat Bodrum Derinliği",
        "3.6 - 6.0 Metre Çift Kat Bodrum / Derin Kazı Kotu",
        "6.0 Metre Üzeri Çok Katlı Derin Bodrum Alanı"
      ]
    },

    // ADIM: ORTAK ANA SORUN - Yeni'de alan sonrası, Mevcut/İstinat'ta derinlik sonrası gelsin
    {
      "id": "ana_sorun",
      "label": "Gözlemlenen Kritik Sorun / İhtiyaç Kapsamı",
      "type": "multi",
      "required": false,
      "dependsOnId": ["alan_m2", "yapi_derinlik_m"],
      "dependsOnValue": [
        "0 - 100 m² Arası Küçük Ölçekli Temel Tabanı",
        "101 - 250 m² Arası Standart Müstakil Yapı / Bina Temeli",
        "251 - 500 m² Arası Geniş Apartman / Site Bloğu Temeli",
        "501 m² ve Üzeri Büyük Endüstriyel Tesis / Fabrika Tabanı",
        "0.0 - 1.5 Metre Yüzeysel Temel Kotu",
        "1.6 - 3.5 Metre Tek Kat Bodrum Derinliği",
        "3.6 - 6.0 Metre Çift Kat Bodrum / Derin Kazı Kotu",
        "6.0 Metre Üzeri Çok Katlı Derin Bodrum Alanı"
      ],
      "options": [
        "Tabandan Aktif Su Çıkması / Kusması",
        "Duvarlarda Kronik Nem, Küf ve Rutubet Oluşumu",
        "Perde Beton Çatlaklarından Sızıntı Suyu",
        "Sıfırdan Komple Güvenlikli Bohçalama Yapılması"
      ]
    },

    // ADIM FİNAL: EKSTRA - ana sorun sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Altyapı Çözümleri, Koruma Plakaları ve Mukavemet Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "ana_sorun",
      "dependsOnValue": [
        "Tabandan Aktif Su Çıkması / Kusması",
        "Duvarlarda Kronik Nem, Küf ve Rutubet Oluşumu",
        "Perde Beton Çatlaklarından Sızıntı Suyu",
        "Sıfırdan Komple Güvenlikli Bohçalama Yapılması"
      ],
      "options": [
        "Drenaj Boru Hattı Kurulumu ve Keçeli Mıcır Serimi (Suyun Yapıya Yaklaşmasını Engelleyen Tahliye Hattı)",
        "Pah Bandı / Köşe Güçlendirmesi Uygulaması (Kritik Dikey ve Yatay Birleşim Noktaları Köşe Pahı İşçiliği)",
        "XPS Isı Yalıtım Levhası ile Koruma (Yalıtım Üzeri Ekstra Isı İzolasyonu ve Mekanik Darbe Koruma Plakası)",
        "Su Tutucu Şerit (Şişen Bant) Montajı (İnşaat Soğuk Derz Alanlarında Akıllı Su Sızdırmazlık Bariyeri)"
      ]
    }
  ];
}