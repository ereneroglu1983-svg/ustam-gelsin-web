// lib/core/calculation/meslek_sorulari/gunes_enerjisi.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class GunesEnerjisiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "hizmet_turu",
      "label": "Talep Edilen Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Güneş Enerjisi Sistemi Sıfırdan Kurulum",
        "Güneş Enerjisi Tamir, Bakım veya Arıza Onarımı",
        "Termosifon Satış ve Montaj Hizmeti"
      ]
    },

    // ========== SIFIRDAN KURULUM ZİNCİRİ ==========
    // ADIM 2: SİSTEM TİPİ
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

    // ADIM 3: DEPO MALZEMESİ - sistem sonrası gelsin
    {
      "id": "depo_malzemesi",
      "label": "Sıcak Su Tankı Depo Malzemesi Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "sistem_tipi",
      "dependsOnValue": [
        "Vakum Tüplü (Açık Devre) Standart Sistem",
        "Basınçlı (Kapalı Devre) Şebeke Basıncına Dayanıklı Antifrizli Eşanjörlü Sistem"
      ],
      "options": [
        "304 Kalite Krom Paslanmaz Depo Malzemesi (Uzun Ömürlü High-End)",
        "Galvaniz Sac Depo Malzemesi (Ekonomik Seri)"
      ]
    },

    // ADIM 4: MONTAJ ZEMİNİ - depo sonrası gelsin
    {
      "id": "montaj_zemini",
      "label": "Montajın Yapılacağı Zemin ve Çatı Yapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "depo_malzemesi",
      "dependsOnValue": [
        "304 Kalite Krom Paslanmaz Depo Malzemesi (Uzun Ömürlü High-End)",
        "Galvaniz Sac Depo Malzemesi (Ekonomik Seri)"
      ],
      "options": [
        "Düz Beton Teras Zemini",
        "Eğimli Kiremit Çatı Zemini (Kiremit Altı Saplama ve İskele İşçilikli)",
        "Sandviç Panel / Sac Çatı Zemini"
      ]
    },

    // ADIM 5: KAPASİTE - montaj zemini sonrası gelsin
    {
      "id": "kapasite_segmenti",
      "label": "Sistem Kapasitesi ve Hacim Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_zemini",
      "dependsOnValue": [
        "Düz Beton Teras Zemini",
        "Eğimli Kiremit Çatı Zemini (Kiremit Altı Saplama ve İskele İşçilikli)",
        "Sandviç Panel / Sac Çatı Zemini"
      ],
      "options": [
        "1-2 Dairelik / Küçük Aile Tipi (Standart Tank)",
        "3-5 Dairelik / Orta Ölçek Ortak Kullanım Sistemi",
        "Merkezi Sistem (Apartman Tipi / Otel / Geniş Ticari Ölçü)"
      ]
    },

    // ADIM 6: FİNAL EKSTRA - kapasite sonrası yeşil kutuda açılsın
    {
      "id": "ekstra_ozellikler",
      "label": "Teknik Takviyeler, Tesisat ve Koruma Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "kapasite_segmenti",
      "dependsOnValue": [
        "1-2 Dairelik / Küçük Aile Tipi (Standart Tank)",
        "3-5 Dairelik / Orta Ölçek Ortak Kullanım Sistemi",
        "Merkezi Sistem (Apartman Tipi / Otel / Geniş Ticari Ölçü)"
      ],
      "options": [
        "Rezidans / Elektrikli Isıtıcı Takviyesi (Kış Ayları İçin Termostatlı Rezistans)",
        "Pompa / Hidrofor Entegrasyonu (Sıcak Suyu Aşağı Basan Sessiz Basınç Pompası)",
        "Yalıtım / İzolasyon Paketi (Boruların UV Dayanımlı Folyolu Kauçuk ile Kaplanması)"
      ]
    },

    // ========== TAMİR YOLU - direkt kökten tek başına ==========
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

    // ========== TERMOSİFON YOLU - direkt kökten tek başına ==========
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
    }
  ];
}