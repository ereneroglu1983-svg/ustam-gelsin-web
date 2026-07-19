// lib/core/calculation/meslek_sorulari/dis_cephe.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class DisCepheSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
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

    // ADIM 2: MANTOLAMA DURUMU - sadece Paket'te gelsin
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

    // ADIM 3: TADİLAT ARA SORU - sadece Tadilat seçilince gelsin
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

    // ADIM 4: MALZEME TİPİ - Sıfır Mantolama VEYA EVET diyenlerde gelsin
    // OR mantığı için dependsOnId2 kullanıyoruz, yeni _alanGorunurMu bunu okuyor
    {
      "id": "malzeme_tipi",
      "label": "Yalıtım Malzemesi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tadilati_gerekli_mi",
      "dependsOnId2": "mantolama_durum",
      "dependsOnValue": [
        "EVET (Hasarlı levhalar değiştirilsin)",
        "Sıfır Mantolama (Yeni Uygulama)"
      ],
      "options": [
        "EPS - Standart",
        "Karbonlu EPS - Yüksek Yoğunluklu",
        "Taş Yünü - A1 Sınıfı Yanmaz / Isı-Ses Yalıtımlı",
        "XPS Yalıtım Levhası"
      ]
    },

    // ADIM 5: KALINLIK - malzeme seçilince gelsin (OR mantığı aynı)
    {
      "id": "kalinlik_boya",
      "label": "Yalıtım Malzeme Kalınlığı",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tipi",
      "dependsOnValue": [
        "EPS - Standart",
        "Karbonlu EPS - Yüksek Yoğunluklu",
        "Taş Yünü - A1 Sınıfı Yanmaz / Isı-Ses Yalıtımlı",
        "XPS Yalıtım Levhası"
      ],
      "options": [
        "3 cm Kalınlık",
        "4 cm Kalınlık",
        "5 cm Kalınlık",
        "8 cm+ Kalınlık"
      ]
    },

    // ADIM 6: ALAN - kök seçilince gelsin ama zincirde buraya oturttuk
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
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-100 m² Arası",
        "100-250 m² Arası",
        "250-500 m² Arası",
        "500-1000 m² Arası",
        "1000 m² ve Üzeri"
      ]
    },

    // ADIM 7: BİNA TİPİ - alan seçilince gelsin
    {
      "id": "bina_tip",
      "label": "Bina Yapı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-100 m² Arası",
        "100-250 m² Arası",
        "250-500 m² Arası",
        "500-1000 m² Arası",
        "1000 m² ve Üzeri"
      ],
      "options": [
        "Apartman Bloğu",
        "Villa / Müstakil Ev",
        "Ticari Bina / İşyeri"
      ]
    },

    // ADIM 8: YÜKSEKLİK - bina tipi seçilince gelsin
    {
      "id": "bina_yuksekligi",
      "label": "Bina Kat Sayısı (Yükseklik Derecesi)",
      "type": "single",
      "required": true,
      "dependsOnId": "bina_tip",
      "dependsOnValue": [
        "Apartman Bloğu",
        "Villa / Müstakil Ev",
        "Ticari Bina / İşyeri"
      ],
      "options": [
        "1-2 Katlı Müstakil Ev / Villa",
        "3-5 Katlı Bina (Çelik İskele Kurulumlu)",
        "6 Kat ve Üzeri Standart Apartman Blokları",
        "Yüksek Kule / Gökdelen (Hareketli Platform Sepetli)"
      ]
    },

    // ADIM 9: EKSTRA SORUSU - yükseklik seçilince gelsin
    {
      "id": "ekstra_secimi",
      "label": "Boyama Detayları ve Dekoratif Ekstralar İstiyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "bina_yuksekligi",
      "dependsOnValue": [
        "1-2 Katlı Müstakil Ev / Villa",
        "3-5 Katlı Bina (Çelik İskele Kurulumlu)",
        "6 Kat ve Üzeri Standart Apartman Blokları",
        "Yüksek Kule / Gökdelen (Hareketli Platform Sepetli)"
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