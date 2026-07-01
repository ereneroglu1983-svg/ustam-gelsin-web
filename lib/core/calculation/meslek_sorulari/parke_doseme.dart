// lib/core/calculation/meslek_sorulari/parke_doseme.dart

class ParkeDosemeSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // 🎯 SİSTEME TAM UYUM: Tip 'single' yapıldı, klavye derdi bitti!
    // Arayüz motoru (UI Engine) tak diye tanıyacak ve en başta direkt render edecek.
    {
      "id": "metre_kare",
      "label": "Parke Döşenecek Net Zemin Alanı (m²)",
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
      "id": "is_kapsami", // 🛠️ KİLİT TETİKLEYİCİ: Alt soruları yöneten ana kilit
      "label": "Döşenecek Parke Malzemesi ve Teknolojisi",
      "type": "single",
      "required": true,
      "options": [
        "Laminat Parke (8mm-10mm Kilitli Sistem Standart)",
        "Lamine Parke (Doğal Üst Katmanlı ve Hassas Klik İşçilikli)",
        "Masif Ahşap Parke (Tutkallı Döşeme, Sistre ve Cila Gerektiren Ağır Zanaat)",
        "LVP / Vinil Parke (Suya Dayanıklı Lüks PVC Klik Sistemler)"
      ]
    },
    {
      "id": "ahsap_cila_tipi",
      "label": "Masif Parke Cila Türü Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Masif Ahşap Parke (Tutkallı Döşeme, Sistre ve Cila Gerektiren Ağır Zanaat)"
      ],
      "options": [
        "Çift Bileşenli Poliüretan Cila (Yüksek Parlaklık ve Aşınma Dayanımı)",
        "Su Bazlı Ekolojik Cila (Kokusuz, Mat / İpek Mat Görünüm)",
        "Doğal Parke Yağı Uygulaması (Mat ve Dokulu Bitiş)"
      ]
    },
    {
      "id": "supurgelik_tipi",
      "label": "Süpürgelik Modeli ve Yükseklik Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Laminat Parke (8mm-10mm Kilitli Sistem Standart)",
        "Lamine Parke (Doğal Üst Katmanlı ve Hassas Klik İşçilikli)",
        "Masif Ahşap Parke (Tutkallı Döşeme, Sistre ve Cila Gerektiren Ağır Zanaat)",
        "LVP / Vinil Parke (Suya Dayanıklı Lüks PVC Klik Sistemler)"
      ],
      "options": [
        "MDF Standart Süpürgelik (PVC veya İnce MDF Serisi)",
        "Lake Yüksek Süpürgelik (8-10 cm CNC Kesimli Ağır Gönye İşçilikli)",
        "Alüminyum Metal Süpürgelik (Modern Minimalist Klipsli Sistem)"
      ]
    },
    {
      "id": "alt_dolgu_tipi",
      "label": "Parke Altı Şilte ve Yalıtım Katmanı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Laminat Parke (8mm-10mm Kilitli Sistem Standart)",
        "Lamine Parke (Doğal Üst Katmanlı ve Hassas Klik İşçilikli)",
        "Masif Ahşap Parke (Tutkallı Döşeme, Sistre ve Cila Gerektiren Ağır Zanaat)",
        "LVP / Vinil Parke (Suya Dayanıklı Lüks PVC Klik Sistemler)"
      ],
      "options": [
        "Standart Şilte (2mm Beyaz Köpük Şilte)",
        "Kapron Levha (Yerden Isıtma Uyumlu Yüksek Isı İletkenlikli XPS)",
        "Mantar Şilte (Üst Düzey Ses Yalıtımlı Doğal Akustik Mantar Rulo)"
      ]
    },
    {
      "id": "ekstra_ozellikler",
      "label": "Zemin Hazırlığı, Kapı Tıraşlama ve Profil Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Laminat Parke (8mm-10mm Kilitli Sistem Standart)",
        "Lamine Parke (Doğal Üst Katmanlı ve Hassas Klik İşçilikli)",
        "Masif Ahşap Parke (Tutkallı Döşeme, Sistre ve Cila Gerektiren Ağır Zanaat)",
        "LVP / Vinil Parke (Suya Dayanıklı Lüks PVC Klik Sistemler)"
      ],
      "options": [
        "Kapı Altı Kesimi ve Tıraşlanması",
        "Eşik / Kot Farkı Profilomi Montajı",
        "Eski Parke / Halı Sökümü ve Temizlenmesi",
        "Zemin Şap Düzeltme / Tesviye"
      ]
    },
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Laminat Parke (8mm-10mm Kilitli Sistem Standart)",
        "Lamine Parke (Doğal Üst Katmanlı ve Hassas Klik İşçilikli)",
        "Masif Ahşap Parke (Tutkallı Döşeme, Sistre ve Cila Gerektiren Ağır Zanaat)",
        "LVP / Vinil Parke (Suya Dayanıklı Lüks PVC Klik Sistemler)"
      ],
      "options": ["Ev (Oda / Salon)", "Ofis / Ticari Alan", "Spor Salonu"]
    },
    {
      "id": "zemin_durum",
      "label": "Mevcut Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Laminat Parke (8mm-10mm Kilitli Sistem Standart)",
        "Lamine Parke (Doğal Üst Katmanlı ve Hassas Klik İşçilikli)",
        "Masif Ahşap Parke (Tutkallı Döşeme, Sistre ve Cila Gerektiren Ağır Zanaat)",
        "LVP / Vinil Parke (Suya Dayanıklı Lüks PVC Klik Sistemler)"
      ],
      "options": ["Şap Düzgün / Pürüzsüz", "Zemin Bozuk (Tesviye Gerekiyor)", "Eski Parke Üzerine Doğrudan"]
    },
    {
      "id": "kalinlik",
      "label": "Parke Kalınlık ve Derz Seçimi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Laminat Parke (8mm-10mm Kilitli Sistem Standart)",
        "Lamine Parke (Doğal Üst Katmanlı ve Hassas Klik İşçilikli)",
        "Masif Ahşap Parke (Tutkallı Döşeme, Sistre ve Cila Gerektiren Ağır Zanaat)",
        "LVP / Vinil Parke (Suya Dayanıklı Lüks PVC Klik Sistemler)"
      ],
      "options": ["8 mm Standart Derzsiz", "10 mm Standart", "12 mm Derzli Premium Seri"]
    }
  ];
}