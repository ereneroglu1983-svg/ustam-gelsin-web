// lib/core/services/acil_is_yonetim_servisi.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ustam_gelsin/core/services/wallet_service.dart';

class AcilIsYonetimServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GeoHasher _geoHasher = GeoHasher();
  final WalletService _walletService = WalletService();

  Future<Position?> konumKontrolVeAl() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint("Konum servisi uyarısı: $e");
      return null;
    }
  }

  Future<void> usta724DurumunuGuncelle(bool aktifMi) async {
    final ustaId = _auth.currentUser?.uid;
    if (ustaId == null) return;

    Map<String, dynamic> updateData = {
      'is724Active': aktifMi,
      'lastActive': FieldValue.serverTimestamp(),
    };

    if (aktifMi) {
      Position? position = await konumKontrolVeAl();
      if (position != null) {
        updateData['geohash'] = _geoHasher.encode(position.longitude, position.latitude, precision: 5);
        updateData['konum'] = GeoPoint(position.latitude, position.longitude);
      } else {
        updateData['is724Active'] = false;
      }
    } else {
      updateData['geohash'] = null;
    }

    await _firestore.collection('users').doc(ustaId).update(updateData);
  }

  Future<bool> acilIsiKap(String ilanId) async {
    final ustaId = _auth.currentUser?.uid;
    if (ustaId == null) return false;

    final ustaDoc = await _firestore.collection('users').doc(ustaId).get();
    final ustaData = ustaDoc.data();

    final String firstName = ustaData?['firstName'] ?? '';
    final String lastName = ustaData?['lastName'] ?? '';
    final String name = ustaData?['name'] ?? '';
    final String ustaAd = (firstName.isNotEmpty || lastName.isNotEmpty) ? "$firstName $lastName".trim() : name.trim();
    final String ustaTelefon = ustaData?['phoneNumber'] ?? ustaData?['phone'] ?? "";
    final String ustaProfilResmi = ustaData?['profileImageUrl'] ?? "";
    final bool ustaUstalikBelgesi = ustaData?['ustalikBelgesiVarMi'] ?? false;

    await konumKontrolVeAl();

    final ilanRef = _firestore.collection('acil_cagri').doc(ilanId);

    try {
      // 1. ÖNCE BAKİYE KONTROLÜ - Transaction DIŞINDA
      DocumentSnapshot walletSnap = await _firestore.collection('wallets').doc(ustaId).get();
      double mevcutBakiye = 0.0;
      if (walletSnap.exists) {
        mevcutBakiye = (walletSnap.data() as Map<String, dynamic>)['balance']?.toDouble() ?? 0.0;
      }
      if (mevcutBakiye < 250.0) {
        debugPrint("Bakiye yetersiz: $mevcutBakiye");
        return false;
      }

      // 2. İLANI KİLİTLE - Sadece ilanı güncelleyen transaction
      bool ilanAlindi = await _firestore.runTransaction((transaction) async {
        DocumentSnapshot ilanSnap = await transaction.get(ilanRef);
        if (!ilanSnap.exists) return false;
        if (ilanSnap.get('durum') != 'bekliyor') return false;

        transaction.update(ilanRef, {
          'durum': 'atandi',
          'secilenUstaId': ustaId,
          'ustaAd': ustaAd,
          'ustaTelefon': ustaTelefon,
          'ustaProfilResmi': ustaProfilResmi,
          'ustaUstalikBelgesi': ustaUstalikBelgesi,
          'kabulEdilmeTarihi': FieldValue.serverTimestamp(),
          'teknikDetaylar.kilitAcildi': true,
          'teklifUcreti': 250,
        });
        return true;
      });

      if (!ilanAlindi) return false;

      // 3. BAKİYE DÜŞ - Transaction DIŞINDA, ilan alındıktan sonra
      bool bakiyeDustu = await _walletService.bakiyeDus(ustaId, 250.0);
      if (!bakiyeDustu) {
        // Bakiye düşmezse ilanı geri al - rollback
        await ilanRef.update({'durum': 'bekliyor', 'secilenUstaId': FieldValue.delete()});
        return false;
      }

      return true;
    } catch (e) {
      debugPrint("İş kapma işlem hatası: $e");
      return false;
    }
  }
}