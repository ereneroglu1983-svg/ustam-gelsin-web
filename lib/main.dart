// lib/main.dart - FINAL REVIZE - HIZLI AÇILIŞ + BEYAZ EKRAN FIX
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().showLocalNotification(message);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashWrapper()),
    GoRoute(path: '/home', builder: (context, state) => const AuthGate()),
    GoRoute(path: '/musteri_profil', builder: (context, state) => const MusteriProfilSayfasi()),
    GoRoute(path: '/acil_ilanlar', builder: (context, state) => AcilIlanlarSayfasi()),
    GoRoute(path: '/admin', builder: (context, state) => const AdminDashboard()),
    GoRoute(path: '/admin/blog-ekle', builder: (context, state) => const BlogEkleScreen()),
    GoRoute(
      path: '/rehber/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return RehberDetayScreen(slug: slug);
      },
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

// --- YENİ: runApp SONRASI ARKA PLANDA ÇALIŞACAK AĞIR İŞLER ---
Future<void> _initializeServicesInBackground() async {
  // 1. Yorumları arka planda yükle, ana thread'i kitlemeden
  try {
    await YorumService.loadData();
  } catch (e) {
    debugPrint("YorumService yükleme hatası: $e");
  }

  if (kIsWeb) return;

  // 2. AppCheck'i arka planda aktive et, bekletme
  if (!kDebugMode) {
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.appAttest,
      );
    } catch (_) {}
  }

  // 3. Bildirim servisleri
  try {
    await NotificationService().initialize();
    await FirebaseMessaging.instance.subscribeToTopic('acil_cagri_ustalar').catchError((_) {});

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

  // SADECE Firebase'i bekle, gerisini bekleme! Bu 300ms sürer.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("✅ Firebase başlatıldı");
    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }
    // Background handler'ı erken set et, hafiftir
    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
  } catch (e) {
    debugPrint("Firebase Hatası: $e");
  }

  // HEMEN EKRANI ÇİZ - 7 tane await'i beklemeden runApp!
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HesaplamaProvider>(create: (_) => HesaplamaProvider()),
      ],
      child: const MyApp(),
    ),
  );

  // Ağır işleri runApp'ten SONRA arka planda başlat
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
      // İlk frame çizildikten SONRA splash'i kaldır - beyaz ekranı bitirir
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
          // Mesaj dinlemeyi de gecikmeli başlat
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