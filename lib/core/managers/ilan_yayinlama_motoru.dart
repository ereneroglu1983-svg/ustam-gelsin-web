import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/services/sosyal_medya.dart';
import 'package:ustam_gelsin/core/managers/price_calculation_manager.dart';

class IlanYayinlamaMotoru {
  static Future<void> ilanYayinla({
    required BuildContext context,
    required IlanModel ilan,
    required Map<String, dynamic> detaylar,
    required String notlar,
    required String guncelFiyat,
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
    if (user == null) return;

    // Moderasyon Kontrolü
    bool ilanOnayBekliyorMu = false;
    try {
      var modDoc = await FirebaseFirestore.instance.collection('settings').doc('moderasyon_ayarlari').get();
      if (modDoc.exists) {
        List<dynamic> seciliBolgeler = modDoc.data()?['secili_bolgeler'] ?? [];
        ilanOnayBekliyorMu = seciliBolgeler.any((b) =>
        b['sehir_id'].toString() == secilenIlId &&
            (b['ilceler'] as List).any((i) => i['id'].toString() == secilenIlceId));
      }
    } catch (e) {
      debugPrint("Moderasyon kontrol hatası: $e");
    }

    final double netTutar = PriceCalculationManager.fiyatTemizle(guncelFiyat);
    final yeniIlan = ilan.copyWith(
      teknikDetaylar: Map<String, dynamic>.from(detaylar),
      detaylar: notlar,
      fiyatBilgisi: guncelFiyat,
      durum: ilanOnayBekliyorMu ? 'onay_bekliyor' : 'aktif',
      musteriAd: user.displayName ?? "Müşteri",
      konumMetin: "$secilenIl / $secilenIlce",
      ilId: secilenIlId,
      ilceId: secilenIlceId,
      latitude: lat,
      longitude: lng,
      komisyonTutari: netTutar * 0.01,
    );

    try {
      await AdService().ilanOlustur(yeniIlan);

      // Sosyal Medya (Sadece Facebook)
      if (!ilanOnayBekliyorMu) {
        await SosyalMedyaMotoru.facebookPaylas(yeniIlan.baslik, yeniIlan.konumMetin, yeniIlan.kategori, detaylar, "");
      }

      // AI Veri Kaydı
      await FirebaseFirestore.instance.collection('app_ai_data').add({
        'userId': user.uid,
        'kategori': ilan.kategori,
        'sistemFiyat': netTutar,
        'musteriDegerlendirmesi': secilenGeriBildirim ?? "Belirtilmedi",
        'musterininIstedigiFiyat': (ozelFiyatGoster && fiyatDuzenleMetin.isNotEmpty)
            ? double.tryParse(fiyatDuzenleMetin.replaceAll('.', ''))
            : null,
        'detaylar': detaylar,
        'notlar': notlar,
        'tarih': FieldValue.serverTimestamp(),
        'konum': "$secilenIl / $secilenIlce",
        'latitude': lat,
        'longitude': lng,
      });

      onResult(
          ilanOnayBekliyorMu ? "İlanınız İncelemede!" : "İlanınız Yayınlandı!",
          ilanOnayBekliyorMu ? "İlanınız moderasyon sürecine alındı." : "İlanınız başarıyla yayına girdi."
      );
    } catch (e) {
      rethrow;
    }
  }
}