// lib/core/calculation/meslek_sorulari/temizlik_hizmetleri.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class TemizlikHizmetleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "hizmet_tipi",
      "label": "Temizlik Hizmeti Seçin",
      "type": "single",
      "required": true,
      "options": [
        "İnşaat Sonrası Temizlik",
        "Genel Ev ve Derin Temizlik",
        "Taşınma Öncesi/Sonrası Temizlik",
        "Cam ve Cephe Temizliği",
        "Mutfak ve Banyo Temizliği",
        "Merdiven ve Ortak Alan Temizliği",
        "Bahçe ve Dış Alan Temizliği",
        "Havuz Temizliği ve Bakımı"
      ]
    },

    // ==========================================
    // 🏗 İNŞAAT / GENEL EV / TAŞINMA YOLU - 4'lü patlama zincire bağlandı
    // ==========================================
    {
      "id": "m2",
      "label": "Alan Büyüklüğü (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_tipi",
      "dependsOnValue": ["İnşaat Sonrası Temizlik", "Genel Ev ve Derin Temizlik", "Taşınma Öncesi/Sonrası Temizlik"],
      "options": ["0-50 m²", "51-100 m²", "101-150 m²", "151-200 m²", "201-300 m²", "300+ m²"]
    },
    {
      "id": "tadilat_tipi",
      "label": "Tadilat Detayı",
      "type": "single",
      "dependsOnId": "m2",
      "dependsOnValue": ["0-50 m²", "51-100 m²", "101-150 m²", "151-200 m²", "201-300 m²", "300+ m²"],
      "options": ["Sadece Boya Temizliği", "Komple Tadilat Temizliği(Molozlu)", "Yeni İnşaat Temizliği", "Kısmi Tadilat Temizliği"]
    },
    {
      "id": "durum",
      "label": "Mevcut Durum",
      "type": "multi",
      "dependsOnId": "tadilat_tipi",
      "dependsOnValue": ["Sadece Boya Temizliği", "Komple Tadilat Temizliği(Molozlu)", "Yeni İnşaat Temizliği", "Kısmi Tadilat Temizliği"],
      "options": ["İnşaat Malzemeleri Mevcut", "Sadece Toz/Alçı Artığı", "Eşyalı ve Yerleşimli"]
    },
    {
      "id": "ekipman",
      "label": "İhtiyaç Duyulan Ekipman",
      "type": "multi",
      "dependsOnId": "durum",
      "dependsOnValue": ["İnşaat Malzemeleri Mevcut", "Sadece Toz/Alçı Artığı", "Eşyalı ve Yerleşimli"],
      "options": ["Sanayi Tipi Süpürge", "Zemin Kazıma/Cila Makinesi", "Buharlı Temizlik Cihazı"]
    },

    // ==========================================
    // 🏢 CAM VE CEPHE YOLU - 3'lü patlama zincire bağlandı
    // ==========================================
    {
      "id": "yapi",
      "label": "Cephe Tipi",
      "type": "single",
      "dependsOnId": "hizmet_tipi",
      "dependsOnValue": ["Cam ve Cephe Temizliği"],
      "options": ["Cam Giydirme", "Kompozit / Alüminyum", "Taş / Mermer / Beton"]
    },
    {
      "id": "yukseklik",
      "label": "Erişim Detayı",
      "type": "single",
      "dependsOnId": "yapi",
      "dependsOnValue": ["Cam Giydirme", "Kompozit / Alüminyum", "Taş / Mermer / Beton"],
      "options": ["Zemin Kat", "1-3. Kat (Merdivenle)", "Yüksek Kat (Vinç/Platform Gerekli)", "Dağcı/İp ile Erişim"]
    },
    {
      "id": "kirlilik",
      "label": "Kirlilik Seviyesi",
      "type": "single",
      "dependsOnId": "yukseklik",
      "dependsOnValue": ["Zemin Kat", "1-3. Kat (Merdivenle)", "Yüksek Kat (Vinç/Platform Gerekli)", "Dağcı/İp ile Erişim"],
      "options": ["Hafif (Tozlu)", "Ağır (İnşaat Harcı/Boyası)", "Kireç/Dış Etken"]
    },

    // ==========================================
    // 🛁 MUTFAK VE BANYO YOLU - 2'li zincir
    // ==========================================
    {
      "id": "hacim",
      "label": "Bölüm Sayısı",
      "type": "single",
      "dependsOnId": "hizmet_tipi",
      "dependsOnValue": ["Mutfak ve Banyo Temizliği"],
      "options": ["Sadece Mutfak", "Sadece Banyo", "Mutfak + Banyo", "Komple Islak Hacimler"]
    },
    {
      "id": "dezenfeksiyon",
      "label": "Hijyen Gereksinimi",
      "type": "single",
      "dependsOnId": "hacim",
      "dependsOnValue": ["Sadece Mutfak", "Sadece Banyo", "Mutfak + Banyo", "Komple Islak Hacimler"],
      "options": ["Standart Temizlik", "Derin Hijyen / Dezenfeksiyon", "Kireç ve Derz Temizliği"]
    },

    // ==========================================
    // 🌳 BAHÇE / HAVUZ YOLU - 2'li zincir
    // ==========================================
    {
      "id": "alan_tipi",
      "label": "Alan/Hacim Ölçeği",
      "type": "single",
      "dependsOnId": "hizmet_tipi",
      "dependsOnValue": ["Bahçe ve Dış Alan Temizliği", "Havuz Temizliği ve Bakımı"],
      "options": ["Küçük (0-50m²/m³)", "Orta (50-150m²/m³)", "Büyük (150-300m²/m³)", "Çok Büyük (300+ m²/m³)"]
    },
    {
      "id": "kapsam",
      "label": "Uygulama Kapsamı",
      "type": "multi",
      "dependsOnId": "alan_tipi",
      "dependsOnValue": ["Küçük (0-50m²/m³)", "Orta (50-150m²/m³)", "Büyük (150-300m²/m³)", "Çok Büyük (300+ m²/m³)"],
      "options": ["Ot ve Yabani Bitki Temizliği", "Havuz Kimyasalları ve Bakımı", "İnşaat Atığı/Moloz Tahliyesi", "Dış Zemin Yıkama"]
    },

    // ==========================================
    // 🏢 MERDİVEN VE ORTAK ALAN YOLU - 3'lü patlama zincire bağlandı
    // ==========================================
    {
      "id": "kat",
      "label": "Kat Sayısı",
      "type": "single",
      "dependsOnId": "hizmet_tipi",
      "dependsOnValue": ["Merdiven ve Ortak Alan Temizliği"],
      "options": ["1-5 Kat", "6-10 Kat", "11-20 Kat", "20+ Kat"]
    },
    {
      "id": "periyot",
      "label": "Temizlik Sıklığı",
      "type": "single",
      "dependsOnId": "kat",
      "dependsOnValue": ["1-5 Kat", "6-10 Kat", "11-20 Kat", "20+ Kat"],
      "options": ["Tek Seferlik", "Haftalık", "15 Günde Bir", "Aylık Sabit"]
    },
    {
      "id": "alanlar",
      "label": "Kapsam",
      "type": "multi",
      "dependsOnId": "periyot",
      "dependsOnValue": ["Tek Seferlik", "Haftalık", "15 Günde Bir", "Aylık Sabit"],
      "options": ["Asansör İçleri", "Giriş Holü", "Dış Kapı Önü", "Kat Koridorları"]
    }
  ];
}