// lib/main.dart

import 'package:flutter/foundation.dart'; // kIsWeb kullanımı için eklendi
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ustam_gelsin/core/config/firebase_options.dart';
import 'package:ustam_gelsin/core/services/notification_service.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';
import 'package:ustam_gelsin/core/services/token_yenileme_servisi.dart'; // EKLENDİ
import 'package:ustam_gelsin/features/home/screens/web_home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';
import 'package:ustam_gelsin/core/theme/usta_theme.dart';
import 'package:ustam_gelsin/services/yorum_service.dart'; // EKLENDİ

// Arka plan bildirim işleyicisi
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // REVİZE: showNotification yerine servisteki public metot olan showLocalNotification çağrıldı
  await NotificationService().showLocalNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Yorum servis verilerini yükle (EKLENDİ)
  await YorumService.loadData();

  // Firebase Başlatma
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
      apiKey: "AIzaSyDb63MIo3CRdKjnLb-bfbnr2N5tHyVa_kE",
      authDomain: "device-streaming-6f29b03c.firebaseapp.com",
      projectId: "device-streaming-6f29b03c",
      storageBucket: "device-streaming-6f29b03c.firebasestorage.app",
      messagingSenderId: "715610995273",
      appId: "1:715610995273:web:9896daeb9a61ce385a1d98",
    )
        : DefaultFirebaseOptions.currentPlatform,
  );

  // Token yenileme servisini tetikle (EKLENDİ)
  await TokenYenilemeServisi().tokenKontrolVeYenile();

  // Web dışı platformlarda bildirim servislerini başlat
  if (!kIsWeb) {
    // Arka plan mesaj işleyiciyi kaydet
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Bildirim Servisini Başlat
    await NotificationService().initialize();

    // Yeni Mesaj Dinleyiciyi Başlat (Balon yapısı için)
    ChatService().yeniMesajlariDinle();
  }

  // Env Yükleme
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Env dosyası yüklenemedi: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ustam Gelsin',

      // Bildirim navigasyonu için servis üzerinden gelen anahtar
      navigatorKey: kIsWeb ? null : NotificationService.navigatorKey,

      // 1. MÜŞTERİ TEMASI (Light Mode)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2DB34A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),

      // 2. USTA TEMASI (Dark Mode)
      darkTheme: UstaTheme.darkTheme,

      // 3. TEMA YÖNETİMİ
      themeMode: ThemeMode.dark,

      initialRoute: '/',

      routes: {
        '/': (context) => kIsWeb ? const WebHomeScreen() : const HomeScreen(),
        '/musteri_profil': (context) => const MusteriProfilSayfasi(),
      },
    );
  }
}