// lib/core/calculation/meslek_sorulari/sineklik_panjur.dart - FINAL
class SineklikPanjurSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Sadece Sineklik", "Sadece Panjur", "Hem Panjur Hem Sineklik Komple Paket"]
    },
    {
      "id": "dograma_adet",
      "label": "Montaj Doğrama Adedi Pencere Kapı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "options": ["1 Adet Tekil", "2-4 Adet Kısmi", "5-8 Adet Standart Daire Paket", "9-14 Adet Geniş Dubleks Müstakil", "14+ Villa Toplu"]
    },
    {
      "id": "yapi_tip",
      "label": "Yapı Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "dograma_adet",
      "options": ["Apartman Dairesi", "Müstakil Villa", "Ofis Ticari", "Yazlık Bağ Evi"]
    },
    {
      "id": "montaj_zemin",
      "label": "Mevcut Doğrama Altyapı",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "options": ["PVC Hazır Kasa", "Alüminyum Profil Üzeri", "Ahşap Çerçeve", "Mermer Beton Dış Cephe"]
    },
    // SADECE SİNEKLİK DALI
    {
      "id": "sineklik_tipi",
      "label": "Sineklik Mekanizma Tül Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sadece Sineklik"],
      "options": ["Plise Pileli Akordeon Katlanır", "Sabit Çerçeveli Ekonomik Çıkar Tak", "Sürgülü Duble Kasetli Rulmanlı Geniş Açıklık"]
    },
    {
      "id": "ekstra_sineklik",
      "label": "Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "sineklik_tipi",
      "options": ["Kedi Köpek Yırtılmaz Çelik Tül", "Antrasit Özel Renk Profil", "Eski Söküm Revizyon", "Ekstra İstemiyorum"]
    },
    // SADECE PANJUR DALI
    {
      "id": "panjur_ici_sineklik",
      "label": "Panjura Entegre Sineklik İstiyor musun",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sadece Panjur"],
      "options": ["Evet Sineklik de İstiyorum", "Hayır Sadece Panjur"]
    },
    {
      "id": "panjur_tipi",
      "label": "Panjur Tahrik Kontrol Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "panjur_ici_sineklik",
      "options": ["Manuel Makaralı İpli Duvar Makaralı", "Motorlu Otomatik Uzaktan Kumandalı Tüp Motorlu"]
    },
    {
      "id": "panjur_alan",
      "label": "Panjur Toplam Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "panjur_tipi",
      "options": ["0-3 m² Küçük Menfez", "3-6 m² Standart Oda", "6-12 m² Geniş Balkon Kapı", "12-20 m² Büyük Teras", "20 m² Üzeri Komple Ev"]
    },
    {
      "id": "sineklik_entegre",
      "label": "Entegre Sineklik Mekanizması",
      "type": "single",
      "required": true,
      "dependsOnId": "panjur_ici_sineklik",
      "dependsOnValue": ["Evet Sineklik de İstiyorum"],
      "options": ["Plise Akordeon", "Sabit Çerçeveli", "Sürgülü Duble Kasetli"]
    },
    {
      "id": "ekstra_panjur",
      "label": "Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "panjur_alan",
      "options": ["Akıllı Ev Otomasyon Röle Mobil", "Antrasit Özel Renk", "Eski Panjur Söküm Revizyon", "Ekstra İstemiyorum"]
    },
    {
      "id": "ekstra_panjur_sineklikli",
      "label": "Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "sineklik_entegre",
      "options": ["Kedi Köpek Çelik Tül", "Akıllı Ev Otomasyon", "Antrasit Renk", "Ekstra İstemiyorum"]
    },
    // KOMPLE PAKET DALI
    {
      "id": "panjur_tipi_paket",
      "label": "Panjur Tahrik Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Hem Panjur Hem Sineklik Komple Paket"],
      "options": ["Manuel Makaralı", "Motorlu Otomatik Uzaktan Kumandalı"]
    },
    {
      "id": "sineklik_tipi_paket",
      "label": "Sineklik Mekanizması",
      "type": "single",
      "required": true,
      "dependsOnId": "panjur_tipi_paket",
      "options": ["Plise Pileli", "Sabit Çerçeveli", "Sürgülü Duble Kasetli"]
    },
    {
      "id": "panjur_alan_paket",
      "label": "Panjur Toplam Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "sineklik_tipi_paket",
      "options": ["0-3 m²", "3-6 m²", "6-12 m²", "12-20 m²", "20 m² Üzeri"]
    },
    {
      "id": "ekstra_paket",
      "label": "Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "panjur_alan_paket",
      "options": ["Kedi Köpek Tülü Çelik", "Akıllı Ev Otomasyon", "Antrasit Özel Renk", "Eski Söküm Revizyon", "Ekstra İstemiyorum"]
    }
  ];
}