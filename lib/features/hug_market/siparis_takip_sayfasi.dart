import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SiparisTakipSayfasi extends StatefulWidget {
  const SiparisTakipSayfasi({super.key});
  @override State<SiparisTakipSayfasi> createState() => _SiparisTakipSayfasiState();
}

class _SiparisTakipSayfasiState extends State<SiparisTakipSayfasi> {
  final _firestore = FirebaseFirestore.instance;

  final Map<String, int> _durumStep = {
    'hazirlaniyor': 0,
    'onaylandi': 1,
    'kargoda': 2,
    'dagitimda': 3,
    'teslim_edildi': 4,
  };

  String _durumText(String durum) {
    switch (durum) {
      case 'hazirlaniyor': return 'Hazırlanıyor';
      case 'onaylandi': return 'Onaylandı';
      case 'kargoda': return 'Kargoda';
      case 'dagitimda': return 'Dağıtımda';
      case 'teslim_edildi': return 'Teslim Edildi';
      default: return durum;
    }
  }

  Color _durumColor(String durum) {
    switch (durum) {
      case 'teslim_edildi': return const Color(0xFF10B981);
      case 'dagitimda': case 'kargoda': return const Color(0xFF3B82F6);
      case 'onaylandi': return const Color(0xFFF59E0B);
      default: return const Color(0xFFDC143C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Sipariş Takip', style: GoogleFonts.poppins(fontWeight: FontWeight.w700))),
        body: Center(child: Text('Giriş yapmalısın', style: GoogleFonts.poppins())),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          Image.asset('assets/hug_market/hug_logo.png', height: 30),
          const SizedBox(width: 8),
          Text('Sipariş Takip', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18)),
        ]),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('hug_market_siparisler').where('userId', isEqualTo: user.uid).orderBy('olusturmaTarihi', descending: true).snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Henüz sipariş yok', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Sepetinden sipariş ver, buradan takip et', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),
              FilledButton(style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A)), onPressed: () => Navigator.pop(context), child: Text('Alışverişe Dön', style: GoogleFonts.poppins())),
            ]));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snap.data!.docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final doc = snap.data!.docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final durum = (data['durum'] as String?)?? 'hazirlaniyor';
              final toplam = (data['toplam'] as num?)?.toDouble()?? 0;
              final tarih = (data['olusturmaTarihi'] as Timestamp?)?.toDate();
              final currentStep = _durumStep[durum]?? 0;

              return Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Header
                  Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Sipariş #${doc.id.substring(0, 6).toUpperCase()}', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(tarih!= null? '${tarih.day}.${tarih.month}.${tarih.year} • ${data['teslimatKonumu']?? 'Salihli'}' : 'Yeni sipariş', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    ]),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: _durumColor(durum).withOpacity(0.12), borderRadius: BorderRadius.circular(20)), child: Text(_durumText(durum), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: _durumColor(durum)))),
                  ])),

                  // Steps
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: List.generate(5, (step) {
                    final isDone = step <= currentStep;
                    final isLast = step == 4;
                    return Expanded(child: Row(children: [
                      Column(children: [
                        Container(width: 28, height: 28, decoration: BoxDecoration(color: isDone? _durumColor(durum) : const Color(0xFFE2E8F0), shape: BoxShape.circle), child: Icon(isDone? Icons.check : Icons.circle, size: 14, color: isDone? Colors.white : Colors.grey)),
                        const SizedBox(height: 4),
                        Text(['Hazır', 'Onay', 'Kargo', 'Dağıtım', 'Teslim'][step], style: GoogleFonts.poppins(fontSize: 9, fontWeight: isDone? FontWeight.w700 : FontWeight.w400, color: isDone? Colors.black : Colors.grey)),
                      ]),
                      if (!isLast) Expanded(child: Container(height: 2, margin: const EdgeInsets.only(bottom: 16), color: step < currentStep? _durumColor(durum) : const Color(0xFFE2E8F0))),
                    ]));
                  }))),

                  const Divider(height: 24),

                  // Ürünler alt collection'dan
                  FutureBuilder<QuerySnapshot>(
                    future: _firestore.collection('hug_market_siparisler').doc(doc.id).collection('urunler').get(),
                    builder: (context, urunSnap) {
                      if (!urunSnap.hasData) return const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator());
                      return Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), child: Column(children: urunSnap.data!.docs.map((u) {
                        final ud = u.data() as Map<String, dynamic>;
                        return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.inventory_2_outlined, size: 20)),
                          const SizedBox(width: 10),
                          Expanded(child: Text('${ud['urunAdi']?? 'Ürün'} x${ud['adet']?? 1}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500))),
                          Text('₺${(ud['fiyat']?? 0).toString()}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                        ]));
                      }).toList()));
                    },
                  ),

                  Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Toplam', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    Text('₺${toplam.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 15)),
                  ])),

                  // Bilgi bandı
                  Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Color(0xFFF8FAFC), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))), child: Row(children: [
                    const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFFDC143C)),
                    const SizedBox(width: 6),
                    Expanded(child: Text('Sponsor depodan direkt • 973 ilçeye • Tahmini teslimat 3 iş günü', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[700]))),
                  ])),
                ]),
              );
            },
          );
        },
      ),
    );
  }
}