// lib/core/calculation/meslek_sorulari/mermer_granit.dart

class MermerGranitSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ KİLİT TETİKLEYİCİ: Evye/Ocak, rıht veya mezar altyapı modüllerini tetikleyen ana kilit id
      "label": "Mermer / Granit Uygulama Alanı",
      "type": "single",
      "required": true,
      "options": [
        "Mutfak Tezgahı (Evye/Ocak Deliği ve Şablon İşçilikli)",
        "Banyo / Zemin Kaplama",
        "Merdiven Basamağı (Rıht Kesimi ve Kaymazlık Kanallı)",
        "Balkon Denizliği Uygulaması",
        "Asansör Sövesi / Dış Mekan Kaplama",
        "Mezar Yapımı ve Restorasyonu"
      ]
    },
    {
      "id": "mezar_tipi", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue mimarisine geçirildi
      "label": "Mezar Modeli ve Yapım Seçeneği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Mezar Yapımı ve Restorasyonu"
      ],
      "options": [
        "Tek Kişilik (Standart Blok Kaplama)",
        "Çift Kişilik (Aile Kabri)",
        "Katlı Mezar (Gömme Sistemi)",
        "Sadece Baş Taşı Değişimi / Onarım Hizmeti"
      ]
    },
    {
      "id": "malzeme_tipi", // Hesaplayıcıda plaka taban fiyat modelini kilitler
      "label": "Kullanılacak Taş / Plaka Teknolojisi",
      "type": "single",
      "required": true,
      "options": [
        "Yerli Mermer (Muğla Beyazı / Marmara Serisi - Standart)",
        "İthal Granit (Yüksek Sertlik Dereceli Sert Taş Serisi)",
        "Kuvars / Belenco / Coante Kompoze Taş Grubu (Lüks Plaka)",
        "Ultra İnce Porselen Plaka (Özel Kesim ve Yüksek Dayanımlı Üst Segment)"
      ]
    },
    {
      "id": "metraj_segmenti", // Kullanıcı net ölçü girmezse devreye giren hacim süzgeci
      "label": "Tahmini Ölçü / Uzunluk veya Alan Kademesi",
      "type": "single",
      "required": true,
      "options": [
        "0-5 Metretül / m² Arası",
        "5-10 Metretül / m² Arası",
        "10-20 Metretül / m² Arası",
        "20 Metretül / m² ve Üzeri"
      ]
    },
    {
      "id": "metre_kare", // Doğrudan çarpan kabul edilecek ana metraj (Opsiyonel)
      "label": "Net Ölçü Girin (m² veya Metretül - Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 4.5"
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Atölye İşçilikleri, Kenar Detayları ve Donanımlar",
      "type": "multi",
      "required": false,
      "options": [
        "Balıksırtı / Tam Pah İşçiliği (Kenarların Makine ile Yuvarlatılıp Parlatılması)",
        "Alttan Montaj Evye Entegrasyonu (İç Kısmın Hassas Rodajlanması)",
        "L Çıta / Kalınlaştırma Uygulaması (Ön Kısmın Kalın Görünmesi İçin 45° Gönye Birleştirme)",
        "Süpürgelik Dahil Hizmeti (Duvar Dibine Çekilecek Koruma Şeritleri)"
      ]
    }
  ];
}