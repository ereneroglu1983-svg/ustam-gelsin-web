import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';
import 'package:ustam_gelsin/features/hug_market/widgets/hug_market_footer.dart';
import 'package:ustam_gelsin/features/hug_market/widgets/reklam_board_slider.dart';
import 'package:ustam_gelsin/features/hug_market/sepet_sayfasi.dart';
import 'package:ustam_gelsin/features/hug_market/siparis_takip_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens//musteri_login.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_login.dart';
import 'package:ustam_gelsin/features/admin/screens/admin_dashboard.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_profil_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';

// KATEGORİ İMPORTLARI - 14 ADET - KILAVUZ KOD İÇİN
import 'package:ustam_gelsin/features/hug_market/kategoriler/mutfak_banyo.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/temizlik.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/elektrik.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/hirdavat.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/peyzaj.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/su_tesisat.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/yapi_malzemeleri.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/boya.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/cati.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/havuz.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/iklimlendirme.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/seramik.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/yalitim.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/yenilenebilir.dart';

class HugMarketHomepage extends StatefulWidget {
  const HugMarketHomepage({super.key});
  @override State<HugMarketHomepage> createState() => _HugMarketHomepageState();
}

class _HugMarketHomepageState extends State<HugMarketHomepage> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  int _sepetCount = 0;

  @override void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _searchCtrl.addListener(() => setState(() => _searchQuery = _searchCtrl.text.toLowerCase()));
  }

  @override void dispose() { _pulseController.dispose(); _searchCtrl.dispose(); super.dispose(); }

  void _showLoginDialog() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Nasıl devam edelim?', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.person_outline, color: Colors.blue)),
          title: Text('Müşteri Olarak', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          subtitle: Text('Alışveriş yap, sipariş ver', style: GoogleFonts.poppins(fontSize: 11)),
          onTap: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const MusteriLoginPage(targetRole: 'musteri'))); },
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.handyman_outlined, color: Colors.orange)),
          title: Text('Usta Olarak', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          subtitle: Text('Sepette %5 indirim kazan', style: GoogleFonts.poppins(fontSize: 11)),
          onTap: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaLoginPage(targetRole: 'usta'))); },
        ),
      ]),
    ));
  }

  void _goProfil() async {
    bool adminMi = await _authService.isAdmin();
    String? role = await _authService.getUserRole();
    if (!mounted) return;
    if (adminMi) { Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboard())); }
    else if (role == 'usta' || role == 'master') { Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaProfilSayfasi())); }
    else { Navigator.push(context, MaterialPageRoute(builder: (_) => const MusteriProfilSayfasi())); }
  }

  void _goSepet() { Navigator.push(context, MaterialPageRoute(builder: (_) => const SepetSayfasi())); }
  void _goSiparisTakip() {
    if (_authService.currentUser == null) { _showLoginDialog(); return; }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SiparisTakipSayfasi()));
  }

  void _goKategori(String file) {
    Widget? page;
    switch(file){
      case 'banyo_mutfak.webp': page = const MutfakBanyoKategoriPage(); break;
      case 'temizlik.webp': page = const TemizlikKategoriPage(); break;
      case 'elektrik.webp': page = const ElektrikKategoriPage(); break;
      case 'hirdavat.webp': page = const HirdavatKategoriPage(); break;
      case 'peyzaj.webp': page = const PeyzajKategoriPage(); break;
      case 'tesisat_su.webp': page = const TesisatKategoriPage(); break;
      case 'yapi_malzemeleri.webp': page = const YapiMalzemeleriKategoriPage(); break;
      case 'boya_dekarasyon.webp': page = const BoyaDekorasyonKategoriPage(); break;
      case 'cati.webp': page = const CatiCepheKategoriPage(); break;
      case 'havuz_spa.webp': page = const HavuzSpaKategoriPage(); break;
      case 'iklimlendirme.webp': page = const IsitmaSogutmaKategoriPage(); break;
      case 'seramik_fayans.webp': page = const SeramikFayansKategoriPage(); break;
      case 'yalitim.webp': page = const YalitimIzolasyonKategoriPage(); break;
      case 'yenilenebilir.webp': page = const YenilenebilirEnerjiKategoriPage(); break;
    }
    if(page!=null) Navigator.push(context, MaterialPageRoute(builder: (_)=> page!));
  }

  @override Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final isMobile = w < 600;
      final isTablet = w >= 600 && w < 1100;
      final isDesktop = w >= 1100;

      return StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snap) {
        final isLoggedIn = snap.data!= null;
        final user = snap.data;
        final displayName = user?.email?.split('@').first?? 'Hesabım';

        Widget topBar;
        if (kIsWeb) {
          topBar = _buildWebTopBar(isLoggedIn, displayName, isMobile: isMobile, isTablet: isTablet, isDesktop: isDesktop);
        } else {
          topBar = _buildAppTopBar(isLoggedIn, displayName, isMobile: isMobile);
        }

        final bodyContent = Column(children: [
          _buildHero(isMobile: isMobile, isTablet: isTablet, isDesktop: isDesktop),
          _buildTrustStrip(isMobile: isMobile, isTablet: isTablet, isDesktop: isDesktop),
          _buildLiveStats(isMobile: isMobile),
          _buildCategories(isMobile: isMobile, isTablet: isTablet, isDesktop: isDesktop),
          _buildSponsorBanner(isMobile: isMobile),
          const HugMarketFooter(),
        ]);

        if (kIsWeb) {
          return Scaffold(backgroundColor: const Color(0xFFF1F5F9), body: ScrollConfiguration(behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad, PointerDeviceKind.stylus}), child: SingleChildScrollView(child: Column(children: [topBar, bodyContent]))));
        }
        return Scaffold(backgroundColor: HugMarketTheme.lightBg, body: CustomScrollView(slivers: [topBar, SliverToBoxAdapter(child: bodyContent)]));
      });
    });
  }

  Widget _buildAppTopBar(bool isLoggedIn, String displayName, {required bool isMobile}) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 76,
      titleSpacing: 12,
      title: Image.asset('assets/hug_market/hug_logo.png', height: 52, fit: BoxFit.contain),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(108),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
          child: Column(children: [
            SizedBox(height: 46, child: TextField(
              controller: _searchCtrl,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF0F172A)),
              cursorColor: const Color(0xFF0F172A),
              decoration: InputDecoration(
                hintText: '🔍 Ara... boya, fayans, tesisat',
                hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.2)),
              ),
            )),
            const SizedBox(height: 10),
            Row(children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF0F172A), side: const BorderSide(color: Color(0xFFCBD5E1)), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: _goSiparisTakip,
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                label: Text('Sipariş Takip', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _goSepet,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    const Icon(Icons.shopping_basket_outlined, size: 18, color: Colors.white),
                    const SizedBox(width: 6),
                    Text('Sepet', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(width: 6),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(20)), child: Text('$_sepetCount', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))),
                  ]),
                ),
              ),
              const Spacer(),
              if (isLoggedIn)
                InkWell(
                  onTap: _goProfil,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [const Icon(Icons.person_outline, size: 16, color: Colors.white), const SizedBox(width: 6), Text(displayName, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))]),
                  ),
                )
              else
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF0F172A)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: _showLoginDialog,
                  icon: const Icon(Icons.login, size: 16),
                  label: Text('Giriş Yap', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12)),
                ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _buildWebTopBar(bool isLoggedIn, String displayName, {required bool isMobile, required bool isTablet, required bool isDesktop}) {
    final hPad = isMobile? 16.0 : isTablet? 24.0 : 40.0;
    final logoHeight = isDesktop? 62.0 : isTablet? 54.0 : 52.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))]
      ),
      child: Column(children: [
        Row(children: [
          Image.asset('assets/hug_market/hug_logo.png', height: logoHeight, fit: BoxFit.contain),
          if (isDesktop) const SizedBox(width: 20),
          if (isDesktop) Expanded(child: SizedBox(height: 46, child: TextField(
            controller: _searchCtrl,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF0F172A)),
            cursorColor: const Color(0xFF0F172A),
            decoration: InputDecoration(
              hintText: '🔍 Kategorilerde ara... boya, fayans, tesisat',
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0F172A))),
            ),
          ))),
          const SizedBox(width: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF0F172A), side: const BorderSide(color: Color(0xFFCBD5E1)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: _goSiparisTakip,
            icon: const Icon(Icons.receipt_long_outlined, size: 18),
            label: Text('Sipariş Takip', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _goSepet,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.shopping_basket_outlined, size: 20, color: Colors.white),
                const SizedBox(width: 8),
                Text('Sepet', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(20)), child: Text('$_sepetCount', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))),
              ]),
            ),
          ),
          const SizedBox(width: 12),
          if (isLoggedIn)
            FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), onPressed: _goProfil, icon: const Icon(Icons.person_outline, size: 18), label: Text(displayName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12)))
          else
            OutlinedButton.icon(style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF0F172A)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), onPressed: _showLoginDialog, icon: const Icon(Icons.login, size: 18), label: Text('Giriş Yap / Profilim', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12))),
        ]),
        if (!isDesktop) const SizedBox(height: 10),
        if (!isDesktop) Row(children: [
          Expanded(child: SizedBox(height: 46, child: TextField(
            controller: _searchCtrl,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF0F172A)),
            cursorColor: const Color(0xFF0F172A),
            decoration: InputDecoration(
              hintText: '🔍 Ara...',
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0F172A))),
            ),
          ))),
        ]),
      ]),
    );
  }

  Widget _buildHero({required bool isMobile, required bool isTablet, required bool isDesktop}) {
    final heroText = Column(crossAxisAlignment: isMobile? CrossAxisAlignment.center : CrossAxisAlignment.start, children: [
      Wrap(spacing: 8, alignment: isMobile? WrapAlignment.center : WrapAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(20)), child: Text('ŞANTİYEYE TESLİM • 3 İŞ GÜNÜ', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(20)), child: Text('81 il 973 ilçeye', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)))]),
      const SizedBox(height: 18),
      Text('İşin İçin Ne\nLazımsa,\nŞantiyene Gelsin.', textAlign: isMobile? TextAlign.center : TextAlign.start, style: GoogleFonts.poppins(color: Colors.white, fontSize: isMobile? 32 : isTablet? 38 : 46, fontWeight: FontWeight.w900, height: 0.95)),
      const SizedBox(height: 12),
      Text('Yapı malzemelerinde yeni nesil satın alma.', textAlign: isMobile? TextAlign.center : TextAlign.start, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
    ]);
    final slider = Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), clipBehavior: Clip.antiAlias, child: const ReklamBoardSlider());
    if (isMobile) { return Column(children: [Container(width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)])), padding: const EdgeInsets.all(20), child: heroText), Container(color: const Color(0xFFF1F5F9), padding: const EdgeInsets.all(16), child: slider)]); }
    return Container(width: double.infinity, color: const Color(0xFF0F172A), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1300), child: Padding(padding: EdgeInsets.all(isTablet? 24 : 32), child: Row(children: [Expanded(flex: 5, child: heroText), const SizedBox(width: 24), Expanded(flex: 6, child: ConstrainedBox(constraints: const BoxConstraints(maxHeight: 400), child: slider))])))));
  }

  Widget _buildTrustStrip({required bool isMobile, required bool isTablet, required bool isDesktop}) => Container(margin: EdgeInsets.symmetric(horizontal: isMobile? 16 : 32, vertical: 16), padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16)]), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_trustItem(Icons.local_shipping_outlined, 'Şantiyeye Teslim', '3 iş günü'), _trustItem(Icons.discount_outlined, '%5 İndirim', 'Ustalara özel'), if (!isMobile) _trustItem(Icons.verified_outlined, 'Faturalı & Garantili', 'Güvenli alışveriş'), if (!isMobile) _trustItem(Icons.bolt_outlined, 'Canlı Stok', 'Anlık takip')]));
  Widget _trustItem(IconData i, String t, String d) => Column(children: [Icon(i, color: const Color(0xFFDC143C), size: 20), const SizedBox(height: 4), Text(t, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 11)), Text(d, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey))]);

  Widget _buildLiveStats({required bool isMobile}) => Container(
    margin: EdgeInsets.symmetric(horizontal: isMobile? 16 : 32, vertical: 6),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Row(children: [const Icon(Icons.public, size: 16, color: Color(0xFF0F172A)), const SizedBox(width: 6), Text('81 İl 973 İlçe', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 12))]),
      Container(width: 1, height: 20, color: const Color(0xFFE2E8F0)),
      Row(children: [const Icon(Icons.receipt_long_outlined, size: 16, color: Color(0xFF0F172A)), const SizedBox(width: 6), Text('Faturalı & Garantili', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 12))]),
      Container(width: 1, height: 20, color: const Color(0xFFE2E8F0)),
      Row(children: [const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFFDC143C)), const SizedBox(width: 6), Text('3 İş Gününde Teslim', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 12, color: Color(0xFFDC143C)))]),
    ]),
  );

  Widget _buildCategories({required bool isMobile, required bool isTablet, required bool isDesktop}) {
    final allCats = [
      {'name': 'banyo mutfak', 'file': 'banyo_mutfak.webp'},
      {'name': 'temizlik', 'file': 'temizlik.webp'},
      {'name': 'elektrik', 'file': 'elektrik.webp'},
      {'name': 'hirdavat', 'file': 'hirdavat.webp'},
      {'name': 'peyzaj', 'file': 'peyzaj.webp'},
      {'name': 'tesisat su', 'file': 'tesisat_su.webp'},
      {'name': 'yapi malzemeleri', 'file': 'yapi_malzemeleri.webp'},
      {'name': 'boya dekorasyon', 'file': 'boya_dekarasyon.webp'},
      {'name': 'cati', 'file': 'cati.webp'},
      {'name': 'havuz spa', 'file': 'havuz_spa.webp'},
      {'name': 'iklimlendirme', 'file': 'iklimlendirme.webp'},
      {'name': 'seramik fayans', 'file': 'seramik_fayans.webp'},
      {'name': 'yalitim', 'file': 'yalitim.webp'},
      {'name': 'yenilenebilir', 'file': 'yenilenebilir.webp'},
    ];

    final filtered = _searchQuery.isEmpty? allCats : allCats.where((c) => (c['name'] as String).toLowerCase().contains(_searchQuery)).toList();

    return Padding(
      padding: EdgeInsets.all(isMobile? 16 : 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Kategoriler${_searchQuery.isEmpty? '' : ' • "$_searchQuery"'}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile? 2 : isTablet? 3 : 4,
              childAspectRatio: 2.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12
          ),
          itemCount: filtered.length,
          itemBuilder: (_, i) {
            final file = filtered[i]['file'] as String;
            return InkWell(
              onTap: ()=> _goKategori(file),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/hug_market/kategori/$file',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (c, e, s) => Container(color: Colors.white, child: Center(child: Text(filtered[i]['name'] as String, style: GoogleFonts.poppins(fontSize: 11)))),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  Widget _buildSponsorBanner({required bool isMobile}) => Container(margin: EdgeInsets.all(isMobile? 16 : 32), padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]), borderRadius: BorderRadius.circular(16)), child: Row(children: [Expanded(child: Text('Markanız Burada Yer Alabilir', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800))), FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black), onPressed: () {}, child: const Text('Sponsor Ol'))]));
}
