// lib/core/calculation/meslek_sorulari/dis_cephe.dart

class DisCepheSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "islem_turu",
      "label": "Talep Edilen Cephe İşlem Türü",
      "type": "single",
      "required": true,
      "options": [
        "Mantolama ve Boya Paket Uygulaması",
        "Sadece Dış Cephe Boya (Mantolama İstemiyorum)"
      ]
    },
    // 🎯 1. ADIM: Uygulama Durumu
    {
      "id": "mantolama_durum",
      "label": "Mantolama Uygulama Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_turu",
      "dependsOnValue": ["Mantolama ve Boya Paket Uygulaması"],
      "options": [
        "Sıfır Mantolama (Yeni Uygulama)",
        "Mevcut Mantolama Yenileme / Revizyon (Tadilat)"
      ]
    },
    // 🎯 2. ADIM: Sadece Tadilat seçenler için dinamik ara yönlendirme sorusu açılır
    {
      "id": "malzeme_tadilati_gerekli_mi",
      "label": "Mantolama Malzemesi Değişimi / Tadilatı Gerekiyor mu?",
      "type": "single",
      "required": true,
      "dependsOnId": "mantolama_durum",
      "dependsOnValue": ["Mevcut Mantolama Yenileme / Revizyon (Tadilat)"],
      "options": [
        "EVET (Hasarlı levhalar değiştirilsin)",
        "HAYIR (Sadece sıva/file tamiri ve boya yapılsın)"
      ]
    },
    // 🎯 3. ADIM: Malzeme Tipi Yönlendirmesi
    // ARTIK KİLİTLİ! Sadece Sıfır Mantolama yapacaklara VEYA tadilatta kesinlikle EVET diyenlere açılır.
    // HAYIR diyen adamın arayüzünde bu soru ASLA görünmez.
    {
      "id": "malzeme_tipi",
      "label": "Yalıtım Malzemesi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tadilati_gerekli_mi", // 👈 Tetikleyiciyi ara soruya bağladık
      "dependsOnId2": "mantolama_durum", // 👈 Eğer UI çift bağımlılık desteklemiyorsa alt satırdaki listeyle çözüyoruz
      "dependsOnValue": [
        "EVET (Hasarlı levhalar değiştirilsin)",
        "Sıfır Mantolama (Yeni Uygulama)" // 👈 UI motorunun süzebilmesi için iki tetikleyici değeri de diziye ekledik
      ],
      "options": [
        "EPS - Standart",
        "Karbonlu EPS - Yüksek Yoğunluklu",
        "Taş Yünü - A1 Sınıfı Yanmaz / Isı-Ses Yalıtımlı",
        "XPS Yalıtım Levhası"
      ]
    },
    // 🎯 4. ADIM: Malzeme Kalınlığı Yallatımı
    // HAYIR diyen adam buradan da muaf, zorla mal satmak yok!
    {
      "id": "kalinlik_boya",
      "label": "Yalıtım Malzeme Kalınlığı",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tadilati_gerekli_mi",
      "dependsOnValue": [
        "EVET (Hasarlı levhalar değiştirilsin)",
        "Sıfır Mantolama (Yeni Uygulama)"
      ],
      "options": [
        "3 cm Kalınlık",
        "4 cm Kalınlık",
        "5 cm Kalınlık",
        "8 cm+ Kalınlık"
      ]
    },
    // --- GENEL CEPHE SORULARI (HER İKİ SEÇENEKTE DE AÇILANLAR) ---
    {
      "id": "alan_segmenti",
      "label": "Toplam Dış Cephe Alanı (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_turu",
      "dependsOnValue": [
        "Mantolama ve Boya Paket Uygulaması",
        "Sadece Dış Cephe Boya (Mantolama İstemiyorum)"
      ],
      "options": [
        "0-100 m² Arası",
        "100-250 m² Arası",
        "250-500 m² Arası",
        "500-1000 m² Arası",
        "1000 m² ve Üzeri"
      ]
    },
    {
      "id": "metre_kare",
      "label": "Net Dış Cephe Alanı Girin - m² (Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 185",
      "dependsOnId": "islem_turu",
      "dependsOnValue": [
        "Mantolama ve Boya Paket Uygulaması",
        "Sadece Dış Cephe Boya (Mantolama İstemiyorum)"
      ]
    },
    {
      "id": "bina_tip",
      "label": "Bina Yapı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_turu",
      "dependsOnValue": [
        "Mantolama ve Boya Paket Uygulaması",
        "Sadece Dış Cephe Boya (Mantolama İstemiyorum)"
      ],
      "options": [
        "Apartman Bloğu",
        "Villa / Müstakil Ev",
        "Ticari Bina / İşyeri"
      ]
    },
    {
      "id": "bina_yuksekligi",
      "label": "Bina Kat Sayısı (Yükseklik Derecesi)",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_turu",
      "dependsOnValue": [
        "Mantolama ve Boya Paket Uygulaması",
        "Sadece Dış Cephe Boya (Mantolama İstemiyorum)"
      ],
      "options": [
        "1-2 Katlı Müstakil Ev / Villa",
        "3-5 Katlı Bina (Çelik İskele Kurulumlu)",
        "6 Kat ve Üzeri Standart Apartman Blokları",
        "Yüksek Kule / Gökdelen (Hareketli Platform Sepetli)"
      ]
    },
    // --- DEKORATİF EKSTRALAR KATMANI ---
    {
      "id": "ekstra_secimi",
      "label": "Boyama Detayları ve Dekoratif Ekstralar İstiyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_turu",
      "dependsOnValue": [
        "Mantolama ve Boya Paket Uygulaması",
        "Sadece Dış Cephe Boya (Mantolama İstemiyorum)"
      ],
      "options": [
        "EKSTRALAR İSTİYORUM",
        "EKSTRALAR İSTEMİYORUM"
      ]
    },
    {
      "id": "ekstra_detaylar",
      "label": "Lütfen İstediğiniz Ekstraları Seçin",
      "type": "multi",
      "required": true,
      "dependsOnId": "ekstra_secimi",
      "dependsOnValue": ["EKSTRALAR İSTİYORUM"],
      "options": [
        "Söve / Pencere Kenarı Dekoratif Süsleme Uygulaması",
        "Silikonlu Boya Tercihi (Kendi Kendini Temizleyen)",
        "Grenli Dış Cephe Boyası / Dekoratif Sıva (Mozaik)",
        "Cephe Çatlak Tamiri ve Fileli Kimyasal Dolgu"
      ]
    }
  ];
}