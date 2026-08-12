// lib/core/calculation/meslek_sorulari/su_yalitimi.dart - FINAL
class SuYalitimiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Yapı ve Uygulama Durumu",
      "type": "single",
      "required": true,
      "options": ["Yeni İnşaat Temel Bohçalama", "Mevcut Bina Bodrum Su Alma Onarım", "İstinat Duvarı Toprak Altı Dikey Koruma"]
    },
    // YENİ İNŞAAT DALI
    {
      "id": "yalitim_teknik_yeni",
      "label": "Ana İzolasyon Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Yeni İnşaat Temel Bohçalama"],
      "options": ["Bitümlü Membran Çift Kat Şaloma", "Poliüretan Sürme Likit Elastik", "Polyurea Reaktörlü Püskürtme Anında Kürlenen"]
    },
    {
      "id": "alan_yeni",
      "label": "Yatay Temel Taban Alanı m²",
      "type": "single",
      "required": true,
      "dependsOnId": "yalitim_teknik_yeni",
      "options": ["0-100 m² Küçük Temel", "101-250 m² Standart Müstakil Bina", "251-500 m² Geniş Apartman Site", "501 m² Üzeri Endüstriyel Fabrika"]
    },
    {
      "id": "ana_sorun_yeni",
      "label": "İhtiyaç Kapsamı",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_yeni",
      "options": ["Sıfırdan Komple Bohçalama", "Tabandan Su Kusması Önlem", "Duvar Nem Küf Rutubet Önlem", "Çatlak Sızıntı Önlem"]
    },
    {
      "id": "ekstra_yeni",
      "label": "Altyapı Koruma Mukavemet Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "ana_sorun_yeni",
      "options": [
        "Drenaj Boru Keçeli Mıcır Tahliye",
        "Pah Bandı Köşe Güçlendirme",
        "XPS Isı Yalıtım Koruma Plaka",
        "Su Tutucu Şişen Bant Soğuk Derz Bariyer",
        "Ekstra İstemiyorum"
      ]
    },
    // MEVCUT BİNA DALI
    {
      "id": "perde_uzunluk_mevcut",
      "label": "Çevre Perde Beton Uzunluk Metre",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mevcut Bina Bodrum Su Alma Onarım"],
      "options": ["1-25 Metre Kısa", "26-60 Metre Standart Çevre", "61-120 Metre Geniş Çevre", "121 Metre Üzeri Ticari Endüstriyel"]
    },
    {
      "id": "bodrum_yukseklik_mevcut",
      "label": "Bodrum Perde Yüksekliği Metre",
      "type": "single",
      "required": true,
      "dependsOnId": "perde_uzunluk_mevcut",
      "options": ["0-2.5 Metre Alçak", "2.6-3.5 Metre Standart Kat", "3.6-5.0 Metre Yüksek Perde", "5.0 Metre Üzeri Çift Katlı Derin"]
    },
    {
      "id": "derinlik_mevcut",
      "label": "Temel Derinlik Zemin Altı Metre",
      "type": "single",
      "required": true,
      "dependsOnId": "bodrum_yukseklik_mevcut",
      "options": ["0-1.5 Metre Yüzeysel", "1.6-3.5 Metre Tek Bodrum", "3.6-6.0 Metre Çift Bodrum Derin Kazı", "6.0 Metre Üzeri Çok Katlı Derin"]
    },
    {
      "id": "yalitim_mevcut",
      "label": "Ana İzolasyon Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "derinlik_mevcut",
      "options": ["Bitümlü Membran", "Poliüretan Sürme Ek Yersiz", "Polyurea Reaktörlü"]
    },
    {
      "id": "ana_sorun_mevcut",
      "label": "Kritik Sorun",
      "type": "single",
      "required": true,
      "dependsOnId": "yalitim_mevcut",
      "options": ["Tabandan Aktif Su Çıkması", "Duvar Nem Küf Rutubet", "Perde Çatlak Sızıntı", "Komple Bohçalama İhtiyaç"]
    },
    {
      "id": "ekstra_mevcut",
      "label": "Altyapı Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "ana_sorun_mevcut",
      "options": ["Drenaj Hattı Mıcır", "Pah Bandı Köşe Güçlendirme", "XPS Koruma Plaka", "Su Tutucu Bant", "Ekstra İstemiyorum"]
    },
    // İSTİNAT DALI
    {
      "id": "perde_istinat",
      "label": "Perde Uzunluk Metre",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["İstinat Duvarı Toprak Altı Dikey Koruma"],
      "options": ["1-25 Metre", "26-60 Metre", "61-120 Metre", "121 Metre Üzeri"]
    },
    {
      "id": "yukseklik_istinat",
      "label": "Perde Yüksekliği",
      "type": "single",
      "required": true,
      "dependsOnId": "perde_istinat",
      "options": ["0-2.5 Metre Alçak", "2.6-3.5 Metre Standart", "3.6-5.0 Metre Yüksek", "5.0 Metre Üzeri Derin"]
    },
    {
      "id": "derinlik_istinat",
      "label": "Derinlik",
      "type": "single",
      "required": true,
      "dependsOnId": "yukseklik_istinat",
      "options": ["0-1.5 Metre", "1.6-3.5 Metre", "3.6-6.0 Metre", "6.0 Metre Üzeri"]
    },
    {
      "id": "yalitim_istinat",
      "label": "Teknoloji",
      "type": "single",
      "required": true,
      "dependsOnId": "derinlik_istinat",
      "options": ["Bitümlü Membran", "Poliüretan Sürme", "Polyurea"]
    },
    {
      "id": "ekstra_istinat",
      "label": "Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "yalitim_istinat",
      "options": ["Drenaj Boru Mıcır", "Pah Bandı", "XPS Koruma", "Su Tutucu Şerit", "Ekstra İstemiyorum"]
    }
  ];
}