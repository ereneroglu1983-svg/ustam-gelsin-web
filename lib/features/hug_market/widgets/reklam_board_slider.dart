import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';

class ReklamBoardSlider extends StatefulWidget {
  const ReklamBoardSlider({super.key});

  @override
  State<ReklamBoardSlider> createState() => _ReklamBoardSliderState();
}

class _ReklamBoardSliderState extends State<ReklamBoardSlider>
    with SingleTickerProviderStateMixin {
  List<String> _urls = [];
  int _currentIndex = 0;
  Timer? _timer;
  bool _yukleniyor = true;

  late AnimationController _fadeController;

  String _fixR2Url(String path) {
    path = path.trim();
    if (path.isEmpty) return '';
    const cdnBase = 'https://cdn.hemenustamgelsin.com';
    const oldR2 = 'https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev';

    path = path.replaceAll(oldR2, cdnBase);
    path = path.replaceAll('$cdnBase/ustam-gelsin-medya/', '$cdnBase/');

    if (path.startsWith('http')) return path;

    path = path.replaceAll(RegExp(r'^/*ustam-gelsin-medya/+'), '');
    path = path.replaceAll(RegExp(r'^/+'), '');

    return '$cdnBase/$path';
  }

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: 1.0, // başlangıçta tamamen görünür
    );

    _verileriGetir();
  }

  Future<void> _verileriGetir() async {
    try {
      final snap = await FirebaseFirestore.instance.collection('reklam_board').get();

      var filtered = snap.docs.where((d) {
        final data = d.data() as Map<String, dynamic>;
        final aktif = (data['aktif'] == true) || (data['isActive'] == true);
        final hasImage = ((data['imageUrl'] ?? '').toString().trim().isNotEmpty) ||
            ((data['imagePath'] ?? '').toString().trim().isNotEmpty);
        return aktif && hasImage;
      }).toList();

      filtered.sort((a, b) {
        final sa = (a.data() as Map)['sira'] is int ? (a.data() as Map)['sira'] as int : 9999;
        final sb = (b.data() as Map)['sira'] is int ? (b.data() as Map)['sira'] as int : 9999;
        return sa.compareTo(sb);
      });

      final urls = filtered.map((d) {
        final data = d.data() as Map<String, dynamic>;
        String img = (data['imageUrl'] ?? '').toString().trim();
        if (img.isNotEmpty) {
          img = _fixR2Url(img);
        } else {
          img = _fixR2Url((data['imagePath'] ?? '').toString());
        }
        return img;
      }).where((u) => u.isNotEmpty).toList();

      if (mounted) {
        setState(() {
          _urls = urls;
          _yukleniyor = false;
        });
        if (_urls.isNotEmpty) _baslatSlider();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _yukleniyor = false;
          _urls = [];
        });
      }
    }
  }

  void _baslatSlider() {
    _timer?.cancel();
    if (_urls.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted || _urls.isEmpty) return;
      _gecisYap();
    });
  }

  Future<void> _gecisYap() async {
    // 1. Yavaşça söndür (1 → 0)
    await _fadeController.animateTo(0.0, curve: Curves.easeInOut);

    if (!mounted) return;

    // 2. Index değiştir
    setState(() {
      _currentIndex = (_currentIndex + 1) % _urls.length;
    });

    // 3. Yavaşça göster (0 → 1)
    await _fadeController.animateTo(1.0, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_yukleniyor) return _skeleton();
    if (_urls.isEmpty) return _fallback();

    final w = MediaQuery.of(context).size.width;
    final h = w < 600 ? 260.0 : w < 1100 ? 320.0 : 380.0;

    return Container(
      width: double.infinity,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Opacity ile yumuşak geçiş
          AnimatedBuilder(
            animation: _fadeController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeController.value,
                child: child,
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Blur arka plan
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Image.network(
                    _urls[_currentIndex],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (c, e, s) =>
                        Container(color: Colors.grey.shade100),
                  ),
                ),
                // Karartma
                Container(color: Colors.black.withOpacity(0.2)),
                // Ortadaki net ana görsel
                Center(
                  child: Image.network(
                    _urls[_currentIndex],
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) =>
                    const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Indicator noktaları
          if (_urls.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _urls.length,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == i ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? HugMarketTheme.primary
                          : Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _skeleton() {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFFDC143C),
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        'assets/hug_market/hugmarket.png',
        fit: BoxFit.contain,
      ),
    );
  }
}