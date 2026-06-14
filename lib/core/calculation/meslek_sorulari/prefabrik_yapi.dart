// lib/core/calculation/meslek_sorulari/prefabrik_yapi.dart

class PrefabrikYapiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ KİLİT TETİKLEYİCİ: Proje standardına eşitlendi (hizmet_turu -> is_kapsami)
      "label": "Talep Edilen Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan İmalat / Anahtar Teslim Kurulum Hizmeti",
        "Mevcut Yapı İçin Onarım, Tamir ve Tadilat",
        "Lojistik, Nakliye ve Başka Sahaya Yer Değiştirme"
      ]
    },

    // ==========================================
    // 🏗️ GRUP 1: FABRİKA İMALAT VE TEKNOLOJİ DETAYLARI (Sadece Sıfırdan İmalat Seçilirse Açılır)
    // ==========================================
    {
      "id": "yapi_tipi", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue mimarisine geçirildi
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
      "id": "kat_sayisi", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue mimarisine geçirildi
      "label": "Yapının Kat Mimarisi ve Yük Endeksi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan İmalat / Anahtar Teslim Kurulum Hizmeti"],
      "options": [
        "Tek Katlı Mimari Yapı Planyası",
        "Dubleks (İki Katlı Çelik Karkas ve Ağır Şase Güçlendirmeli Yapı Mimarisi)"
      ]
    },

    // ==========================================
    // 🛠️ GRUP 2: LOKAL ONARIM VE SERVİS DETAYLARI (Sadece Tamir / Tadilat Seçilirse Açılır)
    // ==========================================
    {
      "id": "tamir_detay", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue mimarisine geçirildi
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

    // ==========================================
    // 📐 ÖLÇÜ, LOJİSTİK VE TONAJ PARAMETRELERİ (Seçmeli Sekmelere Dönüştürüldü)
    // ==========================================
    {
      "id": "alan_m2", // 🛠️ REVIZE EDİLDİ: Text tipinden single seçmeli tipe dönüştürüldü ve kilitleme eklendi
      "label": "Yapının Yaklaşık Net Toplam Alanı (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat / Anahtar Teslim Kurulum Hizmeti",
        "Mevcut Yapı İçin Onarım, Tamir ve Tadilat",
        "Lojistik, Nakliye ve Başka Sahaya Yer Değiştirme"
      ],
      "options": [
        "Küçük Ölçekli Yapı (0 - 45 m² Arası)",
        "Standart Konut Alanı (45 - 85 m² Arası)",
        "Geniş Aile Konutu (85 - 130 m² Arası)",
        "Çok Geniş / Endüstriyel Alan (130 m² ve Üzeri)"
      ]
    },
    {
      "id": "nakliye_mesafesi_km", // 🛠️ REVIZE EDİLDİ: Text tipinden single seçmeli tipe dönüştürüldü ve kilitleme eklendi
      "label": "Kurulum Sahası Sevk Mesafesi Lojistik Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat / Anahtar Teslim Kurulum Hizmeti",
        "Lojistik, Nakliye ve Başka Sahaya Yer Değiştirme"
      ],
      "options": [
        "Yakın Mesafe Sevk (0 - 50 KM Arası)",
        "Orta Mesafe Sevk (50 - 150 KM Arası)",
        "Uzak Mesafe Sevk (150 - 350 KM Arası)",
        "Şehirler Arası Uzun Hat (350 KM ve Üzeri)"
      ]
    },

    // ==========================================
    // ⚙️ ALTYAPI, YALITIM VE YAPISAL KONFOR EKSTRALARI
    // ==========================================
    {
      "id": "ekstra_ozellikler", // 🛠️ DÜZELTİLDİ: Form ilk açıldığında havada kalmaması için bağımlılık eklendi
      "label": "Altyapı Çözümleri, Yalıtım ve Yapısal Konfor Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat / Anahtar Teslim Kurulum Hizmeti",
        "Mevcut Yapı İçin Onarım, Tamir ve Tadilat"
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