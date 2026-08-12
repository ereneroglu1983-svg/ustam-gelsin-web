// lib/core/calculation/meslek_sorulari/mutfak_dolabi.dart

class MutfakDolabiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Mutfak Proje Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Mutfak Yenileme",
        "Sadece Dolap İmalatı",
        "Sadece Tezgah Değişimi",
        "Kapak Yenileme Boyama"
      ]
    },
    {
      "id": "kapak_tipi_komple",
      "label": "Dolap Kapak Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": "Komple Mutfak Yenileme",
      "options": [
        "Akrilik Kapak",
        "Lake Kapak",
        "Membran MDFLam",
        "Masif Ahşap Kapak"
      ]
    },
    {
      "id": "kapak_tipi_dolap",
      "label": "Dolap Kapak Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": "Sadece Dolap İmalatı",
      "options": [
        "Akrilik Kapak",
        "Lake Kapak",
        "Membran MDFLam",
        "Masif Ahşap Kapak"
      ]
    },
    {
      "id": "kapak_tipi_kapak",
      "label": "Dolap Kapak Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": "Kapak Yenileme Boyama",
      "options": [
        "Akrilik Kapak",
        "Lake Kapak",
        "Membran MDFLam",
        "Masif Ahşap Kapak"
      ]
    },
    {
      "id": "tezgah_tipi_komple",
      "label": "Tezgah Malzeme Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapak_tipi_komple",
      "dependsOnValue": "Akrilik Kapak",
      "options": [
        "Kuvars Kompoze Tezgah",
        "Porselen Tezgah",
        "Granit Tezgah",
        "Ahşap Masif Panel Tezgah"
      ]
    },
    {
      "id": "tezgah_tipi_sadece",
      "label": "Tezgah Malzeme Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": "Sadece Tezgah Değişimi",
      "options": [
        "Kuvars Kompoze Tezgah",
        "Porselen Tezgah",
        "Granit Tezgah",
        "Ahşap Masif Panel Tezgah"
      ]
    },
    {
      "id": "mutfak_formu",
      "label": "Mutfak Yerleşim Formu",
      "type": "single",
      "required": true,
      "dependsOnId": "tezgah_tipi_komple",
      "dependsOnValue": "Kuvars Kompoze Tezgah",
      "options": [
        "Düz Mutfak",
        "L Mutfak",
        "U Mutfak Ada Entegrasyon"
      ]
    },
    {
      "id": "metraj_segmenti",
      "label": "Toplam Mutfak Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "mutfak_formu",
      "dependsOnValue": "Düz Mutfak",
      "options": [
        "0-3 Metretül",
        "3-5 Metretül",
        "5-8 Metretül",
        "8 Metretül ve Üzeri"
      ]
    },
    {
      "id": "yapi_tipi",
      "label": "Uygulama Alanı Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "metraj_segmenti",
      "dependsOnValue": "0-3 Metretül",
      "options": [
        "Apartman Dairesi",
        "Müstakil Ev Villa",
        "Ofis Personel Mutfağı",
        "Cafe Restoran Ticari"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Mekanizma ve Donanım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "yapi_tipi",
      "dependsOnValue": "Apartman Dairesi",
      "options": [
        "Premium Frenli Ray Setleri",
        "Kör Köşe Kiler Sistemi",
        "Kulpsuz Gola Sistem",
        "Tezgah Arası Cam Kaplama",
        "LED Aydınlatma Entegrasyonu"
      ]
    }
  ];
}