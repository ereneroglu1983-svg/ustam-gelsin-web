// lib/core/calculation/meslek_sorulari/klima.dart - FINAL
class KlimaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Ana Teknik Servis İşlemi",
      "type": "single",
      "required": true,
      "options": ["Periyodik Bakım İlaçlı Temizlik", "Montaj Kurulum Vakumlama", "Sökme Montaj Yer Değişim Gaz Toplama", "Gaz Basımı Şarj Kaçak Kontrol"]
    },
    {
      "id": "cihaz_kapasitesi",
      "label": "Klima Kapasite Cihaz Formu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["9000-12000 BTU Duvar Split", "18000-24000 BTU Geniş Alan Ağır Ünite", "Salon Tipi Kaset Kanallı Tavan Tipi"]
    },
    {
      "id": "cihaz_sayisi",
      "label": "İşlem Yapılacak Toplam Klima Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "cihaz_kapasitesi",
      "options": ["1 Cihaz", "2-3 Cihaz", "4-10 Cihaz", "10 Üzeri"]
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "cihaz_sayisi",
      "options": ["Apartman Dairesi", "Müstakil Villa", "Ofis İş Yeri Mağaza", "Fabrika Endüstriyel"]
    },
    // MONTAJ DALI
    {
      "id": "montaj_yuzeyi",
      "label": "Dış Ünite Montaj Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Montaj Kurulum Vakumlama", "Sökme Montaj Yer Değişim Gaz Toplama"],
      "options": ["Dış Cephe Duvar Konsollu", "Çatı Teras Zemin", "Balkon Korkuluk İçi", "Hazır Klima Askısı Altyapı"]
    },
    {
      "id": "kat_durumu",
      "label": "Montaj Kat Yükseklik Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_yuzeyi",
      "options": ["Zemin Kolay Erişim", "1-3 Kat Standart Merdiven", "4 Kat Üzeri Riskli Vinç Sepet Gerekebilir"]
    },
    {
      "id": "elektrik_hat_montaj",
      "label": "Elektrik Besleme Hattı Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "kat_durumu",
      "options": ["Hat Hazır Priz Şalter Mevcut", "Hat Çekilmesi Gerekli Panodan"]
    },
    {
      "id": "ekstra_montaj",
      "label": "Ekstra Sarf Teknik İşlemler",
      "type": "multi",
      "required": true,
      "dependsOnId": "elektrik_hat_montaj",
      "options": [
        "Ekstra Bakır Boru İzoleli Hat",
        "Dış Ünite Konsol Kauçuk Takozlu",
        "Kaçak Tespit Azot Testi",
        "Drenaj Pompası Otomatik Tahliye",
        "Ekstra İstemiyorum"
      ]
    },
    // BAKIM / GAZ DALI
    {
      "id": "elektrik_hat_diger",
      "label": "Elektrik Besleme Hattı Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "options": ["Hat Hazır", "Hat Çekilmesi Gerekli"]
    },
    {
      "id": "ekstra_diger",
      "label": "Ekstra İşlemler",
      "type": "multi",
      "required": true,
      "dependsOnId": "elektrik_hat_diger",
      "options": ["Kaçak Tespit Azot Testi", "Drenaj Pompası", "Dış Ünite Kauçuk Takoz", "Ekstra İstemiyorum"]
    }
  ];
}