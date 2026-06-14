class BinaTemizlikSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "temizlik_turu",
      "label": "Temizlik Türü ve Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "İnşaat Sonrası Kaba Temizlik (Moloz, Alçı ve Harç Kaldırma)",
        "İnşaat Sonrası Detaylı / İnce Temizlik (Boya Sökme, İnce Toz ve Cam Kazıma)",
        "Ofis / İşyeri Genel Temizliği (Periyodik veya Tek Seferlik Düzenleme)",
        "Bina Merdiven / Ortak Alan Temizliği",
        "Dış Cephe Cam Temizliği (Plaza, Gökdelen ve Otel Cam Yüzeyleri)"
      ]
    },
    {
      "id": "alan_m2",
      "label": "Temizlik Yapılacak Toplam Alan (Net m²)",
      "type": "text",
      "keyboardType": "number",
      "required": true,
      "hint": "Örn: 150"
    },
    {
      "id": "oda_bölüm_sayisi",
      "label": "Toplam Oda / Bölüm Sayısı",
      "type": "text",
      "keyboardType": "number",
      "required": true,
      "hint": "Örn: 5"
    },
    {
      "id": "erisim_yontemi",
      "label": "Dış Cephe Erişim Yöntemi",
      "type": "single",
      "required": true,
      "dependsOnId": "temizlik_turu",
      "dependsOnValue": [
        "Dış Cephe Cam Temizliği (Plaza, Gökdelen ve Otel Cam Yüzeyleri)"
      ],
      "options": [
        "Yerden Uzatma Aparatı / Teleskobik Boru (Alçak Katlar İçin)",
        "Vinç / Sepet Gerektirir (Günlük Platform Vinç Kiralama Dahil)",
        "Dış Cephe Asansör Sistemi Var (Bina Bünyesindeki Sepet Kullanılacak)",
        "Dağcı Ekibi (Rope Access) İhtiyacı (İple Erişim Sertifikalı Personel)"
      ]
    },
    {
      "id": "yapi_tip",
      "label": "Yapı Yapısal Tipi",
      "type": "single",
      "required": true,
      "options": [
        "Plaza / Gökdelen",
        "Alçak Katlı Ofis",
        "Villa / Müstakil Ev",
        "Otel / Okul / Kamu Binası"
      ]
    },
    {
      "id": "periyot",
      "label": "Hizmet Sıklığı (Periyot Planlaması)",
      "type": "single",
      "required": true,
      "options": [
        "Tek Seferlik Hizmet",
        "Aylık Düzenli Hizmet",
        "3 Aylık Periyot",
        "6 Aylık Periyot"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Ek Hizmet Talepleri",
      "type": "multi",
      "required": false,
      "options": [
        "Zemin Cilalama ve Cilalama Makinesi Uygulaması (Mermer/PVC Parlatma)",
        "Buharlı Dezenfeksiyon ve Sterilizasyon Hizmeti (Yüksek Basınçlı Hijyen)",
        "Kimyasal Alçı ve Harç Sökümü İşçiliği (İnşaat Sonrası Ağır Lekeler İçin)",
        "Cam Silimi (İç Mekan İçin Cam Ekstrası)"
      ]
    }
  ];
}