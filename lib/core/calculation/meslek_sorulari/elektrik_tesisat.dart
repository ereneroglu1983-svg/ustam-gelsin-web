// lib/core/calculation/meslek_sorulari/elektrik_tesisat.dart - FINAL
class ElektrikTesisatiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_kapsami",
      "label": "Elektrik İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Komple Tesisat Yenileme Revizyon", "Lokal Kısmi Tadilat Arıza Onarım", "Sadece Montaj Priz Anahtar"]
    },
    {
      "id": "yapi_tipi",
      "label": "Yapı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_kapsami",
      "options": ["Daire", "Villa Müstakil Ev", "Ticari Alan İşyeri", "Fabrika Atölye"]
    },
    // KONUT DALI
    {
      "id": "konut_tipi",
      "label": "Konut Oda Planı",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tipi",
      "dependsOnValue": ["Daire", "Villa Müstakil Ev"],
      "options": ["1+1 Konut", "2+1 Konut", "3+1 Konut", "4+1 ve Üzeri Geniş"]
    },
    // TİCARİ DALI
    {
      "id": "ticari_m2_alan",
      "label": "Ticari Alan Büyüklüğü",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tipi",
      "dependsOnValue": ["Ticari Alan İşyeri", "Fabrika Atölye"],
      "options": ["1-100 m² Küçük", "100-250 m² Orta", "250-500 m² Geniş", "500 m² Üzeri Büyük"]
    },
    // ORTAK ZİNCİR - Konut sonrası
    {
      "id": "tesisat_sekli_konut",
      "label": "Tesisat Uygulama Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": "konut_tipi",
      "options": ["Duvar İçi Sıva Altı", "Sıva Üstü Kanal Boru"]
    },
    {
      "id": "tesisat_sekli_ticari",
      "label": "Tesisat Uygulama Şekli",
      "type": "single",
      "required": true,
      "dependsOnId": "ticari_m2_alan",
      "options": ["Duvar İçi Sıva Altı", "Sıva Üstü Kanal Boru", "Kablo Kanalı Busbar"]
    },
    {
      "id": "adet_konut",
      "label": "Priz Anahtar Montaj Adeti",
      "type": "single",
      "required": true,
      "dependsOnId": "tesisat_sekli_konut",
      "options": ["Sadece Hat Çekimi", "1-15 Adet", "15-30 Adet", "30-50 Adet", "50 Adet Üzeri"]
    },
    {
      "id": "adet_ticari",
      "label": "Priz Anahtar Montaj Adeti",
      "type": "single",
      "required": true,
      "dependsOnId": "tesisat_sekli_ticari",
      "options": ["Sadece Hat Çekimi", "1-15 Adet", "15-30 Adet", "30-50 Adet", "50 Adet Üzeri"]
    },
    {
      "id": "aydinlatma_konut",
      "label": "Aydınlatma Noktası Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "adet_konut",
      "options": ["1-10 Nokta", "10-25 Nokta", "25-50 Nokta", "Aydınlatma Yok"]
    },
    {
      "id": "aydinlatma_ticari",
      "label": "Aydınlatma Noktası Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "adet_ticari",
      "options": ["1-10 Nokta", "10-25 Nokta", "25-50 Nokta", "50 Üzeri Nokta", "Aydınlatma Yok"]
    },
    {
      "id": "malzeme_segmenti_konut",
      "label": "Malzeme Kalite Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "aydinlatma_konut",
      "options": ["Standart Yerli NYM Tam Bakır", "Premium Halogen Free Yangın Yürütmez"]
    },
    {
      "id": "malzeme_segmenti_ticari",
      "label": "Malzeme Kalite Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "aydinlatma_ticari",
      "options": ["Standart Yerli", "Premium Halogen Free"]
    },
    {
      "id": "ekstra_konut",
      "label": "Özel Linye ve Ekstra Talepler",
      "type": "multi",
      "required": true,
      "dependsOnId": "malzeme_segmenti_konut",
      "options": [
        "Klima Hattı Bağımsız Linye",
        "Pano Yenileme Kaçak Akım Rölesi",
        "Topraklama Hattı Megger Testli",
        "İnternet Data Cat6 Hattı",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_ticari",
      "label": "Özel Linye ve Ekstra Talepler",
      "type": "multi",
      "required": true,
      "dependsOnId": "malzeme_segmenti_ticari",
      "options": [
        "Trifaze Hat Çekimi",
        "Pano Yenileme Kompanzasyon",
        "Topraklama Paratoner",
        "Data Kamera Hattı",
        "Jeneratör Transfer Panosu",
        "Ekstra İstemiyorum"
      ]
    }
  ];
}