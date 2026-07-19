// lib/core/calculation/meslek_sorulari/bina_temizlik.dart - TEXT KALDIRILDI, SEÇMELİ VERSİYON

class BinaTemizlikSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "temizlik_turu",
      "label": "Temizlik Türü ve Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "İnşaat Sonrası Kaba Temizlik (Moloz, Alçı ve Harç Kaldırma)",
        "İnşaat Sonrası Detaylı / İnce Temizlik (Boya Sökme, İnce Toz ve Cam Kazıma)",
        "Ofis / İşyeri Genel Temizliği (Periyodik veya Tek Seferlik Düzenleme)",
        "Bina Merdiven / Ortak Alan Temizliği",
        "Dış Cephe Cam Temizliği (Plaza, Gökdelen ve Otel Cam Yüzeyleri)"
      ]
    },

    // ADIM 2: METRAJ - tür seçilince gelsin (TEXT KALDIRILDI -> SINGLE YAPILDI)
    {
      "id": "alan_m2",
      "label": "Temizlik Yapılacak Toplam Alan Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "temizlik_turu",
      "dependsOnValue": [
        "İnşaat Sonrası Kaba Temizlik (Moloz, Alçı ve Harç Kaldırma)",
        "İnşaat Sonrası Detaylı / İnce Temizlik (Boya Sökme, İnce Toz ve Cam Kazıma)",
        "Ofis / İşyeri Genel Temizliği (Periyodik veya Tek Seferlik Düzenleme)",
        "Bina Merdiven / Ortak Alan Temizliği",
        "Dış Cephe Cam Temizliği (Plaza, Gökdelen ve Otel Cam Yüzeyleri)"
      ],
      "options": [
        "0-50 m²",
        "50-100 m²",
        "100-200 m²",
        "200-350 m²",
        "350-500 m²",
        "500 m² ve Üzeri"
      ]
    },

    // ADIM 3: ODA / BÖLÜM SAYISI - alan seçilince gelsin (TEXT KALDIRILDI -> SINGLE YAPILDI)
    {
      "id": "oda_bölüm_sayisi",
      "label": "Toplam Oda / Bölüm Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_m2",
      "dependsOnValue": [
        "0-50 m²",
        "50-100 m²",
        "100-200 m²",
        "200-350 m²",
        "350-500 m²",
        "500 m² ve Üzeri"
      ],
      "options": [
        "1-2 Oda / Bölüm",
        "3-4 Oda / Bölüm",
        "5-7 Oda / Bölüm",
        "8-12 Oda / Bölüm",
        "12+ Oda / Bölüm (Geniş Alan)"
      ]
    },

    // ADIM 4: YAPI TİPİ - oda sayısı seçilince gelsin
    {
      "id": "yapi_tip",
      "label": "Yapı Yapısal Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "oda_bölüm_sayisi",
      "dependsOnValue": [
        "1-2 Oda / Bölüm",
        "3-4 Oda / Bölüm",
        "5-7 Oda / Bölüm",
        "8-12 Oda / Bölüm",
        "12+ Oda / Bölüm (Geniş Alan)"
      ],
      "options": [
        "Plaza / Gökdelen",
        "Alçak Katlı Ofis",
        "Villa / Müstakil Ev",
        "Otel / Okul / Kamu Binası"
      ]
    },

    // ADIM 5: PERİYOT - yapı tipi seçilince gelsin
    {
      "id": "periyot",
      "label": "Hizmet Sıklığı (Periyot Planlaması)",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "dependsOnValue": [
        "Plaza / Gökdelen",
        "Alçak Katlı Ofis",
        "Villa / Müstakil Ev",
        "Otel / Okul / Kamu Binası"
      ],
      "options": [
        "Tek Seferlik Hizmet",
        "Aylık Düzenli Hizmet",
        "3 Aylık Periyot",
        "6 Aylık Periyot"
      ]
    },

    // ADIM 5.5: ÖZEL DAL - sadece Dış Cephe + periyot seçildiyse gelsin
    {
      "id": "erisim_yontemi",
      "label": "Dış Cephe Erişim Yöntemi",
      "type": "single",
      "required": true,
      "dependsOnId": "temizlik_turu",
      "dependsOnValue": [
        "Dış Cephe Cam Temizliği (Plaza, Gökdelen ve Otel Cam Yüzeyleri)"
      ],
      "options": [
        "Yerden Uzatma Aparatı / Teleskobik Boru (Alçak Katlar İçin)",
        "Vinç / Sepet Gerektirir (Günlük Platform Vinç Kiralama Dahil)",
        "Dış Cephe Asansör Sistemi Var (Bina Bünyesindeki Sepet Kullanılacak)",
        "Dağcı Ekibi (Rope Access) İhtiyacı (İple Erişim Sertifikalı Personel)"
      ]
    },

    // ADIM 6: FİNAL - periyot seçilince yeşil kutuda açılsın
    {
      "id": "ekstra_ozellikler",
      "label": "Ek Hizmet Talepleri",
      "type": "multi",
      "required": false,
      "dependsOnId": "periyot",
      "dependsOnValue": [
        "Tek Seferlik Hizmet",
        "Aylık Düzenli Hizmet",
        "3 Aylık Periyot",
        "6 Aylık Periyot"
      ],
      "options": [
        "Zemin Cilalama ve Cilalama Makinesi Uygulaması (Mermer/PVC Parlatma)",
        "Buharlı Dezenfeksiyon ve Sterilizasyon Hizmeti (Yüksek Basınçlı Hijyen)",
        "Kimyasal Alçı ve Harç Sökümü İşçiliği (İnşaat Sonrası Ağır Lekeler İçin)",
        "Cam Silimi (İç Mekan İçin Cam Ekstrası)"
      ]
    }
  ];
}