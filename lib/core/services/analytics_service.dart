import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Şehir/İlçe parametreleri kaldırıldı, her şey GENEL havuzuna yazılır
  Future<void> logIlanOlusturuldu(String kategoriId) async {
    try {
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      DocumentReference ref = _firestore
          .collection('market_trends')
          .doc(today)
          .collection('GENEL')
          .doc(kategoriId);

      await ref.set({
        'requestCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Analytics logIlanOlusturuldu hatası: $e");
    }
  }

  // Şehir/İlçe parametreleri kaldırıldı
  Future<void> logTeklifVerildi(String kategoriId, double teklifFiyati) async {
    try {
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      DocumentReference ref = _firestore
          .collection('market_trends')
          .doc(today)
          .collection('GENEL')
          .doc(kategoriId);

      await ref.set({
        'totalOfferAmount': FieldValue.increment(teklifFiyati),
        'offerCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Analytics logTeklifVerildi hatası: $e");
    }
  }

  // Şehir bağımsız, son 7 günün tüm GENEL kategorilerini getirir
  Stream<QuerySnapshot> getGenelTrendler() {
    return _firestore
        .collectionGroup('GENEL')
        .where('updatedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7))))
        .snapshots();
  }
}