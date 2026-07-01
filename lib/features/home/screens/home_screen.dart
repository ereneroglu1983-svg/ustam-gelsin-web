// lib/features/home/screens/home_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ustam_gelsin/core/theme/app_theme.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_auth_page.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_auth_page.dart';
import 'package:ustam_gelsin/features/home/screens/home_page_ai.dart'; // YENİ AI SAYFASI
import 'package:ustam_gelsin/features/home/widgets/hizmetler_slider.dart';
import 'package:ustam_gelsin/features/home/widgets/ilan_akisi_slider.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'web_home_screen.dart';
import 'nasil_calisir.dart';
import 'destek_iletisim.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchURL(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width > 0) return const WebHomeScreen();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Image.asset('assets/app_logo.png', height: 80, fit: BoxFit.contain),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(decoration: const BoxDecoration(color: Colors.white), child: Column(children: [Image.asset('assets/app_logo.png', height: 90, fit: BoxFit.contain), const SizedBox(height: 2), Text("İşin Ustası, Hep Yanında", style: GoogleFonts.caveat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))])),
              Expanded(
                child: ListView(padding: EdgeInsets.zero, children: [
                  ListTile(leading: const Icon(Icons.badge_outlined, color: Color(0xFF2979FF)), title: const Text("MÜŞTERİ GİRİŞİ", style: TextStyle(color: Colors.black)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerAuthPage(role: "customer")))),
                  ListTile(leading: Icon(Icons.construction, color: AppColors.ustaColor), title: const Text("USTA GİRİŞİ", style: TextStyle(color: Colors.black)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaAuthPage(role: "usta")))),
                  const Divider(),
                  ListTile(leading: const Icon(Icons.fingerprint, color: Colors.black), title: const Text("Biz Kimiz", style: TextStyle(color: Colors.black)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BizKimizPage()))),
                  ListTile(leading: const Icon(Icons.settings_suggest, color: Colors.black), title: const Text("Nasıl Çalışır", style: TextStyle(color: Colors.black)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NasilCalisirPage()))),
                  ListTile(leading: const Icon(Icons.support_agent, color: Colors.black), title: const Text("Destek & İletişim", style: TextStyle(color: Colors.black)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DestekIletisimPage()))),
                ]),
              ),
              Padding(padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10), child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(icon: const Icon(Icons.facebook, color: Colors.blue, size: 35), onPressed: () => _launchURL("https://www.facebook.com/profile.php?id=61590307306927")),
                  const SizedBox(width: 15),
                  IconButton(icon: const Icon(Icons.camera_alt, color: Colors.pink, size: 35), onPressed: () => _launchURL("https://www.instagram.com/hemenustamgelsin?igsh=NnlneXE2b2ZydDZu")),
                ]),
                const SizedBox(height: 10),
                const Wrap(alignment: WrapAlignment.center, spacing: 10, children: [Icon(Icons.verified_user, size: 16, color: Colors.green), Text("KVKK", style: TextStyle(fontSize: 10)), Icon(Icons.lock, size: 16, color: Colors.blue), Text("Güvenli Ödeme", style: TextStyle(fontSize: 10)), Icon(Icons.headset_mic, size: 16, color: Colors.orange), Text("Destek", style: TextStyle(fontSize: 10))])
              ])),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text("Aradığın Usta, Bir Tık Uzağında!", textAlign: TextAlign.center, style: GoogleFonts.caveat(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),

              const SizedBox(height: 15),
              const HizmetlerSlider(),

              const SizedBox(height: 0),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text("Hizmetlerimiz", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                  const SizedBox(height: 8),
                  Container(height: 1.5, width: double.infinity, color: Colors.red),
                ],
              ),

              const SizedBox(height: 25),
              const IlanAkisiSlider(ustaLat: 0.0, ustaLng: 0.0),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text("İlanlar", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                  const SizedBox(height: 8),
                  Container(height: 1.5, width: double.infinity, color: Colors.red),
                ],
              ),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.auto_awesome, color: Colors.amber, size: 24), const SizedBox(width: 10), Text("Maliyetini Merak mı Ediyorsun?", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))]),
                    const SizedBox(height: 12),
                    const Text("Yapay zeka asistanımız piyasa verilerini analiz etsin, sana tahmini bir fiyat aralığı çıkarsın.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageAI())),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text("Ücretsiz Analiz Et")
                    )
                  ]),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class BizKimizPage extends StatelessWidget {
  const BizKimizPage({super.key});
  Future<Map<String, dynamic>> _loadData() async {
    final String response = await rootBundle.loadString('assets/data/biz_kimiz.json');
    return jsonDecode(response);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biz Kimiz", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData) return const Center(child: Text("İçerik bulunamadı."));
          final data = snapshot.data!;
          final List icerikListesi = data['icerik'] ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(data['baslik'] ?? "Biz Kimiz?", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(height: 40),
              ...icerikListesi.map((item) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item['baslik'] ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                const SizedBox(height: 5),
                Text(item['metin'] ?? "", style: const TextStyle(fontSize: 15, height: 1.4)),
                const SizedBox(height: 20),
              ])),
            ]),
          );
        },
      ),
    );
  }
}