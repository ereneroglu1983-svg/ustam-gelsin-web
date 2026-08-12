// lib/core/calculation/meslek_sorulari/ferforje_metal.dart - FINAL
class FerforjeMetalSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Sıfırdan İmalat Nakliye Montaj", "Mevcut Demir Onarım Kaynak Boya"]
    },
    {
      "id": "urun_tipi",
      "label": "Ana Ürün Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["Pencere Balkon Korkuluğu", "Bahçe Garaj Kapısı", "Yangın Merdiveni"]
    },
    {
      "id": "alan_segmenti",
      "label": "Toplam Uzunluk Metraj",
      "type": "single",
      "required": true,
      "dependsOnId": "urun_tipi",
      "options": ["0-5 Metre m² Küçük", "5-12 Metre Standart", "12-25 Metre Geniş", "25 Metre Üzeri Büyük"]
    },
    {
      "id": "tasarim_modeli",
      "label": "Tasarım İşçilik Yoğunluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan İmalat Nakliye Montaj"],
      "options": ["Standart Düz Profil Modern", "Klasik Motifli Ferforje Kavisli", "Özel CNC Kesim Sac Giydirme"]
    },
    {
      "id": "kapi_mekanizmasi",
      "label": "Kapı Çalışma Mekanizması",
      "type": "single",
      "required": true,
      "dependsOnId": "urun_tipi",
      "dependsOnValue": ["Bahçe Garaj Kapısı"],
      "options": ["Yana Kayar Sürgülü Raylı", "Çift Kanatlı Dairesel Menteşeli", "Tek Kanatlı Yaya Kapısı"]
    },
    {
      "id": "motor_otomasyonu",
      "label": "Motor Otomasyon Talebi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_mekanizmasi",
      "options": ["Otomatik Motorlu Kumandalı Flaşörlü", "Manuel El İle Otomasyonsuz"]
    },
    {
      "id": "yuzey_islem",
      "label": "Yüzey Koruma Boya Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "tasarim_modeli",
      "options": ["Elektrostatik Toz Fırın Boya", "Sıcak Daldırma Galvaniz Paslanmaz", "Patina Bakır Eskitme Dekoratif"]
    },
    {
      "id": "yuzey_islem_garaj",
      "label": "Yüzey Koruma Boya Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "motor_otomasyonu",
      "options": ["Elektrostatik Toz Fırın Boya", "Sıcak Daldırma Galvaniz Paslanmaz", "Patina Bakır Eskitme Dekoratif"]
    },
    {
      "id": "ekstra_korkuluk",
      "label": "Donanım ve Kalınlık Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "yuzey_islem",
      "options": [
        "Yüksek Et Kalın Profil İçi Dolu Demir",
        "Akıllı Kilit Solenoid Trafo",
        "Paslanmaz Ankraj Montaj",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_garaj",
      "label": "Donanım ve Otomasyon Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "yuzey_islem_garaj",
      "options": [
        "Ağır Hizmet Motor Dişli Fotosel",
        "Sürme Ray Rulmanlı Tekerlek Zemin Kılavuz",
        "Yüksek Et Kalın Profil",
        "Uzaktan Kumanda Flaşör",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "onarim_detay",
      "label": "Onarım Kapsamı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mevcut Demir Onarım Kaynak Boya"],
      "options": ["Kaynak Onarım Güçlendirme", "Zımpara Boya Yenileme", "Komple Sök Tak Yenileme"]
    }
  ];
}