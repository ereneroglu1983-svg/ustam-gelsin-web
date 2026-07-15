// lib/core/services/chat_service.dart

import 'package:rxdart/rxdart.dart';
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

  // --- OPTİMİZE EDİLMİŞ CHAT YÖNETİMİ ---

  /// Mesaj Gönderme ve Bildirim Tetikleme (Mevcut sohbeti kullanır veya yenisini oluşturur)
  Future<void> mesajGonder({
    required String ilanId,
    required String gonderenId,
    required String aliciId,
    required String mesajMetni,
  }) async {
    try {
      // 1. Aynı ilan ve katılımcılar için daha önce oluşturulmuş bir sohbet var mı kontrol et
      var chatQuery = await _firestore
          .collection('chats')
          .where('ilanId', isEqualTo: ilanId)
          .where('katilimcilar', arrayContains: gonderenId)
          .limit(1)
          .get();

      DocumentReference chatRef;

      if (chatQuery.docs.isNotEmpty) {
        // Zaten bir sohbet varsa onun referansını al
        chatRef = chatQuery.docs.first.reference;
      } else {
        // Yoksa yeni bir sohbet dokümanı oluştur
        chatRef = await _firestore.collection('chats').add({
          'ilanId': ilanId,
          'katilimcilar': [gonderenId, aliciId],
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // 2. Mesajı, o sohbetin altına "mesajlar" alt koleksiyonu olarak ekle
      await chatRef.collection('mesajlar').add({
        'gonderenId': gonderenId,
        'mesajMetni': mesajMetni,
        'timestamp': FieldValue.serverTimestamp(),
        'okundu': false,
      });

      // 3. İlan bilgilerini güncelle
      await _firestore.collection('ilanlar').doc(ilanId).update({
        'sonMesaj': mesajMetni,
        'sonMesajTarihi': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Mesaj gönderme sırasında hata oluştu: $e");
    }
  }

  /// Yeni mesajları dinle (Alt koleksiyon yapısına uygun güncellendi)
  void yeniMesajlariDinle() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _firestore
        .collection('chats')
        .where('katilimcilar', arrayContains: uid)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          // Sohbet dokümanı güncellendiğinde yeni mesaj gelmiş olabilir
          var data = change.doc.data() as Map<String, dynamic>;

          // Alıcıyı belirle
          List katilimcilar = data['katilimcilar'] ?? [];
          String digerKullaniciId = katilimcilar.firstWhere((id) => id != uid, orElse: () => "");

          OverlayManager.showChatHead(
            data['ilanId'],
            digerKullaniciId,
            "Yeni Mesaj",
          );
        }
      }
    });
  }

  /// Belirli bir ilana ait mesajları anlık dinle (limit eklendi)
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

  /// Kullanıcının okunmamış mesaj bildirimlerini dinle (limit eklendi)
  Stream<QuerySnapshot> bildirimleriDinle(String userId) {
    return _firestore
        .collection('chats')
        .where('katilimcilar', arrayContains: userId)
        .limit(10)
        .snapshots();
  }

  /// Mesajı okundu olarak işaretle (Alt koleksiyona göre güncellendi)
  Future<void> mesajOkunduIsaretle(String ilanId, String mevcutKullaniciId) async {
    try {
      var chatQuery = await _firestore
          .collection('chats')
          .where('ilanId', isEqualTo: ilanId)
          .limit(1)
          .get();

      if (chatQuery.docs.isNotEmpty) {
        var okunmamislar = await chatQuery.docs.first.reference
            .collection('mesajlar')
            .where('okundu', isEqualTo: false)
            .get();

        var batch = _firestore.batch();
        for (var doc in okunmamislar.docs) {
          // Sadece karşı tarafın gönderdiği mesajları okundu işaretle
          if (doc.get('gonderenId') != mevcutKullaniciId) {
            batch.update(doc.reference, {'okundu': true});
          }
        }
        await batch.commit();
      }

      OverlayManager.hideChatHead();
    } catch (e) {
      print("Okundu işaretleme hatası: $e");
    }
  }
}