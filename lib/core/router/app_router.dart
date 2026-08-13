import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/insaat_rehberi.dart';
import 'package:ustam_gelsin/features/rehber/screens/rehber_detay_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
    GoRoute(path: '/rehber', builder: (c, s) => const InsaatRehberiScreen()),
    GoRoute(path: '/rehber/:slug', builder: (c, s) => RehberDetayScreen(slug: s.pathParameters['slug']!)),
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