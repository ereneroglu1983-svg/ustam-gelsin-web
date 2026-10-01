import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';
import 'package:ustam_gelsin/features/hug_market/widgets/hug_market_footer.dart';
import 'package:ustam_gelsin/features/hug_market/widgets/reklam_board_slider.dart';
import 'package:ustam_gelsin/features/hug_market/sepet_sayfasi.dart';
import 'package:ustam_gelsin/features/hug_market/siparis_takip_sayfasi.dart';
import 'package:ustam_gelsin/features/admin/screens/admin_dashboard.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_profil_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';
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
import 'package:ustam_gelsin/features/hug_market/kategoriler/cam_aluminyum.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/kapi_kilit.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/guvenlik.dart';
import 'package:ustam_gelsin/features/hug_market/kategoriler/asansor.dart';
import 'package:ustam_gelsin/features/hug_market/cozum_ortagi_page.dart';
import 'package:ustam_gelsin/web_dosyalari/musteri_kayit_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/usta_kayit_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/musteri_giris_ekrani.dart';
import 'package:ustam_gelsin/web_dosyalari/usta_giris_ekrani.dart';
import 'package:url_launcher/url_launcher.dart';

class HugMarketHomepage extends StatefulWidget {
  const HugMarketHomepage({super.key});
  @override
  State<HugMarketHomepage> createState() => _HugMarketHomepageState();
}

class _HugMarketHomepageState extends State<HugMarketHomepage> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _isProfileLoading = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showSelectionDialog(BuildContext context, bool isRegister) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isRegister? "Üyelik Tipi Seçin" : "Giriş Tipi Seçin", style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.person_outline, color: Colors.blue),
              ),
              title: Text("Müşteri Olarak", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text(isRegister? "Hemen alışverişe başla" : "Alışveriş yap, sipariş ver", style: GoogleFonts.poppins(fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_)=> isRegister? MusteriKayitEkrani() : MusteriGirisEkrani()));
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.handyman_outlined, color: Colors.orange),
              ),
              title: Text("Usta Olarak", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text("Sepette %5 indirim kazan", style: GoogleFonts.poppins(fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_)=> isRegister? UstaKayitEkrani() : UstaGirisEkrani()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goProfil() async {
    setState(()=> _isProfileLoading = true);
    bool adminMi = await _authService.isAdmin();
    String? role = await _authService.getUserRole();
    if (!mounted) return;
    setState(()=> _isProfileLoading = false);
    if (adminMi) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
    } else if (role == 'usta' || role == 'master') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaProfilSayfasi()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MusteriProfilSayfasi()));
    }
  }

  void _goSepet() => context.push('/hug-market/sepet');

  void _goSiparisTakip() {
    if (_authService.currentUser == null) {
      _showSelectionDialog(context, false);
      return;
    }
    context.push('/hug-market/siparis-takip');
  }

  void _goCozumOrtagi() => context.push('/hug-market/cozum-ortagi');

  void _goKategori(String file) {
    final slugMap = {
      'banyo_mutfak.webp': 'banyo-mutfak',
      'temizlik.webp': 'temizlik',
      'elektrik.webp': 'elektrik',
      'hirdavat.webp': 'hirdavat',
      'peyzaj.webp': 'peyzaj',
      'tesisat_su.webp': 'tesisat-su',
      'yapi_malzemeleri.webp': 'yapi-malzemeleri',
      'boya_dekarasyon.webp': 'boya-dekorasyon',
      'cati.webp': 'cati-cephe',
      'havuz_spa.webp': 'havuz-spa',
      'iklimlendirme.webp': 'iklimlendirme',
      'seramik_fayans.webp': 'seramik-fayans',
      'yalitim.webp': 'yalitim-izolasyon',
      'yenilenebilir.webp': 'yenilenebilir-enerji',
      'cam_aluminyum.png': 'cam-aluminyum',
      'kapi_kilit.png': 'kapi-kilit',
      'guvenlik.png': 'guvenlik-yangin-zayif-akim',
      'asansor.png': 'asansor-yuruyen-merdiven',
    };
    final slug = slugMap[file];
    if (slug!= null) {
      context.push('/hug-market/kategori/$slug');
    }
  }

  Future<void> _onBack() async {
    if (kIsWeb) {
      context.go('/');
    } else {
      if (Navigator.canPop(context)) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isMobile = w < 700;
        final isTablet = w >= 700 && w < 1100;
        final isDesktop = w >= 1100;

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snap) {
            final isLoggedIn = snap.data!= null;
            final displayName = snap.data?.email?.split('@').first?? 'Hesabım';
            final uid = snap.data?.uid;

            return Scaffold(
              backgroundColor: HugMarketTheme.lightBg,
              body: CustomScrollView(
                slivers: [
                  _buildAppBar(isDesktop: isDesktop, isMobile: isMobile),
                  _buildActionBar(isLoggedIn, displayName, uid, isDesktop: isDesktop),
                  if (!isDesktop) _buildSearchBar(),
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: Column(
                          children: [
                            _buildHero(isDesktop: isDesktop, isMobile: isMobile, isTablet: isTablet),
                            _buildKategoriBaslikCubugu(isDesktop: isDesktop),
                            _buildCategories(isDesktop: isDesktop, isTablet: isTablet, isMobile: isMobile),
                            _buildCozumOrtagiBanner(isDesktop: isDesktop),
                            const SizedBox(height: 24),
                            const HugMarketFooter(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAppBar({required bool isDesktop, required bool isMobile}) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: isDesktop? 64 : 72,
      leadingWidth: 72,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: InkWell(
            onTap: _onBack,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5D6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8DCC0), width: 1),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF0F172A)),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Image.asset('assets/hug_market/hug_logo.png', height: isDesktop? 40 : 48, fit: BoxFit.contain),
          if (isDesktop) const SizedBox(width: 24),
          if (isDesktop)
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchCtrl,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: '🔍 Ara... boya, fayans, tesisat',
                    hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                    prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                    suffixIcon: _searchQuery.isNotEmpty? IconButton(icon: const Icon(Icons.clear, size: 16), onPressed: () => _searchCtrl.clear()) : null,
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1)),
                  ),
                ),
              ),
            ),
        ],
      ),
      centerTitle:!isDesktop,
      actions: const [SizedBox(width: 12)],
    );
  }

  Widget _buildActionBar(bool isLoggedIn, String displayName, String? uid, {required bool isDesktop}) {
    final pad = isDesktop? 32.0 : 12.0;
    return SliverToBoxAdapter(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(pad, 0, pad, 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: isDesktop? 6 : 8),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: isLoggedIn
                  ? Row(
                children: [
                  Expanded(child: InkWell(onTap: _goSiparisTakip, borderRadius: BorderRadius.circular(8), child: Container(padding: EdgeInsets.symmetric(vertical: isDesktop? 8 : 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.inventory_2_rounded, size: isDesktop? 16 : 18, color: const Color(0xFF0F172A)), const SizedBox(width: 6), Text('Siparişlerim', style: GoogleFonts.poppins(fontSize: isDesktop? 10.5 : 11, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)))])))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSepetAction(uid, isDesktop: isDesktop)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildProfilActionLoggedIn(displayName, isDesktop: isDesktop)),
                ],
              )
                  : Row(
                children: [
                  Expanded(child: InkWell(onTap: _goSiparisTakip, borderRadius: BorderRadius.circular(8), child: Container(padding: EdgeInsets.symmetric(vertical: isDesktop? 8 : 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.inventory_2_rounded, size: isDesktop? 16 : 18, color: const Color(0xFF0F172A)), const SizedBox(width: 6), Text('Siparişlerim', style: GoogleFonts.poppins(fontSize: isDesktop? 10.5 : 11, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)))])))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSepetAction(uid, isDesktop: isDesktop)),
                  const SizedBox(width: 8),
                  Expanded(child: InkWell(onTap: ()=> _showSelectionDialog(context, true), borderRadius: BorderRadius.circular(8), child: Container(padding: EdgeInsets.symmetric(vertical: isDesktop? 8 : 10), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)), child: Center(child: Text('Üye Ol', style: GoogleFonts.poppins(fontSize: isDesktop? 10.5 : 11, fontWeight: FontWeight.w700, color: Colors.white)))))),
                  const SizedBox(width: 8),
                  Expanded(child: InkWell(onTap: ()=> _showSelectionDialog(context, false), borderRadius: BorderRadius.circular(8), child: Container(padding: EdgeInsets.symmetric(vertical: isDesktop? 8 : 10), decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(8)), child: Center(child: Text('GİRİŞ YAP', style: GoogleFonts.poppins(fontSize: isDesktop? 10.5 : 11, fontWeight: FontWeight.w700, color: Colors.white)))))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchCtrl,
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: '🔍 Ara... boya, fayans, tesisat',
                  hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                  suffixIcon: _searchQuery.isNotEmpty? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () => _searchCtrl.clear()) : null,
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.2)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSepetAction(String? uid, {required bool isDesktop}) {
    final vPad = isDesktop? 8.0 : 10.0;
    final fSize = isDesktop? 10.5 : 11.0;
    if (uid == null) {
      return InkWell(onTap: _goSepet, borderRadius: BorderRadius.circular(8), child: Container(padding: EdgeInsets.symmetric(vertical: vPad), decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shopping_cart_rounded, size: isDesktop? 16 : 18, color: Colors.white), const SizedBox(width: 6), Text('Sepet', style: GoogleFonts.poppins(fontSize: fSize, fontWeight: FontWeight.w700, color: Colors.white))])));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('sepet').where('userId', isEqualTo: uid).snapshots(),
      builder: (context, snap) {
        int count = 0;
        if (snap.hasData) count = snap.data!.docs.length;
        return InkWell(onTap: _goSepet, borderRadius: BorderRadius.circular(8), child: Container(padding: EdgeInsets.symmetric(vertical: vPad), decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shopping_cart_rounded, size: isDesktop? 16 : 18, color: Colors.white), const SizedBox(width: 6), Text('Sepet', style: GoogleFonts.poppins(fontSize: fSize, fontWeight: FontWeight.w700, color: Colors.white)), const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(20)), child: Text('$count', style: GoogleFonts.poppins(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)))])));
      },
    );
  }

  Widget _buildProfilActionLoggedIn(String displayName, {required bool isDesktop}) {
    final vPad = isDesktop? 8.0 : 10.0;
    final fSize = isDesktop? 10.5 : 11.0;
    return InkWell(
      onTap: _isProfileLoading? null : _goProfil,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: vPad),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF0F172A))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isProfileLoading) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            else Icon(Icons.account_circle_rounded, size: isDesktop? 16 : 18, color: const Color(0xFF0F172A)),
            const SizedBox(width: 4),
            Flexible(child: Text(_isProfileLoading? "..." : displayName, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: fSize, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)))),
          ],
        ),
      ),
    );
  }

  Widget _buildHero({required bool isDesktop, required bool isMobile, required bool isTablet}) {
    final textPart = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('İşin İçin Ne\nLazımsa,\nŞantiyene Gelsin.', style: GoogleFonts.poppins(color: Colors.white, fontSize: isDesktop? 36 : isMobile? 28 : 32, fontWeight: FontWeight.w900, height: 0.95)), const SizedBox(height: 10), Text('Yapı malzemelerinde yeni nesil satın alma.', style: GoogleFonts.poppins(color: Colors.white70, fontSize: isDesktop? 13 : 12))]);
    final slider = Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), clipBehavior: Clip.antiAlias, child: const ReklamBoardSlider());
    if (isDesktop) {
      return Container(width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)])), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28), child: Row(children: [Expanded(flex: 5, child: textPart), const SizedBox(width: 28), Expanded(flex: 7, child: ConstrainedBox(constraints: const BoxConstraints(maxHeight: 320), child: slider))]));
    }
    return Column(children: [Container(width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)])), padding: const EdgeInsets.all(20), child: textPart), Container(color: const Color(0xFFF1F5F9), padding: const EdgeInsets.all(16), child: slider)]);
  }

  Widget _buildKategoriBaslikCubugu({required bool isDesktop}) {
    return Container(width: double.infinity, margin: EdgeInsets.fromLTRB(isDesktop? 32 : 16, 12, isDesktop? 32 : 16, 0), height: isDesktop? 28 : 32, decoration: BoxDecoration(color: const Color(0xFFB91C1C), borderRadius: BorderRadius.circular(8)), child: Center(child: Text('KATEGORİLER', style: GoogleFonts.poppins(color: const Color(0xFF0A0A0A), fontSize: isDesktop? 11 : 12, fontWeight: FontWeight.w800, letterSpacing: 1.0))));
  }

  Widget _buildCategories({required bool isDesktop, required bool isTablet, required bool isMobile}) {
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
      {'name': 'cam aluminyum', 'file': 'cam_aluminyum.png'},
      {'name': 'kapi kilit', 'file': 'kapi_kilit.png'},
      {'name': 'guvenlik', 'file': 'guvenlik.png'},
      {'name': 'asansor', 'file': 'asansor.png'},
    ];
    final filtered = _searchQuery.isEmpty? allCats : allCats.where((c) => (c['name'] as String).toLowerCase().contains(_searchQuery)).toList();
    final cross = isDesktop? 4 : isTablet? 3 : 2;
    final aspect = isDesktop? 2.55 : isTablet? 2.45 : 2.35;
    final pad = isDesktop? 32.0 : 16.0;
    return Padding(padding: EdgeInsets.all(pad), child: GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cross, childAspectRatio: aspect, crossAxisSpacing: 14, mainAxisSpacing: 14), itemCount: filtered.length, itemBuilder: (_, i) {
      final file = filtered[i]['file'] as String;
      return InkWell(onTap: () => _goKategori(file), borderRadius: BorderRadius.circular(12), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/hug_market/kategori/$file', fit: BoxFit.cover, width: double.infinity, height: double.infinity, alignment: Alignment.center, errorBuilder: (c, e, s) => Container(color: Colors.white, child: Center(child: Text(filtered[i]['name'] as String, style: GoogleFonts.poppins(fontSize: 11)))))));
    }));
  }

  Widget _buildCozumOrtagiBanner({required bool isDesktop}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isDesktop? 32 : 16, 8, isDesktop? 32 : 16, 16),
      child: InkWell(
        onTap: _goCozumOrtagi,
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset('assets/hug_market/cozum_ortagi.png', width: double.infinity, fit: BoxFit.fitWidth, errorBuilder: (c, e, s) => Container(height: 110, decoration: BoxDecoration(color: const Color(0xFFFFF5D6), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE8DCC0))), child: Center(child: Text('assets/hug_market/cozum_ortagi.png bulunamadı', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54))))),
        ),
      ),
    );
  }
}