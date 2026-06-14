// lib/core/services/offer_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // EKLENDİ (debugPrint için şart)
import 'package:ustam_gelsin/core/services/notification_service.dart';
import 'package:ustam_gelsin/core/services/billing_service.dart'; // EKLENDİ
import '../repositories/offer_repository.dart';

class OfferService {
  final OfferRepository _repo;
  final NotificationService _notificationService = NotificationService();
  final BillingService _billingService = BillingService(); // EKLENDİ

  OfferService(this._repo);

  Future<void> processOffer({
    required String offerId,
    required String durum,
    required String ilanId,
    required String ilanBaslik,
    required Map<String, dynamic> offer,
    required String musteriUid,
  }) async {

    final ustaId = offer['ustaId'];
    final ustaAd = offer['ustaAd'] ?? "Bilinmiyor";
    final musteriUserId = offer['musteriUserId'];

    try {
      final batch = FirebaseFirestore.instance.batch();
      final ilanRef = FirebaseFirestore.instance.collection('ilanlar').doc(ilanId);
      final offerRef = FirebaseFirestore.instance.collection('teklifler').doc(offerId);
      final jobRef = FirebaseFirestore.instance.collection('jobs').doc();

      batch.update(offerRef, {'durum': durum});

      if (durum == 'onaylandi') {
        batch.update(ilanRef, {
          'durum': 'is_verildi',
          'onaylananTeklifId': offerId,
          'atananUstaId': ustaId,
        });

        batch.set(jobRef, {
          'ilanId': ilanId,
          'teklifId': offerId,
          'ustaId': ustaId,
          'musteriId': musteriUserId,
          'title': ilanBaslik,
          'price': offer['teklifFiyat'] ?? 0,
          'ustaAd': ustaAd,
          'status': 'devam_ediyor',
          'timestamp': FieldValue.serverTimestamp(),
        });

        final others = await _repo.getOtherOffers(ilanId);
        for (var doc in others.docs) {
          if (doc.id != offerId) {
            batch.update(doc.reference, {'durum': 'reddedildi'});
          }
        }
      }

      await batch.commit();

      // BİLDİRİM TETİKLEME VE FATURA İŞLEMİ
      if (durum == 'onaylandi') {
        // FATURA TETİKLEME
        await _billingService.createInvoiceForOffer(ustaId, offer['teklifFiyat'] ?? 0, ilanId);

        final musteriDoc = await FirebaseFirestore.instance.collection('users').doc(musteriUserId).get();
        final musteriToken = musteriDoc.data()?['fcmToken'];

        if (musteriToken != null) {
          debugPrint("Bildirim gönderilecek: $musteriToken");
        }
      }

    } catch (e) {
      throw Exception("KRİTİK HATA: $e");
    }
  }
}