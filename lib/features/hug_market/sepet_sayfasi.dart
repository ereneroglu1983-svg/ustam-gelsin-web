import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/features/hug_market/siparis_takip_sayfasi.dart';

class SepetSayfasi extends StatefulWidget {
  const SepetSayfasi({super.key});
  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}

class _SepetSayfasiState extends State<SepetSayfasi> {
  final AuthService _authService = AuthService();
  final _firestore = FirebaseFirestore.instance;
  bool _isUsta = false;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    String? role = await _authService.getUserRole();
    if (mounted) setState(() => _isUsta = role == 'usta' || role == 'master');
  }

  Future<void> _updateAdet(String docId, int newAdet) async {
    if (newAdet <= 0) {
      await _firestore.collection('hug_market_sepet').doc(docId).delete();
      return;
    }
    await _firestore.collection('hug_market_sepet').doc(docId).update({'adet': newAdet});
  }

  Future<void> _sepetiBosalt() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final batch = _firestore.batch();
    final snap = await _firestore.collection('hug_market_sepet').where('userId', isEqualTo: user.uid).get();
    for (var doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Sepetim', style: GoogleFonts.poppins(fontWeight: FontWeight.w700))),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text('Sepeti görmek için giriş yap', style: GoogleFonts.poppins()),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFDC143C)),
              onPressed: () => Navigator.pop(context),
              child: const Text('Geri Dön'),
            ),
          ]),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          Image.asset('assets/hug_market/hug_logo.png', height: 32),
          const SizedBox(width: 8),
          Text('Sepetim', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18)),
        ]),
        actions: [
          TextButton.icon(
            onPressed: () => _sepetiBosalt(),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: Text('Boşalt', style: GoogleFonts.poppins(fontSize: 12)),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('hug_market_sepet').where('userId', isEqualTo: user.uid).snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Image.asset('assets/hug_market/hugmarket.png', height: 120),
                const SizedBox(height: 16),
                Text('Sepetin boş', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Malzeme ekle, 3 iş gününde şantiyene gelsin', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Alışverişe Devam Et', style: GoogleFonts.poppins()),
                ),
              ]),
            );
          }

          double araToplam = 0;
          for (var d in snap.data!.docs) {
            final data = d.data() as Map<String, dynamic>;
            final fiyat = (data['fiyat'] as num?)?? 0;
            final adet = (data['adet'] as num?)?? 1;
            araToplam += fiyat * adet;
          }
          final indirim = _isUsta? araToplam * 0.05 : 0.0;
          final toplam = araToplam - indirim;

          return LayoutBuilder(builder: (context, c) {
            final isMobile = c.maxWidth < 700;
            final list = ListView.separated(
              padding: EdgeInsets.all(isMobile? 16 : 24),
              itemCount: snap.data!.docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final doc = snap.data!.docs[i];
                final data = doc.data() as Map<String, dynamic>;
                final fiyat = (data['fiyat'] as num?)?? 0;
                final adet = (data['adet'] as num?)?? 1;
                final gorsel = data['gorsel'] as String?;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                      child: gorsel!= null
                          ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(gorsel, fit: BoxFit.cover))
                          : const Icon(Icons.inventory_2_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(data['urunAdi']?? 'Ürün', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 2),
                        const SizedBox(height: 2),
                        Text('${data['sponsor']?? 'Sponsor Depo'} • 3 günde teslim', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Text('₺$fiyat', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 14, color: const Color(0xFF0F172A))),
                      ]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(children: [
                        IconButton(icon: const Icon(Icons.remove, size: 16), onPressed: () => _updateAdet(doc.id, (adet - 1).toInt())),
                        Text('$adet', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                        IconButton(icon: const Icon(Icons.add, size: 16), onPressed: () => _updateAdet(doc.id, (adet + 1).toInt())),
                      ]),
                    ),
                  ]),
                );
              },
            );

            final summary = Container(
              padding: EdgeInsets.all(isMobile? 16 : 20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sipariş Özeti', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 14),
                _priceRow('Ara Toplam', araToplam),
                if (_isUsta) _priceRow('%5 Usta İndirimi', -indirim, isDiscount: true),
                const Divider(height: 20),
                _priceRow('Toplam', toplam, isTotal: true),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFDC143C).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFFDC143C)),
                    const SizedBox(width: 6),
                    Expanded(child: Text('Sponsor depodan direkt • 973 ilçeye • 3 iş günü şantiyeye teslim', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFFDC143C)))),
                  ]),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () async {
                      final batch = _firestore.batch();
                      final siparisId = _firestore.collection('hug_market_siparisler').doc().id;
                      batch.set(_firestore.collection('hug_market_siparisler').doc(siparisId), {
                        'userId': user.uid,
                        'toplam': toplam,
                        'araToplam': araToplam,
                        'indirim': indirim,
                        'durum': 'hazirlaniyor',
                        'olusturmaTarihi': FieldValue.serverTimestamp(),
                        'teslimatKonumu': 'Salihli',
                      });
                      for (var d in snap.data!.docs) {
                        final data = d.data() as Map<String, dynamic>;
                        batch.set(_firestore.collection('hug_market_siparisler').doc(siparisId).collection('urunler').doc(), data);
                        batch.delete(d.reference);
                      }
                      await batch.commit();
                      if (!context.mounted) return;
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SiparisTakipSayfasi()));
                    },
                    child: Text('Siparişi Onayla • ₺${toplam.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
            );

            if (isMobile) return Column(children: [Expanded(child: list), summary]);
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: list), Expanded(flex: 2, child: Padding(padding: const EdgeInsets.fromLTRB(0, 24, 24, 24), child: summary))]);
          });
        },
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: GoogleFonts.poppins(fontSize: isTotal? 14 : 12, fontWeight: isTotal? FontWeight.w800 : FontWeight.w500, color: isDiscount? const Color(0xFFDC143C) : Colors.black87)),
        Text('${isDiscount? '-' : ''}₺${value.abs().toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: isTotal? 16 : 12, fontWeight: isTotal? FontWeight.w800 : FontWeight.w600, color: isDiscount? const Color(0xFFDC143C) : Colors.black)),
      ]),
    );
  }
}