// lib/features/home/screens/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _shineController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _shineAnimation;

  bool showTitle = false;
  bool showLogo = false;
  bool showBrand = false;
  bool show1 = false;
  bool show2 = false;
  bool show3 = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    // SİNEMATİK AKIŞ - SÜRELER UZATILDI
    Timer(const Duration(milliseconds: 200), () => setState(() => showTitle = true));
    Timer(const Duration(milliseconds: 700), () => setState(() => showLogo = true));
    Timer(const Duration(milliseconds: 1200), () => setState(() => showBrand = true));

    Timer(const Duration(milliseconds: 1800), () => setState(() => show1 = true));
    Timer(const Duration(milliseconds: 2600), () => setState(() => show2 = true));
    Timer(const Duration(milliseconds: 3400), () => setState(() => show3 = true));

    Timer(const Duration(milliseconds: 4800), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  Widget tickItem(bool visible, String text, int index) {
    return AnimatedOpacity(
      opacity: visible? 1 : 0,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: visible? Offset.zero : const Offset(0, 0.6),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: visible? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: visible
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ]
                : [],
            border: Border.all(
              color: visible? const Color(0xFFEEEEEE) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C853), Color(0xFF2DB34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C853).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BAŞLIK - SENİN HOMESCREEN AYARINLA AYNI
              AnimatedOpacity(
                opacity: showTitle? 1 : 0,
                duration: const Duration(milliseconds: 800),
                child: AnimatedSlide(
                  offset: showTitle? Offset.zero : const Offset(0, -0.3),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Aradığın usta,\n",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextSpan(
                          text: "bir tık uzağında!",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFE53935),
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // LOGO - GELİŞMİŞ ANİMASYON
              AnimatedOpacity(
                opacity: showLogo? 1 : 0,
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOut,
                child: AnimatedScale(
                  scale: showLogo? 1.0 : 0.6,
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.elasticOut,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow efekti
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2DB34A).withOpacity(0.15),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        // Logo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.asset(
                            'assets/app_logo.png',
                            width: 135,
                            height: 135,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // MARKA ADI
              AnimatedOpacity(
                opacity: showBrand? 1 : 0,
                duration: const Duration(milliseconds: 700),
                child: AnimatedSlide(
                  offset: showBrand? Offset.zero : const Offset(0, 0.3),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  child: Column(
                    children: [
                      Text(
                        "HEMEN USTAM GELSİN",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 52),

              // TICK'LER
              tickItem(show1, "Ücretsiz İlan Oluştur", 1),
              const SizedBox(height: 14),
              tickItem(show2, "Yapay Zekâ Maliyet Hesabı", 2),
              const SizedBox(height: 14),
              tickItem(show3, "Doğrulanmış Ustalar", 3),

              const SizedBox(height: 60),

              // Loading dots
              AnimatedOpacity(
                opacity: show3? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 400 + (index * 150)),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: show3? const Color(0xFF2DB34A) : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}