// lib/core/calculation/meslek_sorulari/ferforje_metal.dart - PROFESYONEL AKIŞLI VERSİYON
// id ve options ASLA değiştirilmedi.

class FerforjeMetalSorulari {
  static final List<Map<String, dynamic>> sorular = [
    // ADIM 1: KÖK
    {
      "id": "is_kapsami",
      "label": "Ferforje / Metal İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet",
        "Mevcut Demirin Lokal Onarımı / Kaynak ve Boya Tadilatı"
      ]
    },

    // ADIM 2: ÜRÜN TİPİ - kökten sonra tek başına gelsin
    {
      "id": "urun_tipi",
      "label": "Üretilecek Ana Ürün Tipi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet",
        "Mevcut Demirin Lokal Onarımı / Kaynak ve Boya Tadilatı"
      ],
      "options": [
        "Pencere / Balkon Korkuluğu (Standart Profil ve Dekoratif Ferforje Serisi)",
        "Bahçe / Garaj Kapısı (Ağır Kasa Profil, Menteşe ve Ray Sistemli)",
        "Yangın Merdiveni (Mühendislik Hesabı Yapılmış Ağır Taşıyıcı Putrelli)"
      ]
    },

    // ADIM 3: KAPI MEKANİZMASI - sadece Bahçe/Garaj Kapısı'nda gelsin
    {
      "id": "kapi_mekanizmasi",
      "label": "Kapı Çalışma ve Açılır Mekanizma Sistemi",
      "type": "single",
      "required": true,
      "dependsOnId": "urun_tipi",
      "dependsOnValue": ["Bahçe / Garaj Kapısı (Ağır Kasa Profil, Menteşe ve Ray Sistemli)"],
      "options": [
        "Yana Kayar Sürgülü Sistem (Ray Üzerinde Çalışan Tek Kanat)",
        "Çift Kanatlı Dairesel Açılır Sistem (Gömme Ağır Menteşeli)",
        "Tek Kanatlı Standart Menteşeli Yaya Kapısı"
      ]
    },

    // ADIM 4: MOTOR - kapı mekanizması seçilince gelsin
    {
      "id": "motor_otomasyonu",
      "label": "Motor ve Otomasyon Sistemi Talebi",
      "type": "single",
      "required": true,
      "dependsOnId": "kapi_mekanizmasi",
      "dependsOnValue": [
        "Yana Kayar Sürgülü Sistem (Ray Üzerinde Çalışan Tek Kanat)",
        "Çift Kanatlı Dairesel Açılır Sistem (Gömme Ağır Menteşeli)",
        "Tek Kanatlı Standart Menteşeli Yaya Kapısı"
      ],
      "options": [
        "Otomatik Motorlu Sistem (Uzaktan Kumandalı, Flaşörlü ve Emniyet Fotoselli)",
        "Manuel Kullanım (El İle Açılır / Otomasyonsuz Standart Mekanizma)"
      ]
    },

    // ADIM 5: TASARIM - Sıfırdan imalatta, Garaj ise motor sonrası, diğer ürünlerde direkt urun_tipi sonrası gelsin
    {
      "id": "tasarim_modeli",
      "label": "Tasarım İşçiliği ve Model Yoğunluğu",
      "type": "single",
      "required": true,
      "dependsOnId": ["motor_otomasyonu", "urun_tipi"],
      "visibleIf": {"is_kapsami": "Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet"},
      "dependsOnValue": [
        "Otomatik Motorlu Sistem (Uzaktan Kumandalı, Flaşörlü ve Emniyet Fotoselli)",
        "Manuel Kullanım (El İle Açılır / Otomasyonsuz Standart Mekanizma)",
        "Pencere / Balkon Korkuluğu (Standart Profil ve Dekoratif Ferforje Serisi)",
        "Yangın Merdiveni (Mühendislik Hesabı Yapılmış Ağır Taşıyıcı Putrelli)"
      ],
      "options": [
        "Standart / Düz Profil Tasarımı (Modern ve Minimalist Ekonomik Düz Hatlar)",
        "Klasik / Motifli Ferforje Model (Kavisli Cumba Büküm ve Hazır Döküm Aksesuar)",
        "Özel Motifli / CNC Kesim Model (Ağır El İşçiliği, Sac Giydirme veya Plazma Kesim)"
      ]
    },

    // ADIM 6: YÜZEY İŞLEM - tasarım sonrası gelsin
    {
      "id": "yuzey_islem",
      "label": "Metal Yüzey Koruma, Yalıtım ve Boya Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "tasarim_modeli",
      "dependsOnValue": [
        "Standart / Düz Profil Tasarımı (Modern ve Minimalist Ekonomik Düz Hatlar)",
        "Klasik / Motifli Ferforje Model (Kavisli Cumba Büküm ve Hazır Döküm Aksesuar)",
        "Özel Motifli / CNC Kesim Model (Ağır El İşçiliği, Sac Giydirme veya Plazma Kesim)"
      ],
      "options": [
        "Elektrostatik Toz Boya Uygulaması (Endüstriyel Fırın Boyama)",
        "Sıcak Daldırma Galvaniz Kaplama (Paslanmazlık Garantili Ağır Hizmet Tipi koruma)",
        "Patina / Bakır Eskitme Boya İşçiliği (Dekoratif Amaçlı El İşçiliği Son Kat Boya)"
      ]
    },

    // ADIM 7: ALAN - Sıfırdan'da yüzey sonrası, Onarım'da direkt urun_tipi sonrası veya Garaj'da motor sonrası da gelebilir
    {
      "id": "alan_segmenti",
      "label": "Uygulacak Yaklaşık Toplam Uzunluk / Metraj Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": ["yuzey_islem", "urun_tipi", "motor_otomasyonu"],
      "dependsOnValue": [
        "Elektrostatik Toz Boya Uygulaması (Endüstriyel Fırın Boyama)",
        "Sıcak Daldırma Galvaniz Kaplama (Paslanmazlık Garantili Ağır Hizmet Tipi koruma)",
        "Patina / Bakır Eskitme Boya İşçiliği (Dekoratif Amaçlı El İşçiliği Son Kat Boya)",
        "Pencere / Balkon Korkuluğu (Standart Profil ve Dekoratif Ferforje Serisi)",
        "Bahçe / Garaj Kapısı (Ağır Kasa Profil, Menteşe ve Ray Sistemli)",
        "Yangın Merdiveni (Mühendislik Hesabı Yapılmış Ağır Taşıyıcı Putrelli)",
        "Otomatik Motorlu Sistem (Uzaktan Kumandalı, Flaşörlü ve Emniyet Fotoselli)",
        "Manuel Kullanım (El İle Açılır / Otomasyonsuz Standart Mekanizma)"
      ],
      "options": [
        "0-5 Metre / m² Arası (Küçük Ölçekli İşler)",
        "5-12 Metre / m² Arası (Standart Konut / Çevre Korkuluk Ölçüsü)",
        "12-25 Metre / m² Arası (Geniş Bahçe / Komple Bina Pencere Korkuluğu)",
        "25 Metre / m² ve Üzeri (Büyük Sanayi / Site Çevre Kapatma Ölçüsü)"
      ]
    },

    // ADIM 8: NET ÖLÇÜ - alan sonrası gelsin
    {
      "id": "metre_kare",
      "label": "Net Ölçü Kademesi Seçin (Metre veya m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "alan_segmenti",
      "dependsOnValue": [
        "0-5 Metre / m² Arası (Küçük Ölçekli İşler)",
        "5-12 Metre / m² Arası (Standart Konut / Çevre Korkuluk Ölçüsü)",
        "12-25 Metre / m² Arası (Geniş Bahçe / Komple Bina Pencere Korkuluğu)",
        "25 Metre / m² ve Üzeri (Büyük Sanayi / Site Çevre Kapatma Ölçüsü)"
      ],
      "options": [
        "Net 3 Metre / m² (Küçük Ölçekli Alan)",
        "Net 8 Metre / m² (Orta Ölçekli Alan)",
        "Net 15 Metre / m² (Geniş Ölçekli Alan)",
        "Net 30 Metre / m² (Çok Geniş Alan)",
        "Net 50 Metre / m² ve Üzeri (Endüstriyel Alan)"
      ]
    },

    // ADIM 9: FİNAL - sadece Sıfırdan'da, net ölçü sonrası yeşil kutuda
    {
      "id": "ekstra_ozellikler",
      "type": "multi",
      "required": false,
      "dependsOnId": "metre_kare",
      "visibleIf": {"is_kapsami": "Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet"},
      "dependsOnValue": [
        "Net 3 Metre / m² (Küçük Ölçekli Alan)",
        "Net 8 Metre / m² (Orta Ölçekli Alan)",
        "Net 15 Metre / m² (Geniş Ölçekli Alan)",
        "Net 30 Metre / m² (Çok Geniş Alan)",
        "Net 50 Metre / m² ve Üzeri (Endüstriyel Alan)"
      ],
      "label": "Donanım, Otomasyon ve Kalınlık Ekstraları",
      "options": [
        "Yana Kayar Motor Otomasyon Seti Entegrasyonu (Ağır Hizmet Tipi Motor, Dişli Çark ve Fotosel Takımı)",
        "Sürme Ray Seti İşçilik Desteği (Ağır Tip Rulmanlı Tekerlekler ve Zemin Kılavuz Ray Donanımı)",
        "Akıllı Kilit / Otomat Sistemi Montajı (Kapılar İçin Paslanmaz Solenoid Kilit ve Trafo Altyapısı)",
        "Yüksek Et Kalınlığına Sahip Profil / İçi Dolu Kare Demir Kullanımı (Maksimum Mukavemet ve Tonaj Farkı)"
      ]
    }
  ];
}