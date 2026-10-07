// lib/features/admin/screens/support_view.dart - V2 FIX - TELEFONA SIĞAR

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = FirebaseFirestore.instance
        .collection('admin_messages')
        .where('isNotificationNeeded', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          debugPrint("Yeni mesaj: ${change.doc.data()}");
        }
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admin_messages')
          .orderBy('time', descending: true)
          .limit(50) // Maliyet için limit
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 2));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz mesaj yok.", style: TextStyle(color: Colors.grey)));
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 80), // Altta boşluk - nav bar için
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var data = messages[index].data() as Map<String, dynamic>;
            var timestamp = data['time'] as Timestamp?;

            String tarihStr = "";
            if (timestamp!= null) {
              final dt = timestamp.toDate();
              tarihStr = "${dt.day}.${dt.month}.${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2,'0')}";
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Material( // FIX: Ink splash hatası için Material
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {}, // Tıklanabilir olsun ki splash görünsün
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.message_outlined, color: Colors.blueAccent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['msg']?? "Mesaj içeriği yok",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tarihStr,
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () async {
                            final onay = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                backgroundColor: const Color(0xFF1A1A1A),
                                title: const Text("Silinsin mi?", style: TextStyle(color: Colors.white, fontSize: 14)),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("İPTAL")),
                                  TextButton(onPressed: () => Navigator.pop(c, true), child: const Text("SİL", style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            );
                            if (onay == true) {
                              await messages[index].reference.delete();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}