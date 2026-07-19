// lib/core/managers/ilan_yayinlama_motoru.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/services/sosyal_medya.dart';
import 'package:ustam_gelsin/core/managers/price_calculation_manager.dart';

class IlanYayinlamaMotoru {
  static const String _defaultGorselUrl = 'https://pub-63efa1c2a7de49f4a20c67bfcefeb342.r2.dev/default.jpg';

  // REVIZE EDILDI - Senin istedigin mantik: (min+max)/2 * %1
  static double _komisyonHesapla(String fiyatBilgisi) {
    try {
      // fiyatBilgisi artik "35.000 - 45.000 ₺" formatinda geliyor
      if (fiyatBilgisi.contains('-')) {
        final parts = fiyatBilgisi.split('-');
        double min = PriceCalculationManager.fiyatTemizle(parts[0]);
        double max = PriceCalculationManager.fiyatTemizle(parts[1]);
        double taban = (min + max) / 2;
        return taban * 0.01;
      } else {
        // Eski tekil fiyat geriye uyumluluk icin
        double muhtemelTutar = PriceCalculationManager.fiyatTemizle(fiyatBilgisi);
        if (muhtemelTutar >= 15000) return muhtemelTutar * 0.01;
        return 150.0;
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
        List<dynamic> seciliBolgeler = modDoc.data()?['secili_bolgeler']?? [];
        ilanOnayBekliyorMu = seciliBolgeler.any((b) => b['sehir_id'].toString() == secilenIlId && (b['ilceler'] as List).any((i) => i['id'].toString() == secilenIlceId));
      }
    } catch (e) {
      debugPrint("Moderasyon kontrol hatası: $e");
    }

    final double muhtemelTutar = PriceCalculationManager.fiyatTemizle(fiyatBilgisi);
    final bool isAcilMi = detaylar['isAcil'] == true;

    Map<String, dynamic> guncelTeknikDetaylar = Map<String, dynamic>.from(detaylar);

    final yeniIlan = ilan.copyWith(
      teknikDetaylar: guncelTeknikDetaylar,
      resimler: resimler,
      detaylar: notlar,
      fiyatBilgisi: fiyatBilgisi,
      durum: ilanOnayBekliyorMu? 'onay_bekliyor' : 'aktif',
      musteriAd: user.displayName?? "Müşteri",
      konumMetin: "$secilenIl / $secilenIlce",
      ilId: secilenIlId,
      ilceId: secilenIlceId,
      latitude: lat,
      longitude: lng,
      komisyonTutari: _komisyonHesapla(fiyatBilgisi), // REVIZE - artik aralikli stringi dogru okuyor
      isAcil: isAcilMi,
    );

    try {
      await AdService().ilanOlustur(yeniIlan);

      if (!ilanOnayBekliyorMu) {
        final String gorsel = resimler.isNotEmpty? resimler.first : _defaultGorselUrl;
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
        'sistemFiyat': muhtemelTutar,
        'muhtemelTutar': muhtemelTutar,
        'musteriDegerlendirmesi': secilenGeriBildirim?? "Belirtilmedi",
        'musterininIstedigiFiyat': anketFiyat,
        'detaylar': detaylar,
        'resimler': resimler,
        'notlar': notlar,
        'tarih': FieldValue.serverTimestamp(),
        'konum': "$secilenIl / $secilenIlce",
        'latitude': lat,
        'longitude': lng,
      });

      onResult(ilanOnayBekliyorMu? "İlanınız İncelemede!" : "İlanınız Yayınlandı!", ilanOnayBekliyorMu? "İlanınız moderasyon sürecine alındı." : "İlanınız başarıyla yayına girdi.");
    } catch (e) {
      debugPrint("IlanYayinlamaMotoru hata: $e");
      onResult("Hata Oluştu", "İlan yayınlanırken bir sorun oluştu.");
    }
  }
}