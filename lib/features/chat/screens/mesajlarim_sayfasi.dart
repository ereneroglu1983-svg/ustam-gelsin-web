// lib/features/chat/screens/mesajlarim_sayfasi.dart - FINAL FIX - ID YERINE BASLIK
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

    _myChatsStream = FirebaseFirestore.instance
        .collection('chats')
        .where('katilimcilar', arrayContains: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>?> _ilanGetir(String ilanId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('ilanlar').doc(ilanId).get();
      if (doc.exists) return doc.data();
      var acil = await FirebaseFirestore.instance.collection('acil_cagri').doc(ilanId).get();
      if (acil.exists) return acil.data();
      return null;
    } catch (_) {
      return null;
    }
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

              String ilanId = data['ilanId'] ?? '';
              String sonMesaj = data['sonMesaj'] ?? "Mesaj gönderildi";
              // Yeni chatlerde direkt var
              String? ilanBaslikFromChat = data['ilanBaslik'];
              String? ilanKategoriFromChat = data['ilanKategori'];

              // Eğer yeni chat ise Future'a gerek yok
              if (ilanBaslikFromChat != null && ilanBaslikFromChat.isNotEmpty) {
                return ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
                  title: Text(ilanBaslikFromChat,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    ilanKategoriFromChat != null && ilanKategoriFromChat.isNotEmpty
                        ? "$ilanKategoriFromChat • $sonMesaj"
                        : sonMesaj,
                    style: const TextStyle(color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                      ChatDetaySayfasi(ilanId: ilanId, ustaId: digerKullaniciId, ustaAd: ilanBaslikFromChat))),
                );
              }

              // Eski chatler için ilanlar'dan başlığı çek
              return FutureBuilder<Map<String, dynamic>?>(
                future: _ilanGetir(ilanId),
                builder: (context, ilanSnap) {
                  String baslik = "İlan";
                  String kategori = "";
                  if (ilanSnap.hasData && ilanSnap.data != null) {
                    baslik = ilanSnap.data!['baslik'] ?? ilanSnap.data!['kategori'] ?? "İlan";
                    kategori = ilanSnap.data!['kategori'] ?? "";
                  }

                  return ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
                    title: Text(baslik,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      kategori.isNotEmpty ? "$kategori • $sonMesaj" : sonMesaj,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        ChatDetaySayfasi(ilanId: ilanId, ustaId: digerKullaniciId, ustaAd: baslik))),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}