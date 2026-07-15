// lib/features/usta/screens/usta_cuzdanim.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ustam_gelsin/core/services/wallet_service.dart';
import 'package:ustam_gelsin/core/payment/iyzico/iyzico_manager.dart';
import 'package:ustam_gelsin/core/payment/iyzico/webview_payment_screen.dart';
import 'package:ustam_gelsin/features/wallet/screens/bakiye_yukle_screen.dart';

class UstaCuzdanim extends StatefulWidget {
  final String uid;
  const UstaCuzdanim({super.key, required this.uid});

  @override
  State<UstaCuzdanim> createState() => _UstaCuzdanimState();
}

class _UstaCuzdanimState extends State<UstaCuzdanim> {
  final WalletService _walletService = WalletService();
  final IyzicoManager _iyzicoManager = IyzicoManager();
  final TextEditingController _tutarController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _tutarController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,##0.00", "tr_TR");
    return "${formatter.format(price)} TL";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text("Cüzdanım", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<double>(
                  stream: _walletService.streamBakiye(widget.uid),
                  builder: (context, snapshot) {
                    double bakiye = snapshot.data?? 0.0;
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildCuzdanKarti(bakiye),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Son İşlemler", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: const [
                                    Expanded(flex: 3, child: Text("İŞLEM", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black54))),
                                    Expanded(flex: 2, child: Text("TARİH", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black54))),
                                    Expanded(flex: 2, child: Text("SAAT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black54))),
                                    Expanded(flex: 2, child: Text("TUTAR", textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black54))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(child: _buildIslemGecmisi(widget.uid)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
                          child: ElevatedButton(
                            onPressed: _loading
                                ? null
                                : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BakiyeYukleScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE30613),
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                elevation: 4),
                            child: _loading
                                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                                : const Text("BAKİYE YÜKLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuzdanKarti(double bakiye) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF203A43)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mevcut Bakiyeniz", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 10),
          Text(_formatPrice(bakiye), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildIslemGecmisi(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: _walletService.streamTransactions(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "Henüz bir işlem bulunmuyor.",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.shade300,
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

            // DÜZELTİLDİ: Backend 'topup' yazıyor, 'deposit' değil
            final String type = (data['type']?? '').toString();
            bool isPositive = type == 'topup' || type == 'deposit';

            // Senin tarih/saat sistemin - tek kaynak 'date'
            final Timestamp? ts = data['date'] as Timestamp?;
            if (ts == null) return const SizedBox.shrink();
            DateTime date = ts.toDate();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: Colors.white,
              child: Row(
                children: [
                  // İŞLEM kolonu
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: isPositive? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPositive? Icons.add : Icons.remove,
                            color: isPositive? Colors.green.shade700 : Colors.red.shade700,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isPositive? "YÜKLEME" : "HARCAMA",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TARİH kolonu
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat('dd.MM.yyyy').format(date),
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                  // SAAT kolonu
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat('HH:mm').format(date),
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                  // TUTAR kolonu
                  Expanded(
                    flex: 2,
                    child: Text(
                      "${isPositive? '+' : '-'}${data['amount']} TL",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPositive? Colors.green.shade700 : Colors.red.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}