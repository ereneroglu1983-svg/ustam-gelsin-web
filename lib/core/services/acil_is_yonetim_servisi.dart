// lib/core/services/acil_is_yonetim_servisi.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:geolocator/geolocator.dart';

class AcilIsYonetimServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GeoHasher _geoHasher = GeoHasher();

  // Ustanın 7/24 aktif olup olmadığını kontrol eder
  Stream<DocumentSnapshot> usta724DurumuGetir() {
    final ustaId = _auth.currentUser?.uid;
    if (ustaId == null) return const Stream.empty();
    return _firestore.collection('users').doc(ustaId).snapshots();
  }

  // 7/24 durumunu güncelleme ve Geohash kaydetme
  Future<void> usta724DurumunuGuncelle(bool aktifMi) async {
    final ustaId = _auth.currentUser?.uid;
    if (ustaId == null) return;

    Map<String, dynamic> updateData = {'is724Active': aktifMi};

    // Eğer usta online oluyorsa, konumunu al ve Geohash oluştur
    if (aktifMi) {
      try {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

          // dart_geohash paketi: encode(boylam, enlem, precision)
          String hash = _geoHasher.encode(position.longitude, position.latitude, precision: 5);
          updateData['geohash'] = hash;
        }
      } catch (e) {
        debugPrint("Konum alınamadı: $e");
      }
    } else {
      // Offline olduğunda konumu silebiliriz veya boş bırakabiliriz
      updateData['geohash'] = null;
    }

    await _firestore.collection('users').doc(ustaId).update(updateData);
  }

  // Ustanın çağrıyı kabul etmesi için güncellenmiş metod
  Future<void> cagriyiKabulEt(String cagriId) async {
    try {
      await _firestore.collection('acil_cagri').doc(cagriId).update({
        'durum': 'kabul_edildi',
        'kabulEdilmeTarihi': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Çağrı kabul edilirken hata oluştu: $e");
    }
  }

  // İş Kapma Fonksiyonu
  Future<bool> acilIsiKap(String ilanId) async {
    final ustaId = _auth.currentUser?.uid;
    if (ustaId == null) return false;

    final ilanRef = _firestore.collection('ilanlar').doc(ilanId);
    final ustaRef = _firestore.collection('users').doc(ustaId);

    try {
      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot ilanSnap = await transaction.get(ilanRef);
        DocumentSnapshot ustaSnap = await transaction.get(ustaRef);

        if (!ilanSnap.exists) return false;

        var ilanData = ilanSnap.data() as Map<String, dynamic>;

        if (ilanData['durum'] != 'aktif') {
          return false;
        }

        if (ustaSnap.exists) {
          var ustaData = ustaSnap.data() as Map<String, dynamic>;
          double mevcutBakiye = (ustaData['bakiye'] ?? 0.0).toDouble();

          if (mevcutBakiye < 250) {
            throw Exception("Yetersiz Bakiye");
          }

          transaction.update(ustaRef, {'bakiye': FieldValue.increment(-250)});
        }

        transaction.update(ilanRef, {
          'durum': 'eslesti',
          'secilenUstaId': ustaId,
          'kabulEdilmeTarihi': FieldValue.serverTimestamp(),
          'teknikDetaylar.kilitAcildi': true,
        });

        final acilChatId = "acil_$ilanId";
        final chatRef = _firestore.collection('chats').doc(acilChatId);

        transaction.set(chatRef, {
          'ilanId': ilanId,
          'aliciId': ilanData['userId'],
          'gonderenId': ustaId,
          'sonMesaj': "7/24 Acil Usta Yola Çıktı!",
          'tarih': DateTime.now().toIso8601String(),
          'okundu': false,
        });

        return true;
      });
    } catch (e) {
      debugPrint("İş kapma hatası: $e");
      return false;
    }
  }
}