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
  final PageController _controller = PageController();
  Timer? _timer;
  int _current = 0;
  late Future<List<QueryDocumentSnapshot>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchAds();
  }

  Future<List<QueryDocumentSnapshot>> _fetchAds() async {
    final snap = await FirebaseFirestore.instance
        .collection('reklam_board')
        .where('aktif', isEqualTo: true)
        .orderBy('sira')
        .limit(10)
        .get();
    return snap.docs;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay(int count) {
    _timer?.cancel();
    if (count <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted ||!_controller.hasClients) return;
      final next = (_current + 1) % count;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) return _loading();
        if (!snap.hasData || snap.data!.isEmpty) return _fallback();
        return _buildSlider(snap.data!);
      },
    );
  }

  Widget _buildSlider(List<QueryDocumentSnapshot> docs) {
    final validDocs = docs.where((d) {
      final data = d.data() as Map<String, dynamic>;
      final url = (data['imageUrl']?? '').toString().trim();
      final path = (data['imagePath']?? '').toString().trim();
      return url.isNotEmpty || path.isNotEmpty;
    }).toList();

    if (validDocs.isEmpty) return _fallback();

    if (_timer == null ||!_timer!.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay(validDocs.length));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1100;
    final h = isMobile? 260.0 : isTablet? 320.0 : 380.0;

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
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _current = i),
              itemCount: validDocs.length,
              itemBuilder: (ctx, i) {
                var data = validDocs[i].data() as Map<String, dynamic>;
                String img = (data['imageUrl']?? '').toString().trim();
                if (img.isEmpty) {
                  img = 'https://cdn.hemenustamgelsin.com/${data['imagePath']}';
                }
                // AYNI TEKNIK - BLURLU ARKA PLAN
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. Altta blur cover - boşlukları doldurur
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
                    // 3. Üstte ortada contain - resim asla kesilmez
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: img,
                        fit: BoxFit.contain,
                        memCacheWidth: 1920,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ],
                );
              },
            ),
            if (validDocs.length > 1)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    validDocs.length,
                        (idx) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _current == idx? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _current == idx? HugMarketTheme.primary : Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1100;
    final h = isMobile? 260.0 : isTablet? 320.0 : 380.0;
    return Container(
      width: double.infinity,
      height: h,
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFDC143C))),
    );
  }

  Widget _fallback() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1100;
    final h = isMobile? 260.0 : isTablet? 320.0 : 380.0;
    return Container(
      width: double.infinity,
      height: h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset('assets/hug_market/hugmarket.png', fit: BoxFit.contain),
      ),
    );
  }
}