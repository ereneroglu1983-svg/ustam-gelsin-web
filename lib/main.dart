// lib/main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/firebase_options.dart';
import 'package:ustam_gelsin/core/services/notification_service.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';
import 'package:ustam_gelsin/features/home/screens/web_home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/splash_screen.dart';
import 'package:ustam_gelsin/features/rehber/screens/rehber_detay_screen.dart'; // <-- DÜZELTİLDİ: TEK DOĞRU YOL
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';
import 'package:ustam_gelsin/core/theme/usta_theme.dart';
import 'package:ustam_gelsin/services/yorum_service.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:ustam_gelsin/features/admin/screens/blog_ekle_screen.dart';
import 'package:ustam_gelsin/features/admin/screens/admin_dashboard.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().showLocalNotification(message);
}

// --- YENİ ROUTER - SEO URL'LER BURADA ---
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashWrapper(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: '/musteri_profil',
      builder: (context, state) => const MusteriProfilSayfasi(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: '/admin/blog-ekle',
      builder: (context, state) => const BlogEkleScreen(),
    ),
    // --- SEO İÇİN CAN DAMARI ---
    GoRoute(
      path: '/rehber/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return RehberDetayScreen(slug: slug);
      },
    ),
  ],
);

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await YorumService.loadData();

  try {
    await Firebase.initializeApp(
      options: kIsWeb
          ? FirebaseOptions(
        apiKey: Env.firebaseApiKeyWeb,
        authDomain: "device-streaming-6f29b03c.firebaseapp.com",
        projectId: "device-streaming-6f29b03c",
        storageBucket: "device-streaming-6f29b03c.firebasestorage.app",
        messagingSenderId: "715610995273",
        appId: "1:715610995273:web:9896daeb9a61ce385a1d98",
      )
          : DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase başlatıldı");

    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      debugPrint("🌐 WEB MOD: Auth persistence LOCAL");
    } else {
      if (kDebugMode) {
        debugPrint("🛠 DEBUG MOD: App Check DEVRE DIŞI");
      } else {
        await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.playIntegrity,
          appleProvider: AppleProvider.appAttest,
        );
        debugPrint("✅ RELEASE MOD: App Check aktif");
      }
    }
  } catch (e) {
    debugPrint("Firebase Hatası: $e");
  }

  if (!kIsWeb) {
    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      await NotificationService().initialize();
      await FirebaseMessaging.instance.subscribeToTopic('acil_cagri_ustalar').catchError((_) {});
      ChatService().yeniMesajlariDinle();
    } catch (_) {}
  }

  runApp(const MyApp());
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FlutterNativeSplash.remove();
      // İŞTE KİLİT NOKTA: 2 sn sonra home'a at, yoksa sonsuza kadar splash'de kalır
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return kIsWeb ? const WebHomeScreen() : const HomeScreen();
      },
    );
  }
}