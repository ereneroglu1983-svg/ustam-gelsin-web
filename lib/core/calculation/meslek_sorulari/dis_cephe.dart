// lib/core/calculation/meslek_sorulari/dis_cephe.dart - KURAL DEFTERİNE UYGUN FINAL
class DisCepheSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "islem_turu",
      "label": "Talep Edilen Cephe İşlem Türü",
      "type": "single",
      "required": true,
      "options": [
        "Mantolama ve Boya Paket Uygulaması",
        "Sadece Dış Cephe Boya"
      ]
    },
    {
      "id": "mantolama_durum",
      "label": "Mantolama Durumu Nedir?",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_turu",
      "dependsOnValue": ["Mantolama ve Boya Paket Uygulaması"],
      "options": [
        "Sıfırdan Mantolama Yapılacak",
        "Mevcut Mantolama Tamir Edilecek",
        "Kararsızım / Usta Karar Versin"
      ]
    },
    {
      "id": "malzeme_tipi",
      "label": "Yalıtım Malzemesi Tercihiniz",
      "type": "single",
      "required": true,
      "dependsOnId": "mantolama_durum",
      "dependsOnValue": ["Sıfırdan Mantolama Yapılacak", "Mevcut Mantolama Tamir Edilecek"],
      "options": [
        "EPS - Standart",
        "Karbonlu EPS",
        "Taş Yünü - Yanmaz",
        "XPS",
        "Fark Etmez / En Uygun Fiyatlı Olsun"
      ]
    },
    {
      "id": "kalinlik",
      "label": "Yalıtım Levha Kalınlığı",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tipi",
      "options": ["3 cm", "4 cm", "5 cm", "6 cm", "8 cm ve Üzeri", "Usta Önerisine Bırakıyorum"]
    },
    // TEK M² SORUSU - BİR DAHA SORULMAYACAK
    {
      "id": "alan_segmenti",
      "label": "Toplam Dış Cephe Alanı Ne Kadar?",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_turu",
      "options": ["0-100 m²", "100-250 m²", "250-500 m²", "500-1000 m²", "1000 m² ve Üzeri", "Bilmiyorum / Keşif Gerekir"]
    },
    {
      "id": "bina_tip",
      "label": "Bina Tipi Nedir?",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "options": ["Apartman", "Villa / Müstakil Ev", "İş Yeri / Ticari Bina", "Fabrika / Depo"]
    },
    // TEK KAT SORUSU - BİR DAHA SORULMAYACAK
    {
      "id": "kat_sayisi",
      "label": "Bina Kaç Katlı?",
      "type": "single",
      "required": true,
      "dependsOnId": "bina_tip",
      "options": ["1-2 Kat", "3-5 Kat", "6-10 Kat", "11 Kat ve Üzeri"]
    },
    {
      "id": "iskele_durumu",
      "label": "İskele / Vinç Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "kat_sayisi",
      "options": ["İskele Kurulmalı", "Sitemizde İskele Var", "Vinç Yeterli Olur", "Gerek Yok / Zemin Kat"]
    },
    {
      "id": "cephe_durumu",
      "label": "Mevcut Cephe Duvarının Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "iskele_durumu",
      "options": ["Sağlam, Direkt Boya Olur", "Çatlak ve Dökülmeler Var", "Eski Boya Kazınmalı", "Nem / Rutubet Var"]
    },
    {
      "id": "ekstra_isler",
      "label": "Ekstra Dekoratif İş İstiyor musunuz?",
      "type": "multi",
      "required": false,
      "dependsOnId": "cephe_durumu",
      "options": [
        "Söve / Pencere Kenarı Süsleme",
        "Dekoratif Mineral Sıva",
        "Silikonlu Dış Cephe Boyası Olsun",
        "Çatlak Tamiri ve File Çekilsin",
        "Ekstra İstemiyorum"
      ]
    }
  ];
}