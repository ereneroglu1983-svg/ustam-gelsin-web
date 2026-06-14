// lib/features/home/widgets/hizmetler_slider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ustam_gelsin/core/constants/meslekler_data.dart';
import 'package:ustam_gelsin/features/home/screens/meslek_detay_view.dart';

class HizmetlerSlider extends StatefulWidget {
  const HizmetlerSlider({super.key});

  @override
  State<HizmetlerSlider> createState() => _HizmetlerSliderState();
}

class _HizmetlerSliderState extends State<HizmetlerSlider> with WidgetsBindingObserver {
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    _startAutoScroll();
  }

  // Timer'ı güvenli başlatma: Önce eskisini öldür, sonra yenisini kur
  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = 1.5;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(currentScroll + delta);
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            _timer?.cancel();
            // Kullanıcı kaydırmayı bıraktıktan sonra tekrar başlat
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) _startAutoScroll();
            });
          }
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: MesleklerData.hizmetlerDetayli.length,
          itemBuilder: (context, index) {
            final item = MesleklerData.hizmetlerDetayli[index];

            return InkWell(
              onTap: () {
                _timer?.cancel(); // Tıklanınca timer'ı durdur
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeslekDetayView(meslek: item),
                  ),
                ).then((_) {
                  // Detay sayfasından dönünce tekrar başlat
                  if (mounted) _startAutoScroll();
                });
              },
              child: Container(
                width: 130,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          item.resimYolu,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.isim,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        Text(
                            " ${item.puan} (${item.yorumSayisi})",
                            style: const TextStyle(fontSize: 10, color: Colors.grey)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}