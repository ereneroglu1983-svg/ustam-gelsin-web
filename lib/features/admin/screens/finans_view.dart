// lib/features/admin/screens/finans_view.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FinansView extends StatefulWidget {
  const FinansView({super.key});
  @override
  State<FinansView> createState() => _FinansViewState();
}

class _FinansViewState extends State<FinansView> {
  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);

  bool _loading = true;
  List<QueryDocumentSnapshot> _allDocs = [];
  DateTime _lastFetch = DateTime(2000);

  @override
  void initState() {
    super.initState();
    _fetchOnce();
  }

  Future<void> _fetchOnce() async {
    // FATURA KORUMASI: Son 2 dakikada çekildiyse tekrar çekme
    if (DateTime.now().difference(_lastFetch).inMinutes < 2 && _allDocs.isNotEmpty) {
      return;
    }
    setState(() => _loading = true);
    try {
      // collectionGroup ile TÜM cüzdanlardaki transactions'ları tek seferde alıyoruz
      final snap = await FirebaseFirestore.instance.collectionGroup('transactions').get();
      _allDocs = snap.docs;
      _lastFetch = DateTime.now();
    } catch (e) {
      debugPrint("Finans çekme hatası: $e");
    }
    setState(() => _loading = false);
  }

  double _sum(String type, DateTime start, DateTime end) {
    double total = 0;
    for (var doc in _allDocs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['type'] != type) continue;
      final ts = data['date'] as Timestamp?;
      if (ts == null) continue;
      final d = ts.toDate();
      if (d.isAfter(start.subtract(const Duration(seconds: 1))) && d.isBefore(end)) {
        total += (data['amount'] as num?)?.toDouble() ?? 0;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: Colors.white30));

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day, 0, 0);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(monday.year, monday.month, monday.day, 0, 0);
    final weekEnd = weekStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final yearStart = DateTime(now.year, 1, 1);
    final yearEnd = DateTime(now.year + 1, 1, 1).subtract(const Duration(seconds: 1));

    return RefreshIndicator(
      color: primaryRed,
      backgroundColor: cardBg,
      onRefresh: _fetchOnce,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header(),
          const SizedBox(height: 4),
          Text("Son güncelleme: ${_lastFetch.hour.toString().padLeft(2,'0')}:${_lastFetch.minute.toString().padLeft(2,'0')} - Yenilemek için aşağı çek", style: const TextStyle(color: Colors.white24, fontSize: 10)),
          const SizedBox(height: 16),
          _card(
            title: "GÜNLÜK",
            subtitle: "${todayStart.day.toString().padLeft(2,'0')}/${todayStart.month.toString().padLeft(2,'0')}/${todayStart.year} (00:00 - 23:59)",
            komisyon: _sum('withdrawal', todayStart, todayEnd),
            cuzdan: _sum('deposit', todayStart, todayEnd),
          ),
          const SizedBox(height: 12),
          _card(
            title: "HAFTALIK",
            subtitle: "Pazartesi - Pazar (Bu Hafta)",
            komisyon: _sum('withdrawal', weekStart, weekEnd),
            cuzdan: _sum('deposit', weekStart, weekEnd),
            btnText: "Detay Gör >>",
            onBtn: () => _showHaftalik(weekStart),
          ),
          const SizedBox(height: 12),
          _card(
            title: "AYLIK - ${_ayAdi(now.month).toUpperCase()}",
            subtitle: "Ayın 1'inden ${monthEnd.day}'ine kadar",
            komisyon: _sum('withdrawal', monthStart, monthEnd),
            cuzdan: _sum('deposit', monthStart, monthEnd),
          ),
          const SizedBox(height: 12),
          _card(
            title: "YILLIK TOPLAM ${now.year}",
            subtitle: "Ocak - Aralık",
            komisyon: _sum('withdrawal', yearStart, yearEnd),
            cuzdan: _sum('deposit', yearStart, yearEnd),
            isYear: true,
            btnText: "Yıllık Detay >>",
            onBtn: () => _showYillik(now.year),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required String subtitle, required double komisyon, required double cuzdan, String? btnText, VoidCallback? onBtn, bool isYear = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), border: isYear ? Border.all(color: primaryRed.withOpacity(0.6)) : null),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(subtitle, style: const TextStyle(color: Colors.white30, fontSize: 11)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _box("KOMİSYON TOPLAMI", komisyon)),
          const SizedBox(width: 10),
          Expanded(child: _box("CÜZDAN TOPLAMI", cuzdan)),
        ]),
        if (onBtn != null) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: onBtn, child: Text(btnText!, style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold)))),
      ]),
    );
  }

  Widget _box(String label, double v) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      const SizedBox(height: 4),
      Text("${v.toStringAsFixed(2)} TL", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ]),
  );

  void _showHaftalik(DateTime mon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: List.generate(7, (i) {
              final d = mon.add(Duration(days: i));
              final s = DateTime(d.year, d.month, d.day, 0, 0);
              final e = DateTime(d.year, d.month, d.day, 23, 59, 59);
              return ListTile(
                title: Text(_gunAdi(i + 1), style: const TextStyle(color: Colors.white)),
                subtitle: Text("${d.day}/${d.month}", style: const TextStyle(color: Colors.white30, fontSize: 11)),
                trailing: Text("K:${_sum('withdrawal', s, e).toStringAsFixed(0)} | C:${_sum('deposit', s, e).toStringAsFixed(0)} TL", style: const TextStyle(color: Colors.white70)),
              );
            }),
          );
        },
      ),
    );
  }

  void _showYillik(int year) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: List.generate(12, (i) {
              final m = i + 1;
              final s = DateTime(year, m, 1);
              final e = DateTime(year, m + 1, 0, 23, 59, 59);
              return ListTile(
                title: Text(_ayAdi(m), style: const TextStyle(color: Colors.white)),
                trailing: Text("K:${_sum('withdrawal', s, e).toStringAsFixed(0)} | C:${_sum('deposit', s, e).toStringAsFixed(0)} TL", style: const TextStyle(color: Colors.white70)),
              );
            }),
          );
        },
      ),
    );
  }

  String _gunAdi(int w) => ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"][w - 1];
  String _ayAdi(int m) => ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"][m - 1];
  Widget _header() => const Row(children: [Icon(Icons.account_balance_wallet, color: Colors.white38), SizedBox(width: 10), Text("FİNANSAL AKIŞ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]);
}