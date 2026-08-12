// lib/core/calculation/meslek_sorulari/uydu_kamera.dart - FINAL
class UyduKameraSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Ana İş Türü Altyapı Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Güvenlik Kamerası IP NVR", "Merkezi Bireysel Uydu TV Kurulum", "İnternet Network Kablolama Rack Düzenleme"]
    },
    // GÜVENLİK DALI
    {
      "id": "mekan_kamera",
      "label": "Mekan Yapı Mimari Sınıf",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Güvenlik Kamerası IP NVR"],
      "options": ["Daire Asma Tavan Süpürgelik Kolay Hat", "Villa Müstakil Geniş Bahçe Toprak Altı Borulama", "Fabrika Site Depo Galvaniz Tava Yüksek İrtifa"]
    },
    {
      "id": "kamera_teknik",
      "label": "Kamera Mercek Çözünürlük Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "mekan_kamera",
      "options": ["Full HD Kızılötesi Sabit Lens", "4K Ultra HD Geniş Açı Dijital Zoom Premium", "AI Yüz Tanıma Plaka Analitik", "Full Color Renkli Gece Görüş Ses Çift Yönlü"]
    },
    {
      "id": "nokta_kamera",
      "label": "Toplam Nokta Sayısı Kamera",
      "type": "single",
      "required": true,
      "dependsOnId": "kamera_teknik",
      "options": ["1-4 Nokta Küçük", "4-8 Nokta Standart Konut Ofis", "8-16 Nokta Geniş Villa", "16-32 Nokta Büyük İşletme Site Fabrika", "32+ Endüstriyel Komple"]
    },
    {
      "id": "kablo_kamera",
      "label": "Kablolama Teknolojisi Estetik",
      "type": "single",
      "required": true,
      "dependsOnId": "nokta_kamera",
      "options": ["UTP Cat6 PoE Bakır Kanal", "Fiber Optik Pigtail Füzyon Ek", "Sıva Altı Kırım Spiral Boru Alçı Rütuş"]
    },
    {
      "id": "ekstra_kamera",
      "label": "Lens AI Erişim Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "kablo_kamera",
      "options": ["4K Ultra HD Fark Entegrasyon", "AI Akıllı Analitik Sensör", "PTZ Motorize Pan Tilt Zoom Otomatik Takip", "Yüksek İrtifa Vinç Platform Sepetli", "UPS Kesintisiz Güç Akü Kit", "Ekstra İstemiyorum"]
    },
    // UYDU DALI
    {
      "id": "mekan_uydu",
      "label": "Mekan Yapı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Merkezi Bireysel Uydu TV Kurulum"],
      "options": ["Daire İç Mekan", "Villa Müstakil", "Fabrika Site Depo"]
    },
    {
      "id": "uydu_tip",
      "label": "Uydu Altyapı Dağıtım Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "mekan_uydu",
      "options": ["Merkezi Santral Çoklu Multiswitch", "Bireysel Çanak Balkon Çatı Tek LNB", "Mevcut Hat Sinyal Ayar Frekans Optimizasyon", "Komple Splitter LNB Koaksiyel Kablo Değişim"]
    },
    {
      "id": "nokta_uydu",
      "label": "Uydu Uç Nokta Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "uydu_tip",
      "options": ["1-4 Nokta Küçük", "4-8 Nokta Standart", "8-16 Nokta Geniş", "16-32 Nokta Büyük", "32+ Komple"]
    },
    {
      "id": "kablo_uydu",
      "label": "Kablolama",
      "type": "single",
      "required": true,
      "dependsOnId": "nokta_uydu",
      "options": ["UTP Kanal", "Fiber Füzyon", "Sıva Altı Kırım Spiral"]
    },
    {
      "id": "ekstra_uydu",
      "label": "Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "kablo_uydu",
      "options": ["Yüksek İrtifa Vinç", "UPS Akü Kit", "Ekstra İstemiyorum"]
    },
    // NETWORK DALI
    {
      "id": "mekan_net",
      "label": "Mekan Yapı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["İnternet Network Kablolama Rack Düzenleme"],
      "options": ["Daire", "Villa Müstakil", "Fabrika Site Depo Tava Montaj"]
    },
    {
      "id": "network_tur",
      "label": "Network Donanım Dağıtım Altyapısı",
      "type": "single",
      "required": true,
      "dependsOnId": "mekan_net",
      "options": ["Kablosuz Access Point Mesh Kapsama Genişletme", "Sıfırdan Sistem Odası Rack Patch Panel Switch", "Kurumsal Ağ Router VLAN Firewall Konfigürasyon"]
    },
    {
      "id": "nokta_net",
      "label": "Data Hat Nokta Sayısı",
      "type": "single",
      "required": true,
      "dependsOnId": "network_tur",
      "options": ["1-4 Hat Küçük", "4-8 Hat Standart Ofis", "8-16 Hat Geniş", "16-32 Hat Büyük", "32+ Komple Ağ"]
    },
    {
      "id": "kablo_net",
      "label": "Kablolama Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "nokta_net",
      "options": ["UTP Cat6 PoE", "Fiber Optik Pigtail Füzyon", "Sıva Altı Kırım Spiral Boru"]
    },
    {
      "id": "ekstra_net",
      "label": "Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "kablo_net",
      "options": ["Yüksek İrtifa Vinç Platform", "UPS Kesintisiz Güç", "Ekstra İstemiyorum"]
    }
  ];
}