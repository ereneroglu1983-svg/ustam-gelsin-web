// lib/core/calculation/meslek_sorulari/ray_dolap.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class RayDolapSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "islem_kapsami",
      "label": "Talep Edilen Hizmet Türü Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
        "Sadece Kapak Yenileme (Mevcut Dolaba Yeni Sürgülü/Ray Kapak Sistemi)",
        "İç Raf Düzenleme / Tadilat (Gövde İçi Raf ve Bölme Ekleme)"
      ]
    },

    // ADIM 2: GÖVDE - Sıfırdan ve İç Raf'ta gelsin
    {
      "id": "govde_malzemesi",
      "label": "Gövde ve Raf İskelet Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
        "İç Raf Düzenleme / Tadilat (Gövde İçi Raf ve Bölme Ekleme)"
      ],
      "options": [
        "Suntalam (Standart Ekonomik Gövde ve Raf İçeriği)",
        "MDF Lam (Dayanıklı ve Yüksek Yoğunluklu 1. Kalite Uzun Ömürlü Panel)",
        "Masif Ahşap Kaplama (Doğal Kereste Üzeri Özel Laka İşçilikli Lüks Seri)"
      ]
    },

    // ADIM 3: KAPAK - Sıfırdan için gövde sonrası, Kapak Yenileme için direkt kökten gelsin
    {
      "id": "kapak_modeli",
      "label": "Kapak Teknolojisi ve Yüzey Tasarımı",
      "type": "single",
      "required": true,
      "dependsOnId": ["govde_malzemesi", "islem_kapsami"],
      "dependsOnValue": [
        "Suntalam (Standart Ekonomik Gövde ve Raf İçeriği)",
        "MDF Lam (Dayanıklı ve Yüksek Yoğunluklu 1. Kalite Uzun Ömürlü Panel)",
        "Masif Ahşap Kaplama (Doğal Kereste Üzeri Özel Laka İşçilikli Lüks Seri)",
        "Sadece Kapak Yenileme (Mevcut Dolaba Yeni Sürgülü/Ray Kapak Sistemi)"
      ],
      "options": [
        "Düz / Suntalam Kapak (Modern Ekonomik Hatlar)",
        "Akrilik Panel Kapak (Yüksek Parlaklıkta Parlak/Mat Çizilmez Yüzey)",
        "Membran / Balon Pres Kapak (PVC Vakum Pres Esnek Kaplama)",
        "Lake Boya Kapak (MDF Üzeri CNC Desen İşlemeli Poliüretan Boyalı Lüks Seri)"
      ]
    },

    // ADIM 4: ALAN - Kapak sonrası (Sıfırdan ve Kapak Yenileme) veya Gövde sonrası (İç Raf)
    {
      "id": "alan_segmenti",
      "label": "Dolap Ölçüsü ve Alan Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": ["kapak_modeli", "govde_malzemesi"],
      "dependsOnValue": [
        "Düz / Suntalam Kapak (Modern Ekonomik Hatlar)",
        "Akrilik Panel Kapak (Yüksek Parlaklıkta Parlak/Mat Çizilmez Yüzey)",
        "Membran / Balon Pres Kapak (PVC Vakum Pres Esnek Kaplama)",
        "Lake Boya Kapak (MDF Üzeri CNC Desen İşlemeli Poliüretan Boyalı Lüks Seri)",
        "Suntalam (Standart Ekonomik Gövde ve Raf İçeriği)",
        "MDF Lam (Dayanıklı ve Yüksek Yoğunluklu 1. Kalite Uzun Ömürlü Panel)",
        "Masif Ahşap Kaplama (Doğal Kereste Üzeri Özel Laka İşçilikli Lüks Seri)"
      ],
      "options": [
        "0 - 4 m² Arası Standart Küçük Boy Dolap",
        "4 - 8 m² Arası Orta Boy Odalar İçin İdeal Düzen",
        "8 - 12 m² Arası Geniş Boy Giyinme Odası Blokları",
        "12 m² ve Üzeri Duvarı Komple Kaplayan Büyük Sistemler"
      ]
    },

    // ADIM 5: RAY MEKANİZMASI - sadece Sıfırdan ve Kapak Yenileme'de, alan sonrası gelsin
    {
      "id": "ray_mekanizmasi",
      "label": "Ray Mekanizması ve Kapak Açılış Akıllı Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "visibleIf": {
        "islem_kapsami": [
          "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
          "Sadece Kapak Yenileme (Mevcut Dolaba Yeni Sürgülü/Ray Kapak Sistemi)"
        ]
      },
      "dependsOnValue": [
        "0 - 4 m² Arası Standart Küçük Boy Dolap",
        "4 - 8 m² Arası Orta Boy Odalar İçin İdeal Düzen",
        "8 - 12 m² Arası Geniş Boy Giyinme Odası Blokları",
        "12 m² ve Üzeri Duvarı Komple Kaplayan Büyük Sistemler"
      ],
      "options": [
        "Standart Ray Sistemi (Manuel Açılış Alttan Makaralı)",
        "Menteşeli Frenli Stoplu Kapak Grubu",
        "Lüks Üstten Askılı Frenli Ray Sistemi (Gizli Yavaşlatıcılı Sessiz Stop Mekanizması)"
      ]
    },

    // ADIM 6: YÜKSEKLİK - ray varsa ray sonrası, İç Raf'ta direkt alan sonrası gelsin
    {
      "id": "yukseklik_tip",
      "label": "Dolap Yükseklik ve Tavan Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": ["ray_mekanizmasi", "alan_segmenti"],
      "dependsOnValue": [
        "Standart Ray Sistemi (Manuel Açılış Alttan Makaralı)",
        "Menteşeli Frenli Stoplu Kapak Grubu",
        "Lüks Üstten Askılı Frenli Ray Sistemi (Gizli Yavaşlatıcılı Sessiz Stop Mekanizması)",
        "0 - 4 m² Arası Standart Küçük Boy Dolap",
        "4 - 8 m² Arası Orta Boy Odalar İçin İdeal Düzen",
        "8 - 12 m² Arası Geniş Boy Giyinme Odası Blokları",
        "12 m² ve Üzeri Duvarı Komple Kaplayan Büyük Sistemler"
      ],
      "options": [
        "Tavana Kadar Tam Boy (Sıfır Boşluklu Pervaz Entegreli)",
        "Standart Ölçü (210 - 230 cm Arası Üstü Açık)",
        "Özel Ölçü / Alçak Tavan (Kiriş / Çatı Katı Eğim Kesimli İşçilik)"
      ]
    },

    // ADIM 7: YAPI TİP - yükseklik sonrası gelsin
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "yukseklik_tip",
      "dependsOnValue": [
        "Tavana Kadar Tam Boy (Sıfır Boşluklu Pervaz Entegreli)",
        "Standart Ölçü (210 - 230 cm Arası Üstü Açık)",
        "Özel Ölçü / Alçak Tavan (Kiriş / Çatı Katı Eğim Kesimli İşçilik)"
      ],
      "options": [
        "Yatak Odası",
        "Giyinme Odası",
        "Antre / Koridor",
        "Çocuk / Genç Odası",
        "Ofis / Arşiv Odası"
      ]
    },

    // ADIM 8: FİNAL EKSTRA - sadece Sıfırdan'da ve yapı tipi sonrası gelsin
    {
      "id": "ekstra_donanim",
      "label": "Dolap İçi Fonksiyonel Donanım ve Aksesuar Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "yapi_tip",
      "visibleIf": {
        "islem_kapsami": "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)"
      },
      "dependsOnValue": [
        "Yatak Odası",
        "Giyinme Odası",
        "Antre / Koridor",
        "Çocuk / Genç Odası",
        "Ofis / Arşiv Odası"
      ],
      "options": [
        "LED Aydınlatma Sistemi (Sensörlü, Alüminyum Kanallı Dolap İçi Profil Işık Paketi)",
        "Ayna veya Cam Kapak Entegrasyonu (Reflekte Cam / Flotal Füme Ayna İşçilik Farkı)",
        "Pantolonluk veya Asansör Askı Sistemi Entegrasyonu (Fonksiyonel Çekme Aparatları)",
        "Ekstra Derin Ölçü Tasarımı (70 - 80 cm Özel Ölçü İmalat Malzeme Firesi Çarpanı)",
        "Çekmece Modülü Ünitesi İlavesi (Dolap İçi Ekstra 3'lü Frenli Ray Çekmece Kutusu)"
      ]
    }
  ];
}