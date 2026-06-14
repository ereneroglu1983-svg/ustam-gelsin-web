// lib/core/calculation/meslek_sorulari/ferforje_metal.dart

class FerforjeMetalSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_kapsami", // 🛠️ ANA TETİKLEYİCİ: Tüm alt soruları ve akışı kilitler
      "label": "Ferforje / Metal İşlem Kapsamı",
      "type": "single",
      "required": true,
      "options": [
        "Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet",
        "Mevcut Demirin Lokal Onarımı / Kaynak ve Boya Tadilatı"
      ]
    },
    {
      "id": "urun_tipi", // 🛠️ İKİNCİL TETİKLEYİCİ: Korkuluk, ağır garaj kapısı ve yangın merdiveni akışlarını ayıran ana anahtar id
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

    // ==========================================
    // ⚙️ GRUP 1: KAPI MEKANİZMA VE OTOMASYON DETAYLARI (Sadece Garaj Kapısı Seçilirse Açılır)
    // ==========================================
    {
      "id": "kapi_mekanizmasi", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue yapısına geçirildi
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
    {
      "id": "motor_otomasyonu", // 🛠️ PROJE STANDARDI: dependsOnId ve dependsOnValue yapısına geçirildi
      "label": "Motor ve Otomasyon Sistemi Talebi",
      "type": "single",
      "required": true,
      "dependsOnId": "urun_tipi",
      "dependsOnValue": ["Bahçe / Garaj Kapısı (Ağır Kasa Profil, Menteşe ve Ray Sistemli)"],
      "options": [
        "Otomatik Motorlu Sistem (Uzaktan Kumandalı, Flaşörlü ve Emniyet Fotoselli)",
        "Manuel Kullanım (El İle Açılır / Otomasyonsuz Standart Mekanizma)"
      ]
    },

    // ==========================================
    // 🎨 TASARIM, BOYAMA VE YÜZEY İŞLEMLERİ
    // ==========================================
    {
      "id": "tasarim_modeli", // Hesaplayıcıda CNC plazma kesim, cumba büküm veya minimal düz hat işçilik katsayılarını tetikler
      "label": "Tasarım İşçiliği ve Model Yoğunluğu",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet"],
      "options": [
        "Standart / Düz Profil Tasarımı (Modern ve Minimalist Ekonomik Düz Hatlar)",
        "Klasik / Motifli Ferforje Model (Kavisli Cumba Büküm ve Hazır Döküm Aksesuar)",
        "Özel Motifli / CNC Kesim Model (Ağır El İşçiliği, Sac Giydirme veya Plazma Kesim)"
      ]
    },
    {
      "id": "yuzey_islem", // Paslanmazlık garantili daldırma galvaniz veya fırın boya farklarını kilitler
      "label": "Metal Yüzey Koruma, Yalıtım ve Boya Teknolojisi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet"],
      "options": [
        "Elektrostatik Toz Boya Uygulaması (Endüstriyel Fırın Boyama)",
        "Sıcak Daldırma Galvaniz Kaplama (Paslanmazlık Garantili Ağır Hizmet Tipi koruma)",
        "Patina / Bakır Eskitme Boya İşçiliği (Dekoratif Amaçlı El İşçiliği Son Kat Boya)"
      ]
    },

    // ==========================================
    // 📐 ÖLÇÜ, METRAJ VE UZUNLUK PARAMETRELERİ
    // ==========================================
    {
      "id": "alan_segmenti", // Soru seçeneklerindeki aralıklar ile hesaplayıcı senkronize edildi
      "label": "Uygulacak Yaklaşık Toplam Uzunluk / Metraj Kademesi",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet",
        "Mevcut Demirin Lokal Onarımı / Kaynak ve Boya Tadilatı"
      ],
      "options": [
        "0-5 Metre / m² Arası (Küçük Ölçekli İşler)",
        "5-12 Metre / m² Arası (Standart Konut / Çevre Korkuluk Ölçüsü)",
        "12-25 Metre / m² Arası (Geniş Bahçe / Komple Bina Pencere Korkuluğu)",
        "25 Metre / m² ve Üzeri (Büyük Sanayi / Site Çevre Kapatma Ölçüsü)"
      ]
    },
    {
      "id": "metre_kare", // 🛠️ REVIZE EDİLDİ: Text tipinden single seçmeli tipe dönüştürüldü
      "label": "Net Ölçü Kademesi Seçin (Metre veya m²)",
      "type": "single",
      "required": true,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": [
        "Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet",
        "Mevcut Demirin Lokal Onarımı / Kaynak ve Boya Tadilatı"
      ],
      "options": [
        "Net 3 Metre / m² (Küçük Ölçekli Alan)",
        "Net 8 Metre / m² (Orta Ölçekli Alan)",
        "Net 15 Metre / m² (Geniş Ölçekli Alan)",
        "Net 30 Metre / m² (Çok Geniş Alan)",
        "Net 50 Metre / m² ve Üzeri (Endüstriyel Alan)"
      ]
    },

    // ==========================================
    // ⚙️ DONANIM, GÜVENLİK VE KALINLIK EKSTRALARI (Ortak Donanım Havuzu)
    // ==========================================
    {
      "id": "ekstra_ozellikler",
      "type": "multi",
      "required": false,
      "dependsOnId": "is_kapsami",
      "dependsOnValue": ["Sıfırdan İmalat, Nakliye ve Montaj Dahil Hizmet"],
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