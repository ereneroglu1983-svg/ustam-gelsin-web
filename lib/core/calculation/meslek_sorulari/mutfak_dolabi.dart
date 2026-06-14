// lib/core/calculation/meslek_sorulari/mutfak_dolabi.dart

class MutfakDolabiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ EN ANA TETİKLEYİCİ (İlk açılışta SADECE bu soru görünür)
      "label": "Yapılacak Mutfak Projesinin Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Komple Mutfak Yenileme (Hem Dolap Hem Tezgah İmalat ve Montajı)",
        "Sadece Mutfak Dolabı İmalatı (Tezgah Hariç)",
        "Sadece Mutfak Tezgahı Değişimi (Dolaplar Sabit)",
        "Mutfak Kapak Yenileme / Boyama Hizmeti"
      ]
    },

    // ==========================================
    // 🚪 DOLAP KAPAK SEÇİMİ (Sadece Dolap veya Kapak Yenileme Varsa Açılır)
    // ==========================================
    {
      "id": "kapak_tipi",
      "label": "Mutfak Dolabı Kapak Malzemesi ve Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Mutfak Yenileme (Hem Dolap Hem Tezgah İmalat ve Montajı)",
        "Sadece Mutfak Dolabı İmalatı (Tezgah Hariç)",
        "Mutfak Kapak Yenileme / Boyama Hizmeti"
      ],
      "options": [
        "Akrilik Kapak (Parlak / Mat Çizilmeye Dayanıklı Pürüzsüz Yüzey)",
        "Lake Kapak (7 Kat Boyalı İpek Mat / Parlak Lüks El İşçiliği)",
        "Membran / MDFlam Kapak (Ekonomik ve Standart Dayanımlı Segment)",
        "Masif Ahşap Kapak (Fırınlanmış Doğal Ağaç / Rustik Klasik Seri)"
      ]
    },

    // ==========================================
    // 🪨 TEZGAH MALZEME SEÇİMİ (Bedava Marka İsimleri Temizlendi 💰)
    // ==========================================
    {
      "id": "tezgah_tipi",
      "label": "Mutfak Tezgahı Malzeme Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Mutfak Yenileme (Hem Dolap Hem Tezgah İmalat ve Montajı)",
        "Sadece Mutfak Tezgahı Değişimi (Dolaplar Sabit)"
      ],
      "options": [
        "Kuvars Kompoze Tezgah (Yüksek Mukavemetli Yeni Nesil Doğal Taş Teknolojisi)", // 🛠️ Reklam bitti, parayı veren marka buraya gelecek
        "Porselen Tezgah (Lüks / Isıya Dayanıklı CNC Kesim İnce Panel)",
        "Granit Tezgah (Doğal Taş Yerli / İthal Ağır Sanayi Serisi)",
        "Ahşap / Masif Panel Tezgah (İroko / Meşe Suya Dayanıklı Yağlanmış Seri)"
      ]
    },

    // ==========================================
    // 📐 GLOBAL DETAYLAR (İş Kapsamı Seçilmeden Asla Ekrana Gelmezler)
    // ==========================================
    {
      "id": "mutfak_formu",
      "label": "Mutfak Mimari Yerleşim Formu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Mutfak Yenileme (Hem Dolap Hem Tezgah İmalat ve Montajı)",
        "Sadece Mutfak Dolabı İmalatı (Tezgah Hariç)",
        "Sadece Mutfak Tezgahı Değişimi (Dolaplar Sabit)",
        "Mutfak Kapak Yenileme / Boyama Hizmeti"
      ],
      "options": [
        "Düz Mutfak (Tek Hat Duvar Boyu Yerleşim)",
        "L Mutfak (Köşe Birleşim ve Tezgah Köşe Kesim Fire Paylı)",
        "U Mutfak / Ada Mutfak Entegrasyonu (Çift Köşe Dönüşlü ve Ağır Lojistik Yükü)"
      ]
    },
    {
      "id": "metraj_segmenti",
      "label": "Tahmini Mutfak Toplam Ölçüsü / Uzunluk Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Mutfak Yenileme (Hem Dolap Hem Tezgah İmalat ve Montajı)",
        "Sadece Mutfak Dolabı İmalatı (Tezgah Hariç)",
        "Sadece Mutfak Tezgahı Değişimi (Dolaplar Sabit)",
        "Mutfak Kapak Yenileme / Boyama Hizmeti"
      ],
      "options": [
        "0 - 3 Metretül Arası Standart Küçük Mutfak",
        "3 - 5 Metretül Arası Orta Ölçek Daire Mutfağı",
        "5 - 8 Metretül Arası Geniş Mutfak",
        "8 Metretül ve Üzeri Büyük Villa / Ticari Mutfak"
      ]
    },
    {
      "id": "yapi_tip",
      "label": "Uygulama Yapılacak Alanın Mimarisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Mutfak Yenileme (Hem Dolap Hem Tezgah İmalat ve Montajı)",
        "Sadece Mutfak Dolabı İmalatı (Tezgah Hariç)",
        "Sadece Mutfak Tezgahı Değişimi (Dolaplar Sabit)",
        "Mutfak Kapak Yenileme / Boyama Hizmeti"
      ],
      "options": [
        "Apartman Dairesi",
        "Müstakil Ev / Villa",
        "Ofis / İş Yeri Personel Mutfağı",
        "Cafe / Restoran Ticari Mutfağı"
      ]
    },
    {
      "id": "ekstra_ozellikler", // 🛠️ Aksesuar markaları da (Blum/Hettich) süpürüldü! Parayı veren düdüğü çalacak.
      "label": "Mekanizma, Ray Sistemleri ve Donanım Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Komple Mutfak Yenileme (Hem Dolap Hem Tezgah İmalat ve Montajı)",
        "Sadece Mutfak Dolabı İmalatı (Tezgah Hariç)",
        "Sadece Mutfak Tezgahı Değişimi (Dolaplar Sabit)",
        "Mutfak Kapak Yenileme / Boyama Hizmeti"
      ],
      "options": [
        "Premium Frenli Ray Çekmece Setleri (Yüksek Taşıma Kapasiteli Tandem Sistemler)",
        "Kör Köşe (Kiler) Sistemi Entegrasyonu (Fasulye Tipi Döner Çekmece Mekanizması)",
        "Kulpsuz (Gola) Sistem Geçişi (Gizli Alüminyum Profil Kanalı ve Özel Kapak Kesimi)",
        "Tezgah Arası Cam / Seramik Kaplama Hizmeti (Temperli Cam veya Büyük Ebat Panel)",
        "LED Aydınlatma Entegrasyonu Tasarımı (El Sensörlü Profil İçi Gizli Işık Bandı)"
      ]
    }
  ];
}