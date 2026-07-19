// lib/core/calculation/meslek_sorulari/kapi_sistemleri.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class KapiSistemleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "kapi_tipi",
      "label": "Ana Kapı Teknolojisi ve Malzeme Tipi",
      "type": "single",
      "required": true,
      "options": [
        "Melamin Panel Kapı (Standart Oda Kapısı)",
        "Çelik Dış Kapı (Dış Mekan Giriş / 6 Noktadan Kilitli)",
        "CNC İşlemeli Akrilik Lake Kapı (Lüks Oda Serisi)",
        "Amerikan Pres Panel Kapı (Ekonomik Seri)"
      ]
    },

    // ========== ÇELİK DIŞ KAPI YOLU ==========
    {
      "id": "celik_kapi_yuzeyi",
      "label": "Çelik Kapı Gövde Mukavemeti ve Güvenlik Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": ["Çelik Dış Kapı (Dış Mekan Giriş / 6 Noktadan Kilitli)"],
      "options": [
        "Standart Muhafazalı Çelik Kapı Gövdesi",
        "Zırhlı Ağır Sac Gövde Teknolojisi (1.5 mm Esnemeyen Sac Gövde Farkı)",
        "Pivot Çelik Kapı Sistemi (Geniş Villa Girişleri İçin Özel Mafsallı)"
      ]
    },

    // ========== İÇ KAPI YOLU ==========
    {
      "id": "oda_kapi_yuzeyi",
      "label": "İç Kapı Yüzey Teknolojisi ve Koruma Katmanı",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": [
        "Melamin Panel Kapı (Standart Oda Kapısı)",
        "CNC İşlemeli Akrilik Lake Kapı (Lüks Oda Serisi)",
        "Amerikan Pres Panel Kapı (Ekonomik Seri)"
      ],
      "options": [
        "Standart Kaplama / Boya Yüzeyi",
        "Laminat / Çizilmez Yüksek Dayanımlı Yüzey Farkı (Evcil Hayvan / Çocuk Yoğun Evler İçin)"
      ]
    },
    {
      "id": "kasa_tipi",
      "label": "Kasa ve Pervaz Montaj Altyapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "oda_kapi_yuzeyi",
      "dependsOnValue": [
        "Standart Kaplama / Boya Yüzeyi",
        "Laminat / Çizilmez Yüksek Dayanımlı Yüzey Farkı (Evcil Hayvan / Çocuk Yoğun Evler İçin)"
      ],
      "options": [
        "Ayarlı Geçme Kasa (Duvar Kalınlığına Göre Esneyen Teleskopik Pervaz)",
        "Sabit Kasa Montajı",
        "Mevcut Eski Kasa Kullanılacak (Sadece Kanat Değişimi)",
        "Kasa Tipi Bilmiyorum (Usta Keşif Esnasında Ölçsün)"
      ]
    },

    // ========== ORTAK ZİNCİR - ADET - çelik yüzey sonrası veya iç kapıda kasa sonrası gelsin
    {
      "id": "kapi_adedi_secim",
      "label": "İhtiyacınız Olan Net Kapı Adedi",
      "type": "single",
      "required": true,
      "dependsOnId": ["celik_kapi_yuzeyi", "kasa_tipi"],
      "dependsOnValue": [
        "Standart Muhafazalı Çelik Kapı Gövdesi",
        "Zırhlı Ağır Sac Gövde Teknolojisi (1.5 mm Esnemeyen Sac Gövde Farkı)",
        "Pivot Çelik Kapı Sistemi (Geniş Villa Girişleri İçin Özel Mafsallı)",
        "Ayarlı Geçme Kasa (Duvar Kalınlığına Göre Esneyen Teleskopik Pervaz)",
        "Sabit Kasa Montajı",
        "Mevcut Eski Kasa Kullanılacak (Sadece Kanat Değişimi)",
        "Kasa Tipi Bilmiyorum (Usta Keşif Esnasında Ölçsün)"
      ],
      "options": [
        "1 Adet (Tekil Değişim / Dış Kapı)",
        "2 - 4 Adet Arası (Küçük Daire / Kısmi Yenileme)",
        "5 - 7 Adet Arası (Standart 2+1 / 3+1 Daire Paketi)",
        "8 - 12 Adet Arası (Geniş Daire / Dubleks / Villa)",
        "12 Adet Üzeri (Çoklu Dağıtım / Toplu Proje)"
      ]
    },

    // ADIM: RENK - adet sonrası gelsin
    {
      "id": "renk_tercihi",
      "label": "Renk ve Ahşap Desen Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_adedi_secim",
      "dependsOnValue": [
        "1 Adet (Tekil Değişim / Dış Kapı)",
        "2 - 4 Adet Arası (Küçük Daire / Kısmi Yenileme)",
        "5 - 7 Adet Arası (Standart 2+1 / 3+1 Daire Paketi)",
        "8 - 12 Adet Arası (Geniş Daire / Dubleks / Villa)",
        "12 Adet Üzeri (Çoklu Dağıtım / Toplu Proje)"
      ],
      "options": [
        "Beyaz (Standart Akrilik / Lake)",
        "Antrasit Gri / Siyah Mat Ral Tonları",
        "Ceviz / Meşe / Doğal Ahşap Desen Kaplama",
        "Krem / Vizon Sıcak Soft Tonlar"
      ]
    },

    // ADIM: MONTAJ - renk sonrası gelsin
    {
      "id": "montaj_durum",
      "label": "Mevcut Kapıların Demontaj Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "renk_tercihi",
      "dependsOnValue": [
        "Beyaz (Standart Akrilik / Lake)",
        "Antrasit Gri / Siyah Mat Ral Tonları",
        "Ceviz / Meşe / Doğal Ahşap Desen Kaplama",
        "Krem / Vizon Sıcak Soft Tonlar"
      ],
      "options": [
        "Eski Kapılar Sökülecek (Demontaj ve Moloz Temizliği İşçiliği Dahil)",
        "Sıfır İnşaat / Boş Kasa Yuvası (Söküm Yok Doğrudan Montaj)"
      ]
    },

    // ADIM FİNAL - ÇELİK EKSTRA - sadece Çelik'te ve montaj sonrası yeşil kutuda
    {
      "id": "celik_kapi_ekstralari",
      "label": "Çelik Kapı Güvenlik ve Otomasyon Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "montaj_durum",
      "visibleIf": {"kapi_tipi": "Çelik Dış Kapı (Dış Mekan Giriş / 6 Noktadan Kilitli)"},
      "dependsOnValue": [
        "Eski Kapılar Sökülecek (Demontaj ve Moloz Temizliği İşçiliği Dahil)",
        "Sıfır İnşaat / Boş Kasa Yuvası (Söküm Yok Doğrudan Montaj)"
      ],
      "options": [
        "Akıllı Kilit Entegrasyonu (Parmak İzi / Kartlı Dijital Giriş Sistemi)",
        "Monoblok / Kancalı Güvenlik Sistemi Entegrasyonu (Çelik Kapı Üst Düzey Kilitleme)",
        "Söve / Pervaz Genişletme Takımı (Kalın Duvarlar İçin İlave Ahşap Pervaz)"
      ]
    },

    // ADIM FİNAL - İÇ KAPI EKSTRA - sadece iç kapılarda ve montaj sonrası yeşil kutuda
    {
      "id": "oda_kapi_ekstralari",
      "label": "İç Kapı Donanım ve Tasarım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "montaj_durum",
      "visibleIf": {
        "kapi_tipi": [
          "Melamin Panel Kapı (Standart Oda Kapısı)",
          "CNC İşlemeli Akrilik Lake Kapı (Lüks Oda Serisi)",
          "Amerikan Pres Panel Kapı (Ekonomik Seri)"
        ]
      },
      "dependsOnValue": [
        "Eski Kapılar Sökülecek (Demontaj ve Moloz Temizliği İşçiliği Dahil)",
        "Sıfır İnşaat / Boş Kasa Yuvası (Söküm Yok Doğrudan Montaj)"
      ],
      "options": [
        "Camlı Model Geçişi (İç Kapılar İçin Temperli Cam, Çıta ve Kanal İşçiliği)",
        "Gizli Menteşe / Manyetik Kilit Kombinasyonu (Sessiz Konfor Mekanizma Paketi)",
        "Söve / Pervaz Genişletme Takımı (Kalın Duvarlar İçin İlave Ahşap Pervaz)"
      ]
    }
  ];
}