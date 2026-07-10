// lib/core/services/price_query_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/price_model.dart';

class PriceQueryService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<PriceModel?> getMarketPrice(String hizmetTipi, String sehir) async {
    final String docId = "${hizmetTipi.trim().toUpperCase()}_${sehir.trim().toUpperCase()}";

    DocumentSnapshot doc = await _firestore.collection('price_model').doc(docId).get();

    if (doc.exists && doc.data() != null) {
      // Veriyi alıyoruz
      final data = (doc.data() as Map).cast<String, dynamic>();

      // HATA GİDERİLDİ: Artık docId'yi ikinci parametre olarak gönderiyoruz
      return PriceModel.fromMap(data, doc.id);
    }

    return null;
  }
}