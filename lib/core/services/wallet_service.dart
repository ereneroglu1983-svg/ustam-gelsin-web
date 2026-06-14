import 'package:cloud_firestore/cloud_firestore.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Manuel Yükleme (Revize edildi: 3 parametreli çağrıyla tam uyumlu)
  Future<void> bakiyeYukle(String uid, double miktar, String aciklama) async {
    try {
      DocumentReference walletRef = _firestore.collection('wallets').doc(uid);

      // İşlemi 'transactions' koleksiyonuna ekle
      await walletRef.collection('transactions').add({
        'amount': miktar,
        'type': 'deposit',
        'description': aciklama,
        'date': FieldValue.serverTimestamp(),
      });

      // Bakiyeyi güncelle
      await walletRef.set({
        'balance': FieldValue.increment(miktar),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Bakiye yükleme hatası: $e");
    }
  }

  // 2. Teklif Verdikçe Bakiyeden Düşme
  Future<bool> bakiyeDus(String uid, double miktar) async {
    try {
      DocumentReference walletRef = _firestore.collection('wallets').doc(uid);

      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(walletRef);

        if (!snapshot.exists) return false;

        double mevcutBakiye = (snapshot.data() as Map<String, dynamic>)['balance']?.toDouble() ?? 0.0;

        if (mevcutBakiye < miktar) return false; // Bakiye yetersiz

        transaction.update(walletRef, {'balance': FieldValue.increment(-miktar)});

        // Transaction kaydı (opsiyonel)
        walletRef.collection('transactions').add({
          'amount': miktar,
          'type': 'withdrawal',
          'description': 'Teklif komisyonu',
          'date': FieldValue.serverTimestamp(),
        });

        return true;
      });
    } catch (e) {
      print("Bakiye düşme hatası: $e");
      return false;
    }
  }

  // 3. AKBANK POS İÇİN YAPI (İleride burayı dolduracaksın)
  Future<void> akbankPosEntegrasyonuBaslat(double miktar) async {
    // Akbank SDK veya API çağrıları buraya gelecek.
    print("Akbank POS: $miktar TL için ödeme ekranı açılıyor...");
  }
}