// lib/features/home/screens/biz_kimiz_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BizKimizPage extends StatelessWidget {
  const BizKimizPage({super.key});

  Future<Map<String, dynamic>> _loadData() async {
    final String response = await rootBundle.loadString('assets/data/biz_kimiz.json');
    return jsonDecode(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biz Kimiz", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("İçerik yüklenemedi."));
          }

          final data = snapshot.data!;
          final List icerikListesi = data['icerik'] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['baslik'] ?? "Biz Kimiz?", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(data['slogan'] ?? "", style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey)),
                const Divider(height: 40),
                // İçerik listesini döngü ile ekrana basıyoruz
                ...icerikListesi.map((item) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['baslik'] ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    const SizedBox(height: 5),
                    Text(item['metin'] ?? "", style: const TextStyle(fontSize: 15, height: 1.4)),
                    const SizedBox(height: 20),
                  ],
                )).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}