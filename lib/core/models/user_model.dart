// lib/core/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;
  final Map<String, dynamic> address;
  final DateTime createdAt;
  // YENİ ALANLAR: Puanlama Sistemi
  final double rating;
  final int ratingCount;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.address,
    required this.createdAt,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "role": role,
      "address": address,
      "createdAt": Timestamp.fromDate(createdAt), // Firestore için Timestamp formatı
      "rating": rating,
      "ratingCount": ratingCount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"] ?? "",
      email: map["email"] ?? "",
      name: map["name"] ?? "İsimsiz Kullanıcı",
      role: (map["role"] ?? "customer").toString().toLowerCase(),
      address: Map<String, dynamic>.from(map["address"] ?? {}),
      createdAt: map["createdAt"] != null
          ? (map["createdAt"] is Timestamp
          ? (map["createdAt"] as Timestamp).toDate()
          : (map["createdAt"] is String
          ? DateTime.parse(map["createdAt"])
          : DateTime.now()))
          : DateTime.now(),
      rating: (map["rating"] ?? 0.0).toDouble(),
      ratingCount: (map["ratingCount"] ?? 0).toInt(),
    );
  }

  String get roleDisplay => role == 'usta' ? 'Usta' : 'Müşteri';
}