// lib/features/home/widgets/hizmetler_slider.dart

import 'package:flutter/material.dart';
import 'package:ustam_gelsin/core/constants/meslekler_data.dart';
import 'package:ustam_gelsin/features/home/screens/meslek_detay_view.dart';

class HizmetlerSlider extends StatefulWidget {
  const HizmetlerSlider({super.key});

  @override
  State<HizmetlerSlider> createState() => _HizmetlerSliderState();
}

class _HizmetlerSliderState extends State<HizmetlerSlider> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: MesleklerData.hizmetlerDetayli.length,
        itemBuilder: (context, index) {
          final item = MesleklerData.hizmetlerDetayli[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeslekDetayView(meslek: item),
                ),
              );
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
    );
  }
}