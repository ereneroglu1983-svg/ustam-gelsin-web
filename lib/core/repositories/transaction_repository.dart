// lib/core/repositories/transaction_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Bellekte tutulacak ana liste
  List<Map<String, dynamic>> _allTransactions = [];

  // Veriyi tek seferde çek ve belleğe al
  Future<List<Map<String, dynamic>>> fetchAllTransactions() async {
    try {
      List<Map<String, dynamic>> tempTransactions = [];

      // Tüm cüzdanları al
      QuerySnapshot walletSnapshot = await _firestore.collection('wallets').get();

      for (var walletDoc in walletSnapshot.docs) {
        // Her cüzdanın altındaki 'transactions' koleksiyonunu al
        QuerySnapshot transSnapshot = await walletDoc.reference.collection('transactions').get();

        for (var transDoc in transSnapshot.docs) {
          Map<String, dynamic> data = transDoc.data() as Map<String, dynamic>;

          // Ustanın ismini (veya kimlik bilgisini) eklemek için
          // Not: Eğer user koleksiyonundan çekmek istersen burayı zenginleştirebilirsin
          data['id'] = transDoc.id;
          data['walletId'] = walletDoc.id;

          tempTransactions.add(data);
        }
      }

      _allTransactions = tempTransactions;
      return _allTransactions;
    } catch (e) {
      print("Transaction yükleme hatası: $e");
      return [];
    }
  }

  // Bellekteki liste üzerinden filtreleme yap (Firebase sorgusu ATMAZ)
  List<Map<String, dynamic>> filterTransactions({
    required String type,
    String? filterType, // "Günlük", "Aylık" vb.
  }) {
    DateTime now = DateTime.now();

    // 1. Tip filtresi (commission / deposit)
    var filtered = _allTransactions.where((t) => t['type'] == type).toList();

    // 2. Tarih filtresi (Yerel)
    if (filterType != null && filterType != "Tüm Zamanlar") {
      int days = 365;
      if (filterType == "Günlük") days = 1;
      else if (filterType == "Haftalık") days = 7;
      else if (filterType == "Aylık") days = 30;
      else if (filterType == "3 Aylık") days = 90;
      else if (filterType == "6 Aylık") days = 180;

      DateTime limit = now.subtract(Duration(days: days));

      filtered = filtered.where((t) {
        Timestamp? ts = t['date'] as Timestamp?;
        return ts != null && ts.toDate().isAfter(limit);
      }).toList();
    }

    // 3. Sıralama
    filtered.sort((a, b) {
      Timestamp? tsA = a['date'] as Timestamp?;
      Timestamp? tsB = b['date'] as Timestamp?;
      return (tsB?.toDate() ?? DateTime(0)).compareTo(tsA?.toDate() ?? DateTime(0));
    });

    return filtered;
  }
}