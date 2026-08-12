// lib/core/calculation/meslek_sorulari/banyo_vestiyer.dart - FINAL
class BanyoVestiyerSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "Mobilya Grubu",
      "type": "single",
      "required": true,
      "options": ["Banyo Dolabı", "Vestiyer Portmanto", "Çamaşır Makinesi Dolabı", "Gömme Dolap Yüklük"]
    },

    // ISLAK ALAN DALI
    {
      "id": "banyo_malzeme_tipi",
      "label": "Gövde ve Kapak Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Banyo Dolabı", "Çamaşır Makinesi Dolabı"],
      "options": ["Suya Dayanıklı Yeşil MDF Lam", "Poliüretan Lake Kapak", "Akrilik High Gloss Kapak"]
    },

    // KURU ALAN DALI
    {
      "id": "kuru_alan_malzemesi",
      "label": "Gövde ve Kapak Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Vestiyer Portmanto", "Gömme Dolap Yüklük"],
      "options": ["Standart MDF Lam", "High Gloss Akrilik Kapak", "İpek Mat Lake CNC", "Doğal Masif Kaplama"]
    },

    // ORTAK ZİNCİR - Islak alan sonrası
    {
      "id": "dolap_olcusu_banyo",
      "label": "Mobilya Genişliği",
      "type": "single",
      "required": true,
      "dependsOnId": "banyo_malzeme_tipi",
      "options": ["0-1 Metre Dar Alan", "1-2 Metre Standart", "2-3 Metre Geniş", "3 Metre Üzeri Tam Duvar"]
    },
    {
      "id": "dolap_olcusu_kuru",
      "label": "Mobilya Genişliği",
      "type": "single",
      "required": true,
      "dependsOnId": "kuru_alan_malzemesi",
      "options": ["0-1 Metre Dar Alan", "1-2 Metre Standart", "2-3 Metre Geniş", "3 Metre Üzeri Tam Duvar"]
    },
    {
      "id": "kapak_modeli_banyo",
      "label": "Kapak Tasarım Modeli",
      "type": "single",
      "required": true,
      "dependsOnId": "dolap_olcusu_banyo",
      "options": ["Düz Modern Kapak", "Çıtalı Country CNC Kapak"]
    },
    {
      "id": "kapak_modeli_kuru",
      "label": "Kapak Tasarım Modeli",
      "type": "single",
      "required": true,
      "dependsOnId": "dolap_olcusu_kuru",
      "options": ["Düz Modern Kapak", "Çıtalı Country CNC Kapak"]
    },
    {
      "id": "montaj_durum_banyo",
      "label": "Mevcut Alan Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "kapak_modeli_banyo",
      "options": ["Eski Dolap Sökülecek", "Boş Alan Sıfır Montaj"]
    },
    {
      "id": "montaj_durum_kuru",
      "label": "Mevcut Alan Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "kapak_modeli_kuru",
      "options": ["Eski Dolap Sökülecek", "Boş Alan Sıfır Montaj"]
    },
    {
      "id": "yapi_tip_banyo",
      "label": "Uygulama Alan Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_durum_banyo",
      "options": ["Apartman Dairesi", "Müstakil Villa", "Ofis Ticari Alan", "Otel Proje"]
    },
    {
      "id": "yapi_tip_kuru",
      "label": "Uygulama Alan Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_durum_kuru",
      "options": ["Apartman Dairesi", "Müstakil Villa", "Ofis Ticari Alan", "Otel Proje"]
    },
    {
      "id": "ekstra_donanimlar_banyo",
      "label": "Ekstra Donanım ve Mekanizma",
      "type": "multi",
      "required": true,
      "dependsOnId": "yapi_tip_banyo",
      "options": [
        "LED Sensörlü Aydınlatma",
        "Alüminyum Çerçeveli Cam Kapak",
        "Frenli Menteşe Ray Sistemi",
        "Boy Aynası Entegrasyonu",
        "Seramik Lavabo Batarya Seti",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_donanimlar_kuru",
      "label": "Ekstra Donanım ve Mekanizma",
      "type": "multi",
      "required": true,
      "dependsOnId": "yapi_tip_kuru",
      "options": [
        "LED Sensörlü Aydınlatma",
        "Alüminyum Çerçeveli Cam Kapak",
        "Frenli Menteşe Ray Sistemi",
        "Boy Aynası Entegrasyonu",
        "Ekstra İstemiyorum"
      ]
    }
  ];
}