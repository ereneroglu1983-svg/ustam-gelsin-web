// lib/core/calculation/meslek_sorulari/havuz_sistemleri.dart

class HavuzSistemleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ ANA TETİKLEYİCİ: Komple yapım, tadilat, bakım veya kapatma akışlarını birbirinden ayıran anahtar
      "label": "İhtiyacınız Olan Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan Havuz Yapımı (Komple Anahtar Teslim İnşaat ve Mekanik)",
        "Mevcut Havuz Tadilatı / Liner Değişimi (Yenileme ve Onarım)",
        "Periyodik Sezonluk Bakım Servisi (Kimyasal ve Filtrasyon Temizliği)",
        "Havuz Kapatma / Isı Sistemi Kurulumu (Sezon Uzatma Çözümleri)"
      ]
    },

    // ==========================================
    // 🏗️ GRUP 1: KABA İNŞAAT VE YAPI DETAYLARI
    // ==========================================
    {
      "id": "havuz_tipi", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue mimarisine geçirildi, string uyuşmazlığı giderildi
      "label": "Havuz Yapım Teknolojisi ve İşletim Modeli",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan Havuz Yapımı (Komple Anahtar Teslim İnşaat ve Mekanik)"],
      "options": [
        "Betonarme Gövde (Skimmerlı Standart Filtrasyon Sistemi)",
        "Üstten Taşmalı Betonarme / Infinity (Denge Tanklı Lüks Sistem)",
        "Prefabrik / Panel Havuz Sistemi (Hızlı Kurulum Çelik Panel Altyapılı)",
        "Fiberglass Havuz Gövdesi (Hazır Monoblok Kabuk Kasa Montajı)"
      ]
    },
    {
      "id": "arazi_sarti", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue mimarisine geçirildi
      "label": "Zemin Yapısı ve Hafriyat Koşulları",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan Havuz Yapımı (Komple Anahtar Teslim İnşaat ve Mekanik)"],
      "options": [
        "Normal Toprak Yapısı (Düz Arazi / Kolay Ekskavatör Kazısı)",
        "Kayalık / Sert Zemin Yapısı (Ağır İş Makinesi ve Kırıcı Mesaisi Gereken)",
        "Bataklık / Yüksek Yeraltı Suyu Olan Balçık Zemin (Zemin Islahı, Kazık ve Drenaj Gereken)"
      ]
    },

    // ==========================================
    // 🧱 GRUP 2: İÇ KAPLAMA VE YÜZEY MİMARİSİ
    // ==========================================
    {
      "id": "kaplama_tipi", // 🛠️ PROJE STANDARDI: Yapım ve tadilat durumlarında tetiklenecek şekilde optimize edildi
      "label": "Havuz İç Yüzey Kaplama Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan Havuz Yapımı (Komple Anahtar Teslim İnşaat ve Mekanik)",
        "Mevcut Havuz Tadilatı / Liner Değişimi (Yenileme ve Onarım)"
      ],
      "options": [
        "Porselen Mozaik Kaplama (Yüksek Dayanımlı Havuz Seramiği)",
        "Cam Mozaik veya Doğal Taş Kaplama (Premium Derinlik Efektli Lüks Seri)",
        "Liner Kaplama Uygulaması (Sızdırmaz PVC Membran Hazır İç Hazne Örtüsü)"
      ]
    },

    // ==========================================
    // 📐 ÖLÇÜ, METRAJ VE SU HACMİ PARAMETRELERİ
    // ==========================================
    {
      "id": "alan_segmenti", // 🛠️ TEK ÖLÇÜ KAYNAĞI: Bağımlılık eklendi, ana seçim yapılmadan görünmez
      "label": "Havuz Yüzey Alanı Ölçü Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan Havuz Yapımı (Komple Anahtar Teslim İnşaat ve Mekanik)",
        "Mevcut Havuz Tadilatı / Liner Değişimi (Yenileme ve Onarım)",
        "Periyodik Sezonluk Bakım Servisi (Kimyasal ve Filtrasyon Temizliği)",
        "Havuz Kapatma / Isı Sistemi Kurulumu (Sezon Uzatma Çözümleri)"
      ],
      "options": [
        "0-25 m² Arası (Küçük Ölçekli / Müstakil Villa Tipi Havuz)",
        "25-50 m² Arası (Orta Boy Standart Bahçe Tipi Aile Havuzu)",
        "50-100 m² Arası (Geniş / Ticari / Sosyal Tesis Havuzu)",
        "100 m² ve Üzeri (Yarı Olimpik / Büyük Otel Tesis Tipi)"
      ]
    },

    // ==========================================
    // ⚙️ ELEKTROMEKANİK DONANIMLAR VE KONFOR EKSTRALARI
    // ==========================================
    {
      "id": "ekstra_ozellikler", // 🛠️ DÜZELTİLDİ: Bağımlılık eklendi, ana seçim yapılmadan görünmez
      "label": "Elektromekanik Donanımlar ve Konfor Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan Havuz Yapımı (Komple Anahtar Teslim İnşaat ve Mekanik)",
        "Mevcut Havuz Tadilatı / Liner Değişimi (Yenileme ve Onarım)",
        "Periyodik Sezonluk Bakım Servisi (Kimyasal ve Filtrasyon Temizliği)",
        "Havuz Kapatma / Isı Sistemi Kurulumu (Sezon Uzatma Çözümleri)"
      ],
      "options": [
        "Inverter Isı Pompası Entegrasyonu (Dört Mevsim Yüzme İçin Akıllı Havuz Isıtma Sistemi)",
        "Tuz Klorlama Jeneratörü Otomasyonu (Doğal Dezenfeksiyon ve Otomatik pH Dozajlama Ünitesi)",
        "Paslanmaz Çelik Şelale veya Jakuzi SPA Köşesi (Bağımsız Pompa ve Masaj Jet Ekipmanları)",
        "RGB Akıllı Aydınlatma Paketeti (Uzaktan Kumandalı ve Trafolu Renkli LED Armatür Seti)",
        "Otomatik Kapak Sistemi (Isı ve Buharlaşma Kaybını Önleyen Motorlu Lamel Örtü)"
      ]
    }
  ];
}