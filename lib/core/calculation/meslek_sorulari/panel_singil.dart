// lib/core/calculation/meslek_sorulari/panel_singil.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class PanelSingilSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Tercih Edilen Çatı Kaplama Teknolojisi",
      "type": "single",
      "required": true,
      "options": [
        "Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)",
        "Şingıl Kaplama (Shingle - OSB Altyapılı Dekoratif ve Esnek Seri)",
        "Trapez Sac Uygulaması (Yalıtımsız Ekonomik Tek Kat Boyalı Sac)"
      ]
    },

    // ========== SANDVİÇ PANEL YOLU ==========
    {
      "id": "panel_dolgu_tipi",
      "label": "Panel İçi Yalıtım Dolgu Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)"],
      "options": [
        "Poliüretan Dolgu (PUR - Yüksek Isı Yalıtımlı Standart)",
        "Taş Yünü Dolgu (Yangın Dayanımlı A Sınıfı Güvenlikli)",
        "Polistiren Dolgu (EPS - Ekonomik Segment Hafif Dolgu)"
      ]
    },
    {
      "id": "panel_kalinligi",
      "label": "Talep Edilen Panel Et Kalınlığı",
      "type": "single",
      "required": true,
      "dependsOnId": "panel_dolgu_tipi",
      "dependsOnValue": [
        "Poliüretan Dolgu (PUR - Yüksek Isı Yalıtımlı Standart)",
        "Taş Yünü Dolgu (Yangın Dayanımlı A Sınıfı Güvenlikli)",
        "Polistiren Dolgu (EPS - Ekonomik Segment Hafif Dolgu)"
      ],
      "options": [
        "40 mm (Standart Konut ve Sundurma Tipi)",
        "50 mm (Orta Ölçekli Fabrika ve Depo Tipi)",
        "60 mm (Geniş Endüstriyel Yapı Tipi)",
        "80-100 mm (Soğuk Hava Deposu / Maksimum İzolasyon Serisi)"
      ]
    },

    // ========== ŞINGIL YOLU ==========
    {
      "id": "shingle_modeli",
      "label": "Şıngıl (Shingle) Tasarım Formu ve Görsel Model",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Şingıl Kaplama (Shingle - OSB Altyapılı Dekoratif ve Esnek Seri)"],
      "options": [
        "Petek Model (Geleneksel Simetrik Hatlar)",
        "Safir / Yuvarlak Model (Klasik Balık Sırtı Formu)",
        "Dikdörtgen / Ejderha Dişi Tasarım (Modern Kırıklı Geometri)",
        "3D Gölgeli Özel Seri (Derinlik Efektli Premium Görünüm)"
      ]
    },

    // ADIM: ALAN - Sandviç'te kalınlık sonrası, Şıngıl'da model sonrası, Trapez'da direkt kökten gelsin
    {
      "id": "alan_m2_secim",
      "label": "Kaplama Yapılacak Yaklaşık Çatı Alanı (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": ["panel_kalinligi", "shingle_modeli", "is_kapsami"],
      "dependsOnValue": [
        "40 mm (Standart Konut ve Sundurma Tipi)",
        "50 mm (Orta Ölçekli Fabrika ve Depo Tipi)",
        "60 mm (Geniş Endüstriyel Yapı Tipi)",
        "80-100 mm (Soğuk Hava Deposu / Maksimum İzolasyon Serisi)",
        "Petek Model (Geleneksel Simetrik Hatlar)",
        "Safir / Yuvarlak Model (Klasik Balık Sırtı Formu)",
        "Dikdörtgen / Ejderha Dişi Tasarım (Modern Kırıklı Geometri)",
        "3D Gölgeli Özel Seri (Derinlik Efektli Premium Görünüm)",
        "Trapez Sac Uygulaması (Yalıtımsız Ekonomik Tek Kat Boyalı Sac)"
      ],
      "options": [
        "1 - 50 m² Arası (Küçük Alan / Kamelya / Garaj / Sundurma)",
        "51 - 120 m² Arası (Standart Müstakil Ev / Küçük Depo)",
        "121 - 250 m² Arası (Geniş Çatı / Orta Ölçekli Bina)",
        "251 - 500 m² Arası (Büyük Bina / Küçük Fabrika / Depo)",
        "500 m² Üzeri (Büyük Endüstriyel Tesis / Fabrika)"
      ]
    },

    // ADIM: KAT YÜKSEKLİĞİ - alan sonrası gelsin
    {
      "id": "kat_yuksekligi",
      "label": "Yapının Kat Yüksekliği ve Erişim Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_m2_secim",
      "dependsOnValue": [
        "1 - 50 m² Arası (Küçük Alan / Kamelya / Garaj / Sundurma)",
        "51 - 120 m² Arası (Standart Müstakil Ev / Küçük Depo)",
        "121 - 250 m² Arası (Geniş Çatı / Orta Ölçekli Bina)",
        "251 - 500 m² Arası (Büyük Bina / Küçük Fabrika / Depo)",
        "500 m² Üzeri (Büyük Endüstriyel Tesis / Fabrika)"
      ],
      "options": [
        "1-2 Katlı Bina (Alçak Yapı / İskele ve Erişim Kolay)",
        "3-5 Kat Arası Yüksek Bina (Malzeme Çekimi, Vinç Kurulumu ve Lojistik Primli)",
        "5 Kat ve Üzeri / Dev Endüstriyel Yapı (Ağır İş Makinesi ve Maksimum Güvenlik Öncelikli)"
      ]
    },

    // ADIM: ÇATI EĞİMİ - kat sonrası gelsin
    {
      "id": "cati_egimi",
      "label": "Çatının Mevcut Mimari Eğimi ve İşçilik Zorluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "kat_yuksekligi",
      "dependsOnValue": [
        "1-2 Katlı Bina (Alçak Yapı / İskele ve Erişim Kolay)",
        "3-5 Kat Arası Yüksek Bina (Malzeme Çekimi, Vinç Kurulumu ve Lojistik Primli)",
        "5 Kat ve Üzeri / Dev Endüstriyel Yapı (Ağır İş Makinesi ve Maksimum Güvenlik Öncelikli)"
      ],
      "options": [
        "Normal Eğimli Çatı Yapısı (Standart Yürüme Alanı)",
        "Dik Eğimli Çatı Yapısı (Yüksek Eğim / İSG Emniyet Kemerli ve Halatlı Çalışma Zorluğu)"
      ]
    },

    // ADIM: YAPI TİP - eğim sonrası gelsin
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimari Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "cati_egimi",
      "dependsOnValue": [
        "Normal Eğimli Çatı Yapısı (Standart Yürüme Alanı)",
        "Dik Eğimli Çatı Yapısı (Yüksek Eğim / İSG Emniyet Kemerli ve Halatlı Çalışma Zorluğu)"
      ],
      "options": [
        "Endüstriyel Yapı (Fabrika / Depo / Antrepo)",
        "Müstakil Ev / Villa / Prefabrik Konut",
        "Sundurma / Garaj / Açık Kamelya Çatısı"
      ]
    },

    // ADIM FİNAL: EKSTRA - yapı tipi sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Yalıtım Katmanları, Söküm ve Kenar Detay Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "yapi_tip",
      "dependsOnValue": [
        "Endüstriyel Yapı (Fabrika / Depo / Antrepo)",
        "Müstakil Ev / Villa / Prefabrik Konut",
        "Sundurma / Garaj / Açık Kamelya Çatısı"
      ],
      "options": [
        "Eski Çatı Kaplamasının Sökümü ve Moloz Nakliyesi Hizmeti",
        "Ekstra Taş Yünü Katmanı İlavesi (Çatı Arası Yüksek Yoğunluklu Isı Yalıtımı)",
        "Çift Kat Membran / Su Yalıtımı Desteği (Şingıl Altı Arduvazlı veya Keçeli Rulo)",
        "Eksiz Oluk / Dere Sistemleri Montajı (Eksiz Çinko/Galvaniz Yağlanmış Yağmur Hatları)",
        "Mahya ve Kenar Sacı Kapama İşçiliği (Tepe Birleşim Sacları ve Rüzgar Tahtası Montajı)"
      ]
    }
  ];
}