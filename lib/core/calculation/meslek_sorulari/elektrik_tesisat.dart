// lib/core/calculation/meslek_sorulari/elektrik_tesisat.dart

class ElektrikTesisatiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_kapsami", // 🛠️ ANA TETİKLEYİCİ: Tüm alt soruları ve akışı kilitler
      "label": "Elektrik İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Tesisat Yenileme / Revizyon (Sıfırdan Kanal ve Kablo Çekimi)",
        "Lokal Kısmi Tadilat / Arıza Onarımı (Kısa Devre / Buat Yenileme)",
        "Sadece Montaj İşçiliği (Kabloları Hazır Yerlere Priz/Anahtar Takma)"
      ]
    },
    {
      "id": "yapi_tipi", // 🛠️ İKİNCİL TETİKLEYİCİ: Yapı tipine göre Konut veya Ticari akışı açar
      "label": "Uygulama Yapılacak Yapı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_kapsami",
      "dependsOnValue": [
        "Komple Tesisat Yenileme / Revizyon (Sıfırdan Kanal ve Kablo Çekimi)",
        "Lokal Kısmi Tadilat / Arıza Onarımı (Kısa Devre / Buat Yenileme)",
        "Sadece Montaj İşçiliği (Kabloları Hazır Yerlere Priz/Anahtar Takma)"
      ],
      "options": [
        "Daire",
        "Villa / Müstakil Ev",
        "Ticari Alan / İşyeri",
        "Fabrika / Atölye"
      ]
    },

    // ==========================================
    // 🏠 GRUP 1: KONUT ELEKTRİK SORULARI
    // ==========================================
    {
      "id": "konut_tipi",
      "label": "Konut Ölçüsü ve Oda Planı",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tipi",
      "dependsOnValue": ["Daire", "Villa / Müstakil Ev"],
      "options": [
        "1+1 Konut Düzeni",
        "2+1 Konut Düzeni",
        "3+1 Konut Düzeni",
        "4+1 ve Üzeri / Geniş Müstakil Ev"
      ]
    },

    // ==========================================
    // 🏭 GRUP 2: TİCARİ / ENDÜSTRİYEL SORULARI
    // ==========================================
    {
      "id": "ticari_m2_alan",
      "label": "Toplam Ticari Uygulama Alanı (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tipi",
      "dependsOnValue": ["Ticari Alan / İşyeri", "Fabrika / Atölye"],
      "options": [
        "1-100 m² Arası Küçük İşletme",
        "100-250 m² Arası Orta Ölçekli Ticari Alan",
        "250-500 m² Arası Geniş Mağaza / Atölye",
        "500 m² ve Üzeri Büyük Fabrika / Depo alanı"
      ]
    },

    // ==========================================
    // ⚙️ MEKANİK VE TEKNİK PARAMETRELER
    // ==========================================
    {
      "id": "adet",
      "label": "Net Priz / Anahtar Montaj Adeti",
      "type": "single", // 🎯 REVIZE: text salaklığı temizlendi, single yapıldı! Validasyon artık kilitlenmez.
      "required": true, // UI motorunda patlamasın diye zorunlu yapıp seçenek ekledik
      "dependsOnId": "uygulama_kapsami",
      "dependsOnValue": [
        "Komple Tesisat Yenileme / Revizyon (Sıfırdan Kanal ve Kablo Çekimi)",
        "Lokal Kısmi Tadilat / Arıza Onarımı (Kısa Devre / Buat Yenileme)",
        "Sadece Montaj İşçiliği (Kabloları Hazır Yerlere Priz/Anahtar Takma)"
      ],
      "options": [
        "Priz/Anahtar Montajı İstenmiyor (Sadece Hat Çekimi)",
        "1-15 Adet Arası Priz/Anahtar",
        "15-30 Adet Arası Priz/Anahtar",
        "30-50 Adet Arası Priz/Anahtar",
        "50+ Adet Üzeri Priz/Anahtar"
      ]
    },
    {
      "id": "aydinlatma_sayi",
      "label": "Montajı Yapılacak Toplam Aydınlatma Noktası (Duy/Armatür/Sorti)",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_kapsami",
      "dependsOnValue": [
        "Komple Tesisat Yenileme / Revizyon (Sıfırdan Kanal ve Kablo Çekimi)",
        "Lokal Kısmi Tadilat / Arıza Onarımı (Kısa Devre / Buat Yenileme)",
        "Sadece Montaj İşçiliği (Kabloları Hazır Yerlere Priz/Anahtar Takma)"
      ],
      "options": [
        "1-10 Nokta Arası",
        "10-25 Nokta Arası",
        "25-50 Nokta Arası",
        "Aydınlatma Montaj İşlemi Yok"
      ]
    },
    {
      "id": "malzeme_segmenti",
      "label": "Kullanılacak Malzeme Standart Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_kapsami",
      "dependsOnValue": [
        "Komple Tesisat Yenileme / Revizyon (Sıfırdan Kanal ve Kablo Çekimi)",
        "Lokal Kısmi Tadilat / Arıza Onarımı (Kısa Devre / Buat Yenileme)",
        "Sadece Montaj İşçiliği (Kabloları Hazır Yerlere Priz/Anahtar Takma)"
      ],
      "options": [
        "Standart Yerli (NYM / Tam Bakır Kablo ve Standart Şalt Grubu)",
        "Premium Kalite (Halogen Free Yangın Yürütmez Kablo + Birinci Sınıf İthal Şalt Grubu)" // 💰 SPONSORLUK REVİZYONU: Marka isimleri uçuruldu, reklam bütçesi bekleniyor!
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Özel Linye Hatları ve Ekstra Donanım Talepleri",
      "type": "multi",
      "required": false,
      "dependsOnId": "uygulama_kapsami",
      "dependsOnValue": [
        "Komple Tesisat Yenileme / Revizyon (Sıfırdan Kanal ve Kablo Çekimi)",
        "Lokal Kısmi Tadilat / Arıza Onarımı (Kısa Devre / Buat Yenileme)",
        "Sadece Montaj İşçiliği (Kabloları Hazır Yerlere Priz/Anahtar Takma)"
      ],
      "options": [
        "Klima / Hat Çekimi (Panodan Doğrudan Bağımsız Yüksek Amperajlı Hat)",
        "Pano Yenileme / Sigorta Kutusu Değişimi (Kaçak Akım Rölesi Dahil)",
        "Topraklama Hattı Çekimi (Levha Çakımı ve Megger Testi Ölçümü Dahil)",
        "İnternet / Data Hattı Çekimi (Cat6 Kablo ve Data Prizi Sonlandırma)"
      ]
    },
    {
      "id": "tesisat_sekli",
      "label": "Tesisat Uygulama Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_kapsami",
      "dependsOnValue": [
        "Komple Tesisat Yenileme / Revizyon (Sıfırdan Kanal ve Kablo Çekimi)",
        "Lokal Kısmi Tadilat / Arıza Onarımı (Kısa Devre / Buat Yenileme)"
      ],
      "options": [
        "Duvar İçi / Sıva Altı Tesisat",
        "Sıva Üstü Tesisat (Kanal/Boru)",
        "Karar Vermedim (Usta Sahada İnceleyip Önersin)"
      ]
    }
  ];
}