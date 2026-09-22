import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:ui';
import 'package:ustam_gelsin/features/home/screens/insaat_rehberi.dart'; // DİREKT SAYFAYI IMPORT ETTİK

class InsaatRehberiSlider extends StatefulWidget {
  const InsaatRehberiSlider({super.key});

  @override
  State<InsaatRehberiSlider> createState() => _InsaatRehberiSliderState();
}

class _InsaatRehberiSliderState extends State<InsaatRehberiSlider> {
  List<Map<String, dynamic>> _karisikListe = [];
  int _currentIndex = 0;
  Timer? _timer;
  bool _yukleniyor = true;

  String _fixR2Url(String path) {
    path = path.trim();
    if (path.isEmpty) return path;
    const cdnBase = 'https://cdn.hemenustamgelsin.com';
    const oldR2 = 'https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev';
    path = path.replaceAll(oldR2, cdnBase);
    path = path.replaceAll('$cdnBase/ustam-gelsin-medya/', '$cdnBase/');
    path = path.replaceAll('/ustam-gelsin-medya/', '/');
    path = path.replaceAll('ustam-gelsin-medya/', '');
    if (path.startsWith('http')) return path;
    if (path.startsWith('/')) return '$cdnBase$path';
    return '$cdnBase/$path';
  }

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  Future<void> _verileriGetir() async {
    try {
      final rehberSnap = await FirebaseFirestore.instance.collection('icerikler').get();
      final ustaSnap = await FirebaseFirestore.instance.collection('karisik_slider').get();
      List<QueryDocumentSnapshot> rehberDocs = List.from(rehberSnap.docs);
      List<QueryDocumentSnapshot> ustaDocs = List.from(ustaSnap.docs);
      int tarihSirala(QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
        final da = a.data() as Map<String, dynamic>;
        final db = b.data() as Map<String, dynamic>;
        final ta = da['tarih'] is Timestamp? (da['tarih'] as Timestamp).millisecondsSinceEpoch : 0;
        final tb = db['tarih'] is Timestamp? (db['tarih'] as Timestamp).millisecondsSinceEpoch : 0;
        return tb.compareTo(ta);
      }
      rehberDocs.sort(tarihSirala);
      ustaDocs.sort(tarihSirala);
      final rehberler = rehberDocs.map((d) => {'tip': 'rehber', 'doc': d}).toList();
      final ustalar = ustaDocs.map((d) => {'tip': 'usta', 'doc': d}).toList();
      List<Map<String, dynamic>> karisik = [];
      int r = 0, u = 0;
      bool siraRehber = true;
      while (r < rehberler.length || u < ustalar.length) {
        if (siraRehber && r < rehberler.length) { karisik.add(rehberler[r++]); }
        else if (!siraRehber && u < ustalar.length) { karisik.add(ustalar[u++]); }
        else { if (r < rehberler.length) karisik.add(rehberler[r++]); if (u < ustalar.length) karisik.add(ustalar[u++]); }
        siraRehber =!siraRehber;
      }
      if (mounted) {
        setState(() { _karisikListe = karisik; _yukleniyor = false; });
        if (_karisikListe.isNotEmpty) _baslatSlider();
      }
    } catch (e) {
      if (mounted) { setState(() { _yukleniyor = false; _karisikListe = []; }); }
    }
  }

  void _baslatSlider() {
    _timer?.cancel();
    if (_karisikListe.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && _karisikListe.isNotEmpty) {
        setState(() => _currentIndex = (_currentIndex + 1) % _karisikListe.length);
      }
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (_yukleniyor == false && _karisikListe.isEmpty) { return const SizedBox.shrink(); }
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: isMobile? 16 : 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        isMobile? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("İNŞAAT REHBERİ", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFFDC143C))),
          const SizedBox(height: 4),
          Text("İnşaat, Tadilat, Dekorasyon ve Yenilenebilir Enerji Rehberleri", maxLines: 2, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        ]) : Row(children: [
          Text("İNŞAAT REHBERİ", style: GoogleFonts.poppins(fontSize: isTablet? 15 : 16, fontWeight: FontWeight.w700, color: const Color(0xFFDC143C))),
          const SizedBox(width: 8),
          Expanded(child: Text("İnşaat, Tadilat, Dekorasyon ve Yenilenebilir Enerji Rehberleri", maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: isTablet? 12 : 14, fontWeight: FontWeight.w500))),
        ]),
        const SizedBox(height: 12),
        // KESIN COZUM - Navigator.push direkt sayfaya gidiyor, GoRouter'a bagli degil
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const InsaatRehberiScreen()),
            );
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: _buildContent(isMobile, isTablet),
          ),
        )
      ]),
    );
  }

  Widget _buildContent(bool isMobile, bool isTablet) {
    if (_yukleniyor) {
      return Container(
        key: const ValueKey('loading'),
        width: double.infinity,
        height: isMobile? 260 : 380,
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFDC143C))),
      );
    }
    if (_karisikListe.isEmpty) { return const SizedBox.shrink(key: ValueKey('empty')); }
    final current = _karisikListe[_currentIndex];
    final doc = current['doc'] as QueryDocumentSnapshot;
    final data = doc.data() as Map<String, dynamic>;
    final String tip = current['tip'];
    final bool isUsta = tip == 'usta';
    final String imagePath = _fixR2Url((data['imagePath']?? data['image']?? data['resim']?? '').toString());
    final String baslik = (data['baslik']?? data['adSoyad']?? '').toString();
    return Container(
      key: ValueKey(_currentIndex),
      width: double.infinity,
      height: isMobile? 260 : isTablet? 320 : 380,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(fit: StackFit.expand, children: [
          if (isUsta) Stack(fit: StackFit.expand, children: [
            ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), child: Image.network(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]))),
            Container(color: Colors.black.withOpacity(0.2)),
            Center(child: Image.network(imagePath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]))),
          ]) else Container(color: Colors.white, child: Image.network(imagePath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]))),
          Positioned(left: 0, right: 0, bottom: 0, child: Container(padding: EdgeInsets.fromLTRB(isMobile? 14 : 20, 60, isMobile? 14 : 20, isMobile? 14 : 20),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.85), Colors.black.withOpacity(0.3), Colors.transparent])),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: isUsta? const Color(0xFF00C853) : const Color(0xFFDC143C), borderRadius: BorderRadius.circular(6)), child: Text(isUsta? "YENİ USTA" : "YENİ", style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                const SizedBox(height: 10),
                Text(baslik, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white, fontSize: isMobile? 16 : 22)),
                const SizedBox(height: 10),
                Row(children: [const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18), const SizedBox(width: 6), Text("Tüm rehberleri gör", style: GoogleFonts.poppins(color: Colors.white, fontSize: 13))]),
              ]))),
        ]),
      ),
    );
  }
}