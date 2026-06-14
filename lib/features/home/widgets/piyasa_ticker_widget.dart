import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/services/analytics_service.dart';

class PiyasaTickerWidget extends StatelessWidget {
  final AnalyticsService _analyticsService = AnalyticsService();

  PiyasaTickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      color: Colors.black87,
      child: StreamBuilder<QuerySnapshot>(
        // Şehir bağımsız, GENEL trendleri çeken metod kullanıldı
        stream: _analyticsService.getGenelTrendler(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Piyasa verileri yükleniyor...", style: TextStyle(color: Colors.white70)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Henüz piyasa verisi oluşmadı.", style: TextStyle(color: Colors.white70)),
            );
          }

          // Verileri metne dönüştür
          String tickerText = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            String kategori = doc.id.replaceAll('_', ' ');
            int count = data['requestCount'] ?? 0;
            return " 📈 $kategori: $count talep | ";
          }).join(" ");

          return Marquee(
            text: tickerText,
            style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14
            ),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            velocity: 40.0,
            blankSpace: 50.0,
          );
        },
      ),
    );
  }
}