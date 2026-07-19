// lib/core/calculation/meslek_sorulari/asansor_servis.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class AsansorSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "hizmet_turu",
      "label": "İhtiyacınız Olan Hizmet",
      "type": "single",
      "required": true,
      "options": [
        "Periyodik Aylık Bakım",
        "Acil Arıza Müdahale",
        "Yıllık Revizyon (Mavi/Yeşil Etiket Hazırlık)",
        "Komple Modernizasyon (Yenileme)"
      ]
    },

    // ADIM 2: TEKNİK YAPI - hizmet seçilince gelsin
    {
      "id": "asansor_tipi",
      "label": "Asansör Teknik Yapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Periyodik Aylık Bakım",
        "Acil Arıza Müdahale",
        "Yıllık Revizyon (Mavi/Yeşil Etiket Hazırlık)",
        "Komple Modernizasyon (Yenileme)"
      ],
      "options": [
        "Halatlı (Makine Daireli)",
        "MRL (Makine Dairesiz/Dairesiz)",
        "Hidrolik Asansör Sistemleri",
        "Yük / Araç Asansörü",
        "Panoramik Asansör"
      ]
    },

    // ADIM 3: DURAK SAYISI - tip seçilince gelsin
    {
      "id": "durak_sayisi",
      "label": "Toplam Durak (Kat) Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "asansor_tipi",
      "dependsOnValue": [
        "Halatlı (Makine Daireli)",
        "MRL (Makine Dairesiz/Dairesiz)",
        "Hidrolik Asansör Sistemleri",
        "Yük / Araç Asansörü",
        "Panoramik Asansör"
      ],
      "options": [
        "2-4 Durak",
        "5-8 Durak",
        "9-15 Durak",
        "16 Kat ve Üzeri"
      ]
    },

    // ADIM 4: KAT ARALIĞI - durak seçilince gelsin
    {
      "id": "kat",
      "label": "Tam Kat Aralığı Belirleme",
      "type": "single",
      "required": true,
      "dependsOnId": "durak_sayisi",
      "dependsOnValue": [
        "2-4 Durak",
        "5-8 Durak",
        "9-15 Durak",
        "16 Kat ve Üzeri"
      ],
      "options": [
        "Zemin / Alçak Kat Yapısı (2 - 4 Kat)",
        "Standart Apartman Segmenti (5 - 8 Kat)",
        "Yüksek Katlı Bina Yapısı (9 - 15 Kat)",
        "Çok Yüksek Rezidans / Kule (16 Kat ve Üzeri)"
      ]
    },

    // ADIM 5: BİNA TİPİ - kat seçilince gelsin
    {
      "id": "bina_tipi",
      "label": "Bina Kullanım Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "kat",
      "dependsOnValue": [
        "Zemin / Alçak Kat Yapısı (2 - 4 Kat)",
        "Standart Apartman Segmenti (5 - 8 Kat)",
        "Yüksek Katlı Bina Yapısı (9 - 15 Kat)",
        "Çok Yüksek Rezidans / Kule (16 Kat ve Üzeri)"
      ],
      "options": [
        "Konut / Apartman",
        "Ticari Plaza / Otel",
        "Hastane / Sağlık Merkezi (Kamu)",
        "Kamu Binası"
      ]
    },

    // ==================== DALLANAN ÖZEL SORULAR - ZATEN DOĞRUYDU, KORUNDU ====================
    {
      "id": "etiket_durumu",
      "label": "Mevcut Etiket Rengi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Yıllık Revizyon (Mavi/Yeşil Etiket Hazırlık)"
      ],
      "options": [
        "Kırmızı (Kullanım Dışı / Ağır Kusurlu)",
        "Sarı (Kusurlu)",
        "Mavi (Hafif Kusurlu)",
        "Etiket Yok / İlk Denetim"
      ]
    },
    {
      "id": "ariza_belirtisi",
      "label": "Arıza Belirtileri",
      "type": "multi",
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Acil Arıza Müdahale"
      ],
      "options": [
        "Kat Arasında Kaldı (Halat/Fren Problemi)",
        "Kapı Açılmıyor / Kapanmıyor Arızası",
        "Sarsıntılı / Gürültülü Çalışma",
        "Kumanda Panosu Hatası / Arızası",
        "Sinyalizasyon / Buton Arızası"
      ]
    },
    {
      "id": "modernizasyon_kapsami",
      "label": "Yenilenecek Üniteler (Modernizasyon)",
      "type": "multi",
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Komple Modernizasyon (Yenileme)"
      ],
      "options": [
        "Makine Motor Ünitesi Değişimi",
        "Kabin İçi ve Kapılar Yenilenmesi",
        "Çelik Halatlerin Değişimi",
        "Kumanda Panosu (Inverterlı)",
        "Fotosel ve Güvenlik Sensörleri"
      ]
    },

    // ADIM 6: FİNAL - bina tipi seçilince gelsin
    {
      "id": "parca_garanti",
      "label": "Yedek Parça ve Güvenlik Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "bina_tipi",
      "dependsOnValue": [
        "Konut / Apartman",
        "Ticari Plaza / Otel",
        "Hastane / Sağlık Merkezi (Kamu)",
        "Kamu Binası"
      ],
      "options": [
        "CE Belgeli / Yerli Üretim",
        "Global Marka (Orijinal)",
        "Usta Keşif Sonrası Önersin"
      ]
    }
  ];
}