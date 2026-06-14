import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/web_dosyalari/musteri_kayit_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/usta_kayit_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/musteri_giris_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/usta_giris_ekrani.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_profil_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isProfileLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        setState(() => _currentUser = user);
      }
    });
  }

  void _showSelectionDialog(BuildContext context, bool isRegister) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isRegister ? "Üyelik Tipi Seçin" : "Giriş Tipi Seçin"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Usta Olarak"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => isRegister ? const UstaKayitEkrani() : const UstaGirisEkrani()));
              },
            ),
            ListTile(
              title: const Text("Müşteri Olarak"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => isRegister ? const MusteriKayitEkrani() : const MusteriGirisEkrani()));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Scaffold(body: SizedBox.shrink());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildHero(context),
            _buildTrustBar(context),
            _buildHowItWorks(context),
            _buildPopularServices(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        child: Row(
          children: [
            Image.asset('assets/web_logo.png', height: 88),
            SizedBox(width: constraints.maxWidth > 900 ? 50 : 20),
            Expanded(
              child: Wrap(
                spacing: 28,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: ["Nasıl Çalışır?", "AI Fiyat Tahmini", "Hakkımızda", "İletişim"]
                    .map((text) => InkWell(
                  onTap: () {},
                  child: Text(text, style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.w500)),
                ))
                    .toList(),
              ),
            ),
            const SizedBox(width: 20),
            _currentUser == null
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => _showSelectionDialog(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  ),
                  child: const Text("Üye Ol", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _showSelectionDialog(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC143C),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  ),
                  child: const Text("GİRİŞ YAP", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _isProfileLoading ? null : () async {
                    setState(() => _isProfileLoading = true);
                    String? role = await _authService.getUserRole();
                    if (!mounted) return;
                    setState(() => _isProfileLoading = false);

                    if (role == 'usta' || role == 'master') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaProfilSayfasi()));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriProfilSayfasi()));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
                  child: _isProfileLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Profilim", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () async {
                    await _authService.signOut();
                  },
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
                  child: const Text("Çıkış Yap", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHero(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isNarrow = constraints.maxWidth < 1000;
      return Padding(
        padding: const EdgeInsets.fromLTRB(80, 20, 80, 40),
        child: Flex(
          direction: isNarrow ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Chip(
                    label: Text("YAPAY ZEKA DESTEĞİ İLE", style: TextStyle(color: Color(0xFFDC143C), fontWeight: FontWeight.bold)),
                    backgroundColor: Color(0xFFFFEBEE),
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(fontSize: 62, fontWeight: FontWeight.bold, height: 1.05),
                      children: const [
                        TextSpan(text: "Ustanızı ", style: TextStyle(color: Colors.black87)),
                        TextSpan(text: "Dakikalar ", style: TextStyle(color: Color(0xFFDC143C))),
                        TextSpan(text: "İçinde Bulun", style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Yapay zeka ile anında fiyat tahmini alın, doğrulanmış ustalardan\nteklifler alın ve işinizi güvenle tamamlayın.",
                    style: TextStyle(fontSize: 20, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC143C),
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 22),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("İLAN VER", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 22),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Usta Ol →", style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!isNarrow) const SizedBox(width: 60),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/usta.png',
                  height: 600,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 600,
                    color: Colors.grey[100],
                    child: const Center(child: Text("usta.png yüklenemedi")),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTrustBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(80, 0, 80, 20),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 25)],
      ),
      child: Wrap(
        spacing: 40,
        runSpacing: 20,
        alignment: WrapAlignment.spaceAround,
        children: const [
          _IconText(icon: Icons.lock, title: "SSL Güvenli Ödeme\n256-bit şifreleme"),
          _IconText(icon: Icons.verified_user, title: "Doğrulanmış Ustalar\nKimlik doğrulaması yapılmış"),
          _IconText(icon: Icons.access_time_filled, title: "7/24 Acil Usta\nHer zaman yanınızdayız"),
          _IconText(icon: Icons.auto_awesome, title: "AI Fiyat Tahmini\nYüksek doğruluk oranı"),
        ],
      ),
    );
  }

  Widget _buildHowItWorks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(80, 40, 80, 60),
      child: Column(
        children: [
          Text("Nasıl Çalışır?", style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 50,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: const [
              _Step(num: "1", title: "İlanını Oluştur", subtitle: "İhtiyacını detaylı anlat"),
              _Step(num: "2", title: "AI Fiyat Tahmini Al", subtitle: "Anında fiyat aralığı gör"),
              _Step(num: "3", title: "Teklifleri Karşılaştır", subtitle: "Doğrulanmış ustalardan teklifler"),
              _Step(num: "4", title: "Ustanı Seç", subtitle: "Güvenle işi tamamla"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularServices() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(80, 20, 80, 60),
      child: Column(
        children: [
          Text("Popüler Hizmetler", style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: const [
              _ServiceCard("Elektrik", icon: Icons.electric_bolt),
              _ServiceCard("Tesisat", icon: Icons.plumbing),
              _ServiceCard("Boya", icon: Icons.format_paint),
              _ServiceCard("Fayans", icon: Icons.view_module),
              _ServiceCard("Mobilya", icon: Icons.chair),
              _ServiceCard("Klima", icon: Icons.ac_unit),
            ],
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () {},
            child: Text("Tüm Hizmetleri Gör →", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFFDC143C))),
          ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String title;
  const _IconText({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFDC143C), size: 34),
        const SizedBox(width: 14),
        Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, height: 1.3)),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final String num, title, subtitle;
  const _Step({required this.num, required this.title, this.subtitle = ""});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          CircleAvatar(radius: 32, backgroundColor: const Color(0xFFDC143C), child: Text(num, style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          if (subtitle.isNotEmpty) Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  const _ServiceCard(this.title, {required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: const Color(0xFFDC143C)),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}