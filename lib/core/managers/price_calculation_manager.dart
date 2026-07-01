import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/services/gemini_service.dart';
import 'package:ustam_gelsin/core/calculation/butce_orkestra_servisi.dart';

class PriceCalculationManager {
  final GeminiService _geminiService = GeminiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const int _cacheTazelikSuresiGun = 20;

  static double fiyatTemizle(String fiyat) => double.tryParse(fiyat.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;

  Future<String> orkestraFiyatHesapla({
    required String userId,
    required String baslik,
    required String kategori,
    required String kategoriId,
    required Map<String, dynamic> detaylar,
  }) async {
    final String cacheKey = _generateSecureCacheKey(kategori, detaylar);

    try {
      var cacheDoc = await _firestore.collection('fiyat_arsivi').doc(cacheKey).get();
      if (cacheDoc.exists) {
        Timestamp tarih = cacheDoc['hesaplamaTarihi'] as Timestamp;
        if (DateTime.now().difference(tarih.toDate()).inDays < _cacheTazelikSuresiGun) {
          debugPrint("⚡ [CACHE HIT] $cacheKey");
          return cacheDoc['fiyat'].toString();
        }
      }
    } catch (e) {
      debugPrint("❌ [CACHE READ ERROR] $e");
    }

    String sonuc;
    try {
      String aiRaw = await _geminiService.getFiyatTahmini(
        musteriId: userId,
        isAdi: baslik,
        kategoriAdi: kategori,
        kategoriId: kategoriId,
        detaylar: detaylar,
      ).timeout(const Duration(seconds: 8));

      if (aiRaw.isEmpty || aiRaw == "0" || aiRaw.length > 10) throw Exception("Geçersiz AI");
      sonuc = aiRaw;

      // TAKİP MEKANİZMASI:
      debugPrint("✅ [HESAPLAMA] Kaynak: GEMİNİ AI | Sonuç: $sonuc");

    } catch (e) {
      // TAKİP MEKANİZMASI:
      debugPrint("⚠️ [HESAPLAMA] Kaynak: YEREL ROBOT (Fallback) | Hata: $e");
      sonuc = _yerelHesapla(kategori, detaylar);
    }

    await _saveToCache(cacheKey, sonuc, kategori);
    return sonuc;
  }

  String _yerelHesapla(String kategori, Map<String, dynamic> detaylar) {
    List<dynamic> cevaplarListesi = detaylar.entries.map((e) => {"id": e.key, "cevap": e.value}).toList();
    final Map<String, dynamic> rapor = ButceOrkestraServisi.yerelRobotHesapla(
      kategori: kategori,
      gelenCevaplar: cevaplarListesi,
    );

    double maliyet = (rapor['tahminiButce'] as num? ?? 0.0).toDouble();
    double taban = _getAgirlikliTabanFiyat(kategori);
    double agirlikKatsayisi = 1.0 + (detaylar.length * 0.1);
    double finalMaliyet = (maliyet < taban ? taban : maliyet) * agirlikKatsayisi;

    return "${finalMaliyet.round()} ₺";
  }

  double _getAgirlikliTabanFiyat(String kategori) {
    if (RegExp(r'(KOMPLE|PREFABRİK|HAVUZ)').hasMatch(kategori)) return 100000.0;
    if (RegExp(r'(ÇATI|ALÜMİNYUM|CEPHE|TADİLAT)').hasMatch(kategori)) return 30000.0;
    if (RegExp(r'(DOLAP|KAPI|PARKE|BOYA|ALÇI|FAYANS)').hasMatch(kategori)) return 8000.0;
    if (RegExp(r'(ELEKTRİK|SIHHI|KLİMA|ASANSÖR|KOMBİ|UYDU)').hasMatch(kategori)) return 3500.0;
    return 3000.0;
  }

  String _generateSecureCacheKey(String kategori, Map<String, dynamic> detaylar) {
    final sortedMap = Map.fromEntries(detaylar.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    return sha256.convert(utf8.encode("${kategori}_${jsonEncode(sortedMap)}")).toString().substring(0, 40);
  }

  Future<void> _saveToCache(String key, String fiyat, String kategori) async {
    try {
      await _firestore.collection('fiyat_arsivi').doc(key).set({
        'fiyat': fiyat,
        'kategori': kategori,
        'hesaplamaTarihi': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ [CRITICAL] Cache Yazılamadı: $e");
    }
  }

  String formatFiyatGosterim(String text) => text.contains('₺') ? "Tahmini: $text" : "Tahmini: $text ₺";
}