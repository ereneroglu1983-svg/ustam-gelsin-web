import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinished;
  const SplashScreen({super.key, this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _shimmerController;
  final List<bool> _visible = List.filled(6, false);

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    _shimmerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    for (int i = 0; i < _visible.length; i++) {
      await Future.delayed(Duration(milliseconds: i == 0? 300 : 480));
      if (!mounted) return;
      setState(() => _visible[i] = true);
    }
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    widget.onFinished?.call();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Üstten hafif yeşil radial glow - premium his
          Positioned(
            top: -180,
            left: -80,
            right: -80,
            child: Container(
              height: 380,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.1,
                  colors: [
                    const Color(0xFF2DB34A).withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _anim(0, _slogan()),
                  const SizedBox(height: 34),
                  _anim(1, _logoPro()),
                  const SizedBox(height: 22),
                  _anim(2, _titlePro()),
                  const SizedBox(height: 52),
                  _anim(3, _featurePro(icon: Icons.bolt_rounded, title: "Ücretsiz İlan Oluştur", subtitle: "30 saniyede, komisyonsuz")),
                  const SizedBox(height: 12),
                  _anim(4, _featurePro(icon: Icons.auto_awesome_rounded, title: "Yapay Zekâ Maliyet Hesabı", subtitle: "Fotoğraftan anında fiyat tahmini")),
                  const SizedBox(height: 12),
                  _anim(5, _featurePro(icon: Icons.verified_rounded, title: "Doğrulanmış Ustalar", subtitle: "Puanlı, belgeli, güvenilir")),
                  const SizedBox(height: 56),
                  _anim(5, _bottomLoader()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _slogan() {
    return Column(
      children: [
        Text("Aradığın usta,", style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w800, height: 1.15, color: const Color(0xFF111111), letterSpacing: -0.5)),
        const SizedBox(height: 2),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFFE53935), Color(0xFFFF6B6B)]).createShader(bounds),
          child: Text("bir tık uzağında!", style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w800, height: 1.15, color: Colors.white, letterSpacing: -0.5)),
        ),
      ],
    );
  }

  Widget _titlePro() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 18, height: 2, decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 10),
            Text("HEMEN USTAM GELSİN", style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w800, letterSpacing: 2.2, color: const Color(0xFF8A8A8A))),
            const SizedBox(width: 10),
            Container(width: 18, height: 2, decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2))),
          ],
        ),
      ],
    );
  }

  Widget _logoPro() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        double scale = 0.98 + (_logoController.value * 0.06);
        return Transform.scale(scale: scale, child: child);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 148, height: 148,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: const Color(0xFF2DB34A).withValues(alpha: 0.22), blurRadius: 36, spreadRadius: 4),
                BoxShadow(color: const Color(0xFF2DB34A).withValues(alpha: 0.10), blurRadius: 80, spreadRadius: 18),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFF1F1F1)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/app_logo.png', width: 108, height: 108, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 108, height: 108, color: const Color(0xFFF7F7F7), child: const Icon(Icons.handyman_rounded, size: 44, color: Color(0xFF2DB34A)))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featurePro({required IconData icon, required String title, required String subtitle}) {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2ECC71), Color(0xFF27AE60)]),
            ),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A))),
              const SizedBox(height: 1),
              Text(subtitle, style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w500, color: const Color(0xFF8E8E8E))),
            ]),
          ),
          const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF2DB34A)),
        ],
      ),
    );
  }

  Widget _bottomLoader() {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, _) => LinearProgressIndicator(
              value: _shimmerController.value,
              backgroundColor: const Color(0xFFF0F0F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2DB34A)),
              minHeight: 3,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 10),
          Text("USTALAR HAZIRLANIYOR...", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.6, color: const Color(0xFFB0B0B0))),
        ],
      ),
    );
  }

  Widget _anim(int i, Widget child) {
    final v = _visible[i];
    return AnimatedOpacity(
      opacity: v? 1 : 0,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: v? Offset.zero : const Offset(0, 0.18),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}