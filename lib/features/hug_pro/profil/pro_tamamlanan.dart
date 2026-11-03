// lib/features/home/screens/pro_tamamlanan_screen.dart
// HATASIZ - TAMAMLANAN PROJELER - DETAY SAYFASI KARTI DNA - BEYAZ ZEMIN SIYAH YAZI
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

const _black = Color(0xFF0B0B0B);
const _dark = Color(0xFF111111);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

class ProTamamlananScreen extends StatelessWidget {
  const ProTamamlananScreen({super.key});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: _offWhite,
      appBar: AppBar(
        backgroundColor: _black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('TAMAMLANAN PROJELER', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 3, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(height: 1, color: _gold.withOpacity(0.6)),
          // ÜST KÜNYE - DETAY HEADER ILE AYNI DNA
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users_pro').doc(uid).snapshots(),
            builder: (context, proSnap) {
              if (!proSnap.hasData) return const SizedBox();
              final proData = proSnap.data!.data() as Map<String, dynamic>?;
              final tamamlananSayi = proData?['tamamlananProjeSayisi'] ?? 0;
              return Container(
                width: double.infinity,
                color: _black,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  children: [
                    Container(width: 20, height: 1, color: _gold),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$tamamlananSayi TAMAMLANAN PROJE', style: const TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        const Text('KÜNYENDE GÖRÜNECEK', style: TextStyle(color: Colors.white38, fontSize: 7, letterSpacing: 1)),
                      ],
                    ),
                    const Spacer(),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(border: Border.all(color: _gold.withOpacity(0.4))), child: const Row(children: [Icon(Icons.verified, size: 10, color: _gold), SizedBox(width: 4), Text('KÜNYE', style: TextStyle(color: _gold, fontSize: 8, letterSpacing: 1, fontWeight: FontWeight.bold))])),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('hug_pro_tamamlanan').where('proId', isEqualTo: uid).orderBy('tamamlanmaTarihi', descending: true).snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _gold, strokeWidth: 1.5));
                if (snap.hasError) {
                  return Center(child: Text('HATA: ${snap.error}', style: const TextStyle(fontSize: 10, color: _gray)));
                }
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _gold.withOpacity(0.5))), child: const Icon(Icons.verified_outlined, size: 40, color: _gold)),
                      const SizedBox(height: 16),
                      const Text('HENÜZ TAMAMLANAN PROJE YOK', style: TextStyle(fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold, color: _black)),
                      const SizedBox(height: 8),
                      const Text('Tamamladığın projeler künyende görünecek', style: TextStyle(fontSize: 9, color: _gray)),
                    ]),
                  );
                }
                final docs = snap.data!.docs;
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final d = docs[i].data() as Map<String, dynamic>;
                    final projeBaslik = (d['projeBaslik'] ?? d['baslik'] ?? 'Proje').toString();
                    final musteri = (d['musteriAd'] ?? '').toString();
                    final sehir = (d['sehir'] ?? d['il'] ?? '').toString();
                    final fiyat = d['anlasilanFiyat'] ?? d['fiyat'] ?? 0;
                    final tamamlanma = (d['tamamlanmaTarihi'] as Timestamp?)?.toDate();
                    final fotoUrl = d['projeFotoUrl'] ?? d['kapakFotoUrl'];
                    final puan = d['musteriPuani'] ?? 5;
                    final idShort = (docs[i].id).substring(0, 8).toUpperCase();

                    // DETAY SAYFASI ULTRA SADE KART DNA - TAMAMLANDI VERSIYON
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _gold.withOpacity(0.3))),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        if (fotoUrl != null)
                          CachedNetworkImage(imageUrl: fotoUrl, height: 160, width: double.infinity, fit: BoxFit.cover, errorWidget: (_, __, ___) => Container(height: 160, color: _offWhite, child: const Icon(Icons.image_outlined, color: _gray))),

                        // HEADER - DETAY ILE AYNI
                        Container(
                          width: double.infinity,
                          color: _black,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Container(width: 14, height: 1, color: _gold),
                              const SizedBox(width: 8),
                              Expanded(child: Text("${projeBaslik.toUpperCase()} - TAMAMLANDI", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3))),
                              const SizedBox(width: 8),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), color: _gold, child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star, size: 10, color: _black), const SizedBox(width: 2), Text('$puan', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: _black))])),
                            ],
                          ),
                        ),

                        // ICERIK - DETAY ILE AYNI padding 16
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Container(width: 32, height: 32, decoration: BoxDecoration(color: _black, border: Border.all(color: _gold.withOpacity(0.3))), child: const Icon(Icons.verified, size: 16, color: _gold)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    const Text("ANLAŞILAN BEDEL", style: TextStyle(fontSize: 7, color: _gray, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                    const SizedBox(height: 2),
                                    Text("$fiyat TL", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _black, letterSpacing: -0.5)),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), color: _offWhite, child: Text("Tamamlanma: ${_formatDate(tamamlanma)}", style: const TextStyle(fontSize: 8, color: _gray))),
                            const SizedBox(height: 14),
                            Container(height: 1, color: Colors.black.withOpacity(0.06)),
                            const SizedBox(height: 12),
                            Row(children: [const SizedBox(width: 50, child: Text("MÜŞTERİ", style: TextStyle(fontSize: 7, color: _gray, letterSpacing: 1))), Expanded(child: Text(musteri, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _black)))]),
                            const SizedBox(height: 6),
                            Row(children: [const SizedBox(width: 50, child: Text("KONUM", style: TextStyle(fontSize: 7, color: _gray, letterSpacing: 1))), Expanded(child: Text(sehir, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _black)))]),
                          ]),
                        ),

                        // KÜNYE FOOTER - DETAY FOOTER DNA
                        Container(
                          width: double.infinity,
                          color: _black,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text('KÜNYEDE GÖRÜNÜYOR', style: TextStyle(color: _gold, fontSize: 7, letterSpacing: 1, fontWeight: FontWeight.bold)),
                            Row(children: [const Icon(Icons.verified, size: 10, color: _gold), const SizedBox(width: 4), Text(idShort, style: const TextStyle(color: Colors.white54, fontSize: 7, letterSpacing: 1))]),
                          ]),
                        ),
                      ]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}