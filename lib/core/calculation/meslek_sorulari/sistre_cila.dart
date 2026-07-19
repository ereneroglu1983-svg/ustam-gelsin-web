// lib/core/calculation/meslek_sorulari/sistre_cila.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class SistreCilaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK - işlem kapsamı tüm akışı belirler
    {
      "id": "islem_kapsam",
      "label": "Talep Edilen İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Sistre (Zımpara) + Cila İşlemi",
        "Sadece Cila Uygulaması (Zımparasız Üst Katman Yenileme)"
      ]
    },

    // ADIM 2: METREKARE - kapsam sonrası gelsin
    {
      "id": "metre_kare",
      "label": "Sistre Cila Yapılacak Net Alan (m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsam",
      "dependsOnValue": [
        "Komple Sistre (Zımpara) + Cila İşlemi",
        "Sadece Cila Uygulaması (Zımparasız Üst Katman Yenileme)"
      ],
      "options": [
        "0-40 m²",
        "40-60 m²",
        "60-80 m²",
        "80-100 m²",
        "100-120 m²",
        "120-150 m²",
        "150+ m²"
      ]
    },

    // ADIM 3: YIPRANMA - sadece Komple'de ve m² sonrası gelsin
    {
      "id": "yipranma_durumu",
      "label": "Mevcut Parkenin Yıpranma ve Hasar Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "metre_kare",
      "visibleIf": {"islem_kapsam": "Komple Sistre (Zımpara) + Cila İşlemi"},
      "dependsOnValue": [
        "0-40 m²",
        "40-60 m²",
        "60-80 m²",
        "80-100 m²",
        "100-120 m²",
        "120-150 m²",
        "150+ m²"
      ],
      "options": [
        "Orta Derece Çizikler (Yüzeysel Matlaşma ve Hafif Aşınmalar)",
        "Çok Derin Çizikli / Yüksek Hasarlı Yüzey (Su Şişmesi, Derin Oyuklar)"
      ]
    },

    // ADIM 4: CİLA TİPİ - Komple'de yıpranma sonrası, Sadece Cila'da direkt m² sonrası gelsin
    {
      "id": "cila_tipi",
      "label": "Kullanılacak Cila Teknolojisi ve Koruyucu Katman",
      "type": "single",
      "required": true,
      "dependsOnId": ["yipranma_durumu", "metre_kare"],
      "dependsOnValue": [
        "Orta Derece Çizikler (Yüzeysel Matlaşma ve Hafif Aşınmalar)",
        "Çok Derin Çizikli / Yüksek Hasarlı Yüzey (Su Şişmesi, Derin Oyuklar)",
        "0-40 m²",
        "40-60 m²",
        "60-80 m²",
        "80-100 m²",
        "100-120 m²",
        "120-150 m²",
        "150+ m²"
      ],
      "options": [
        "Poliüretan (Çift Bileşenli Standart Parlak/Mat Cila)",
        "Su Bazlı İthal Cila (Sararma Yapmayan Çevre Dostu ve Kokusuz)",
        "Yoğun Trafik Cilası (Ticari Mekanlar İçin Çift Komponentli Ultra Dayanıklı)"
      ]
    },

    // ADIM 5: FİNAL - cila sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Özel Macunlama, Renklendirme ve Süpürgelik Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "cila_tipi",
      "dependsOnValue": [
        "Poliüretan (Çift Bileşenli Standart Parlak/Mat Cila)",
        "Su Bazlı İthal Cila (Sararma Yapmayan Çevre Dostu ve Kokusuz)",
        "Yoğun Trafik Cilası (Ticari Mekanlar İçin Çift Komponentli Ultra Dayanıklı)"
      ],
      "options": [
        "Parke Tozu ile Macun Dolgu (Çatlak ve Derz Boşluklarının Kapatılması)",
        "Renk Değişimi / Parke Boyama (Ahşap Tonunu Değiştirme veya Lake Yapma)",
        "Süpürgeliklerin Sökülmesi, Zımparalanması ve Kenar İnce İşçiliği",
        "Lamine Parke Hassas Zımpara Farkı (Hassas Katmanlar İçin Mikro Kazıma)"
      ]
    }
  ];
}