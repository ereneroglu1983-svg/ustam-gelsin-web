// lib/main.dart - FINAL - DOTENV REMOVED + TOKEN LOOP FIX + BİLDİRİM FIX
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
import 'package:ustam_gelsin/core/theme/usta_theme.dart';
import 'package:ustam_gelsin/services/yorum_service.dart';
import 'package:ustam_gelsin/features/admin/screens/blog_ekle_screen.dart';
import 'package:ustam_gelsin/features/admin/screens/admin_dashboard.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().showLocalNotification(message);
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashWrapper()),
    GoRoute(path: '/home', builder: (context, state) => const AuthGate()),
    GoRoute(path: '/musteri_profil', builder: (context, state) => const MusteriProfilSayfasi()),
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

void main() async {
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await YorumService.loadData();
  } catch (e) {
    debugPrint("YorumService yükleme hatası: $e");
  }

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("✅ Firebase başlatıldı");

    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    } else {
      if (!kDebugMode) {
        try {
          await FirebaseAppCheck.instance.activate(
            androidProvider: AndroidProvider.playIntegrity,
            appleProvider: AppleProvider.appAttest,
          );
        } catch (appCheckError) {
          debugPrint("App Check Başlatma Hatası: $appCheckError");
        }
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
    } catch (notificationError) {
      debugPrint("Bildirim Servisi Başlatma Hatası: $notificationError");
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HesaplamaProvider>(
          create: (_) => HesaplamaProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
    WidgetsBinding.instance.addPostFrameCallback((_) => FlutterNativeSplash.remove());
  }

  @override
  Widget build(BuildContext context) {
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
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null && !kIsWeb) {
        ChatService().yeniMesajlariDinle();
      }
    });
  }

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