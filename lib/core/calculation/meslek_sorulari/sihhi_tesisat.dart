// lib/core/calculation/meslek_sorulari/sihhi_tesisat.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class SihhiTesisatSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Yapılacak Tesisat İşleminin Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Genel Tesisat Yenileme (Sıfırdan Komple Altyapı Kurulumu)",
        "Su Kaçağı Tespiti / Tıkanıklık Açma / Küçük Onarım Hizmeti"
      ]
    },

    // ========== GENEL TESİSAT YENİLEME YOLU ==========
    {
      "id": "boru_tipi",
      "label": "Tesisatta Kullanılacak Ana Boru Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Genel Tesisat Yenileme (Sıfırdan Komple Altyapı Kurulumu)"],
      "options": [
        "PPRC Standart Plastik Tesisat Borusu",
        "Cam Elyaf Takviyeli Kompozit Boru (Sıcak Su Hatlarında Uzamayı Önleyen İç Gövde)",
        "Sessiz Boru / Akustik Gider Hattı (Pis Su Şaft Seslerini Keserek Sessizlik Sağlayan Kalın Cıdarlı)"
      ]
    },
    {
      "id": "islak_hacim_sayisi",
      "label": "Yenilenecek Toplam Islak Hacim Sayısı (Banyo, WC, Mutfak vb.)",
      "type": "single",
      "required": true,
      "dependsOnId": "boru_tipi",
      "dependsOnValue": [
        "PPRC Standart Plastik Tesisat Borusu",
        "Cam Elyaf Takviyeli Kompozit Boru (Sıcak Su Hatlarında Uzamayı Önleyen İç Gövde)",
        "Sessiz Boru / Akustik Gider Hattı (Pis Su Şaft Seslerini Keserek Sessizlik Sağlayan Kalın Cıdarlı)"
      ],
      "options": [
        "1 Islak Hacim (Sadece Tek Banyo veya Sadece Mutfak)",
        "2 Islak Hacim (Banyo + Mutfak / Banyo + WC)",
        "3 Islak Hacim (Ebeveyn Banyosu + Ana Banyo + Mutfak)",
        "4+ Islak Hacim (Çoklu Islak Hacim Komple Altyapı Revizyonu)"
      ]
    },

    // ========== KAÇAK / ONARIM YOLU ==========
    {
      "id": "kacak_durumu",
      "label": "Arıza ve Kaçak Durumu Detayı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Su Kaçağı Tespiti / Tıkanıklık Açma / Küçük Onarım Hizmeti"],
      "options": [
        "Su Kaçağı Var (Yeri Bilinmiyor, Akustik Cihaz ve Termal Kamerayla Noktasal Tespit)",
        "Gider Tıkanıklığı Mevcut (Robot Kameralı Cihazla Açılması Gerekiyor)",
        "Onarım / Tamirat / Musluk-Batarya Montajı İstiyorum"
      ]
    },
    {
      "id": "hat_uzunlugu",
      "label": "Müdahale Edilecek Hat / Bölge Uzunluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "kacak_durumu",
      "dependsOnValue": [
        "Su Kaçağı Var (Yeri Bilinmiyor, Akustik Cihaz ve Termal Kamerayla Noktasal Tespit)",
        "Gider Tıkanıklığı Mevcut (Robot Kameralı Cihazla Açılması Gerekiyor)",
        "Onarım / Tamirat / Musluk-Batarya Montajı İstiyorum"
      ],
      "options": [
        "Lokal Müdahale (1-5 Metre Arası)",
        "Bölgesel Müdahale (5-15 Metre Arası)",
        "Kısmi Hat Yenileme (15-30 Metre Arası)"
      ]
    },

    // ========== ORTAK ZİNCİR - her iki yoldan sonra gelsin ==========
    // ADIM: ARMATÜR - Genel'de ıslak hacim sonrası, Kaçak'ta hat uzunluğu sonrası gelsin
    {
      "id": "armatur_sayisi",
      "label": "Montajı/Değişimi Yapılacak Toplam Armatür / Batarya / Musluk Adedi",
      "type": "single",
      "required": true,
      "dependsOnId": ["islak_hacim_sayisi", "hat_uzunlugu"],
      "dependsOnValue": [
        "1 Islak Hacim (Sadece Tek Banyo veya Sadece Mutfak)",
        "2 Islak Hacim (Banyo + Mutfak / Banyo + WC)",
        "3 Islak Hacim (Ebeveyn Banyosu + Ana Banyo + Mutfak)",
        "4+ Islak Hacim (Çoklu Islak Hacim Komple Altyapı Revizyonu)",
        "Lokal Müdahale (1-5 Metre Arası)",
        "Bölgesel Müdahale (5-15 Metre Arası)",
        "Kısmi Hat Yenileme (15-30 Metre Arası)"
      ],
      "options": [
        "Armatür/Musluk Montajı İstenmiyor",
        "1 - 3 Adet Arası Batarya/Musluk Değişimi",
        "4 - 6 Adet Arası Batarya/Musluk Değişimi",
        "7 - 10 Adet Arası Batarya/Musluk Değişimi",
        "10+ Adet Üzeri Yoğun Armatür Montajı"
      ]
    },

    // ADIM: YAPI TİP - armatür sonrası gelsin
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Yapı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "armatur_sayisi",
      "dependsOnValue": [
        "Armatür/Musluk Montajı İstenmiyor",
        "1 - 3 Adet Arası Batarya/Musluk Değişimi",
        "4 - 6 Adet Arası Batarya/Musluk Değişimi",
        "7 - 10 Adet Arası Batarya/Musluk Değişimi",
        "10+ Adet Üzeri Yoğun Armatür Montajı"
      ],
      "options": ["Daire", "Villa / Müstakil Ev", "İşyeri / Ofis / Ticari Alan"]
    },

    // ADIM: TESİSAT KONUMU - yapı tipi sonrası gelsin
    {
      "id": "tesisat_konumu",
      "label": "Mevcut Tesisat Konum Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "dependsOnValue": ["Daire", "Villa / Müstakil Ev", "İşyeri / Ofis / Ticari Alan"],
      "options": ["Duvar İçi Gizli Tesisat", "Zemin Altı Tesisat", "Açıkta Geçen Sıva Üstü Tesisat"]
    },

    // ADIM FİNAL: EKSTRA - sadece Genel Yenileme'de ve konum sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Duvar Kırım İşçilikleri, Kollektör ve Kaçak Test Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "tesisat_konumu",
      "visibleIf": {"is_kapsami": "Genel Tesisat Yenileme (Sıfırdan Komple Altyapı Kurulumu)"},
      "dependsOnValue": ["Duvar İçi Gizli Tesisat", "Zemin Altı Tesisat", "Açıkta Geçen Sıva Üstü Tesisat"],
      "options": [
        "Eski Tesisat Sökümü / Duvar Kırımı ve Moloz İşçiliği",
        "Gömme Rezervuar Altyapı Montajı (Duvar İçi Gizli Sarnıç Kurulumu)",
        "Kollektörlü (Mobil) Sistem Kutusu Kurulumu (Merkezi Kombi/Su Dağıtım Paneli)",
        "Basınçlı Kaçak and Sızdırmazlık Testi (Kompresör Pompası İle Boru Basınç Kontrolü)"
      ]
    }
  ];
}