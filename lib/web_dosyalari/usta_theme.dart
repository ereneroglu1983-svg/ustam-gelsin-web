// lib/web_dosyalari/usta_theme.dart

import 'package:flutter/material.dart';

class UstaTheme {
  // Renk Paleti Tanımları
  static const Color koyuArkaPlan = Color(0xFF0F0F0F);
  static const Color kartArkaPlan = Color(0xFF1A1A1A);
  static const Color anaTuruncu = Color(0xFFFF8C00);
  static const Color vurguTuruncu = Color(0xFFFFB347);
  static const Color griMetin = Color(0xFF9E9E9E);
  static const Color beyazMetin = Color(0xFFF5F5F5);

  static const Color kartGolgeRengi = Color(0x80000000);
  static const Color kartKenarlikRengi = Color(0x0DFFFFFF);
  static const Color inputArkaPlanRengi = Color(0x0DFFFFFF);
  static const Color inputKenarlikRengi = Color(0x1AFFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: anaTuruncu,
        secondary: vurguTuruncu,
        surface: kartArkaPlan,
        onPrimary: Colors.black,
        onSurface: beyazMetin,
      ),

      primaryColor: anaTuruncu,
      scaffoldBackgroundColor: koyuArkaPlan,

      appBarTheme: const AppBarTheme(
        backgroundColor: koyuArkaPlan,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: beyazMetin,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: beyazMetin),
      ),

      cardTheme: const CardThemeData(
        color: kartArkaPlan,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: kartGolgeRengi,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: kartKenarlikRengi, width: 1),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: inputArkaPlanRengi,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: inputKenarlikRengi),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: anaTuruncu, width: 1.5),
        ),
        hintStyle: TextStyle(color: griMetin, fontSize: 14),
      ),

      // Butonların Row içinde doğru boyutlanması için minimumSize ayarı
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: anaTuruncu,
          foregroundColor: Colors.black,
          elevation: 2,
          shadowColor: kartGolgeRengi,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: Size.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: beyazMetin, fontWeight: FontWeight.bold, fontSize: 22),
        titleLarge: TextStyle(color: beyazMetin, fontWeight: FontWeight.w600, fontSize: 18),
        bodyLarge: TextStyle(color: beyazMetin, fontSize: 16),
        bodyMedium: TextStyle(color: griMetin, fontSize: 14),
      ),
    );
  }

  static BoxDecoration get ustaArkaPlanDecor => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF1A1A1A),
        Color(0xFF0F0F0F),
      ],
    ),
  );
}