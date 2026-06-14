// lib/core/calculation/meslek_sorulari/otomatik_sulama.dart

class OtomatikSulamaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ KİLİT TETİKLEYİCİ: Standart mimariye eşitlendi (sistem_tipi -> is_kapsami)
      "label": "Ana Sulama Altyapı ve Sistem Teknolojisi",
      "type": "single",
      "required": true,
      "options": [
        "Pop-up Sprinkler (Çim Alan İçin Toprak Altı Gömülü Borulama ve Hat Kazısı Hizmeti)",
        "Temel Damla Sulama (Ağaç, Bitki Grupları ve Çalı Çit Hatları İçin Yüzey Borulaması)",
        "Mikro Sprinkler / Sisleme Sistemi (Sera, Dikey Tarım ve Özel Kış Bahçeleri İçin)"
      ]
    },

    // ==========================================
    // 💧 GRUP 1: HİDROLİK KAYNAK VE BASINÇ DETAYLARI (Sadece Pop-up Sprinkler Seçilirse Açılır)
    // ==========================================
    {
      "id": "su_kaynagi", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue mimarisine geçirildi, kelimeler temizlendi
      "label": "Sistemin Besleneceği Su Kaynağı Altyapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Pop-up Sprinkler (Çim Alan İçin Toprak Altı Gömülü Borulama ve Hat Kazısı Hizmeti)"
      ],
      "options": [
        "Şebeke Hattı (Yeterli Statik Basınç ve Dinamik Debi Mevcut)",
        "Kuyu Suyu / Artezyen Hattı (Sabit Basınç Sağlayan Pompa Seti Entegrasyonlu)",
        "Depo / Tank Bağlantılı Altyapı (Cazibeli Akış / Pompa Destekli)",
        "Su Basıncı Düşük Şebeke Hattı (Sistem İçin İlave Hidrofor Takviyesi Gereken Alanlar)"
      ]
    },

    // ==========================================
    // 🧠 GRUP 2: OTOMASYON VE KONTROL SİSTEMLERİ
    // ==========================================
    {
      "id": "kontrol_unitesi", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, ana seçim yapılmadan görünmez
      "label": "Sulama Otomasyonu ve Kontrol Ünitesi Zekası",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Pop-up Sprinkler (Çim Alan İçin Toprak Altı Gömülü Borulama ve Hat Kazısı Hizmeti)",
        "Temel Damla Sulama (Ağaç, Bitki Grupları ve Çalı Çit Hatları İçin Yüzey Borulaması)",
        "Mikro Sprinkler / Sisleme Sistemi (Sera, Dikey Tarım ve Özel Kış Bahçeleri İçin)"
      ],
      "options": [
        "Standart Dijital Panel (İç/Dış Mekan Zamanlayıcılı Programlanabilir Otomatik Saat)",
        "Wi-Fi ve Mobil Bağlantılı Akıllı Kontrol (Uzaktan Debi Takibi, Tahminli Sulama ve Yönetim Uygulamalı)",
        "Hava İstasyonlu Profesyonel Panel (Anlık Evapotranspirasyon Hava Verisiyle Çalışan Otomasyon)"
      ]
    },

    // ==========================================
    // 📐 ÖLÇÜ, TOPOGRAFYA VE COĞRAFİ ŞARTLAR
    // ==========================================
    {
      "id": "alan_m2", // 🛠️ SEÇMELİ SEKME: Text kaldırıldı, aralık getirildi, ana seçime bağlandı
      "label": "Sulama Yapılacak Toplam Alan Kademesi (Net m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Pop-up Sprinkler (Çim Alan İçin Toprak Altı Gömülü Borulama ve Hat Kazısı Hizmeti)",
        "Temel Damla Sulama (Ağaç, Bitki Grupları ve Çalı Çit Hatları İçin Yüzey Borulaması)",
        "Mikro Sprinkler / Sisleme Sistemi (Sera, Dikey Tarım ve Özel Kış Bahçeleri İçin)"
      ],
      "options": [
        "0 - 100 m² Arası (Küçük Ölçekli Bahçe / Lokal Alan)",
        "101 - 300 m² Arası (Standart Villa / Müstakil Ev Bahçesi)",
        "301 - 600 m² Arası (Geniş Peyzaj / Ortak Site Alanı)",
        "601 - 1000 m² Arası (Büyük Ticari / Kamusal Park Alanı)",
        "1000 m² ve Üzeri (Geniş Tarım Arazisi / Endüstriyel Yeşil Alan)"
      ]
    },
    {
      "id": "arazi_yapisi", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, ana seçim yapılmadan görünmez
      "label": "Arazi Topografyası ve Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Pop-up Sprinkler (Çim Alan İçin Toprak Altı Gömülü Borulama ve Hat Kazısı Hizmeti)",
        "Temel Damla Sulama (Ağaç, Bitki Grupları ve Çalı Çit Hatları İçin Yüzey Borulaması)",
        "Mikro Sprinkler / Sisleme Sistemi (Sera, Dikey Tarım ve Özel Kış Bahçeleri İçin)"
      ],
      "options": [
        "Düz Zemin Yapısı (Standart Yumuşak Toprak / Kolay Kazı)",
        "Eğimli Arazi / Sert Kayalık Zemin Yapısı (Basınç Regülatörlü Hat ve Zorlu Kazı Mesaisi Gereken)"
      ]
    },
    {
      "id": "uygulama_yeri", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, ana seçim yapılmadan görünmez
      "label": "Sulama Yapılacak Alanın Mimari Yapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Pop-up Sprinkler (Çim Alan İçin Toprak Altı Gömülü Borulama ve Hat Kazısı Hizmeti)",
        "Temel Damla Sulama (Ağaç, Bitki Grupları ve Çalı Çit Hatları İçin Yüzey Borulaması)",
        "Mikro Sprinkler / Sisleme Sistemi (Sera, Dikey Tarım ve Özel Kış Bahçeleri İçin)"
      ],
      "options": [
        "Villa / Müstakil Ev Bahçesi",
        "Site Ortak Alanı / Kamu Parkı",
        "Tarım Arazisi / Ticari Meyve Bahçesi",
        "Sera / Kapalı Dikey Tarım Alanı",
        "Çatı / Teras Bahçesi (Özel Drenaj Uyumlu Altyapı)"
      ]
    },

    // ==========================================
    // ⚙️ SENSÖRLER VE TEKNİK EKSTRALAR HAVUZU
    // ==========================================
    {
      "id": "ekstra_ozellikler", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, ana seçim yapılmadan görünmez
      "label": "Teknik Sensörler, Zon Yönetimi ve Donanım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Pop-up Sprinkler (Çim Alan İçin Toprak Altı Gömülü Borulama ve Hat Kazısı Hizmeti)",
        "Temel Damla Sulama (Ağaç, Bitki Grupları ve Çalı Çit Hatları İçin Yüzey Borulaması)",
        "Mikro Sprinkler / Sisleme Sistemi (Sera, Dikey Tarım ve Özel Kış Bahçeleri İçin)"
      ],
      "options": [
        "Ekstra Selenoid Vana Montajı (Büyük Metrajlı Alanlarda Hat Ayrımı, Debi Dengesi ve Bölge Zon Yönetimi İçin)",
        "Yağmur / Toprak Nem Sensörü Entegrasyonu (Yağışlı Günlerde Gereksiz Sulamayı Otomatik Engelleyen Tasarım)",
        "Sert Zemin Kırımı ve Geçiş İşçiliği (Boru Hattı İçin Beton, Parke Taş Kaldırma ve Tekrar Geri Kapatma)",
        "Gübreleme Ünitesi Kurulumu (Sulama Ana Hattına Sıvı Gübre Karıştıran Venturi Dozajlama Sistemi)"
      ]
    }
  ];
}