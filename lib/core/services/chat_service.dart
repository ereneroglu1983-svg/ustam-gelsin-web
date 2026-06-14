// lib/core/services/chat_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/overlay_manager.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- EKLENEN OPERASYONEL YETENEKLER ---

  /// Kullanıcıyı Yasakla/Kaldır
  Future<void> updateUserBanStatus(String uid, bool isBanned) async {
    await _firestore.collection('users').doc(uid).update({'isBanned': isBanned});
  }

  /// Admin tarafından doğrudan mesaj gönderimi
  Future<void> adminMesajGonder({
    required String aliciId,
    required String mesajMetni,
  }) async {
    await _firestore.collection('admin_chats').add({
      'gonderenId': 'ADMIN',
      'aliciId': aliciId,
      'mesajMetni': mesajMetni,
      'timestamp': FieldValue.serverTimestamp(),
      'okundu': false,
    });
  }

  // --- SİSTEMDEKİ MEVCUT YAPI (DEĞİŞMEDİ, SİLİNMEDİ) ---

  /// Mesaj Gönderme ve Bildirim Tetikleme
  Future<void> mesajGonder({
    required String ilanId,
    required String gonderenId,
    required String aliciId,
    required String mesajMetni,
  }) async {
    final Map<String, dynamic> mesajVerisi = {
      'ilanId': ilanId,
      'gonderenId': gonderenId,
      'aliciId': aliciId,
      'mesajMetni': mesajMetni,
      'timestamp': FieldValue.serverTimestamp(),
      'okundu': false,
    };

    try {
      await _firestore.collection('chats').add(mesajVerisi);

      await _firestore.collection('ilanlar').doc(ilanId).update({
        'sonMesaj': mesajMetni,
        'sonMesajTarihi': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Mesaj gönderme sırasında hata oluştu: $e");
    }
  }

  /// Yeni mesajları dinle ve Overlay (Balon) tetikle
  void yeniMesajlariDinle() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _firestore
        .collection('chats')
        .where('aliciId', isEqualTo: uid)
        .where('okundu', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          var data = change.doc.data() as Map<String, dynamic>;

          // Balonu fırlat
          OverlayManager.showChatHead(
            data['ilanId'],
            data['gonderenId'],
            "Yeni Mesaj",
          );
        }
      }
    });
  }

  /// Belirli bir ilana ait mesajları anlık dinle
  Stream<QuerySnapshot> mesajlariGetir(String ilanId) {
    return _firestore
        .collection('chats')
        .where('ilanId', isEqualTo: ilanId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Kullanıcının okunmamış mesaj bildirimlerini dinle
  Stream<QuerySnapshot> bildirimleriDinle(String userId) {
    return _firestore
        .collection('chats')
        .where('aliciId', isEqualTo: userId)
        .where('okundu', isEqualTo: false)
        .snapshots();
  }

  /// Mesajı okundu olarak işaretle
  Future<void> mesajOkunduIsaretle(String ilanId, String mevcutKullaniciId) async {
    try {
      var batch = _firestore.batch();
      var okunmamislar = await _firestore
          .collection('chats')
          .where('ilanId', isEqualTo: ilanId)
          .where('aliciId', isEqualTo: mevcutKullaniciId)
          .where('okundu', isEqualTo: false)
          .get();

      for (var doc in okunmamislar.docs) {
        batch.update(doc.reference, {'okundu': true});
      }
      await batch.commit();

      // Mesajlar okunduğunda balonu kaldır
      OverlayManager.hideChatHead();
    } catch (e) {
      print("Okundu işaretleme hatası: $e");
    }
  }
}