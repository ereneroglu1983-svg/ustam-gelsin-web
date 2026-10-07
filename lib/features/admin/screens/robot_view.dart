
// lib/features/admin/screens/robot_view.dart - V3 YENI KATILANLAR GERCEK KULLANICILAR
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RobotView extends StatefulWidget {
  const RobotView({super.key});

  @override
  State<RobotView> createState() => _RobotViewState();
}

class _RobotViewState extends State<RobotView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);
  final Color primaryOrange = const Color(0xFFFF7A00);

  String _filter = 'Bugün';
  String _search = '';
  final TextEditingController _searchController = TextEditingController();

  bool _isInFilter(DateTime createdAt) {
    final now = DateTime.now();
    if (_filter == 'Bugün') {
      final start = DateTime(now.year, now.month, now.day);
      return createdAt.isAfter(start);
    }
    if (_filter == 'Son 7 Gün') return createdAt.isAfter(now.subtract(const Duration(days: 7)));
    if (_filter == 'Son 30 Gün') return createdAt.isAfter(now.subtract(const Duration(days: 30)));
    return true;
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return "şimdi";
    if (diff.inMinutes < 60) return "${diff.inMinutes} dk önce";
    if (diff.inHours < 24) return "${diff.inHours} saat önce";
    if (diff.inDays == 1) return "dün";
    if (diff.inDays < 7) return "${diff.inDays} gün önce";
    return DateFormat('dd.MM HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.person_add_alt_1, color: Color(0xFFFF7A00), size: 18),
              const SizedBox(width: 8),
              const Text("YENİ KATILANLAR", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              const Spacer(),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').orderBy('createdAt', descending: true).limit(200).snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) return const SizedBox();
                  int today = snap.data!.docs.where((d) {
                    try {
                      var data = d.data() as Map<String, dynamic>;
                      if (data['createdAt'] == null) return false;
                      var dt = (data['createdAt'] as Timestamp).toDate();
                      return _isInFilter(dt) == false ? false : DateTime.now().difference(dt).inHours < 24;
                    } catch(_) { return false; }
                  }).length;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: primaryOrange, borderRadius: BorderRadius.circular(10)),
                    child: Text("${snap.data!.docs.where((d){ try{ var dt = (d.data() as Map)['createdAt'] as Timestamp; return DateTime.now().difference(dt.toDate()).inHours < 24; }catch(_){return false;}}).length} bugün", style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ],
          ),
        ),

        // Filtre chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _chip("Bugün"),
              const SizedBox(width: 6),
              _chip("Son 7 Gün"),
              const SizedBox(width: 6),
              _chip("Son 30 Gün"),
              const SizedBox(width: 6),
              _chip("Tümü"),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Arama
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              hintText: "İsim veya e-posta ara...",
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 11),
              prefixIcon: const Icon(Icons.search, color: Colors.white30, size: 16),
              filled: true,
              fillColor: cardBg,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => _search = v.toLowerCase()),
          ),
        ),
        const SizedBox(height: 12),

        // Liste - Gerçek kullanıcılar
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').orderBy('createdAt', descending: true).limit(150).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('users').limit(150).snapshots(),
                  builder: (context, snap2) {
                    if (!snap2.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 2));
                    return _buildUserList(snap2.data!.docs);
                  },
                );
              }
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 2));
              return _buildUserList(snapshot.data!.docs);
            },
          ),
        ),
      ],
    );
  }

  Widget _chip(String label) {
    bool selected = _filter == label;
    return InkWell(
      onTap: () => setState(() => _filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? primaryOrange : cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? primaryOrange : Colors.white10),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.black : Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildUserList(List<QueryDocumentSnapshot> docs) {
    // filtrele
    var filtered = docs.where((doc) {
      try {
        var data = doc.data() as Map<String, dynamic>;
        DateTime? dt;
        if (data['createdAt'] is Timestamp) dt = (data['createdAt'] as Timestamp).toDate();
        if (dt == null && _filter != 'Tümü') return false;
        if (dt != null && !_isInFilter(dt)) return false;

        if (_search.isEmpty) return true;
        String displayName = (data['firstName'] != null && data['firstName'].isNotEmpty)
            ? "${data['firstName']} ${data['lastName'] ?? ''}".toLowerCase()
            : (data['name'] ?? "").toString().toLowerCase();
        String email = (data['email'] ?? "").toString().toLowerCase();
        return displayName.contains(_search) || email.contains(_search);
      } catch (_) { return _filter == 'Tümü'; }
    }).toList();

    // client sort yeniler üstte garanti
    filtered.sort((a, b) {
      try {
        var da = a.data() as Map<String, dynamic>;
        var db = b.data() as Map<String, dynamic>;
        DateTime? ta = da['createdAt'] is Timestamp ? (da['createdAt'] as Timestamp).toDate() : null;
        DateTime? tb = db['createdAt'] is Timestamp ? (db['createdAt'] as Timestamp).toDate() : null;
        if (ta == null && tb == null) return 0;
        if (ta == null) return 1;
        if (tb == null) return -1;
        return tb.compareTo(ta);
      } catch (_) { return 0; }
    });

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, color: Colors.white10, size: 48),
            const SizedBox(height: 12),
            Text(_filter == 'Bugün' ? "Bugün kimse katılmadı\nOrtalık sakin ☕" : "Kayıt bulunamadı", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white30, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + MediaQuery.of(context).padding.bottom + 24),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        var doc = filtered[index];
        var data = doc.data() as Map<String, dynamic>;
        String displayName = (data['firstName'] != null && data['firstName'].isNotEmpty)
            ? "${data['firstName']} ${data['lastName'] ?? ''}"
            : (data['name'] ?? "İsimsiz");
        String email = data['email'] ?? "-";
        String role = data['role'] ?? "customer";
        bool isUsta = role == 'usta';
        DateTime? createdAt = data['createdAt'] is Timestamp ? (data['createdAt'] as Timestamp).toDate() : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isUsta ? primaryOrange.withOpacity(0.25) : Colors.white10),
          ),
          child: Row(
            children: [
              // timeline çizgi
              Container(width: 3, height: 60, decoration: BoxDecoration(color: isUsta ? primaryOrange : Colors.greenAccent, borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)))),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 18,
                backgroundColor: isUsta ? primaryOrange.withOpacity(0.2) : Colors.greenAccent.withOpacity(0.2),
                child: Text(displayName.isNotEmpty ? displayName[0].toUpperCase() : "?", style: TextStyle(color: isUsta ? primaryOrange : Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: isUsta ? primaryOrange.withOpacity(0.2) : Colors.greenAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                            child: Text(isUsta ? "USTA" : "MÜŞTERİ", style: TextStyle(color: isUsta ? primaryOrange : Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(email, style: const TextStyle(color: Colors.white38, fontSize: 10), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(createdAt != null ? _timeAgo(createdAt) : "-", style: TextStyle(color: isUsta ? primaryOrange.withOpacity(0.7) : Colors.white30, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white24, size: 16),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}
