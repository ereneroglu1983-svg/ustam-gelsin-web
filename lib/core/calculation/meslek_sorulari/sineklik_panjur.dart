// lib/core/calculation/meslek_sorulari/sineklik_panjur.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class SineklikPanjurSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "hizmet_turu",
      "label": "Almak İstediğiniz Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sadece Sineklik Sistemleri",
        "Sadece Panjur Sistemleri",
        "Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"
      ]
    },

    // ========== SADECE SİNEKLİK YOLU ==========
    {
      "id": "sineklik_tipi",
      "label": "Sineklik Mekanizması ve Tül Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Sadece Sineklik Sistemleri"],
      "options": [
        "Plise (Pileli) Sineklik (Akordeon Katlanır Standart Sistem)",
        "Sabit Çerçeveli Sineklik (Ekonomik Mekanizmasız Çıkar-Tak)",
        "Sürgülü Sistem / Duble Kasetli Sineklik (Geniş Açıklıklar İçin Rulmanlı)"
      ]
    },

    // ========== SADECE PANJUR YOLU ==========
    {
      "id": "panjur_ici_sineklik_durum",
      "label": "Panjur Sistemine Entegre Sineklik İstiyor musunuz?",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Sadece Panjur Sistemleri"],
      "options": [
        "Evet, Panjura Ek Olarak Sineklik de İstiyorum",
        "Hayır, Sadece Panjur İmalatı Yapılsın"
      ]
    },
    {
      "id": "sineklik_tipi_panjur_ici",
      "label": "Entegre Sineklik Mekanizması",
      "type": "single",
      "required": true,
      "dependsOnId": "panjur_ici_sineklik_durum",
      "dependsOnValue": ["Evet, Panjura Ek Olarak Sineklik de İstiyorum"],
      "options": [
        "Plise (Pileli) Sineklik (Akordeon Katlanır Standart Sistem)",
        "Sabit Çerçeveli Sineklik (Ekonomik Mekanizmasız Çıkar-Tak)",
        "Sürgülü Sistem / Duble Kasetli Sineklik (Geniş Açıklıklar İçin Rulmanlı)"
      ]
    },

    // ========== KOMPLE PAKET YOLU ==========
    // Komple paket için sineklik tipi (ayrı id, aynı mantık)
    {
      "id": "sineklik_tipi_komple",
      "label": "Sineklik Mekanizması ve Tül Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"],
      "options": [
        "Plise (Pileli) Sineklik (Akordeon Katlanır Standart Sistem)",
        "Sabit Çerçeveli Sineklik (Ekonomik Mekanizmasız Çıkar-Tak)",
        "Sürgülü Sistem / Duble Kasetli Sineklik (Geniş Açıklıklar İçin Rulmanlı)"
      ]
    },

    // ADIM: PANJUR TİPİ - Sadece Panjur'da iç durum sonrası, Komple'de sineklik sonrası gelsin
    {
      "id": "panjur_tipi",
      "label": "Panjur Tahrik ve Kontrol Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": ["panjur_ici_sineklik_durum", "sineklik_tipi_panjur_ici", "sineklik_tipi_komple"],
      "dependsOnValue": [
        "Evet, Panjura Ek Olarak Sineklik de İstiyorum",
        "Hayır, Sadece Panjur İmalatı Yapılsın",
        "Plise (Pileli) Sineklik (Akordeon Katlanır Standart Sistem)",
        "Sabit Çerçeveli Sineklik (Ekonomik Mekanizmasız Çıkar-Tak)",
        "Sürgülü Sistem / Duble Kasetli Sineklik (Geniş Açıklıklar İçin Rulmanlı)"
      ],
      "options": [
        "Manuel Makaralı Panjur (Standart İpli / Duvar Makaralı Sistem)",
        "Motorlu / Otomatik Uzaktan Kumandalı Panjur (Tüp Motorlu Yüksek Torklu Sistem)"
      ]
    },

    // ADIM: PANJUR ALANI - panjur tipi sonrası gelsin
    {
      "id": "panjur_alani_secim",
      "label": "Panjur Yapılacak Tahmini Toplam Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "panjur_tipi",
      "dependsOnValue": [
        "Manuel Makaralı Panjur (Standart İpli / Duvar Makaralı Sistem)",
        "Motorlu / Otomatik Uzaktan Kumandalı Panjur (Tüp Motorlu Yüksek Torklu Sistem)"
      ],
      "options": [
        "0 - 3 m² Arası Küçük Pencere / Menfez",
        "3 - 6 m² Arası Standart Oda Pencereleri",
        "6 - 12 m² Arası Geniş Doğramalar / Balkon Kapıları",
        "12 - 20 m² Arası Büyük Alan / Teras Kapatma",
        "20 m² ve Üzeri Çoklu Komple Ev Panjur Projesi"
      ]
    },

    // ADIM: ORTAK DOĞRAMA ADEDİ - Sadece Sineklik'te sineklik sonrası, Panjur'da alan sonrası gelsin
    {
      "id": "dograma_adedi_secim",
      "label": "Montaj Yapılacak Toplam Doğrama Adedi (Pencere / Kapı)",
      "type": "single",
      "required": true,
      "dependsOnId": ["sineklik_tipi", "panjur_alani_secim"],
      "dependsOnValue": [
        "Plise (Pileli) Sineklik (Akordeon Katlanır Standart Sistem)",
        "Sabit Çerçeveli Sineklik (Ekonomik Mekanizmasız Çıkar-Tak)",
        "Sürgülü Sistem / Duble Kasetli Sineklik (Geniş Açıklıklar İçin Rulmanlı)",
        "0 - 3 m² Arası Küçük Pencere / Menfez",
        "3 - 6 m² Arası Standart Oda Pencereleri",
        "6 - 12 m² Arası Geniş Doğramalar / Balkon Kapıları",
        "12 - 20 m² Arası Büyük Alan / Teras Kapatma",
        "20 m² ve Üzeri Çoklu Komple Ev Panjur Projesi"
      ],
      "options": [
        "1 Adet (Tekil Değişim / Eksik Tamamlama)",
        "2 - 4 Adet Arası (Kısmi Yenileme)",
        "5 - 8 Adet Arası (Standart Daire Paket Kurulumu)",
        "9 - 14 Adet Arası (Geniş Daire / Dubleks / Müstakil)",
        "14 Adet Üzeri (Toplu İmalat / Villa Projesi)"
      ]
    },

    // ADIM: YAPI TİP - adedi sonrası gelsin
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Yapı Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "dograma_adedi_secim",
      "dependsOnValue": [
        "1 Adet (Tekil Değişim / Eksik Tamamlama)",
        "2 - 4 Adet Arası (Kısmi Yenileme)",
        "5 - 8 Adet Arası (Standart Daire Paket Kurulumu)",
        "9 - 14 Adet Arası (Geniş Daire / Dubleks / Müstakil)",
        "14 Adet Üzeri (Toplu İmalat / Villa Projesi)"
      ],
      "options": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri / Ticari Alan",
        "Yazlık / Bağ Evi"
      ]
    },

    // ADIM: MONTAJ ZEMİN - yapı tipi sonrası gelsin
    {
      "id": "montaj_zemin",
      "label": "Montaj Yapılacak Mevcut Doğrama Altyapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "dependsOnValue": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri / Ticari Alan",
        "Yazlık / Bağ Evi"
      ],
      "options": [
        "PVC Doğrama Hazır Kasa",
        "Alüminyum Doğrama Profil Üzeri",
        "Ahşap Çerçeve",
        "Mermer / Beton Zemin Üzeri (Dış Cephe Montajı)"
      ]
    },

    // ADIM FİNAL: EKSTRA - zemin sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Güvenlik Tülü, Otomasyon ve Profil Renk Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "montaj_zemin",
      "dependsOnValue": [
        "PVC Doğrama Hazır Kasa",
        "Alüminyum Doğrama Profil Üzeri",
        "Ahşap Çerçeve",
        "Mermer / Beton Zemin Üzeri (Dış Cephe Montajı)"
      ],
      "options": [
        "Kedi / Köpek Tülü (Yırtılmaz Mukavemetli Mikron Çelik Dokuma Tel)",
        "Akıllı Ev / Otomasyon Rölesi Entegrasyonu (Mobil Uygulama Kontrolü)",
        "Antrasit / Özel Renk Profil Profil Kaplama (Standart Beyaz Dışı Renk Farkı)",
        "Eski Panjur Sökümü / Revizyon ve Mekanizma Yenileme İşçiliği"
      ]
    }
  ];
}