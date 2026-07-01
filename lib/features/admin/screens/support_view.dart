// lib/features/admin/screens/support_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  @override
  void initState() {
    super.initState();
    // Admin paneli açıkken yeni gelen mesajları izler
    FirebaseFirestore.instance
        .collection('admin_messages')
        .where('isNotificationNeeded', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          // Burada istersen bir Snack bar tetikleyebilir veya
          // özel bir ses/görsel uyarı çalabilirsin.
          debugPrint("Yeni mesaj bildirimi alındı: ${change.doc.data()}");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admin_messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz mesaj yok.", style: TextStyle(color: Colors.grey)));
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var data = messages[index].data() as Map<String, dynamic>;
            var timestamp = data['time'] as Timestamp?;

            return Card(
              color: const Color(0xFF1A1A1A),
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.message_outlined, color: Colors.blueAccent),
                title: Text(
                    data['msg'] ?? "Mesaj içeriği yok",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                    timestamp != null ? timestamp.toDate().toString() : "Tarih bilgisi yok",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => messages[index].reference.delete(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}