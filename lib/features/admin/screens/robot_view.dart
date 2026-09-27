// lib/features/admin/screens/robot_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RobotView extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RobotView({super.key});

  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);

  // Hata mesajlarını filtrelemek için
  bool _isErrorMessage(String message) {
    final lower = message.toLowerCase();
    return lower.contains('hata') ||
        lower.contains('error') ||
        lower.contains('exception') ||
        lower.contains('failed') ||
        lower.contains('başarısız');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('robot_logs')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: Colors.white30, strokeWidth: 2));
              }

              // Hata mesajlarını filtrele
              final filteredDocs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final message = (data['message'] ?? '').toString();
                return !_isErrorMessage(message);
              }).toList();

              if (filteredDocs.isEmpty) {
                return const Center(
                    child: Text("Kayıt bulunamadı.",
                        style: TextStyle(color: Colors.white30, fontSize: 12)));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  var log = filteredDocs[index];
                  var data = log.data() as Map<String, dynamic>;
                  var time = (data['timestamp'] as Timestamp?)?.toDate();
                  final message = data['message'] ?? "İşlem kaydı";

                  // Usta veya Müşteri kaydına göre ikon rengi
                  final isUsta = message.toLowerCase().contains('usta');
                  final isMusteri = message.toLowerCase().contains('müşteri') ||
                      message.toLowerCase().contains('musteri');

                  Color iconColor = primaryRed;
                  if (isMusteri) iconColor = Colors.greenAccent;
                  if (isUsta) iconColor = Colors.orangeAccent;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.terminal, color: iconColor, size: 16),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(message,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                              if (time != null)
                                Text(DateFormat('dd.MM HH:mm:ss').format(time),
                                    style: const TextStyle(
                                        color: Colors.white30, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Row(children: [
      Icon(Icons.smart_toy, color: primaryRed, size: 16),
      const SizedBox(width: 8),
      const Text("OTONOM SİSTEM GÜNLÜĞÜ",
          style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold))
    ]),
  );
}