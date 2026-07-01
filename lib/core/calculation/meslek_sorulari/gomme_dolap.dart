// lib/core/calculation/meslek_sorulari/ray_dolap.dart

class RayDolapSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "islem_kapsami", // 🛠️ EN ANA TETİKLEYİCİ (İlk açılışta SADECE bu soru görünür)
      "label": "Talep Edilen Hizmet Türü Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
        "Sadece Kapak Yenileme (Mevcut Dolaba Yeni Sürgülü/Ray Kapak Sistemi)",
        "İç Raf Düzenleme / Tadilat (Gövde İçi Raf ve Bölme Ekleme)"
      ]
    },

    // ==========================================
    // 🪵 GRUP 1: GÖVDE VE İSKELET SORULARI (Tadilat veya Sıfırdan İmalatta Açılır)
    // ==========================================
    {
      "id": "govde_malzemesi",
      "label": "Gövde ve Raf İskelet Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
        "İç Raf Düzenleme / Tadilat (Gövde İçi Raf ve Bölme Ekleme)"
      ],
      "options": [
        "Suntalam (Standart Ekonomik Gövde ve Raf İçeriği)",
        "MDF Lam (Dayanıklı ve Yüksek Yoğunluklu 1. Kalite Uzun Ömürlü Panel)",
        "Masif Ahşap Kaplama (Doğal Kereste Üzeri Özel Laka İşçilikli Lüks Seri)"
      ]
    },

    // ==========================================
    // 🎨 GRUP 2: KAPAK VE YÜZEY SORULARI (Kapak veya Sıfırdan İmalatta Açılır)
    // ==========================================
    {
      "id": "kapak_modeli",
      "label": "Kapak Teknolojisi ve Yüzey Tasarımı",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
        "Sadece Kapak Yenileme (Mevcut Dolaba Yeni Sürgülü/Ray Kapak Sistemi)"
      ],
      "options": [
        "Düz / Suntalam Kapak (Modern Ekonomik Hatlar)",
        "Akrilik Panel Kapak (Yüksek Parlaklıkta Parlak/Mat Çizilmez Yüzey)",
        "Membran / Balon Pres Kapak (PVC Vakum Pres Esnek Kaplama)",
        "Lake Boya Kapak (MDF Üzeri CNC Desen İşlemeli Poliüretan Boyalı Lüks Seri)"
      ]
    },

    // ==========================================
    // 📐 ÖLÇÜ PARAMETRELERİ (Klavye Girişi Tamamen Kaldırıldı, Tek Ölçü Kaynağı)
    // ==========================================
    {
      "id": "alan_segmenti",
      "label": "Dolap Ölçüsü ve Alan Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
        "Sadece Kapak Yenileme (Mevcut Dolaba Yeni Sürgülü/Ray Kapak Sistemi)",
        "İç Raf Düzenleme / Tadilat (Gövde İçi Raf ve Bölme Ekleme)"
      ],
      "options": [
        "0 - 4 m² Arası Standart Küçük Boy Dolap",
        "4 - 8 m² Arası Orta Boy Odalar İçin İdeal Düzen",
        "8 - 12 m² Arası Geniş Boy Giyinme Odası Blokları",
        "12 m² ve Üzeri Duvarı Komple Kaplayan Büyük Sistemler"
      ]
    },

    // ==========================================
    // ⚙️ MEKANİZMA VE DONANIM PARAMETRELERİ
    // ==========================================
    {
      "id": "ray_mekanizmasi",
      "label": "Ray Mekanizması ve Kapak Açılış Akıllı Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
        "Sadece Kapak Yenileme (Mevcut Dolaba Yeni Sürgülü/Ray Kapak Sistemi)"
      ],
      "options": [
        "Standart Ray Sistemi (Manuel Açılış Alttan Makaralı)",
        "Menteşeli Frenli Stoplu Kapak Grubu",
        "Lüks Üstten Askılı Frenli Ray Sistemi (Gizli Yavaşlatıcılı Sessiz Stop Mekanizması)"
      ]
    },
    {
      "id": "yukseklik_tip",
      "label": "Dolap Yükseklik ve Tavan Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
        "Sadece Kapak Yenileme (Mevcut Dolaba Yeni Sürgülü/Ray Kapak Sistemi)",
        "İç Raf Düzenleme / Tadilat (Gövde İçi Raf ve Bölme Ekleme)"
      ],
      "options": [
        "Tavana Kadar Tam Boy (Sıfır Boşluklu Pervaz Entegreli)",
        "Standart Ölçü (210 - 230 cm Arası Üstü Açık)",
        "Özel Ölçü / Alçak Tavan (Kiriş / Çatı Katı Eğim Kesimli İşçilik)"
      ]
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)",
        "Sadece Kapak Yenileme (Mevcut Dolaba Yeni Sürgülü/Ray Kapak Sistemi)",
        "İç Raf Düzenleme / Tadilat (Gövde İçi Raf ve Bölme Ekleme)"
      ],
      "options": [
        "Yatak Odası",
        "Giyinme Odası",
        "Antre / Koridor",
        "Çocuk / Genç Odası",
        "Ofis / Arşiv Odası"
      ]
    },
    {
      "id": "ekstra_donanim", // 🛠️ Reklamsız ve tam jenerik premium ekstralar
      "label": "Dolap İçi Fonksiyonel Donanım ve Aksesuar Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "islem_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat Navlun ve Montaj Dahil (Komple Ray Dolap Yapımı)"
      ],
      "options": [
        "LED Aydınlatma Sistemi (Sensörlü, Alüminyum Kanallı Dolap İçi Profil Işık Paketi)",
        "Ayna veya Cam Kapak Entegrasyonu (Reflekte Cam / Flotal Füme Ayna İşçilik Farkı)",
        "Pantolonluk veya Asansör Askı Sistemi Entegrasyonu (Fonksiyonel Çekme Aparatları)",
        "Ekstra Derin Ölçü Tasarımı (70 - 80 cm Özel Ölçü İmalat Malzeme Firesi Çarpanı)",
        "Çekmece Modülü Ünitesi İlavesi (Dolap İçi Ekstra 3'lü Frenli Ray Çekmece Kutusu)"
      ]
    }
  ];
}