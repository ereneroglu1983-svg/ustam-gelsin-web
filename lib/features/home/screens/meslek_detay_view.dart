// lib/features/home/screens/meslek_detay_view.dart

import 'package:flutter/material.dart';
import 'package:ustam_gelsin/core/constants/meslekler_data.dart';
import 'package:ustam_gelsin/core/constants/yorum_motoru.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_auth_page.dart';

class MeslekDetayView extends StatelessWidget {
  final MeslekModel meslek;

  const MeslekDetayView({super.key, required this.meslek});

  @override
  Widget build(BuildContext context) {
    final yorumListesi = YorumMotoru.yorumlariGetir(meslek.isim);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: const Color(0xFFF5F5F5),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(meslek.resimYolu, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      meslek.isim,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                // 1. "Hemen Ücretsiz İlan Ver" Butonu
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerAuthPage(role: "customer"))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("HEMEN ÜCRETSİZ İLAN VER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  );
                }
                // 2. Yorumlar Başlığı
                if (index == 1) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text("Müşteri Yorumları",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  );
                }
                // 3. Yorum Kartları
                final yorum = yorumListesi[index - 2];
                return _yorumKarti(
                    yorum['isim']!,
                    yorum['yorum']!,
                    yorum['puan']!,
                    yorum['sehir']!
                );
              },
              childCount: yorumListesi.length + 2,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {},
          child: const Text("TEKLİF AL", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _yorumKarti(String isim, String yorum, String puan, String sehir) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Text(isim[0], style: const TextStyle(color: Colors.black))
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isim, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
            Text(sehir.toUpperCase(), style: const TextStyle(fontSize: 9, color: Colors.blueGrey, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                Text(" $puan", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 4),
            Text(yorum, style: const TextStyle(color: Colors.black87, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}