// lib/features/home/screens/home_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/theme/app_theme.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_auth_page.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_auth_page.dart';
import 'package:ustam_gelsin/features/home/screens/home_page_ai.dart';
import 'package:ustam_gelsin/features/home/widgets/hizmetler_slider.dart';
import 'package:ustam_gelsin/features/home/widgets/ilan_akisi_slider.dart';
import 'web_home_screen.dart';
import 'nasil_calisir.dart';
import 'destek_iletisim.dart';
import 'insaat_rehberi.dart';

// Firebase'den veri çeken güncellenmiş sözleşme fonksiyonu
Future<void> showSozlesmeDialog(BuildContext context, String documentId, String defaultBaslik) async {
  showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
  try {
    final doc = await FirebaseFirestore.instance.collection('config').doc(documentId).get();
    Navigator.pop(context);
    if (!doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sözleşme bulunamadı')));
      return;
    }
    final data = doc.data()!;
    final String baslik = data['baslik'] ?? defaultBaslik;
    final String metin = data['metin'] ?? 'İçerik yüklenemedi.';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(baslik, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(child: Text(metin)),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat'))],
      ),
    );
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _lat = 0.0;
  double _lng = 0.0;
  bool _konumYukleniyor = true;

  static const String FIRMA_UNVANI = "Hemen Ustam Gelsin";
  static const String FIRMA_ADRES = "Sağlık Mh. Kurudere Cd. No:76/9 Salihli - MANİSA";
  static const String FIRMA_TELEFON = "0532 163 59 66";
  static const String FIRMA_MAIL = "hemenustamgelsin@gmail.com";
  static const String FIRMA_VERGI_DAIRESI = "Salihli";
  static const String FIRMA_VERGI_NO = "3650145075";

  @override
  void initState() {
    super.initState();
    _konumuBelirle();
  }

  Future<void> _konumuBelirle() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        if (mounted) {
          setState(() {
            _lat = position.latitude;
            _lng = position.longitude;
            _konumYukleniyor = false;
          });
        }
      } else {
        if (mounted) setState(() => _konumYukleniyor = false);
      }
    } catch (e) {
      if (mounted) setState(() => _konumYukleniyor = false);
    }
  }

  Future<void> _launchURL(String urlString) async {
    try {
      final Uri uri = Uri.parse(urlString);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Yönlendirme hatası: $e");
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 30),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(decoration: const BoxDecoration(color: Colors.white), child: Column(children: [Image.asset('assets/app_logo.png', height: 90, fit: BoxFit.contain), const SizedBox(height: 2), Text("İşin Ustası, Hep Yanında", style: GoogleFonts.caveat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))])),
              Expanded(
                child: ListView(padding: EdgeInsets.zero, children: [
                  ListTile(leading: const Icon(Icons.badge_outlined, color: Color(0xFF2979FF)), title: const Text("MÜŞTERİ GİRİŞİ"), titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerAuthPage(role: "customer")))),
                  ListTile(leading: Icon(Icons.construction, color: AppColors.ustaColor), title: const Text("USTA GİRİŞİ"), titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaAuthPage(role: "usta")))),
                  const Divider(),
                  ListTile(leading: const Icon(Icons.fingerprint, color: Colors.black), title: const Text("Biz Kimiz"), titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BizKimizPage()))),
                  ListTile(leading: const Icon(Icons.settings_suggest, color: Colors.black), title: const Text("Nasıl Çalışır"), titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NasilCalisirPage()))),
                  ListTile(leading: const Icon(Icons.support_agent, color: Colors.black), title: const Text("Destek & İletişim"), titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DestekIletisimPage()))),

                  // Sosyal medya başlığı ve ikonları
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Column(
                      children: [
                        const Text("Sosyal medyada bizi takip edin", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
                        const SizedBox(height: 15),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 15,
                              runSpacing: 15,
                              children: [
                                _buildSocialIcon("assets/linkedin.png", "https://www.linkedin.com/in/hemen-ustam-gelsin-2499b2415/"),
                                _buildSocialIcon("assets/instagram.png", "https://www.instagram.com/hemenustamgelsin?igsh=NnlneXE2b2ZydDZu"),
                                _buildSocialIcon("assets/facebook.png", "https://www.facebook.com/profile.php?id=61591164702200"),
                                _buildSocialIcon("assets/x.png", "https://x.com/Hemenustamglsn"),
                                _buildSocialIcon("assets/tiktok.png", "https://www.tiktok.com/@hemen_ustam_gelsin"),
                                _buildSocialIcon("assets/youtube.png", "https://www.youtube.com/@HemenUstamGelsin"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  RichText(text: TextSpan(children: [TextSpan(text: "Aradığın usta,\n", style: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.black, height: 1.1)), TextSpan(text: "bir tık uzağında!", style: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.red, height: 1.1))])),
                  const SizedBox(height: 10),
                  Text("Güvenilir ustalar, şeffaf fiyatlar, hızlı çözümler.", style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 22),
                  Row(children: [
                    Expanded(child: SizedBox(height: 58, child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerAuthPage(role: "customer"))), icon: const Icon(Icons.add, color: Colors.white), label: Text("ÜCRETSİZ İLAN OLUŞTUR", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12)), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))))),
                    const SizedBox(width: 10),
                    Expanded(child: SizedBox(height: 58, child: OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageAI())), icon: const Icon(Icons.calculate_outlined), label: Text("AI MALİYET HESAPLA", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12)), style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black, width: 1.3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))))),
                  ]),
                ]),
              ),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Image.asset('assets/kesinti_yok.png', fit: BoxFit.contain)),
              const SizedBox(height: 25),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Align(alignment: Alignment.centerLeft, child: Text("HİZMETLERİMİZ", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)))),
              const SizedBox(height: 8),
              const HizmetlerSlider(),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Container(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10)]), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildStat(Icons.groups, "12.500+", "Tamamlanan İş"), _buildStat(Icons.verified_user, "3.200+", "Doğrulanmış Usta"), _buildStat(Icons.location_on, "81 İlde", "Hizmet")]))),
              const SizedBox(height: 30),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("SON İLANLAR", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)), InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaAuthPage(role: "usta"))), child: const Text("Tümünü Gör →", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)) )])),
              const SizedBox(height: 12),
              _konumYukleniyor ? const Center(child: CircularProgressIndicator()) : IlanAkisiSlider(ustaLat: _lat, ustaLng: _lng),
              const SizedBox(height: 15),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Image.asset('assets/kesinti_yok_2.png', fit: BoxFit.contain)),
              const SizedBox(height: 30),

              // FOOTER ALANI
              Container(
                width: double.infinity,
                color: const Color(0xFF1A1A1A),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(FIRMA_UNVANI, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text("Adres: $FIRMA_ADRES", textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)),
                    Text("Tel: $FIRMA_TELEFON | Mail: $FIRMA_MAIL", textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)),

                    const SizedBox(height: 20),
                    Text("GÜVENLİ ÖDEME", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(alignment: WrapAlignment.center, spacing: 10, runSpacing: 10, children: [
                      Image.asset('assets/visa.png', height: 30, errorBuilder: (c, e, s) => const Icon(Icons.credit_card, color: Colors.grey)),
                      Image.asset('assets/master.png', height: 30, errorBuilder: (c, e, s) => const Icon(Icons.credit_card, color: Colors.grey)),
                      Image.asset('assets/troy.png', height: 30, errorBuilder: (c, e, s) => const Icon(Icons.credit_card, color: Colors.grey)),
                      Image.asset('assets/iyzico.png', height: 30, errorBuilder: (c, e, s) => const Icon(Icons.payment, color: Colors.grey)),
                      Image.asset('assets/3D_secure.png', height: 30, errorBuilder: (c, e, s) => const Icon(Icons.security, color: Colors.grey)),
                    ]),

                    const SizedBox(height: 20),
                    Text("SÖZLEŞMELER", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(alignment: WrapAlignment.center, spacing: 10, children: [
                      InkWell(onTap: () => showSozlesmeDialog(context, "gizlilik_politikasi", "Gizlilik Politikası"), child: const Text("Gizlilik Politikası", style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline))),
                      InkWell(onTap: () => showSozlesmeDialog(context, "mesafeli_satis", "Mesafeli Satış"), child: const Text("Mesafeli Satış", style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline))),
                      InkWell(onTap: () => showSozlesmeDialog(context, "kullanim_kosullari", "Kullanım Koşulları"), child: const Text("Kullanım Koşulları", style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline))),
                      InkWell(onTap: () => showSozlesmeDialog(context, "iptal_iade", "İptal ve İade"), child: const Text("İptal ve İade", style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline))),
                    ]),

                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFF444444)),
                    Text("© ${DateTime.now().year} $FIRMA_UNVANI. Tüm hakları saklıdır.", style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.auto_awesome, "AI MALİYET", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageAI()))),
              _buildNavItem(Icons.help_outline, "NASIL ÇALIŞIR", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NasilCalisirPage()))),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: FloatingActionButton(
                        elevation: 0,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerAuthPage(role: "customer"))),
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.add, color: Colors.white, size: 30)
                    ),
                  ),
                  const Text("İLAN VER", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
              _buildNavItem(Icons.article_outlined, "İNŞAAT REHBERİ", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InsaatRehberiScreen()))),
              _buildNavItem(Icons.support_agent, "DESTEK", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DestekIletisimPage()))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Image.asset(assetPath, width: 50, height: 50),
    );
  }

  Widget _buildNavItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [const SizedBox(height: 10), Icon(icon, size: 24, color: Colors.black87), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(children: [Icon(icon, color: Colors.red, size: 30), const SizedBox(height: 8), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const SizedBox(height: 3), Text(label, style: const TextStyle(fontSize: 11))]);
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
    return Scaffold(appBar: AppBar(title: const Text("Biz Kimiz", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)), body: FutureBuilder<Map<String, dynamic>>(future: _loadData(), builder: (context, snapshot) { if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator()); if (!snapshot.hasData) return const Center(child: Text("İçerik bulunamadı.")); final data = snapshot.data!; final List icerikListesi = data['icerik'] ?? []; return SingleChildScrollView(padding: const EdgeInsets.all(20.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['baslik'] ?? "Biz Kimiz?", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const Divider(height: 40), ...icerikListesi.map((item) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['baslik'] ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)), const SizedBox(height: 5), Text(item['metin'] ?? "", style: const TextStyle(fontSize: 15, height: 1.4)), const SizedBox(height: 20)]))])); }));
  }
}