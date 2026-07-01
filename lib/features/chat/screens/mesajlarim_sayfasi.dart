// lib/features/chat/screens/mesajlarim_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_detay_sayfasi.dart';

class MesajlarimSayfasi extends StatefulWidget {
  const MesajlarimSayfasi({super.key});

  @override
  State<MesajlarimSayfasi> createState() => _MesajlarimSayfasiState();
}

class _MesajlarimSayfasiState extends State<MesajlarimSayfasi> {
  late Stream<QuerySnapshot> _myChatsStream;

  @override
  void initState() {
    super.initState();
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    // ARTIK TUM KOLEKSİYONU İNDİRMİYORUZ!
    // Sadece senin katıldığın sohbetleri index üzerinden getiriyoruz.
    _myChatsStream = FirebaseFirestore.instance
        .collection('chats')
        .where('katilimcilar', arrayContains: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mesajlarım")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _myChatsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var chatDocs = snapshot.data!.docs;

          if (chatDocs.isEmpty) {
            return const Center(child: Text("Henüz bir sohbetin yok."));
          }

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var data = chatDocs[index].data() as Map<String, dynamic>;

              // İsim ve İlan detaylarını dokümanın içine (denormalization) yazdıysan
              // buradan direkt okuyabilirsin. Eğer yoksa, sadece ilgili 1 dokümanı çekecek
              // tek bir FutureBuilder kullanmalısın, iç içe 3 tane değil.

              return ListTile(
                title: Text(data['ilanBaslik'] ?? "Sohbet"),
                subtitle: Text(data['sonMesaj'] ?? ""),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    ChatDetaySayfasi(
                        ilanId: data['ilanId'],
                        ustaId: data['aliciId'],
                        ustaAd: data['aliciIsim'] ?? "Kullanıcı"
                    ))),
              );
            },
          );
        },
      ),
    );
  }
}