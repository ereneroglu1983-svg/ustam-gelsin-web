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

    // Sohbetleri katılımcı filtresiyle getiriyoruz.
    _myChatsStream = FirebaseFirestore.instance
        .collection('chats')
        .where('katilimcilar', arrayContains: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("Mesajlarım", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _myChatsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Henüz bir sohbetin yok.", style: TextStyle(color: Colors.white54)));
          }

          var chatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var data = chatDocs[index].data() as Map<String, dynamic>;

              List katilimcilar = data['katilimcilar'] ?? [];
              String digerKullaniciId = katilimcilar.firstWhere((id) => id != currentUserId, orElse: () => "");

              return ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
                title: Text(
                    "İlan ID: ${data['ilanId']?.toString().substring(0, 8) ?? 'Sohbet'}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                  data['sonMesaj'] ?? "Mesaj gönderildi",
                  style: const TextStyle(color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    ChatDetaySayfasi(
                        ilanId: data['ilanId'],
                        ustaId: digerKullaniciId,
                        ustaAd: "Sohbet"
                    ))),
              );
            },
          );
        },
      ),
    );
  }
}