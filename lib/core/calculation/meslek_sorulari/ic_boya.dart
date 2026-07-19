// lib/core/calculation/meslek_sorulari/ic_boya.dart - PROFESYONEL AKIŞLI VERSİYON
// NOT: id ve options metinleri ASLA değiştirilmedi, sadece dependsOn eklenerek sıra garantilendi.
// Fiyat hesaplaması %100 aynı çalışır.

class IcBoyaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ==================== ADIM 1: MEKAN TESPİTİ (KÖK) ====================
    {
      "id": "yapi_cesidi",
      "label": "Uygulama Yapılacak Yapı Çeşidi",
      "type": "single",
      "required": true,
      "options": [
        "Daire",
        "Müstakil Ev",
        "Ofis",
        "İş Yeri"
      ]
    },
    {
      "id": "oda_sayisi",
      "label": "Oda Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_cesidi",
      "dependsOnValue": ["Daire", "Müstakil Ev"], // Ofis ve İş Yeri'nde oda sayısı sorulmaz, profesyonel dokunuş
      "options": [
        "1+0",
        "1+1",
        "2+1",
        "3+1",
        "4+1",
        "5+1",
        "6+ ve Üzeri"
      ]
    },
    {
      "id": "alan_kademe",
      "label": "Tahmini Uygulama Alanı (Taban m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_cesidi", // EKLENDİ: Yapı seçilmeden alan sorulmaz, sıra düzeldi
      "dependsOnValue": ["Daire", "Müstakil Ev", "Ofis", "İş Yeri"],
      "options": [
        "0-40 m²",
        "40-60 m²",
        "60-80 m²",
        "80-100 m²",
        "100-120 m²",
        "120-150 m²",
        "150-200 m²",
        "200-250 m²",
        "250-300 m²",
        "300+ m²"
      ]
    },

    // ==================== ADIM 2: MEKAN DURUMU ====================
    {
      "id": "mekan_durumu",
      "label": "Mekanın Eşya Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_kademe", // EKLENDİ: Alan seçilince bu gelsin, adım akışı
      "dependsOnValue": [
        "0-40 m²", "40-60 m²", "60-80 m²", "80-100 m²", "100-120 m²",
        "120-150 m²", "150-200 m²", "200-250 m²", "250-300 m²", "300+ m²"
      ],
      "options": [
        "Boş",
        "Eşyalı"
      ]
    },
    {
      "id": "zemin_durumu",
      "label": "Mevcut Duvarların Durumu (Tamir / Bakım)",
      "type": "single",
      "required": true,
      "dependsOnId": "mekan_durumu", // EKLENDİ: Eşya durumu seçilince duvar durumu gelsin
      "dependsOnValue": ["Boş", "Eşyalı"],
      "options": [
        "Gerekmez",
        "Gerekir"
      ]
    },
    {
      "id": "ekstra_islemler",
      "label": "Gerekli Görülen Tamirat ve Renk Detayları",
      "type": "multi",
      "required": false,
      "dependsOnId": "zemin_durumu",
      "dependsOnValue": ["Gerekir"], // Zaten doğruydu, korundu
      "options": [
        "Koyu Renkten Açık Renge Dönüşüm",
        "Kazıma + Macunlama İşlemleri",
        "Mevcut Duvar Kağıdı Sökümü",
        "Komple / Bölgesel Alçı Sıva İşçiliği"
      ]
    },

    // ==================== ADIM 3: BOYA TERCİHİ (FİNAL) ====================
    {
      "id": "boya_tip",
      "label": "Tercih Edilen Boya Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durumu", // EKLENDİ: Duvar durumu netleşince boya tipi sorulsun
      "dependsOnValue": ["Gerekmez", "Gerekir"],
      "options": [
        "Su Bazlı Silikonlu (Silinebilir)",
        "Plastik Boya",
        "Yağlı Boya",
        "Antibakteriyel Boya"
      ]
    },
    {
      "id": "tavan_boyasi",
      "label": "Tavan Boyası Uygulaması Yapılsın mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "boya_tip", // EKLENDİ: En son soru, final dokunuşu
      "dependsOnValue": [
        "Su Bazlı Silikonlu (Silinebilir)",
        "Plastik Boya",
        "Yağlı Boya",
        "Antibakteriyel Boya"
      ],
      "options": [
        "Hayır",
        "Evet"
      ]
    }
  ];
}