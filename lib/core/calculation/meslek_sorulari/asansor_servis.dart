// lib/core/calculation/meslek_sorulari/asansor_servis.dart - FINAL
class AsansorSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "hizmet_turu",
      "label": "İhtiyacınız Olan Hizmet",
      "type": "single",
      "required": true,
      "options": ["Periyodik Aylık Bakım", "Acil Arıza Müdahale", "Yıllık Revizyon Etiket Hazırlık", "Komple Modernizasyon Yenileme"]
    },
    {
      "id": "asansor_tipi",
      "label": "Asansör Teknik Yapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "options": ["Halatlı Makine Daireli", "MRL Makine Dairesiz", "Hidrolik Sistem", "Yük Araç Asansörü", "Panoramik Asansör"]
    },
    {
      "id": "durak_sayisi",
      "label": "Toplam Durak Kat Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "asansor_tipi",
      "options": ["2-4 Durak", "5-8 Durak", "9-15 Durak", "16 Kat ve Üzeri"]
    },
    {
      "id": "bina_tipi",
      "label": "Bina Kullanım Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "durak_sayisi",
      "options": ["Konut Apartman", "Ticari Plaza Otel", "Hastane Sağlık Merkezi", "Kamu Binası"]
    },
    {
      "id": "etiket_durumu",
      "label": "Mevcut Etiket Rengi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Yıllık Revizyon Etiket Hazırlık"],
      "options": ["Kırmızı Ağır Kusurlu", "Sarı Kusurlu", "Mavi Hafif Kusurlu", "Etiket Yok İlk Denetim"]
    },
    {
      "id": "ariza_belirtisi",
      "label": "Arıza Belirtileri",
      "type": "multi",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Acil Arıza Müdahale"],
      "options": ["Kat Arasında Kaldı", "Kapı Açılmıyor Kapanmıyor", "Sarsıntılı Gürültülü Çalışma", "Kumanda Panosu Hatası", "Sinyalizasyon Buton Arızası"]
    },
    {
      "id": "modernizasyon_kapsami",
      "label": "Yenilenecek Üniteler",
      "type": "multi",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Komple Modernizasyon Yenileme"],
      "options": ["Makine Motor Değişimi", "Kabin ve Kapılar", "Çelik Halatlar", "Kumanda Panosu Inverterlı", "Fotosel Güvenlik Sensörleri"]
    },
    {
      "id": "parca_garanti",
      "label": "Yedek Parça Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "bina_tipi",
      "options": ["CE Belgeli Yerli Üretim", "Global Marka Orijinal", "Fiyat Performans Ekonomik Seri"]
    }
  ];
}