// lib/features/home/screens/nasil_calisir.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NasilCalisirPage extends StatelessWidget {
  const NasilCalisirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Nasıl Çalışır?", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Görsel Alanı
            Image.asset(
              'assets/images/nasil_calisir.png',
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),

            // Başlık
            Text(
              "NASIL ÇALIŞIR?",
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // İçerik Listesi
            _buildStep("1️⃣ İlanını Oluştur", "İhtiyacını birkaç adımda paylaş.\nKategori, detay ve görsellerini ekleyerek ilanını hızlıca yayınla."),
            _buildStep("2️⃣ AI Destekli Fiyat Tahmini", "Gelişmiş yapay zeka sistemi; iş detaylarını analiz ederek ortalama fiyat aralığını tahmin eder.\nBöylece teklifleri daha bilinçli değerlendirebilirsin."),
            _buildStep("3️⃣ Teklifleri Karşılaştır", "Doğrulanmış ustalardan gelen teklifleri incele.\nProfil, puan, belge ve kullanıcı yorumlarını karşılaştırarak en uygun ustayı seç."),
            _buildStep("4️⃣ Güvenle İletişime Geç", "Teklifini onayladığın usta ile doğrudan iletişime geç.\nSüreci uygulama üzerinden daha kontrollü ve güvenli şekilde yönet."),
            _buildStep("5️⃣ İşini Tamamla", "Anlaştığın usta işini tamamlasın, sen de deneyimini değerlendir.\nBöylece platformdaki hizmet kalitesi sürekli gelişsin."),

            const Divider(height: 40),

            // Son Not
            Text(
              "6️⃣ Güçlü Dijital Usta Ağı",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            const Text(
              "HEMEN USTAM GELSİN yalnızca bir ilan uygulaması değil; müşteri ile ustayı hızlı, şeffaf ve organize şekilde buluşturan yeni nesil dijital hizmet ağıdır.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black54)),
        ],
      ),
    );
  }
}