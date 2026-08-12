// lib/core/calculation/meslek_sorulari/komple_tadilat.dart - FINAL
class KompleTadilatSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Tadilat Yapı Türü",
      "type": "single",
      "required": true,
      "options": ["Daire Eski Yapı Komple Yenileme", "Villa Müstakil İç Dış Entegre", "Ofis Ticari Kurumsal", "Yeni Teslim Boş Daire İnce İşçilik"]
    },
    {
      "id": "alan_m2",
      "label": "Toplam Alan Net m²",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["1-50 m² Küçük Stüdyo", "51-90 m² Standart 1+1 2+1", "91-140 m² Geniş 3+1 Ofis", "141-200 m² Büyük Daire Villa", "200 m² Üzeri Lüks Villa Ticari"]
    },
    {
      "id": "kalite_segmenti",
      "label": "Malzeme Kalite Mimari Segment",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_m2",
      "options": ["Standart Ekonomik Kiralık Satış Odaklı", "Lüks Premium İthal Seramik Lake A+", "Ultra Lüks Akıllı Ev Masif Özel Mimari"]
    },
    {
      "id": "esyali_mi",
      "label": "Mekan Eşya Kullanım Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "kalite_segmenti",
      "options": ["Tamamen Boş Hızlı Kırım Uygun", "Eşyalı Paketleme Koruma Gerekli", "Yaşam Var Kademeli Toz Bariyerli"]
    },
    {
      "id": "bina_yasi",
      "label": "Yapı Yaşı Altyapı Riski",
      "type": "single",
      "required": true,
      "dependsOnId": "esyali_mi",
      "options": ["0-5 Yıl Yeni Kolay Revizyon", "5-15 Yıl Orta", "15-30 Yıl Eski Kontrol Kritik", "30 Yıl Üzeri Yorgun Komple Hat Değişim"]
    },
    {
      "id": "tadilat_kapsami",
      "label": "Yenilenecek Bölümler Uygulama Kapsamı",
      "type": "multi",
      "required": true,
      "dependsOnId": "bina_yasi",
      "options": [
        "Kırım Yıkım Duvar Kaldırma Moloz Atım",
        "Elektrik Tesisat Zayıf Akım Yenileme",
        "Su Tesisat Sıhhi Temiz Pis Su Yenileme",
        "Mutfak Komple Tezgah Dolap",
        "Banyo Komple Yalıtım Vitrifiye",
        "Zemin Kaplama Parke Seramik Taş",
        "Alçı Boya Asma Tavan Çıtalama"
      ]
    },
    {
      "id": "tasarim_destek",
      "label": "Mimari Tasarım Projelendirme Talebi",
      "type": "single",
      "required": true,
      "dependsOnId": "tadilat_kapsami",
      "options": ["3D Görselleştirme Mimari Tasarım İstiyorum", "Sadece Uygulama Çizimim Hazır", "Usta Tecrübesi Yerinde Keşif Fikir"]
    }
  ];
}