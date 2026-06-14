// lib/core/calculation/meslek_sorulari/cam_balkon.dart

class CamBalkonSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "sistem_tipi",
      "label": "Cam Balkon Sistem Türü",
      "type": "single",
      "required": true,
      "options": [
        "Katlanır Cam Balkon (8mm Klasik Temperli Tek Cam)",
        "Sürgülü Cam Balkon (Eşikli / Eşiksiz Sürme Sistem)",
        "Giyotin Cam (Motorlu / Dikey Hareketli Uzaktan Kumandalı)",
        "Isıcamlı Cam Balkon (Yüksek Isı Yalıtımlı Konfor Çift Cam Serisi)"
      ]
    },
    {
      "id": "motor_marka_secimi",
      "label": "Giyotin Sistemi Motor Teknoloji Sınıfı",
      "type": "single",
      "required": true,
      "dependsOnId": "sistem_tipi",
      "dependsOnValue": [
        "Giyotin Cam (Motorlu / Dikey Hareketli Uzaktan Kumandalı)"
      ],
      "options": [
        "Somfy Motor (Avrupa Üst Segment - Akıllı Ev Entegreli Akustik)",
        "Becker / Cherubini (Avrupa Dayanıklı Orta-Üst Segment)",
        "Yerli / Yerel Marka (Ekonomik Tork Motoru Sistemi)",
        "Motor Markası Fark Etmez (Usta Standart Garantili Motor Taksın)"
      ]
    },
    {
      "id": "alan_segmenti", // 🛠️ TEK VE ANA METRAJ BELİRLEYİCİ: Text alanı kaldırıldı, tamamen bu seçmeli sekme yönetiyor.
      "label": "Tahmini Kapatılacak Yaklaşık Cam Alanı",
      "type": "single",
      "required": true,
      "options": [
        "0 - 5 m² Arası Küçük Balkon",
        "5 - 10 m² Arası Standart Balkon",
        "10 - 20 m² Arası Geniş Balkon / Teras",
        "20 - 40 m² Arası Büyük Alan / Kış Bahçesi",
        "40 m² ve Üzeri Ticari / Restoran Cephe Kapatma"
      ]
    },
    {
      "id": "cam_rengi",
      "label": "Temperli Cam Renk Tercihi",
      "type": "single",
      "required": true,
      "options": [
        "Şeffaf Cam (Standart Şeffaf Temperli)",
        "Füme Cam (Güneş Kırıcı Koyu Renkli)",
        "Bronz veya Mavi Cam (Mimari Estetik Renkli Seriler)"
      ]
    },
    {
      "id": "profil_rengi",
      "label": "Alüminyum Profil (Kasa) Rengi",
      "type": "single",
      "required": true,
      "options": [
        "Eloksal Naturel (Gri / Mat Alüminyum)",
        "Antrasit Gri veya Siyah Toz Fırın Boya (Ral Kodu)",
        "Beyaz Boyalı Kasa",
        "Ahşap Desenli Özel Transfer Kaplama Profil"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Mimari Yapı, Emniyet ve Donanım Ekstraları",
      "type": "multi",
      "options": [
        "Kavisli / Açılı Balkon Yapısı (Köşe Dönüşlü / Oval Dönüş İşçilik Farkı)",
        "Plise Perde Sistemi Entegrasyonu (Cam Balkona Özel Akordeon Perde Paketi)",
        "Ekstra Güvenlikli Çocuk Kilit Sistemi Kurulumu",
        "Pileli Sineklik Sistemi Entegrasyonu (Kanat Önü Koruma Tülü)"
      ]
    }
  ];
}