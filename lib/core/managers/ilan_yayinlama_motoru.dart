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

  // Komisyon hesaplama kuralı
  static double _komisyonHesapla(double muhtemelTutar) {
    if (muhtemelTutar >= 15000) {
      return muhtemelTutar * 0.01;
    } else {
      return 150.0;
    }
  }

  static Future<void> ilanYayinla({
    required BuildContext context,
    required IlanModel ilan,
    required Map<String, dynamic> detaylar,
    required List<String> resimler,
    required String notlar,
    required String fiyatBilgisi, // Map yerine String
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

    // ESKİ SİSTEM: String'den komisyon için sayıya çevir
    final double muhtemelTutar = PriceCalculationManager.fiyatTemizle(fiyatBilgisi);
    final bool isAcilMi = detaylar['isAcil'] == true;

    // Teknik detayları güncelle - fiyatYapisi YOK artık
    Map<String, dynamic> guncelTeknikDetaylar = Map<String, dynamic>.from(detaylar);
    // guncelTeknikDetaylar['fiyatYapisi'] = fiyatYapisi; // SİLİNDİ

    final yeniIlan = ilan.copyWith(
      teknikDetaylar: guncelTeknikDetaylar,
      resimler: resimler,
      detaylar: notlar,
      fiyatBilgisi: fiyatBilgisi, // Direkt String
      durum: ilanOnayBekliyorMu ? 'onay_bekliyor' : 'aktif',
      musteriAd: user.displayName ?? "Müşteri",
      konumMetin: "$secilenIl / $secilenIlce",
      ilId: secilenIlId,
      ilceId: secilenIlceId,
      latitude: lat,
      longitude: lng,
      komisyonTutari: _komisyonHesapla(muhtemelTutar),
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

      // AI Veri Kaydı - Map tutabilir, sorun yok
      await FirebaseFirestore.instance.collection('app_ai_data').add({
        'userId': user.uid,
        'kategori': ilan.kategori,
        'fiyatBilgisi': fiyatBilgisi, // String
        'muhtemelTutar': muhtemelTutar, // Sayısal da tut
        'musteriDegerlendirmesi': secilenGeriBildirim ?? "Belirtilmedi",
        'musterininIstedigiFiyat': (ozelFiyatGoster && fiyatDuzenleMetin.isNotEmpty)
            ? double.tryParse(fiyatDuzenleMetin.replaceAll('.', ''))
            : null,
        'detaylar': detaylar,
        'resimler': resimler,
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
      debugPrint("IlanYayinlamaMotoru hata: $e");
      onResult("Hata Oluştu", "İlan yayınlanırken bir sorun oluştu.");
    }
  }
}