// lib/main.dart - FINAL REVIZE - HIZLI AÇILIŞ + BEYAZ EKRAN FIX + HUG MARKET ROUTE FIX + B ŞIKKI ADMIN EKLENDI - IMPORT FIX + KOMSU HELPER EKLENDI + ANALYTICS EKLENDI
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:ustam_gelsin/core/providers/hesaplama_provider.dart';
import 'package:ustam_gelsin/firebase_options.dart';
import 'package:ustam_gelsin/core/services/notification_service.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';
import 'package:ustam_gelsin/features/home/screens/web_home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/splash_screen.dart';
import 'package:ustam_gelsin/features/rehber/screens/rehber_detay_screen.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/acil_ilanlar.dart';
import 'package:ustam_gelsin/core/theme/usta_theme.dart';
import 'package:ustam_gelsin/services/yorum_service.dart';
import 'package:ustam_gelsin/features/admin/screens/blog_ekle_screen.dart';
import 'package:ustam_gelsin/features/admin/screens/admin_dashboard.dart';

// HUG MARKET IMPORTLARI EKLENDI
import 'package:ustam_gelsin/features/hug_market/hug_market_homepage.dart';
import 'package:ustam_gelsin/features/hug_market/sepet_sayfasi.dart';
import 'package:ustam_gelsin/features/hug_market/siparis_takip_sayfasi.dart';
import 'package:ustam_gelsin/features/hug_market/cozum_ortagi_page.dart';
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

// B ŞIKKI - HUG MARKET ADMIN - V11 TEK KOMUTA - SHELL SILINDI, MOTOR EKLENDI
import 'package:ustam_gelsin/features/admin/hug_market/kategori_munhasir_motoru.dart';
// YENI EKLENEN - KOMSU ILCE HELPER - 973 ILCE ICIN CANLI USTA GORUNURLUK
import 'package:ustam_gelsin/utils/komsu_helper.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().showLocalNotification(message);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashWrapper()),
    GoRoute(path: '/home', builder: (context, state) => const AuthGate()),
    GoRoute(path: '/musteri_profil', builder: (context, state) => const MusteriProfilSayfasi()),
    GoRoute(path: '/acil_ilanlar', builder: (context, state) => AcilIlanlarSayfasi()),
    GoRoute(path: '/admin', builder: (context, state) => const AdminDashboard()),
    GoRoute(path: '/admin/blog-ekle', builder: (context, state) => const BlogEkleScreen()),
    GoRoute(path: '/hug-market-admin', builder: (context, state) => const KategoriMunhasirMotoruPage()),
    GoRoute(
      path: '/rehber/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return RehberDetayScreen(slug: slug);
      },
    ),
    GoRoute(
      path: '/hug-market',
      builder: (c, s) => const HugMarketHomepage(),
      routes: [
        GoRoute(path: 'sepet', builder: (c, s) => const SepetSayfasi()),
        GoRoute(path: 'siparis-takip', builder: (c, s) => const SiparisTakipSayfasi()),
        GoRoute(path: 'cozum-ortagi', builder: (c, s) => const CozumOrtagiPage()),
        GoRoute(
          path: 'kategori/:slug',
          builder: (c, s) {
            final slug = s.pathParameters['slug']!;
            switch (slug) {
              case 'banyo-mutfak': return const MutfakBanyoKategoriPage();
              case 'temizlik': return const TemizlikKategoriPage();
              case 'elektrik': return const ElektrikKategoriPage();
              case 'hirdavat': return const HirdavatKategoriPage();
              case 'peyzaj': return const PeyzajKategoriPage();
              case 'tesisat-su': return const TesisatKategoriPage();
              case 'yapi-malzemeleri': return const YapiMalzemeleriKategoriPage();
              case 'boya-dekorasyon': return const BoyaDekorasyonKategoriPage();
              case 'cati-cephe': return const CatiCepheKategoriPage();
              case 'havuz-spa': return const HavuzSpaKategoriPage();
              case 'iklimlendirme': return const IsitmaSogutmaKategoriPage();
              case 'seramik-fayans': return const SeramikFayansKategoriPage();
              case 'yalitim-izolasyon': return const YalitimIzolasyonKategoriPage();
              case 'yenilenebilir-enerji': return const YenilenebilirEnerjiKategoriPage();
              case 'cam-aluminyum': return const CamAluminyumKategoriPage();
              case 'kapi-kilit': return const KapiKilitKategoriPage();
              case 'guvenlik-yangin-zayif-akim': return const GuvenlikKategoriPage();
              case 'asansor-yuruyen-merdiven': return const AsansorKategoriPage();
              default: return const HugMarketHomepage();
            }
          },
        ),
      ],
    ),
  ],
);

void _handleNotificationClick(RemoteMessage message) {
  debugPrint("Bildirime tıklandı: ${message.data}");
  final data = message.data;
  final type = data['type'] ?? data['tip'] ?? '';
  if (type == 'acil_cagri' || type == 'acil_cagri_ustalar' || data['acilCagriId'] != null) {
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => AcilIlanlarSayfasi()));
  } else if (type == 'acil_kabul') {
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const MusteriProfilSayfasi()));
  }
}

Future<void> _initializeServicesInBackground() async {
  try {
    await YorumService.loadData();
  } catch (e) {
    debugPrint("YorumService yükleme hatası: $e");
  }
  try {
    await KomsuHelper.init();
    debugPrint("✅ KomsuHelper 973 ilçe yüklendi");
  } catch (e) {
    debugPrint("KomsuHelper yükleme hatası: $e");
  }
  if (kIsWeb) return;
  if (!kDebugMode) {
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.appAttest,
      );
    } catch (_) {}
  }
  try {
    await NotificationService().initialize();
    await FirebaseMessaging.instance.subscribeToTopic('acil_cagri_ustalar').catchError((_) {});
    await FirebaseMessaging.instance.subscribeToTopic('admin_notifications').catchError((_) {});
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(seconds: 1), () => _handleNotificationClick(initialMessage));
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);
  } catch (e) {
    debugPrint("Bildirim init hatası: $e");
  }
}

void main() async {
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("✅ Firebase başlatıldı");
    // ANALYTICS - CANLI SAYAC ICIN EKLENDI
    await FirebaseAnalytics.instance.logAppOpen();
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    debugPrint("✅ Analytics başlatıldı");
    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }
    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
  } catch (e) {
    debugPrint("Firebase Hatası: $e");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HesaplamaProvider>(create: (_) => HesaplamaProvider()),
      ],
      child: const MyApp(),
    ),
  );
  unawaited(_initializeServicesInBackground());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Ustam Gelsin',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2DB34A)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: UstaTheme.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});
  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/home');
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FlutterNativeSplash.remove();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const AuthGate();
    }
    return SplashScreen(onFinished: () {
      if (mounted) context.go('/home');
    });
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        if (user != null) {
          Future.microtask(() => ChatService().yeniMesajlariDinle());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebHomeScreen();
    }
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return const HomeScreen();
      },
    );
  }
}