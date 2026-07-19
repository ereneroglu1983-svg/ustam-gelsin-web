// lib/core/calculation/meslek_sorulari/elektrik_tesisat.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class ElektrikTesisatiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_kapsami",
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
      "id": "yapi_tipi",
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

    // ADIM 3: KONUT / TİCARİ AYRIMI - yapi_tipi'ne göre sadece biri gelir
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

    // ADIM 4: TESİSAT ŞEKLİ - sadece Komple ve Lokal'de gelir, Sadece Montaj'da gelmez
    // Konut veya Ticari seçildikten sonra gelir
    {
      "id": "tesisat_sekli",
      "label": "Tesisat Uygulama Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": ["konut_tipi", "ticari_m2_alan"],
      "visibleIf": {
        "uygulama_kapsami": [
          "Komple Tesisat Yenileme / Revizyon (Sıfırdan Kanal ve Kablo Çekimi)",
          "Lokal Kısmi Tadilat / Arıza Onarımı (Kısa Devre / Buat Yenileme)"
        ]
      },
      "dependsOnValue": [
        "1+1 Konut Düzeni",
        "2+1 Konut Düzeni",
        "3+1 Konut Düzeni",
        "4+1 ve Üzeri / Geniş Müstakil Ev",
        "1-100 m² Arası Küçük İşletme",
        "100-250 m² Arası Orta Ölçekli Ticari Alan",
        "250-500 m² Arası Geniş Mağaza / Atölye",
        "500 m² ve Üzeri Büyük Fabrika / Depo alanı"
      ],
      "options": [
        "Duvar İçi / Sıva Altı Tesisat",
        "Sıva Üstü Tesisat (Kanal/Boru)",
        "Karar Vermedim (Usta Sahada İnceleyip Önersin)"
      ]
    },

    // ADIM 5: ADET - tesisat şekli varsa ondan sonra, yoksa (Sadece Montaj) konut/ticari sonrası
    {
      "id": "adet",
      "label": "Net Priz / Anahtar Montaj Adeti",
      "type": "single",
      "required": true,
      "dependsOnId": ["tesisat_sekli", "konut_tipi", "ticari_m2_alan"],
      "dependsOnValue": [
        "Duvar İçi / Sıva Altı Tesisat",
        "Sıva Üstü Tesisat (Kanal/Boru)",
        "Karar Vermedim (Usta Sahada İnceleyip Önersin)",
        "1+1 Konut Düzeni",
        "2+1 Konut Düzeni",
        "3+1 Konut Düzeni",
        "4+1 ve Üzeri / Geniş Müstakil Ev",
        "1-100 m² Arası Küçük İşletme",
        "100-250 m² Arası Orta Ölçekli Ticari Alan",
        "250-500 m² Arası Geniş Mağaza / Atölye",
        "500 m² ve Üzeri Büyük Fabrika / Depo alanı"
      ],
      "options": [
        "Priz/Anahtar Montajı İstenmiyor (Sadece Hat Çekimi)",
        "1-15 Adet Arası Priz/Anahtar",
        "15-30 Adet Arası Priz/Anahtar",
        "30-50 Adet Arası Priz/Anahtar",
        "50+ Adet Üzeri Priz/Anahtar"
      ]
    },

    // ADIM 6: AYDINLATMA - adet seçilince gelsin
    {
      "id": "aydinlatma_sayi",
      "label": "Montajı Yapılacak Toplam Aydınlatma Noktası (Duy/Armatür/Sorti)",
      "type": "single",
      "required": true,
      "dependsOnId": "adet",
      "dependsOnValue": [
        "Priz/Anahtar Montajı İstenmiyor (Sadece Hat Çekimi)",
        "1-15 Adet Arası Priz/Anahtar",
        "15-30 Adet Arası Priz/Anahtar",
        "30-50 Adet Arası Priz/Anahtar",
        "50+ Adet Üzeri Priz/Anahtar"
      ],
      "options": [
        "1-10 Nokta Arası",
        "10-25 Nokta Arası",
        "25-50 Nokta Arası",
        "Aydınlatma Montaj İşlemi Yok"
      ]
    },

    // ADIM 7: MALZEME - aydınlatma seçilince gelsin
    {
      "id": "malzeme_segmenti",
      "label": "Kullanılacak Malzeme Standart Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "aydinlatma_sayi",
      "dependsOnValue": [
        "1-10 Nokta Arası",
        "10-25 Nokta Arası",
        "25-50 Nokta Arası",
        "Aydınlatma Montaj İşlemi Yok"
      ],
      "options": [
        "Standart Yerli (NYM / Tam Bakır Kablo ve Standart Şalt Grubu)",
        "Premium Kalite (Halogen Free Yangın Yürütmez Kablo + Birinci Sınıf İthal Şalt Grubu)"
      ]
    },

    // ADIM 8: FİNAL - malzeme seçilince yeşil kutuda açılsın
    {
      "id": "ekstra_ozellikler",
      "label": "Özel Linye Hatları ve Ekstra Donanım Talepleri",
      "type": "multi",
      "required": false,
      "dependsOnId": "malzeme_segmenti",
      "dependsOnValue": [
        "Standart Yerli (NYM / Tam Bakır Kablo ve Standart Şalt Grubu)",
        "Premium Kalite (Halogen Free Yangın Yürütmez Kablo + Birinci Sınıf İthal Şalt Grubu)"
      ],
      "options": [
        "Klima / Hat Çekimi (Panodan Doğrudan Bağımsız Yüksek Amperajlı Hat)",
        "Pano Yenileme / Sigorta Kutusu Değişimi (Kaçak Akım Rölesi Dahil)",
        "Topraklama Hattı Çekimi (Levha Çakımı ve Megger Testi Ölçümü Dahil)",
        "İnternet / Data Hattı Çekimi (Cat6 Kablo ve Data Prizi Sonlandırma)"
      ]
    }
  ];
}