// lib/core/calculation/meslek_sorulari/gunes_enerjisi.dart - FINAL
class GunesEnerjisiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "hizmet_turu",
      "label": "Hizmet Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Güneş Enerjisi Sıfırdan Kurulum", "Güneş Enerjisi Tamir Bakım Arıza", "Termosifon Satış Montaj"]
    },
    // KURULUM DALI
    {
      "id": "sistem_tipi",
      "label": "Enerji Isıtıcı Sistem Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Güneş Enerjisi Sıfırdan Kurulum"],
      "options": ["Vakum Tüplü Açık Devre Standart", "Basınçlı Kapalı Devre Antifrizli Eşanjörlü"]
    },
    {
      "id": "depo_malzemesi",
      "label": "Sıcak Su Depo Malzemesi",
      "type": "single",
      "required": true,
      "dependsOnId": "sistem_tipi",
      "options": ["304 Krom Paslanmaz Uzun Ömürlü", "Galvaniz Sac Ekonomik"]
    },
    {
      "id": "montaj_zemini",
      "label": "Montaj Zemin Çatı Yapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "depo_malzemesi",
      "options": ["Düz Beton Teras", "Eğimli Kiremit Çatı İskeleli", "Sandviç Panel Sac Çatı"]
    },
    {
      "id": "kapasite_segmenti",
      "label": "Sistem Kapasite Hacim Segmenti",
      "type": "single",
      "required": true,
      "dependsOnId": "montaj_zemini",
      "options": ["1-2 Daire Küçük Aile Tipi", "3-5 Daire Orta Ölçek Ortak", "Merkezi Sistem Apartman Otel Ticari"]
    },
    {
      "id": "ekstra_kurulum",
      "label": "Teknik Takviye ve Koruma Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "kapasite_segmenti",
      "options": [
        "Elektrikli Rezistans Termostatlı Kış Takviyesi",
        "Pompa Hidrofor Basınç Pompası",
        "Yalıtım Paketi UV Kauçuk Boru Kaplama",
        "Ekstra İstemiyorum"
      ]
    },
    // TAMİR DALI
    {
      "id": "tamir_bakim_detayi",
      "label": "Arıza Hasar Bakım Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Güneş Enerjisi Tamir Bakım Arıza"],
      "options": [
        "Vakum Tüp Cam Kırılması Değişim",
        "Depo Sızıntı Kazan Kaynak Değişim",
        "Şamandıra Vana Boru Kaçak Onarım",
        "Kışlık Bakım Antifriz Panel Temizlik"
      ]
    },
    // TERMOSİFON DALI
    {
      "id": "termosifon_detayi",
      "label": "Termosifon Uygulama Kapsamı",
      "type": "single",
      "required": true,
      "dependsOnId": "hizmet_turu",
      "dependsOnValue": ["Termosifon Satış Montaj"],
      "options": ["Sadece Montaj Cihaz Müşteride", "Cihaz Dahil Anahtar Teslim", "Eski Söküm Yeni Değişim Montaj"]
    },
    {
      "id": "termosifon_kapasite",
      "label": "Termosifon Kapasite",
      "type": "single",
      "required": true,
      "dependsOnId": "termosifon_detayi",
      "options": ["50-65 Litre Küçük", "80 Litre Standart", "100 Litre Geniş", "120 Litre Üzeri Büyük"]
    }
  ];
}