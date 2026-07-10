// lib/core/services/price_learning_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/price_model.dart';

class PriceLearningService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> updatePriceModel(String hizmetTipi, String sehir, double yeniTeklif) async {
    // 1. Basit Filtreleme (Spam Koruması)
    if (yeniTeklif < 100 || yeniTeklif > 50000) return;

    final String docId = "${hizmetTipi.trim().toUpperCase()}_${sehir.trim().toUpperCase()}";
    final DocumentReference docRef = _firestore.collection('price_model').doc(docId);

    // 2. Transaction ile veriyi güvenli güncelle
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        // İlk teklif: Dokümanı yeni oluştur
        transaction.set(docRef, {
          'hizmet_tipi': hizmetTipi,
          'sehir': sehir,
          'avg_price': yeniTeklif,
          'min_price': yeniTeklif,
          'max_price': yeniTeklif,
          'sample_size': 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Mevcut veriyi güncelle
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        int n = (data['sample_size'] ?? 0).toInt();
        double oldAvg = (data['avg_price'] ?? 0.0).toDouble();
        double oldMin = (data['min_price'] ?? 0.0).toDouble();
        double oldMax = (data['max_price'] ?? 0.0).toDouble();

        // Yeni ortalama hesabı
        double newAvg = ((oldAvg * n) + yeniTeklif) / (n + 1);

        transaction.update(docRef, {
          'avg_price': newAvg,
          'min_price': yeniTeklif < oldMin ? yeniTeklif : oldMin,
          'max_price': yeniTeklif > oldMax ? yeniTeklif : oldMax,
          'sample_size': n + 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    });
  }
}