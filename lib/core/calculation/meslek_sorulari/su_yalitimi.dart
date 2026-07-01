// lib/core/calculation/meslek_sorulari/su_yalitimi.dart

class SuYalitimiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "yapi_durumu", // 🛠️ KİLİT TETİKLEYİCİ: Radikal akış belirleyici parametre
      "label": "Yapı ve Uygulama Mevcut Durumu",
      "type": "single",
      "required": true,
      "options": [
        "Yeni İnşaat (Temel Aşamasında Komple Bohçalama Sistemi)",
        "Mevcut Bina (Bodrum Kattan Su Alma / Perde Beton İzolasyon Onarımı)",
        "İstinat Duvarı Yalıtımı (Toprak Altı Dikey Yüzey Koruma)"
      ]
    },
    {
      "id": "yalitimi_tipi", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, ana seçim yapılmadan görünmez
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

    // ==========================================
    // 📐 ÖLÇÜ VE METRAJ PARAMETRELERİ (Seçmeli Sekme Yapısına Geçirildi)
    // ==========================================
    {
      "id": "alan_m2", // 🛠️ SEÇMELİ SEKME: Text kaldırıldı, aralık getirildi
      "label": "Yatay Temel Taban Alanı (Net m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_durumu",
      "dependsOnValue": ["Yeni İnşaat (Temel Aşamasında Komple Bohçalama Sistemi)"],
      "options": [
        "0 - 100 m² Arası Küçük Ölçekli Temel Tabanı",
        "101 - 250 m² Arası Standart Müstakil Yapı / Bina Temeli",
        "251 - 500 m² Arası Geniş Apartman / Site Bloğu Temeli",
        "501 m² ve Üzeri Büyük Endüstriyel Tesis / Fabrika Tabanı"
      ]
    },
    {
      "id": "perde_uzunluk_m", // 🛠️ SEÇMELİ SEKME: Text kaldırıldı, aralık getirildi
      "label": "Çevre Perde Beton Toplam Uzunluğu (Doğrusal Metre)",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_durumu",
      "dependsOnValue": [
        "Mevcut Bina (Bodrum Kattan Su Alma / Perde Beton İzolasyon Onarımı)",
        "İstinat Duvarı Yalıtımı (Toprak Altı Dikey Yüzey Koruma)"
      ],
      "options": [
        "1 - 25 Metre Arası Kısa Hat",
        "26 - 60 Metre Arası Standart Çevre Uzunluğu",
        "61 - 120 Metre Arası Geniş Bina Çevresi",
        "121 Metre ve Üzeri Uzun Ticari / Endüstriyel Hat"
      ]
    },
    {
      "id": "bodrum_yukseklik_m", // 🛠️ SEÇMELİ SEKME: Text kaldırıldı, aralık getirildi
      "label": "Bodrum Duvarı / Perde Beton Yüksekliği (Metre)",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_durumu",
      "dependsOnValue": [
        "Mevcut Bina (Bodrum Kattan Su Alma / Perde Beton İzolasyon Onarımı)",
        "İstinat Duvarı Yalıtımı (Toprak Altı Dikey Yüzey Koruma)"
      ],
      "options": [
        "0.0 - 2.5 Metre Arası Alçak Bodrum Perdesi",
        "2.6 - 3.5 Metre Arası Standart Kat Yüksekliği",
        "3.6 - 5.0 Metre Arası Yüksek Perde Beton",
        "5.0 Metre Üzeri Çift Katlı / Derin İstinat Hattı"
      ]
    },
    {
      "id": "yapi_derinlik_m", // 🛠️ SEÇMELİ SEKME: Text kaldırıldı, aralık getirildi
      "label": "Yapı Temel Derinliği (Zemin Altı Kaç Metre Sıfır Noktası?)",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_durumu",
      "dependsOnValue": [
        "Mevcut Bina (Bodrum Kattan Su Alma / Perde Beton İzolasyon Onarımı)",
        "İstinat Duvarı Yalıtımı (Toprak Altı Dikey Yüzey Koruma)"
      ],
      "options": [
        "0.0 - 1.5 Metre Yüzeysel Temel Kotu",
        "1.6 - 3.5 Metre Tek Kat Bodrum Derinliği",
        "3.6 - 6.0 Metre Çift Kat Bodrum / Derin Kazı Kotu",
        "6.0 Metre Üzeri Çok Katlı Derin Bodrum Alanı"
      ]
    },

    // ==========================================
    // ⚙️ ALTYAPI ÇÖZÜMLERİ VE TAKVİYE EKSTRALARI
    // ==========================================
    {
      "id": "ana_sorun", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, ana seçim yapılmadan görünmez
      "label": "Gözlemlenen Kritik Sorun / İhtiyaç Kapsamı",
      "type": "multi",
      "required": false,
      "dependsOnId": "yapi_durumu",
      "dependsOnValue": [
        "Yeni İnşaat (Temel Aşamasında Komple Bohçalama Sistemi)",
        "Mevcut Bina (Bodrum Kattan Su Alma / Perde Beton İzolasyon Onarımı)",
        "İstinat Duvarı Yalıtımı (Toprak Altı Dikey Yüzey Koruma)"
      ],
      "options": [
        "Tabandan Aktif Su Çıkması / Kusması",
        "Duvarlarda Kronik Nem, Küf ve Rutubet Oluşumu",
        "Perde Beton Çatlaklarından Sızıntı Suyu",
        "Sıfırdan Komple Güvenlikli Bohçalama Yapılması"
      ]
    },
    {
      "id": "ekstra_ozellikler", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, ana seçim yapılmadan görünmez
      "label": "Altyapı Çözümleri, Koruma Plakaları ve Mukavemet Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "yapi_durumu",
      "dependsOnValue": [
        "Yeni İnşaat (Temel Aşamasında Komple Bohçalama Sistemi)",
        "Mevcut Bina (Bodrum Kattan Su Alma / Perde Beton İzolasyon Onarımı)",
        "İstinat Duvarı Yalıtımı (Toprak Altı Dikey Yüzey Koruma)"
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