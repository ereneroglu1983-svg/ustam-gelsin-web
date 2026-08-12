// lib/core/calculation/meslek_sorulari/prefabrik_yapi.dart - FINAL
class PrefabrikYapiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Talep Edilen Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Sıfırdan İmalat Anahtar Teslim Kurulum", "Mevcut Yapı Onarım Tamir Tadilat", "Lojistik Nakliye Yer Değiştirme"]
    },
    // SIFIRDAN DALI
    {
      "id": "yapi_tipi",
      "label": "İmalat Ana Yapı Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan İmalat Anahtar Teslim Kurulum"],
      "options": ["Prefabrik Konut Galvaniz Hafif Çelik Panel", "Ahşap Bungalov İthal Çam Üçgen Lambri", "Çelik Konstrüksiyon Ağır Statik Deprem Yönetmelikli"]
    },
    {
      "id": "kat_sayisi",
      "label": "Kat Mimarisi Yük Endeksi",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tipi",
      "options": ["Tek Katlı Mimari", "Dubleks İki Katlı Ağır Şase Güçlendirmeli"]
    },
    {
      "id": "alan_sifir",
      "label": "Net Toplam Alan m²",
      "type": "single",
      "required": true,
      "dependsOnId": "kat_sayisi",
      "options": ["0-45 m² Küçük", "45-85 m² Standart Konut", "85-130 m² Geniş Aile", "130 m² Üzeri Endüstriyel"]
    },
    {
      "id": "nakliye_sifir",
      "label": "Sevk Mesafesi Lojistik Kademe",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_sifir",
      "options": ["0-50 KM Yakın", "50-150 KM Orta", "150-350 KM Uzak", "350 KM Üzeri Şehirler Arası"]
    },
    {
      "id": "ekstra_sifir",
      "label": "Altyapı Yalıtım Konfor Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "nakliye_sifir",
      "options": [
        "Yoğun Taş Yünü Ekstra Yalıtım",
        "Yerden Isıtma Altyapı Strafor Borulama",
        "Alüminyum Konfor Cam Isı Yalıtımlı Premium",
        "Subasman Beton Hasırlı Kalıp Döküm",
        "Veranda Sundurma Çelik Kapalı Alan",
        "Zor Arazi Dik Eğim Çift Bomlu Vinç",
        "Ekstra İstemiyorum"
      ]
    },
    // ONARIM DALI
    {
      "id": "alan_onarim",
      "label": "Yapı Net Alan m²",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mevcut Yapı Onarım Tamir Tadilat"],
      "options": ["0-45 m²", "45-85 m²", "85-130 m²", "130 m² Üzeri"]
    },
    {
      "id": "tamir_detay",
      "label": "Onarılacak Revize Bölümler",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_onarim",
      "options": [
        "Çatı Akması Membran İzolasyon Yenileme",
        "Taban Çürümesi Şase Alt Sac Yenileme",
        "Dış Cephe Boya Betopan Revizyon",
        "Tesisat Elektrik Altyapı Yenileme",
        "Sandviç Panel Değişim Duvar Yalıtım"
      ]
    },
    {
      "id": "ekstra_onarim",
      "label": "Ekstra",
      "type": "multi",
      "required": true,
      "dependsOnId": "tamir_detay",
      "options": ["Ekstra Yalıtım", "Yerden Isıtma", "Konfor Cam", "Zor Arazi Vinç", "Ekstra İstemiyorum"]
    },
    // LOJİSTİK DALI
    {
      "id": "alan_lojistik",
      "label": "Yapı Net Alan m²",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Lojistik Nakliye Yer Değiştirme"],
      "options": ["0-45 m²", "45-85 m²", "85-130 m²", "130 m² Üzeri"]
    },
    {
      "id": "nakliye_lojistik",
      "label": "Sevk Mesafesi Kademe",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_lojistik",
      "options": ["0-50 KM Yakın", "50-150 KM Orta", "150-350 KM Uzak", "350 KM Üzeri Uzun Hat"]
    }
  ];
}