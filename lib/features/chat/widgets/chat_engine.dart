// lib/features/chat/widgets/chat_engine.dart - FINAL FIX
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';

class ChatEngine extends StatefulWidget {
  final String ilanId;
  final String aliciId;
  final String baslik;

  const ChatEngine({super.key, required this.ilanId, required this.aliciId, required this.baslik});

  @override
  State<ChatEngine> createState() => _ChatEngineState();
}

class _ChatEngineState extends State<ChatEngine> {
  final String mevcutKullanici = FirebaseAuth.instance.currentUser!.uid;
  final ChatService chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Stream<QuerySnapshot> _mesajStream;

  @override
  void initState() {
    super.initState();
    // FIX: Doğru chat'i bul - sadece ilanId değil, katılımcıya göre
    _mesajStream = FirebaseFirestore.instance
        .collection('chats')
        .where('ilanId', isEqualTo: widget.ilanId)
        .where('katilimcilar', arrayContains: mevcutKullanici)
        .snapshots()
        .asyncExpand((chatSnap) {
      if (chatSnap.docs.isEmpty) return const Stream<QuerySnapshot>.empty();
      var dogruChat = chatSnap.docs.firstWhere(
            (d) => (d.data() as Map<String, dynamic>)['katilimcilar']?.contains(widget.aliciId)?? false,
        orElse: () => chatSnap.docs.first,
      );
      return dogruChat.reference
          .collection('mesajlar')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots();
    });

    // Okundu işaretle
    chatService.mesajOkunduIsaretle(widget.ilanId, mevcutKullanici);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _gonder() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    chatService.mesajGonder(
      ilanId: widget.ilanId,
      gonderenId: mevcutKullanici,
      aliciId: widget.aliciId,
      mesajMetni: text,
    );
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Row(children: [
            const Icon(Icons.work),
            const SizedBox(width: 10),
            Expanded(child: Text(widget.baslik, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis))
          ]),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _mesajStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              var mesajlar = snapshot.data!.docs;
              if (mesajlar.isEmpty) {
                return const Center(child: Text("Henüz mesaj yok, ilk mesajı sen at!"));
              }
              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: mesajlar.length,
                itemBuilder: (context, index) {
                  var data = mesajlar[index].data() as Map<String, dynamic>;
                  bool isMe = data['gonderenId'] == mevcutKullanici;
                  return Align(
                    alignment: isMe? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: isMe? Colors.orange : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(data['mesajMetni']?? "", style: TextStyle(color: isMe? Colors.white : Colors.black)),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: "Mesaj yaz..."), onSubmitted: (_) => _gonder())),
            IconButton(icon: const Icon(Icons.send), onPressed: _gonder)
          ]),
        )
      ],
    );
  }
}