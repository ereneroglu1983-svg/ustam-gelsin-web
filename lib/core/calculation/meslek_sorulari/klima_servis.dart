// lib/core/calculation/meslek_sorulari/klima.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class KlimaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Talep Edilen Ana Teknik Servis İşlemi",
      "type": "single",
      "required": true,
      "options": [
        "Periyodik Bakım (İlaçlı İç / Dış Ünite Temizliği ve Filtre Dezenfeksiyonu)",
        "Montaj (Sadece Kurulum - Vakumlama, Konsol Montajı ve Devreye Alma)",
        "Sökme + Montaj (Yer Değişimi - Pump-Down Gaz Toplama, Demontaj ve Yeniden Kurulum)",
        "Gaz Basımı / Şarj Hizmeti (Sistem Kaçak Kontrolü, Vakum ve Tam Kat Gaz Şarjı)"
      ]
    },

    // ADIM 2: MONTAJ YÜZEYİ - sadece Montaj ve Sökme+Montaj'da gelsin
    {
      "id": "montaj_yuzeyi",
      "label": "Dış Ünitenin Monte Edileceği Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Montaj (Sadece Kurulum - Vakumlama, Konsol Montajı ve Devreye Alma)",
        "Sökme + Montaj (Yer Değişimi - Pump-Down Gaz Toplama, Demontaj ve Yeniden Kurulum)"
      ],
      "options": [
        "Dış Cephe Duvarı (Konsol Bağlantılı)",
        "Çatı / Teras Zemini",
        "Balkon Korkuluğu / Balkon İçi Zemin",
        "Hazır Klima Askısı / Hazır Altyapı Yuvası"
      ]
    },

    // ADIM 3: KAT DURUMU - montaj yüzeyi sonrası gelsin
    {
      "id": "kat_durumu",
      "label": "Montaj Yapılacak Kat ve Yükseklik Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_yuzeyi",
      "dependsOnValue": [
        "Dış Cephe Duvarı (Konsol Bağlantılı)",
        "Çatı / Teras Zemini",
        "Balkon Korkuluğu / Balkon İçi Zemin",
        "Hazır Klima Askısı / Hazır Altyapı Yuvası"
      ],
      "options": [
        "Zemin Kat / Kolay Erişilebilir Bahçe-Balkon",
        "1. - 3. Kat Arası (Standart Merdiven/Uzatma İle Erişilebilir)",
        "4. Kat ve Üzeri (Dış Cephe Riskli / Vinç veya Sepetli Platform Gerekebilir)"
      ]
    },

    // ADIM 4: CİHAZ KAPASİTESİ - Montaj yolunda kat sonrası, Bakım/Gaz yolunda direkt kökten gelsin
    {
      "id": "cihaz_kapasitesi",
      "label": "Klima Kapasitesi ve Cihaz Formu",
      "type": "single",
      "required": true,
      "dependsOnId": ["kat_durumu", "is_kapsami"],
      "dependsOnValue": [
        "Zemin Kat / Kolay Erişilebilir Bahçe-Balkon",
        "1. - 3. Kat Arası (Standart Merdiven/Uzatma İle Erişilebilir)",
        "4. Kat ve Üzeri (Dış Cephe Riskli / Vinç veya Sepetli Platform Gerekebilir)",
        "Periyodik Bakım (İlaçlı İç / Dış Ünite Temizliği ve Filtre Dezenfeksiyonu)",
        "Gaz Basımı / Şarj Hizmeti (Sistem Kaçak Kontrolü, Vakum ve Tam Kat Gaz Şarjı)"
      ],
      "options": [
        "9.000 - 12.000 BTU (Standart Duvar Tipi Split)",
        "18.000 - 24.000 BTU (Geniş Alan / Ağır Dış Ünite Çift Usta Mesaisi)",
        "Salon Tipi (Ayaklı) / Kaset ve Kanallı Tip (Tavan Tipi Karmaşık Drenaj)"
      ]
    },

    // ADIM 5: CİHAZ SAYISI - kapasite sonrası gelsin
    {
      "id": "cihaz_sayisi",
      "label": "İşlem Yapılacak Toplam Klima Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "cihaz_kapasitesi",
      "dependsOnValue": [
        "9.000 - 12.000 BTU (Standart Duvar Tipi Split)",
        "18.000 - 24.000 BTU (Geniş Alan / Ağır Dış Ünite Çift Usta Mesaisi)",
        "Salon Tipi (Ayaklı) / Kaset ve Kanallı Tip (Tavan Tipi Karmaşık Drenaj)"
      ],
      "options": [
        "1 Cihaz",
        "2-3 Cihaz Arası",
        "4-10 Cihaz Arası",
        "10 Cihaz ve Üzeri"
      ]
    },

    // ADIM 6: NET ADET - sayı sonrası gelsin
    {
      "id": "adet",
      "label": "Net Cihaz Sayısı (Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 2",
      "dependsOnId": "cihaz_sayisi",
      "dependsOnValue": [
        "1 Cihaz",
        "2-3 Cihaz Arası",
        "4-10 Cihaz Arası",
        "10 Cihaz ve Üzeri"
      ]
    },

    // ADIM 7: YAPI TİP - adet sonrası (adet boş geçilebilir, o yüzden hem adet hem cihaz_sayisi'ne bağlı)
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Yapı Türü",
      "type": "single",
      "required": true,
      "dependsOnId": ["cihaz_sayisi", "adet"],
      "dependsOnValue": [
        "1 Cihaz",
        "2-3 Cihaz Arası",
        "4-10 Cihaz Arası",
        "10 Cihaz ve Üzeri",
        "1",
        "2",
        "3",
        "4",
        "5"
      ],
      "options": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri / Mağaza",
        "Fabrika / Endüstriyel Büyük Alan"
      ]
    },

    // ADIM 8: ELEKTRİK HAT - yapı sonrası gelsin
    {
      "id": "elektrik_hat",
      "label": "Elektrik Besleme Hattı Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "yapi_tip",
      "dependsOnValue": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri / Mağaza",
        "Fabrika / Endüstriyel Büyük Alan"
      ],
      "options": [
        "Hat Hazır (Klima Yanında Priz veya Şalter Sigortası Mevcut)",
        "Hat Çekilmesi Gerekiyor (Panodan İlgili Noktaya Kablo Çekimi)"
      ]
    },

    // ADIM 9: FİNAL EKSTRA - elektrik hat sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Ekstra Sarf Malzeme ve İlave Teknik İşlemler",
      "type": "multi",
      "required": false,
      "dependsOnId": "elektrik_hat",
      "dependsOnValue": [
        "Hat Hazır (Klima Yanında Priz veya Şalter Sigortası Mevcut)",
        "Hat Çekilmesi Gerekiyor (Panodan İlgili Noktaya Kablo Çekimi)"
      ],
      "options": [
        "Ekstra Bakır Boru Tedariği (Varsayılan Mesafe Üzerinden İlave İzoleli Hat)",
        "Dış Ünite Konsol Seti Değişimi (Kauçuk Takozlu Paslanmaz Ağır Hizmet Konsolu)",
        "Kaçak Tespiti / Azot Testi Uygulaması (Sisteme Azot Basılarak Sızıntı Aranması)",
        "Drenaj Pompası Montajı (Su Tahliyesi Zor Alanlar İçin Otomatik Tahliye Pompası)"
      ]
    }
  ];
}