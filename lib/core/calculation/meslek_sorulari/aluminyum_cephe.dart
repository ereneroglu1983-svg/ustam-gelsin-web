// lib/core/calculation/meslek_sorulari/aluminyum_cephe.dart

class AluminyumCepheSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "Yapılacak İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Giydirme Cephe Sistemleri (Silikon / Kapaklı Dış Cephe)",
        "Alüminyum Doğrama Kapı/Pencere (Korkuluk / Küpeşte ve Sürme Sistemler)",
        "Kompozit Panel Kaplama (Dış Cephe Levha Giydirme)",
        "Ofis Bölme Sistemleri (İç Mekan Alüminyum Modüler Bölme)"
      ]
    },
    {
      "id": "cephe_sistem_detayi",
      "label": "Giydirme Cephe Mimari Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Giydirme Cephe Sistemleri (Silikon / Kapaklı Dış Cephe)"
      ],
      "options": [
        "Strüktürel Silikon Cephe (Dışarıdan Tamamen Cam Görünümlü - Gizli Profilli)",
        "Kapaklı Giydirme Cephe (Dışarıdan Alüminyum Çizgisel Profiller Belirgin)",
        "Yarı Kapaklı / Badem Kapaklı Cephe Sistemi"
      ]
    },
    {
      "id": "dograma_profil_serisi",
      "label": "Alüminyum Profil Serisi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Alüminyum Doğrama Kapı/Pencere (Korkuluk / Küpeşte ve Sürme Sistemler)"
      ],
      "options": [
        "C60 Serisi (Isı Yalıtımsız - Vitrin, Rüzgarlık ve İç Mekan İçin İdeal)",
        "Aldoks Serisi (Ekonomik İnce Seri Doğrama)",
        "HBŞB Sürme Sistem (HebeSchiebe Ağır Kaldırmalı Isı Yalıtımlı Lüks Sürme)",
        "Usta Sahada İnceleyip Mimari Seriyi Önersin"
      ]
    },
    {
      "id": "alan_segmenti",
      "label": "Tahmini Toplam Uygulama / Metraj Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Giydirme Cephe Sistemleri (Silikon / Kapaklı Dış Cephe)",
        "Alüminyum Doğrama Kapı/Pencere (Korkuluk / Küpeşte ve Sürme Sistemler)",
        "Kompozit Panel Kaplama (Dış Cephe Levha Giydirme)",
        "Ofis Bölme Sistemleri (İç Mekan Alüminyum Modüler Bölme)"
      ],
      "options": [
        "0-10 m² / mt Arası Küçük Ölçek",
        "10-30 m² / mt Arası Orta Ölçek",
        "30-100 m² / mt Arası Geniş Cephe",
        "100-300 m² / mt Arası Büyük Proje",
        "300 m² ve Üzeri Endüstriyel / Kurumsal Proje"
      ]
    },
    {
      "id": "metre_kare",
      "label": "Net Metrekare veya Metretül Ölçüsü (Opsiyonel)",
      "type": "text",
      "keyboardType": "number",
      "hint": "Örn: 45",
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Giydirme Cephe Sistemleri (Silikon / Kapaklı Dış Cephe)",
        "Alüminyum Doğrama Kapı/Pencere (Korkuluk / Küpeşte ve Sürme Sistemler)",
        "Kompozit Panel Kaplama (Dış Cephe Levha Giydirme)",
        "Ofis Bölme Sistemleri (İç Mekan Alüminyum Modüler Bölme)"
      ]
    },
    {
      "id": "profil_renk",
      "label": "Profil Renk ve Yüzey Bitiş Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Giydirme Cephe Sistemleri (Silikon / Kapaklı Dış Cephe)",
        "Alüminyum Doğrama Kapı/Pencere (Korkuluk / Küpeşte ve Sürme Sistemler)",
        "Kompozit Panel Kaplama (Dış Cephe Levha Giydirme)",
        "Ofis Bölme Sistemleri (İç Mekan Alüminyum Modüler Bölme)"
      ],
      "options": [
        "Eloksal Kaplama (Gümüş / Parlak Standart Korozyon Dirençli)",
        "Elektrostatik Toz Boya (Antrasit Gri / Siyah Mat Ral Kodu)",
        "Premium Eloksal (Bronz veya Altın Sarısı Özel Kimyasal İşlemli)",
        "Ahşap Desenli Özel Transfer Kaplama"
      ]
    },
    {
      "id": "zemin_montaj",
      "label": "Montaj Zemini ve Cephe Yükseklik Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Giydirme Cephe Sistemleri (Silikon / Kapaklı Dış Cephe)",
        "Alüminyum Doğrama Kapı/Pencere (Korkuluk / Küpeşte ve Sürme Sistemler)",
        "Kompozit Panel Kaplama (Dış Cephe Levha Giydirme)",
        "Ofis Bölme Sistemleri (İç Mekan Alüminyum Modüler Bölme)"
      ],
      "options": [
        "Beton Zemin (Standart Ankrajlı Kolay Montaj)",
        "Mermer / Granit Basamak Üzeri (Sulu Karot Delimli Hassas İşçilik)",
        "Yüksek Kat Dış Cephe (Güvenlikli İskele Kurulumu veya Vinç / Sepet Gerektiren)"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Ekstra Teknik Donanım ve Cam Katmanları",
      "type": "multi",
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Giydirme Cephe Sistemleri (Silikon / Kapaklı Dış Cephe)",
        "Alüminyum Doğrama Kapı/Pencere (Korkuluk / Küpeşte ve Sürme Sistemler)",
        "Kompozit Panel Kaplama (Dış Cephe Levha Giydirme)",
        "Ofis Bölme Sistemleri (İç Mekan Alüminyum Modüler Bölme)"
      ],
      "options": [
        "Isı Yalıtım Bariyeri ve Konfor EPDM Fitil Farkı",
        "Lamine Cam Güvenlik Katmanı Farkı (Kırılsa Da Dağılmayan Emniyet Camı)",
        "Akıllı Cam Entegrasyonu (PDLC Teknolojili Elektrik Kumandalı Kararan Cam)"
      ]
    }
  ];
}