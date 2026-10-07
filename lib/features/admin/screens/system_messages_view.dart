
// lib/features/admin/screens/system_messages_view.dart - YENI - SISTEM MESAJLARI
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SystemMessagesView extends StatefulWidget {
  const SystemMessagesView({super.key});

  @override
  State<SystemMessagesView> createState() => _SystemMessagesViewState();
}

class _SystemMessagesViewState extends State<SystemMessagesView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);
  final Color primaryOrange = const Color(0xFFFF7A00);

  Future<void> _markAsRead(String docId) async {
    await _firestore.collection('admin_messages').doc(docId).update({
      'status': 'okundu',
      'isNotificationNeeded': false,
    });
  }

  Future<void> _markAllAsRead() async {
    final snap = await _firestore.collection('admin_messages').where('status', isEqualTo: 'yeni').get();
    for (var doc in snap.docs) {
      await doc.reference.update({'status': 'okundu', 'isNotificationNeeded': false});
    }
  }

  Future<void> _deleteMessage(String docId) async {
    await _firestore.collection('admin_messages').doc(docId).delete();
  }

  void _showMessageDetail(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final msg = data['msg'] ?? '';
    final time = (data['time'] is Timestamp) ? (data['time'] as Timestamp).toDate() : (data['time'] as DateTime?);
    final status = data['status'] ?? 'yeni';

    // okundu yap
    if (status == 'yeni') _markAsRead(doc.id);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: primaryOrange, width: 1)),
        title: Row(
          children: [
            Icon(status == 'yeni' ? Icons.mark_email_unread : Icons.drafts, color: status == 'yeni' ? primaryOrange : Colors.white54, size: 18),
            const SizedBox(width: 8),
            Text(status == 'yeni' ? "YENİ MESAJ" : "SİSTEM MESAJI", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (time != null)
                  Text(DateFormat('dd.MM.yyyy HH:mm').format(time), style: const TextStyle(color: Colors.white30, fontSize: 11)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
                  child: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
                ),
                const SizedBox(height: 12),
                Text("ID: ${doc.id}", style: const TextStyle(color: Colors.white24, fontSize: 9)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("KAPAT", style: TextStyle(fontSize: 11))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.8)),
            onPressed: () { Navigator.pop(context); _deleteMessage(doc.id); },
            child: const Text("SİL", style: TextStyle(fontSize: 11)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryOrange),
            onPressed: () { _markAsRead(doc.id); Navigator.pop(context); },
            child: const Text("OKUNDU YAP", style: TextStyle(fontSize: 11, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(Icons.mail_outline, color: primaryOrange, size: 18),
              const SizedBox(width: 8),
              const Text("SİSTEM MESAJLARI", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              const Spacer(),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('admin_messages').where('status', isEqualTo: 'yeni').snapshots(),
                builder: (context, snap) {
                  int count = snap.hasData ? snap.data!.docs.length : 0;
                  if (count == 0) return const SizedBox();
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: primaryRed, borderRadius: BorderRadius.circular(10)),
                        child: Text("$count YENİ", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      TextButton(onPressed: _markAllAsRead, child: Text("TÜMÜNÜ OKUNDU YAP", style: TextStyle(color: primaryOrange, fontSize: 9, fontWeight: FontWeight.bold))),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('admin_messages').orderBy('time', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Hata: ${snapshot.error}", style: const TextStyle(color: Colors.white30, fontSize: 12)));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 2));
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Henüz sistem mesajı yok.", style: TextStyle(color: Colors.white30, fontSize: 12)));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  var data = doc.data() as Map<String, dynamic>;
                  String msg = data['msg'] ?? '';
                  String status = data['status'] ?? 'yeni';
                  DateTime? time;
                  try {
                    if (data['time'] is Timestamp) time = (data['time'] as Timestamp).toDate();
                    else if (data['time'] is DateTime) time = data['time'];
                  } catch (_) {}

                  bool isYeni = status == 'yeni';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: isYeni ? primaryOrange.withOpacity(0.12) : cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isYeni ? primaryOrange.withOpacity(0.4) : Colors.white10, width: isYeni ? 1.2 : 1),
                    ),
                    child: ListTile(
                      dense: true,
                      onTap: () => _showMessageDetail(doc),
                      leading: Icon(isYeni ? Icons.mark_email_unread : Icons.drafts, color: isYeni ? primaryOrange : Colors.white38, size: 18),
                      title: Text(
                        msg.length > 60 ? "${msg.substring(0, 60)}..." : msg,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: isYeni ? Colors.white : Colors.white70, fontSize: 12, fontWeight: isYeni ? FontWeight.bold : FontWeight.normal),
                      ),
                      subtitle: Text(
                        time != null ? DateFormat('dd.MM HH:mm').format(time) : "",
                        style: const TextStyle(color: Colors.white30, fontSize: 10),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isYeni)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: primaryRed, borderRadius: BorderRadius.circular(4)),
                              child: const Text("YENİ", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          const SizedBox(width: 6),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 16),
                            onPressed: () => _deleteMessage(doc.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
