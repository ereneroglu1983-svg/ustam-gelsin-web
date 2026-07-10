// lib/core/models/price_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PriceModel {
  final String hizmetTipi;
  final String sehir;
  final double muhtemelButce; // Revize: avgPrice yerine standart isim
  final double minimumButce;   // Revize: minPrice yerine standart isim
  final double maksimumButce;  // Revize: maxPrice yerine standart isim
  final int sampleSize;
  final DateTime lastUpdated;

  PriceModel({
    required this.hizmetTipi,
    required this.sehir,
    required this.muhtemelButce,
    required this.minimumButce,
    required this.maksimumButce,
    required this.sampleSize,
    required this.lastUpdated,
  });

  factory PriceModel.fromMap(Map<String, dynamic> map, String docId) {
    return PriceModel(
      hizmetTipi: map['hizmet_tipi'] ?? '',
      sehir: map['sehir'] ?? '',
      muhtemelButce: (map['muhtemelButce'] ?? 0.0).toDouble(),
      minimumButce: (map['minimumButce'] ?? 0.0).toDouble(),
      maksimumButce: (map['maksimumButce'] ?? 0.0).toDouble(),
      sampleSize: (map['sample_size'] ?? 0).toInt(),
      lastUpdated: (map['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hizmet_tipi': hizmetTipi,
      'sehir': sehir,
      'muhtemelButce': muhtemelButce,
      'minimumButce': minimumButce,
      'maksimumButce': maksimumButce,
      'sample_size': sampleSize,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }
}