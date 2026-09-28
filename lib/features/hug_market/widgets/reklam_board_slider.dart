import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';

class ReklamBoardSlider extends StatefulWidget {
  const ReklamBoardSlider({super.key});
  @override State<ReklamBoardSlider> createState() => _ReklamBoardSliderState();
}

class _ReklamBoardSliderState extends State<ReklamBoardSlider> {
  List<QueryDocumentSnapshot> _liste = [];
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
  void initState() { super.initState(); _verileriGetir(); }

  Future<void> _verileriGetir() async {
    try {
      // DİKKAT: orderBy YOK - client'da sıralayacağız, web patlamasın diye
      final snap = await FirebaseFirestore.instance.collection('reklam_board').get();

      var filtered = snap.docs.where((d) {
        final data = d.data() as Map<String, dynamic>;
        final isAktif = (data['aktif'] == true) || (data['isActive'] == true);
        final url = (data['imageUrl'] ?? '').toString().trim();
        final path = (data['imagePath'] ?? '').toString().trim();
        return isAktif && (url.isNotEmpty || path.isNotEmpty);
      }).toList();

      // Client-side sira'ya göre sırala
      filtered.sort((a,b){
        final da = a.data() as Map<String,dynamic>;
        final db = b.data() as Map<String,dynamic>;
        final sa = (da['sira'] is int) ? da['sira'] as int : 9999;
        final sb = (db['sira'] is int) ? db['sira'] as int : 9999;
        return sa.compareTo(sb);
      });

      if(mounted){
        setState(() { _liste = filtered; _yukleniyor = false; });
        if(_liste.isNotEmpty) _baslatSlider();
      }
    } catch (e) {
      debugPrint('REKLAM BOARD HATA WEB: $e');
      if(mounted) setState(() { _yukleniyor = false; _liste = []; });
    }
  }

  void _baslatSlider() {
    _timer?.cancel();
    if(_liste.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if(mounted && _liste.isNotEmpty){
        setState(() => _currentIndex = (_currentIndex + 1) % _liste.length);
      }
    });
  }

  @override void dispose(){ _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if(!_yukleniyor && _liste.isEmpty) return _fallback();
    final w = MediaQuery.of(context).size.width;
    final h = w < 600 ? 260.0 : w < 1100 ? 320.0 : 380.0;
    return Container(
      width: double.infinity, height: h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0,4))]),
      child: ClipRRect(borderRadius: BorderRadius.circular(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (c,a) => FadeTransition(opacity: a, child: c),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent(){
    if(_yukleniyor){
      return Container(key: const ValueKey('loading'), color: Colors.grey.shade100, child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFDC143C))));
    }
    if(_liste.isEmpty) return _fallback();
    final data = _liste[_currentIndex].data() as Map<String,dynamic>;
    String img = (data['imageUrl'] ?? '').toString().trim();
    if(img.isEmpty) img = _fixR2Url((data['imagePath'] ?? '').toString());
    return Container(
      key: ValueKey(_currentIndex),
      child: Stack(fit: StackFit.expand, children: [
        ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), child: CachedNetworkImage(imageUrl: img, fit: BoxFit.cover)),
        Container(color: Colors.black.withOpacity(0.2)),
        Center(child: CachedNetworkImage(imageUrl: img, fit: BoxFit.contain, memCacheWidth: 1920)),
        if(_liste.length > 1) Positioned(bottom: 10, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_liste.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 3), width: _currentIndex==i?18:6, height: 6, decoration: BoxDecoration(color: _currentIndex==i?HugMarketTheme.primary:Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(8)))))),
      ]),
    );
  }

  Widget _fallback(){
    final w = MediaQuery.of(context).size.width;
    final h = w < 600 ? 260.0 : w < 1100 ? 320.0 : 380.0;
    return Container(width: double.infinity, height: h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset('assets/hug_market/hugmarket.png', fit: BoxFit.contain)));
  }
}