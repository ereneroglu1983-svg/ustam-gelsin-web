// lib/core/calculation/meslek_sorulari/fayans_seramik.dart - FINAL
class FayansSeramikSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Komple Seramik Döşeme", "Sadece Eski Fayans Kırım Kazıma"]
    },
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alan Bölgesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["Banyo Duvar Zemin", "Mutfak Tezgah Arası", "Balkon Teras", "Tüm Ev Zemin", "Havuz İçi Kaplama"]
    },
    {
      "id": "alan_segmenti",
      "label": "Uygulama Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "options": ["0-10 m² Küçük WC Tezgah", "10-30 m² Banyo Balkon", "30-70 m² Teras Orta Alan", "70 m² Üzeri Büyük Alan"]
    },
    {
      "id": "seramik_ebati",
      "label": "Seramik Ebat Tasarım",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Seramik Döşeme"],
      "options": ["Standart 30x60 60x60", "Büyük Ebat 60x120 Üzeri", "Mozaik Metro Dekoratif", "Dev Plaka 120x240 Slab"]
    },
    {
      "id": "zemin_durumu",
      "label": "Mevcut Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "seramik_ebati",
      "options": ["Şaplı Düz Zemin Hazır", "Eski Fayans Var Kırım Gerekli", "Fayans Üstü Fayans Astarlı"]
    },
    {
      "id": "moloz_dokum",
      "label": "Moloz Taşıma Atım",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durumu",
      "dependsOnValue": ["Eski Fayans Var Kırım Gerekli"],
      "options": ["Çuvallanıp Kamyona Yüklenecek", "Sadece Çuvallanacak Kapı Önü", "Müşteri Çözecek Sadece Kırım"]
    },
    {
      "id": "malzeme_sinif",
      "label": "Malzeme Kalite Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durumu",
      "dependsOnValue": ["Şaplı Düz Zemin Hazır", "Fayans Üstü Fayans Astarlı"],
      "options": ["1. Kalite Malzeme", "Ekonomik Seri", "Malzeme Dahil Usta Tedarik"]
    },
    {
      "id": "malzeme_sinif_kirimli",
      "label": "Malzeme Kalite Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "moloz_dokum",
      "options": ["1. Kalite Malzeme", "Ekonomik Seri", "Malzeme Dahil Usta Tedarik"]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Teknik ve Estetik Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "malzeme_sinif",
      "options": [
        "Su Yalıtım Sürme Köşe Bandı",
        "45 Derece Jolly Köşe Taşlama",
        "Epoksi Derz Uygulaması",
        "Tesviye Şapı Akıllı Şap",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_kirimli",
      "label": "Teknik ve Estetik Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "malzeme_sinif_kirimli",
      "options": [
        "Su Yalıtım Sürme Köşe Bandı",
        "45 Derece Jolly Köşe Taşlama",
        "Epoksi Derz Uygulaması",
        "Tesviye Şapı Akıllı Şap",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "kirim_alani",
      "label": "Kırım Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sadece Eski Fayans Kırım Kazıma"],
      "options": ["0-10 m²", "10-30 m²", "30-70 m²", "70 m² Üzeri"]
    }
  ];
}