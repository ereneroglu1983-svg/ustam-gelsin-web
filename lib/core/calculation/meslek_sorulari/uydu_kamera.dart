// lib/core/calculation/meslek_sorulari/uydu_kamera.dart

class UyduKameraSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_turu", // 🛠️ KİLİT TETİKLEYİCİ: IP Güvenlik kamerası, merkezi/bireysel uydu ve yapısal network kablolama akışlarını ve taban altyapı işçilik maliyetlerini jilet gibi ayıran ana id
      "label": "Yapılacak Ana İş Türü / Altyapı Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Güvenlik Kamerası Sistemi (IP Tabanlı NVR Altyapısı)",
        "Merkezi / Bireysel Uydu TV Sistemleri Kurulumu",
        "İnternet / Network Kablolu Hat Çekimi ve Rack Kabin Düzenleme"
      ]
    },

    // ==========================================
    // 📹 GRUP 1: GÜVENLİK KAMERASI TEKNOLOJİSİ (Sadece Güvenlik Kamerası Seçilirse Açılır)
    // ==========================================
    {
      "id": "kamera_detay", // 🛠️ DÜZELTİLDİ: dependsOnId ve dependsOnValue yapısına geçirildi.
      "label": "Kamera Mercek ve Çözünürlük Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Güvenlik Kamerası Sistemi (IP Tabanlı NVR Altyapısı)"],
      "options": [
        "Standart Full HD Çözünürlük (Kızılötesi Gece Görüşlü Sabit Lens)",
        "4K Ultra HD Yüksek Çözünürlük (Geniş Açı ve Dijital Zoom Destekli Premium Lens)",
        "AI Yapay Zeka Destekli Akıllı Akış (Yüz Tanıma ve Plaka Okuma Analitik Yazılımlı)",
        "Full Color Renkli Gece Görüşlü (Ses Kayıt ve Çift Yönlü Konuşma Özellikli)"
      ]
    },

    // ==========================================
    // 📡 GRUP 2: UYDU VE TELEVİZYON ALTYAPISI (Sadece Uydu TV Sistemleri Seçilirse Açılır)
    // ==========================================
    {
      "id": "uydu_altyapi_tipi", // 🛠️ DÜZELTİLDİ: dependsOnId ve dependsOnValue yapısına geçirildi.
      "label": "Uydu Altyapı ve Dağıtım Sistemi Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["Merkezi / Bireysel Uydu TV Sistemleri Kurulumu"],
      "options": [
        "Merkezi Santral Sistemi Kurulumu (Apartman Tipi Çoklu Dağıtım ve Multiswitch)",
        "Bireysel Çanak Anten Kurulumu (Balkon / Çatı Montajı ve Tekli LNB)",
        "Mevcut Uydu Hattı Sinyal Ayarı (Frekans Güncelleme ve İnce Sinyal Optimizasyonu)",
        "Komple Dağıtıcı Splitter, LNB ve Eskimiş Koaksiyel Kablo Değişimi"
      ]
    },

    // ==========================================
    // 💻 GRUP 3: YAPISAL NETWORK VE İNTERNET OMURGASI (Sadece İnternet / Network Seçilirse Açılır)
    // ==========================================
    {
      "id": "network_ekipman_detay", // 🛠️ DÜZELTİLDİ: dependsOnId ve dependsOnValue yapısına geçirildi.
      "label": "Talep Edilen Network Donanım ve Dağıtım Altyapısı",
      "type": "multi",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["İnternet / Network Kablolu Hat Çekimi ve Rack Kabin Düzenleme"],
      "options": [
        "Kablosuz Kapsama Alanı Genişletme (Access Point ve Kesintisiz Mesh Sistem Kurulumu)",
        "Sıfırdan Sistem Odası Kurulumu (Rack Kabin Montajı, Patch Panel ve Switch Sonlandırma)",
        "Kurumsal Ağ Yönetimi (Router Konfigürasyonu, VLAN Bölümlendirme ve Firewall Kurulumu)"
      ]
    },

    // ==========================================
    // 📐 ÖLÇÜ, MEKAN VE KABLOLAMA KOŞULLARI
    // ==========================================
    {
      "id": "mekan_tipi", // Daire, villa veya endüstriyel tava montajı gerektiren fabrika zorluk çarpanlarını tetikler
      "label": "Uygulama Yapılacak Mekan Yapısı ve Mimari Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": [
        "Güvenlik Kamerası Sistemi (IP Tabanlı NVR Altyapısı)",
        "Merkezi / Bireysel Uydu TV Sistemleri Kurulumu",
        "İnternet / Network Kablolu Hat Çekimi ve Rack Kabin Düzenleme"
      ],
      "options": [
        "Daire Standart İç Mekan (Asma Tavan / Süpürgelik Üstü Kolay Hat Çekimi)",
        "Villa / Müstakil Ev (Geniş Bahçe ve Çevre Duvarı Toprak Altı Borulama Zorluğu)",
        "Fabrika / Site / Depo (Galvaniz Sac Tava Montajı ve Yüksek İrtifa Geniş Omurga Mimari)"
      ]
    },
    {
      "id": "cihaz_adedi", // 🛠️ REVIZE EDİLDİ: Text tipinden bağımlı ve single seçmeli tipe dönüştürüldü
      "label": "Sisteme Dahil Edilecek Toplam Nokta Sayısı (Kamera / Uydu Uç / Data Hattı)",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": [
        "Güvenlik Kamerası Sistemi (IP Tabanlı NVR Altyapısı)",
        "Merkezi / Bireysel Uydu TV Sistemleri Kurulumu",
        "İnternet / Network Kablolu Hat Çekimi ve Rack Kabin Düzenleme"
      ],
      "options": [
        "1 - 4 Arası Nokta / Hat Dağıtımı (Küçük Ölçekli)",
        "4 - 8 Arası Nokta / Hat Dağıtımı (Standart Konut / Ofis)",
        "8 - 16 Arası Nokta / Hat Dağıtımı (Geniş Yapı / Villa)",
        "16 - 32 Arası Nokta / Hat Dağıtımı (Büyük İşletme / Site / Fabrika)",
        "32 Nokta ve Üzeri / Komple Ağ Altyapısı (Endüstriyel Proje)"
      ]
    },
    {
      "id": "kablolama_tipi", // Füzyon ek işçiliği, fiber pigtail veya duvar kırma, spiral boru gömme maliyet modelini kilitler
      "label": "Kablolama Teknolojisi ve Hat Kanal Estetiği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": [
        "Güvenlik Kamerası Sistemi (IP Tabanlı NVR Altyapısı)",
        "Merkezi / Bireysel Uydu TV Sistemleri Kurulumu",
        "İnternet / Network Kablolu Hat Çekimi ve Rack Kabin Düzenleme"
      ],
      "options": [
        "UTP Kablolama (Cat6 / PoE Standart Bakır Network Kablo Döşeme ve Kanal İşçiliği)",
        "Fiber Optik Kablolama (Pigtail Sonlandırma ve Hassas Füzyon Ek Cihazı Mesaisi)",
        "Sıva Altı Kablolama / Kanal İçi Kırım (Duvar Kırma, Spiral Boru Geçişi ve Alçı Rütuş Payı)"
      ]
    },

    // ==========================================
    // ⚙️ TEKNİK DONANIM, LENS VE ERİŞİM EKSTRALARI
    // ==========================================
    {
      "id": "ekstra_ozellikler",
      "label": "Lens Teknolojisi, Yapay Zeka ve Erişim Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_turu",
      "dependsOnValue": [
        "Güvenlik Kamerası Sistemi (IP Tabanlı NVR Altyapısı)",
        "Merkezi / Bireysel Uydu TV Sistemleri Kurulumu",
        "İnternet / Network Kablolu Hat Çekimi ve Rack Kabin Düzenleme"
      ],
      "options": [
        "4K Ultra HD Ultra Yüksek Çözünürlüklü Kamera Farkı Entegrasyonu",
        "AI Yapay Zeka Sınıfı Akıllı Analitik Yazılım Sensörleri İlavesi",
        "PTZ (Motorize / Hareketli / Pan-Tilt-Zoom) Otomatik Nesne Takip Sistemi",
        "Yüksek İrtifa / Çatı Erişimi İçin Özel Platform ve Sepetli Vinç Kiralama Desteği",
        "Kesintisiz Güç Kaynağı (UPS) ve Koruyucu Akü Kiti Entegrasyonu"
      ]
    }
  ];
}