// lib/features/chat/screens/chat_detay_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';

class ChatDetaySayfasi extends StatefulWidget {
  final String ustaAd; // Karşı tarafın görünen ismi
  final String ustaId; // Mesajın gideceği hedef ID
  final String ilanId; // İlgili ilan

  const ChatDetaySayfasi({
    super.key,
    required this.ustaAd,
    required this.ustaId,
    required this.ilanId
  });

  @override
  State<ChatDetaySayfasi> createState() => _ChatDetaySayfasiState();
}

class _ChatDetaySayfasiState extends State<ChatDetaySayfasi> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _chatService.mesajOkunduIsaretle(widget.ilanId, currentUserId);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(widget.ustaAd, style: const TextStyle(color: Colors.white, fontSize: 16)),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('ilanlar').doc(widget.ilanId).snapshots(),
              builder: (context, snapshot) {
                String baslik = (snapshot.data?.exists == true) ? (snapshot.data?.get('baslik') ?? "İlan Başlığı") : "İlan Başlığı";
                return Text(baslik, style: const TextStyle(fontSize: 12, color: Colors.white70));
              },
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatService.mesajlariGetir(widget.ilanId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final mesajlar = snapshot.data!.docs;

                  if (mesajlar.isEmpty) {
                    return const Center(
                      child: Text(
                        "Henüz mesajlaşma yok, ilk mesajı sen at!",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: mesajlar.length,
                    itemBuilder: (context, index) {
                      var data = mesajlar[index].data() as Map<String, dynamic>;
                      bool isMe = data['gonderenId'] == currentUserId;
                      return ListTile(
                        title: Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(data['mesajMetni'], style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Mesaj yaz...",
                        hintStyle: TextStyle(color: Colors.white54),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _chatService.mesajGonder(
                          ilanId: widget.ilanId,
                          gonderenId: currentUserId,
                          aliciId: widget.ustaId,
                          mesajMetni: _controller.text,
                        );
                        _controller.clear();
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}