// lib/core/calculation/meslek_sorulari/havuz_sistemleri.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class HavuzSistemleriSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
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

    // ADIM 2: HAVUZ TİPİ - sadece Sıfırdan'da gelsin
    {
      "id": "havuz_tipi",
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

    // ADIM 3: ARAZİ ŞARTI - havuz tipi sonrası gelsin
    {
      "id": "arazi_sarti",
      "label": "Zemin Yapısı ve Hafriyat Koşulları",
      "type": "single",
      "required": true,
      "dependsOnId": "havuz_tipi",
      "dependsOnValue": [
        "Betonarme Gövde (Skimmerlı Standart Filtrasyon Sistemi)",
        "Üstten Taşmalı Betonarme / Infinity (Denge Tanklı Lüks Sistem)",
        "Prefabrik / Panel Havuz Sistemi (Hızlı Kurulum Çelik Panel Altyapılı)",
        "Fiberglass Havuz Gövdesi (Hazır Monoblok Kabuk Kasa Montajı)"
      ],
      "options": [
        "Normal Toprak Yapısı (Düz Arazi / Kolay Ekskavatör Kazısı)",
        "Kayalık / Sert Zemin Yapısı (Ağır İş Makinesi ve Kırıcı Mesaisi Gereken)",
        "Bataklık / Yüksek Yeraltı Suyu Olan Balçık Zemin (Zemin Islahı, Kazık ve Drenaj Gereken)"
      ]
    },

    // ADIM 4: KAPLAMA - Sıfırdan için arazi sonrası, Tadilat için direkt kökten gelsin
    {
      "id": "kaplama_tipi",
      "label": "Havuz İç Yüzey Kaplama Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": ["arazi_sarti", "is_kapsami"],
      "dependsOnValue": [
        "Normal Toprak Yapısı (Düz Arazi / Kolay Ekskavatör Kazısı)",
        "Kayalık / Sert Zemin Yapısı (Ağır İş Makinesi ve Kırıcı Mesaisi Gereken)",
        "Bataklık / Yüksek Yeraltı Suyu Olan Balçık Zemin (Zemin Islahı, Kazık ve Drenaj Gereken)",
        "Mevcut Havuz Tadilatı / Liner Değişimi (Yenileme ve Onarım)"
      ],
      "options": [
        "Porselen Mozaik Kaplama (Yüksek Dayanımlı Havuz Seramiği)",
        "Cam Mozaik veya Doğal Taş Kaplama (Premium Derinlik Efektli Lüks Seri)",
        "Liner Kaplama Uygulaması (Sızdırmaz PVC Membran Hazır İç Hazne Örtüsü)"
      ]
    },

    // ADIM 5: ALAN - kaplama sonrası veya Bakım/Kapatma'da direkt kökten gelsin
    {
      "id": "alan_segmenti",
      "label": "Havuz Yüzey Alanı Ölçü Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": ["kaplama_tipi", "is_kapsami"],
      "dependsOnValue": [
        "Porselen Mozaik Kaplama (Yüksek Dayanımlı Havuz Seramiği)",
        "Cam Mozaik veya Doğal Taş Kaplama (Premium Derinlik Efektli Lüks Seri)",
        "Liner Kaplama Uygulaması (Sızdırmaz PVC Membran Hazır İç Hazne Örtüsü)",
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

    // ADIM 6: FİNAL EKSTRA - alan sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Elektromekanik Donanımlar ve Konfor Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-25 m² Arası (Küçük Ölçekli / Müstakil Villa Tipi Havuz)",
        "25-50 m² Arası (Orta Boy Standart Bahçe Tipi Aile Havuzu)",
        "50-100 m² Arası (Geniş / Ticari / Sosyal Tesis Havuzu)",
        "100 m² ve Üzeri (Yarı Olimpik / Büyük Otel Tesis Tipi)"
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