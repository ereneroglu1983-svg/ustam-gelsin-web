import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:universal_html/html.dart' as html;
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/core/widgets/responsive_layout.dart';
import 'package:ustam_gelsin/web_dosyalari/musteri_kayit_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/usta_kayit_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/musteri_giris_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/usta_giris_ekrani.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_profil_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';
import 'package:ustam_gelsin/features/home/widgets/hizmetler_slider.dart';
import 'package:ustam_gelsin/features/home/widgets/ilan_akisi_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ustam_gelsin/features/home/screens/nasil_calisir.dart';
import 'package:ustam_gelsin/features/home/screens/home_page_ai.dart';
import 'package:ustam_gelsin/features/home/screens/biz_kimiz_page.dart';
import 'package:ustam_gelsin/features/home/screens/destek_iletisim.dart';

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
    showDialog(context: context, builder: (_) => AlertDialog(title: Text(baslik, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), content: SizedBox(width: double.maxFinite, height: MediaQuery.of(context).size.height * 0.6, child: SingleChildScrollView(child: Text(metin))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat'))]));
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
  }
}

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});
  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isProfileLoading = false;
  double _lat = 39.9334;
  double _lng = 32.8597;
  bool _isLocationLoading = true;

  static const String FIRMA_UNVANI = "Hemen Ustam Gelsin";
  static const String FIRMA_ADRES = "Sağlık Mh. Kurudere Cd. No:76/9 Salihli - MANİSA";
  static const String FIRMA_TELEFON = "0532 163 59 66";
  static const String FIRMA_MAIL = "hemenustamgelsin@gmail.com";
  static const String FIRMA_VERGI_DAIRESI = "Salihli";
  static const String FIRMA_VERGI_NO = "3650145075";

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) { if (mounted) setState(() => _currentUser = user); });
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (kIsWeb) {
      try {
        final position = await html.window.navigator.geolocation?.getCurrentPosition();
        if (mounted && position?.coords != null) {
          setState(() { _lat = (position!.coords!.latitude ?? 39.9334).toDouble(); _lng = (position!.coords!.longitude ?? 32.8597).toDouble(); _isLocationLoading = false; });
        } else { _setFallback(); }
      } catch (e) { _setFallback(); }
    } else { await _determineMobilePosition(); }
  }

  Future<void> _determineMobilePosition() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) { _setFallback(); return; }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      if (mounted) { setState(() { _lat = position.latitude; _lng = position.longitude; _isLocationLoading = false; }); }
    } catch (e) { _setFallback(); }
  }

  void _setFallback() { if (mounted) setState(() { _isLocationLoading = false; }); }

  Widget _buildCanliIlanlarSection() {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [Text("Canlı İlanlar", style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold)), const SizedBox(height: 32), _isLocationLoading ? const SizedBox(height: 240, child: Center(child: CircularProgressIndicator())) : IlanAkisiSlider(ustaLat: _lat, ustaLng: _lng)]));
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const Scaffold(body: SizedBox.shrink());
    return ResponsiveLayout(mobileBody: _buildMainContent(context), desktopBody: _buildMainContent(context));
  }

  Widget _buildMainContent(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: SingleChildScrollView(child: Column(children: [_buildHeader(context), _buildHero(context), _buildTrustBar(context), _buildHowItWorks(context), _buildCanliIlanlarSection(), _buildHizmetlerimizSection(), _buildFooter(context)])));
  }

  Widget _buildHeader(BuildContext context) {
    final menuItems = [
      {"title": "Nasıl Çalışır", "page": const NasilCalisirPage()},
      {"title": "AI Fiyat Tahmini", "page": const HomePageAI()},
      {"title": "Hakkımızda", "page": const BizKimizPage()},
      {"title": "İletişim", "page": const DestekIletisimPage()},
    ];
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16), child: Row(children: [Image.asset('assets/web_logo.png', height: 88), SizedBox(width: constraints.maxWidth > 900 ? 50 : 20), Expanded(child: Wrap(spacing: 28, runSpacing: 10, alignment: WrapAlignment.center, children: menuItems.map((item) => InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => item['page'] as Widget)), child: Text(item['title'] as String, style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.w500)))).toList())), const SizedBox(width: 20), _currentUser == null ? Row(mainAxisSize: MainAxisSize.min, children: [ElevatedButton(onPressed: () => _showSelectionDialog(context, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)), child: const Text("Üye Ol", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))), const SizedBox(width: 12), ElevatedButton(onPressed: () => _showSelectionDialog(context, false), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)), child: const Text("GİRİŞ YAP", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))]) : Row(mainAxisSize: MainAxisSize.min, children: [ElevatedButton(onPressed: _isProfileLoading ? null : () async { setState(() => _isProfileLoading = true); String? role = await _authService.getUserRole(); if (!mounted) return; setState(() => _isProfileLoading = false); if (role == 'usta' || role == 'master') Navigator.push(context, MaterialPageRoute(builder: (context) => UstaProfilSayfasi())); else Navigator.push(context, MaterialPageRoute(builder: (context) => MusteriProfilSayfasi())); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)), child: _isProfileLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Profilim", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))), const SizedBox(width: 12), OutlinedButton(onPressed: () async => await _authService.signOut(), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)), child: const Text("Çıkış Yap", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)))])]));
    });
  }

  Widget _buildHero(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isNarrow = constraints.maxWidth < 1000;
      return Padding(padding: const EdgeInsets.fromLTRB(80, 20, 80, 40), child: Flex(direction: isNarrow ? Axis.vertical : Axis.horizontal, crossAxisAlignment: CrossAxisAlignment.center, children: [Expanded(flex: 5, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Chip(label: Text("YAPAY ZEKA DESTEĞİ İLE", style: TextStyle(color: Color(0xFFDC143C), fontWeight: FontWeight.bold)), backgroundColor: Color(0xFFFFEBEE), side: BorderSide.none), const SizedBox(height: 12), RichText(text: TextSpan(style: GoogleFonts.poppins(fontSize: 62, fontWeight: FontWeight.bold, height: 1.05), children: const [TextSpan(text: "Ustanızı ", style: TextStyle(color: Colors.black87)), TextSpan(text: "Dakikalar ", style: TextStyle(color: Color(0xFFDC143C))), TextSpan(text: "İçinde Bulun", style: TextStyle(color: Colors.black87))])), const SizedBox(height: 12), const Text("Yapay zeka ile anında fiyat tahmini alın, doğrulanmış ustalardan\nteklifler alın ve işinizi güvenle tamamlayın.", style: TextStyle(fontSize: 20, height: 1.6, color: Colors.black87)), const SizedBox(height: 18), Row(children: [ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("İLAN VER", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))), const SizedBox(width: 16), OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Usta Ol →", style: TextStyle(fontSize: 18)))])])), if (!isNarrow) const SizedBox(width: 60), Expanded(flex: 5, child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/usta.png', height: 600, fit: BoxFit.contain, errorBuilder: (c, e, s) => Container(height: 600, color: Colors.grey[100], child: const Center(child: Text("usta.png yüklenemedi"))))))]));
    });
  }

  Widget _buildTrustBar(BuildContext context) {
    return Container(margin: const EdgeInsets.fromLTRB(80, 0, 80, 20), padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 25)]), child: Wrap(spacing: 40, runSpacing: 20, alignment: WrapAlignment.spaceAround, children: const [_IconText(icon: Icons.lock, title: "SSL Güvenli Ödeme\n256-bit şifreleme"), _IconText(icon: Icons.verified_user, title: "Doğrulanmış Ustalar\nKimlik doğrulaması yapılmış"), _IconText(icon: Icons.access_time_filled, title: "7/24 Acil Usta\nHer zaman yanınızdayız"), _IconText(icon: Icons.auto_awesome, title: "AI Fiyat Tahmini\nYüksek doğruluk oranı")]));
  }

  Widget _buildHowItWorks(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(80, 40, 80, 60), child: Column(children: [Text("Nasıl Çalışır?", style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold)), const SizedBox(height: 32), Wrap(spacing: 50, runSpacing: 30, alignment: WrapAlignment.center, children: const [_Step(num: "1", title: "İlanını Oluştur", subtitle: "İhtiyacını detaylı anlat"), _Step(num: "2", title: "AI Fiyat Tahmini Al", subtitle: "Anında fiyat aralığı gör"), _Step(num: "3", title: "Teklifleri Karşılaştır", subtitle: "Doğrulanmış ustalardan teklifler"), _Step(num: "4", title: "Ustanı Seç", subtitle: "Güvenle işi tamamla")])]));
  }

  Widget _buildHizmetlerimizSection() {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [Text("Hizmetlerimiz", style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold)), const SizedBox(height: 32), const HizmetlerSlider()]));
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isNarrow = constraints.maxWidth < 1100;
          return Column(
            children: [
              Flex(
                direction: isNarrow ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(FIRMA_UNVANI, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text("Adres: $FIRMA_ADRES", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)), Text("Tel: $FIRMA_TELEFON | Mail: $FIRMA_MAIL", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)), Text("$FIRMA_VERGI_DAIRESI V.D. - VKN: $FIRMA_VERGI_NO", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12))])),
                  const SizedBox(width: 20, height: 20),
                  Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("GÜVENLİ ÖDEME", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Wrap(spacing: 10, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [Image.asset('assets/visa.png', height: 35, errorBuilder: (c, e, s) => _buildLogoPlaceholder("VISA")), Image.asset('assets/master.png', height: 35, errorBuilder: (c, e, s) => _buildLogoPlaceholder("Mastercard")), Image.asset('assets/troy.png', height: 35, errorBuilder: (c, e, s) => _buildLogoPlaceholder("TROY")), Image.asset('assets/3D_secure.png', height: 50, errorBuilder: (c, e, s) => _buildLogoPlaceholder("3D Secure"))]), const SizedBox(height: 8), Text("Tüm ödemeler 256 Bit SSL şifreleme ve 3D Secure doğrulaması ile güvenle gerçekleştirilir.", style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 10))])),
                  Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SÖZLEŞMELER", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 8), _buildFooterLink(context, "Gizlilik Politikası", "gizlilik_politikasi"), _buildFooterLink(context, "Mesafeli Satış", "mesafeli_satis"), _buildFooterLink(context, "Kullanım Koşulları", "kullanim_kosullari"), _buildFooterLink(context, "İptal ve İade", "iptal_iade")]))
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Color(0xFF444444)),
              const SizedBox(height: 16),
              Center(child: Text("© ${DateTime.now().year} $FIRMA_UNVANI. Tüm hakları saklıdır.", style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)))
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogoPlaceholder(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)));

  Widget _buildFooterLink(BuildContext context, String text, String documentId) => Padding(padding: const EdgeInsets.only(bottom: 4), child: InkWell(onTap: () => showSozlesmeDialog(context, documentId, text), child: Text(text, style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12, decoration: TextDecoration.underline))));

  void _showSelectionDialog(BuildContext context, bool isRegister) {
    showDialog(context: context, builder: (context) => AlertDialog(title: Text(isRegister ? "Üyelik Tipi Seçin" : "Giriş Tipi Seçin"), content: Column(mainAxisSize: MainAxisSize.min, children: [ListTile(title: const Text("Usta Olarak"), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => isRegister ? UstaKayitEkrani() : UstaGirisEkrani())); }), ListTile(title: const Text("Müşteri Olarak"), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => isRegister ? MusteriKayitEkrani() : MusteriGirisEkrani())); })])));
  }
}

class _IconText extends StatelessWidget {
  final IconData icon; final String title;
  const _IconText({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: const Color(0xFFDC143C), size: 34), const SizedBox(width: 14), Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, height: 1.3))]);
}

class _Step extends StatelessWidget {
  final String num, title, subtitle;
  const _Step({required this.num, required this.title, this.subtitle = ""});
  @override
  Widget build(BuildContext context) => SizedBox(width: 200, child: Column(children: [CircleAvatar(radius: 32, backgroundColor: const Color(0xFFDC143C), child: Text(num, style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold))), const SizedBox(height: 16), Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)), if (subtitle.isNotEmpty) Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 14))]));
}