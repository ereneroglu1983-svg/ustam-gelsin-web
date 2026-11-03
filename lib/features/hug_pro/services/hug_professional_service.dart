import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ustam_gelsin/services/r2_service.dart';
import 'package:ustam_gelsin/features/hug_pro/models/hug_professional_model.dart';

class HugProfessionalService {
  final _firestore = FirebaseFirestore.instance;
  final _r2 = R2Service();

  Future<List<String>> uploadPortfolyo(List<XFile> files, String userId) async {
    List<String> urls = [];
    for (var i = 0; i < files.length; i++) {
      final file = files[i];
      String url;
      if (file.path.contains('blob')) { // Web
        final bytes = await file.readAsBytes();
        url = await _r2.uploadBytes(bytes, 'hug_professionals/$userId/portfolyo_${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
      } else {
        url = await _r2.uploadFile(File(file.path), 'hug_professionals/$userId', 'portfolyo_${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
      }
      urls.add(url);
    }
    return urls;
  }

  Future<void> createProfessional({
    required String adSoyad,
    required String unvan,
    required List<String> uzmanlikIds,
    required List<String> iller,
    required String hakkinda,
    required List<XFile> portfolyoFiles,
    required SubscriptionType type,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final fotoUrls = await uploadPortfolyo(portfolyoFiles, uid);

    DateTime expiry = DateTime.now();
    switch (type) {
      case SubscriptionType.MONTHLY: expiry = expiry.add(const Duration(days: 30)); break;
      case SubscriptionType.THREE_MONTH: expiry = expiry.add(const Duration(days: 90)); break;
      case SubscriptionType.SIX_MONTH: expiry = expiry.add(const Duration(days: 180)); break;
      case SubscriptionType.YEARLY: expiry = expiry.add(const Duration(days: 365)); break;
    }

    await _firestore.collection('hug_professionals').doc(uid).set({
      'userId': uid,
      'adSoyad': adSoyad,
      'unvan': unvan,
      'uzmanlikIds': uzmanlikIds,
      'iller': iller,
      'hakkinda': hakkinda,
      'portfolyoFotoUrls': fotoUrls,
      'belgeUrls': [],
      'bitirilenProjeSayisi': 0,
      'puan': 5.0,
      'subscriptionType': type.name,
      'subscriptionExpiry': Timestamp.fromDate(expiry),
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'aylikUcretsizBasvuruHakki': 1,
      'kullanilanBasvuru': 0,
    });
  }
}