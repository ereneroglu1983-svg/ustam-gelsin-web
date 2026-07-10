import 'package:cloud_firestore/cloud_firestore.dart';

class FiyatOnericiServis {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<double> getHibritFiyat(String hizmetTipi, String sehir, double hesaplayiciFiyat) async {
    final String docId = "${hizmetTipi.trim().toUpperCase()}_${sehir.trim().toUpperCase()}";

    DocumentSnapshot doc = await _firestore.collection('price_model').doc(docId).get();

    if (!doc.exists) {
      return hesaplayiciFiyat; // AI verisi yoksa kendi formülüne güven
    }

    double aiAvg = (doc.get('avg_price') as num).toDouble();

    // HİBRİT FORMÜL: %60 Senin Formül + %40 Piyasa Ortalaması
    return (hesaplayiciFiyat * 0.6) + (aiAvg * 0.4);
  }
}