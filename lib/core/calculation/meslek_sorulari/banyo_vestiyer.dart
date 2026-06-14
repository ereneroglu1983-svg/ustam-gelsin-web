// lib/core/calculation/meslek_sorulari/banyo_vestiyer.dart

class BanyoVestiyerSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi", // 🛠️ EN ANA TETİKLEYİCİ
      "label": "İhtiyacınız Olan Mobilya Grubu",
      "type": "single",
      "required": true,
      "options": [
        "Banyo Dolabı (Lavabolu / Lavabosuz Modeller)",
        "Vestiyer / Portmanto İmalatı (Antre Grubu)",
        "Çamaşır Makinesi Dolabı (Banyo / Çamaşır Odası Grubu)",
        "Gömme Dolap / Yüklük (Yatak Odası / Koridor Grubu)"
      ]
    },
    {
      "id": "banyo_malzeme_tipi",
      "label": "Banyo Grubu Gövde ve Kapak Malzemesi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Banyo Dolabı (Lavabolu / Lavabosuz Modeller)",
        "Çamaşır Makinesi Dolabı (Banyo / Çamaşır Odası Grubu)"
      ],
      "options": [
        "Suya Dayanıklı Yeşil MDF Lam (Neme Karşı Dirençli Standart Gövde)",
        "Poliüretan Lake Kapak (MDF Üzeri Lüks Su Geçirmez Boyalı İşçilik)",
        "Akrilik / High Gloss Kapak (MDF Üzeri Parlak Su İtici Yüzey)"
      ]
    },
    {
      "id": "kuru_alan_malzemesi",
      "label": "Vestiyer / Dolap Gövde ve Kapak Malzemesi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Vestiyer / Portmanto İmalatı (Antre Grubu)",
        "Gömme Dolap / Yüklük (Yatak Odası / Koridor Grubu)"
      ],
      "options": [
        "Standart MDF Lam Gövde ve Kapak",
        "High Gloss / Akrilik Kapak (Çizilmeye Dayanıklı Parlak/Mat Yüzey)",
        "İpek Mat Lake Kapak (CNC İşlemeli Lüks Panel Serisi)",
        "Doğal Masif Ahşap Kaplama Plaka"
      ]
    },
    {
      "id": "dolap_olcusu", // 🛠️ TEK ÖLÇÜ KAYNAĞI: Tamamen sekmeli hale getirildi, text kaldırıldı!
      "label": "Tahmini Mobilya Genişliği / Ölçü Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Banyo Dolabı (Lavabolu / Lavabosuz Modeller)",
        "Vestiyer / Portmanto İmalatı (Antre Grubu)",
        "Çamaşır Makinesi Dolabı (Banyo / Çamaşır Odası Grubu)",
        "Gömme Dolap / Yüklük (Yatak Odası / Koridor Grubu)"
      ],
      "options": [
        "Küçük Ölçekli Alan (0 - 1 Metre Arası Dar Alan Çözümleri)",
        "Orta Ölçekli Alan (1 - 2 Metre Arası Standart Ölçü)",
        "Geniş Ölçekli Alan (2 - 3 Metre Arası Geniş Yerleşim)",
        "Tam Boy / Duvar Blok (3 Metre ve Üzeri Komple Kurulum)"
      ]
    },
    {
      "id": "kapak_modeli",
      "label": "Kapak Tasarım ve Yüzey Modeli",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Banyo Dolabı (Lavabolu / Lavabosuz Modeller)",
        "Vestiyer / Portmanto İmalatı (Antre Grubu)",
        "Çamaşır Makinesi Dolabı (Banyo / Çamaşır Odası Grubu)",
        "Gömme Dolap / Yüklük (Yatak Odası / Koridor Grubu)"
      ],
      "options": [
        "Düz / Standart Modern Kapak Tasarımı",
        "Çıtalı Kapak / Country Model Tasarımı (Özel CNC Kesim İşçiliği)"
      ]
    },
    {
      "id": "montaj_durum",
      "label": "Mevcut Alandaki Demontaj Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Banyo Dolabı (Lavabolu / Lavabosuz Modeller)",
        "Vestiyer / Portmanto İmalatı (Antre Grubu)",
        "Çamaşır Makinesi Dolabı (Banyo / Çamaşır Odası Grubu)",
        "Gömme Dolap / Yüklük (Yatak Odası / Koridor Grubu)"
      ],
      "options": [
        "Eski Dolap Sökülecek (Demontaj ve Moloz Temizliği İşçiliği Dahil)",
        "Boş Alan / Sıfır Duvar Yuvası (Doğrudan Yeni Montaj)"
      ]
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Banyo Dolabı (Lavabolu / Lavabosuz Modeller)",
        "Vestiyer / Portmanto İmalatı (Antre Grubu)",
        "Çamaşır Makinesi Dolabı (Banyo / Çamaşır Odası Grubu)",
        "Gömme Dolap / Yüklük (Yatak Odası / Koridor Grubu)"
      ],
      "options": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri Ticari Alanı",
        "Otel / Pansiyon Projesi"
      ]
    },
    {
      "id": "ekstra_donanimlar", // 🛠️ Tamamen reklamsız, jenerik premium donanım tanımları
      "label": "Mekanizma, Aydınlatma ve Donanım Ekstraları",
      "type": "multi",
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Banyo Dolabı (Lavabolu / Lavabosuz Modeller)",
        "Vestiyer / Portmanto İmalatı (Antre Grubu)",
        "Çamaşır Makinesi Dolabı (Banyo / Çamaşır Odası Grubu)",
        "Gömme Dolap / Yüklük (Yatak Odası / Koridor Grubu)"
      ],
      "options": [
        "LED Şerit / Sensörlü Dolap İçi Aydınlatma Sistemi",
        "Alüminyum Çerçeveli Cam Kapak Tasarımı Farkı",
        "Premium Frenli Menteşe ve Ray Sistemleri Entegrasyonu (Sessiz Konfor Paketi)",
        "Boy Aynası / Rodajlı Güvenlikli Ayna Entegrasyonu",
        "Seramik Lavabo ve Batarya Seti Tedariği (Sadece Banyo Seçimleri İçin)"
      ]
    }
  ];
}