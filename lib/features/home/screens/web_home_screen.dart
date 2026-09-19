import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/web_dosyalari/musteri_kayit_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/usta_kayit_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/musteri_giris_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/usta_giris_ekrani.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_profil_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';
import 'package:ustam_gelsin/features/home/widgets/hizmetler_slider.dart';
import 'package:ustam_gelsin/features/home/widgets/ilan_akisi_slider.dart';
import 'package:ustam_gelsin/features/home/widgets/insaat_rehberi_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/features/home/screens/nasil_calisir.dart';
import 'package:ustam_gelsin/features/home/screens/home_page_ai.dart';
import 'package:ustam_gelsin/features/home/screens/biz_kimiz_page.dart';
import 'package:ustam_gelsin/features/home/screens/destek_iletisim.dart';
import 'package:ustam_gelsin/features/admin/screens/admin_dashboard.dart';

Future<void> showSozlesmeDialog(BuildContext context, String documentId, String defaultBaslik) async {
  showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
  try {
    final doc = await FirebaseFirestore.instance.collection('config').doc(documentId).get();
    if (context.mounted) Navigator.pop(context);
    if (!doc.exists) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sözleşme bulunamadı')));
      return;
    }
    final data = doc.data()!;
    final String baslik = data['baslik']?? defaultBaslik;
    final String metin = data['metin']?? 'İçerik yüklenemedi.';
    if (context.mounted) {
      showDialog(context: context, builder: (_) => AlertDialog(title: Text(baslik, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), content: SizedBox(width: double.maxFinite, height: MediaQuery.of(context).size.height * 0.6, child: SingleChildScrollView(child: Text(metin))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat'))]));
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
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
  double? _lat;
  double? _lng;
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeLocation());
  }

  Future<void> _initializeLocation() async => await _determinePositionFromIP();

  Future<void> _determinePositionFromIP() async {
    // 1. ipapi.co - istemciden çağrılabilir, lat/lng döner
    try {
      final r1 = await http.get(Uri.parse('https://ipapi.co/json/')).timeout(const Duration(seconds: 3));
      if (r1.statusCode == 200) {
        final d = jsonDecode(r1.body);
        final lat = (d['latitude'] as num?)?.toDouble();
        final lng = (d['longitude'] as num?)?.toDouble();
        if (lat!= null && lng!= null && mounted) {
          setState(() { _lat = lat; _lng = lng; _isLocationLoading = false; });
          return;
        }
      }
    } catch (_) {}
    // 2. Fallback: ipwho.is - CORS destekli ikinci kaynak
    try {
      final r2 = await http.get(Uri.parse('https://ipwho.is/')).timeout(const Duration(seconds: 3));
      if (r2.statusCode == 200) {
        final d = jsonDecode(r2.body);
        final lat = (d['latitude'] as num?)?.toDouble();
        final lng = (d['longitude'] as num?)?.toDouble();
        if (lat!= null && lng!= null && mounted) {
          setState(() { _lat = lat; _lng = lng; _isLocationLoading = false; });
          return;
        }
      }
    } catch (_) {}
    // 3. Hepsi başarısız -> genel gösterim (Ankara'ya düşme yok)
    _setFallback();
  }

  Future<void> _requestPreciseLocation() async {
    if (!mounted) return;
    setState(() => _isLocationLoading = true);
    try {
      final perm = await Geolocator.requestPermission();
      if (!mounted) return;
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        setState(() => _isLocationLoading = false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium).timeout(const Duration(seconds: 5));
      if (!mounted) return;
      setState(() { _lat = pos.latitude; _lng = pos.longitude; _isLocationLoading = false; });
    } catch (_) {
      if (!mounted) return;
      // GPS hata verirse IP konumunu koru, sadece loading kapat
      setState(() => _isLocationLoading = false);
    }
  }

  void _setFallback() {
    if (!mounted) return;
    setState(() { _lat = null; _lng = null; _isLocationLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const Scaffold(body: SizedBox.shrink());
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      return _buildMainContent(context, isMobile: w < 600, isTablet: w >= 600 && w < 1100, isDesktop: w >= 1100);
    });
  }

  Widget _buildMainContent(BuildContext context, {required bool isMobile, required bool isTablet, required bool isDesktop}) {
    return Scaffold(backgroundColor: Colors.white, body: SingleChildScrollView(child: Column(children: [_buildHeader(context, isMobile: isMobile, isTablet: isTablet, isDesktop: isDesktop), _buildHero(context, isMobile: isMobile, isTablet: isTablet, isDesktop: isDesktop), _buildTrustBar(context, isMobile: isMobile, isTablet: isTablet, isDesktop: isDesktop), _buildHowItWorks(context, isMobile: isMobile, isTablet: isTablet, isDesktop: isDesktop), _buildCanliIlanlarSection(isMobile: isMobile, isTablet: isTablet), _buildHizmetlerimizSection(isMobile: isMobile, isTablet: isTablet), _buildFooter(context, isMobile: isMobile, isTablet: isTablet, isDesktop: isDesktop)])));
  }

  Widget _buildHeader(BuildContext context, {required bool isMobile, required bool isTablet, required bool isDesktop}) {
    final menuItems = [{"title": "Nasıl Çalışır", "page": const NasilCalisirPage()}, {"title": "AI Fiyat Tahmini", "page": const HomePageAI()}, {"title": "Hakkımızda", "page": const BizKimizPage()}, {"title": "İletişim", "page": const DestekIletisimPage()}];
    final hPad = isMobile? 16.0 : isTablet? 24.0 : 80.0;
    final logoH = isMobile? 48.0 : isTablet? 64.0 : 88.0;
    if (isMobile) {
      return Padding(padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Image.asset('assets/web_logo.png', height: logoH), _currentUser == null? Row(mainAxisSize: MainAxisSize.min, children: [ElevatedButton(onPressed: () => _showSelectionDialog(context, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)), child: const Text("Üye Ol", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))), const SizedBox(width: 8), ElevatedButton(onPressed: () => _showSelectionDialog(context, false), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)), child: const Text("GİRİŞ", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))]) : ElevatedButton(onPressed: _isProfileLoading? null : () async { setState(() => _isProfileLoading = true); bool adminMi = await _authService.isAdmin(); String? role = await _authService.getUserRole(); if (!mounted) return; setState(() => _isProfileLoading = false); if (adminMi) Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboard())); else if (role == 'usta' || role == 'master') Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaProfilSayfasi())); else Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriProfilSayfasi())); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)), child: const Text("Profilim", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))]), const SizedBox(height: 12), Wrap(spacing: 16, runSpacing: 8, alignment: WrapAlignment.center, children: menuItems.map((item) => InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => item['page'] as Widget)), child: Text(item['title'] as String, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)))).toList())]));
    }
    return Padding(padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16), child: Row(children: [Image.asset('assets/web_logo.png', height: logoH), SizedBox(width: isTablet? 20 : 50), Expanded(child: Wrap(spacing: isTablet? 16 : 28, runSpacing: 10, alignment: WrapAlignment.center, children: menuItems.map((item) => InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => item['page'] as Widget)), child: Text(item['title'] as String, style: GoogleFonts.poppins(fontSize: isTablet? 13.5 : 15.5, fontWeight: FontWeight.w500)))).toList())), const SizedBox(width: 20), _currentUser == null? Row(mainAxisSize: MainAxisSize.min, children: [ElevatedButton(onPressed: () => _showSelectionDialog(context, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)), child: const Text("Üye Ol", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), const SizedBox(width: 12), ElevatedButton(onPressed: () => _showSelectionDialog(context, false), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)), child: const Text("GİRİŞ YAP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]) : Row(mainAxisSize: MainAxisSize.min, children: [ElevatedButton(onPressed: _isProfileLoading? null : () async { setState(() => _isProfileLoading = true); bool adminMi = await _authService.isAdmin(); String? role = await _authService.getUserRole(); if (!mounted) return; setState(() => _isProfileLoading = false); if (adminMi) Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboard())); else if (role == 'usta' || role == 'master') Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaProfilSayfasi())); else Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriProfilSayfasi())); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)), child: _isProfileLoading? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Profilim", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), const SizedBox(width: 12), OutlinedButton(onPressed: () async => await _authService.signOut(), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)), child: const Text("Çıkış Yap", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))])]));
  }

  Widget _buildHero(BuildContext context, {required bool isMobile, required bool isTablet, required bool isDesktop}) {
    final hPad = isMobile? 16.0 : isTablet? 24.0 : 80.0;
    final titleSize = isMobile? 32.0 : isTablet? 42.0 : 62.0;
    final descSize = isMobile? 14.0 : isTablet? 16.0 : 20.0;
    final imgH = isMobile? 280.0 : isTablet? 420.0 : 600.0;
    final textColumn = Column(crossAxisAlignment: isMobile? CrossAxisAlignment.center : CrossAxisAlignment.start, children: [const SizedBox(height: 12), RichText(textAlign: isMobile? TextAlign.center : TextAlign.start, text: TextSpan(style: GoogleFonts.poppins(fontSize: titleSize, fontWeight: FontWeight.bold, height: 1.05), children: const [TextSpan(text: "Ustanızı ", style: TextStyle(color: Colors.black87)), TextSpan(text: "Dakikalar ", style: TextStyle(color: Color(0xFFDC143C))), TextSpan(text: "İçinde Bulun", style: TextStyle(color: Colors.black87))])), const SizedBox(height: 12), Text("Yapay zeka ile anında fiyat tahmini alın, doğrulanmış ustalardan teklifler alın ve işinizi güvenle tamamlayın.", textAlign: isMobile? TextAlign.center : TextAlign.start, style: TextStyle(fontSize: descSize, height: 1.6, color: Colors.black87)), const SizedBox(height: 18), const InsaatRehberiSlider()]);
    final imageWidget = Image.asset('assets/usta.png', height: imgH, fit: BoxFit.contain, errorBuilder: (c, e, s) => Container(height: imgH, color: Colors.grey[100], child: const Center(child: Text("usta.png yüklenemedi"))));
    if (isDesktop) return Padding(padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 40), child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Expanded(flex: 5, child: textColumn), const SizedBox(width: 60), Expanded(flex: 5, child: Align(alignment: Alignment.centerRight, child: imageWidget))]));
    return Padding(padding: EdgeInsets.fromLTRB(hPad, 0, hPad, isMobile? 20 : 40), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [textColumn, const SizedBox(height: 20), imageWidget]));
  }

  Widget _buildTrustBar(BuildContext context, {required bool isMobile, required bool isTablet, required bool isDesktop}) {
    final hMargin = isMobile? 16.0 : isTablet? 24.0 : 80.0;
    final hPad = isMobile? 16.0 : 40.0;
    return Container(margin: EdgeInsets.fromLTRB(hMargin, 0, hMargin, 20), padding: EdgeInsets.symmetric(vertical: 24, horizontal: hPad), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 25)]), child: Wrap(spacing: isMobile? 20 : 40, runSpacing: 20, alignment: WrapAlignment.spaceAround, children: const [_IconText(icon: Icons.lock, title: "SSL Güvenli Ödeme\n256-bit şifreleme"), _IconText(icon: Icons.verified_user, title: "Doğrulanmış Ustalar\nKimlik doğrulaması yapılmış"), _IconText(icon: Icons.access_time_filled, title: "7/24 Acil Usta\nHer zaman yanınızdayız"), _IconText(icon: Icons.auto_awesome, title: "AI Fiyat Tahmini\nYüksek doğruluk oranı")]));
  }

  Widget _buildHowItWorks(BuildContext context, {required bool isMobile, required bool isTablet, required bool isDesktop}) {
    final hPad = isMobile? 16.0 : isTablet? 24.0 : 80.0;
    return Padding(padding: EdgeInsets.fromLTRB(hPad, isMobile? 20 : 40, hPad, isMobile? 30 : 60), child: Column(children: [Text("Nasıl Çalışır?", style: GoogleFonts.poppins(fontSize: isMobile? 26 : 36, fontWeight: FontWeight.bold)), const SizedBox(height: 32), Wrap(spacing: isMobile? 20 : 50, runSpacing: 30, alignment: WrapAlignment.center, children: const [_Step(num: "1", title: "İlanını Oluştur", subtitle: "İhtiyacını detaylı anlat"), _Step(num: "2", title: "AI Fiyat Tahmini Al", subtitle: "Anında fiyat aralığı gör"), _Step(num: "3", title: "Teklifleri Karşılaştır", subtitle: "Doğrulanmış ustalardan teklifler"), _Step(num: "4", title: "Ustanı Seç", subtitle: "Güvenle işi tamamla")])]));
  }

  Widget _buildCanliIlanlarSection({required bool isMobile, required bool isTablet}) {
    return Padding(padding: EdgeInsets.symmetric(vertical: isMobile? 20 : 40), child: Column(children: [Text("Canlı İlanlar", style: GoogleFonts.poppins(fontSize: isMobile? 26 : 36, fontWeight: FontWeight.bold)), const SizedBox(height: 8), TextButton.icon(onPressed: _requestPreciseLocation, icon: const Icon(Icons.my_location, size: 18, color: Color(0xFFDC143C)), label: Text("Konumumu hassaslaştır", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFDC143C)))), const SizedBox(height: 16), _isLocationLoading? const SizedBox(height: 240, child: Center(child: CircularProgressIndicator())) : _lat == null || _lng == null? const IlanAkisiSlider() : IlanAkisiSlider(ustaLat: _lat!, ustaLng: _lng!)]));
  }

  Widget _buildHizmetlerimizSection({required bool isMobile, required bool isTablet}) {
    return Padding(padding: EdgeInsets.symmetric(vertical: isMobile? 20 : 40), child: Column(children: [Text("Hizmetlerimiz", style: GoogleFonts.poppins(fontSize: isMobile? 26 : 36, fontWeight: FontWeight.bold)), const SizedBox(height: 32), const HizmetlerSlider()]));
  }

  Widget _buildFooter(BuildContext context, {required bool isMobile, required bool isTablet, required bool isDesktop}) {
    final hPad = isMobile? 16.0 : isTablet? 24.0 : 80.0;
    final firmaColumn = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(FIRMA_UNVANI, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text("Adres: $FIRMA_ADRES", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)), Text("Tel: $FIRMA_TELEFON | Mail: $FIRMA_MAIL", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)), Text("$FIRMA_VERGI_DAIRESI V.D. - VKN: $FIRMA_VERGI_NO", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12))]);
    final odemeColumn = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("GÜVENLİ ÖDEME", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Wrap(spacing: 10, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [Image.asset('assets/visa.png', height: 35, errorBuilder: (c, e, s) => _buildLogoPlaceholder("VISA")), Image.asset('assets/master.png', height: 35, errorBuilder: (c, e, s) => _buildLogoPlaceholder("Mastercard")), Image.asset('assets/troy.png', height: 35, errorBuilder: (c, e, s) => _buildLogoPlaceholder("TROY")), Image.asset('assets/iyzico.png', height: 35, errorBuilder: (c, e, s) => _buildLogoPlaceholder("Iyzico")), Image.asset('assets/3D_secure.png', height: 50, errorBuilder: (c, e, s) => _buildLogoPlaceholder("3D Secure"))]), const SizedBox(height: 8), Text("Tüm ödemeler 256 Bit SSL şifreleme ve 3D Secure doğrulaması ile güvenle gerçekleştirilir.", style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 10))]);
    final sozlesmeColumn = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SÖZLEŞMELER", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 8), _buildFooterLink(context, "Gizlilik Politikası", "gizlilik_politikasi"), _buildFooterLink(context, "Mesafeli Satış", "mesafeli_satis"), _buildFooterLink(context, "Kullanım Koşulları", "kullanim_kosullari"), _buildFooterLink(context, "İptal ve İade", "iptal_iade")]);
    final content = isDesktop? Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(flex: 3, child: firmaColumn), const SizedBox(width: 20), Expanded(flex: 3, child: odemeColumn), const SizedBox(width: 20), Expanded(flex: 2, child: sozlesmeColumn)]): Column(crossAxisAlignment: CrossAxisAlignment.start, children: [firmaColumn, const SizedBox(height: 20), odemeColumn, const SizedBox(height: 20), sozlesmeColumn]);
    return Container(width: double.infinity, color: const Color(0xFF1A1A1A), padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 32), child: Column(children: [content, const SizedBox(height: 24), const Divider(color: Color(0xFF444444)), const SizedBox(height: 16), Center(child: Text("© ${DateTime.now().year} $FIRMA_UNVANI. Tüm hakları saklıdır.", style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)))]));
  }

  Widget _buildLogoPlaceholder(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)));
  Widget _buildFooterLink(BuildContext context, String text, String documentId) => Padding(padding: const EdgeInsets.only(bottom: 4), child: InkWell(onTap: () => showSozlesmeDialog(context, documentId, text), child: Text(text, style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12, decoration: TextDecoration.underline))));
  void _showSelectionDialog(BuildContext context, bool isRegister) {
    showDialog(context: context, builder: (context) => AlertDialog(title: Text(isRegister? "Üyelik Tipi Seçin" : "Giriş Tipi Seçin"), content: Column(mainAxisSize: MainAxisSize.min, children: [ListTile(title: const Text("Usta Olarak"), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => isRegister? UstaKayitEkrani() : UstaGirisEkrani())); }), ListTile(title: const Text("Müşteri Olarak"), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => isRegister? MusteriKayitEkrani() : MusteriGirisEkrani())); })])));
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