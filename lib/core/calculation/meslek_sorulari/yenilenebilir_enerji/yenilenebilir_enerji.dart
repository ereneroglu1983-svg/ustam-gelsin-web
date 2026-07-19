// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/yenilenebilir_enerji.dart - DÜZELTİLMİŞ TAM HALİ

import 'ges.dart';
import 'res.dart';
import 'enerji_depolama.dart';
import 'elektrikli_arac.dart';
import 'off_grid_mobil_enerji.dart';

class YenilenebilirEnerjiSorulari {
  static final List<Map<String, dynamic>> sorular = [
    {
      "id": "is_turu",
      "label": "Yapılacak Yenilenebilir Enerji Hizmetini Seçiniz",
      "type": "single",
      "required": true,
      "options": [
        "☀ Güneş Enerji Sistemleri (GES)",
        "🌬 Rüzgar Enerji Sistemleri (RES)",
        "🔋 Enerji Depolama Sistemleri",
        "🚗 Elektrikli Araç Şarj İstasyonları",
        "🏕 Off-Grid / Mobil Enerji Sistemleri"
      ]
    },

    // ==================== 1) ☀ GES ====================
    {
      "id": "ges_is_turu",
      "label": "Yapılacak Güneş Enerji Sistemi Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["☀ Güneş Enerji Sistemleri (GES)"],
      "options": [
        "Güneş Paneli Kurulumu",
        "Arazi GES Kurulumu",
        "Tarımsal Sulama GES Kurulumu",
        "Güneş Paneli Söküm ve Taşıma",
        "Güneş Paneli Bakım ve Temizliği",
        "Güneş Paneli Arıza Tespiti",
        "Güneş Paneli Performans Kontrolü",
        "İnverter Montajı",
        "İnverter Arıza ve Değişimi",
        "Solar Kablo ve Elektrik Tesisatı",
        "Panel Taşıyıcı Konstrüksiyon Montajı",
        "GES Projelendirme ve Danışmanlık"
      ]
    },
    // GES alt detayları -> ges_is_turu'na bağlandı
    ...GesSorulari.sorular.where((s) => s["id"] != "is_turu").map((s) {
      if (s["dependsOnId"] == "is_turu") {
        return {...s, "dependsOnId": "ges_is_turu"};
      }
      return s;
    }),

    // ==================== 2) 🌬 RES ====================
    {
      "id": "res_is_turu",
      "label": "Yapılacak Rüzgar Enerji Sistemi Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["🌬 Rüzgar Enerji Sistemleri (RES)"],
      "options": RESSorulari.sorular.firstWhere((e) => e["id"] == "is_turu")["options"],
    },
    ...RESSorulari.sorular.where((s) => s["id"] != "is_turu").map((s) {
      if (s["dependsOnId"] == "is_turu") {
        return {...s, "dependsOnId": "res_is_turu"};
      }
      return s;
    }),

    // ==================== 3) 🔋 ENERJİ DEPOLAMA ====================
    {
      "id": "depolama_is_turu",
      "label": "Yapılacak Enerji Depolama Hizmeti",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["🔋 Enerji Depolama Sistemleri"],
      "options": EnerjiDepolamaSorulari.sorular.firstWhere((e) => e["id"] == "is_turu")["options"],
    },
    ...EnerjiDepolamaSorulari.sorular.where((s) => s["id"] != "is_turu").map((s) {
      if (s["dependsOnId"] == "is_turu") {
        return {...s, "dependsOnId": "depolama_is_turu"};
      }
      return s;
    }),

    // ==================== 4) 🚗 ELEKTRİKLİ ARAÇ ŞARJ ====================
    {
      "id": "arac_is_turu",
      "label": "Yapılacak Şarj İstasyonu Hizmeti",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["🚗 Elektrikli Araç Şarj İstasyonları"],
      "options": ElektrikliAracSorulari.sorular.firstWhere((e) => e["id"] == "is_turu")["options"],
    },
    ...ElektrikliAracSorulari.sorular.where((s) => s["id"] != "is_turu").map((s) {
      if (s["dependsOnId"] == "is_turu") {
        return {...s, "dependsOnId": "arac_is_turu"};
      }
      return s;
    }),

    // ==================== 5) 🏕 OFF-GRID / MOBİL ====================
    {
      "id": "offgrid_is_turu",
      "label": "Yapılacak Off-Grid Sistem Türü",
      "type": "single",
      "required": true,
      "dependsOnId": "is_turu",
      "dependsOnValue": ["🏕 Off-Grid / Mobil Enerji Sistemleri"],
      "options": OffGridMobilEnerjiSorulari.sorular.firstWhere((e) => e["id"] == "is_turu")["options"],
    },
    ...OffGridMobilEnerjiSorulari.sorular.where((s) => s["id"] != "is_turu").map((s) {
      if (s["dependsOnId"] == "is_turu") {
        return {...s, "dependsOnId": "offgrid_is_turu"};
      }
      return s;
    }),
  ];
}