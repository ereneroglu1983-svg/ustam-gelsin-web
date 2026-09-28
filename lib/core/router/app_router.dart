import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/insaat_rehberi.dart';
import 'package:ustam_gelsin/features/rehber/screens/rehber_detay_screen.dart';
import 'package:ustam_gelsin/features/hug_market/hug_market_homepage.dart';
import 'package:ustam_gelsin/features/hug_market/sepet_sayfasi.dart';
import 'package:ustam_gelsin/features/hug_market/siparis_takip_sayfasi.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (c, s) => const HomeScreen()),

    // ESKİ /home KALINTISINI ANA SAYFAYA AT
    GoRoute(
      path: '/home',
      redirect: (c, s) => '/',
    ),

    // /insaat-rehberi yazan da /rehber'e gitsin
    GoRoute(
      path: '/insaat-rehberi',
      redirect: (c, s) => '/rehber',
    ),

    GoRoute(
      path: '/rehber',
      builder: (c, s) => const InsaatRehberiScreen(),
      routes: [
        GoRoute(
          path: ':slug',
          builder: (c, s) => RehberDetayScreen(slug: s.pathParameters['slug']!),
        ),
      ],
    ),

    // HUG MARKET - YENİ
    GoRoute(
      path: '/hug-market',
      builder: (c, s) => const HugMarketHomepage(),
      routes: [
        GoRoute(
          path: 'sepet',
          builder: (c, s) => const SepetSayfasi(),
        ),
        GoRoute(
          path: 'siparis-takip',
          builder: (c, s) => const SiparisTakipSayfasi(),
        ),
      ],
    ),

    GoRoute(
      path: '/odeme-basarili',
      builder: (context, state) {
        final amount = state.uri.queryParameters['amount'] ?? '0';
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 100),
                const SizedBox(height: 20),
                Text('$amount TL Yüklendi!', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => context.go('/'), child: const Text('Ana Sayfaya Dön')),
              ],
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: '/odeme-basarisiz',
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 100),
                const SizedBox(height: 20),
                const Text('Ödeme Başarısız', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => context.go('/'), child: const Text('Ana Sayfaya Dön')),
              ],
            ),
          ),
        );
      },
    ),
  ],
);