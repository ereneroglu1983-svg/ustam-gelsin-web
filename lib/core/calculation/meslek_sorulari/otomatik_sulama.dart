// lib/core/calculation/meslek_sorulari/otomatik_sulama.dart - FINAL
class OtomatikSulamaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Ana Sulama Altyapı Sistem Teknolojisi",
      "type": "single",
      "required": true,
      "options": ["Pop-up Sprinkler Çim Gömülü Hat Kazılı", "Temel Damla Sulama Ağaç Bitki Çalı", "Mikro Sprinkler Sisleme Sera Dikey Tarım"]
    },
    {
      "id": "alan_m2",
      "label": "Sulama Toplam Alan Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["0-100 m² Küçük Lokal", "101-300 m² Standart Villa", "301-600 m² Geniş Peyzaj Site", "601-1000 m² Büyük Ticari Park", "1000 m² Üzeri Tarım Endüstriyel"]
    },
    {
      "id": "uygulama_yeri",
      "label": "Alanın Mimari Yapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_m2",
      "options": ["Villa Müstakil Bahçe", "Site Ortak Kamu Parkı", "Tarım Ticari Meyve Bahçesi", "Sera Kapalı Dikey Tarım", "Çatı Teras Drenaj Uyumlu"]
    },
    {
      "id": "arazi_yapisi",
      "label": "Arazi Topografya Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_yeri",
      "options": ["Düz Yumuşak Toprak Kolay Kazı", "Eğimli Sert Kayalık Basınç Regülatörlü Zor Kazı"]
    },
    // POP-UP DALI
    {
      "id": "su_kaynagi",
      "label": "Su Kaynağı Altyapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Pop-up Sprinkler Çim Gömülü Hat Kazılı"],
      "options": ["Şebeke Hattı Yeterli Basınç Debi", "Kuyu Artezyen Pompa Entegre", "Depo Tank Cazibeli Pompa Destekli", "Düşük Basınç Şebeke Hidrofor Takviye Gerekli"]
    },
    {
      "id": "kontrol_popup",
      "label": "Sulama Otomasyon Kontrol Zekası",
      "type": "single",
      "required": true,
      "dependsOnId": "su_kaynagi",
      "options": ["Standart Dijital Zamanlayıcılı", "Wi-Fi Mobil Akıllı Tahminli", "Hava İstasyonlu Profesyonel Evapotranspirasyon"]
    },
    // DAMLA / MİKRO DALI
    {
      "id": "kontrol_diger",
      "label": "Sulama Otomasyon Kontrol Zekası",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Temel Damla Sulama Ağaç Bitki Çalı", "Mikro Sprinkler Sisleme Sera Dikey Tarım"],
      "options": ["Standart Dijital Zamanlayıcılı", "Wi-Fi Mobil Akıllı", "Hava İstasyonlu Profesyonel"]
    },
    {
      "id": "ekstra_popup",
      "label": "Sensör Zon Donanım Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "kontrol_popup",
      "options": [
        "Ekstra Selenoid Vana Zon Yönetim",
        "Yağmur Toprak Nem Sensörü",
        "Sert Zemin Kırım Geçiş Beton Parke",
        "Gübreleme Venturi Dozajlama",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_diger",
      "label": "Sensör Zon Donanım Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "kontrol_diger",
      "options": ["Ekstra Vana Zon", "Nem Yağmur Sensörü", "Gübreleme Ünitesi", "Ekstra İstemiyorum"]
    }
  ];
}