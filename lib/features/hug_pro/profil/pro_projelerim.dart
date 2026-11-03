import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _black = Color(0xFF0B0B0B);
const _dark = Color(0xFF111111);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

class ProProjelerimScreen extends StatefulWidget {
  const ProProjelerimScreen({super.key});
  @override
  State<ProProjelerimScreen> createState() => _ProProjelerimScreenState();
}

class _ProProjelerimScreenState extends State<ProProjelerimScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: _offWhite,
      appBar: AppBar(
        backgroundColor: _black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('PROJELERİM', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 3)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88),
          child: Column(
            children: [
              Container(height: 1, color: _gold.withOpacity(0.6)),
              TabBar(
                controller: _tabController,
                indicatorColor: _gold,
                indicatorWeight: 2,
                labelColor: _gold,
                unselectedLabelColor: Colors.white38,
                labelStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
                unselectedLabelStyle: const TextStyle(fontSize: 9, letterSpacing: 1),
                tabs: const [
                  Tab(text: 'TEKLİF VERİLEN'),
                  Tab(text: 'RED EDİLEN'),
                  Tab(text: 'DEVAM EDEN'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(uid, ['BEKLEMEDE', 'GONDERILDI', 'TEKLIF_VERILDI'], _gold),
          _buildList(uid, ['REDDEDILDI', 'RED'], Colors.red),
          _buildList(uid, ['ONAYLANDI', 'DEVAM_EDIYOR', 'DEVAM'], Colors.green),
        ],
      ),
    );
  }

  Widget _buildList(String uid, List<String> durumlar, Color renk) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('hug_pro_teklifler').where('proId', isEqualTo: uid).where('durum', whereIn: durumlar).orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _gold));
        if (snap.hasError) return Center(child: Text('HATA: ${snap.error}', style: const TextStyle(fontSize: 10, color: _gray)));
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          String baslik = 'PROJE YOK';
          String alt = 'Bu kategoride proje bulunamadı';
          if (durumlar.contains('BEKLEMEDE')) { baslik = 'TEKLİF VERİLEN PROJE YOK'; alt = 'Verdiğin teklifler burada görünecek'; }
          if (durumlar.contains('REDDEDILDI')) { baslik = 'RED EDİLEN PROJE YOK'; alt = 'Reddedilen teklifler burada görünecek'; }
          if (durumlar.contains('ONAYLANDI')) { baslik = 'DEVAM EDEN PROJE YOK'; alt = 'Onaylanan projeler burada görünecek'; }
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 80, height: 80, decoration: BoxDecoration(border: Border.all(color: _black, width: 1)), child: Icon(Icons.folder_open_outlined, size: 40, color: renk.withOpacity(0.6))),
              const SizedBox(height: 16),
              Text(baslik, style: const TextStyle(fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(alt, style: const TextStyle(fontSize: 9, color: _gray)),
            ]),
          );
        }
        final docs = snap.data!.docs;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final projeBaslik = d['projeBaslik'] ?? d['baslik'] ?? 'Proje';
            final musteri = d['musteriAd'] ?? d['sehir'] ?? '';
            final fiyat = d['teklifFiyat'] ?? d['fiyat'] ?? 0;
            final durum = d['durum'] ?? '';
            final tarih = (d['createdAt'] as Timestamp?)?.toDate();
            return Container(
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: renk.withOpacity(0.2), width: 0.8)),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(width: 4, height: 50, color: renk),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(projeBaslik.toString().toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                      const SizedBox(height: 4),
                      Text(musteri.toString(), style: const TextStyle(fontSize: 9, color: _gray)),
                      const SizedBox(height: 4),
                      Row(children: [
                        Text('$fiyat TL', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _black)),
                        const SizedBox(width: 8),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), color: renk.withOpacity(0.1), child: Text(durum, style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: renk, letterSpacing: 0.8))),
                      ]),
                      if (tarih != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text('${tarih.day}.${tarih.month}.${tarih.year}', style: const TextStyle(fontSize: 8, color: _gray))),
                    ])),
                    Container(width: 28, height: 28, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6D6D6), width: 0.8), shape: BoxShape.circle), child: const Icon(Icons.arrow_outward, size: 12, color: _gray)),
                  ]),
                ),
                Container(height: 1, color: Colors.black.withOpacity(0.05)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(d['sehir'] ?? 'Türkiye', style: const TextStyle(fontSize: 8, color: _gray, letterSpacing: 1)),
                    const Text('DETAY →', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ]),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}