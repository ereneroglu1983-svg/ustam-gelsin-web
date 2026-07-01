// lib/core/calculation/meslek_sorulari/sistre_cila.dart

class SistreCilaSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // 🎯 REVIZE: Metrekare sorusu listenin EN BAŞINA taşındı ve tipi 'single' (seçmeli) yapıldı!
    // Arayüz motoru sayfayı açar açmaz dropdown olarak direkt render edecek.
    {
      "id": "metre_kare",
      "label": "Sistre Cila Yapılacak Net Alan (m²)",
      "type": "single",
      "required": true,
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
    {
      "id": "islem_kapsam", // 🛠️ KİLİT TETİKLEYİCİ: Radikal akış belirleyici parametre
      "label": "Talep Edilen İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Sistre (Zımpara) + Cila İşlemi",
        "Sadece Cila Uygulaması (Zımparasız Üst Katman Yenileme)"
      ]
    },
    {
      "id": "yipranma_durumu", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue yapısına geçirildi
      "label": "Mevcut Parkenin Yıpranma ve Hasar Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "islem_kapsam",
      "dependsOnValue": [
        "Komple Sistre (Zımpara) + Cila İşlemi"
      ],
      "options": [
        "Orta Derece Çizikler (Yüzeysel Matlaşma ve Hafif Aşınmalar)",
        "Çok Derin Çizikli / Yüksek Hasarlı Yüzey (Su Şişmesi, Derin Oyuklar)"
      ]
    },
    {
      "id": "cila_tipi",
      "label": "Kullanılacak Cila Teknolojisi ve Koruyucu Katman",
      "type": "single",
      "required": true,
      "options": [
        "Poliüretan (Çift Bileşenli Standart Parlak/Mat Cila)",
        "Su Bazlı İthal Cila (Sararma Yapmayan Çevre Dostu ve Kokusuz)",
        "Yoğun Trafik Cilası (Ticari Mekanlar İçin Çift Komponentli Ultra Dayanıklı)"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Özel Macunlama, Renklendirme ve Süpürgelik Ekstraları",
      "type": "multi",
      "required": false,
      "options": [
        "Parke Tozu ile Macun Dolgu (Çatlak ve Derz Boşluklarının Kapatılması)",
        "Renk Değişimi / Parke Boyama (Ahşap Tonunu Değiştirme veya Lake Yapma)",
        "Süpürgeliklerin Sökülmesi, Zımparalanması ve Kenar İnce İşçiliği",
        "Lamine Parke Hassas Zımpara Farkı (Hassas Katmanlar İçin Mikro Kazıma)"
      ]
    }
  ];
}