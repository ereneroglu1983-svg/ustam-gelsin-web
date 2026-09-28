import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// lib/features/hug_market/theme/hug_market_theme.dart
// HUG MARKET - Canlı, Aktif, Dinamik ama Hemen Ustam Gelsin ailesinden

class HugMarketTheme {
  // Ana renkler - hemenustamgelsin yeşili korunuyor ama markete özel canlandı
  static const Color primary = Color(0xFF2DB34A); // Usta yeşili - güven
  static const Color primaryDark = Color(0xFF1E8A33);
  static const Color accent = Color(0xFFFF6B00); // Market turuncusu - aciliyet, canlı
  static const Color accentLight = Color(0xFFFF8F3D);

  static const Color darkBg = Color(0xFF0F172A); // Hero lacivert - premium
  static const Color lightBg = Color(0xFFFBF9F6); // Sıcak beyaz - soğuk değil
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color success = Color(0xFF2DB34A);

  // Canlı gradientler - aktif dinamik his
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient liveGradient = LinearGradient(
    colors: [Color(0xFF2DB34A), Color(0xFF1E8A33)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6B00), Color(0xFFFF8F3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFFFBF9F6), Color(0xFFFFF7ED), Color(0xFFFBF9F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text stilleri - Google Fonts ile canlı
  static TextStyle headingXl({Color color = textDark}) => GoogleFonts.poppins(
      fontSize: 36, fontWeight: FontWeight.w800, color: color, height: 1.1, letterSpacing: -0.5
  );
  static TextStyle headingLg({Color color = textDark}) => GoogleFonts.poppins(
      fontSize: 24, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.3
  );
  static TextStyle headingMd({Color color = textDark}) => GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w600, color: color
  );
  static TextStyle body({Color color = textMuted}) => GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w400, color: color, height: 1.5
  );
  static TextStyle bodyBold({Color color = textDark}) => GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w600, color: color
  );
  static TextStyle caption({Color color = textMuted}) => GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w500, color: color
  );
  static TextStyle price({Color color = textDark}) => GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w800, color: color
  );
  static TextStyle badge() => GoogleFonts.poppins(
      fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5
  );

  // Shadow - canlı ama abartısız
  static List<BoxShadow> cardShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4)),
  ];
  static List<BoxShadow> liveShadow = [
    BoxShadow(color: primary.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8)),
  ];

  // Border radius
  static const double radiusLg = 16;
  static const double radiusMd = 12;
  static const double radiusSm = 8;
  static const double radiusPill = 100;
}
