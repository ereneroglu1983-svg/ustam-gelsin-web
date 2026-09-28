import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';

// lib/features/hug_market/widgets/reklam_board_slider.dart
// HUG MARKET ana sayfa sag taraf - 5sn arayla donen dinamik reklam alani
// Firestore: reklam_board collection (aktif=true, orderBy sira)

class ReklamBoardSlider extends StatefulWidget {
  const ReklamBoardSlider({super.key});
  @override
  State<ReklamBoardSlider> createState() => _ReklamBoardSliderState();
}

class _ReklamBoardSliderState extends State<ReklamBoardSlider> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _current = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay(int length) {
    _timer?.cancel();
    if (length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || length == 0) return;
      final next = (_current + 1) % length;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reklam_board').where('aktif', isEqualTo: true).orderBy('sira').snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return AspectRatio(aspectRatio: 16/9, child: Container(decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)), child: const Center(child: CircularProgressIndicator())));
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: HugMarketTheme.border)),
              child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset('assets/hug_market/hugmarket.png', fit: BoxFit.contain)),
            ),
          );
        }

        final docs = snap.data!.docs;
        if (_timer == null || _timer!.isActive == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay(docs.length));
        }

        return AspectRatio(
          aspectRatio: 16/9,
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _current = i),
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final d = docs[i].data() as Map<String, dynamic>;
                  final img = d['imageUrl']?? 'https://cdn.hemenustamgelsin.com/${d['imagePath']}';
                  final link = d['link'] as String?;

                  return GestureDetector(
                    onTap: () {
                      if (link!= null && link.isNotEmpty) {
                        FirebaseFirestore.instance.collection('reklam_board').doc(docs[i].id).update({'tiklama': FieldValue.increment(1)});
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: img,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (_, __) => Container(color: Colors.grey[200], child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
                        errorWidget: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, size: 40)),
                      ),
                    ),
                  );
                },
              ),
              if (docs.length > 1)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(docs.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _current == index? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _current == index? HugMarketTheme.primary : Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2)],
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}