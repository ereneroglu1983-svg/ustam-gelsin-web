// lib/features/admin/screens/user_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';
import 'package:ustam_gelsin/core/repositories/transaction_repository.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();
  final TransactionRepository _transactionRepository = TransactionRepository();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);

  // ID'den isme çevrim için değişkenler
  dynamic _sehirler;
  dynamic _ilceler;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
    _transactionRepository.fetchAllTransactions();
  }

  Future<void> _loadLocationData() async {
    final sehirJson = await rootBundle.loadString('assets/data/sehirler.json');
    final ilceJson = await rootBundle.loadString('assets/data/ilceler.json');
    setState(() {
      _sehirler = json.decode(sehirJson);
      _ilceler = json.decode(ilceJson);
    });
  }

  String _getName(dynamic data, dynamic id, String idKey, String nameKey) {
    if (id == null || data == null || data is! List) return id?.toString() ?? "-";
    for (var item in data) {
      if (item[idKey]?.toString() == id.toString()) {
        return item[nameKey]?.toString() ?? id.toString();
      }
    }
    return id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: "İsim veya E-posta ara...",
                hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                prefixIcon: const Icon(Icons.search, color: Colors.white30, size: 16),
                filled: true,
                fillColor: cardBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          TabBar(
            indicatorColor: primaryRed,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white38,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            tabs: const [Tab(text: "MÜŞTERİ"), Tab(text: "USTA")],
          ),
          Expanded(
            child: TabBarView(
              children: [_userList('customer'), _userList('usta')],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userList(String role) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').where('role', isEqualTo: role).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 2));
        var docs = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          String displayName = (data['firstName'] != null && data['firstName'].isNotEmpty)
              ? "${data['firstName']} ${data['lastName'] ?? ''}"
              : (data['name'] ?? "");
          return displayName.toLowerCase().contains(_searchQuery) ||
              (data['email'] ?? "").toLowerCase().contains(_searchQuery);
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var user = docs[index];
            var data = user.data() as Map<String, dynamic>;
            bool isBanned = data['isBanned'] ?? false;
            String displayName = (data['firstName'] != null && data['firstName'].isNotEmpty)
                ? "${data['firstName']} ${data['lastName'] ?? ''}"
                : (data['name'] ?? "İsimsiz/Ünvansız");

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(6)),
              child: ListTile(
                dense: true,
                onTap: () => _showUserDetail(user, context),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: isBanned ? primaryRed.withOpacity(0.2) : Colors.white10,
                  child: Text(displayName.isNotEmpty ? displayName[0].toUpperCase() : "?", style: TextStyle(color: isBanned ? primaryRed : Colors.white, fontSize: 12)),
                ),
                title: Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                subtitle: Text(data['email'] ?? "-", style: const TextStyle(color: Colors.white54, fontSize: 10)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(isBanned ? Icons.lock_open : Icons.block, color: isBanned ? Colors.green : Colors.white38, size: 16),
                        onPressed: () => _chatService.updateUserBanStatus(user.id, !isBanned)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.white38, size: 16),
                        onPressed: () => _firestore.collection('users').doc(user.id).delete()),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showUserDetail(DocumentSnapshot doc, BuildContext context) async {
    var user = doc.data() as Map<String, dynamic>;
    var riza = user['riza_tarihleri'] ?? {};
    final TextEditingController msgController = TextEditingController();
    bool isUsta = user['role'] == 'usta';
    List<dynamic> uzmanliklar = user['uzmanliklar'] ?? [];

    // Şehir ve İlçe İsimleri
    String sehirIsmi = _getName(_sehirler, user['sehir_id'], 'sehir_id', 'sehir_adi');
    String ilceIsmi = _getName(_ilceler, user['ilce_id'], 'ilce_id', 'ilce_adi');

    // Komisyon toplamını sistem içinden hesapla
    double toplamKomisyon = 0.0;
    if (isUsta) {
      final allTrans = await _transactionRepository.fetchAllTransactions();
      toplamKomisyon = allTrans
          .where((t) => t['walletId'] == doc.id && t['type'] == 'withdrawal')
          .fold(0.0, (sum, item) => sum + (double.tryParse(item['amount']?.toString() ?? "0") ?? 0.0));
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: primaryRed, width: 1)),
        title: const Text("HUKUKİ KAYIT & İLETİŞİM", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 350,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _infoRow("İsim", user['firstName'] ?? user['name'] ?? "-"),
                _infoRow("Soyisim/Ünvan", user['lastName'] ?? "-"),
                _infoRow("E-posta", user['email'] ?? "-"),
                _infoRow("Telefon", user['phone'] ?? "-"),
                _infoRow("Şehir", sehirIsmi),
                _infoRow("İlçe", ilceIsmi),
                _infoRow("Kayıt Tarihi", (user['createdAt'] as Timestamp?)?.toDate().toString().substring(0, 16) ?? "-"),
                if (isUsta) ...[
                  _infoRow("TC/VD No", user['tcVergiNo'] ?? "-"),
                  _infoRow("Cüzdan Bakiye", "${user['bakiye'] ?? 0} TL"),
                  _infoRow("Komisyon Ödemesi", "${toplamKomisyon.toStringAsFixed(2)} TL"),
                  const Divider(color: Colors.white10, height: 20),
                  const Text("UZMANLIK ALANLARI", style: TextStyle(color: Colors.white30, fontSize: 10)),
                  Wrap(spacing: 4, runSpacing: 4, children: uzmanliklar.map((u) => Chip(label: Text(u, style: const TextStyle(fontSize: 9)), backgroundColor: Colors.white10)).toList()),
                ],
                _infoRow("IP", user['ipKaydi'] ?? "-"),
                const Divider(color: Colors.white10, height: 20),
                const Text("ONAYLAR", style: TextStyle(color: Colors.white30, fontSize: 10)),
                const SizedBox(height: 8),
                _infoRow("Sözleşme", riza['sozlesme'] != null ? "ONAYLI" : "BEKLİYOR"),
                _infoRow("KVKK", riza['kvkk'] != null ? "ONAYLI" : "BEKLİYOR"),
                _infoRow("Kişisel Veri", riza['kisiselVeri'] != null ? "ONAYLI" : "BEKLİYOR"),
                _infoRow("Yasal Yüküm.", riza['yasalYukumluluk'] != null ? "ONAYLI" : "BEKLİYOR"),
                const SizedBox(height: 12),
                TextField(
                  controller: msgController,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(hintText: "Mesaj gönder...", hintStyle: TextStyle(color: Colors.white30, fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("KAPAT", style: TextStyle(fontSize: 11))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
            onPressed: () {
              _chatService.adminMesajGonder(aliciId: doc.id, mesajMetni: msgController.text);
              Navigator.pop(context);
            },
            child: const Text("MESAJ GÖNDER", style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}