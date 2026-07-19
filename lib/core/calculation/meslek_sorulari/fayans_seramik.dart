// lib/core/calculation/meslek_sorulari/fayans_seramik.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class FayansSeramikSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Fayans / Seramik İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)",
        "Sadece Eski Fayans Kırım ve Duvar/Zemin Kazıma İşçiliği"
      ]
    },

    // ADIM 2: EBAT - sadece Komple'de gelsin
    {
      "id": "seramik_ebati",
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

    // ADIM 3: ALAN - Komple için ebat sonrası, Kırım için direkt kökten gelsin
    {
      "id": "alan_segmenti",
      "label": "Uygulama Yapılacak Alan Ölçüsü",
      "type": "single",
      "required": true,
      "dependsOnId": ["seramik_ebati", "is_kapsami"],
      "dependsOnValue": [
        "Standart (30x60, 60x60) Ölçüleri",
        "Büyük Ebat (60x120 ve Üzeri Porselen Seramik)",
        "Mozaik / Metro / Dekoratif Küçük Ebat Seramik",
        "Dev Plaka Lamine (120x240 Slab) Özel Ekip İşçiliği",
        "Sadece Eski Fayans Kırım ve Duvar/Zemin Kazıma İşçiliği"
      ],
      "options": [
        "0-10 m² Arası (Küçük Alan / WC / Tezgah Arası)",
        "10-30 m² Arası (Banyo / Balkon Zemin)",
        "30-70 m² Arası (Teras / Orta Ölçek Alan)",
        "70 m² ve Üzeri (Tüm Ev Zemin / Büyük Mağaza)"
      ]
    },

    // ADIM 4: NET METRE - alan seçilince gelsin
    {
      "id": "metre_kare",
      "label": "Net Alan Ölçüsü Girin (m² - Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 24",
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-10 m² Arası (Küçük Alan / WC / Tezgah Arası)",
        "10-30 m² Arası (Banyo / Balkon Zemin)",
        "30-70 m² Arası (Teras / Orta Ölçek Alan)",
        "70 m² ve Üzeri (Tüm Ev Zemin / Büyük Mağaza)"
      ]
    },

    // ADIM 5: ZEMİN DURUMU - sadece Komple'de, alan sonrası gelsin
    {
      "id": "zemin_durumu",
      "label": "Uygulama Yapılacak Mevcut Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "visibleIf": {
        "is_kapsami": "Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)"
      },
      "dependsOnValue": [
        "0-10 m² Arası (Küçük Alan / WC / Tezgah Arası)",
        "10-30 m² Arası (Banyo / Balkon Zemin)",
        "30-70 m² Arası (Teras / Orta Ölçek Alan)",
        "70 m² ve Üzeri (Tüm Ev Zemin / Büyük Mağaza)"
      ],
      "options": [
        "Şaplı / Düz Zemin (Ham Yapı / Seramiğe Hazır)",
        "Zeminde Eski Fayans Var (Hilti ile Kırım ve Moloz Çuvallama Dahil)",
        "Fayans Üstü Fayans Uygulaması (Geçiş Astarlı)"
      ]
    },

    // ADIM 6: MOLOZ - sadece Zeminde Eski Fayans Var seçilince gelsin
    {
      "id": "moloz_dokum_durumu",
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

    // ADIM 7: UYGULAMA ALANI - zemin veya moloz sonrası, Kırım yolunda direkt alan sonrası gelsin
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alanı Mimari Bölgesi",
      "type": "multi",
      "required": true,
      "dependsOnId": ["zemin_durumu", "moloz_dokum_durumu", "alan_segmenti"],
      "dependsOnValue": [
        "Şaplı / Düz Zemin (Ham Yapı / Seramiğe Hazır)",
        "Zeminde Eski Fayans Var (Hilti ile Kırım ve Moloz Çuvallama Dahil)",
        "Fayans Üstü Fayans Uygulaması (Geçiş Astarlı)",
        "Moloz Çuvallanıp Kamyona Yüklenecek (Kat Basit / Asansörlü)",
        "Moloz Sadece Çuvallanacak (Kapı Önüne Bırakılacak)",
        "Kırım Yapılsın, Moloz Atımını Müşteri Çözecek",
        "0-10 m² Arası (Küçük Alan / WC / Tezgah Arası)",
        "10-30 m² Arası (Banyo / Balkon Zemin)",
        "30-70 m² Arası (Teras / Orta Ölçek Alan)",
        "70 m² ve Üzeri (Tüm Ev Zemin / Büyük Mağaza)"
      ],
      "options": ["Banyo (Duvar / Zemin)", "Mutfak Tezgah Arası", "Balkon / Teras", "Havuz İçi Kaplama", "Tüm Ev Zemin"]
    },

    // ADIM 8: MALZEME SINIF - sadece Komple'de, uygulama alanı sonrası gelsin
    {
      "id": "malzeme_sinif",
      "label": "Kalite Sınıfı Beyanı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "visibleIf": {
        "is_kapsami": "Komple Seramik Döşeme (İşçilik veya Malzeme Dahil)"
      },
      "dependsOnValue": [
        "Banyo (Duvar / Zemin)",
        "Mutfak Tezgah Arası",
        "Balkon / Teras",
        "Havuz İçi Kaplama",
        "Tüm Ev Zemin"
      ],
      "options": ["1. Kalite Malzeme", "Defolu / Ekonomik Seri", "Usta Tedarik Etsin"]
    },

    // ADIM 9: FİNAL - malzeme sınıfı sonrası (Komple) veya direkt uygulama alanı sonrası (Kırım'da gelmemeli, o yüzden Komple'ye kitli)
    {
      "id": "ekstra_ozellikler",
      "label": "Teknik İzolasyon ve Estetik Köşe Ekstralarınız",
      "type": "multi",
      "required": false,
      "dependsOnId": "malzeme_sinif",
      "dependsOnValue": ["1. Kalite Malzeme", "Defolu / Ekonomik Seri", "Usta Tedarik Etsin"],
      "options": [
        "Su Yalıtımı ve İzolasyon Uygulaması (Çift Kat Sürme + Köşe Pah Bandı)",
        "45 Derece Jolly Köşe Taşlama İşçiliği (Estetik Birleşim Köşeleri)",
        "Epoksi Derz Uygulaması (Leke Tutmayan, Kimyasal Dayanımlı Derz)",
        "Tesviye Şapı Uygulaması (Bozuk Zeminler İçin Kendinden Yayılan Akıllı Şap)"
      ]
    }
  ];
}