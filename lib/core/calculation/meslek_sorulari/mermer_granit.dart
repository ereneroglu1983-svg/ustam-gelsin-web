// lib/core/calculation/meslek_sorulari/mermer_granit.dart - FINAL
class MermerGranitSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami",
      "label": "Mermer Granit Uygulama Alanı",
      "type": "single",
      "required": true,
      "options": ["Mutfak Tezgahı Evye Ocak Şablonlu", "Banyo Zemin Kaplama", "Merdiven Basamağı Rıht Kaymaz Kanallı", "Balkon Denizliği", "Asansör Sövesi Dış Kaplama", "Mezar Yapımı Restorasyon"]
    },
    // MEZAR DALI
    {
      "id": "mezar_tipi",
      "label": "Mezar Modeli Yapım Seçeneği",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mezar Yapımı Restorasyon"],
      "options": ["Tek Kişilik Standart Blok", "Çift Kişilik Aile Kabri", "Katlı Gömme Sistem", "Sadece Baş Taşı Değişim Onarım"]
    },
    {
      "id": "malzeme_mezar",
      "label": "Taş Plaka Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "mezar_tipi",
      "options": ["Yerli Mermer Muğla Marmara", "İthal Granit Yüksek Sertlik", "Kuvars Belenco Kompoze Lüks", "Ultra İnce Porselen Üst Segment"]
    },
    {
      "id": "metraj_mezar",
      "label": "Tahmini Ölçü Kademe",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_mezar",
      "options": ["0-5 m²", "5-10 m²", "10-20 m²", "20 m² Üzeri"]
    },
    // TEZGAH DALI
    {
      "id": "malzeme_tezgah",
      "label": "Taş Plaka Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Mutfak Tezgahı Evye Ocak Şablonlu", "Banyo Zemin Kaplama", "Merdiven Basamağı Rıht Kaymaz Kanallı", "Balkon Denizliği", "Asansör Sövesi Dış Kaplama"],
      "options": ["Yerli Mermer Muğla Marmara", "İthal Granit Yüksek Sertlik", "Kuvars Belenco Kompoze Lüks", "Ultra İnce Porselen Üst Segment"]
    },
    {
      "id": "metraj_tezgah",
      "label": "Tahmini Ölçü Uzunluk Alan",
      "type": "single",
      "required": true,
      "dependsOnId": "malzeme_tezgah",
      "options": ["0-5 Metretül m²", "5-10 Metretül m²", "10-20 Metretül m²", "20 Metretül m² Üzeri"]
    },
    {
      "id": "ekstra_tezgah",
      "label": "Atölye Kenar Donanım Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "metraj_tezgah",
      "options": [
        "Balıksırtı Tam Pah Kenar Parlatma",
        "Alttan Montaj Evye Rodaj Entegrasyon",
        "L Çıta Kalınlaştırma 45° Gönye",
        "Süpürgelik Koruma Şerit Dahil",
        "Ekstra İstemiyorum"
      ]
    },
    {
      "id": "ekstra_mezar",
      "label": "Ekstra İşçilikler",
      "type": "multi",
      "required": true,
      "dependsOnId": "metraj_mezar",
      "options": ["Balıksırtı Pah Parlatma", "Yazı Gravür İşçilik", "Süpürgelik Çevre Taşı", "Ekstra İstemiyorum"]
    }
  ];
}