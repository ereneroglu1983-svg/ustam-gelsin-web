import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/features/home/screens/insaat_rehberi.dart';
import 'dart:async';

class InsaatRehberiSlider extends StatefulWidget {
  const InsaatRehberiSlider({super.key});

  @override
  State<InsaatRehberiSlider> createState() => _InsaatRehberiSliderState();
}

class _InsaatRehberiSliderState extends State<InsaatRehberiSlider> {
  List<QueryDocumentSnapshot> _sliderRehberler = [];
  int _currentIndex = 0;
  Timer? _timer;
  bool _yukleniyor = true;
  String? _hata;

  String _fixR2Url(String url) {
    if (url.contains('pub-27a42c3abc764860b54d06b5cf79567f.r2.dev')) {
      return url.replaceAll(
        'https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev',
        'https://cdn.hemenustamgelsin.com/ustam-gelsin-medya',
      );
    }
    return url.trim();
  }

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  Future<void> _verileriGetir() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('icerikler')
          .limit(3)
          .get();

      if (mounted) {
        setState(() {
          _sliderRehberler = snapshot.docs;
          _yukleniyor = false;
          if (snapshot.docs.isEmpty) {
            _hata = "Gösterilecek rehber bulunamadı.";
          }
        });
        if (_sliderRehberler.isNotEmpty) _baslatSlider();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _yukleniyor = false;
          _hata = "Veri çekilemedi: $e";
        });
      }
      print("İNŞAAT REHBERİ VERİ HATASI: $e");
    }
  }

  void _baslatSlider() {
    _timer?.cancel();
    if (_sliderRehberler.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && _sliderRehberler.isNotEmpty) {
        setState(() => _currentIndex = (_currentIndex + 1) % _sliderRehberler.length);
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // DEĞİŞEN TEK YER BURASI
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("İNŞAAT REHBERİ",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFDC143C),
                    letterSpacing: 0.5)),
            const SizedBox(width: 8),
            Text("İnşaat, Tadilat, Dekorasyon ve Yenilenebilir Enerji Rehberleri",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const InsaatRehberiScreen())),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: _buildContent(),
          ),
        )
      ]),
    );
  }

  Widget _buildContent() {
    if (_yukleniyor) {
      return Container(
        key: const ValueKey('loading'),
        width: double.infinity,
        height: 380,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFDC143C)),
            const SizedBox(height: 12),
            Text("Rehber içerikleri yükleniyor...",
                style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14)),
          ],
        ),
      );
    }

    if (_hata!= null) {
      return Container(
        key: const ValueKey('error'),
        width: double.infinity,
        height: 380,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(_hata!, style: GoogleFonts.poppins(color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    return Container(
      key: ValueKey(_currentIndex),
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _fixR2Url(_sliderRehberler[_currentIndex].get('imagePath').toString()),
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade100,
                  child: const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Color(0xFFDC143C))),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                final url = _sliderRehberler[_currentIndex].get('imagePath');
                print("GÖRSEL YÜKLEME HATASI: $error URL: $url");
                return Container(
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text("Görsel yüklenemedi",
                          style: GoogleFonts.poppins(color: Colors.grey.shade600)),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC143C),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "YENİ",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _sliderRehberler[_currentIndex].get('baslik')?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "Tüm rehberleri gör",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}