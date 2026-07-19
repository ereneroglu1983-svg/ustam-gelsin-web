// lib/core/calculation/meslek_sorulari/otomatik_sulama.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class OtomatikSulamaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Ana Sulama Altyapı ve Sistem Teknolojisi",
      "type": "single",
      "required": true,
      "options": [
        "Pop-up Sprinkler (Çim Alan İçin Toprak Altı Gömülü Borulama ve Hat Kazısı Hizmeti)",
        "Temel Damla Sulama (Ağaç, Bitki Grupları ve Çalı Çit Hatları İçin Yüzey Borulaması)",
        "Mikro Sprinkler / Sisleme Sistemi (Sera, Dikey Tarım ve Özel Kış Bahçeleri İçin)"
      ]
    },

    // ADIM 2: SU KAYNAĞI - sadece Pop-up'da gelsin
    {
      "id": "su_kaynagi",
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

    // ADIM 3: KONTROL ÜNİTESİ - Pop-up'ta su kaynağı sonrası, diğerlerinde direkt kök sonrası gelsin
    {
      "id": "kontrol_unitesi",
      "label": "Sulama Otomasyonu ve Kontrol Ünitesi Zekası",
      "type": "single",
      "required": true,
      "dependsOnId": ["su_kaynagi", "is_kapsami"],
      "dependsOnValue": [
        "Şebeke Hattı (Yeterli Statik Basınç ve Dinamik Debi Mevcut)",
        "Kuyu Suyu / Artezyen Hattı (Sabit Basınç Sağlayan Pompa Seti Entegrasyonlu)",
        "Depo / Tank Bağlantılı Altyapı (Cazibeli Akış / Pompa Destekli)",
        "Su Basıncı Düşük Şebeke Hattı (Sistem İçin İlave Hidrofor Takviyesi Gereken Alanlar)",
        "Temel Damla Sulama (Ağaç, Bitki Grupları ve Çalı Çit Hatları İçin Yüzey Borulaması)",
        "Mikro Sprinkler / Sisleme Sistemi (Sera, Dikey Tarım ve Özel Kış Bahçeleri İçin)"
      ],
      "options": [
        "Standart Dijital Panel (İç/Dış Mekan Zamanlayıcılı Programlanabilir Otomatik Saat)",
        "Wi-Fi ve Mobil Bağlantılı Akıllı Kontrol (Uzaktan Debi Takibi, Tahminli Sulama ve Yönetim Uygulamalı)",
        "Hava İstasyonlu Profesyonel Panel (Anlık Evapotranspirasyon Hava Verisiyle Çalışan Otomasyon)"
      ]
    },

    // ADIM 4: ALAN - kontrol sonrası gelsin
    {
      "id": "alan_m2",
      "label": "Sulama Yapılacak Toplam Alan Kademesi (Net m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "kontrol_unitesi",
      "dependsOnValue": [
        "Standart Dijital Panel (İç/Dış Mekan Zamanlayıcılı Programlanabilir Otomatik Saat)",
        "Wi-Fi ve Mobil Bağlantılı Akıllı Kontrol (Uzaktan Debi Takibi, Tahminli Sulama ve Yönetim Uygulamalı)",
        "Hava İstasyonlu Profesyonel Panel (Anlık Evapotranspirasyon Hava Verisiyle Çalışan Otomasyon)"
      ],
      "options": [
        "0 - 100 m² Arası (Küçük Ölçekli Bahçe / Lokal Alan)",
        "101 - 300 m² Arası (Standart Villa / Müstakil Ev Bahçesi)",
        "301 - 600 m² Arası (Geniş Peyzaj / Ortak Site Alanı)",
        "601 - 1000 m² Arası (Büyük Ticari / Kamusal Park Alanı)",
        "1000 m² ve Üzeri (Geniş Tarım Arazisi / Endüstriyel Yeşil Alan)"
      ]
    },

    // ADIM 5: ARAZİ YAPISI - alan sonrası gelsin
    {
      "id": "arazi_yapisi",
      "label": "Arazi Topografyası ve Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_m2",
      "dependsOnValue": [
        "0 - 100 m² Arası (Küçük Ölçekli Bahçe / Lokal Alan)",
        "101 - 300 m² Arası (Standart Villa / Müstakil Ev Bahçesi)",
        "301 - 600 m² Arası (Geniş Peyzaj / Ortak Site Alanı)",
        "601 - 1000 m² Arası (Büyük Ticari / Kamusal Park Alanı)",
        "1000 m² ve Üzeri (Geniş Tarım Arazisi / Endüstriyel Yeşil Alan)"
      ],
      "options": [
        "Düz Zemin Yapısı (Standart Yumuşak Toprak / Kolay Kazı)",
        "Eğimli Arazi / Sert Kayalık Zemin Yapısı (Basınç Regülatörlü Hat ve Zorlu Kazı Mesaisi Gereken)"
      ]
    },

    // ADIM 6: UYGULAMA YERİ - arazi sonrası gelsin
    {
      "id": "uygulama_yeri",
      "label": "Sulama Yapılacak Alanın Mimari Yapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "arazi_yapisi",
      "dependsOnValue": [
        "Düz Zemin Yapısı (Standart Yumuşak Toprak / Kolay Kazı)",
        "Eğimli Arazi / Sert Kayalık Zemin Yapısı (Basınç Regülatörlü Hat ve Zorlu Kazı Mesaisi Gereken)"
      ],
      "options": [
        "Villa / Müstakil Ev Bahçesi",
        "Site Ortak Alanı / Kamu Parkı",
        "Tarım Arazisi / Ticari Meyve Bahçesi",
        "Sera / Kapalı Dikey Tarım Alanı",
        "Çatı / Teras Bahçesi (Özel Drenaj Uyumlu Altyapı)"
      ]
    },

    // ADIM 7: FİNAL - uygulama yeri sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Teknik Sensörler, Zon Yönetimi ve Donanım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "uygulama_yeri",
      "dependsOnValue": [
        "Villa / Müstakil Ev Bahçesi",
        "Site Ortak Alanı / Kamu Parkı",
        "Tarım Arazisi / Ticari Meyve Bahçesi",
        "Sera / Kapalı Dikey Tarım Alanı",
        "Çatı / Teras Bahçesi (Özel Drenaj Uyumlu Altyapı)"
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