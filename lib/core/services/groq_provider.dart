// lib/core/services/groq_provider.dart - FINAL V5 - SIRALAMA FIX - TAM KOD
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../env.dart';
import 'ai_price_provider.dart';

class GroqProvider implements AiPriceProvider {
  @override
  String get providerName => "groq_final_v5";

  String _slugBul(String kategoriId, String kategoriAdi) {
    String ad = kategoriAdi.toLowerCase().trim();

    // DİKKAT: Dart Map sırası garanti değil! O yüzden List kullanıyoruz.
    // Uzun ve özel olanlar EN ÜSTTE olmalı, genel olanlar EN ALTTA!
    final List<MapEntry<String, String>> ordered = [
      // ELEKTRİK EN ÜSTE - tesisat'tan önce yakalanmalı!
      MapEntry('elektrik tesisatı', 'elektrik_tesisat'),
      MapEntry('elektrik tesisat', 'elektrik_tesisat'),
      MapEntry('elektrikli araç şarj', 'elektrikli_arac'),
      MapEntry('elektrikli arac', 'elektrikli_arac'),
      MapEntry('şarj istasyonu', 'elektrikli_arac'),

      // SIHHİ TESİSAT
      MapEntry('sıhhi tesisat', 'sihhi_tesisat'),
      MapEntry('sihhi tesisat', 'sihhi_tesisat'),

      // BOYA
      MapEntry('iç cephe boya', 'ic_boya'),
      MapEntry('ic cephe boya', 'ic_boya'),
      MapEntry('dış cephe boyası', 'dis_cephe'),
      MapEntry('dış cephe', 'dis_cephe'),
      MapEntry('dis cephe', 'dis_cephe'),
      MapEntry('italyan boya', 'italyan_boya'),

      // ÖZEL İSİMLER
      MapEntry('bina temizlik hesaplayici', 'bina_temizlik_hesaplayici'),
      MapEntry('bina temizlik', 'bina_temizlik_hesaplayici'),
      MapEntry('otomatik sulama', 'otomatik_sulama'),
      MapEntry('havuz sistemleri', 'havuz_sistemleri'),
      MapEntry('havuz sistemi', 'havuz_sistemleri'),
      MapEntry('güneş enerjisi', 'gunes_enerjisi'),
      MapEntry('gunes enerjisi', 'gunes_enerjisi'),
      MapEntry('enerji depolama', 'enerji_depolama'),
      MapEntry('off grid mobil', 'off_grid_mobil_enerji'),
      MapEntry('off grid', 'off_grid_mobil_enerji'),
      MapEntry('off_grid', 'off_grid_mobil_enerji'),
      MapEntry('komple tadilat', 'komple_tadilat'),
      MapEntry('anahtar teslim', 'komple_tadilat'),
      MapEntry('bahçe peyzaj', 'bahce_peyzaj'),
      MapEntry('bahce peyzaj', 'bahce_peyzaj'),
      MapEntry('duvar kağıdı', 'duvar_kagidi'),
      MapEntry('duvar kagidi', 'duvar_kagidi'),
      MapEntry('parke döşeme', 'parke_doseme'),
      MapEntry('pvc doğrama', 'pvc_dograma'),
      MapEntry('pvc dograma', 'pvc_dograma'),
      MapEntry('kapı sistemleri', 'kapi_sistemleri'),
      MapEntry('kapi sistemleri', 'kapi_sistemleri'),
      MapEntry('cam balkon', 'cam_balkon'),
      MapEntry('çatı işleri', 'cati_isleri'),
      MapEntry('cati isleri', 'cati_isleri'),
      MapEntry('panel şingıl', 'panel_singil'),
      MapEntry('panel singil', 'panel_singil'),
      MapEntry('mutfak dolabı', 'mutfak_dolabi'),
      MapEntry('mutfak dolabi', 'mutfak_dolabi'),
      MapEntry('gömme dolap', 'gomme_dolap'),
      MapEntry('gomme dolap', 'gomme_dolap'),
      MapEntry('banyo dolap', 'banyo_vestiyer'),
      MapEntry('doğalgaz', 'dogalgaz_kombi'),
      MapEntry('dogalgaz', 'dogalgaz_kombi'),
      MapEntry('klima servis', 'klima_servis'),
      MapEntry('klima servisi', 'klima_servis'),
      MapEntry('sineklik', 'sineklik_panjur'),
      MapEntry('panjur', 'sineklik_panjur'),
      MapEntry('gergi tavan', 'gergi_tavan'),
      MapEntry('asma tavan', 'gergi_tavan'),
      MapEntry('asmatavan', 'gergi_tavan'),
      MapEntry('bölme duvar', 'bolme_duvar'),
      MapEntry('bolme duvar', 'bolme_duvar'),
      MapEntry('su yalıtım', 'su_yalitimi'),
      MapEntry('su yalitimi', 'su_yalitimi'),

      // GENEL - EN SONDA
      MapEntry('iç boya', 'ic_boya'),
      MapEntry('parke', 'parke_doseme'),
      MapEntry('fayans', 'fayans_seramik'),
      MapEntry('seramik', 'fayans_seramik'),
      MapEntry('mermer', 'mermer_granit'),
      MapEntry('granit', 'mermer_granit'),
      MapEntry('epoksi', 'epoksi_zemin'),
      MapEntry('sistre', 'sistre_cila'),
      MapEntry('alçıpan', 'bolme_duvar'),
      MapEntry('kartonpiyer', 'kartonpiyer'),
      MapEntry('çatı', 'cati_isleri'),
      MapEntry('cati', 'cati_isleri'),
      MapEntry('panel', 'panel_singil'),
      MapEntry('şingıl', 'panel_singil'),
      MapEntry('singil', 'panel_singil'),
      MapEntry('ferforje', 'ferforje_metal'),
      MapEntry('metal', 'ferforje_metal'),
      MapEntry('prefabrik', 'prefabrik_yapi'),
      MapEntry('mutfak', 'mutfak_dolabi'),
      MapEntry('vestiyer', 'banyo_vestiyer'),
      MapEntry('banyo', 'banyo_vestiyer'),
      MapEntry('marangoz', 'marangozluk'),
      MapEntry('marangozluk', 'marangozluk'),
      MapEntry('kombi', 'dogalgaz_kombi'),
      MapEntry('klima', 'klima_servis'),
      MapEntry('uydu', 'uydu_kamera'),
      MapEntry('kamera', 'uydu_kamera'),
      MapEntry('peyzaj', 'bahce_peyzaj'),
      MapEntry('bahçe', 'bahce_peyzaj'),
      MapEntry('sulama', 'otomatik_sulama'),
      MapEntry('havuz', 'havuz_sistemleri'),
      MapEntry('ges', 'ges'),
      MapEntry('res', 'res'),
      MapEntry('rüzgar', 'res'),
      MapEntry('ruzgar', 'res'),
      MapEntry('batarya', 'enerji_depolama'),
      MapEntry('tadilat', 'komple_tadilat'),
      MapEntry('temizlik', 'temizlik_hizmetleri'),
      // tesisat ve elektrik EN EN SONDA
      MapEntry('elektrik', 'elektrik_tesisat'),
      MapEntry('tesisat', 'sihhi_tesisat'),
    ];

    for (final entry in ordered) {
      if (ad.contains(entry.key)) {
        return entry.value;
      }
    }

    if (!RegExp(r'^\d+$').hasMatch(kategoriId) && kategoriId.length > 2) {
      return kategoriId.toLowerCase().trim();
    }

    return ad
        .replaceAll("ı", "i")
        .replaceAll("ş", "s")
        .replaceAll("ğ", "g")
        .replaceAll("ü", "u")
        .replaceAll("ö", "o")
        .replaceAll("ç", "c")
        .replaceAll(" ", "_")
        .replaceAll("-", "_")
        .replaceAll("__", "_");
  }

  @override
  Future<String> getFiyatTahmini({
    required String musteriId,
    required String isAdi,
    required String kategoriAdi,
    required String kategoriId,
    Map<String, dynamic>? detaylar,
  }) async {
    final String apiKey = Env.groqApiKey;
    if (apiKey.isEmpty) {
      throw Exception("GROQ API_KEY YOK - Env.groqApiKey bos");
    }

    final String slug = _slugBul(kategoriId, kategoriAdi);
    debugPrint("🔧 GROQ SLUG FIX: id=[$kategoriId] ad=[$kategoriAdi] -> slug=[$slug]");

    double tabanM2 = 200;
    Map<String, dynamic> alanKatsayi = {};
    Map<String, dynamic> carpanlar = {};
    int minFiyat = 0;
    int maxFiyat = 0;

    try {
      final doc = await FirebaseFirestore.instance.collection('meslek_fiyat_tarifeleri').doc(slug).get();

      if (doc.exists && doc.data()!= null) {
        final d = doc.data()!;
        tabanM2 = (d['taban_m2']?? d['taban_fiyat']?? d['m2_fiyat']?? d['birim_fiyat']?? 200).toDouble();
        alanKatsayi = Map<String, dynamic>.from(d['alanKatsayilari']?? d['alan_katsayilari']?? d['alanKatsayisi']?? {});
        carpanlar = Map<String, dynamic>.from(d['carpanlar']?? d['carpan']?? d['carpanlar_map']?? {});
        minFiyat = (d['min_fiyat']?? d['minimum_fiyat']?? 0).toInt();
        maxFiyat = (d['max_fiyat']?? d['maksimum_fiyat']?? 0).toInt();
        debugPrint("✅ FIREBASE OK: $slug taban=$tabanM2 alanK=${alanKatsayi.length} carpan=${carpanlar.length} min=$minFiyat max=$maxFiyat");
      } else {
        debugPrint("⚠️ FIREBASE YOK: meslek_fiyat_tarifeleri/$slug bulunamadi, default 200 TL");
        tabanM2 = 200;
      }
    } catch (e) {
      debugPrint("⚠️ FIREBASE HATA: $e - default devam");
      tabanM2 = 200;
    }

    final String alanStr = (detaylar?['alan_kademe']?? detaylar?['alan']?? detaylar?['metrekare']?? "100").toString().toLowerCase();
    int m2 = 100;
    if (alanStr.contains("300") || alanStr.contains("500_uzeri")) {
      m2 = 320;
    } else if (alanStr.contains("250") || alanStr.contains("200") || alanStr.contains("251_500") || alanStr.contains("121_250")) {
      m2 = 220;
    } else if (alanStr.contains("120") || alanStr.contains("100") || alanStr.contains("51_120")) {
      m2 = 110;
    } else if (alanStr.contains("50") || alanStr.contains("1_50")) {
      m2 = 45;
    } else {
      final sayi = RegExp(r'\d+').firstMatch(alanStr);
      if (sayi!= null) {
        m2 = int.tryParse(sayi.group(0)!)?? 100;
      }
    }

    double alanK = 1.0;
    if (alanKatsayi.isNotEmpty) {
      try {
        if (m2 <= 50 && alanKatsayi.containsKey('1_50_kucuk_kamelya_garaj_sundurma')) {
          alanK = (alanKatsayi['1_50_kucuk_kamelya_garaj_sundurma'] as num).toDouble();
        } else if (m2 <= 120 && alanKatsayi.containsKey('51_120_standart_mustakil_kucuk_depo')) {
          alanK = (alanKatsayi['51_120_standart_mustakil_kucuk_depo'] as num).toDouble();
        } else if (m2 <= 250 && alanKatsayi.containsKey('121_250_genis_cati_orta_bina')) {
          alanK = (alanKatsayi['121_250_genis_cati_orta_bina'] as num).toDouble();
        } else if (m2 <= 500 && alanKatsayi.containsKey('251_500_buyuk_bina_kucuk_fabrika')) {
          alanK = (alanKatsayi['251_500_buyuk_bina_kucuk_fabrika'] as num).toDouble();
        } else if (m2 > 500 && alanKatsayi.containsKey('500_uzeri_buyuk_endustriyel')) {
          alanK = (alanKatsayi['500_uzeri_buyuk_endustriyel'] as num).toDouble();
        } else {
          alanK = (alanKatsayi.values.first as num).toDouble();
        }
      } catch (_) {
        alanK = 1.0;
      }
    } else {
      if (m2 >= 300) alanK = 0.85;
      else if (m2 <= 50) alanK = 1.35;
      else if (m2 <= 120) alanK = 1.12;
      else alanK = 1.0;
    }

    double tipK = 1.0;
    final String kalinlik = (detaylar?['kalinlik']?? detaylar?['panel_tip']?? detaylar?['malzeme']?? detaylar?['kaplama']?? "").toString().toLowerCase();
    if (carpanlar.isNotEmpty) {
      try {
        if (kalinlik.contains("40")) tipK = (carpanlar['40mm']?? carpanlar['40']?? 1.0).toDouble();
        else if (kalinlik.contains("50")) tipK = (carpanlar['50mm']?? carpanlar['50']?? 1.12).toDouble();
        else if (kalinlik.contains("60")) tipK = (carpanlar['60mm']?? carpanlar['60']?? 1.22).toDouble();
        else if (kalinlik.contains("80") || kalinlik.contains("100")) tipK = (carpanlar['80_100mm']?? carpanlar['80']?? 1.45).toDouble();
        else if (kalinlik.contains("sandvi") || kalinlik.contains("sandwic")) tipK = (carpanlar['sandvic_panel']?? carpanlar['sandvic']?? 1.18).toDouble();
      } catch (_) {
        tipK = 1.0;
      }
    }

    int kodTaban = (m2 * tabanM2 * alanK * tipK).toInt();
    if (kodTaban <= 0) kodTaban = (m2 * 200).toInt();

    debugPrint("📐 HESAP: m2=$m2 x taban=$tabanM2 x alanK=$alanK x tipK=$tipK = $kodTaban TL");

    final String detayStr = detaylar?.entries.where((e) =>!['bolgeKodu', 'sehir', 'ilce'].contains(e.key)).map((e) => "${e.key}:${e.value}").join(", ")?? "";

    final String prompt = """
Sen Turkiye insaat ve tadilat maliyet analistisin.
Is: $kategoriAdi
Slug: $slug
Detaylar: $detayStr
Firebase verisi: m2=$m2, taban_m2=$tabanM2 TL, alanKatsayisi=$alanK, tipCarpani=$tipK, hesaplananTaban=$kodTaban TL
GOREV: Bu veriyi dogrula ve mantikli nihai fiyati ver.
KURALLAR: Turkiye fiyati, sadece TL, Dolar Euro YASAK, Asla 0 verme, Sadece JSON: {"price": $kodTaban, "confidence": 92}
JSON:
""";

    try {
      final res = await http.post(
        Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "groq/compound-mini",
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "temperature": 0,
          "max_tokens": 60,
          "response_format": {"type": "json_object"}
        }),
      );

      if (res.statusCode!= 200) {
        debugPrint("❌ GROQ HATA ${res.statusCode}: ${res.body}");
        throw Exception("GROQ ${res.statusCode}");
      }

      final Map<String, dynamic> body = jsonDecode(res.body);
      final String raw = body['choices'][0]['message']['content'].toString();
      final Map<String, dynamic> decoded = jsonDecode(raw);
      int aiPrice = (decoded['price'] as num?)?.toInt()?? kodTaban;

      int finalPrice = aiPrice > 0? aiPrice : kodTaban;

      final String mekan = (detaylar?['mekan_durumu']?? "").toString().toLowerCase();
      final String tavan = (detaylar?['tavan_boyasi']?? "").toString().toLowerCase();
      final String zemin = (detaylar?['zemin_durumu']?? "").toString().toLowerCase();

      if (mekan.contains("boş") || mekan.contains("bos")) finalPrice = (finalPrice * 0.90).toInt();
      if (tavan.contains("evet")) finalPrice = (finalPrice * 1.15).toInt();
      if (zemin.contains("gerekir") || zemin.contains("evet")) finalPrice += 8000;

      if (minFiyat > 0 && finalPrice < minFiyat) finalPrice = minFiyat;
      if (maxFiyat > 0 && finalPrice > maxFiyat) finalPrice = maxFiyat;

      if (slug == 'ic_boya' && finalPrice > 95000) finalPrice = 85000;
      if (slug == 'ic_boya' && finalPrice < 8000) finalPrice = 12000;
      if (slug.contains('temizlik') && finalPrice > 35000) finalPrice = 18000;

      debugPrint("✅ FINAL: AI=$aiPrice KOD=$kodTaban -> FINAL=$finalPrice");
      final String formatted = NumberFormat("#,###", "tr_TR").format(finalPrice).replaceAll(',', '.');
      return "$formatted ₺";
    } catch (e) {
      debugPrint("⚠️ AI BASARISIZ, FIREBASE TABAN DONULUYOR: $e");
      int fallback = kodTaban;
      final String mekan = (detaylar?['mekan_durumu']?? "").toString().toLowerCase();
      if (mekan.contains("boş") || mekan.contains("bos")) fallback = (fallback * 0.90).toInt();
      final String formatted = NumberFormat("#,###", "tr_TR").format(fallback).replaceAll(',', '.');
      return "$formatted ₺";
    }
  }
}