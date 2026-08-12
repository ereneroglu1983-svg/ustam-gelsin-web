// lib/core/calculation/meslek_sorulari/cati_isleri.dart - FINAL
class CatiIsleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "hizmet_turu",
      "label": "Ana Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Sıfırdan Çatı Yapımı", "Çatı Aktarma ve Onarım", "Sandviç Panel Şıngıl Yenileme", "Sadece İzolasyon Yalıtım", "Oluk Dere Yenileme"]
    },
    {
      "id": "yapi_tip",
      "label": "Yapı Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "options": ["Müstakil Villa Bungalov", "Apartman Site Bloğu", "Fabrika Depo Endüstriyel", "Prefabrik Hafif Çelik"]
    },
    {
      "id": "alan_segmenti",
      "label": "Çatı Alan Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "options": ["0-50 m² Küçük", "50-100 m² Standart", "100-200 m² Geniş", "200-400 m² Büyük Ticari", "400 m² Üzeri Endüstriyel"]
    },
    {
      "id": "karkas_tipi",
      "label": "Taşıyıcı Karkas Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Sıfırdan Çatı Yapımı"],
      "options": ["Ahşap Karkas Kereste", "Çelik Karkas Metal Profil"]
    },
    {
      "id": "kaplama_tipi_sifir",
      "label": "Üst Kaplama Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "karkas_tipi",
      "options": ["Kiremit Kaplama", "Sandviç Panel", "Shingle Kaplama", "Trapez Sac"]
    },
    {
      "id": "kaplama_tipi_yenileme",
      "label": "Yeni Kaplama Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Çatı Aktarma ve Onarım", "Sandviç Panel Şıngıl Yenileme"],
      "options": ["Kiremit Kaplama", "Sandviç Panel", "Shingle Kaplama", "Trapez Sac"]
    },
    {
      "id": "malzeme_tedarik",
      "label": "Malzeme Tedarik Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "options": ["Malzeme Dahil Ustaya Ait", "Sadece İşçilik Malzeme Müşteriye Ait"]
    },
    {
      "id": "ekstra_detaylar",
      "label": "Teknik Detay ve Zorluklar",
      "type": "multi",
      "required": true,
      "dependsOnId": "malzeme_tedarik",
      "options": [
        "Isı Yalıtımı Taş Yünü Cam Yünü",
        "Su Yalıtımı Membran",
        "Gizli Dere Oluk Yenileme",
        "Baca Kenarı Çinko İzolasyon",
        "Dik Eğimli Çatı Zor İşçilik",
        "Yüksek Kat Vinç İskele Gerekli",
        "Ekstra İstemiyorum"
      ]
    }
  ];
}