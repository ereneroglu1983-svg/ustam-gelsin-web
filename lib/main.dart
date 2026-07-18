// lib/main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ustam_gelsin/firebase_options.dart';
import 'package:ustam_gelsin/core/services/notification_service.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';
import 'package:ustam_gelsin/features/home/screens/web_home_screen.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';
import 'package:ustam_gelsin/core/theme/usta_theme.dart';
import 'package:ustam_gelsin/services/yorum_service.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:ustam_gelsin/features/admin/screens/blog_ekle_screen.dart';
import 'package:ustam_gelsin/features/admin/screens/admin_dashboard.dart';

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

  // 3. Firebase Başlatma (Güvenli Kutuya Alındı)
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
    debugPrint("Firebase başarıyla başlatıldı.");

    // [REVİZE - KALICI GİRİŞ İÇİN EKLENDİ] Web'de kalıcılığı garantile
    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }

  } catch (e) {
    debugPrint("FATAL HATA: Firebase başlatılamadı: $e");
  }

  // 4. Diğer servisleri başlat
  if (!kIsWeb) {
    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      await NotificationService().initialize();

      // Usta bildirim kanalına abone ol
      try {
        await FirebaseMessaging.instance.subscribeToTopic('acil_cagri_ustalar');
      } catch (e) {
        debugPrint("Bildirim abonelik hatası: $e");
      }

      ChatService().yeniMesajlariDinle();
    } catch (e) {
      debugPrint("Servis başlatma hatası: $e");
    }
  }

  // 5. Her şey hazır olduğunda Splash ekranını kaldır
  FlutterNativeSplash.remove();

  runApp(const MyApp());
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
        // [REVİZE - KALICI GİRİŞ İÇİN EKLENDİ] Artık ana sayfa AuthGate üzerinden açılıyor
        '/': (context) => const AuthGate(),
        '/musteri_profil': (context) => const MusteriProfilSayfasi(),
        '/admin': (context) => const AdminDashboard(),
        '/admin/blog-ekle': (context) => const BlogEkleScreen(),
      },
    );
  }
}

/// [REVİZE - KALICI GİRİŞ İÇİN EKLENDİ]
/// Bu widget Instagram/Facebook mantığıdır.
/// Bir kere giriş yapan kullanıcıyı (Usta veya Müşteri farketmez) her zaman hatırlar.
/// Firebase Auth token'ı cihazda güvenle saklar.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Bağlantı bekleniyor, splash zaten kalktığı için boş bir loader göster
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Kullanıcı zaten giriş yapmış (Usta veya Müşteri) -> Direkt içeri al
        // Kullanıcı giriş yapmamış -> Yine ana sayfaya al (misafir olarak dolaşsın)
        // Profil gibi korumalı sayfalara girince zaten login isteyeceksin
        if (kIsWeb) {
          return const WebHomeScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}
