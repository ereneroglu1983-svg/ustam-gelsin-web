// lib/core/calculation/meslek_sorulari/dogalgaz_kombi.dart

class DogalgazKombiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "Doğalgaz / Kombi ve Isıtma İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan Komple Daire İçi Tesisat ve Hat Kurulumu",
        "Sadece Kombi Montajı ve İlk Çalıştırma İşçiliği",
        "Yerden Isıtma Tesisatı Sistem Kurulumu",
        "Kombi Bakımı, Onarımı veya Arıza Giderme"
      ]
    },

    // ==========================================
    // 🔥 GRUP 1: DOĞALGAZ & KOMBİ MONTAJ SORULARI
    // ==========================================
    {
      "id": "kombi_teknolojisi",
      "label": "Talep Edilen Kombi Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sıfırdan Komple Daire İçi Tesisat ve Hat Kurulumu",
        "Sadece Kombi Montajı ve İlk Çalıştırma İşçiliği",
        "Yerden Isıtma Tesisatı Sistem Kurulumu"
      ],
      "options": [
        "Tam Yoğuşmalı Kombi (Yüksek Tasarruflu Yeni Nesil)",
        "Yarı Yoğuşmalı Kombi",
        "Hermetik Kombi (Mevcut Değişim Hatları İçin)",
        "Kombi Hariç (Sadece Altyapı Boru Hattı Çekilecek)"
      ]
    },
    {
      "id": "proje_durumu",
      "label": "Mühendislik Proje ve Onay Beyanı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sıfırdan Komple Daire İçi Tesisat ve Hat Kurulumu",
        "Sadece Kombi Montajı ve İlk Çalıştırma İşçiliği",
        "Yerden Isıtma Tesisatı Sistem Kurulumu"
      ],
      "options": [
        "Mühendislik Proje Çizimi ve Dijital Gaz Açma Onayı Dahil Olsun",
        "Gaz Dağıtım Şirketi Projesi Mevcut / Onaylı",
        "Sadece Mekanik Montaj ve İşçilik Hizmeti İstiyorum"
      ]
    },
    {
      "id": "montaj_yeri",
      "label": "Kombi Montajının Yapılacağı Bölge",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sıfırdan Komple Daire İçi Tesisat ve Hat Kurulumu",
        "Sadece Kombi Montajı ve İlk Çalıştırma İşçiliği",
        "Yerden Isıtma Tesisatı Sistem Kurulumu"
      ],
      "options": [
        "Mutfak İçi Montaj",
        "Balkon (Açık veya Kapalı Balkon Dolabı Kurulumu Dahil)",
        "Kiler / Hol / Koridor Montajı",
        "Mevcut Eski Kombi Yerine Doğrudan Değişim"
      ]
    },

    // ==========================================
    // 🌀 GRUP 2: ENTEGRE YERDEN ISITMA ÖZEL SORULARI
    // ==========================================
    {
      "id": "izolasyon_tipi",
      "label": "Zemin İzolasyon (Strafor) Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Yerden Isıtma Tesisatı Sistem Kurulumu"],
      "options": [
        "Mantarlı Strafor (Boru Kanallı Yoğunlaştırılmış EPS Isı Yalıtım Paneli)",
        "Düz Folyo Kaplı İzolasyon Straforu (Ekonomik Seri)",
        "Zemin İzolasyonu Hariç (Sadece Borulama ve Tesisat İşçiliği)"
      ]
    },
    {
      "id": "sap_durumu",
      "label": "Uygulama Alanının Şap Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Yerden Isıtma Tesisatı Sistem Kurulumu"],
      "options": [
        "Şap Atılmamış Ham Beton (Doğrudan Strafor Üstü Borulama Kurulumu)",
        "Mevcut Şap Var (Kırım Yapılması veya Şap Üstü İnce Sistem Uygulanması Gerekiyor)"
      ]
    },
    {
      "id": "alan_m2", // 🛠️ TEXT YAKILDI -> ARALIKLI SEÇMELİ YAPILDI
      "label": "Isıtılacak Net Toplam Alan (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Yerden Isıtma Tesisatı Sistem Kurulumu"],
      "options": [
        "0 - 70 m² Arası Küçük Alan",
        "71 - 110 m² Arası Standart Daire",
        "111 - 150 m² Arası Geniş Daire",
        "151 - 250 m² Arası Dubleks / Büyük Yapı",
        "250 m² Üzeri Çok Geniş / Villa / Ticari Alan"
      ]
    },
    {
      "id": "yapi_tipi",
      "label": "Uygulama Yapılacak Yapı Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Yerden Isıtma Tesisatı Sistem Kurulumu"],
      "options": [
        "Apartman Dairesi",
        "Villa / Müstakil Ev",
        "Ticari Alan / Ofis / İş Yeri",
        "Geniş Alan / İbadethane"
      ]
    },
    {
      "id": "kat_durumu",
      "label": "Uygulama Yapılacak Kat Lokasyonu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Yerden Isıtma Tesisatı Sistem Kurulumu"],
      "options": [
        "Zemin Kat (Isı Kaybı Yüksek Toprak Temaslı)",
        "Ara Kat",
        "Çatı Katı / Çatı Altı"
      ]
    },
    {
      "id": "isi_kaynagi",
      "label": "Sistemde Kullanılacak Ana Isı Kaynağı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Yerden Isıtma Tesisatı Sistem Kurulumu"],
      "options": [
        "Kombi (Doğalgaz Altyapılı)",
        "Isı Pompası Sistemi",
        "Merkezi Sistem (Merkezi Pay Ölçerli Hat)",
        "Elektrikli Rezistanslı Kazan"
      ]
    },

    // ==========================================
    // 🛠️ GRUP 3: BAKIM / ARIZA SORULARI
    // ==========================================
    {
      "id": "bakim_ariza_detayi",
      "label": "Bakım veya Arıza Durumu Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Kombi Bakımı, Onarımı veya Arıza Giderme"],
      "options": [
        "Yıllık Periyodik Kombi Bakımı ve Filtre Temizliği",
        "Sıcak Su Gelmiyor / Devreye Girmiyor Arızası",
        "Kombi Hiç Çalışmıyor / Ateşleme Yapmıyor",
        "Dijital Ekranda Hata Kodu Veriyor / Su Eksiltiyor"
      ]
    },

    // ==========================================
    // 📐 GRUP 4: GENEL PARAMETRELER VE RADYATÖR KOŞULLARI
    // ==========================================
    {
      "id": "daire_tipi",
      "label": "Uygulama Yapılacak Yapı Planı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sıfırdan Komple Daire İçi Tesisat ve Hat Kurulumu",
        "Sadece Kombi Montajı ve İlk Çalıştırma İşçiliği",
        "Kombi Bakımı, Onarımı veya Arıza Giderme"
      ],
      "options": [
        "1+1 Konut Düzeni",
        "2+1 Konut Düzeni",
        "3+1 Konut Düzeni",
        "Müstakil Villa / Dubleks veya Geniş Yapı"
      ]
    },
    {
      "id": "petek_adedi", // 🛠️ TEXT YAKILDI -> ARALIKLI SEÇMELİ YAPILDI
      "label": "Yenilenecek / Montajı Yapılacak Net Petek Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sıfırdan Komple Daire İçi Tesisat ve Hat Kurulumu",
        "Sadece Kombi Montajı ve İlk Çalıştırma İşçiliği"
      ],
      "options": [
        "1 - 4 Adet Arası Petek",
        "5 - 7 Adet Arası Standart Petek",
        "8 - 10 Adet Arası Yoğun Petek",
        "11 Adet ve Üzeri / Geniş Tesisat"
      ]
    },
    {
      "id": "tesisat_malzemesi",
      "label": "Kullanılacak Tesisat Boru ve Hat Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sıfırdan Komple Daire İçi Tesisat ve Hat Kurulumu",
        "Sadece Kombi Montajı ve İlk Çalıştırma İşçiliği"
      ],
      "options": [
        "PPRC Plastik Boru Tesisatı (Standart Sıva Altı/Üstü Hat)",
        "Çelik Boru (Kaynaklı Endüstriyel Hat)",
        "Bakır Boru Hattı (Gümüş Kaynak İşçilikli)",
        "Mobil Sistem Kılıflı Boru (Kollektörlü Dağıtım Paneli)"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Sistem Ekstraları, Otomasyon ve Test Donanımları",
      "type": "multi",
      "required": false,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sıfırdan Komple Daire İçi Tesisat ve Hat Kurulumu",
        "Sadece Kombi Montajı ve İlk Çalıştırma İşçiliği",
        "Yerden Isıtma Tesisatı Sistem Kurulumu",
        "Kombi Bakımı, Onarımı veya Arıza Giderme"
      ],
      "options": [
        "Radyatör Montaj İşçilik Paketi (Petek Askılama, Vana ve Bağlantılar)",
        "Kombi Yoğuşma Gideri Pimaş Hattı Bağlantı İşçiliği",
        "Kablosuz Oda Termostatı Montajı ve Senkronizasyonu",
        "Gaz Alarm Cihazı ve Selenoid Vana Emniyet Sistemi Kurulumu",
        "Kollektör Vana Grubu ve Dolabı (Debi Ayarlı Pirinç Dağıtım Paneli Montajı)",
        "Oda Bazlı Akıllı Termostat Altyapısı (Her Oda İçin Ayrı Aktüatör ve Dijital Kontrol)",
        "Kenar Yalıtım Bandı ve Koruma Sütü (Isıl Genleşme Bariyeri ve Şap Mukavemet Sıvısı)",
        "Basınçlı Manometre Kaçak Testi (Şap Öncesi Kompresör ile Sızdırmazlık Kilitlemesi)"
      ]
    }
  ];
}