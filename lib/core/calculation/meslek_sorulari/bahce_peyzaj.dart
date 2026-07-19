// lib/core/calculation/meslek_sorulari/bahce_peyzaj.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class BahcePeyzajSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "uygulama_tipi",
      "label": "İhtiyacınız Olan Hizmet Türü",
      "type": "single",
      "required": true,
      "options": [
        "Sadece Çim Ekimi / Serimi Uygulaması",
        "Komple Anahtar Teslim Bahçe Tasarımı ve Peyzaj"
      ]
    },

    // ADIM 2: ÇİM TÜRÜ - kök seçilince gelsin
    {
      "id": "cim_turu",
      "label": "Talep Edilen Çim Uygulama Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sadece Çim Ekimi / Serimi Uygulaması",
        "Komple Anahtar Teslim Bahçe Tasarımı ve Peyzaj"
      ],
      "options": [
        "Hazır Rulo Çim (Canlı Doğal Hazır Kalıp Çim Serimi)",
        "Tohum Çim Ekimi (Mevsimsel Karışım Tohum ile Ekonomik Çimlendirme)",
        "Yapay / Sentetik Çim (Bakım Gerektirmeyen Dekoratif Halı Çim Serimi)"
      ]
    },

    // ADIM 2.5: SULAMA - sadece Komple'de ve çim türü seçilince gelsin (dal)
    {
      "id": "sulama_detay",
      "label": "Otomatik Sulama Sistemi Altyapı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "cim_turu", // DEĞİŞTİ: Direkt köke değil, çim türüne bağlı - akış için
      "dependsOnValue": [
        "Hazır Rulo Çim (Canlı Doğal Hazır Kalıp Çim Serimi)",
        "Tohum Çim Ekimi (Mevsimsel Karışım Tohum ile Ekonomik Çimlendirme)",
        "Yapay / Sentetik Çim (Bakım Gerektirmeyen Dekoratif Halı Çim Serimi)"
      ],
      // NOT: Bu soru sadece Komple'de gösterilecek, kontrolünü musteri_ilan_detay'daki
      // _alanGorunurMu içinde uygulama_tipi == Komple diye filtreliyoruz zaten.
      // Data tarafında görünmemesi için extra anahtar ekliyoruz:
      "visibleIf": {"uygulama_tipi": "Komple Anahtar Teslim Bahçe Tasarımı ve Peyzaj"},
      "options": [
        "Pop-up Fıskiye Sistemi (Çim Alanlar İçin Toprak Altı Gizli Hat)",
        "Damlama Sulama Sistemi (Ağaç, Çalı ve Çiçeklik Alanlar İçin Yoğun Hat)",
        "Akıllı Saat / Zamanlayıcı Kurulumu Dahil Komple Otomatik Altyapı",
        "Sadece Manuel Vana ve Bahçe Sulama Hat Çekimi"
      ]
    },

    // ADIM 3: ALAN KADEMESİ - çim seçilince (ve sulama varsa ondan sonra) gelsin
    {
      "id": "alan_segmenti",
      "label": "Uygulama Yapılacak Yaklaşık Bahçe Alan Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "cim_turu", // DEĞİŞTİ: Direkt köke değil, çim türüne bağlı
      "dependsOnValue": [
        "Hazır Rulo Çim (Canlı Doğal Hazır Kalıp Çim Serimi)",
        "Tohum Çim Ekimi (Mevsimsel Karışım Tohum ile Ekonomik Çimlendirme)",
        "Yapay / Sentetik Çim (Bakım Gerektirmeyen Dekoratif Halı Çim Serimi)"
      ],
      "options": [
        "0-50 m² Arası (Küçük Ölçekli Bahçe / Hobi Alanı)",
        "51-100 m² Arası (Standart Konut / Müstakil Ev Bahçesi)",
        "100-250 m² Arası (Geniş Bahçe / Villa Yaşam Alanı)",
        "250-500 m² Arası (Çok Geniş Peyzaj Alanı)",
        "500 m² ve Üzeri (Büyük Site / Ticari Fabrika Açık Alanı)"
      ]
    },

    // ADIM 4: ZEMİN - alan seçilince gelsin
    {
      "id": "zemin_durumu",
      "label": "Mevcut Zemin Yapısı ve Eğim Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-50 m² Arası (Küçük Ölçekli Bahçe / Hobi Alanı)",
        "51-100 m² Arası (Standart Konut / Müstakil Ev Bahçesi)",
        "100-250 m² Arası (Geniş Bahçe / Villa Yaşam Alanı)",
        "250-500 m² Arası (Çok Geniş Peyzaj Alanı)",
        "500 m² ve Üzeri (Büyük Site / Ticari Fabrika Açık Alanı)"
      ],
      "options": [
        "Normal Toprak Yapısı (Düz and Temiz Zemin)",
        "Sert veya Taşlı Zemin Yapısı (Yoğun İş Makineli Çapa ve Taş Temizliği Gereken)",
        "Eğimli Arazi Yapısı (Özel Mekanik Tesviye, Hafriyat ve Kademe Gereken)"
      ]
    },

    // ADIM 5: YAPI TİPİ - zemin seçilince gelsin
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimari Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durumu",
      "dependsOnValue": [
        "Normal Toprak Yapısı (Düz and Temiz Zemin)",
        "Sert veya Taşlı Zemin Yapısı (Yoğun İş Makineli Çapa ve Taş Temizliği Gereken)",
        "Eğimli Arazi Yapısı (Özel Mekanik Tesviye, Hafriyat ve Kademe Gereken)"
      ],
      "options": [
        "Müstakil Ev / Villa Bahçesi",
        "Site / Apartman Ortak Yeşil Alanı",
        "İş Yeri / Fabrika Çevresi Açık Alanı",
        "Teras / Çatı Bahçesi (Özel İzolasyon Korumalı Katman)"
      ]
    },

    // ADIM 6: FİNAL - yapı tipi seçilince yeşil kutuda açılsın
    {
      "id": "ekstra_ozellikler",
      "label": "İstediğiniz Altyapı Çözümleri ve Ekstra Donanımlar",
      "type": "multi",
      "required": false,
      "dependsOnId": "yapi_tip",
      "dependsOnValue": [
        "Müstakil Ev / Villa Bahçesi",
        "Site / Apartman Ortak Yeşil Alanı",
        "İş Yeri / Fabrika Çevresi Açık Alanı",
        "Teras / Çatı Bahçesi (Özel İzolasyon Korumalı Katman)"
      ],
      "options": [
        "Kademeli Drenaj Hattı Yapımı (Kışın Su Birikmesini ve Çim Çürümesini Önleyen Altyapı)",
        "Yürüyüş Yolu Tasarımı ve Uygulaması (Doğal Kayrak Taşı veya Kilit Taşı Döşeme İşçiliği)",
        "Bahçe Aydınlatma Sistemi Montajı (Su Geçirmez Armatür Bahçe Aydınlatma ve Kablolama Altyapısı)",
        "Organik Gübre Kullanımı ve Bitkisel Zenginleştirilmiş Toprak İyileştirici İlavesi"
      ]
    }
  ];
}