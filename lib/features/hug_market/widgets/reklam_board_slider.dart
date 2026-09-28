import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';

class ReklamBoardSlider extends StatefulWidget {
  const ReklamBoardSlider({super.key});
  @override
  State<ReklamBoardSlider> createState() => _ReklamBoardSliderState();
}

class _ReklamBoardSliderState extends State<ReklamBoardSlider> {
  List<QueryDocumentSnapshot> _liste = [];
  int _currentIndex = 0;
  Timer? _timer;
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  Future<void> _verileriGetir() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('reklam_board')
          .orderBy('sira')
          .get();

      final filtered = snap.docs.where((d) {
        final data = d.data() as Map<String, dynamic>;
        final isAktif = (data['aktif'] == true) || (data['isActive'] == true);
        final url = (data['imageUrl'] ?? '').toString().trim();
        final path = (data['imagePath'] ?? '').toString().trim();
        return isAktif && (url.isNotEmpty || path.isNotEmpty);
      }).toList();

      if (mounted) {
        setState(() {
          _liste = filtered;
          _yukleniyor = false;
        });
        if (_liste.isNotEmpty) _baslatSlider();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _yukleniyor = false;
          _liste = [];
        });
      }
    }
  }

  void _baslatSlider() {
    _timer?.cancel();
    if (_liste.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _liste.isNotEmpty) {
        setState(() => _currentIndex = (_currentIndex + 1) % _liste.length);
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
    if (_yukleniyor == false && _liste.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1100;
    final h = isMobile ? 260.0 : isTablet ? 320.0 : 380.0;

    return Container(
      width: double.infinity,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          child: _buildContent(isMobile, isTablet),
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile, bool isTablet) {
    if (_yukleniyor) {
      return Container(
        key: const ValueKey('loading'),
        width: double.infinity,
        height: isMobile ? 260 : 380,
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFDC143C))),
      );
    }
    if (_liste.isEmpty) {
      return const SizedBox.shrink(key: ValueKey('empty'));
    }

    final doc = _liste[_currentIndex];
    final data = doc.data() as Map<String, dynamic>;
    String img = (data['imageUrl'] ?? '').toString().trim();
    if (img.isEmpty) {
      img = 'https://cdn.hemenustamgelsin.com/${data['imagePath']}';
    }

    return Container(
      key: ValueKey(_currentIndex),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Blur arka plan
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: CachedNetworkImage(
              imageUrl: img,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // 2. Karartma
          Container(color: Colors.black.withOpacity(0.2)),
          // 3. Ortada contain
          Center(
            child: CachedNetworkImage(
              imageUrl: img,
              fit: BoxFit.contain,
              memCacheWidth: 1920,
              filterQuality: FilterQuality.high,
            ),
          ),
          // 4. Noktalar
          if (_liste.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _liste.length,
                      (idx) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == idx ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentIndex == idx ? HugMarketTheme.primary : Colors.white.withOpacity(0.7),
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
}