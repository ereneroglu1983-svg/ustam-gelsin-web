// lib/core/calculation/meslek_sorulari/cati_isleri.dart

class CatiIsleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "hizmet_turu", // 🛠️ ANA TETİKLEYİCİ: Formun kapısını açan ana kilit id
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
    {
      "id": "alan_segmenti", // 🛠️ DÜZELTİLDİ: Ana seçime bağlandı, klavyesiz tek ölçü kaynağı
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
    {
      "id": "yapi_tip", // 🛠️ DÜZELTİLDİ: Ana seçime bağlandı, seçim yapılmadan ekranda görünmez
      "label": "Uygulama Yapılacak Yapının Mimarisi",
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
        "Müstakil Ev / Villa / Bungalov",
        "Apartman / Site Bloğu",
        "Fabrika / Depo / Endüstriyel Tesis",
        "Prefabrik / Hafif Çelik Yapı"
      ]
    },
    {
      "id": "malzeme_tedarik", // 🛠️ DÜZELTİLDİ: Ana seçime bağlandı, lojistik kırılımı kilitler
      "label": "Malzeme Tedarik dev Lojistik Durumu",
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
        "Malzeme Dahil (Tüm Sarf Malzemeleri ve Nakliye Ustaya Ait)",
        "Sadece İşçilik (Ana ve Yardımcı Malzemeler Müşteriye Ait)"
      ]
    },
    {
      "id": "ekstra_detaylar", // 🛠️ DÜZELTİLDİ: Ana seçime bağlandı, çoklu seçmeli ekstralar
      "type": "multi",
      "label": "Teknik Detaylar, Yalıtım ve Mimari Zorluklar",
      "required": false,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sıfırdan Çatı Yapımı (Yeni Çatı Konstrüksiyonu ve Kaplama)",
        "Çatı Aktarma ve Onarım (Geleneksel Kiremit Revizyonu ve Tamirat)",
        "Sandviç Panel / Şıngıl Kaplama Yenileme (Üst Örtü Değişimi)",
        "Sadece İzolasyon / Yalıtım Uygulaması (Isı ve Su Yalıtım Çözümleri)",
        "Oluk ve Dere Yenileme (Yağmur Suyu Drenaj Sistemleri)"
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