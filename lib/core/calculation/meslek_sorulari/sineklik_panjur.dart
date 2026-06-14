// lib/core/calculation/meslek_sorulari/sineklik_panjur.dart

class SineklikPanjurSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "hizmet_turu", // 🛠️ EN ANA TETİKLEYİCİ (İlk başta SADECE bu görünür)
      "label": "Almak İstediğiniz Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sadece Sineklik Sistemleri",
        "Sadece Panjur Sistemleri",
        "Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"
      ]
    },

    // ==========================================
    // 🔍 PANJUR SEÇENLER İÇİN ÖZEL İÇ SİNEKLİK SORGUSU
    // ==========================================
    {
      "id": "panjur_ici_sineklik_durum", // 🛠️ PANJURUN İÇİNE GÖMÜLEN KONTROL
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

    // ==========================================
    // 🚪 SİNEKLİK MEKANİZMA SEÇİMİ (Sineklik içeren tüm senaryolarda açılır)
    // ==========================================
    {
      "id": "sineklik_tipi",
      "label": "Sineklik Mekanizması ve Tül Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sadece Sineklik Sistemleri",
        "Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"
      ],
      "options": [
        "Plise (Pileli) Sineklik (Akordeon Katlanır Standart Sistem)",
        "Sabit Çerçeveli Sineklik (Ekonomik Mekanizmasız Çıkar-Tak)",
        "Sürgülü Sistem / Duble Kasetli Sineklik (Geniş Açıklıklar İçin Rulmanlı)"
      ]
    },
    {
      "id": "sineklik_tipi_panjur_ici", // 🛠️ Panjur içinden "Evet" diyenler için açılan sineklik tipi
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

    // ==========================================
    // 📊 PANJUR MEKANİZMA VE ÖLÇÜ AKIŞI (Panjur içeren tüm senaryolarda açılır)
    // ==========================================
    {
      "id": "panjur_tipi",
      "label": "Panjur Tahrik ve Kontrol Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sadece Panjur Sistemleri",
        "Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"
      ],
      "options": [
        "Manuel Makaralı Panjur (Standart İpli / Duvar Makaralı Sistem)",
        "Motorlu / Otomatik Uzaktan Kumandalı Panjur (Tüp Motorlu Yüksek Torklu Sistem)"
      ]
    },
    {
      "id": "panjur_alani_secim",
      "label": "Panjur Yapılacak Tahmini Toplam Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sadece Panjur Sistemleri",
        "Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"
      ],
      "options": [
        "0 - 3 m² Arası Küçük Pencere / Menfez",
        "3 - 6 m² Arası Standart Oda Pencereleri",
        "6 - 12 m² Arası Geniş Doğramalar / Balkon Kapıları",
        "12 - 20 m² Arası Büyük Alan / Teras Kapatma",
        "20 m² ve Üzeri Çoklu Komple Ev Panjur Projesi"
      ]
    },

    // ==========================================
    // 📐 GLOBAL TEKNİK ÖZELLİKLER (İlk sorudan herhangi biri seçildiği an açılır)
    // ==========================================
    {
      "id": "dograma_adedi_secim",
      "label": "Montaj Yapılacak Toplam Doğrama Adedi (Pencere / Kapı)",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sadece Sineklik Sistemleri",
        "Sadece Panjur Sistemleri",
        "Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"
      ],
      "options": [
        "1 Adet (Tekil Değişim / Eksik Tamamlama)",
        "2 - 4 Adet Arası (Kısmi Yenileme)",
        "5 - 8 Adet Arası (Standart Daire Paket Kurulumu)",
        "9 - 14 Adet Arası (Geniş Daire / Dubleks / Müstakil)",
        "14 Adet Üzeri (Toplu İmalat / Villa Projesi)"
      ]
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Yapı Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sadece Sineklik Sistemleri",
        "Sadece Panjur Sistemleri",
        "Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"
      ],
      "options": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri / Ticari Alan",
        "Yazlık / Bağ Evi"
      ]
    },
    {
      "id": "montaj_zemin",
      "label": "Montaj Yapılacak Mevcut Doğrama Altyapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sadece Sineklik Sistemleri",
        "Sadece Panjur Sistemleri",
        "Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"
      ],
      "options": [
        "PVC Doğrama Hazır Kasa",
        "Alüminyum Doğrama Profil Üzeri",
        "Ahşap Çerçeve",
        "Mermer / Beton Zemin Üzeri (Dış Cephe Montajı)"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Güvenlik Tülü, Otomasyon ve Profil Renk Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": [
        "Sadece Sineklik Sistemleri",
        "Sadece Panjur Sistemleri",
        "Hem Panjur Hem Sineklik Sistemleri (Komple Paket)"
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