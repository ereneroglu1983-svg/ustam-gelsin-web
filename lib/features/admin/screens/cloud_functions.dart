import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Senin verdiğin fonksiyon
Future<void> adminBakiyeYukle(
    BuildContext context,
    String hedefUid,
    int amount,
    String note
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
        content: Text('Bakiye yüklendi: ${result.data['message']}'),
        backgroundColor: Colors.green,
      ),
    );

  } on FirebaseFunctionsException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hata: ${e.message}'), backgroundColor: Colors.red),
    );
  }
}

class FinansView extends StatefulWidget {
  const FinansView({super.key});

  @override
  State<FinansView> createState() => _FinansViewState();
}

class _FinansViewState extends State<FinansView> {
  final Color primaryRed = const Color(0xFFDC143C);
  final Color navyBlue = const Color(0xFF000080);
  final Color darkBg = const Color(0xFF0F0F0F);
  final Color cardBg = const Color(0xFF1A1A1A);

  // YENİ: Kendine mi Başkasına mı seçimi
  void _showBakiyeSecimDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        title: const Text('Kime Yüklenecek?', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person, color: primaryRed),
              title: const Text('Kendime Yükle', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showTutarDialog(FirebaseAuth.instance.currentUser!.uid, 'Kendim');
              },
            ),
            ListTile(
              leading: Icon(Icons.group, color: navyBlue),
              title: const Text('Ustaya Yükle', style: TextStyle(color: Colors.white)),
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

  // YENİ: Tutar girme dialog
  void _showTutarDialog(String uid, String isim) {
    final amountController = TextEditingController();
    final noteController = TextEditingController(text: 'Manuel yükleme');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        title: Text('$isim için Yükle', style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tutar (TL)',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: navyBlue)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryRed)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Not',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: navyBlue)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryRed)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
            onPressed: () {
              final amount = int.tryParse(amountController.text)?? 0;
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Geçerli tutar gir')),
                );
                return;
              }
              Navigator.pop(context);
              adminBakiyeYukle(context, uid, amount, noteController.text.trim());
            },
            child: const Text('Yükle', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // YENİ: Usta seçme dialog
  void _showUstaSecDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        title: const Text('Usta Seç', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'usta')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Hata', style: TextStyle(color: Colors.red)));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final ustalar = snapshot.data!.docs;

              if (ustalar.isEmpty) {
                return const Center(
                  child: Text('Usta bulunamadı', style: TextStyle(color: Colors.grey)),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: ustalar.length,
                itemBuilder: (context, index) {
                  final data = ustalar[index].data() as Map<String, dynamic>;
                  final uid = ustalar[index].id;
                  final isim = data['displayName']?? data['name']?? 'İsimsiz';
                  final email = data['email']?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: navyBlue,
                      child: Text(
                        isim.isNotEmpty? isim[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(isim, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    onTap: () {
                      Navigator.pop(context);
                      _showTutarDialog(uid, isim);
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Center(
        child: Text('Finans Ekranı', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showBakiyeSecimDialog,
        backgroundColor: primaryRed,
        icon: const Icon(Icons.add_card, color: Colors.white),
        label: const Text('Bakiye Yükle', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}