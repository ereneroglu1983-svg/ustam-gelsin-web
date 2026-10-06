// lib/features/chat/screens/chat_detay_sayfasi.dart - FINAL FIX V7.1
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';

class ChatDetaySayfasi extends StatefulWidget {
  final String ustaAd;
  final String ustaId;
  final String ilanId;

  const ChatDetaySayfasi({
    super.key,
    required this.ustaAd,
    required this.ustaId,
    required this.ilanId,
  });

  @override
  State<ChatDetaySayfasi> createState() => _ChatDetaySayfasiState();
}

class _ChatDetaySayfasiState extends State<ChatDetaySayfasi> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Stream<QuerySnapshot> _mesajStream;

  Future<DocumentSnapshot> _ilanGetir() async {
    var doc = await FirebaseFirestore.instance.collection('ilanlar').doc(widget.ilanId).get();
    if (doc.exists) return doc;
    return await FirebaseFirestore.instance.collection('acil_cagri').doc(widget.ilanId).get();
  }

  @override
  void initState() {
    super.initState();
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    _chatService.mesajOkunduIsaretle(widget.ilanId, currentUserId);

    // FIX V7.1: orElse hatası giderildi - try/catch ile güvenli arama
    _mesajStream = FirebaseFirestore.instance
        .collection('chats')
        .where('ilanId', isEqualTo: widget.ilanId)
        .where('katilimcilar', arrayContains: currentUserId)
        .snapshots()
        .asyncExpand((chatSnap) {
      if (chatSnap.docs.isEmpty) return const Stream<QuerySnapshot>.empty();

      // Doğru chat'i bul - orElse kullanmadan güvenli yöntem
      var dogruChat = chatSnap.docs.first;
      try {
        dogruChat = chatSnap.docs.firstWhere(
              (d) => (d.data() as Map<String, dynamic>)['katilimcilar']?.contains(widget.ustaId)?? false,
        );
      } catch (_) {
        // Bulamazsa ilk chat'i kullan
        dogruChat = chatSnap.docs.first;
      }

      return dogruChat.reference
          .collection('mesajlar')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _mesajGonder() {
    if (_controller.text.trim().isEmpty) return;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _chatService.mesajGonder(
      ilanId: widget.ilanId,
      gonderenId: currentUserId,
      aliciId: widget.ustaId,
      mesajMetni: _controller.text.trim(),
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
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.ustaAd, style: const TextStyle(color: Colors.white, fontSize: 16)),
            FutureBuilder<DocumentSnapshot>(
              future: _ilanGetir(),
              builder: (context, snapshot) {
                String baslik = "İlan detayı yükleniyor...";
                if (snapshot.hasData && snapshot.data!.exists) {
                  var data = snapshot.data!.data() as Map<String, dynamic>?;
                  baslik = data?['baslik']?? data?['kategori']?? "İlan Başlığı";
                }
                return Text(baslik, style: const TextStyle(fontSize: 12, color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis);
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
                stream: _mesajStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Hata: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final mesajlar = snapshot.data!.docs;
                  if (mesajlar.isEmpty) {
                    return const Center(child: Text("Henüz mesajlaşma yok, ilk mesajı sen at!", style: TextStyle(color: Colors.white54)));
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
                          alignment: isMe? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe? Colors.blue : Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(data['mesajMetni']?? "", style: const TextStyle(color: Colors.white)),
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
                      onSubmitted: (_) => _mesajGonder(),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.send, color: Colors.blue), onPressed: _mesajGonder)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}