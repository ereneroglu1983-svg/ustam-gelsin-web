import 'package:cloud_firestore/cloud_firestore.dart';

enum SubscriptionType { MONTHLY, THREE_MONTH, SIX_MONTH, YEARLY }

class HugProfessionalModel {
  final String id;
  final String userId;
  final String adSoyad;
  final String unvan; // Mimar, Statik Proje Uzmanı vs
  final List<String> uzmanlikIds; // MIMARI_PROJE, STATIK_PROJE...
  final List<String> iller;
  final String hakkinda;
  final List<String> portfolyoFotoUrls; // R2
  final List<String> belgeUrls; // diploma, oda kaydı R2
  final int bitirilenProjeSayisi;
  final double puan;
  final SubscriptionType subscriptionType;
  final Timestamp subscriptionExpiry;
  final bool isActive;
  final Timestamp createdAt;

  HugProfessionalModel({
    required this.id,
    required this.userId,
    required this.adSoyad,
    required this.unvan,
    required this.uzmanlikIds,
    required this.iller,
    required this.hakkinda,
    required this.portfolyoFotoUrls,
    required this.belgeUrls,
    this.bitirilenProjeSayisi = 0,
    this.puan = 0.0,
    required this.subscriptionType,
    required this.subscriptionExpiry,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'adSoyad': adSoyad,
    'unvan': unvan,
    'uzmanlikIds': uzmanlikIds,
    'iller': iller,
    'hakkinda': hakkinda,
    'portfolyoFotoUrls': portfolyoFotoUrls,
    'belgeUrls': belgeUrls,
    'bitirilenProjeSayisi': bitirilenProjeSayisi,
    'puan': puan,
    'subscriptionType': subscriptionType.name,
    'subscriptionExpiry': subscriptionExpiry,
    'isActive': isActive,
    'createdAt': createdAt,
  };

  static HugProfessionalModel fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HugProfessionalModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      adSoyad: data['adSoyad'] ?? '',
      unvan: data['unvan'] ?? '',
      uzmanlikIds: (data['uzmanlikIds'] as List?)?.cast<String>() ?? [],
      iller: (data['iller'] as List?)?.cast<String>() ?? [],
      hakkinda: data['hakkinda'] ?? '',
      portfolyoFotoUrls: (data['portfolyoFotoUrls'] as List?)?.cast<String>() ?? [],
      belgeUrls: (data['belgeUrls'] as List?)?.cast<String>() ?? [],
      bitirilenProjeSayisi: data['bitirilenProjeSayisi'] ?? 0,
      puan: (data['puan'] ?? 0).toDouble(),
      subscriptionType: SubscriptionType.values.firstWhere((e) => e.name == data['subscriptionType'], orElse: () => SubscriptionType.MONTHLY),
      subscriptionExpiry: data['subscriptionExpiry'] ?? Timestamp.now(),
      isActive: data['isActive'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}