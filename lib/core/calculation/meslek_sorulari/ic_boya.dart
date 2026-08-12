// lib/core/calculation/meslek_sorulari/ic_boya.dart - FINAL - DALLANAN ZİNCİR
class IcBoyaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "yapi_cesidi",
      "label": "Uygulama Yapılacak Yapı Çeşidi",
      "type": "single",
      "required": true,
      "options": ["Daire", "Müstakil Ev", "Ofis", "İş Yeri"]
    },
    {
      // Daire / Müstakil Ev seçilirse AÇILIR, Ofis / İş Yeri seçilirse ATLANIR
      "id": "oda_sayisi",
      "label": "Oda Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_cesidi",
      "dependsOnValue": ["Daire", "Müstakil Ev"],
      "options": ["1+0", "1+1", "2+1", "3+1", "4+1", "5+1", "6+ ve Üzeri"]
    },
    {
      // ÖZEL: Ofis/İş Yeri -> direkt yapi'dan sonra açılır
      // Daire/Müstakil -> oda_sayisi seçildikten sonra açılır
      // dependsOn YOK, detay sayfasındaki özel _alanGorunurMu bunu yönetiyor
      "id": "alan_kademe",
      "label": "Tahmini Uygulama Alanı (Taban m²)",
      "type": "single",
      "required": true,
      "options": ["0-40 m²", "40-60 m²", "60-80 m²", "80-100 m²", "100-120 m²", "120-150 m²", "150-200 m²", "200-250 m²", "250-300 m²", "300+ m²"]
    },
    {
      // alan seçilince açılır
      "id": "mekan_durumu",
      "label": "Mekanın Eşya Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_kademe",
      "options": ["Boş", "Eşyalı"]
    },
    {
      // mekan seçilince açılır
      "id": "tavan_boyasi",
      "label": "Tavan Boyası Uygulaması Yapılsın mı?",
      "type": "single",
      "required": true,
      "dependsOnId": "mekan_durumu",
      "options": ["Hayır", "Evet"]
    },
    {
      // tavan seçilince açılır
      "id": "zemin_durumu",
      "label": "Mevcut Duvarların Durumu (Tamir / Bakım)",
      "type": "single",
      "required": true,
      "dependsOnId": "tavan_boyasi",
      "options": ["Gerekmez", "Gerekir"]
    },
    {
      // SADECE Gerekir ise açılır
      "id": "ekstra_islemler",
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
      // zemin seçilince açılır (ekstra ile aynı anda gelebilir, sorun değil)
      "id": "boya_tip",
      "label": "Tercih Edilen Boya Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durumu",
      "options": [
        "Su Bazlı Silikonlu (Silinebilir)",
        "Plastik Boya",
        "Yağlı Boya",
        "Antibakteriyel Boya"
      ]
    }
  ];
}