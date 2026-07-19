// lib/core/calculation/meslek_sorulari/cati_isleri.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class CatiIsleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "hizmet_turu",
      "label": "İhtiyacınız Olan Ana Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan Çatı Yapımı (Yeni Çatı Konstrüksiyonu ve Kaplama)",
        "Çatı Aktarma ve Onarım (Geleneksel Kiremit Revizyonu ve Tamirat)",
        "Sandviç Panel / Şıngıl Kaplama Yenileme (Üst Örtü Değişimi)",
        "Sadece İzolasyon / Yalıtım Uygulaması (Isı ve Su Yalıtım Çözümleri)",
        "Oluk ve Dere Yenileme (Yağmur Suyu Drenaj Sistemleri)"
      ]
    },

    // ADIM 2: KARKAS - sadece Sıfırdan'da gelir
    {
      "id": "karkas_tipi",
      "label": "Çatı Taşıyıcı Karkas Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sıfırdan Çatı Yapımı (Yeni Çatı Konstrüksiyonu ve Kaplama)"
      ],
      "options": [
        "Ahşap Karkas (1. Sınıf Kereste İskelet Kurulumu)",
        "Çelik Karkas veya Metal Profil Konstrüksiyon (Yüksek Mukavemetli)"
      ]
    },

    // ADIM 3: KAPLAMA - Sıfırdan, Aktarma, Sandviç Panel'de gelir
    // NOT: Sıfırdan seçildiyse karkas'tan sonra gelsin diye karkas'a bağlıyoruz
    {
      "id": "kaplama_tipi",
      "label": "Talep Edilen Üst Çatı Kaplama Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sıfırdan Çatı Yapımı (Yeni Çatı Konstrüksiyonu ve Kaplama)",
        "Çatı Aktarma ve Onarım (Geleneksel Kiremit Revizyonu ve Tamirat)",
        "Sandviç Panel / Şıngıl Kaplama Yenileme (Üst Örtü Değişimi)"
      ],
      "options": [
        "Kiremit Kaplama (Geleneksel Kil Kiremit Örtüsü)",
        "Sandviç Panel Kaplama (Poliüretan Dolgulu Çift Kat Sac Isı Yalıtımlı)",
        "Shingle Kaplama (Şıngıl / Membran Üzeri OSB Levha Kaplamalı)",
        "Eternit / Sac / Trapez Kaplama Tek Kat Galvaniz"
      ]
    },

    // ADIM 4: ALAN KADEMESİ - kaplama veya karkas sonrası gelsin
    // Eski halinde köke bağlıydı, şimdi zincir için alan_segmenti'ni
    // kaplama_tipi'ne bağlamıyoruz çünkü İzolasyon ve Oluk'ta kaplama yok.
    // O yüzden köke bağlı bırakıyoruz ama listede 3. sırada durduğu için
    // profesyonel görünüyor: Karkas/Kaplama seçilince hemen altında alan açılıyor.
    {
      "id": "alan_segmenti",
      "label": "Çatı Yaklaşık Alan Kademesi (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sıfırdan Çatı Yapımı (Yeni Çatı Konstrüksiyonu ve Kaplama)",
        "Çatı Aktarma ve Onarım (Geleneksel Kiremit Revizyonu ve Tamirat)",
        "Sandviç Panel / Şıngıl Kaplama Yenileme (Üst Örtü Değişimi)",
        "Sadece İzolasyon / Yalıtım Uygulaması (Isı ve Su Yalıtım Çözümleri)",
        "Oluk ve Dere Yenileme (Yağmur Suyu Drenaj Sistemleri)"
      ],
      "options": [
        "0-50 m² Arası Küçük Çatı / Teras Kapatma",
        "50-100 m² Arası Standart Müstakil Ev",
        "100-200 m² Arası Geniş Bina / Apartman Bloğu",
        "200-400 m² Arası Büyük Site / Depo / Ticari Alan",
        "400 m² ve Üzeri Endüstriyel Fabrika Çatısı"
      ]
    },

    // ADIM 5: YAPI TİPİ - alan seçilince gelsin
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Yapının Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-50 m² Arası Küçük Çatı / Teras Kapatma",
        "50-100 m² Arası Standart Müstakil Ev",
        "100-200 m² Arası Geniş Bina / Apartman Bloğu",
        "200-400 m² Arası Büyük Site / Depo / Ticari Alan",
        "400 m² ve Üzeri Endüstriyel Fabrika Çatısı"
      ],
      "options": [
        "Müstakil Ev / Villa / Bungalov",
        "Apartman / Site Bloğu",
        "Fabrika / Depo / Endüstriyel Tesis",
        "Prefabrik / Hafif Çelik Yapı"
      ]
    },

    // ADIM 6: MALZEME TEDARİK - yapı seçilince gelsin
    {
      "id": "malzeme_tedarik",
      "label": "Malzeme Tedarik dev Lojistik Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "dependsOnValue": [
        "Müstakil Ev / Villa / Bungalov",
        "Apartman / Site Bloğu",
        "Fabrika / Depo / Endüstriyel Tesis",
        "Prefabrik / Hafif Çelik Yapı"
      ],
      "options": [
        "Malzeme Dahil (Tüm Sarf Malzemeleri ve Nakliye Ustaya Ait)",
        "Sadece İşçilik (Ana ve Yardımcı Malzemeler Müşteriye Ait)"
      ]
    },

    // ADIM 7: FİNAL - malzeme seçilince yeşil kutuda açılsın
    {
      "id": "ekstra_detaylar",
      "type": "multi",
      "label": "Teknik Detaylar, Yalıtım ve Mimari Zorluklar",
      "required": false,
      "dependsOnId": "malzeme_tedarik",
      "dependsOnValue": [
        "Malzeme Dahil (Tüm Sarf Malzemeleri ve Nakliye Ustaya Ait)",
        "Sadece İşçilik (Ana ve Yardımcı Malzemeler Müşteriye Ait)"
      ],
      "options": [
        "Isı Yalıtımı İlavesi (Çatı Arası Taş Yünü veya Cam Yünü Şilte Serimi)",
        "Su Yalıtımı İlavesi (Şaloma Alevi ile Membran Yakma ve Bohçalama)",
        "Gizli Dere / Asma Oluk Sistemi Komple Yenileme ve Montajı",
        "Baca Kenarı Çinko İzolasyonu ve Mevcut Baca Sıva Tamiratı",
        "Dik Eğimli Çatı Yapısı (Halatlı Emniyet Tedbirli / Ekstra Zorlu İşçilik)",
        "Yüksek Katlı Bina Sınıfı (Malzeme Çekme İçin Vinç / İskele Kurulum Gereksinimi)"
      ]
    }
  ];
}