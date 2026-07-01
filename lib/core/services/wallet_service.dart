// lib/core/services/wallet_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'wallets';

  /// 1. MANUEL YÜKLEME - Admin panel veya test için
  Future<void> bakiyeYukle(String uid, double miktar, String aciklama) async {
    if (miktar <= 0) throw Exception("Geçersiz miktar: $miktar");

    try {
      DocumentReference walletRef = _firestore.collection(_collection).doc(uid);

      // Idempotency key: Aynı açıklama 2 kez işlenmesin
      final String idempotencyKey = _generateIdempotencyKey(uid, miktar, aciklama);
      final DocumentReference txnRef = walletRef.collection('transactions').doc(idempotencyKey);

      await _firestore.runTransaction((transaction) async {
        final txnDoc = await transaction.get(txnRef);
        if (txnDoc.exists) {
          debugPrint("UYARI: Bu işlem zaten yapılmış. Key: $idempotencyKey");
          return; // Çifte işlem engeli
        }

        transaction.set(txnRef, {
          'amount': miktar,
          'type': 'deposit',
          'description': aciklama,
          'date': FieldValue.serverTimestamp(),
          'idempotencyKey': idempotencyKey,
        });

        transaction.set(walletRef, {
          'balance': FieldValue.increment(miktar),
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      debugPrint("Bakiye yükleme hatası: $e");
      throw Exception("Bakiye yükleme hatası: $e");
    }
  }

  /// 2. TRANSACTION İÇİ YÜKLEME - AkbankCallbackHandler bunu kullanır
  /// ÇİFTE YÜKLEME ENGELLİ - IDEMPOTENCY KEY ZORUNLU
  Future<void> bakiyeYukleTransaction(
      Transaction transaction,
      String uid,
      double miktar,
      String aciklama,
      ) async {
    if (miktar <= 0) throw Exception("Geçersiz miktar: $miktar");

    final DocumentReference walletRef = _firestore.collection(_collection).doc(uid);

    // Idempotency: OrderID bazlı unique key
    final String idempotencyKey = _generateIdempotencyKey(uid, miktar, aciklama);
    final DocumentReference txnRef = walletRef.collection('transactions').doc(idempotencyKey);

    // Transaction içinde read yap
    final txnDoc = await transaction.get(txnRef);
    if (txnDoc.exists) {
      throw Exception("ÇİFTE İŞLEM ENGELİ: Bu bakiye zaten yüklendi. Key: $idempotencyKey");
    }

    // Wallet doc yoksa oluştur
    final walletDoc = await transaction.get(walletRef);
    if (!walletDoc.exists) {
      transaction.set(walletRef, {
        'balance': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'uid': uid,
      });
    }

    // Atomic işlem: Transaction + Balance aynı anda
    transaction.set(txnRef, {
      'amount': miktar,
      'type': 'deposit',
      'description': aciklama,
      'date': FieldValue.serverTimestamp(),
      'idempotencyKey': idempotencyKey,
      'source': 'akbank', // Banka denetimi için
    });

    transaction.update(walletRef, {
      'balance': FieldValue.increment(miktar),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  /// 3. TEKLİF VERDİKÇE BAKİYEDEN DÜŞME - Transaction güvenli
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

  /// 4. BAKİYE SORGULA
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

  /// 5. IDEMPOTENCY KEY ÜRET - Aynı işlem 2 kez işlenmesin
  String _generateIdempotencyKey(String uid, double miktar, String aciklama) {
    final String raw = "$uid-$miktar-$aciklama";
    final bytes = utf8.encode(raw);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 6. AKBANK POS - KALDIRILDI
  /// Bu metod artık kullanılmıyor. AkbankManager kullan.
  @Deprecated('AkbankManager.triggerPaymentProcess kullan')
  Future<void> akbankPosEntegrasyonuBaslat(double miktar) async {
    throw UnimplementedError('Bu metod kaldırıldı. AkbankManager kullan.');
  }
}