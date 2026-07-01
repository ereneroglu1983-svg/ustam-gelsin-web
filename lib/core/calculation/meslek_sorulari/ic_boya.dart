// lib/core/calculation/meslek_sorulari/ic_boya.dart

class IcBoyaSorulari {
  static final List<Map<String, dynamic>> sorular = [
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
      "id": "oda_sayisi", // 🛠️ PROJE STANDARDI: Bağımlılık mimarisi camelCase yapısına geçirildi
      "label": "Oda Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_cesidi",
      "dependsOnValue": ["Daire", "Müstakil Ev"],
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
    {
      "id": "mekan_durumu",
      "label": "Mekanın Eşya Durumu",
      "type": "single",
      "required": true,
      "options": [
        "Boş",
        "Eşyalı"
      ]
    },
    {
      "id": "tavan_boyasi",
      "label": "Tavan Boyası Uygulaması Yapılsın mı?",
      "type": "single",
      "required": true,
      "options": [
        "Hayır",
        "Evet"
      ]
    },
    {
      "id": "zemin_durumu",
      "label": "Mevcut Duvarların Durumu (Tamir / Bakım)",
      "type": "single",
      "required": true,
      "options": [
        "Gerekmez",
        "Gerekir"
      ]
    },
    {
      "id": "ekstra_islemler", // 🛠️ PROJE STANDARDI: Bağımlılık mimarisi camelCase yapısına geçirildi
      "label": "Gerekli Görülen Tamirat ve Renk Detayları",
      "type": "multi",
      "required": false,
      "dependsOnId": "zemin_durumu",
      "dependsOnValue": ["Gerekir"],
      "options": [
        "Koyu Renkten Açık Renge Dönüşüm",
        "Kazıma + Macunlama İşlemleri",
        "Mevcut Duvar Kağıdı Sökümü",
        "Komple / Bölgesel Alçı Sıva İşçiliği"
      ]
    },
    {
      "id": "boya_tip",
      "label": "Tercih Edilen Boya Türü",
      "type": "single",
      "required": true,
      "options": [
        "Su Bazlı Silikonlu (Silinebilir)",
        "Plastik Boya",
        "Yağlı Boya",
        "Antibakteriyel Boya"
      ]
    }
  ];
}