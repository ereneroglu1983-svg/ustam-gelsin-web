// lib/core/calculation/meslek_sorulari/kapi_sistemleri.dart

class KapiSistemleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "kapi_tipi", // 🛠️ ANA TETİKLEYİCİ (Uygulama ilk açıldığında SADECE bu görünecek)
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

    // ==========================================
    // 🛡️ GRUP 1: ÇELİK DIŞ KAPI ÖZEL AKIŞI (Yalnızca Çelik Kapı Seçilirse Açılır)
    // ==========================================
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
    {
      "id": "celik_kapi_ekstralari",
      "label": "Çelik Kapı Güvenlik ve Otomasyon Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": ["Çelik Dış Kapı (Dış Mekan Giriş / 6 Noktadan Kilitli)"],
      "options": [
        "Akıllı Kilit Entegrasyonu (Parmak İzi / Kartlı Dijital Giriş Sistemi)",
        "Monoblok / Kancalı Güvenlik Sistemi Entegrasyonu (Çelik Kapı Üst Düzey Kilitleme)",
        "Söve / Pervaz Genişletme Takımı (Kalın Duvarlar İçin İlave Ahşap Pervaz)"
      ]
    },

    // ==========================================
    // 🚪 GRUP 2: İÇ ODA KAPILARI ÖZEL AKIŞI (İç Kapı Tiplerinden Biri Seçilirse Açılır)
    // ==========================================
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
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": [
        "Melamin Panel Kapı (Standart Oda Kapısı)",
        "CNC İşlemeli Akrilik Lake Kapı (Lüks Oda Serisi)",
        "Amerikan Pres Panel Kapı (Ekonomik Seri)"
      ],
      "options": [
        "Ayarlı Geçme Kasa (Duvar Kalınlığına Göre Esneyen Teleskopik Pervaz)",
        "Sabit Kasa Montajı",
        "Mevcut Eski Kasa Kullanılacak (Sadece Kanat Değişimi)",
        "Kasa Tipi Bilmiyorum (Usta Keşif Esnasında Ölçsün)"
      ]
    },
    {
      "id": "oda_kapi_ekstralari",
      "label": "İç Kapı Donanım ve Tasarım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": [
        "Melamin Panel Kapı (Standart Oda Kapısı)",
        "CNC İşlemeli Akrilik Lake Kapı (Lüks Oda Serisi)",
        "Amerikan Pres Panel Kapı (Ekonomik Seri)"
      ],
      "options": [
        "Camlı Model Geçişi (İç Kapılar İçin Temperli Cam, Çıta ve Kanal İşçiliği)",
        "Gizli Menteşe / Manyetik Kilit Kombinasyonu (Sessiz Konfor Mekanizma Paketi)",
        "Söve / Pervaz Genişletme Takımı (Kalın Duvarlar İçin İlave Ahşap Pervaz)"
      ]
    },

    // ==========================================
    // ⚙️ GLOBAL PARAMETRELER: KAPI TİPİ SEÇİLMEDEN ASLA EKRANA GELMEYECEK DÜZENLEME
    // ==========================================
    {
      "id": "kapi_adedi_secim", // 🛠️ DÜZELTİLDİ: Artık kapi_tipi seçilmeden ekranda belirmeyecek!
      "label": "İhtiyacınız Olan Net Kapı Adedi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": [
        "Melamin Panel Kapı (Standart Oda Kapısı)",
        "Çelik Dış Kapı (Dış Mekan Giriş / 6 Noktadan Kilitli)",
        "CNC İşlemeli Akrilik Lake Kapı (Lüks Oda Serisi)",
        "Amerikan Pres Panel Kapı (Ekonomik Seri)"
      ],
      "options": [
        "1 Adet (Tekil Değişim / Dış Kapı)",
        "2 - 4 Adet Arası (Küçük Daire / Kısmi Yenileme)",
        "5 - 7 Adet Arası (Standart 2+1 / 3+1 Daire Paketi)",
        "8 - 12 Adet Arası (Geniş Daire / Dubleks / Villa)",
        "12 Adet Üzeri (Çoklu Dağıtım / Toplu Proje)"
      ]
    },
    {
      "id": "renk_tercihi", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, başlangıçta gizli.
      "label": "Renk ve Ahşap Desen Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": [
        "Melamin Panel Kapı (Standart Oda Kapısı)",
        "Çelik Dış Kapı (Dış Mekan Giriş / 6 Noktadan Kilitli)",
        "CNC İşlemeli Akrilik Lake Kapı (Lüks Oda Serisi)",
        "Amerikan Pres Panel Kapı (Ekonomik Seri)"
      ],
      "options": [
        "Beyaz (Standart Akrilik / Lake)",
        "Antrasit Gri / Siyah Mat Ral Tonları",
        "Ceviz / Meşe / Doğal Ahşap Desen Kaplama",
        "Krem / Vizon Sıcak Soft Tonlar"
      ]
    },
    {
      "id": "montaj_durum", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, başlangıçta gizli.
      "label": "Mevcut Kapıların Demontaj Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_tipi",
      "dependsOnValue": [
        "Melamin Panel Kapı (Standart Oda Kapısı)",
        "Çelik Dış Kapı (Dış Mekan Giriş / 6 Noktadan Kilitli)",
        "CNC İşlemeli Akrilik Lake Kapı (Lüks Oda Serisi)",
        "Amerikan Pres Panel Kapı (Ekonomik Seri)"
      ],
      "options": [
        "Eski Kapılar Sökülecek (Demontaj ve Moloz Temizliği İşçiliği Dahil)",
        "Sıfır İnşaat / Boş Kasa Yuvası (Söküm Yok Doğrudan Montaj)"
      ]
    }
  ];
}