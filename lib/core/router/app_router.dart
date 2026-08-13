import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/insaat_rehberi.dart';
import 'package:ustam_gelsin/features/rehber/screens/rehber_detay_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/rehber', builder: (context, state) => const InsaatRehberiScreen()),
    GoRoute(path: '/rehber/:slug', builder: (context, state) {
      final slug = state.pathParameters['slug']!;
      return RehberDetayScreen(slug: slug);
    }),
    // --- İŞTE ÇÖZÜM - HAZIR WIDGET, YENİ DOSYA YOK ---
    GoRoute(
      path: '/odeme-basarili',
      builder: (context, state) {
        final amount = state.uri.queryParameters['amount'] ?? '0';
        return Scaffold(
          body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            Text('$amount TL Yüklendi!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => context.go('/'), child: const Text('Ana Sayfaya Dön')),
          ])),
        );
      },
    ),
    GoRoute(
      path: '/odeme-basarisiz',
      builder: (context, state) {
        final reason = state.uri.queryParameters['reason'] ?? 'İptal';
        return Scaffold(
          body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error, color: Colors.red, size: 100),
            const SizedBox(height: 20),
            Text('Ödeme Başarısız: $reason', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => context.go('/'), child: const Text('Tekrar Dene')),
          ])),
        );
      },
    ),
  ],
);