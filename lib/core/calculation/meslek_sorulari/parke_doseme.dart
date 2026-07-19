// lib/core/calculation/meslek_sorulari/parke_doseme.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class ParkeDosemeSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK - Malzeme tüm fiyatı kilitler, en başta gelmeli
    {
      "id": "is_kapsami",
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

    // ADIM 2: METREKARE - kök sonrası gelsin
    {
      "id": "metre_kare",
      "label": "Parke Döşenecek Net Zemin Alanı (m²)",
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
        "0-40 m²",
        "40-60 m²",
        "60-80 m²",
        "80-100 m²",
        "100-120 m²",
        "120-150 m²",
        "150+ m²"
      ]
    },

    // ADIM 3: UYGULAMA ALANI - metrekare sonrası gelsin
    {
      "id": "uygulama_alan",
      "label": "Uygulama Alanı",
      "type": "single",
      "required": true,
      "dependsOnId": "metre_kare",
      "dependsOnValue": [
        "0-40 m²",
        "40-60 m²",
        "60-80 m²",
        "80-100 m²",
        "100-120 m²",
        "120-150 m²",
        "150+ m²"
      ],
      "options": ["Ev (Oda / Salon)", "Ofis / Ticari Alan", "Spor Salonu"]
    },

    // ADIM 4: ZEMİN DURUM - alan sonrası gelsin
    {
      "id": "zemin_durum",
      "label": "Mevcut Zemin Durumu",
      "type": "single",
      "required": true,
      "dependsOnId": "uygulama_alan",
      "dependsOnValue": ["Ev (Oda / Salon)", "Ofis / Ticari Alan", "Spor Salonu"],
      "options": ["Şap Düzgün / Pürüzsüz", "Zemin Bozuk (Tesviye Gerekiyor)", "Eski Parke Üzerine Doğrudan"]
    },

    // ADIM 5: KALINLIK - zemin sonrası gelsin
    {
      "id": "kalinlik",
      "label": "Parke Kalınlık ve Derz Seçimi",
      "type": "single",
      "required": true,
      "dependsOnId": "zemin_durum",
      "dependsOnValue": ["Şap Düzgün / Pürüzsüz", "Zemin Bozuk (Tesviye Gerekiyor)", "Eski Parke Üzerine Doğrudan"],
      "options": ["8 mm Standart Derzsiz", "10 mm Standart", "12 mm Derzli Premium Seri"]
    },

    // ADIM 6: SÜPÜRGELİK - kalınlık sonrası gelsin
    {
      "id": "supurgelik_tipi",
      "label": "Süpürgelik Modeli ve Yükseklik Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "kalinlik",
      "dependsOnValue": ["8 mm Standart Derzsiz", "10 mm Standart", "12 mm Derzli Premium Seri"],
      "options": [
        "MDF Standart Süpürgelik (PVC veya İnce MDF Serisi)",
        "Lake Yüksek Süpürgelik (8-10 cm CNC Kesimli Ağır Gönye İşçilikli)",
        "Alüminyum Metal Süpürgelik (Modern Minimalist Klipsli Sistem)"
      ]
    },

    // ADIM 7: ALT DOLGU - süpürgelik sonrası gelsin
    {
      "id": "alt_dolgu_tipi",
      "label": "Parke Altı Şilte ve Yalıtım Katmanı",
      "type": "single",
      "required": true,
      "dependsOnId": "supurgelik_tipi",
      "dependsOnValue": [
        "MDF Standart Süpürgelik (PVC veya İnce MDF Serisi)",
        "Lake Yüksek Süpürgelik (8-10 cm CNC Kesimli Ağır Gönye İşçilikli)",
        "Alüminyum Metal Süpürgelik (Modern Minimalist Klipsli Sistem)"
      ],
      "options": [
        "Standart Şilte (2mm Beyaz Köpük Şilte)",
        "Kapron Levha (Yerden Isıtma Uyumlu Yüksek Isı İletkenlikli XPS)",
        "Mantar Şilte (Üst Düzey Ses Yalıtımlı Doğal Akustik Mantar Rulo)"
      ]
    },

    // ADIM 8: AHŞAP CİLA - sadece Masif seçildiyse ve alt dolgu sonrası gelsin
    {
      "id": "ahsap_cila_tipi",
      "label": "Masif Parke Cila Türü Tercihi",
      "type": "single",
      "required": true,
      "dependsOnId": "alt_dolgu_tipi",
      "visibleIf": {"is_kapsami": "Masif Ahşap Parke (Tutkallı Döşeme, Sistre ve Cila Gerektiren Ağır Zanaat)"},
      "dependsOnValue": [
        "Standart Şilte (2mm Beyaz Köpük Şilte)",
        "Kapron Levha (Yerden Isıtma Uyumlu Yüksek Isı İletkenlikli XPS)",
        "Mantar Şilte (Üst Düzey Ses Yalıtımlı Doğal Akustik Mantar Rulo)"
      ],
      "options": [
        "Çift Bileşenli Poliüretan Cila (Yüksek Parlaklık ve Aşınma Dayanımı)",
        "Su Bazlı Ekolojik Cila (Kokusuz, Mat / İpek Mat Görünüm)",
        "Doğal Parke Yağı Uygulaması (Mat ve Dokulu Bitiş)"
      ]
    },

    // ADIM 9: FİNAL - Masif ise cila sonrası, diğerlerinde alt dolgu sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "label": "Zemin Hazırlığı, Kapı Tıraşlama ve Profil Ekstraları",
      "type": "multi",
      "required": false,
      "dependsOnId": ["alt_dolgu_tipi", "ahsap_cila_tipi"],
      "dependsOnValue": [
        "Standart Şilte (2mm Beyaz Köpük Şilte)",
        "Kapron Levha (Yerden Isıtma Uyumlu Yüksek Isı İletkenlikli XPS)",
        "Mantar Şilte (Üst Düzey Ses Yalıtımlı Doğal Akustik Mantar Rulo)",
        "Çift Bileşenli Poliüretan Cila (Yüksek Parlaklık ve Aşınma Dayanımı)",
        "Su Bazlı Ekolojik Cila (Kokusuz, Mat / İpek Mat Görünüm)",
        "Doğal Parke Yağı Uygulaması (Mat ve Dokulu Bitiş)"
      ],
      "options": [
        "Kapı Altı Kesimi ve Tıraşlanması",
        "Eşik / Kot Farkı Profilomi Montajı",
        "Eski Parke / Halı Sökümü ve Temizlenmesi",
        "Zemin Şap Düzeltme / Tesviye"
      ]
    }
  ];
}