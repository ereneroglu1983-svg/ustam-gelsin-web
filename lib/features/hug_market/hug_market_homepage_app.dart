import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';
import 'package:ustam_gelsin/features/hug_market/widgets/hug_market_footer.dart';
import 'package:ustam_gelsin/features/hug_market/widgets/reklam_board_slider.dart';
import 'package:ustam_gelsin/features/hug_market/sepet_sayfasi.dart';
import 'package:ustam_gelsin/features/hug_market/siparis_takip_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_login.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_login.dart';
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

class HugMarketAppHomepage extends StatefulWidget {
  const HugMarketAppHomepage({super.key});
  @override
  State<HugMarketAppHomepage> createState() => _HugMarketAppHomepageState();
}

class _HugMarketAppHomepageState extends State<HugMarketAppHomepage> {
  final AuthService _authService = AuthService();

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Nasıl devam edelim?', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.person_outline, color: Colors.blue)),
            title: Text('Müşteri Olarak', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text('Alışveriş yap, sipariş ver', style: GoogleFonts.poppins(fontSize: 11)),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MusteriLoginPage(targetRole: 'musteri')));
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.handyman_outlined, color: Colors.orange)),
            title: Text('Usta Olarak', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text('Sepette %5 indirim kazan', style: GoogleFonts.poppins(fontSize: 11)),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaLoginPage(targetRole: 'usta')));
            },
          ),
        ]),
      ),
    );
  }

  Future<void> _goProfil() async {
    bool adminMi = await _authService.isAdmin();
    String? role = await _authService.getUserRole();
    if (!mounted) return;
    if (adminMi) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
    } else if (role == 'usta' || role == 'master') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaProfilSayfasi()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MusteriProfilSayfasi()));
    }
  }

  void _goSepet() => Navigator.push(context, MaterialPageRoute(builder: (_) => const SepetSayfasi()));

  void _goSiparisTakip() {
    if (_authService.currentUser == null) {
      _showLoginDialog();
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SiparisTakipSayfasi()));
  }

  void _goCozumOrtagi() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CozumOrtagiPage()));
  }

  void _goKategori(String file) {
    Widget? page;
    switch (file) {
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
      case 'cam_aluminyum.png': page = const CamAluminyumKategoriPage(); break;
      case 'kapi_kilit.png': page = const KapiKilitKategoriPage(); break;
      case 'guvenlik.png': page = const GuvenlikKategoriPage(); break;
      case 'asansor.png': page = const AsansorKategoriPage(); break;
    }
    if (page!= null) Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
  }

  @override
  Widget build(BuildContext context) {
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
              _buildAppBar(),
              _buildActionBar(isLoggedIn, displayName, uid),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHero(),
                    _buildKategoriBaslikCubugu(),
                    _buildCategories(),
                    _buildCozumOrtagiBanner(),
                    const HugMarketFooter(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 72,
      leadingWidth: 72,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5D6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8DCC0), width: 1),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF0F172A)),
            ),
          ),
        ),
      ),
      title: Center(
        child: Image.asset('assets/hug_market/hug_logo.png', height: 48, fit: BoxFit.contain),
      ),
      centerTitle: true,
      actions: const [SizedBox(width: 72)],
    );
  }

  Widget _buildActionBar(bool isLoggedIn, String displayName, String? uid) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _goSiparisTakip,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.inventory_2_rounded, size: 18, color: Color(0xFF0F172A)),
                      const SizedBox(width: 6),
                      Text('Siparişlerim', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: _buildSepetAction(uid)),
              const SizedBox(width: 8),
              Expanded(child: _buildProfilAction(isLoggedIn, displayName)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSepetAction(String? uid) {
    if (uid == null) {
      return InkWell(
        onTap: _goSepet,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(10)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.shopping_cart_rounded, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Text('Sepet', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
          ]),
        ),
      );
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('sepet').where('userId', isEqualTo: uid).snapshots(),
      builder: (context, snap) {
        int count = 0;
        if (snap.hasData) count = snap.data!.docs.length;
        return InkWell(
          onTap: _goSepet,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.shopping_cart_rounded, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Text('Sepet', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(20)),
                child: Text('$count', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildProfilAction(bool isLoggedIn, String displayName) {
    if (isLoggedIn) {
      return InkWell(
        onTap: _goProfil,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF0F172A))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.account_circle_rounded, size: 18, color: Color(0xFF0F172A)),
            const SizedBox(width: 4),
            Flexible(child: Text(displayName, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)))),
          ]),
        ),
      );
    } else {
      return InkWell(
        onTap: _showLoginDialog,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF0F172A))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.login_rounded, size: 18, color: Color(0xFF0F172A)),
            const SizedBox(width: 6),
            Text('Giriş Yap', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
          ]),
        ),
      );
    }
  }

  Widget _buildHero() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)])),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('İşin İçin Ne\nLazımsa,\nŞantiyene Gelsin.', style: GoogleFonts.poppins(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, height: 0.95)),
            const SizedBox(height: 8),
            Text('Yapı malzemelerinde yeni nesil satın alma.', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
          ]),
        ),
        Container(
          color: const Color(0xFFF1F5F9),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), clipBehavior: Clip.antiAlias, child: const ReklamBoardSlider()),
        ),
      ],
    );
  }

  Widget _buildKategoriBaslikCubugu() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFB91C1C),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: const Color(0xFFB91C1C).withOpacity(0.18), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Center(
        child: Text(
          'KATEGORİLER',
          style: GoogleFonts.poppins(
            color: const Color(0xFF0A0A0A),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.1, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: allCats.length,
        itemBuilder: (_, i) {
          final file = allCats[i]['file'] as String;
          return InkWell(
            onTap: () => _goKategori(file),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/hug_market/kategori/$file',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.white, child: Center(child: Text(allCats[i]['name'] as String, style: GoogleFonts.poppins(fontSize: 11)))),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCozumOrtagiBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: InkWell(
        onTap: _goCozumOrtagi,
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/hug_market/cozum_ortagi.png',
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              height: 110,
              decoration: BoxDecoration(color: const Color(0xFFFFF5D6), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE8DCC0))),
              child: Center(child: Text('assets/hug_market/cozum_ortagi.png bulunamadı', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54))),
            ),
          ),
        ),
      ),
    );
  }
}