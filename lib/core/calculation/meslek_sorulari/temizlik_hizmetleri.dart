// lib/core/calculation/meslek_sorulari/temizlik_hizmetleri.dart - FINAL
class TemizlikHizmetleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Temizlik Hizmet Tipi",
      "type": "single",
      "required": true,
      "options": [
        "İnşaat Sonrası Temizlik",
        "Genel Ev Derin Temizlik",
        "Taşınma Öncesi Sonrası Temizlik",
        "Cam Cephe Temizliği",
        "Mutfak Banyo Temizliği",
        "Merdiven Ortak Alan Temizliği",
        "Bahçe Dış Alan Temizliği",
        "Havuz Temizliği Bakımı"
      ]
    },
    // İNŞAAT + GENEL + TAŞINMA ORTAK İSKELET
    {
      "id": "m2_ev",
      "label": "Alan Büyüklüğü m²",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["İnşaat Sonrası Temizlik", "Genel Ev Derin Temizlik", "Taşınma Öncesi Sonrası Temizlik"],
      "options": ["0-50 m²", "51-100 m²", "101-150 m²", "151-200 m²", "201-300 m²", "300+ m²"]
    },
    {
      "id": "tadilat_detay",
      "label": "Tadilat Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "m2_ev",
      "options": ["Sadece Boya Temizliği", "Komple Tadilat Molozlu", "Yeni İnşaat Temizliği", "Kısmi Tadilat"]
    },
    {
      "id": "durum_ev",
      "label": "Mevcut Durum",
      "type": "single",
      "required": true,
      "dependsOnId": "tadilat_detay",
      "options": ["İnşaat Malzemeleri Mevcut", "Sadece Toz Alçı Artığı", "Eşyalı Yerleşimli"]
    },
    {
      "id": "ekipman_ev",
      "label": "İhtiyaç Ekipman",
      "type": "multi",
      "required": true,
      "dependsOnId": "durum_ev",
      "options": ["Sanayi Tipi Süpürge", "Zemin Kazıma Cila Makinesi", "Buharlı Temizlik Cihazı", "Ekstra İstemiyorum"]
    },
    // CAM CEPHE DALI
    {
      "id": "yapi_cam",
      "label": "Cephe Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Cam Cephe Temizliği"],
      "options": ["Cam Giydirme", "Kompozit Alüminyum", "Taş Mermer Beton"]
    },
    {
      "id": "yukseklik_cam",
      "label": "Erişim Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_cam",
      "options": ["Zemin Kat", "1-3 Kat Merdivenle", "Yüksek Kat Vinç Platform Gerekli", "Dağcı İp ile Erişim"]
    },
    {
      "id": "kirlilik_cam",
      "label": "Kirlilik Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "yukseklik_cam",
      "options": ["Hafif Tozlu", "Ağır İnşaat Harcı Boya", "Kireç Dış Etken"]
    },
    // MUTFAK BANYO DALI
    {
      "id": "hacim_mb",
      "label": "Bölüm Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mutfak Banyo Temizliği"],
      "options": ["Sadece Mutfak", "Sadece Banyo", "Mutfak Banyo", "Komple Islak Hacimler"]
    },
    {
      "id": "hijyen_mb",
      "label": "Hijyen Gereksinimi",
      "type": "single",
      "required": true,
      "dependsOnId": "hacim_mb",
      "options": ["Standart Temizlik", "Derin Hijyen Dezenfeksiyon", "Kireç Derz Temizliği"]
    },
    // ORTAK ALAN DALI
    {
      "id": "kat_ortak",
      "label": "Kat Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Merdiven Ortak Alan Temizliği"],
      "options": ["1-5 Kat", "6-10 Kat", "11-20 Kat", "20+ Kat"]
    },
    {
      "id": "periyot_ortak",
      "label": "Temizlik Sıklığı",
      "type": "single",
      "required": true,
      "dependsOnId": "kat_ortak",
      "options": ["Tek Seferlik", "Haftalık", "15 Günde Bir", "Aylık Sabit"]
    },
    {
      "id": "kapsam_ortak",
      "label": "Kapsam",
      "type": "multi",
      "required": true,
      "dependsOnId": "periyot_ortak",
      "options": ["Asansör İçleri", "Giriş Holü", "Dış Kapı Önü", "Kat Koridorları", "Ekstra İstemiyorum"]
    },
    // BAHÇE HAVUZ DALI
    {
      "id": "alan_dıs",
      "label": "Alan Hacim Ölçeği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Bahçe Dış Alan Temizliği", "Havuz Temizliği Bakımı"],
      "options": ["Küçük 0-50", "Orta 50-150", "Büyük 150-300", "Çok Büyük 300+"]
    },
    {
      "id": "kapsam_dıs",
      "label": "Uygulama Kapsamı",
      "type": "multi",
      "required": true,
      "dependsOnId": "alan_dıs",
      "options": ["Ot Yabani Bitki Temizliği", "Havuz Kimyasalları Bakım", "İnşaat Atığı Moloz Tahliyesi", "Dış Zemin Yıkama", "Ekstra İstemiyorum"]
    }
  ];
}