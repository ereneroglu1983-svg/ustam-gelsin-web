// lib/core/calculation/meslek_sorulari/klima.dart

class KlimaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ KİLİT TETİKLEYİCİ: En başta yer alan ana iş kapsamı sorusu
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

    // ==========================================
    // 🏗️ GRUP 1: MONTAJ VE KURULUM ZORLUK SORULARI
    // ==========================================
    {
      "id": "montaj_yuzeyi", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue mimarisine geçirildi
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
    {
      "id": "kat_durumu", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue mimarisine geçirildi
      "label": "Montaj Yapılacak Kat ve Yükseklik Seviyesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Montaj (Sadece Kurulum - Vakumlama, Konsol Montajı ve Devreye Alma)",
        "Sökme + Montaj (Yer Değişimi - Pump-Down Gaz Toplama, Demontaj ve Yeniden Kurulum)"
      ],
      "options": [
        "Zemin Kat / Kolay Erişilebilir Bahçe-Balkon",
        "1. - 3. Kat Arası (Standart Merdiven/Uzatma İle Erişilebilir)",
        "4. Kat ve Üzeri (Dış Cephe Riskli / Vinç veya Sepetli Platform Gerekebilir)"
      ]
    },

    // ==========================================
    // ⚙️ TEKNİK PARAMETRELER VE KAPASİTE
    // ==========================================
    {
      "id": "cihaz_kapasitesi",
      "label": "Klima Kapasitesi ve Cihaz Formu",
      "type": "single",
      "required": true,
      "options": [
        "9.000 - 12.000 BTU (Standart Duvar Tipi Split)",
        "18.000 - 24.000 BTU (Geniş Alan / Ağır Dış Ünite Çift Usta Mesaisi)",
        "Salon Tipi (Ayaklı) / Kaset ve Kanallı Tip (Tavan Tipi Karmaşık Drenaj)"
      ]
    },
    {
      "id": "cihaz_sayisi",
      "label": "İşlem Yapılacak Toplam Klima Sayısı",
      "type": "single",
      "required": true,
      "options": [
        "1 Cihaz",
        "2-3 Cihaz Arası",
        "4-10 Cihaz Arası",
        "10 Cihaz ve Üzeri"
      ]
    },
    {
      "id": "adet",
      "label": "Net Cihaz Sayısı (Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 2"
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Yapı Türü",
      "type": "single",
      "required": true,
      "options": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri / Mağaza",
        "Fabrika / Endüstriyel Büyük Alan"
      ]
    },
    {
      "id": "elektrik_hat",
      "label": "Elektrik Besleme Hattı Durumu",
      "type": "single",
      "required": true,
      "options": [
        "Hat Hazır (Klima Yanında Priz veya Şalter Sigortası Mevcut)",
        "Hat Çekilmesi Gerekiyor (Panodan İlgili Noktaya Kablo Çekimi)"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Ekstra Sarf Malzeme ve İlave Teknik İşlemler",
      "type": "multi",
      "required": false,
      "options": [
        "Ekstra Bakır Boru Tedariği (Varsayılan Mesafe Üzerinden İlave İzoleli Hat)",
        "Dış Ünite Konsol Seti Değişimi (Kauçuk Takozlu Paslanmaz Ağır Hizmet Konsolu)",
        "Kaçak Tespiti / Azot Testi Uygulaması (Sisteme Azot Basılarak Sızıntı Aranması)",
        "Drenaj Pompası Montajı (Su Tahliyesi Zor Alanlar İçin Otomatik Tahliye Pompası)"
      ]
    }
  ];
}