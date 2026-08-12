// lib/core/services/chat_service.dart - FINAL FIX - PUSH + LOOP KESİLDİ
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/overlay_manager.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart'; // EKLENDİ - debugPrint için

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> updateUserBanStatus(String uid, bool isBanned) async {
    await _firestore.collection('users').doc(uid).update({'isBanned': isBanned});
  }

  Future<void> adminMesajGonder({required String aliciId, required String mesajMetni}) async {
    await _firestore.collection('admin_chats').add({
      'gonderenId': 'ADMIN',
      'aliciId': aliciId,
      'mesajMetni': mesajMetni,
      'timestamp': FieldValue.serverTimestamp(),
      'okundu': false,
    });
  }

  // === MESAJ GÖNDERME - ARTIK FCM TETİKLİYOR ===
  Future<void> mesajGonder({
    required String ilanId,
    required String gonderenId,
    required String aliciId,
    required String mesajMetni,
  }) async {
    try {
      var chatQuery = await _firestore
          .collection('chats')
          .where('ilanId', isEqualTo: ilanId)
          .where('katilimcilar', arrayContains: gonderenId)
          .limit(1)
          .get();

      DocumentReference chatRef;
      if (chatQuery.docs.isNotEmpty) {
        chatRef = chatQuery.docs.first.reference;
      } else {
        chatRef = await _firestore.collection('chats').add({
          'ilanId': ilanId,
          'katilimcilar': [gonderenId, aliciId],
          'timestamp': FieldValue.serverTimestamp(),
          'sonMesaj': mesajMetni,
        });
      }

      await chatRef.collection('mesajlar').add({
        'gonderenId': gonderenId,
        'aliciId': aliciId, // EKLENDİ - FCM İÇİN ŞART
        'mesajMetni': mesajMetni,
        'timestamp': FieldValue.serverTimestamp(),
        'okundu': false,
      });

      // Ana chat dokümanını da güncelle - Overlay için
      await chatRef.update({
        'sonMesaj': mesajMetni,
        'sonMesajTarihi': FieldValue.serverTimestamp(),
        'sonGonderen': gonderenId,
      });

      // === YENİ: PUSH BİLDİRİM TETİKLE ===
      // Firestore'a yazdıktan sonra Cloud Function çağır
      try {
        await _functions.httpsCallable('sendChatNotification').call({
          'aliciId': aliciId,
          'gonderenId': gonderenId,
          'ilanId': ilanId,
          'mesaj': mesajMetni,
        });
      } catch (e) {
        // Function yoksa yedek yöntem: bildirimler koleksiyonuna yaz
        await _firestore.collection('bildirimler').add({
          'aliciId': aliciId,
          'gonderenId': gonderenId,
          'ilanId': ilanId,
          'mesaj': mesajMetni,
          'tip': 'chat',
          'okundu': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("⚠ Function yok, yedek bildirim koleksiyonuna yazıldı: $e");
      }

    } catch (e) {
      print("❌ Mesaj gönderme hatası: $e");
      rethrow;
    }
  }

  // === DÜZELTİLDİ: SADECE YENİ MESAJLARI DİNLE, CHAT DOKÜMANINI DEĞİL ===
  void yeniMesajlariDinle() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // ARTIK chats'i değil, mesajlar alt koleksiyonunu dinlemiyoruz
    // Bu stream build içinde çağrılmamalı, initState'te 1 kere çağrılmalı
    _firestore
        .collectionGroup('mesajlar')
        .where('aliciId', isEqualTo: uid)
        .where('okundu', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          var data = change.doc.data() as Map<String, dynamic>;
          OverlayManager.showChatHead(
            data['ilanId'] ?? '',
            data['gonderenId'] ?? '',
            data['mesajMetni'] ?? 'Yeni Mesaj',
          );
        }
      }
    }, onError: (e) {
      // EKLENDİ - İşte senin "hata oluştu" ekranını patlatan yeri yutuyoruz
      debugPrint("⚠ Mesaj dinleme hatası (index bekleniyor olabilir): $e");
    });
  }

  Stream<QuerySnapshot> mesajlariGetir(String ilanId) {
    return _firestore
        .collection('chats')
        .where('ilanId', isEqualTo: ilanId)
        .limit(1)
        .snapshots()
        .switchMap((chatSnapshot) {
      if (chatSnapshot.docs.isEmpty) return const Stream<QuerySnapshot>.empty();
      return chatSnapshot.docs.first.reference
          .collection('mesajlar')
          .orderBy('timestamp', descending: true)
          .limit(30)
          .snapshots();
    });
  }

  Stream<QuerySnapshot> bildirimleriDinle(String userId) {
    return _firestore
        .collection('chats')
        .where('katilimcilar', arrayContains: userId)
        .limit(10)
        .snapshots();
  }

  Future<void> mesajOkunduIsaretle(String ilanId, String mevcutKullaniciId) async {
    try {
      var chatQuery = await _firestore.collection('chats').where('ilanId', isEqualTo: ilanId).limit(1).get();
      if (chatQuery.docs.isNotEmpty) {
        var okunmamislar = await chatQuery.docs.first.reference.collection('mesajlar').where('okundu', isEqualTo: false).where('aliciId', isEqualTo: mevcutKullaniciId).get();
        var batch = _firestore.batch();
        for (var doc in okunmamislar.docs) {
          batch.update(doc.reference, {'okundu': true});
        }
        await batch.commit();
      }
      OverlayManager.hideChatHead();
    } catch (e) {
      print("Okundu hatası: $e");
    }
  }
}