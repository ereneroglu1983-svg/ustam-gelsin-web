// DOSYA: lib/features/home/screens/home_page_ai.dart
import 'package:flutter/material.dart';
import 'package:ustam_gelsin/features/home/screens/ai_is_secimi.dart';

class HomePageAI extends StatefulWidget {
  const HomePageAI({super.key});

  @override
  State<HomePageAI> createState() => _HomePageAIState();
}

class _HomePageAIState extends State<HomePageAI> {
  final Color _bgColor = const Color(0xFFF5F5F7);
  final Color _textColor = const Color(0xFF1D1D1F);
  final Color _accentColor = const Color(0xFF0066CC);
  // İstediğin Kırmızı Renk:
  final Color _kirmiziButon = const Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
        title: Text("Ustam Gelsin AI", style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text("Ustam Gelsin AI ile tanışın.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: _textColor)),
                  const SizedBox(height: 20),
                  Text("Tadilat ve ustalık gerektiren işleriniz için en hızlı, en güvenilir ve yapay zeka destekli fiyatlandırma deneyimine hazır mısınız?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: _textColor.withOpacity(0.7), height: 1.6)),
                  const SizedBox(height: 30),
                  // Eklenen resim:
                  Image.asset(
                    'assets/images/ai_page.png',
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              child: SizedBox(
                width: double.infinity, height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kirmiziButon, // Kırmızı Buton
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AiIsSecimi()));
                  },
                  child: const Text("HEMEN BAŞLAYALIM",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), // Beyaz Yazı
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}