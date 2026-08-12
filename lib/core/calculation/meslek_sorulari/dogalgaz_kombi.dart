// lib/core/calculation/meslek_sorulari/dogalgaz_kombi.dart - FINAL
class DogalgazKombiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "uygulama_tipi",
      "label": "İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Sıfırdan Komple Tesisat Hat Kurulumu", "Sadece Kombi Montajı İlk Çalıştırma", "Yerden Isıtma Sistem Kurulumu", "Kombi Bakım Onarım Arıza"]
    },

    // 1) TESİSAT + KOMBİ MONTAJ DALI
    {
      "id": "daire_tipi",
      "label": "Yapı Planı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Sıfırdan Komple Tesisat Hat Kurulumu", "Sadece Kombi Montajı İlk Çalıştırma"],
      "options": ["1+1 Konut", "2+1 Konut", "3+1 Konut", "Villa Dubleks Geniş Yapı"]
    },
    {
      "id": "kombi_teknolojisi",
      "label": "Kombi Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "daire_tipi",
      "options": ["Tam Yoğuşmalı", "Yarı Yoğuşmalı", "Hermetik", "Kombi Hariç Sadece Altyapı"]
    },
    {
      "id": "petek_adedi",
      "label": "Petek Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "kombi_teknolojisi",
      "options": ["1-4 Adet", "5-7 Adet Standart", "8-10 Adet Yoğun", "11 Adet Üzeri"]
    },
    {
      "id": "tesisat_malzemesi",
      "label": "Tesisat Boru Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "petek_adedi",
      "options": ["PPRC Plastik Boru", "Çelik Boru Kaynaklı", "Bakır Boru", "Mobil Kılıflı Kollektörlü"]
    },
    {
      "id": "montaj_yeri",
      "label": "Kombi Montaj Yeri",
      "type": "single",
      "required": true,
      "dependsOnId": "tesisat_malzemesi",
      "options": ["Mutfak İçi", "Balkon Dolabı", "Kiler Hol Koridor", "Eski Kombi Yeri Değişim"]
    },
    {
      "id": "proje_durumu",
      "label": "Proje ve Onay Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_yeri",
      "options": ["Proje Çizimi Onay Dahil Olsun", "Proje Mevcut Onaylı", "Sadece Mekanik Montaj"]
    },

    // 2) YERDEN ISITMA DALI
    {
      "id": "yapi_tipi",
      "label": "Yapı Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Yerden Isıtma Sistem Kurulumu"],
      "options": ["Apartman Dairesi", "Villa Müstakil", "Ticari Ofis", "Geniş Alan İbadethane"]
    },
    {
      "id": "alan_m2",
      "label": "Isıtılacak Net Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tipi",
      "options": ["0-70 m² Küçük", "71-110 m² Standart", "111-150 m² Geniş", "151-250 m² Dubleks", "250 m² Üzeri Villa Ticari"]
    },
    {
      "id": "kat_durumu",
      "label": "Kat Lokasyonu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_m2",
      "options": ["Zemin Kat Isı Kayıplı", "Ara Kat", "Çatı Katı"]
    },
    {
      "id": "izolasyon_tipi",
      "label": "Zemin İzolasyon Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "kat_durumu",
      "options": ["Mantarlı Strafor Kanallı EPS", "Düz Folyo Kaplı Strafor", "İzolasyon Hariç Sadece Borulama"]
    },
    {
      "id": "sap_durumu",
      "label": "Şap Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "izolasyon_tipi",
      "options": ["Şap Atılmamış Ham Beton", "Mevcut Şap Var Kırım Gerekli"]
    },
    {
      "id": "isi_kaynagi",
      "label": "Ana Isı Kaynağı",
      "type": "single",
      "required": true,
      "dependsOnId": "sap_durumu",
      "options": ["Kombi Doğalgaz", "Isı Pompası", "Merkezi Sistem", "Elektrikli Kazan"]
    },

    // 3) BAKIM ARIZA DALI
    {
      "id": "bakim_ariza_detayi",
      "label": "Bakım Arıza Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": ["Kombi Bakım Onarım Arıza"],
      "options": ["Yıllık Periyodik Bakım Filtre Temizliği", "Sıcak Su Gelmiyor", "Hiç Çalışmıyor Ateşleme Yok", "Hata Kodu Su Eksiltiyor"]
    },

    // ORTAK EKSTRALAR
    {
      "id": "ekstra_ozellikler_tesisat",
      "label": "Ekstralar ve Donanım",
      "type": "multi",
      "required": true,
      "dependsOnId": "proje_durumu",
      "options": [
        "Radyatör Montaj Paketi",
        "Yoğuşma Gideri Pimaş Bağlantı",
        "Kablosuz Oda Termostatı",
        "Gaz Alarm Selenoid Vana",
        "Kollektör Vana Grubu Dolabı",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_yerden",
      "label": "Ekstralar ve Testler",
      "type": "multi",
      "required": true,
      "dependsOnId": "isi_kaynagi",
      "options": [
        "Kenar Yalıtım Bandı",
        "Koruma Sütü Mukavemet Sıvısı",
        "Basınçlı Kaçak Testi",
        "Oda Bazlı Akıllı Termostat",
        "Kollektör Dolabı",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_bakim",
      "label": "Ekstra İşlem",
      "type": "multi",
      "required": true,
      "dependsOnId": "bakim_ariza_detayi",
      "options": ["Petek Temizliği", "Filtre Değişimi", "Genleşme Tankı Kontrol", "Ekstra İstemiyorum"]
    }
  ];
}