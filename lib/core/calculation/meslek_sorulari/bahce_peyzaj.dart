// lib/core/calculation/meslek_sorulari/bahce_peyzaj.dart

class BahcePeyzajSorulari {
  static final List<Map<String, dynamic>> sorular = [
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
    {
      "id": "sulama_detay",
      "label": "Otomatik Sulama Sistemi Altyapı Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Komple Anahtar Teslim Bahçe Tasarımı ve Peyzaj"
      ],
      "options": [
        "Pop-up Fıskiye Sistemi (Çim Alanlar İçin Toprak Altı Gizli Hat)",
        "Damlama Sulama Sistemi (Ağaç, Çalı ve Çiçeklik Alanlar İçin Yoğun Hat)",
        "Akıllı Saat / Zamanlayıcı Kurulumu Dahil Komple Otomatik Altyapı",
        "Sadece Manuel Vana ve Bahçe Sulama Hat Çekimi"
      ]
    },
    {
      "id": "alan_segmenti", // 🛠️ TEK ÖLÇÜ KAYNAĞI: Seçmeli aralık sekmesi korunmuştur
      "label": "Uygulama Yapılacak Yaklaşık Bahçe Alan Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sadece Çim Ekimi / Serimi Uygulaması",
        "Komple Anahtar Teslim Bahçe Tasarımı ve Peyzaj"
      ],
      "options": [
        "0-50 m² Arası (Küçük Ölçekli Bahçe / Hobi Alanı)",
        "51-100 m² Arası (Standart Konut / Müstakil Ev Bahçesi)",
        "100-250 m² Arası (Geniş Bahçe / Villa Yaşam Alanı)",
        "250-500 m² Arası (Çok Geniş Peyzaj Alanı)",
        "500 m² ve Üzeri (Büyük Site / Ticari Fabrika Açık Alanı)"
      ]
    },
    {
      "id": "zemin_durumu",
      "label": "Mevcut Zemin Yapısı ve Eğim Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sadece Çim Ekimi / Serimi Uygulaması",
        "Komple Anahtar Teslim Bahçe Tasarımı ve Peyzaj"
      ],
      "options": [
        "Normal Toprak Yapısı (Düz and Temiz Zemin)",
        "Sert veya Taşlı Zemin Yapısı (Yoğun İş Makineli Çapa ve Taş Temizliği Gereken)",
        "Eğimli Arazi Yapısı (Özel Mekanik Tesviye, Hafriyat ve Kademe Gereken)"
      ]
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimari Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sadece Çim Ekimi / Serimi Uygulaması",
        "Komple Anahtar Teslim Bahçe Tasarımı ve Peyzaj"
      ],
      "options": [
        "Müstakil Ev / Villa Bahçesi",
        "Site / Apartman Ortak Yeşil Alanı",
        "İş Yeri / Fabrika Çevresi Açık Alanı",
        "Teras / Çatı Bahçesi (Özel İzolasyon Korumalı Katman)"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "İstediğiniz Altyapı Çözümleri ve Ekstra Donanımlar",
      "type": "multi",
      "dependsOnId": "uygulama_tipi",
      "dependsOnValue": [
        "Sadece Çim Ekimi / Serimi Uygulaması",
        "Komple Anahtar Teslim Bahçe Tasarımı ve Peyzaj"
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