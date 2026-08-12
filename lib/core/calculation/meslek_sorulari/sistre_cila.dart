// lib/core/calculation/meslek_sorulari/sistre_cila.dart - FINAL
class SistreCilaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "islem_kapsam",
      "label": "İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": ["Komple Sistre Zımpara Cila", "Sadece Cila Zımparasız Üst Katman Yenileme"]
    },
    {
      "id": "metre_kare",
      "label": "Net Alan m²",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsam",
      "options": ["0-40 m²", "40-60 m²", "60-80 m²", "80-100 m²", "100-120 m²", "120-150 m²", "150+ m²"]
    },
    // KOMPLE DALI
    {
      "id": "yipranma",
      "label": "Parke Yıpranma Hasar Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsam",
      "dependsOnValue": ["Komple Sistre Zımpara Cila"],
      "options": ["Orta Çizik Yüzeysel Matlaşma Hafif Aşınma", "Çok Derin Çizik Su Şişmesi Oyuk Yüksek Hasar"]
    },
    {
      "id": "cila_komple",
      "label": "Cila Teknolojisi Koruyucu Katman",
      "type": "single",
      "required": true,
      "dependsOnId": "yipranma",
      "options": ["Poliüretan Çift Bileşen Standart Parlak Mat", "Su Bazlı İthal Sararma Yapmaz Kokusuz Ekolojik", "Yoğun Trafik Çift Komponent Ultra Dayanıklı Ticari"]
    },
    {
      "id": "ekstra_komple",
      "label": "Macunlama Renklendirme Süpürgelik Ekstraları",
      "type": "multi",
      "required": true,
      "dependsOnId": "cila_komple",
      "options": [
        "Parke Tozu Macun Dolgu Derz Boşluk Kapatma",
        "Renk Değişim Boyama Ahşap Ton Lake",
        "Süpürgelik Söküm Zımpara Kenar İnce İşçilik",
        "Lamine Hassas Mikro Kazıma Farkı",
        "Ekstra İstemiyorum"
      ]
    },
    // SADECE CİLA DALI
    {
      "id": "cila_sadece",
      "label": "Cila Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsam",
      "dependsOnValue": ["Sadece Cila Zımparasız Üst Katman Yenileme"],
      "options": ["Poliüretan Standart", "Su Bazlı İthal Kokusuz", "Yoğun Trafik Ultra Dayanıklı"]
    },
    {
      "id": "ekstra_sadece",
      "label": "Ekstralar",
      "type": "multi",
      "required": true,
      "dependsOnId": "cila_sadece",
      "options": ["Macun Dolgu", "Renk Değişim", "Süpürgelik İnce İşçilik", "Ekstra İstemiyorum"]
    }
  ];
}