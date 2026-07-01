import 'package:cloud_firestore/cloud_firestore.dart';

/// Teklifler ile ilgili veritabanı işlemlerini yöneten Repository sınıfı.
/// Bu sınıf sadece Firebase ile konuşur, iş mantığına karışmaz.
class OfferRepository {
  final FirebaseFirestore _firestore;

  OfferRepository(this._firestore);

  /// Teklifin durumunu günceller.
  Future<void> updateOfferStatus(String offerId, String durum) async {
    try {
      await _firestore.collection('teklifler').doc(offerId).update({
        'durum': durum,
        'guncellenmeTarihi': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Repository Hatası (updateOfferStatus): $e");
    }
  }

  /// Yeni bir bildirim ekler.
  Future<void> addNotification(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('bildirimler').add(data);
    } catch (e) {
      throw Exception("Repository Hatası (addNotification): $e");
    }
  }

  /// Belirli bir ilana ait diğer teklifleri getirir (İndeks gerektirebilir).
  Future<QuerySnapshot> getOtherOffers(String ilanId) async {
    try {
      return await _firestore
          .collection('teklifler')
          .where('ilanId', isEqualTo: ilanId)
          .get();
    } catch (e) {
      throw Exception("Repository Hatası (getOtherOffers): $e");
    }
  }

  /// Teklif dokümanını genel olarak günceller.
  Future<void> updateOffer(String offerId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('teklifler').doc(offerId).update(data);
    } catch (e) {
      throw Exception("Repository Hatası (updateOffer): $e");
    }
  }
}