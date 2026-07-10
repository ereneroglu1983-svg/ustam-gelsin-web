// lib/core/calculation/meslek_sorulari/yenilenebilir_enerji/yenilenebilir_enerji.dart

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
        "☀️ Güneş Enerji Sistemleri (GES)",
        "🌬️ Rüzgar Enerji Sistemleri (RES)",
        "🔋 Enerji Depolama Sistemleri",
        "🚗 Elektrikli Araç Şarj İstasyonları",
        "🏕️ Off-Grid / Mobil Enerji Sistemleri"
      ]
    },

    // Alt dosyalardan gelen soruları 'is_turu' anahtarına bağlıyoruz.
    // .where ile alt dosyalardaki kendi 'is_turu' (ana seçim) sorularını eliyoruz
    // ve .map ile 'dependsOnId' değerlerini merkezi 'is_turu' ile güncelliyoruz.

    ...GesSorulari.sorular
        .where((s) => s["id"] != "is_turu")
        .map((s) => {...s, "dependsOnId": "is_turu", "dependsOnValue": ["☀️ Güneş Enerji Sistemleri (GES)"]}),

    ...RESSorulari.sorular
        .where((s) => s["id"] != "is_turu")
        .map((s) => {...s, "dependsOnId": "is_turu", "dependsOnValue": ["🌬️ Rüzgar Enerji Sistemleri (RES)"]}),

    ...EnerjiDepolamaSorulari.sorular
        .where((s) => s["id"] != "is_turu")
        .map((s) => {...s, "dependsOnId": "is_turu", "dependsOnValue": ["🔋 Enerji Depolama Sistemleri"]}),

    ...ElektrikliAracSorulari.sorular
        .where((s) => s["id"] != "is_turu")
        .map((s) => {...s, "dependsOnId": "is_turu", "dependsOnValue": ["🚗 Elektrikli Araç Şarj İstasyonları"]}),

    ...OffGridMobilEnerjiSorulari.sorular
        .where((s) => s["id"] != "is_turu")
        .map((s) => {...s, "dependsOnId": "is_turu", "dependsOnValue": ["🏕️ Off-Grid / Mobil Enerji Sistemleri"]}),
  ];
}