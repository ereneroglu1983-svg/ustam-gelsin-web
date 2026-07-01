// lib/features/admin/screens/stats_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'moderasyon_view.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedFilter = 'Tüm Zamanlar';

  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("PLATFORM ANALİZİ",
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(6)),
                child: DropdownButton<String>(
                  dropdownColor: cardBg, value: _selectedFilter, underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  items: ['Tüm Zamanlar', 'Son 7 Gün', 'Son 30 Gün'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                  onChanged: (val) => setState(() => _selectedFilter = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox(height: 50, child: Center(child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 2)));

              var docs = snapshot.data!.docs;
              DateTime now = DateTime.now();
              if (_selectedFilter == 'Son 7 Gün') docs = docs.where((d) => (d['createdAt'] as Timestamp).toDate().isAfter(now.subtract(const Duration(days: 7)))).toList();
              else if (_selectedFilter == 'Son 30 Gün') docs = docs.where((d) => (d['createdAt'] as Timestamp).toDate().isAfter(now.subtract(const Duration(days: 30)))).toList();

              return Wrap(
                spacing: 8, runSpacing: 8,
                children: [
                  _statCard("Toplam", "${docs.length}", Icons.people, primaryRed),
                  _statCard("Usta", "${docs.where((d) => d.get('role') == 'usta').length}", Icons.engineering, Colors.white),
                  _statCard("Müşteri", "${docs.where((d) => d.get('role') == 'customer').length}", Icons.person, Colors.white),
                ],
              );
            },
          ),

          const SizedBox(height: 24),
          const Text("SİSTEM SAĞLIĞI", style: TextStyle(color: Colors.white30, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('ilanlar').where('durum', isEqualTo: 'onay_bekliyor').snapshots(),
                builder: (context, snap) => SizedBox(width: 240, child: _healthCard("Bekleyen Onay", snap.hasData ? "${snap.data!.docs.length}" : "0", Icons.assignment_late, Colors.yellow, () => Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(title: const Text("Moderasyon")), body: ModerasyonView()))))),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('system_alerts').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snap) => SizedBox(width: 240, child: _healthCard("Sistem Hata", snap.hasData ? "${snap.data!.docs.length}" : "0", Icons.error, primaryRed, () => _showErrorDetails(context, snap))),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collectionGroup('transactions').where('type', isEqualTo: 'deposit').snapshots(),
                builder: (context, snap) {
                  double total = 0;
                  if (snap.hasData) {
                    for (var doc in snap.data!.docs) {
                      total += (doc.data() as Map)['amount'] ?? 0;
                    }
                  }
                  return SizedBox(width: 240, child: _healthCard("Finans Hacim", NumberFormat.currency(locale: 'tr_TR', symbol: 'TL').format(total), Icons.account_balance_wallet, Colors.greenAccent, null));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String val, IconData icon, Color color) {
    return Container(
      width: 140, padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white10)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _healthCard(String title, String val, IconData icon, Color color, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white10)),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 11))),
            Text(val, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showErrorDetails(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      builder: (context) => ListView(
        padding: const EdgeInsets.all(16),
        children: snapshot.data!.docs.map((d) {
          var data = d.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(data['message'] ?? "Hata", style: const TextStyle(color: Colors.white, fontSize: 12)),
            subtitle: Text(data['timestamp']?.toDate().toString() ?? "", style: const TextStyle(color: Colors.white30, fontSize: 10)),
          );
        }).toList(),
      ),
    );
  }
}