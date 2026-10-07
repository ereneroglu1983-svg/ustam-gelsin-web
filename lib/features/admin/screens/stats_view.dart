
// lib/features/admin/screens/stats_view.dart - V7 SISTEM MESAJLARI EKLI
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'moderasyon_view.dart';

class StatsView extends StatefulWidget {
  const StatsView({
    super.key,
    this.onNavigateToUsers,
    this.onNavigateToRobot,
    this.onNavigateToFinans,
    this.onNavigateToB2B,
    this.onNavigateToSystemMessages,
  });

  final void Function({String? role})? onNavigateToUsers;
  final VoidCallback? onNavigateToRobot;
  final VoidCallback? onNavigateToFinans;
  final VoidCallback? onNavigateToB2B;
  final VoidCallback? onNavigateToSystemMessages;

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedFilter = 'Güncel';

  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);
  final Color primaryOrange = const Color(0xFFFF7A00);

  bool _isInFilter(DateTime createdAt, DateTime now) {
    if (_selectedFilter == 'Tüm Zamanlar') return true;
    if (_selectedFilter == 'Güncel') {
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      return createdAt.isAfter(startOfDay) && createdAt.isBefore(endOfDay);
    }
    if (_selectedFilter == 'Son 7 Gün') {
      return createdAt.isAfter(now.subtract(const Duration(days: 7)));
    }
    if (_selectedFilter == 'Son 30 Gün') {
      return createdAt.isAfter(now.subtract(const Duration(days: 30)));
    }
    return true;
  }

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
                  dropdownColor: cardBg,
                  value: _selectedFilter,
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  items: ['Güncel', 'Tüm Zamanlar', 'Son 7 Gün', 'Son 30 Gün']
                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedFilter = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(height: 50, child: Center(child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 2)));
              }
              var docs = snapshot.data!.docs;
              DateTime now = DateTime.now();
              docs = docs.where((d) {
                try {
                  final data = d.data() as Map<String, dynamic>;
                  if (!data.containsKey('createdAt') || data['createdAt'] == null) return _selectedFilter == 'Tüm Zamanlar';
                  final createdAt = (data['createdAt'] as Timestamp).toDate();
                  return _isInFilter(createdAt, now);
                } catch (e) { return _selectedFilter == 'Tüm Zamanlar'; }
              }).toList();

              final ustaCount = docs.where((d) { try { return (d.data() as Map)['role'] == 'usta'; } catch(_) { return false; } }).length;
              final musteriCount = docs.where((d) { try { return (d.data() as Map)['role'] == 'customer'; } catch(_) { return false; } }).length;

              return Row(
                children: [
                  Expanded(child: _statCardSmall("Toplam", "${docs.length}", Icons.people, primaryRed, null)),
                  const SizedBox(width: 8),
                  Expanded(child: _statCardSmall("Usta", "$ustaCount", Icons.engineering, Colors.white, () => widget.onNavigateToUsers?.call(role: 'usta'))),
                  const SizedBox(width: 8),
                  Expanded(child: _statCardSmall("Müşteri", "$musteriCount", Icons.person, Colors.white, () => widget.onNavigateToUsers?.call(role: 'customer'))),
                ],
              );
            },
          ),

          const SizedBox(height: 24),
          const Text("SİSTEM ANALİZİ", style: TextStyle(color: Colors.white30, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('ilanlar').where('durum', isEqualTo: 'onay_bekliyor').snapshots(),
                builder: (context, snap) {
                  if (snap.hasError) return SizedBox(width: 240, child: _healthCard("Bekleyen Onay", "0", Icons.assignment_late, Colors.yellow, () => Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(title: const Text("Moderasyon")), body: const ModerasyonView())))));
                  return SizedBox(width: 240, child: _healthCard("Bekleyen Onay", snap.hasData ? "${snap.data!.docs.length}" : "0", Icons.assignment_late, Colors.yellow, () => Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(title: const Text("Moderasyon")), body: const ModerasyonView())))));
                },
              ),

              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').orderBy('createdAt', descending: true).snapshots(),
                builder: (context, snap) {
                  if (snap.hasError) return SizedBox(width: 240, child: _healthCard("Yeni Katılanlar", "0", Icons.person_add_alt_1, Colors.orangeAccent, widget.onNavigateToRobot));
                  int count = 0;
                  if (snap.hasData) {
                    DateTime now = DateTime.now();
                    final startOfDay = DateTime(now.year, now.month, now.day);
                    final endOfDay = startOfDay.add(const Duration(days: 1));
                    count = snap.data!.docs.where((d) {
                      try {
                        final data = d.data() as Map<String, dynamic>;
                        if (data['createdAt'] == null) return false;
                        final dt = (data['createdAt'] as Timestamp).toDate();
                        return dt.isAfter(startOfDay) && dt.isBefore(endOfDay);
                      } catch (_) { return false; }
                    }).length;
                  }
                  return SizedBox(width: 240, child: _healthCard("Yeni Katılanlar", "$count", Icons.person_add_alt_1, Colors.orangeAccent, widget.onNavigateToRobot));
                },
              ),

              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collectionGroup('transactions').where('type', isEqualTo: 'deposit').snapshots(),
                builder: (context, snap) {
                  if (snap.hasError) return SizedBox(width: 240, child: _healthCard("Finans Hacim", "0 TL", Icons.account_balance_wallet, Colors.greenAccent, widget.onNavigateToFinans));
                  double total = 0;
                  if (snap.hasData) {
                    for (var doc in snap.data!.docs) {
                      total += (doc.data() as Map)['amount'] ?? 0;
                    }
                  }
                  return SizedBox(width: 240, child: _healthCard("Finans Hacim", NumberFormat.currency(locale: 'tr_TR', symbol: 'TL').format(total), Icons.account_balance_wallet, Colors.greenAccent, widget.onNavigateToFinans));
                },
              ),

              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('b2b_leads').limit(100).snapshots(),
                builder: (context, snap) {
                  if (snap.hasError) return SizedBox(width: 240, child: _healthCard("B2B Başvuru", "0", Icons.business_center, Colors.cyanAccent, widget.onNavigateToB2B));
                  if (!snap.hasData) return SizedBox(width: 240, child: _healthCard("B2B Başvuru", "0", Icons.business_center, Colors.cyanAccent, widget.onNavigateToB2B));
                  int activeCount = snap.data!.docs.where((d) {
                    try {
                      final data = d.data() as Map<String, dynamic>;
                      final durum = data['durum'] ?? data['status'] ?? 'yeni';
                      return durum == 'beklemede' || durum == 'yeni' || durum == 'aktif' || durum == 'onay_bekliyor';
                    } catch(_) { return true; }
                  }).length;
                  final displayCount = activeCount > 0 ? activeCount : snap.data!.docs.length;
                  return SizedBox(width: 240, child: _healthCard("B2B Başvuru", "$displayCount", Icons.business_center, Colors.cyanAccent, widget.onNavigateToB2B));
                },
              ),

              // YENI - SISTEM MESAJLARI
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('admin_messages').where('status', isEqualTo: 'yeni').snapshots(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return SizedBox(width: 240, child: _healthCard("Sistem Mesajları", "0", Icons.mail_outline, Colors.purpleAccent, widget.onNavigateToSystemMessages));
                  }
                  String countStr = snap.hasData ? "${snap.data!.docs.length}" : "0";
                  bool hasNew = snap.hasData && snap.data!.docs.isNotEmpty;
                  return SizedBox(
                      width: 240,
                      child: _healthCard(
                          "Sistem Mesajları",
                          countStr,
                          hasNew ? Icons.mark_email_unread : Icons.mail_outline,
                          hasNew ? Colors.redAccent : Colors.purpleAccent,
                          widget.onNavigateToSystemMessages,
                          isAlert: hasNew
                      )
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCardSmall(String title, String val, IconData icon, Color color, VoidCallback? onTap) {
    final bool isClickable = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: isClickable ? primaryOrange.withOpacity(0.3) : Colors.white10, width: isClickable ? 1.2 : 1)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isClickable ? primaryOrange : color, size: 16),
            const SizedBox(height: 3),
            Text(val, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 8))),
                if (isClickable) ...[const SizedBox(width: 2), Icon(Icons.arrow_outward, size: 8, color: primaryOrange.withOpacity(0.7))],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _healthCard(String title, String val, IconData icon, Color color, VoidCallback? onTap, {bool isAlert = false}) {
    final bool isClickable = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: isAlert ? color.withOpacity(0.15) : cardBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: isAlert ? color : (isClickable ? color.withOpacity(0.3) : Colors.white10), width: isAlert ? 1.5 : (isClickable ? 1.2 : 1))
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: TextStyle(color: isAlert ? Colors.white : Colors.white, fontSize: 11, fontWeight: isAlert ? FontWeight.bold : FontWeight.normal))),
            Container(
              padding: isAlert ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2) : EdgeInsets.zero,
              decoration: isAlert ? BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)) : null,
              child: Text(val, style: TextStyle(color: isAlert ? Colors.white : Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            if (isClickable) ...[const SizedBox(width: 6), Icon(Icons.arrow_outward, size: 12, color: color.withOpacity(0.7))],
          ],
        ),
      ),
    );
  }
}
