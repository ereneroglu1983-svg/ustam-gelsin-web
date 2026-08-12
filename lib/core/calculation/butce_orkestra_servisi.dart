// lib/core/calculation/butce_orkestra_servisi.dart - FINAL V11 - ICON LOG + KATEGORI BAGIMSIZ - DOTENV TEMIZLENDI - FIXED
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // ✅ BU EKSİKTİ, GERİ EKLENDİ
import '../services/grok_provider.dart';
import '../services/groq_provider.dart';
import '../services/fiyat_hesaplama_robotu.dart';

class ButceOrkestraServisi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GrokProvider _grok = GrokProvider();
  static final GroqProvider _groq = GroqProvider();

  static String _hashUret({
    required String kategoriId,
    required String ilId,
    required Map<String, dynamic> teknikDetaylar,
  }) {
    final normalized = teknikDetaylar.entries
        .map((e) => "${e.key.trim().toLowerCase()}:${e.value.toString().trim().toLowerCase()}")
        .toList()
      ..sort();
    final raw = "$kategoriId|$ilId|${normalized.join('|')}";
    return raw.hashCode.toUnsigned(32).toString();
  }

  static Future<String> _llamaYedekFiyatTahmini({
    required String ilanBasligi,
    required String kategoriAdi,
    required Map<String, dynamic> detaylar,
  }) async {
    const apiKey = String.fromEnvironment('OPENROUTER_API_KEY');
    if (apiKey.isEmpty) throw Exception("OPENROUTER_API_KEY_YOK - --dart-define ile verilmedi");
    String detayStr = detaylar.entries.map((e) => "${e.key}:${e.value}").join(", ");
    final prompt = "TR 2026 guncel fiyat. Sadece rakam ver. Is:$ilanBasligi, Kategori:$kategoriAdi, Detay:$detayStr, Bolge:${detaylar['BOLGE']}. Ornek: 6500";
    final res = await http.post(
      Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://hemenustamgelsin.com",
        "X-Title": "HemenUstamGelsin",
      },
      body: jsonEncode({
        "model": "meta-llama/llama-3.3-70b:free",
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.1,
        "max_tokens": 30
      }),
    );
    if (res.statusCode!= 200) throw Exception("LLAMA_HATA ${res.statusCode}");
    final raw = jsonDecode(res.body)['choices'][0]['message']['content'].toString();
    debugPrint("🦙 [LLAMA RAW] $raw");
    final m = RegExp(r'\d{3,9}').allMatches(raw.replaceAll(RegExp(r'[.,\s₺]'), ''));
    if (m.isEmpty) throw Exception("Llama fiyat yok: $raw");
    int price = int.parse(m.last.group(0)!);
    if (price < 500) price *= 1000;
    return "${NumberFormat("#,###", "tr_TR").format(price).replaceAll(',', '.')} ₺";
  }

  static Future<Map<String, dynamic>> silsileYurut({
    required String talepId,
    required String kategoriAdi,
    required String kategoriId,
    String? ilanBasligi,
    required List<Map<String, dynamic>> kullaniciCevaplari,
    required Map<String, dynamic> yerelHafizaVerisi,
    required String anlikBolgeKodu,
    required String anlikKullaniciSegmenti,
  }) async {
    String gercekIsAdi = (ilanBasligi!= null && ilanBasligi.trim().isNotEmpty)? ilanBasligi.trim() : kategoriAdi;
    debugPrint("🎼 ========== [ORKESTRA BAŞLADI] ==========");
    debugPrint("📋 [GİREN] BAŞLIK: $gercekIsAdi | KATEGORİ: $kategoriAdi ($kategoriId) | BÖLGE: $anlikBolgeKodu | TALEP: $talepId");

    final Map<String, dynamic> detayMap = {
      for (var item in kullaniciCevaplari) item['id'].toString(): item['cevap']
    };
    detayMap['bolgeKodu'] = anlikBolgeKodu;
    detayMap['BOLGE'] = anlikBolgeKodu;
    detayMap['kategoriId'] = kategoriId;
    detayMap['kategoriAdi'] = kategoriAdi;

    String ilId = yerelHafizaVerisi['ilId']?.toString()?? "";
    if (ilId.isEmpty && int.tryParse(anlikBolgeKodu)!= null) ilId = anlikBolgeKodu;

    final Map<String, dynamic> teknikDetaylarMap = Map<String, dynamic>.from(detayMap)
      ..removeWhere((k, v) => ['bolgeKodu', 'BOLGE', 'kategoriId', 'kategoriAdi'].contains(k));

    final String analizHash = _hashUret(kategoriId: kategoriId, ilId: ilId, teknikDetaylar: teknikDetaylarMap);
    debugPrint("🔑 [HASH] $analizHash | ilId:$ilId | detayCount:${teknikDetaylarMap.length}");

    try {
      debugPrint("💾 [1.FIREBASE CACHE KONTROL] ilanlar koleksiyonu taranıyor...");
      final cache = await _firebaseIlanCacheKontrol(kategoriId: kategoriId, ilId: ilId, teknikDetaylar: teknikDetaylarMap, hash: analizHash);
      if (cache!= null) {
        debugPrint("💾✅ [1.FIREBASE BULDU!] FİYAT: ${cache['fiyatBilgisi']} | KAYNAK: FIREBASE_ILANLAR_CACHE | HASH: $analizHash");
        debugPrint("🎼 ========== [ORKESTRA BİTTİ - CACHE] ==========");
        return {"robotSonucu": cache, "kaynak": "FIREBASE_ILANLAR_CACHE", "talepId": talepId};
      }
      debugPrint("💾❌ [1.FIREBASE BOŞ] Benzer ilan yok, 👑 GROK'a geçiliyor");
    } catch (e, s) {
      debugPrint("💾⚠ [1.FIREBASE HATA] $e | Stack: $s");
      debugPrint("💾➡ [1.FIREBASE] Hata, 👑 GROK'a düşüyor");
    }

    try {
      debugPrint("👑 [2.GROK DENENİYOR] isAdi: $gercekIsAdi | detay: ${detayMap.length} alan");
      String fiyatStr = await _grok.getFiyatTahmini(
        isAdi: gercekIsAdi,
        kategoriAdi: kategoriAdi,
        kategoriId: kategoriId,
        detaylar: detayMap,
      );
      int ort = int.tryParse(fiyatStr.replaceAll(RegExp(r'[^0-9]'), ''))?? 0;
      if (ort <= 0) throw Exception("GROK geçersiz fiyat: $fiyatStr");
      double min = ort * 0.95;
      double max = ort * 1.05;
      final sonuc = {
        "minimumButce": min,
        "muhtemelButce": ort.toDouble(),
        "maksimumButce": max,
        "fiyatBilgisi": fiyatStr,
        "aralikliFiyatBilgisi": "${NumberFormat("#,###", "tr_TR").format(min.toInt()).replaceAll(',', '.')} - ${NumberFormat("#,###", "tr_TR").format(max.toInt()).replaceAll(',', '.')} ₺",
        "kaynak": "AI_GROK_4_3",
        "durum": "BASARILI",
        "analizHash": analizHash,
      };
      debugPrint("👑✅ [2.GROK BAŞARILI!] FİYAT: $fiyatStr | KAYNAK: AI_GROK_4_3");
      debugPrint("🎼 ========== [ORKESTRA BİTTİ - GROK] ==========");
      return {"robotSonucu": sonuc, "kaynak": "AI_GROK_4_3", "talepId": talepId};
    } catch (e, stack) {
      debugPrint("👑❌ [2.GROK HATA] $e | Stack: ${stack.toString().substring(0, 300)}");
      debugPrint("👑➡ [2.GROK] Hata, ⚡ GROQ'a geçiliyor");
    }

    try {
      debugPrint("⚡ [3.GROQ YEDEK 1 DENENİYOR] $gercekIsAdi | Bölge: $anlikBolgeKodu");
      String fiyatStr = await _groq.getFiyatTahmini(
        musteriId: talepId,
        isAdi: gercekIsAdi,
        kategoriAdi: kategoriAdi,
        kategoriId: kategoriId,
        detaylar: detayMap,
      );
      int ort = int.tryParse(fiyatStr.replaceAll(RegExp(r'[^0-9]'), ''))?? 0;
      if (ort <= 0) throw Exception("GROQ geçersiz: $fiyatStr");
      double min = ort * 0.9;
      double max = ort * 1.1;
      final sonuc = {
        "minimumButce": min,
        "muhtemelButce": ort.toDouble(),
        "maksimumButce": max,
        "fiyatBilgisi": fiyatStr,
        "aralikliFiyatBilgisi": "${min.toInt()} - ${max.toInt()} ₺",
        "kaynak": "AI_GROQ",
        "durum": "BASARILI",
        "analizHash": analizHash,
      };
      debugPrint("⚡✅ [3.GROQ BAŞARILI!] FİYAT: $fiyatStr | KAYNAK: AI_GROQ");
      debugPrint("🎼 ========== [ORKESTRA BİTTİ - GROQ] ==========");
      return {"robotSonucu": sonuc, "kaynak": "AI_GROQ", "talepId": talepId};
    } catch (e, stack) {
      debugPrint("⚡❌ [3.GROQ HATA] $e | Stack: ${stack.toString().substring(0, 300)}");
      debugPrint("⚡➡ [3.GROQ] Hata, 🦙 LLAMA'ya geçiliyor");
    }

    try {
      debugPrint("🦙 [4.LLAMA YEDEK 2 DENENİYOR] $gercekIsAdi");
      String fiyatStr = await _llamaYedekFiyatTahmini(ilanBasligi: gercekIsAdi, kategoriAdi: kategoriAdi, detaylar: detayMap);
      int ort = int.tryParse(fiyatStr.replaceAll(RegExp(r'[^0-9]'), ''))?? 0;
      if (ort <= 0) throw Exception("LLAMA geçersiz: $fiyatStr");
      double min = ort * 0.9;
      double max = ort * 1.1;
      final sonuc = {
        "minimumButce": min,
        "muhtemelButce": ort.toDouble(),
        "maksimumButce": max,
        "fiyatBilgisi": fiyatStr,
        "aralikliFiyatBilgisi": "${min.toInt()} - ${max.toInt()} ₺",
        "kaynak": "AI_LLAMA_3_3_FREE",
        "durum": "BASARILI",
        "analizHash": analizHash,
      };
      debugPrint("🦙✅ [4.LLAMA BAŞARILI!] FİYAT: $fiyatStr | KAYNAK: AI_LLAMA_3_3_FREE");
      debugPrint("🎼 ========== [ORKESTRA BİTTİ - LLAMA] ==========");
      return {"robotSonucu": sonuc, "kaynak": "AI_LLAMA_3_3_FREE", "talepId": talepId};
    } catch (e, stack) {
      debugPrint("🦙❌ [4.LLAMA HATA] $e | Stack: ${stack.toString().substring(0, 300)}");
      debugPrint("🦙➡ [4.LLAMA] Hata, 🦾 YEREL ROBOT'a geçiliyor");
    }

    try {
      debugPrint("🦾 [5.YEREL ROBOT SON KALE DENENİYOR] kategoriId:$kategoriId | Bölge: $anlikBolgeKodu");
      var doc = await _firestore.collection('kategoriler').doc(kategoriId).get();
      if (!doc.exists) doc = await _firestore.collection('form_schemas').doc(kategoriId).get();
      if (!doc.exists) throw Exception("Kategori verisi yok: $kategoriId");
      double yerelOrt = FiyatHesaplamaRobotu.hesapla(kategoriVerisi: doc.data()!, secilenler: detayMap, sehir: anlikBolgeKodu);
      if (yerelOrt <= 0) throw Exception("Yerel robot 0 döndü");
      double min = yerelOrt * 0.9;
      double max = yerelOrt * 1.1;
      final sonuc = {
        "minimumButce": min,
        "muhtemelButce": yerelOrt,
        "maksimumButce": max,
        "fiyatBilgisi": "${yerelOrt.toInt()} ₺",
        "aralikliFiyatBilgisi": "${min.toInt()} - ${max.toInt()} ₺",
        "kaynak": "YEREL_ROBOT",
        "durum": "BASARILI",
        "analizHash": analizHash,
      };
      debugPrint("🦾✅ [5.YEREL ROBOT BAŞARILI!] FİYAT: ${sonuc['aralikliFiyatBilgisi']} | KAYNAK: YEREL_ROBOT");
      debugPrint("🎼 ========== [ORKESTRA BİTTİ - YEREL] ==========");
      return {"robotSonucu": sonuc, "kaynak": "YEREL_ROBOT", "talepId": talepId};
    } catch (yerelHata, yerelStack) {
      debugPrint("🦾❌ [5.YEREL ROBOT ÇÖKTÜ!] HATA: $yerelHata");
      debugPrint("🦾💥 [SİSTEM TAMAMEN ÇÖKTÜ!] Stack: $yerelStack");
      debugPrint("🎼 ========== [ORKESTRA BİTTİ - ÇÖKÜŞ] ==========");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> _firebaseIlanCacheKontrol({
    required String kategoriId,
    required String ilId,
    required Map<String, dynamic> teknikDetaylar,
    required String hash,
  }) async {
    try {
      debugPrint("💾 [CACHE DETAY] kategoriId:$kategoriId | ilId:$ilId | hash:$hash");
      var snap = await _firestore.collection('ilanlar').where('kategoriId', isEqualTo: kategoriId).where('analizHash', isEqualTo: hash).where('durum', isEqualTo: 'aktif').limit(1).get();
      if (snap.docs.isNotEmpty) {
        String fiyat = snap.docs.first.data()['fiyatBilgisi']?.toString()?? "";
        int ort = int.tryParse(fiyat.replaceAll(RegExp(r'[^0-9]'), ''))?? 0;
        if (ort > 0) {
          debugPrint("💾 [CACHE] analizHash ile bulundu -> $fiyat");
          return {
            "minimumButce": ort * 0.9,
            "muhtemelButce": ort.toDouble(),
            "maksimumButce": ort * 1.1,
            "fiyatBilgisi": fiyat,
            "aralikliFiyatBilgisi": "${(ort * 0.9).toInt()} - ${(ort * 1.1).toInt()} ₺",
            "kaynak": "FIREBASE_ILANLAR_CACHE",
            "durum": "BASARILI",
            "analizHash": hash,
          };
        }
      }
      debugPrint("💾 [CACHE] Hash yok, teknikDetaylar birebir taranıyor...");
      var yedekSnap = await _firestore.collection('ilanlar').where('kategoriId', isEqualTo: kategoriId).where('durum', isEqualTo: 'aktif').limit(25).get();
      debugPrint("💾 [CACHE] ${yedekSnap.docs.length} aktif ilan bulundu, karşılaştırılıyor");
      for (var doc in yedekSnap.docs) {
        var data = doc.data();
        var dbTeknik = data['teknikDetaylar'] as Map<String, dynamic>?;
        if (dbTeknik == null || dbTeknik.length!= teknikDetaylar.length) continue;
        bool eslesiyor = true;
        for (var k in teknikDetaylar.keys) {
          if (dbTeknik[k]?.toString().trim().toLowerCase()!= teknikDetaylar[k]?.toString().trim().toLowerCase()) {
            eslesiyor = false;
            break;
          }
        }
        if (!eslesiyor) continue;
        if (ilId.isNotEmpty && ilId!= "0" && data['ilId']?.toString()!= ilId) continue;
        String fiyat = data['fiyatBilgisi']?.toString()?? "";
        int ort = int.tryParse(fiyat.replaceAll(RegExp(r'[^0-9]'), ''))?? 0;
        if (ort > 0) {
          debugPrint("💾 [CACHE] teknikDetaylar eşleşti! Doc: ${doc.id} -> $fiyat");
          return {
            "minimumButce": ort * 0.9,
            "muhtemelButce": ort.toDouble(),
            "maksimumButce": ort * 1.1,
            "fiyatBilgisi": fiyat,
            "aralikliFiyatBilgisi": "${(ort * 0.9).toInt()} - ${(ort * 1.1).toInt()} ₺",
            "kaynak": "FIREBASE_ILANLAR_CACHE",
            "durum": "BASARILI",
            "analizHash": hash,
          };
        }
      }
      debugPrint("💾 [CACHE] Hiç eşleşme yok");
    } catch (e) {
      debugPrint("💾⚠ [CACHE KONTROL HATASI] $e");
    }
    return null;
  }
}