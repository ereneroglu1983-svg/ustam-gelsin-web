// lib/main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ustam_gelsin/core/config/firebase_options.dart';
import 'package:ustam_gelsin/core/services/notification_service.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';
import 'package:ustam_gelsin/features/home/screens/web_home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';
import 'package:ustam_gelsin/core/theme/usta_theme.dart';
import 'package:ustam_gelsin/services/yorum_service.dart';
import 'package:ustam_gelsin/env.dart';

// Arka plan bildirim işleyicisi
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().showLocalNotification(message);
}

void main() async {
  // 1. Splash ekranını korumaya al
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 2. Kritik başlangıç verilerini yükle
  await YorumService.loadData();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Env dosyası yüklenemedi: $e");
  }

  // 3. Firebase Başlatma
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

  // 4. App Check'i arka planda başlat
  _initializeAppCheck();

  // 5. Diğer servisleri başlat
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationService().initialize();

    // Usta bildirim kanalına abone ol
    await FirebaseMessaging.instance.subscribeToTopic('acil_cagri_ustalar');

    ChatService().yeniMesajlariDinle();
  }

  // 6. Her şey hazır olduğunda Splash ekranını kaldır
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

// App Check başlatma fonksiyonu (Temiz hali)
void _initializeAppCheck() {
  FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    webProvider: kIsWeb ? ReCaptchaEnterpriseProvider('6Lcc_B4tAAAAAMgSTPKVFEPM88Wdoy-1AWmqs68L') : null,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ustam Gelsin',
      navigatorKey: kIsWeb ? null : NotificationService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2DB34A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: UstaTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => kIsWeb ? const WebHomeScreen() : const HomeScreen(),
        '/musteri_profil': (context) => const MusteriProfilSayfasi(),
      },
    );
  }
}