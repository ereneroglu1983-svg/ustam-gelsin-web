// lib/core/calculation/meslek_sorulari/prefabrik_yapi.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class PrefabrikYapiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Talep Edilen Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan İmalat / Anahtar Teslim Kurulum Hizmeti",
        "Mevcut Yapı İçin Onarım, Tamir ve Tadilat",
        "Lojistik, Nakliye ve Başka Sahaya Yer Değiştirme"
      ]
    },

    // ========== SIFIRDAN İMALAT YOLU ==========
    {
      "id": "yapi_tipi",
      "label": "İmalatı Yapılacak Ana Yapı Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan İmalat / Anahtar Teslim Kurulum Hizmeti"],
      "options": [
        "Prefabrik Konut (Galvaniz Hafif Çelik Profil ve Standart Panel Yapı Tabanlı)",
        "Ahşap Bungalov (İthal Çam Malzeme, Üçgen Karkas ve Yoğun Lambri İşçilikli)",
        "Çelik Konstrüksiyon (Statik Hesaplı Resmi Deprem Yönetmeliğine Uygun Ağır Çelik)"
      ]
    },
    {
      "id": "kat_sayisi",
      "label": "Yapının Kat Mimarisi ve Yük Endeksi",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tipi",
      "dependsOnValue": [
        "Prefabrik Konut (Galvaniz Hafif Çelik Profil ve Standart Panel Yapı Tabanlı)",
        "Ahşap Bungalov (İthal Çam Malzeme, Üçgen Karkas ve Yoğun Lambri İşçilikli)",
        "Çelik Konstrüksiyon (Statik Hesaplı Resmi Deprem Yönetmeliğine Uygun Ağır Çelik)"
      ],
      "options": [
        "Tek Katlı Mimari Yapı Planyası",
        "Dubleks (İki Katlı Çelik Karkas ve Ağır Şase Güçlendirmeli Yapı Mimarisi)"
      ]
    },

    // ========== ONARIM YOLU ==========
    {
      "id": "tamir_detay",
      "label": "Onarılacak ve Revize Edilecek Yapı Bölümleri",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mevcut Yapı İçin Onarım, Tamir ve Tadilat"],
      "options": [
        "Çatı Akması Onarımı ve Komple Membran İzolasyon Yenilemesi",
        "Taban Çürümesi Tamiri ve Çelik Şase Alt Taban Sacı Yenileme",
        "Dış Cephe Boya İşçiliği ve Betopan Kompozit Kaplama Revizyonu",
        "Sıhhi Tesisat / Elektrik Altyapı Hatları Yenileme ve Arıza Tamiri",
        "Deforme Olmuş Sandviç Panel Değişimi ve Duvar İçi Yalıtım Desteği"
      ]
    },

    // ADIM: ALAN - Sıfırdan'da kat sonrası, Onarım'da detay sonrası, Lojistik'te direkt kökten gelsin
    {
      "id": "alan_m2",
      "label": "Yapının Yaklaşık Net Toplam Alanı (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": ["kat_sayisi", "tamir_detay", "is_kapsami"],
      "dependsOnValue": [
        "Tek Katlı Mimari Yapı Planyası",
        "Dubleks (İki Katlı Çelik Karkas ve Ağır Şase Güçlendirmeli Yapı Mimarisi)",
        "Çatı Akması Onarımı ve Komple Membran İzolasyon Yenilemesi",
        "Taban Çürümesi Tamiri ve Çelik Şase Alt Taban Sacı Yenileme",
        "Dış Cephe Boya İşçiliği ve Betopan Kompozit Kaplama Revizyonu",
        "Sıhhi Tesisat / Elektrik Altyapı Hatları Yenileme ve Arıza Tamiri",
        "Deforme Olmuş Sandviç Panel Değişimi ve Duvar İçi Yalıtım Desteği",
        "Lojistik, Nakliye ve Başka Sahaya Yer Değiştirme"
      ],
      "options": [
        "Küçük Ölçekli Yapı (0 - 45 m² Arası)",
        "Standart Konut Alanı (45 - 85 m² Arası)",
        "Geniş Aile Konutu (85 - 130 m² Arası)",
        "Çok Geniş / Endüstriyel Alan (130 m² ve Üzeri)"
      ]
    },

    // ADIM: NAKLİYE - alan sonrası, sadece Sıfırdan ve Lojistik'te gelsin
    {
      "id": "nakliye_mesafesi_km",
      "label": "Kurulum Sahası Sevk Mesafesi Lojistik Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_m2",
      "visibleIf": {
        "is_kapsami": [
          "Sıfırdan İmalat / Anahtar Teslim Kurulum Hizmeti",
          "Lojistik, Nakliye ve Başka Sahaya Yer Değiştirme"
        ]
      },
      "dependsOnValue": [
        "Küçük Ölçekli Yapı (0 - 45 m² Arası)",
        "Standart Konut Alanı (45 - 85 m² Arası)",
        "Geniş Aile Konutu (85 - 130 m² Arası)",
        "Çok Geniş / Endüstriyel Alan (130 m² ve Üzeri)"
      ],
      "options": [
        "Yakın Mesafe Sevk (0 - 50 KM Arası)",
        "Orta Mesafe Sevk (50 - 150 KM Arası)",
        "Uzak Mesafe Sevk (150 - 350 KM Arası)",
        "Şehirler Arası Uzun Hat (350 KM ve Üzeri)"
      ]
    },

    // ADIM FİNAL: EKSTRA - Onarım'da alan sonrası, Sıfırdan'da nakliye sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Altyapı Çözümleri, Yalıtım ve Yapısal Konfor Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": ["alan_m2", "nakliye_mesafesi_km"],
      "dependsOnValue": [
        "Küçük Ölçekli Yapı (0 - 45 m² Arası)",
        "Standart Konut Alanı (45 - 85 m² Arası)",
        "Geniş Aile Konutu (85 - 130 m² Arası)",
        "Çok Geniş / Endüstriyel Alan (130 m² ve Üzeri)",
        "Yakın Mesafe Sevk (0 - 50 KM Arası)",
        "Orta Mesafe Sevk (50 - 150 KM Arası)",
        "Uzak Mesafe Sevk (150 - 350 KM Arası)",
        "Şehirler Arası Uzun Hat (350 KM ve Üzeri)"
      ],
      "options": [
        "Yoğun Taş Yünü / Ekstra Yalıtım Desteği (Duvar İçi ve Çatı Üstü Yüksek Yoğunluklu İzolasyon)",
        "Yerden Isıtma Altyapısı Kurulumu (Çelik Şase Üzeri Strafor ve Oksijen Bariyerli Borulama Döşemesi)",
        "Alüminyum Konfor Cam Entegrasyonu (Isı Yalıtımlı Premium Doğramalar ve Sinerji Cam Geçişi)",
        "Subasman / Beton Zemin İşçiliği (Çelik Hasırlı Hazır Beton Dökümü ve Kalıp Kurulumu Hizmeti)",
        "Veranda / Sundurma Tasarımı (Ana Gövdeye Entegre Çelik Karkaslı Üzeri Kapalı Dış Mekan Oturma Alanı)",
        "Zor Arazi / Dik Eğim Saha Zorluğu (Tır Yanaşma Engeli, Çift Bomlu Ağır Vinç Kurulumu ve Denge Mesaisi)"
      ]
    }
  ];
}