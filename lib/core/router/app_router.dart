import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/insaat_rehberi.dart';
import 'package:ustam_gelsin/features/rehber/screens/rehber_detay_screen.dart';
import 'package:ustam_gelsin/features/hug_market/hug_market_homepage.dart' as web_home;
import 'package:ustam_gelsin/features/hug_market/hug_market_homepage_app.dart' as app_home;
import 'package:ustam_gelsin/features/hug_market/sepet_sayfasi.dart';
import 'package:ustam_gelsin/features/hug_market/siparis_takip_sayfasi.dart';
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

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // FIX: Google assetlinks.json'i router patlatmasın diye eklendi
    GoRoute(
      path: '/.well-known/assetlinks.json',
      builder: (c, s) => const Scaffold(body: SizedBox.shrink()),
    ),
    GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
    GoRoute(path: '/home', redirect: (c, s) => '/'),
    GoRoute(path: '/insaat-rehberi', redirect: (c, s) => '/rehber'),
    GoRoute(
      path: '/rehber',
      builder: (c, s) => const InsaatRehberiScreen(),
      routes: [
        GoRoute(path: ':slug', builder: (c, s) => RehberDetayScreen(slug: s.pathParameters['slug']!)),
      ],
    ),
    GoRoute(
      path: '/hug-market',
      builder: (c, s) {
        if (kIsWeb) {
          return const web_home.HugMarketHomepage();
        } else {
          return const app_home.HugMarketAppHomepage();
        }
      },
      routes: [
        GoRoute(path: 'sepet', builder: (c, s) => const SepetSayfasi()),
        GoRoute(path: 'siparis-takip', builder: (c, s) => const SiparisTakipSayfasi()),
        GoRoute(path: 'cozum-ortagi', builder: (c, s) => const CozumOrtagiPage()),
        GoRoute(
          path: 'kategori/:slug',
          builder: (c, s) {
            final slug = s.pathParameters['slug']!;
            switch (slug) {
              case 'banyo-mutfak':
                return const MutfakBanyoKategoriPage();
              case 'temizlik':
                return const TemizlikKategoriPage();
              case 'elektrik':
                return const ElektrikKategoriPage();
              case 'hirdavat':
                return const HirdavatKategoriPage();
              case 'peyzaj':
                return const PeyzajKategoriPage();
              case 'tesisat-su':
                return const TesisatKategoriPage();
              case 'yapi-malzemeleri':
                return const YapiMalzemeleriKategoriPage();
              case 'boya-dekorasyon':
                return const BoyaDekorasyonKategoriPage();
              case 'cati-cephe':
                return const CatiCepheKategoriPage();
              case 'havuz-spa':
                return const HavuzSpaKategoriPage();
              case 'iklimlendirme':
                return const IsitmaSogutmaKategoriPage();
              case 'seramik-fayans':
                return const SeramikFayansKategoriPage();
              case 'yalitim-izolasyon':
                return const YalitimIzolasyonKategoriPage();
              case 'yenilenebilir-enerji':
                return const YenilenebilirEnerjiKategoriPage();
              case 'cam-aluminyum':
                return const CamAluminyumKategoriPage();
              case 'kapi-kilit':
                return const KapiKilitKategoriPage();
              case 'guvenlik-yangin-zayif-akim':
                return const GuvenlikKategoriPage();
              case 'asansor-yuruyen-merdiven':
                return const AsansorKategoriPage();
              default:
                if (kIsWeb) {
                  return const web_home.HugMarketHomepage();
                } else {
                  return const app_home.HugMarketAppHomepage();
                }
            }
          },
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