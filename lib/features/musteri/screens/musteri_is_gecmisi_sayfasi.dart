import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MusteriIsGecmisiSayfasi extends StatelessWidget {
  const MusteriIsGecmisiSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("İş Geçmişim", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tamamlanan_isler')
            .where('userId', isEqualTo: userId)
            .orderBy('tamamlanmaTarihi', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Henüz tamamlanmış işiniz yok.", style: TextStyle(color: Colors.white60)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var job = snapshot.data!.docs[index];
              var data = job.data() as Map<String, dynamic>;

              String tarihStr = "";
              if (data['tamamlanmaTarihi'] != null) {
                DateTime date = (data['tamamlanmaTarihi'] as Timestamp).toDate();
                tarihStr = DateFormat('dd/MM/yyyy HH:mm').format(date);
              }

              return Card(
                color: Colors.white.withOpacity(0.05),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(data['baslik'] ?? "Başlık Yok", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      const Text("Durum: TAMAMLANDI", style: TextStyle(color: Colors.greenAccent)),
                      Text("Tarih: $tarihStr", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}