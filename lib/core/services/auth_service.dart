// lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ustam_gelsin/core/models/user_model.dart';
import 'package:ustam_gelsin/core/services/notification_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  Map<String, dynamic>? _cachedUserData;

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (userCredential.user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (userDoc.exists) {
          List<String> uzmanliklar = List<String>.from((userDoc.data() as Map<String, dynamic>)['uzmanliklar'] ?? []);
          await _notificationService.updateUserToken(userCredential.user!.uid, uzmanliklar);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') throw "LÜTFEN ÖNCE KAYIT OLUNUZ";
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') throw "LÜTFEN GİRİŞ BİLGİLERİNİZİ KONTROL EDİNİZ";
      throw "GİRİŞ HATASI: ${e.message}";
    } catch (e) { throw "SİSTEMSEL BİR HATA OLUŞTU"; }
  }

  Future<Map<String, dynamic>?> getUserProfile({bool refresh = false}) async {
    if (_cachedUserData != null && !refresh) return _cachedUserData;

    User? user = _auth.currentUser;
    if (user == null) return null;

    DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      _cachedUserData = doc.data() as Map<String, dynamic>;
      return _cachedUserData;
    }
    return null;
  }

  // --- EKLENEN METOTLAR (Hataları çözer) ---

  Future<String?> getUserRole() async {
    Map<String, dynamic>? profile = await getUserProfile();
    return profile?['role'];
  }

  Future<bool> isAdmin() async {
    String? role = await getUserRole();
    return role == 'admin';
  }

  // ----------------------------------------

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    required Map<String, dynamic> address,
    List<String>? uzmanliklar,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim(),
      );

      String finalRole = (role == 'musteri') ? 'customer' : role;

      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        email: email.trim(),
        name: name,
        role: finalRole,
        address: address,
        createdAt: DateTime.now(),
      );

      Map<String, dynamic> data = user.toMap();
      if (uzmanliklar != null) data['uzmanliklar'] = uzmanliklar;

      await _firestore.collection('users').doc(userCredential.user!.uid).set(data);
      await _notificationService.updateUserToken(userCredential.user!.uid, uzmanliklar ?? []);

    } on FirebaseAuthException catch (e) { throw e.message ?? "Kayıt hatası"; }
  }

  Future<void> signOut() async {
    _cachedUserData = null;
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}