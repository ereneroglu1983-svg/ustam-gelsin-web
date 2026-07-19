// lib/core/calculation/meslek_sorulari/mermer_granit.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class MermerGranitSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK - Uygulama alanı tüm akışı kilitler
    {
      "id": "is_kapsami",
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

    // ADIM 2: MEZAR TİPİ - sadece Mezar seçildiyse gelsin
    {
      "id": "mezar_tipi",
      "label": "Mezar Modeli ve Yapım Seçeneği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mezar Yapımı ve Restorasyonu"],
      "options": [
        "Tek Kişilik (Standart Blok Kaplama)",
        "Çift Kişilik (Aile Kabri)",
        "Katlı Mezar (Gömme Sistemi)",
        "Sadece Baş Taşı Değişimi / Onarım Hizmeti"
      ]
    },

    // ADIM 3: MALZEME - Mezar ise mezar tipi sonrası, diğerleri için direkt kök sonrası gelsin
    {
      "id": "malzeme_tipi",
      "label": "Kullanılacak Taş / Plaka Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": ["mezar_tipi", "is_kapsami"],
      "dependsOnValue": [
        "Tek Kişilik (Standart Blok Kaplama)",
        "Çift Kişilik (Aile Kabri)",
        "Katlı Mezar (Gömme Sistemi)",
        "Sadece Baş Taşı Değişimi / Onarım Hizmeti",
        "Mutfak Tezgahı (Evye/Ocak Deliği ve Şablon İşçilikli)",
        "Banyo / Zemin Kaplama",
        "Merdiven Basamağı (Rıht Kesimi ve Kaymazlık Kanallı)",
        "Balkon Denizliği Uygulaması",
        "Asansör Sövesi / Dış Mekan Kaplama"
      ],
      "options": [
        "Yerli Mermer (Muğla Beyazı / Marmara Serisi - Standart)",
        "İthal Granit (Yüksek Sertlik Dereceli Sert Taş Serisi)",
        "Kuvars / Belenco / Coante Kompoze Taş Grubu (Lüks Plaka)",
        "Ultra İnce Porselen Plaka (Özel Kesim ve Yüksek Dayanımlı Üst Segment)"
      ]
    },

    // ADIM 4: METRAJ SEGMENTİ - malzeme sonrası gelsin
    {
      "id": "metraj_segmenti",
      "label": "Tahmini Ölçü / Uzunluk veya Alan Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tipi",
      "dependsOnValue": [
        "Yerli Mermer (Muğla Beyazı / Marmara Serisi - Standart)",
        "İthal Granit (Yüksek Sertlik Dereceli Sert Taş Serisi)",
        "Kuvars / Belenco / Coante Kompoze Taş Grubu (Lüks Plaka)",
        "Ultra İnce Porselen Plaka (Özel Kesim ve Yüksek Dayanımlı Üst Segment)"
      ],
      "options": [
        "0-5 Metretül / m² Arası",
        "5-10 Metretül / m² Arası",
        "10-20 Metretül / m² Arası",
        "20 Metretül / m² ve Üzeri"
      ]
    },

    // ADIM 5: NET ÖLÇÜ - metraj sonrası gelsin
    {
      "id": "metre_kare",
      "label": "Net Ölçü Girin (m² veya Metretül - Opsiyonel)",
      "type": "text",
      "required": false,
      "keyboardType": "number",
      "hint": "Örn: 4.5",
      "dependsOnId": "metraj_segmenti",
      "dependsOnValue": [
        "0-5 Metretül / m² Arası",
        "5-10 Metretül / m² Arası",
        "10-20 Metretül / m² Arası",
        "20 Metretül / m² ve Üzeri"
      ]
    },

    // ADIM 6: FİNAL - net ölçü sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Atölye İşçilikleri, Kenar Detayları ve Donanımlar",
      "type": "multi",
      "required": false,
      "dependsOnId": ["metraj_segmenti", "metre_kare"],
      "dependsOnValue": [
        "0-5 Metretül / m² Arası",
        "5-10 Metretül / m² Arası",
        "10-20 Metretül / m² Arası",
        "20 Metretül / m² ve Üzeri",
        "0",
        "1",
        "2",
        "3",
        "4",
        "5"
      ],
      "options": [
        "Balıksırtı / Tam Pah İşçiliği (Kenarların Makine ile Yuvarlatılıp Parlatılması)",
        "Alttan Montaj Evye Entegrasyonu (İç Kısmın Hassas Rodajlanması)",
        "L Çıta / Kalınlaştırma Uygulaması (Ön Kısmın Kalın Görünmesi İçin 45° Gönye Birleştirme)",
        "Süpürgelik Dahil Hizmeti (Duvar Dibine Çekilecek Koruma Şeritleri)"
      ]
    }
  ];
}