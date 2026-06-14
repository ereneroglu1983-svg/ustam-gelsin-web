// lib/features/home/widgets/ilan_akisi_slider.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // ScrollDirection için gerekli
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_auth_page.dart';

class IlanAkisiSlider extends StatefulWidget {
  final double ustaLat;
  final double ustaLng;

  const IlanAkisiSlider({super.key, required this.ustaLat, required this.ustaLng});

  @override
  State<IlanAkisiSlider> createState() => _IlanAkisiSliderState();
}

class _IlanAkisiSliderState extends State<IlanAkisiSlider> with WidgetsBindingObserver {
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_scrollController.hasClients) {
        // Kullanıcı sürükleme yapmıyorsa akıt
        if (_scrollController.position.userScrollDirection == ScrollDirection.idle) {
          double maxScroll = _scrollController.position.maxScrollExtent;
          double currentScroll = _scrollController.position.pixels;
          double delta = 1.0; // HizmetlerSlider ile aynı akış hızı

          if (currentScroll >= maxScroll) {
            _scrollController.jumpTo(0);
          } else {
            _scrollController.jumpTo(currentScroll + delta);
          }
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startAutoScroll();
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  double _mesafeHesapla(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<String> _getMaskeliIsim(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        String ad = userDoc.get('firstName') ?? "";
        String soyad = userDoc.get('lastName') ?? "";
        if (ad.isEmpty) return "MÜŞTERİ";
        String soyadHarf = soyad.isNotEmpty ? soyad[0].toUpperCase() : "";
        return "${ad[0].toUpperCase()}${ad.substring(1).toLowerCase()} $soyadHarf.";
      }
    } catch (e) { return "MÜŞTERİ"; }
    return "MÜŞTERİ";
  }

  Future<String> _formatKonumMetni(String raw) async {
    final parts = raw.split('/').map((e) => e.trim()).toList();
    if (parts.length >= 2 && (RegExp(r'^\d+$').hasMatch(parts[0]))) {
      final ilIsim = await LocationService.getSehirIsim(parts[0]);
      final ilceIsim = await LocationService.getIlceIsim(parts[1]);
      return "$ilIsim / $ilceIsim";
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            _timer?.cancel();
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) _startAutoScroll();
            });
          }
          return false;
        },
        child: StreamBuilder<List<IlanModel>>(
          stream: AdService().getAktifIlanlar(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            List<IlanModel> ilanlar = snapshot.data!;
            ilanlar.sort((a, b) => _mesafeHesapla(widget.ustaLat, widget.ustaLng, a.latitude, a.longitude)
                .compareTo(_mesafeHesapla(widget.ustaLat, widget.ustaLng, b.latitude, b.longitude)));

            return ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ilanlar.length,
              itemBuilder: (context, index) => _ilanKarti(context, ilanlar[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _ilanKarti(BuildContext context, IlanModel ilan) {
    return GestureDetector(
      onTap: () {
        _timer?.cancel();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaAuthPage(role: "usta")))
            .then((_) => _startAutoScroll());
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _getMaskeliIsim(ilan.userId),
                      builder: (ctx, snap) => Text(
                        snap.data ?? "...",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FutureBuilder<String>(
                    future: _formatKonumMetni(ilan.konumMetin),
                    builder: (ctx, snap) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.red),
                        const SizedBox(width: 2),
                        Text(
                          snap.data ?? "...",
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(ilan.kategori, style: const TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Wrap(
                spacing: 4, runSpacing: 4,
                children: ilan.teknikDetaylar.entries.take(4).map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text("${e.key.replaceAll('_', ' ')}: ${e.value}", style: const TextStyle(fontSize: 10, color: Colors.black54)),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}