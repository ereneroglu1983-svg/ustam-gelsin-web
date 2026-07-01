// lib/features/chat/widgets/chat_engine.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';

class ChatEngine extends StatelessWidget {
  final String ilanId;
  final String aliciId;
  final String baslik; // İlan Başlığı

  const ChatEngine({super.key, required this.ilanId, required this.aliciId, required this.baslik});

  @override
  Widget build(BuildContext context) {
    final String mevcutKullanici = FirebaseAuth.instance.currentUser!.uid;
    final ChatService chatService = ChatService();
    final TextEditingController _controller = TextEditingController();

    return Column(
      children: [
        // 1. Üst Panel (Müşteri/Usta Adı + İlan Başlığı)
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.white,
          child: Row(children: [Icon(Icons.work), SizedBox(width: 10), Text(baslik, style: TextStyle(fontWeight: FontWeight.bold))]),
        ),

        // 2. Mesaj Listesi (StreamBuilder ile)
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: chatService.mesajlariGetir(ilanId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              var mesajlar = snapshot.data!.docs;

              return ListView.builder(
                reverse: true, // WP gibi en son mesaj altta/en yeni yukarıda
                itemCount: mesajlar.length,
                itemBuilder: (context, index) {
                  var data = mesajlar[index].data() as Map<String, dynamic>;
                  bool isMe = data['gonderenId'] == mevcutKullanici;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(color: isMe ? Colors.orange : Colors.grey.shade200, borderRadius: BorderRadius.circular(15)),
                      child: Text(data['mesajMetni'], style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // 3. Alt Giriş Alanı
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(children: [
            Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: "Mesaj yaz..."))),
            IconButton(icon: Icon(Icons.send), onPressed: () {
              chatService.mesajGonder(ilanId: ilanId, gonderenId: mevcutKullanici, aliciId: aliciId, mesajMetni: _controller.text);
              _controller.clear();
            })
          ]),
        )
      ],
    );
  }
}