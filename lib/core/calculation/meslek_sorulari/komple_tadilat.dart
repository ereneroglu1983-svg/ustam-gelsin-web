// lib/core/calculation/meslek_sorulari/komple_tadilat.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class KompleTadilatSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK - Yapı türü
    {
      "id": "is_kapsami",
      "label": "Tadilat Yapılacak Yapı Türü",
      "type": "single",
      "required": true,
      "options": [
        "Daire (Eski Yapı Komple İç Mekan Yenileme)",
        "Villa / Müstakil Ev (İç Mekan, Çatı ve Dış Cephe Entegrasyonlu)",
        "Ofis / Ticari Alan (Kurumsal Mimari ve Ofis Bölme Sistemleri)",
        "Yeni Teslim Boş Daire (Altyapısız / Anahtar Teslim İnce İşçilik)"
      ]
    },

    // ADIM 2: ALAN - kök sonrası gelsin
    {
      "id": "alan_m2",
      "label": "Tadilat Yapılacak Toplam Alan (Net m² İzdüşümü)",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Daire (Eski Yapı Komple İç Mekan Yenileme)",
        "Villa / Müstakil Ev (İç Mekan, Çatı ve Dış Cephe Entegrasyonlu)",
        "Ofis / Ticari Alan (Kurumsal Mimari ve Ofis Bölme Sistemleri)",
        "Yeni Teslim Boş Daire (Altyapısız / Anahtar Teslim İnce İşçilik)"
      ],
      "options": [
        "1 - 50 m² Arası (Küçük Ölçekli / Stüdyo)",
        "51 - 90 m² Arası (Standart 1+1 / 2+1 Konut)",
        "91 - 140 m² Arası (Geniş 3+1 / Ofis Alanı)",
        "141 - 200 m² Arası (Büyük Daire / Müstakil Ev)",
        "200 m² ve Üzeri (Lüks Villa / Geniş Ticari Alan)"
      ]
    },

    // ADIM 3: KALİTE - alan sonrası gelsin
    {
      "id": "kalite_segmenti",
      "label": "Malzeme Kalite ve Mimari Tasarım Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_m2",
      "dependsOnValue": [
        "1 - 50 m² Arası (Küçük Ölçekli / Stüdyo)",
        "51 - 90 m² Arası (Standart 1+1 / 2+1 Konut)",
        "91 - 140 m² Arası (Geniş 3+1 / Ofis Alanı)",
        "141 - 200 m² Arası (Büyük Daire / Müstakil Ev)",
        "200 m² ve Üzeri (Lüks Villa / Geniş Ticari Alan)"
      ],
      "options": [
        "Standart / Ekonomik Segment (Kiralık veya Satış Odaklı Optimizasyonlu Malzeme Yapısı)",
        "Lüks / Premium Malzeme Segmenti (İthal Seramik, Lake Mobilya, A+ Sınıfı Vitrifiye Grubu)",
        "Ultra Lüks / A+ Tasarım Segmenti (Akıllı Ev Altyapısı, Masif Detaylar ve Özel Mimari İşçilik)"
      ]
    },

    // ADIM 4: KAPSAM - kalite sonrası gelsin, tüm alt dalları tetikler
    {
      "id": "tadilat_kapsami",
      "label": "Yenilenecek Bölümler ve Uygulama Kapsamı",
      "type": "multi",
      "required": true,
      "dependsOnId": "kalite_segmenti",
      "dependsOnValue": [
        "Standart / Ekonomik Segment (Kiralık veya Satış Odaklı Optimizasyonlu Malzeme Yapısı)",
        "Lüks / Premium Malzeme Segmenti (İthal Seramik, Lake Mobilya, A+ Sınıfı Vitrifiye Grubu)",
        "Ultra Lüks / A+ Tasarım Segmenti (Akıllı Ev Altyapısı, Masif Detaylar ve Özel Mimari İşçilik)"
      ],
      "options": [
        "Kırım / Yıkım / Duvar Kaldırma ve Moloz Atımı İşlemleri",
        "Elektrik Tesisatı Altyapısı ve Zayıf Akım Hatları Yenileme",
        "Su Tesisatı / Sıhhi Tesisat ve Temiz/Pis Su Altyapısı Yenileme",
        "Mutfak Komple Yenileme, Tezgah ve Dolap Tasarımları",
        "Banyo Komple Yenileme, Su Yalıtımı ve Vitrifiye Uygulamaları",
        "Zemin Kaplama İşçiliği (Parke / Seramik / Doğal Taş Uygulaması)",
        "Alçı / Boya / Asma Tavan ve Dekoratif Çıtalama Detayları"
      ]
    },

    // ADIM 5: BİNA YAŞI - sadece Elektrik veya Su tesisatı seçildiyse gelsin
    {
      "id": "bina_yasi",
      "label": "Uygulama Yapılacak Yapının Yaşı",
      "type": "single",
      "required": true,
      "dependsOnId": "tadilat_kapsami",
      "dependsOnValue": [
        "Elektrik Tesisatı Altyapısı ve Zayıf Akım Hatları Yenileme",
        "Su Tesisatı / Sıhhi Tesisat ve Temiz/Pis Su Altyapısı Yenileme"
      ],
      "options": [
        "0-5 Yıl Arası (Yeni Yapı / Altyapı Revizyonu Kolay)",
        "5-15 Yıl Arası (Orta Yaşlı Yapı)",
        "15-30 Yıl Arası (Eski Yapı / Tesisat Kontrolü Kritik)",
        "30 Yıl ve Üzeri (Yorgun Yapı / Komple Hat Değişimi Zorunlu)"
      ]
    },

    // ADIM 6: EŞYALI MI - sadece Kırım seçildiyse, ve bina yaşı varsa ondan sonra gelsin
    {
      "id": "esyali_mi",
      "label": "Mekanın Mevcut Kullanım ve Eşya Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": ["tadilat_kapsami", "bina_yasi"],
      "dependsOnValue": [
        "Kırım / Yıkım / Duvar Kaldırma ve Moloz Atımı İşlemleri",
        "0-5 Yıl Arası (Yeni Yapı / Altyapı Revizyonu Kolay)",
        "5-15 Yıl Arası (Orta Yaşlı Yapı)",
        "15-30 Yıl Arası (Eski Yapı / Tesisat Kontrolü Kritik)",
        "30 Yıl ve Üzeri (Yorgun Yapı / Komple Hat Değişimi Zorunlu)"
      ],
      "options": [
        "Mekan Tamamen Boş (Hızlı Kırım ve Moloz Tahliyesine Uygun)",
        "Mekan Eşyalı (Komple Paketleme, Maskeleme ve Koruma Naylonu Gereken)",
        "Mekanda Yaşam Var (Kademeli Kırım ve Odalar Arası Toz Bariyeri Gereken)"
      ]
    },

    // ADIM 7: FİNAL - kapsam sonrası, bina yaşı ve eşya durumu ne seçilirse seçilsin en sonda gelsin
    {
      "id": "tasarim_destek",
      "label": "Mimari Tasarım ve Projelendirme Desteği Talebi",
      "type": "single",
      "required": true,
      "dependsOnId": ["tadilat_kapsami", "bina_yasi", "esyali_mi"],
      "dependsOnValue": [
        "Kırım / Yıkım / Duvar Kaldırma ve Moloz Atımı İşlemleri",
        "Elektrik Tesisatı Altyapısı ve Zayıf Akım Hatları Yenileme",
        "Su Tesisatı / Sıhhi Tesisat ve Temiz/Pis Su Altyapısı Yenileme",
        "Mutfak Komple Yenileme, Tezgah ve Dolap Tasarımları",
        "Banyo Komple Yenileme, Su Yalıtımı ve Vitrifiye Uygulamaları",
        "Zemin Kaplama İşçiliği (Parke / Seramik / Doğal Taş Uygulaması)",
        "Alçı / Boya / Asma Tavan ve Dekoratif Çıtalama Detayları",
        "0-5 Yıl Arası (Yeni Yapı / Altyapı Revizyonu Kolay)",
        "5-15 Yıl Arası (Orta Yaşlı Yapı)",
        "15-30 Yıl Arası (Eski Yapı / Tesisat Kontrolü Kritik)",
        "30 Yıl ve Üzeri (Yorgun Yapı / Komple Hat Değişimi Zorunlu)",
        "Mekan Tamamen Boş (Hızlı Kırım ve Moloz Tahliyesine Uygun)",
        "Mekan Eşyalı (Komple Paketleme, Maskeleme ve Koruma Naylonu Gereken)",
        "Mekanda Yaşam Var (Kademeli Kırım ve Odalar Arası Toz Bariyeri Gereken)"
      ],
      "options": [
        "3D Görselleştirme, Mimari Tasarım ve Projelendirme İstiyorum",
        "Sadece Uygulama Hizmeti (Benim Çizimim ve Planım Hazır)",
        "Usta Tecrübesine Göre Yerinde Keşif ve Fikir Almak İstiyorum"
      ]
    }
  ];
}