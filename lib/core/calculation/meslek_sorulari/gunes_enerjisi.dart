// lib/core/calculation/meslek_sorulari/gunes_enerjisi.dart

class GunesEnerjisiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "hizmet_turu", // 🛠️ ANA TETİKLEYİCİ: Kurulum, tamir ve termosifon akışlarını jilet gibi ayıran kilit anahtar
      "label": "Talep Edilen Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Güneş Enerjisi Sistemi Sıfırdan Kurulum",
        "Güneş Enerjisi Tamir, Bakım veya Arıza Onarımı",
        "Termosifon Satış ve Montaj Hizmeti"
      ]
    },

    // ==========================================
    // ☀️ GRUP 1: SIFIRDAN GÜNEŞ ENERJİSİ KURULUMU
    // ==========================================
    {
      "id": "sistem_tipi",
      "label": "Kurulacak Enerji veya Isıtıcı Sistem Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Güneş Enerjisi Sistemi Sıfırdan Kurulum"],
      "options": [
        "Vakum Tüplü (Açık Devre) Standart Sistem",
        "Basınçlı (Kapalı Devre) Şebeke Basıncına Dayanıklı Antifrizli Eşanjörlü Sistem"
      ]
    },
    {
      "id": "depo_malzemesi",
      "label": "Sıcak Su Tankı Depo Malzemesi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Güneş Enerjisi Sistemi Sıfırdan Kurulum"],
      "options": [
        "304 Kalite Krom Paslanmaz Depo Malzemesi (Uzun Ömürlü High-End)",
        "Galvaniz Sac Depo Malzemesi (Ekonomik Seri)"
      ]
    },
    {
      "id": "montaj_zemini",
      "label": "Montajın Yapılacağı Zemin ve Çatı Yapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Güneş Enerjisi Sistemi Sıfırdan Kurulum"],
      "options": [
        "Düz Beton Teras Zemini",
        "Eğimli Kiremit Çatı Zemini (Kiremit Altı Saplama ve İskele İşçilikli)",
        "Sandviç Panel / Sac Çatı Zemini"
      ]
    },
    {
      "id": "kapasite_segmenti", // 🛠️ FIX: ARTIK ANA EKRANDA GİZLİ! Sadece Sıfırdan Kurulum seçilirse açılır.
      "label": "Sistem Kapasitesi ve Hacim Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Güneş Enerjisi Sistemi Sıfırdan Kurulum"],
      "options": [
        "1-2 Dairelik / Küçük Aile Tipi (Standart Tank)",
        "3-5 Dairelik / Orta Ölçek Ortak Kullanım Sistemi",
        "Merkezi Sistem (Apartman Tipi / Otel / Geniş Ticari Ölçü)"
      ]
    },

    // ==========================================
    // 🛠️ GRUP 2: GÜNEŞ ENERJİSİ TAMİR VE BAKIM
    // ==========================================
    {
      "id": "tamir_bakim_detayi",
      "label": "Arıza, Hasar veya Bakım Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Güneş Enerjisi Tamir, Bakım veya Arıza Onarımı"],
      "options": [
        "Vakum Tüp / Cam Kırılması (Cam Değişim Hizmeti)",
        "Sıcak/Soğuk Su Depo Sızıntısı (Kazan Değişimi veya Kaynak İşçiliği)",
        "Şamandıra, Vana veya Tesisat Borusu Kaçak Onarımı",
        "Kışlık Bakım (Antifriz Kimyasal Dolumu ve Panel Genel Temizliği)"
      ]
    },

    // ==========================================
    // 🔌 GRUP 3: TERMOSİFON SATIŞ VE MONTAJ
    // ==========================================
    {
      "id": "termosifon_detayi",
      "label": "Termosifon Uygulama Kapsamı",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Termosifon Satış ve Montaj Hizmeti"],
      "options": [
        "Sadece Montaj İşçiliği (Cihaz Müşteriye Ait)",
        "Cihaz Dahil Anahtar Teslim Satış + Montaj İşçiliği",
        "Eski Termosifon Sökümü ve Yeni Cihaz Değişim Montajı"
      ]
    },

    // ==========================================
    // ⚙️ GENEL PARAMETRELER VE EKSTRALAR
    // ==========================================
    {
      "id": "ekstra_ozellikler",
      "label": "Teknik Takviyeler, Tesisat ve Koruma Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Güneş Enerjisi Sistemi Sıfırdan Kurulum"],
      "options": [
        "Rezidans / Elektrikli Isıtıcı Takviyesi (Kış Ayları İçin Termostatlı Rezistans)",
        "Pompa / Hidrofor Entegrasyonu (Sıcak Suyu Aşağı Basan Sessiz Basınç Pompası)",
        "Yalıtım / İzolasyon Paketi (Boruların UV Dayanımlı Folyolu Kauçuk ile Kaplanması)"
      ]
    }
  ];
}