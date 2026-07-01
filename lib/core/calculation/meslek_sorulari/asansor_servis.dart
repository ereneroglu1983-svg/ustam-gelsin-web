// lib/core/calculation/meslek_sorulari/asansor_servis.dart

class AsansorSorulari {
  static final List<Map<String, dynamic>> sorular = [
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
    {
      "id": "durak_sayisi",
      "label": "Toplam Durak (Kat) Sayısı",
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
        "2-4 Durak",
        "5-8 Durak",
        "9-15 Durak",
        "16 Kat ve Üzeri"
      ]
    },
    {
      "id": "kat", // 🛠️ REVIZE: Text sekmesi kaldırıldı, mimariyi bozmayan net seçimli single sekme getirildi.
      "label": "Tam Kat Aralığı Belirleme",
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
        "Zemin / Alçak Kat Yapısı (2 - 4 Kat)",
        "Standart Apartman Segmenti (5 - 8 Kat)",
        "Yüksek Katlı Bina Yapısı (9 - 15 Kat)",
        "Çok Yüksek Rezidans / Kule (16 Kat ve Üzeri)"
      ]
    },
    {
      "id": "bina_tipi",
      "label": "Bina Kullanım Türü",
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
        "Konut / Apartman",
        "Ticari Plaza / Otel",
        "Hastane / Sağlık Merkezi (Kamu)",
        "Kamu Binası"
      ]
    },
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
    {
      "id": "parca_garanti",
      "label": "Yedek Parça ve Güvenlik Sınıfı",
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
        "CE Belgeli / Yerli Üretim",
        "Global Marka (Orijinal)",
        "Usta Keşif Sonrası Önersin"
      ]
    }
  ];
}