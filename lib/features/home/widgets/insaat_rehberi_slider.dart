import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:ui';

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
  String? _hata;

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
      final rehberSnap = await FirebaseFirestore.instance.collection('icerikler').orderBy('tarih', descending: true).limit(50).get();
      final ustaSnap = await FirebaseFirestore.instance.collection('karisik_slider').orderBy('tarih', descending: true).limit(100).get();

      final rehberler = rehberSnap.docs.map((d) => {'tip': 'rehber', 'doc': d}).toList();
      final ustalar = ustaSnap.docs.map((d) => {'tip': 'usta', 'doc': d}).toList();

      List<Map<String, dynamic>> karisik = [];
      int r = 0, u = 0;
      bool siraRehber = true;
      while (r < rehberler.length || u < ustalar.length) {
        if (siraRehber && r < rehberler.length) {
          karisik.add(rehberler[r++]);
        } else if (!siraRehber && u < ustalar.length) {
          karisik.add(ustalar[u++]);
        } else {
          if (r < rehberler.length) karisik.add(rehberler[r++]);
          if (u < ustalar.length) karisik.add(ustalar[u++]);
        }
        siraRehber =!siraRehber;
      }

      if (mounted) {
        setState(() {
          _karisikListe = karisik;
          _yukleniyor = false;
          if (karisik.isEmpty) {
            _hata = "Gösterilecek içerik bulunamadı.";
          }
        });
        if (_karisikListe.isNotEmpty) _baslatSlider();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _yukleniyor = false;
          _hata = "Veri çekilemedi: $e";
        });
      }
      print("KARIŞIK SLIDER HATASI: $e");
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: isMobile? 16 : 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        isMobile
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("İNŞAAT REHBERİ",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFFDC143C), letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text("İnşaat, Tadilat, Dekorasyon ve Yenilenebilir Enerji Rehberleri",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87, height: 1.2)),
          ],
        )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("İNŞAAT REHBERİ",
                style: GoogleFonts.poppins(
                    fontSize: isTablet? 15 : 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFDC143C),
                    letterSpacing: 0.5)),
            const SizedBox(width: 8),
            Expanded(
              child: Text("İnşaat, Tadilat, Dekorasyon ve Yenilenebilir Enerji Rehberleri",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: isTablet? 12 : 14, fontWeight: FontWeight.w500, color: Colors.black87)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            // TEK GİDECEĞİ YER: İNŞAAT REHBERİ SAYFASI
            context.go('/rehber');
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
        decoration: BoxDecoration(
            color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFDC143C)),
          const SizedBox(height: 12),
          Text("Rehber içerikleri yükleniyor...", style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14)),
        ]),
      );
    }

    if (_hata!= null) {
      return Container(
        key: const ValueKey('error'),
        width: double.infinity,
        height: isMobile? 260 : 380,
        decoration: BoxDecoration(
            color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          Text(_hata!, style: GoogleFonts.poppins(color: Colors.grey.shade600)),
        ]),
      );
    }

    final current = _karisikListe[_currentIndex];
    final doc = current['doc'] as QueryDocumentSnapshot;
    final String tip = current['tip'];
    final bool isUsta = tip == 'usta';
    final String imagePath = _fixR2Url(doc.get('imagePath').toString());
    final String baslik = doc.get('baslik')?? "";

    return Container(
      key: ValueKey(_currentIndex),
      width: double.infinity,
      height: isMobile? 260 : isTablet? 320 : 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isUsta)
              Stack(
                fit: StackFit.expand,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Image.network(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200])),
                  ),
                  Container(color: Colors.black.withOpacity(0.2)),
                  Center(
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                color: Colors.white,
                child: Image.network(
                  imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                        color: Colors.grey.shade100,
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFDC143C))));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text("Görsel yüklenemedi", style: GoogleFonts.poppins(color: Colors.grey.shade600)),
                      ]),
                    );
                  },
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(isMobile? 14 : 20, 60, isMobile? 14 : 20, isMobile? 14 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.85), Colors.black.withOpacity(0.3), Colors.transparent],
                      stops: const [0.0, 0.6, 1.0]),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: isUsta? const Color(0xFF00C853) : const Color(0xFFDC143C), borderRadius: BorderRadius.circular(6)),
                    child: Text(isUsta? "YENİ USTA" : "YENİ",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 10),
                  Text(baslik,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: isMobile? 16 : 22,
                          height: 1.3,
                          shadows: [Shadow(color: Colors.black.withOpacity(0.6), blurRadius: 10)])),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text("Tüm rehberleri gör",
                        style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.95), fontSize: 13, fontWeight: FontWeight.w500)),
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}