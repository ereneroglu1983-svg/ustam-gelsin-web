// lib/features/hug_pro/profesyonel/pro_gelen_teklifler_screen.dart
// PRO GELEN TEKLİFLER - KİLİTLİ v1.1 - hug_pro_ozel_davetler + %4 + TEKLİF INPUT - HUGAI ONLY
// FIX: GROK -> HUGAI, budama yok, tam dosya

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _black = Color(0xFF0B0B0B);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

class ProGelenTekliflerScreen extends StatefulWidget {
  const ProGelenTekliflerScreen({super.key});
  @override
  State<ProGelenTekliflerScreen> createState() => _ProGelenTekliflerScreenState();
}

class _ProGelenTekliflerScreenState extends State<ProGelenTekliflerScreen> {
  final Map<String, TextEditingController> _bedelCtrl = {};
  final Map<String, TextEditingController> _notCtrl = {};

  @override
  void dispose() {
    for (final c in _bedelCtrl.values) c.dispose();
    for (final c in _notCtrl.values) c.dispose();
    super.dispose();
  }

  Future<void> _teklifVerDialog(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final davetId = doc.id;
    final erisimUcreti = (data['erisimUcreti'] as num?)?.toInt() ?? 0;
    final musteriAdi = (data['musteriAdi'] ?? 'Müşteri').toString();
    final ihtiyacIds = (data['ihtiyacIds'] as List?)?.cast<String>() ?? [];
    final valuation = data['valuation'] as Map<String, dynamic>?;

    final bedelController = TextEditingController();
    final notController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (c) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: _black, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [Container(width: 16, height: 1, color: _gold), const SizedBox(width: 8), Text('$musteriAdi İÇİN TEKLİF'.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold))])),
                const SizedBox(height: 12),
                if (valuation != null) ...[
                  // [FIX v1.1] GROK SİLİNDİ -> HUGAI
                  Text("HUGAI Tahmini: ${valuation['total']?['estimated_tl'] ?? 0} TL • Hizmet bedelidir", style: const TextStyle(fontSize: 10, color: _gray)),
                  const SizedBox(height: 4),
                  // Per-meslek breakdown göster
                  ...(valuation['services'] as List? ?? []).map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text("${s['service_name'] ?? s['service_id']}: ${s['estimated_tl']} TL (Erişim: ${s['hug_access_fee_tl']} TL)", style: const TextStyle(fontSize: 8, color: _gray)),
                  )),
                  const SizedBox(height: 4),
                ],
                Text("HUG Teklif Erişim Bedeli: $erisimUcreti TL", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _black)),
                Text("Öde, teklif ver, işi al", style: const TextStyle(fontSize: 9, color: _gray)),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(color: _offWhite, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Row(children: [const Text("TEKLİF BEDELİNİZ *", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 1)), const Text(" ZORUNLU", style: TextStyle(fontSize: 6, color: Colors.red))])),
                      TextField(controller: bedelController, keyboardType: TextInputType.number, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), decoration: const InputDecoration(hintText: "Örn: 50000", border: InputBorder.none, contentPadding: EdgeInsets.all(12))),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(color: _offWhite, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: const Text("TEKLİF NOTU (OPSİYONEL)", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 1))),
                      TextField(controller: notController, maxLines: 3, style: const TextStyle(fontSize: 11), decoration: const InputDecoration(hintText: "15 günde teslim, 2 revizyon...", border: InputBorder.none, contentPadding: EdgeInsets.all(12))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: GestureDetector(onTap: () => Navigator.pop(c, false), child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(border: Border.all(color: Colors.black12)), child: const Center(child: Text('İPTAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)))))),
                    const SizedBox(width: 8),
                    Expanded(child: GestureDetector(onTap: () => Navigator.pop(c, true), child: Container(color: _gold, padding: const EdgeInsets.symmetric(vertical: 12), child: Center(child: Text('ÖDE & TEKLİF VER - $erisimUcreti TL', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: _black)))))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result != true) return;
    final bedelText = bedelController.text.trim();
    if (bedelText.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teklif bedeli zorunlu"), backgroundColor: _black));
      return;
    }
    final bedelNum = int.tryParse(bedelText.replaceAll(".", "").replaceAll(",", ""));
    if (bedelNum == null || bedelNum <= 0) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Geçerli bedel gir"), backgroundColor: _black));
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final fs = FirebaseFirestore.instance;
      final userDoc = await fs.collection('users').doc(uid).get();
      final wallet = (userDoc.data()?['walletBalance'] ?? 0) as num;
      final abonelik = userDoc.data()?['abonelik'] as Map<String, dynamic>?;
      final bedava = (abonelik?['hugProBedavaHak'] ?? 0) as num;
      final hasBedava = bedava > 0;

      if (!hasBedava && wallet < erisimUcreti) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Yetersiz bakiye: $erisimUcreti TL lazım, $wallet TL var"), backgroundColor: Colors.red));
        return;
      }

      if (hasBedava) {
        await fs.collection('users').doc(uid).update({'abonelik.hugProBedavaHak': FieldValue.increment(-1)});
      } else {
        await fs.collection('users').doc(uid).update({'walletBalance': FieldValue.increment(-erisimUcreti)});
      }

      await fs.collection('hug_pro_teklifler').add({
        'projeId': data['projeId'] ?? data['parentDavetId'] ?? 'GENEL',
        'davetId': davetId,
        'parentDavetId': data['parentDavetId'],
        'serviceId': ihtiyacIds.isNotEmpty ? ihtiyacIds.first : 'GENEL',
        'profesyonelId': uid,
        'musteriId': data['musteriId'],
        'hugAccessFee': erisimUcreti,
        'teklifBedeli': bedelNum,
        'teklifNotu': notController.text.trim(),
        'durum': 'BEKLEMEDE',
        'olusturmaTarihi': FieldValue.serverTimestamp(),
      });

      await fs.collection('hug_pro_ozel_davetler').doc(davetId).update({
        'durum': 'TEKLIF_VERILDI',
        'teklifBedeli': bedelNum,
        'teklifNotu': notController.text.trim(),
        'teklifTarihi': FieldValue.serverTimestamp(),
      });

      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Teklif verildi: $bedelNum TL - $erisimUcreti TL ödendi"), backgroundColor: _black));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: _offWhite,
      appBar: AppBar(
        backgroundColor: _black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('GELEN TEKLİFLER', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 3, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Container(width: double.infinity, color: _black, padding: const EdgeInsets.fromLTRB(16, 0, 16, 10), child: Row(children: [Container(width: 20, height: 1, color: _gold), const SizedBox(width: 8), const Expanded(child: Text("MÜŞTERİ SENİ SEÇTİ - %4 ÖDE - TEKLİF VER", style: TextStyle(color: Colors.white54, fontSize: 7, letterSpacing: 1.2)))])),
        ),
      ),
      body: Column(
        children: [
          Container(height: 1, color: _gold.withOpacity(0.6)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('hug_pro_ozel_davetler').where('proId', isEqualTo: uid).snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _gold, strokeWidth: 1.5));
                if (snap.hasError) return Center(child: Text('HATA: ${snap.error}', style: const TextStyle(fontSize: 10, color: _gray)));
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _black.withOpacity(0.1))), child: const Icon(Icons.inbox_outlined, size: 40, color: _black)),
                      const SizedBox(height: 16),
                      const Text('GELEN TEKLİF YOK', style: TextStyle(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold, color: _black)),
                      const SizedBox(height: 8),
                      const Text('Müşteri seni seçince burada görünecek', style: TextStyle(fontSize: 10, color: _gray)),
                    ]),
                  );
                }
                final allDocs = snap.data!.docs;
                final docs = allDocs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final durum = data['durum']?.toString() ?? '';
                  return durum == 'BEKLEMEDE' || durum == 'GONDERILDI';
                }).toList()
                  ..sort((a, b) {
                    final at = (a.data() as Map<String, dynamic>)['olusturmaTarihi'] as Timestamp?;
                    final bt = (b.data() as Map<String, dynamic>)['olusturmaTarihi'] as Timestamp?;
                    if (at == null || bt == null) return 0;
                    return bt.compareTo(at);
                  });

                if (docs.isEmpty) {
                  return Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _black.withOpacity(0.1))), child: const Icon(Icons.inbox_outlined, size: 40, color: _black)),
                      const SizedBox(height: 16),
                      const Text('GELEN TEKLİF YOK', style: TextStyle(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold, color: _black)),
                      const SizedBox(height: 8),
                      const Text('Müşteri seni seçince burada görünecek', style: TextStyle(fontSize: 10, color: _gray)),
                    ]),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final d = docs[i].data() as Map<String, dynamic>;
                    final musteriAdi = d['musteriAdi'] ?? 'Müşteri';
                    final erisimUcreti = (d['erisimUcreti'] as num?)?.toInt() ?? 0;
                    final erisimAciklama = d['erisimUcretiAciklama'] ?? '$erisimUcreti TL Teklif Erişim Ücreti';
                    final ihtiyacIds = (d['ihtiyacIds'] as List?)?.join(", ") ?? '';
                    final tarih = (d['olusturmaTarihi'] as Timestamp?)?.toDate();
                    final valuation = d['valuation'] as Map<String, dynamic>?;
                    final tahmini = valuation?['total']?['estimated_tl'] ?? 0;

                    return Container(
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _gold.withOpacity(0.3), width: 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: _black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Container(width: 14, height: 1, color: _gold),
                                const SizedBox(width: 8),
                                Expanded(child: Text(musteriAdi.toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1))),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), color: _gold, child: Text("$erisimUcreti TL ERİŞİM", style: const TextStyle(color: _black, fontSize: 7, fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ihtiyacIds, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _black)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.auto_awesome, size: 10, color: _gold),
                                    const SizedBox(width: 4),
                                    // [FIX v1.1] GROK -> HUGAI
                                    Text("HUGAI Tahmini: $tahmini TL • $erisimAciklama", style: const TextStyle(fontSize: 9, color: _gray)),
                                  ],
                                ),
                                if (tarih != null) ...[
                                  const SizedBox(height: 4),
                                  Text("${tarih.day}.${tarih.month}.${tarih.year} ${tarih.hour}:${tarih.minute.toString().padLeft(2, '0')}", style: const TextStyle(fontSize: 8, color: _gray)),
                                ],
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () => _teklifVerDialog(docs[i]),
                                  child: Container(
                                    width: double.infinity,
                                    color: _gold,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Center(child: Text("TEKLİF VER - $erisimUcreti TL", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1, color: _black))),
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}