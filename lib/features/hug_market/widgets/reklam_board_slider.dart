import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';

class ReklamBoardSlider extends StatefulWidget {
  const ReklamBoardSlider({super.key});
  @override State<ReklamBoardSlider> createState() => _ReklamBoardSliderState();
}

class _ReklamBoardSliderState extends State<ReklamBoardSlider> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _current = 0;
  List<QueryDocumentSnapshot> _validDocs = [];

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (_validDocs.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted ||!_controller.hasClients) return;
      final next = (_current + 1) % _validDocs.length;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reklam_board').snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) return _loading();
        if (!snap.hasData || snap.data!.docs.isEmpty) return _fallback();

        var allDocs = snap.data!.docs.where((d) {
          var data = d.data() as Map<String, dynamic>;
          bool active = data['isActive']?? data['aktif']?? true;
          if (!active) return false;
          String url = (data['imageUrl']?? '').toString().trim();
          if (url.isEmpty ||!url.startsWith('http')) return false;
          // SADECE BOZUK TRIPLE ID'LERİ FİLTRELE - CDN'İ ENGELLEME
          if (url.split('-').length > 6 && url.contains('reklam-')) {
            // reklam-1790-1790-1790 gibi 3 kere tekrar varsa at
            final parts = url.split('reklam-');
            if (parts.length > 3) return false;
          }
          return true;
        }).toList();

        if (allDocs.isEmpty) return _fallback();

        allDocs.sort((a,b){
          var da = a.data() as Map<String, dynamic>;
          var db = b.data() as Map<String, dynamic>;
          return (da['order']?? da['sira']?? 0).compareTo(db['order']?? db['sira']?? 0);
        });

        _validDocs = allDocs;
        if (_timer == null ||!_timer!.isActive) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay());
        }

        return LayoutBuilder(builder: (context, c){
          final w = c.maxWidth;
          final h = w * 0.32;
          return SizedBox(
            width: w, height: h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(children: [
                PageView.builder(
                    controller: _controller,
                    onPageChanged: (i) => setState(() => _current = i),
                    itemCount: _validDocs.length,
                    itemBuilder: (ctx,i){
                      var d = _validDocs[i].data() as Map<String, dynamic>;
                      String img = (d['imageUrl']?? '').toString().trim();
                      return CachedNetworkImage(
                        imageUrl: img,
                        memCacheWidth: 1280,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (_,__)=> Container(color: Colors.grey[200]),
                        errorWidget: (_,__,___)=> Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                      );
                    }
                ),
                if (_validDocs.length > 1) Positioned(bottom: 12, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_validDocs.length, (idx)=> AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 4), width: _current==idx?20:8, height:8, decoration: BoxDecoration(color: _current==idx?HugMarketTheme.primary:Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(8)))))),
              ]),
            ),
          );
        });
      },
    );
  }

  Widget _loading()=> AspectRatio(aspectRatio: 16/5, child: Container(decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)), child: const Center(child: CircularProgressIndicator(strokeWidth: 2))));
  Widget _fallback()=> AspectRatio(aspectRatio: 16/5, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: HugMarketTheme.border)), child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset('assets/hug_market/hugmarket.png', fit: BoxFit.contain))));
}