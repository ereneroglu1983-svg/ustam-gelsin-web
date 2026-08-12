// lib/core/calculation/meslek_sorulari/kapi_sistemleri.dart - FINAL
class KapiSistemleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "kapi_tipi",
      "label": "Ana Kapı Teknolojisi",
      "type": "single",
      "required": true,
      "options": ["Melamin Panel Standart Oda", "Çelik Dış Kapı 6 Nokta Kilitli", "CNC Akrilik Lake Lüks Oda", "Amerikan Pres Ekonomik"]
    },
    // İÇ KAPI DALI
    {
      "id": "oda_kapi_yuzeyi",
      "label": "İç Kapı Yüzey Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": ["Melamin Panel Standart Oda", "CNC Akrilik Lake Lüks Oda", "Amerikan Pres Ekonomik"],
      "options": ["Standart Kaplama Boya", "Laminat Çizilmez Yüksek Dayanımlı"]
    },
    {
      "id": "kasa_tipi",
      "label": "Kasa Pervaz Altyapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "oda_kapi_yuzeyi",
      "options": ["Ayarlı Geçme Teleskopik Pervaz", "Sabit Kasa", "Mevcut Kasa Sadece Kanat Değişim"]
    },
    {
      "id": "kapi_adedi_ic",
      "label": "Net Kapı Adedi",
      "type": "single",
      "required": true,
      "dependsOnId": "kasa_tipi",
      "options": ["1 Adet", "2-4 Adet Küçük Daire", "5-7 Adet Standart Daire", "8-12 Adet Geniş Villa", "12 Üzeri Toplu Proje"]
    },
    {
      "id": "renk_ic",
      "label": "Renk Desen Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_adedi_ic",
      "options": ["Beyaz Standart", "Antrasit Siyah Mat", "Ceviz Meşe Doğal Desen", "Krem Vizon Soft Ton"]
    },
    {
      "id": "montaj_ic",
      "label": "Mevcut Kapı Demontaj Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "renk_ic",
      "options": ["Eski Kapı Sökülecek Demontaj Dahil", "Sıfır İnşaat Boş Kasa Yuvası"]
    },
    {
      "id": "ekstra_ic",
      "label": "İç Kapı Donanım Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "montaj_ic",
      "options": ["Camlı Model Temperli Cam", "Gizli Menteşe Manyetik Kilit", "Pervaz Genişletme Kalın Duvar", "Ekstra İstemiyorum"]
    },
    // ÇELİK DIŞ DALI
    {
      "id": "celik_govde",
      "label": "Çelik Kapı Gövde Güvenlik Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": ["Çelik Dış Kapı 6 Nokta Kilitli"],
      "options": ["Standart Muhafazalı Çelik Gövde", "Zırhlı Ağır Sac 1.5mm", "Pivot Villa Sistem Mafsallı"]
    },
    {
      "id": "celik_adet",
      "label": "Net Kapı Adedi",
      "type": "single",
      "required": true,
      "dependsOnId": "celik_govde",
      "options": ["1 Adet Tekil", "2-4 Adet", "5 Üzeri Toplu"]
    },
    {
      "id": "renk_celik",
      "label": "Renk Desen",
      "type": "single",
      "required": true,
      "dependsOnId": "celik_adet",
      "options": ["Beyaz", "Antrasit Siyah", "Ahşap Desen Kaplama", "Krem Vizon"]
    },
    {
      "id": "montaj_celik",
      "label": "Demontaj Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "renk_celik",
      "options": ["Eski Kapı Sökülecek", "Sıfır İnşaat Boş Yuva"]
    },
    {
      "id": "ekstra_celik",
      "label": "Çelik Kapı Güvenlik Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "montaj_celik",
      "options": [
        "Akıllı Kilit Parmak İzi Kartlı",
        "Monoblok Kancalı Güvenlik Sistemi",
        "Pervaz Genişletme Takımı",
        "Ekstra İstemiyorum"
      ]
    }
  ];
}