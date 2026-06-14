// lib/core/calculation/meslek_sorulari/panel_singil.dart

class PanelSingilSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ ANA TETİKLEYİCİ: Formun kapısını açan anahtar ana kilit id
      "label": "Tercih Edilen Çatı Kaplama Teknolojisi",
      "type": "single",
      "required": true,
      "options": [
        "Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)",
        "Şingıl Kaplama (Shingle - OSB Altyapılı Dekoratif ve Esnek Seri)",
        "Trapez Sac Uygulaması (Yalıtımsız Ekonomik Tek Kat Boyalı Sac)"
      ]
    },

    // ==========================================
    // 🏗️ GRUP 1: SANDVİÇ PANEL DETAYLARI (Sadece Sandviç Panel Seçilirse Açılır)
    // ==========================================
    {
      "id": "panel_dolgu_tipi",
      "label": "Panel İçi Yalıtım Dolgu Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)"
      ],
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
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)"
      ],
      "options": [
        "40 mm (Standart Konut ve Sundurma Tipi)",
        "50 mm (Orta Ölçekli Fabrika ve Depo Tipi)",
        "60 mm (Geniş Endüstriyel Yapı Tipi)",
        "80-100 mm (Soğuk Hava Deposu / Maksimum İzolasyon Serisi)"
      ]
    },

    // ==========================================
    // 🎨 GRUP 2: ŞINGIL (SHINGLE) TASARIM DETAYLARI (Sadece Şingıl Kaplama Seçilirse Açılır)
    // ==========================================
    {
      "id": "shingle_modeli",
      "label": "Şıngıl (Shingle) Tasarım Formu ve Görsel Model",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Şingıl Kaplama (Shingle - OSB Altyapılı Dekoratif ve Esnek Seri)"
      ],
      "options": [
        "Petek Model (Geleneksel Simetrik Hatlar)",
        "Safir / Yuvarlak Model (Klasik Balık Sırtı Formu)",
        "Dikdörtgen / Ejderha Dişi Tasarım (Modern Kırıklı Geometri)",
        "3D Gölgeli Özel Seri (Derinlik Efektli Premium Görünüm)"
      ]
    },

    // ==========================================
    // 📐 ÖLÇÜ, METRAJ VE RİSK FAKTÖRLERİ (Ortak Sorular Da Seçime Bağlandı)
    // ==========================================
    {
      "id": "alan_m2_secim", // 🛠️ TEK ÖLÇÜ KAYNAĞI: Sıfır klavye girdisi, direkt temiz sekmeler
      "label": "Kaplama Yapılacak Yaklaşık Çatı Alanı (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)",
        "Şingıl Kaplama (Shingle - OSB Altyapılı Dekoratif ve Esnek Seri)",
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
    {
      "id": "kat_yuksekligi",
      "label": "Yapının Kat Yüksekliği ve Erişim Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)",
        "Şingıl Kaplama (Shingle - OSB Altyapılı Dekoratif ve Esnek Seri)",
        "Trapez Sac Uygulaması (Yalıtımsız Ekonomik Tek Kat Boyalı Sac)"
      ],
      "options": [
        "1-2 Katlı Bina (Alçak Yapı / İskele ve Erişim Kolay)",
        "3-5 Kat Arası Yüksek Bina (Malzeme Çekimi, Vinç Kurulumu ve Lojistik Primli)",
        "5 Kat ve Üzeri / Dev Endüstriyel Yapı (Ağır İş Makinesi ve Maksimum Güvenlik Öncelikli)"
      ]
    },
    {
      "id": "cati_egimi",
      "label": "Çatının Mevcut Mimari Eğimi ve İşçilik Zorluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)",
        "Şingıl Kaplama (Shingle - OSB Altyapılı Dekoratif ve Esnek Seri)",
        "Trapez Sac Uygulaması (Yalıtımsız Ekonomik Tek Kat Boyalı Sac)"
      ],
      "options": [
        "Normal Eğimli Çatı Yapısı (Standart Yürüme Alanı)",
        "Dik Eğimli Çatı Yapısı (Yüksek Eğim / İSG Emniyet Kemerli ve Halatlı Çalışma Zorluğu)"
      ]
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimari Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)",
        "Şingıl Kaplama (Shingle - OSB Altyapılı Dekoratif ve Esnek Seri)",
        "Trapez Sac Uygulaması (Yalıtımsız Ekonomik Tek Kat Boyalı Sac)"
      ],
      "options": [
        "Endüstriyel Yapı (Fabrika / Depo / Antrepo)",
        "Müstakil Ev / Villa / Prefabrik Konut",
        "Sundurma / Garaj / Açık Kamelya Çatısı"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Yalıtım Katmanları, Söküm ve Kenar Detay Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sandviç Panel (Poliüretan / Taş Yünü Dolgulu Endüstriyel Metal Panel)",
        "Şingıl Kaplama (Shingle - OSB Altyapılı Dekoratif ve Esnek Seri)",
        "Trapez Sac Uygulaması (Yalıtımsız Ekonomik Tek Kat Boyalı Sac)"
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