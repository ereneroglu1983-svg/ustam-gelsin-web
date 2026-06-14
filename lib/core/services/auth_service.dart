// lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // EKLENDİ
// GÜVENLİK PROTOKOLÜ MADDE 3: Model yolu iskelet yapısına göre doğrulandı
import 'package:ustam_gelsin/core/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // GİRİŞ YAPMA: Bildirim token işlemi, giriş akışını kilitlememesi için asenkron yapıya çekildi
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim()
      );

      // GİRİŞ BAŞARILI: Bildirim token güncellemesi giriş akışını kesmemesi için .then ile bağlandı
      FirebaseMessaging.instance.getToken().then((token) async {
        if (token != null && userCredential.user != null) {
          await _firestore.collection('users').doc(userCredential.user!.uid).update({
            'fcmToken': token,
          });
        }
      }).catchError((e) {
        debugPrint("FCM Token hatası (girişi engellemez): $e");
      });

    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Hata Kodu: ${e.code}");

      if (e.code == 'user-not-found') {
        throw "LÜTFEN ÖNCE KAYIT OLUNUZ";
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw "LÜTFEN GİRİŞ BİLGİLERİNİZİ KONTROL EDİNİZ";
      } else if (e.code == 'channel-error') {
        throw "E-MAIL VEYA ŞİFRE ALANI BOŞ BIRAKILAMAZ";
      } else {
        throw "GİRİŞ HATASI: ${e.message}";
      }
    } catch (e) {
      throw "SİSTEMSEL BİR HATA OLUŞTU";
    }
  }

  // ROL SORGULAMA: Mevcut yapıya dokunulmadı, veri güvenliği için null-safety artırıldı
  Future<String?> getUserRole() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Source.server ile verinin anlık sunucudan gelmesi zorunlu kılındı
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get(const GetOptions(source: Source.server));
        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data['role']?.toString();
        }
      }
      return null;
    } catch (e) {
      debugPrint("Rol okuma hatası: $e");
      return null;
    }
  }

  // YENİ EKLENDİ: Admin kontrolünü hızlandıran güvenli metod
  Future<bool> isAdmin() async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    // MASTER ADMIN KONTROLÜ
    if (user.email == "ereneroglu1983@hotmail.com") {
      return true;
    }

    final role = await getUserRole();
    return role == 'admin';
  }

  // İSİM SORGULAMA: WebHomeScreen için eklendi
  Future<String?> getUserName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Source.server ile verinin anlık sunucudan gelmesi zorunlu kılındı
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get(const GetOptions(source: Source.server));
        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data['ad_soyad']?.toString();
        }
      }
      return null;
    } catch (e) {
      debugPrint("İsim okuma hatası: $e");
      return null;
    }
  }

  // KAYIT FONKSİYONU: Rol karmaşasını önlemek için kontrol eklendi
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    required Map<String, dynamic> address,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // GÜVENLİK KONTROLÜ: 'musteri' girişi gelirse 'customer'a çevrilerek sistem standardı korunur
      String finalRole = role;
      if (role == 'musteri') {
        finalRole = 'customer';
      }

      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        email: email.trim(),
        name: name,
        role: finalRole,
        address: address,
        createdAt: DateTime.now(),
      );

      // Kayıt sırasında sadece modelin kendi toMap() verisi gönderiliyor
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());

    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Kayıt sırasında bir hata oluştu.";
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}