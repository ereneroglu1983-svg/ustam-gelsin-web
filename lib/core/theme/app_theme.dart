// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppColors {
  // --- MÜŞTERİ / GENEL KOYU GRADYAN ---
  static const Color primaryGradientStart = Color(0xFF0F2027);
  static const Color primaryGradientMid = Color(0xFF203A43);
  static const Color primaryGradientEnd = Color(0xFF2C5364);

  // --- USTA TARAFI TURUNCU GRADYAN ---
  // "Turuncu ağırlıklı gidelim" dediğin için usta sayfalarında kullanılacak
  static const Color ustaGradientStart = Color(0xFFFF8C00); // Dark Orange
  static const Color ustaGradientMid = Color(0xFFF27121);   // Sunset Orange
  static const Color ustaGradientEnd = Color(0xFFE94057);   // Pinkish Orange

  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color white54 = Colors.white54;
  static const Color white10 = Colors.white10;
  static const Color buttonBorder = Colors.white30;

  // REVIZE EDILDI: Rol renkleri gradyan felsefesiyle tam uyumlu hale getirildi
  static const Color customerColor = Color(0xFF203A43); // Müşteri kimliği (Petrol Mavisi)
  static const Color ustaColor = Color(0xFFF27121);     // Usta kimliği (Canlı Turuncu)
}

class AppTextStyles {
  // Marka başlığı usta tarafında da aynı kalabilir,
  // ama gölge rengini turuncuya uyumlu hale getirmek isteyebiliriz.
  static const TextStyle brandTitle = TextStyle(
    color: AppColors.white,
    fontSize: 42,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
    shadows: [
      Shadow(
          color: Colors.black26, // Turuncu zeminde mavi gölge yerine koyu gölge daha şık durur
          blurRadius: 10,
          offset: Offset(0, 4)
      )
    ],
  );

  static const TextStyle brandSubtitle = TextStyle(
    color: AppColors.white70,
    fontSize: 18,
    letterSpacing: 2,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle buttonTitle = TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Usta İş Fırsatları için kart başlığı stili
  static const TextStyle cardTitle = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

class AppDecorations {
  // Müşteri tarafındaki aynı cam (glassmorphism) etkisini koruyoruz
  static BoxDecoration get buttonBox => BoxDecoration(
    color: AppColors.white.withOpacity(0.08),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.buttonBorder),
  );

  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: AppColors.white.withOpacity(0.1),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.white, width: 2),
    ),
    labelStyle: const TextStyle(color: AppColors.white70),
    hintStyle: const TextStyle(color: AppColors.white54),
  );

  // USTA TARAFINA ÖZEL: İş fırsatları kartları için şeffaf beyaz dekorasyon
  static BoxDecoration get ustaCardDecoration => BoxDecoration(
    color: AppColors.white.withOpacity(0.12),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: AppColors.white.withOpacity(0.2)),
  );
}