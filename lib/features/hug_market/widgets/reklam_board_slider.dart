import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';

// lib/features/hug_market/widgets/reklam_board_slider.dart
// FIX: isActive + order field uyumu + composite index sorunu çözüldü

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
      if (!mounted) return;
      if (!_controller.hasClients) return;
      final next = (_current + 1) % length;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    // FIX: where + orderBy composite index istemesin diye sadece isActive sorgula, sort client-side yap
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reklam_board').where('isActive', isEqualTo: true).snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return AspectRatio(aspectRatio: 16/9, child: Container(decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)), child: const Center(child: CircularProgressIndicator())));
        }

        if (!snap.hasData || snap.data!.docs.isEmpty) {
          // ESKİ KAYITLARDA 'aktif' field'ı olabilir - onu da dene
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('reklam_board').where('aktif', isEqualTo: true).snapshots(),
              builder: (context, snap2) {
                if (!snap2.hasData || snap2.data!.docs.isEmpty) {
                  return AspectRatio(
                    aspectRatio: 16/9,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: HugMarketTheme.border)),
                      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset('assets/hug_market/hugmarket.png', fit: BoxFit.contain)),
                    ),
                  );
                }
                // Eski field ile devam et
                return _buildSlider(snap2.data!.docs);
              }
          );
        }

        // Yeni field ile devam - client side sort
        var docs = snap.data!.docs.toList();
        docs.sort((a,b){
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

  Widget _buildSlider(List<QueryDocumentSnapshot> docs) {
    if (_timer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay(docs.length));
    } else if (_timer!.isActive == false) {
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
              final img = d['imageUrl']?? d['image']?? (d['imagePath']!= null? 'https://cdn.hemenustamgelsin.com/${d['imagePath']}' : '');
              final link = d['link'] as String?;

              if (img.isEmpty) return Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, size: 40));

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
  }
}