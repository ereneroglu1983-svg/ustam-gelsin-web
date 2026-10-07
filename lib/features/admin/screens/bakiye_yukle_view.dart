// lib/features/admin/screens/bakiye_yukle_view.dart - V2 FINAL - TAM
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> adminBakiyeYukle(
    BuildContext context,
    String hedefUid,
    int amount,
    String note,
    ) async {
  try {
    final functions = FirebaseFunctions.instanceFor(region: 'europe-west3');
    final callable = functions.httpsCallable('adminBakiyeYukle');
    final result = await callable.call({
      'hedefUid': hedefUid,
      'amount': amount,
      'note': note,
    });
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Bakiye yüklendi: ${result.data['message']?? '$amount TL'}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.green.shade700,
      ),
    );
  } on FirebaseFunctionsException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Hata: ${e.message}'), backgroundColor: Colors.red.shade700),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Hata: $e'), backgroundColor: Colors.red.shade700),
    );
  }
}

class BakiyeYukleView extends StatefulWidget {
  final VoidCallback? onNavigateHome;
  const BakiyeYukleView({super.key, this.onNavigateHome});

  @override
  State<BakiyeYukleView> createState() => _BakiyeYukleViewState();
}

class _BakiyeYukleViewState extends State<BakiyeYukleView> {
  final Color primaryRed = const Color(0xFFDC143C);
  final Color navyBlue = const Color(0xFF000080);
  final Color darkBg = const Color(0xFF0F0F0F);
  final Color cardBg = const Color(0xFF1A1A1A);
  final Color primaryOrange = const Color(0xFFFF7A00);

  void _showBakiyeSecimDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kime Yüklenecek?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryOrange.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.person, color: primaryOrange)),
              title: const Text('Kendime Yükle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: const Text('Kendi hesabına', style: TextStyle(color: Colors.white54, fontSize: 11)),
              onTap: () {
                Navigator.pop(context);
                _showTutarDialog(FirebaseAuth.instance.currentUser!.uid, 'Kendim');
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.handyman, color: Colors.blue)),
              title: const Text('Ustaya Yükle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: const Text('Usta seç ve yükle', style: TextStyle(color: Colors.white54, fontSize: 11)),
              onTap: () {
                Navigator.pop(context);
                _showUstaSecDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTutarDialog(String uid, String isim) {
    final amountController = TextEditingController();
    final noteController = TextEditingController(text: 'Manuel yükleme - Admin');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$isim için Yükle', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tutar (TL) *',
                labelStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                filled: true,
                fillColor: darkBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white24)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryOrange, width: 1.5)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Not',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: darkBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white24)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryOrange, width: 1.5)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              final amount = int.tryParse(amountController.text)?? 0;
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Geçerli tutar gir kanka')));
                return;
              }
              Navigator.pop(context);
              adminBakiyeYukle(context, uid, amount, noteController.text.trim());
            },
            child: const Text('YÜKLE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _showUstaSecDialog() {
    final searchController = TextEditingController();
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Usta Seç', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: double.maxFinite,
            height: 450,
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (v) => setStateDialog(() => searchQuery = v.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: 'İsim / email ara...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: darkBg,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').where('role', whereIn: ['usta', 'master']).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return const Center(child: Text('Hata', style: TextStyle(color: Colors.red)));
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.orange));
                      var ustalar = snapshot.data!.docs;
                      if (searchQuery.isNotEmpty) {
                        ustalar = ustalar.where((d) {
                          final data = d.data() as Map<String, dynamic>;
                          final isim = (data['displayName']?? data['firstName']?? data['name']?? '').toString().toLowerCase();
                          final email = (data['email']?? '').toString().toLowerCase();
                          return isim.contains(searchQuery) || email.contains(searchQuery);
                        }).toList();
                      }
                      if (ustalar.isEmpty) return const Center(child: Text('Usta bulunamadı', style: TextStyle(color: Colors.white54)));
                      return ListView.separated(
                        itemCount: ustalar.length,
                        separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                        itemBuilder: (context, index) {
                          final data = ustalar[index].data() as Map<String, dynamic>;
                          final uid = ustalar[index].id;
                          final isim = data['displayName']?? '${data['firstName']?? ''} ${data['lastName']?? ''}'.trim();
                          final finalIsim = (isim.isEmpty)? (data['name']?? 'İsimsiz') : isim;
                          final email = data['email']?? '';
                          final bakiye = data['bakiye']?? data['balance']?? 0;
                          return ListTile(
                            leading: CircleAvatar(backgroundColor: navyBlue, child: Text(finalIsim.isNotEmpty? finalIsim[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            title: Text(finalIsim, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(email, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                              Text('Bakiye: $bakiye TL', style: TextStyle(color: primaryOrange, fontSize: 11, fontWeight: FontWeight.w600)),
                            ]),
                            onTap: () {
                              Navigator.pop(context);
                              _showTutarDialog(uid, finalIsim);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat', style: TextStyle(color: Colors.white54)))],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: cardBg,
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet, color: primaryOrange, size: 22),
                const SizedBox(width: 10),
                const Text('BAKİYE YÜKLE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _showBakiyeSecimDialog,
                  style: ElevatedButton.styleFrom(backgroundColor: primaryOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  icon: const Icon(Icons.add_card, color: Colors.white, size: 18),
                  label: const Text('YÜKLE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ],
            ),
          ),
          // Son işlemler
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('bakiye_yuklemeler').orderBy('tarih', descending: true).limit(50).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance_wallet_outlined, size: 60, color: Colors.white24),
                        const SizedBox(height: 12),
                        const Text('Henüz yükleme yok', style: TextStyle(color: Colors.white54)),
                        const SizedBox(height: 6),
                        const Text('Sağ alttaki butonla yükle', style: TextStyle(color: Colors.white24, fontSize: 12)),
                      ],
                    ),
                  );
                }
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final amount = data['amount']?? 0;
                    final hedef = data['hedefAd']?? data['hedefUid']?? 'Bilinmiyor';
                    final not = data['note']?? '';
                    final tarih = (data['tarih'] as Timestamp?)?.toDate();
                    final admin = data['yukleyenAdmin']?? '';
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                      child: Row(
                        children: [
                          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.arrow_upward, color: Colors.green, size: 18)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('$amount TL → $hedef', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(not, style: const TextStyle(color: Colors.white54, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                              if (tarih!= null) Text('${tarih.day}.${tarih.month}.${tarih.year} ${tarih.hour}:${tarih.minute.toString().padLeft(2,'0')} • $admin', style: const TextStyle(color: Colors.white24, fontSize: 10)),
                            ]),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showBakiyeSecimDialog,
        backgroundColor: primaryOrange,
        icon: const Icon(Icons.add_card, color: Colors.white),
        label: const Text('Bakiye Yükle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }
}