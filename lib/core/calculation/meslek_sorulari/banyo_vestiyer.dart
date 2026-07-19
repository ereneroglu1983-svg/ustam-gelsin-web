// lib/core/calculation/meslek_sorulari/banyo_vestiyer.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class BanyoVestiyerSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "uygulama_tipi",
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

    // ADIM 2: MALZEME DALLARI - sadece ilgili köklerde gelir
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

    // ADIM 3: ÖLÇÜ - malzeme seçilince gelsin (dal sonrası tek soru)
    // NOT: 2 farklı dal olduğu için tek dependsOnId yetmez, o yüzden
    // banyo_malzeme_tipi ve kuru_alan_malzemesi'nin TÜM opsiyonlarını
    // kapsayacak şekilde alan_segmenti'ni malzeme sonrası zincire bağlıyoruz.
    // Çözüm: dolap_olcusu'nu banyo dalına bağlıyoruz, kuru dal için de
    // aynı mantık _alanGorunurMu'da OR olarak çalışacak şekilde
    // dependsOnId'yi liste olarak destekliyoruz.
    {
      "id": "dolap_olcusu",
      "label": "Tahmini Mobilya Genişliği / Ölçü Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi", // Eski halinde doğruydu, koruyoruz ki 2 dalda da çalışsın
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

    // ADIM 4: KAPAK MODELİ - ölçü seçilince gelsin
    {
      "id": "kapak_modeli",
      "label": "Kapak Tasarım ve Yüzey Modeli",
      "type": "single",
      "required": true,
      "dependsOnId": "dolap_olcusu",
      "dependsOnValue": [
        "Küçük Ölçekli Alan (0 - 1 Metre Arası Dar Alan Çözümleri)",
        "Orta Ölçekli Alan (1 - 2 Metre Arası Standart Ölçü)",
        "Geniş Ölçekli Alan (2 - 3 Metre Arası Geniş Yerleşim)",
        "Tam Boy / Duvar Blok (3 Metre ve Üzeri Komple Kurulum)"
      ],
      "options": [
        "Düz / Standart Modern Kapak Tasarımı",
        "Çıtalı Kapak / Country Model Tasarımı (Özel CNC Kesim İşçiliği)"
      ]
    },

    // ADIM 5: MONTAJ DURUMU - kapak seçilince gelsin
    {
      "id": "montaj_durum",
      "label": "Mevcut Alandaki Demontaj Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "kapak_modeli",
      "dependsOnValue": [
        "Düz / Standart Modern Kapak Tasarımı",
        "Çıtalı Kapak / Country Model Tasarımı (Özel CNC Kesim İşçiliği)"
      ],
      "options": [
        "Eski Dolap Sökülecek (Demontaj ve Moloz Temizliği İşçiliği Dahil)",
        "Boş Alan / Sıfır Duvar Yuvası (Doğrudan Yeni Montaj)"
      ]
    },

    // ADIM 6: YAPI TİPİ - montaj seçilince gelsin
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_durum",
      "dependsOnValue": [
        "Eski Dolap Sökülecek (Demontaj ve Moloz Temizliği İşçiliği Dahil)",
        "Boş Alan / Sıfır Duvar Yuvası (Doğrudan Yeni Montaj)"
      ],
      "options": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri Ticari Alanı",
        "Otel / Pansiyon Projesi"
      ]
    },

    // ADIM 7: FİNAL - yapı tipi seçilince yeşil kutuda açılsın
    {
      "id": "ekstra_donanimlar",
      "label": "Mekanizma, Aydınlatma ve Donanım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "yapi_tip",
      "dependsOnValue": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri Ticari Alanı",
        "Otel / Pansiyon Projesi"
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