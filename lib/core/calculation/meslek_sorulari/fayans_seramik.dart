// lib/core/calculation/meslek_sorulari/fayans_seramik.dart

class FayansSeramikSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ ANA TETİKLEYİCİ: Tüm alt soruları ve akışı kilitler
      "label": "Fayans / Seramik İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)",
        "Sadece Eski Fayans Kırım ve Duvar/Zemin Kazıma İşçiliği"
      ]
    },
    {
      "id": "seramik_ebati", // Hesaplayıcıda '60x120', 'Mozaik/Metro', 'Dev' ve standart m² fiyatını belirler
      "label": "Seramik Ebat ve Tasarım Seçimi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)"],
      "options": [
        "Standart (30x60, 60x60) Ölçüleri",
        "Büyük Ebat (60x120 ve Üzeri Porselen Seramik)",
        "Mozaik / Metro / Dekoratif Küçük Ebat Seramik",
        "Dev Plaka Lamine (120x240 Slab) Özel Ekip İşçiliği"
      ]
    },
    {
      "id": "alan_segmenti", // Hesaplayıcıda m² aralıklarını kontrol ederek otomatik m² atar ve barajı esnetir
      "label": "Uygulama Yapılacak Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)",
        "Sadece Eski Fayans Kırım ve Duvar/Zemin Kazıma İşçiliği"
      ],
      "options": [
        "0-10 m² Arası (Küçük Alan / WC / Tezgah Arası)",
        "10-30 m² Arası (Banyo / Balkon Zemin)",
        "30-70 m² Arası (Teras / Orta Ölçek Alan)",
        "70 m² ve Üzeri (Tüm Ev Zemin / Büyük Mağaza)"
      ]
    },
    {
      "id": "metre_kare", // Net m² girilirse robot segment yerine doğrudan bu sayıyı çarpar
      "label": "Net Alan Ölçüsü Girin (m² - Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 24",
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)",
        "Sadece Eski Fayans Kırım ve Duvar/Zemin Kazıma İşçiliği"
      ]
    },
    {
      "id": "zemin_durumu", // Hesaplayıcıda 'Eski Fayans' kelimesini yakalarsa kırım ve moloz için m² başına bindirim yapar
      "label": "Uygulama Yapılacak Mevcut Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)"],
      "options": [
        "Şaplı / Düz Zemin (Ham Yapı / Seramiğe Hazır)",
        "Zeminde Eski Fayans Var (Hilti ile Kırım ve Moloz Çuvallama Dahil)",
        "Fayans Üstü Fayans Uygulaması (Geçiş Astarlı)"
      ]
    },
    {
      "id": "moloz_dokum_durumu", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue yapısına geçirildi
      "label": "Moloz Taşıma ve Atım Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durumu",
      "dependsOnValue": [
        "Zeminde Eski Fayans Var (Hilti ile Kırım ve Moloz Çuvallama Dahil)"
      ],
      "options": [
        "Moloz Çuvallanıp Kamyona Yüklenecek (Kat Basit / Asansörlü)",
        "Moloz Sadece Çuvallanacak (Kapı Önüne Bırakılacak)",
        "Kırım Yapılsın, Moloz Atımını Müşteri Çözecek"
      ]
    },
    {
      "id": "ekstra_ozellikler", // Fiyat ibareleri müşteriden gizlendi, teknik isimler korundu
      "label": "Teknik İzolasyon ve Estetik Köşe Ekstralarınız",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)"],
      "options": [
        "Su Yalıtımı ve İzolasyon Uygulaması (Çift Kat Sürme + Köşe Pah Bandı)",
        "45 Derece Jolly Köşe Taşlama İşçiliği (Estetik Birleşim Köşeleri)",
        "Epoksi Derz Uygulaması (Leke Tutmayan, Kimyasal Dayanımlı Derz)",
        "Tesviye Şapı Uygulaması (Bozuk Zeminler İçin Kendinden Yayılan Akıllı Şap)"
      ]
    },
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alanı Mimari Bölgesi",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)",
        "Sadece Eski Fayans Kırım ve Duvar/Zemin Kazıma İşçiliği"
      ],
      "options": ["Banyo (Duvar / Zemin)", "Mutfak Tezgah Arası", "Balkon / Teras", "Havuz İçi Kaplama", "Tüm Ev Zemin"]
    },
    {
      "id": "malzeme_sinif",
      "label": "Kalite Sınıfı Beyanı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)"],
      "options": ["1. Kalite Malzeme", "Defolu / Ekonomik Seri", "Usta Tedarik Etsin"]
    }
  ];
}