// lib/core/calculation/meslek_sorulari/aluminyum_cephe.dart - FINAL
class AluminyumCepheSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "Yapılacak İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Giydirme Cephe Sistemleri",
        "Alüminyum Doğrama Kapı Pencere",
        "Kompozit Panel Kaplama",
        "Ofis Bölme Sistemleri"
      ]
    },

    // 1) GİYDİRME DALI
    {
      "id": "cephe_sistem_detayi",
      "label": "Giydirme Cephe Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Giydirme Cephe Sistemleri"],
      "options": [
        "Strüktürel Silikon Cephe",
        "Kapaklı Giydirme Cephe",
        "Yarı Kapaklı Badem Kapaklı Cephe"
      ]
    },
    {
      "id": "alan_segmenti_giydirme",
      "label": "Toplam Uygulama Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "cephe_sistem_detayi",
      "options": [
        "0-10 m² Küçük Ölçek",
        "10-30 m² Orta Ölçek",
        "30-100 m² Geniş Cephe",
        "100-300 m² Büyük Proje",
        "300 m² Üzeri Endüstriyel"
      ]
    },

    // 2) DOĞRAMA DALI
    {
      "id": "dograma_profil_serisi",
      "label": "Profil Serisi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Alüminyum Doğrama Kapı Pencere"],
      "options": ["C60 Isı Yalıtımsız Seri", "Aldoks Ekonomik Seri", "HBŞB Ağır Kaldırmalı Lüks Sürme", "Isı Yalıtımlı Standart Seri"]
    },
    {
      "id": "alan_segmenti_dograma",
      "label": "Toplam Metraj",
      "type": "single",
      "required": true,
      "dependsOnId": "dograma_profil_serisi",
      "options": ["0-10 mt Küçük", "10-30 mt Orta", "30-100 mt Geniş", "100 mt Üzeri Büyük"]
    },

    // 3) KOMPOZİT DALI
    {
      "id": "alan_segmenti_kompozit",
      "label": "Toplam Uygulama Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Kompozit Panel Kaplama"],
      "options": ["0-10 m²", "10-30 m²", "30-100 m²", "100-300 m²", "300 m² Üzeri"]
    },

    // 4) OFİS BÖLME DALI
    {
      "id": "alan_segmenti_ofis",
      "label": "Toplam Bölme Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Ofis Bölme Sistemleri"],
      "options": ["0-10 m²", "10-30 m²", "30-100 m²", "100 m² Üzeri"]
    },

    // ORTAK ZİNCİR - Renk ve Zemin
    {
      "id": "profil_renk",
      "label": "Profil Renk ve Yüzey",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti_giydirme",
      "dependsOnValue": ["0-10 m² Küçük Ölçek", "10-30 m² Orta Ölçek", "30-100 m² Geniş Cephe", "100-300 m² Büyük Proje", "300 m² Üzeri Endüstriyel"],
      "options": ["Eloksal Gümüş", "Elektrostatik Antrasit Gri", "Elektrostatik Siyah Mat", "Premium Eloksal Bronz", "Ahşap Desenli Transfer"]
    },
    {
      "id": "profil_renk_dograma",
      "label": "Profil Renk ve Yüzey",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti_dograma",
      "options": ["Eloksal Gümüş", "Antrasit Gri", "Siyah Mat", "Bronz", "Ahşap Desenli"]
    },
    {
      "id": "profil_renk_kompozit",
      "label": "Panel Renk",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti_kompozit",
      "options": ["Metal Gri", "Beyaz", "Siyah", "Ahşap Desenli", "Özel RAL Rengi"]
    },
    {
      "id": "profil_renk_ofis",
      "label": "Profil Renk",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti_ofis",
      "options": ["Eloksal Gümüş", "Siyah", "Beyaz", "Antrasit"]
    },

    {
      "id": "zemin_montaj_giydirme",
      "label": "Montaj Zemini ve Yükseklik",
      "type": "single",
      "required": true,
      "dependsOnId": "profil_renk",
      "options": ["Beton Zemin Standart", "Mermer Granit Karotlu", "Yüksek Kat İskele Vinç Gerekiyor"]
    },
    {
      "id": "zemin_montaj_dograma",
      "label": "Montaj Zemini",
      "type": "single",
      "required": true,
      "dependsOnId": "profil_renk_dograma",
      "options": ["Beton Zemin", "Mermer Granit", "Yüksek Kat İskele Gerekiyor"]
    },
    {
      "id": "zemin_montaj_kompozit",
      "label": "Montaj Zemini",
      "type": "single",
      "required": true,
      "dependsOnId": "profil_renk_kompozit",
      "options": ["Beton Zemin", "Çelik Konstrüksiyon", "Yüksek Kat İskele Gerekiyor"]
    },
    {
      "id": "zemin_montaj_ofis",
      "label": "Montaj Zemini",
      "type": "single",
      "required": true,
      "dependsOnId": "profil_renk_ofis",
      "options": ["Beton Zemin", "Yükseltilmiş Döşeme", "Halı Kaplı Zemin"]
    },

    {
      "id": "ekstra_ozellikler_giydirme",
      "label": "Ekstra Teknik Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "zemin_montaj_giydirme",
      "options": ["Isı Yalıtım Bariyeri", "Lamine Güvenlik Camı", "Akıllı Cam PDLC", "Ekstra Özellik İstemiyorum"]
    },
    {
      "id": "ekstra_ozellikler_dograma",
      "label": "Ekstra Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "zemin_montaj_dograma",
      "options": ["Isı Yalıtım Bariyeri", "Çift Cam Konfor", "Lamine Güvenlik Camı", "Sineklik Sistemi", "Ekstra İstemiyorum"]
    },
    {
      "id": "ekstra_kompozit",
      "label": "Ekstra İşlem",
      "type": "multi",
      "required": true,
      "dependsOnId": "zemin_montaj_kompozit",
      "options": ["Isı Yalıtım Levhası", "Su Yalıtım Membranı", "Yangın Bariyeri", "Ekstra İstemiyorum"]
    },
    {
      "id": "ekstra_ofis",
      "label": "Ekstra Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "zemin_montaj_ofis",
      "options": ["Çift Camlı Bölme", "Jaluzi Perde Sistemi", "Kapı Kilit Sistemi", "Akustik Yalıtım", "Ekstra İstemiyorum"]
    },
  ];
}