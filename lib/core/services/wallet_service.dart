// lib/core/services/wallet_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'wallets';

  // SİLİNDİ: bakiyeYukle()
  // Sebep: Manuel yükleme backend işi. Frontend'den kaldırıldı.

  // SİLİNDİ: bakiyeYukleTransaction()
  // Sebep: iyzicoCallback function'ı backend'de transaction ile yüklüyor.

  /// 1. TEKLİF VERDİKÇE BAKİYEDEN DÜŞME - Transaction güvenli
  /// KALDI: Bu senin sistemin. Teklif verince komisyon düşüyor.
  Future<bool> bakiyeDus(String uid, double miktar, {String? aciklama}) async {
    if (miktar <= 0) return false;

    try {
      DocumentReference walletRef = _firestore.collection(_collection).doc(uid);

      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(walletRef);

        if (!snapshot.exists) {
          debugPrint("Cüzdan bulunamadı: $uid");
          return false;
        }

        double mevcutBakiye = (snapshot.data() as Map<String, dynamic>)['balance']?.toDouble() ?? 0.0;

        if (mevcutBakiye < miktar) {
          debugPrint("Yetersiz bakiye: $mevcutBakiye < $miktar");
          return false;
        }

        transaction.update(walletRef, {
          'balance': FieldValue.increment(-miktar),
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        DocumentReference newTransactionRef = walletRef.collection('transactions').doc();
        transaction.set(newTransactionRef, {
          'amount': miktar,
          'type': 'withdrawal',
          'description': aciklama ?? 'Teklif komisyonu',
          'date': FieldValue.serverTimestamp(),
        });

        return true;
      });
    } catch (e) {
      debugPrint("Bakiye düşme hatası: $e");
      return false;
    }
  }

  /// 2. BAKİYE SORGULA
  /// KALDI: UI'da bakiye göstermek için lazım.
  Future<double> getBakiye(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (!doc.exists) return 0.0;
      return (doc.data()?['balance'] ?? 0.0).toDouble();
    } catch (e) {
      debugPrint("Bakiye sorgu hatası: $e");
      return 0.0;
    }
  }

  /// 3. BAKİYE STREAM - Anlık dinleme için
  /// EKLENDİ: Ödeme başarılı olunca bakiyenin artmasını dinleyeceksin.
  Stream<double> streamBakiye(String uid) {
    return _firestore.collection(_collection).doc(uid).snapshots().map((doc) {
      if (!doc.exists) return 0.0;
      return (doc.data()?['balance'] ?? 0.0).toDouble();
    });
  }

  /// 4. İŞLEM GEÇMİŞİ STREAM
  /// KALDI: Kullanıcıya hareketleri göstermek için.
  Stream<QuerySnapshot> streamTransactions(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .limit(50)
        .snapshots();
  }

// SİLİNDİ: _generateIdempotencyKey
// Sebep: Idempotency kontrolünü backend yapıyor.

// SİLİNDİ: akbankPosEntegrasyonuBaslat
// Sebep: Zaten deprecated'ti. IyzicoManager kullanıyoruz.
}