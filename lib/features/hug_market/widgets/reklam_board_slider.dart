import 'dart:async';
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
      if (!mounted ||!_controller.hasClients) return;
      final next = (_current + 1) % length;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reklam_board').where('isActive', isEqualTo: true).snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _loadingBox();
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('reklam_board').where('aktif', isEqualTo: true).snapshots(),
            builder: (context, snap2) {
              if (!snap2.hasData || snap2.data!.docs.isEmpty) {
                return _fallbackBox();
              }
              return _buildSlider(snap2.data!.docs);
            },
          );
        }
        var docs = snap.data!.docs.toList();
        docs.sort((a, b) {
          var da = a.data() as Map<String, dynamic>;
          var db = b.data() as Map<String, dynamic>;
          int oa = (da['order']?? da['sira']?? 0) as int;
          int ob = (db['order']?? db['sira']?? 0) as int;
          return oa.compareTo(ob);
        });
        return _buildSlider(docs);
      },
    );
  }

  Widget _loadingBox() {
    return AspectRatio(
      aspectRatio: 16 / 5, // 16/9 değil 16/5 yap - board daha yatay olmalı
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }

  Widget _fallbackBox() {
    return AspectRatio(
      aspectRatio: 16 / 5,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: HugMarketTheme.border)),
        child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset('assets/hug_market/hugmarket.png', fit: BoxFit.contain)),
      ),
    );
  }

  Widget _buildSlider(List<QueryDocumentSnapshot> docs) {
    if (_timer == null ||!_timer!.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay(docs.length));
    }

    // FIX: LayoutBuilder ile genişliği al, yüksekliği sabitle - taşmayı engelle
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        // Mobilde 16/6, desktop 16/5 - taşma olmasın
        final h = w * 0.32; // %32 yükseklik - board için ideal

        return SizedBox(
          width: w,
          height: h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i].data() as Map<String, dynamic>;
                    var img = d['imageUrl']?? d['image']?? '';
                    if (img.isEmpty && d['imagePath']!= null) {
                      img = 'https://cdn.hemenustamgelsin.com/${d['imagePath']}';
                    }
                    img = img.toString().trim();
                    final link = d['link'] as String?;

                    if (img.isEmpty) {
                      return Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, size: 40));
                    }

                    return GestureDetector(
                      onTap: () {
                        if (link!= null && link.isNotEmpty) {
                          FirebaseFirestore.instance.collection('reklam_board').doc(docs[i].id).update({'tiklama': FieldValue.increment(1)});
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: img,
                        // FIX: En önemli kısım - resmi küçültmeden yükleme
                        memCacheWidth: 1280, // 1280px max - 5MB resim 200kb olur
                        memCacheHeight: 410,
                        maxWidthDiskCache: 1920,
                        maxHeightDiskCache: 1080,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 200),
                        placeholder: (_, __) => Container(color: Colors.grey[200], child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.broken_image, size: 32, color: Colors.grey),
                              const SizedBox(height: 4),
                              Text('Resim yüklenemedi\n$img', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
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
                            color: _current == index? HugMarketTheme.primary : Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2)],
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}