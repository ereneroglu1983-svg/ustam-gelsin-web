// lib/utils/komsu_helper.dart
// FINAL - Komşu ilçe görünürlüğü - 973 ilçe için otomatik - mevcut sistemi bozmaz
import 'dart:convert';
import 'package:flutter/services.dart';

class KomsuHelper {
  static Map<String, List<String>> _komsuMap = {};
  static bool _loaded = false;

  // JSON'u bir kere yükle
  static Future<void> init() async {
    if (_loaded) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/komsu-ilceler.json');
      final Map<String, dynamic> raw = json.decode(jsonStr);
      _komsuMap = raw.map((k, v) => MapEntry(k, List<String>.from(v)));
      _loaded = true;
    } catch (e) {
      print("Komsu JSON yüklenemedi: $e");
      _komsuMap = {};
    }
  }

  // Salihli için komşuları getir: [turgutlu, akhisar, odemis...]
  static List<String> getKomsular(String ilSlug, String ilceSlug) {
    final key = "$ilSlug/$ilceSlug";
    return _komsuMap[key] ?? [];
  }

  // Poster sıralama puanı - senin Next.js'deki mantığın aynısı
  static int getScore({
    required String posterTamKonum, // manisa/salihli
    required String hedefIl,
    required String hedefIlce,
    required List<String> komsuListesi,
  }) {
    final hedefKey = "$hedefIl/$hedefIlce";
    if (posterTamKonum == hedefKey) return 100; // 1. Tam konum
    if (komsuListesi.contains(posterTamKonum)) return 80; // 2. Komşu ilçe
    if (posterTamKonum.startsWith("$hedefIl/")) return 50; // 3. Aynı il
    return 0;
  }
}

// Kullanımı - senin karisik_slider stream'inde
/*
// Örnek:
final komsular = KomsuHelper.getKomsular("manisa", "salihli");
// ["manisa/turgutlu", "manisa/akhisar", "izmir/odemis", ...]

final filtered = allPosters.map((p) {
  final score = KomsuHelper.getScore(
    posterTamKonum: p.tamKonum, // p.data['tamKonum']
    hedefIl: "manisa",
    hedefIlce: "salihli",
    komsuListesi: komsular,
  );
  return {...p, "_score": score};
}).where((p) => p["_score"] > 0)
  .toList()
..sort((a,b) => b["_score"].compareTo(a["_score"]));
*/