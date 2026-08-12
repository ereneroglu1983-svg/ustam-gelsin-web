// lib/core/managers/ilan_yayinlama_motoru.dart - REVIZE FINAL V9
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/services/sosyal_medya.dart';

class IlanYayinlamaMotoru {
  static const String _defaultGorselUrl = 'https://pub-63efa1c2a7de49f4a20c67bfcefeb342.r2.dev/default.jpg';

  // SİSTEM KURALI: 15.000 TL altı sabit 150 TL, 15.000 TL ve üzeri net %1 (Orkestradan gelen net ortalama bütçeye göre)
  static double _komisyonHesapla(double muhtemelButce) {
    try {
      if (muhtemelButce < 15000) {
        return 150.0;
      } else {
        return muhtemelButce * 0.01;
      }
    } catch (e) {
      return 150.0;
    }
  }

  static Future<void> ilanYayinla({
    required BuildContext context,
    required IlanModel ilan,
    required Map<String, dynamic> detaylar,
    required List<String> resimler,
    required String notlar,
    required String fiyatBilgisi,
    required double minimumButce,
    required double maksimumButce,
    required double muhtemelButce,
    required String secilenIl,
    required String secilenIlce,
    required String secilenIlId,
    required String secilenIlceId,
    required String? secilenGeriBildirim,
    required bool ozelFiyatGoster,
    required String fiyatDuzenleMetin,
    required double lat,
    required double lng,
    required Function(String title, String content) onResult,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      onResult("Hata", "Oturum bulunamadı. Lütfen tekrar giriş yapın.");
      return;
    }

    bool ilanOnayBekliyorMu = false;
    try {
      var modDoc = await FirebaseFirestore.instance.collection('settings').doc('moderasyon_ayarlari').get();
      if (modDoc.exists) {
        List<dynamic> seciliBolgeler = modDoc.data()?['secili_bolgeler'] ?? [];
        ilanOnayBekliyorMu = seciliBolgeler.any((b) => b['sehir_id'].toString() == secilenIlId && (b['ilceler'] as List).any((i) => i['id'].toString() == secilenIlceId));
      }
    } catch (e) {
      debugPrint("Moderasyon kontrol hatası: $e");
    }

    final double komisyon = _komisyonHesapla(muhtemelButce);

    debugPrint("💰 ILAN MOTORU: fiyat=$fiyatBilgisi min=$minimumButce max=$maksimumButce ort=$muhtemelButce komisyon -> $komisyon");

    final bool isAcilMi = detaylar['isAcil'] == true;
    Map<String, dynamic> guncelTeknikDetaylar = Map<String, dynamic>.from(detaylar);

    final yeniIlan = ilan.copyWith(
      teknikDetaylar: guncelTeknikDetaylar,
      resimler: resimler,
      detaylar: notlar,
      fiyatBilgisi: fiyatBilgisi,
      minimumButce: minimumButce,
      maksimumButce: maksimumButce,
      muhtemelButce: muhtemelButce,
      fiyatAraligi: fiyatBilgisi,
      durum: ilanOnayBekliyorMu ? 'onay_bekliyor' : 'aktif',
      musteriAd: user.displayName ?? "Müşteri",
      konumMetin: "$secilenIl / $secilenIlce",
      ilId: secilenIlId,
      ilceId: secilenIlceId,
      latitude: lat,
      longitude: lng,
      komisyonTutari: komisyon,
      komisyonTabani: muhtemelButce,
      isAcil: isAcilMi,
    );

    try {
      await AdService().ilanOlustur(yeniIlan);

      if (!ilanOnayBekliyorMu) {
        final String gorsel = resimler.isNotEmpty ? resimler.first : _defaultGorselUrl;
        try {
          await SosyalMedyaMotoru.facebookPaylas(yeniIlan.baslik, yeniIlan.konumMetin, yeniIlan.kategori, detaylar, gorsel);
        } catch (e) {
          debugPrint("Sosyal medya paylaşım hatası: $e");
        }
      }

      double? anketFiyat;
      if (secilenGeriBildirim == "Fiyat çok yüksek" && fiyatDuzenleMetin.isNotEmpty) {
        final temiz = fiyatDuzenleMetin.replaceAll(RegExp(r'[^\d]'), '');
        anketFiyat = double.tryParse(temiz);
      }

      await FirebaseFirestore.instance.collection('app_ai_data').add({
        'userId': user.uid,
        'kategori': ilan.kategori,
        'fiyatBilgisi': fiyatBilgisi,
        'minimumButce': minimumButce,
        'maksimumButce': maksimumButce,
        'muhtemelButce': muhtemelButce,
        'sistemFiyat': muhtemelButce,
        'komisyonTutari': komisyon,
        'musteriDegerlendirmesi': secilenGeriBildirim ?? "Belirtilmedi",
        'musterininIstedigiFiyat': anketFiyat,
        'detaylar': detaylar,
        'resimler': resimler,
        'notlar': notlar,
        'tarih': FieldValue.serverTimestamp(),
        'konum': "$secilenIl / $secilenIlce",
        'latitude': lat,
        'longitude': lng,
      });

      onResult(ilanOnayBekliyorMu ? "İlanınız İncelemede!" : "İlanınız Yayınlandı!", ilanOnayBekliyorMu ? "İlanınız moderasyon sürecine alındı." : "İlanınız başarıyla yayına girdi.");
    } catch (e) {
      debugPrint("IlanYayinlamaMotoru hata: $e");
      onResult("Hata Oluştu", "İlan yayınlanırken bir sorun oluştu.");
    }
  }
}