// lib/core/services/notification_service.dart - FIXED - DÖNGÜSÜZ + KANAL FIX
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ustam_gelsin/features/chat/screens/chat_detay_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/is_teklif_detay_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/acil_ilanlar.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📩 Arka plan mesajı: ${message.data}");
  await NotificationService().showLocalNotification(message);
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // === FIX 1: DÖNGÜ KİLİDİ ===
  static String? _sonKaydedilenToken;
  static bool _yaziliyor = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // === FIX 2: KANALLARI OLUŞTUR - YOKSA BİLDİRİM GELMEZ ===
    const AndroidNotificationChannel mesajKanali = AndroidNotificationChannel(
      'mesaj_kanali', // id
      'Mesaj Bildirimleri',
      description: 'Müşteriden gelen mesajlar',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const AndroidNotificationChannel genelKanal = AndroidNotificationChannel(
      'high_importance_channel',
      'Genel Bildirimler',
      importance: Importance.max,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(mesajKanali);
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(genelKanal);

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            _handleMessageNavigationPayload(response.payload!);
          }
        });

    // İlk açılış mesajı
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Future.delayed(const Duration(milliseconds: 1500), () => _handleMessageNavigation(message.data)); // DÜZELTİLDİ: 500 -> 1500, navigator hazır olsun diye
      }
    });

    // Ön planda mesaj
    FirebaseMessaging.onMessage.listen((message) {
      showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageNavigation(message.data);
    });

    // Token yenilenirse SADECE DEĞİŞTİYSE yaz
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (newToken != _sonKaydedilenToken) {
        final prefs = await SharedPreferences.getInstance();
        final uid = prefs.getString('son_uid'); // uid'yi cache'den al
        if (uid != null) {
          await _guvenliYaz(uid, newToken, []);
        }
      }
    });
  }

  // === FIX 3: GÜVENLİ YAZMA - AYNI TOKENI TEKRAR YAZMAZ ===
  Future<void> updateUserToken(String uid, List<String> uzmanliklar) async {
    if (_yaziliyor) return;
    String? token = await _messaging.getToken();
    if (token == null) return;
    if (token == _sonKaydedilenToken) return; // AYNI TOKENSA DUR

    await _guvenliYaz(uid, token, uzmanliklar);
  }

  Future<void> _guvenliYaz(String uid, String token, List<String> uzmanliklar) async {
    if (_yaziliyor) return;
    _yaziliyor = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheToken = prefs.getString('fcm_token_cache');

      // Cache ile aynıysa Firestore'a hiç dokunma - DÖNGÜ BİTER
      if (cacheToken == token && _sonKaydedilenToken == token) {
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': token,
        'uzmanliklar': uzmanliklar,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await prefs.setString('fcm_token_cache', token);
      await prefs.setString('son_uid', uid);
      _sonKaydedilenToken = token;

      // LOGU KAPAT - ARTIK SPAM YOK
      // debugPrint("✅ FCM TOKEN YAZILDI..."); // SİLDİK
      debugPrint("✅ [TOKEN KAYDEDİLDİ - TEK SEFER]");
    } catch (e) {
      debugPrint("❌ Token yazma hatası: $e");
    } finally {
      _yaziliyor = false;
    }
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    final String type = message.data['type'] ?? '';
    final String channelId = type == 'chat' ? 'mesaj_kanali' : 'high_importance_channel';

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      type == 'chat' ? 'Mesaj Bildirimleri' : 'Bildirimler',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? message.data['title'] ?? "Yeni Bildirim",
      message.notification?.body ?? message.data['body'] ?? "Bildiriminiz var.",
      NotificationDetails(android: androidDetails),
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageNavigationPayload(String payload) {
    try {
      final Map<String, dynamic> dataMap = jsonDecode(payload);
      _handleMessageNavigation(dataMap);
    } catch (e) {
      debugPrint("Payload hatası: $e");
    }
  }

  void _handleMessageNavigation(Map<String, dynamic> dataMap) async {
    String type = dataMap['type']?.toString().trim() ?? '';
    String typeLower = type.toLowerCase(); // DÜZELTİLDİ: EKLENDİ

    if (typeLower.contains('acil')) { // DÜZELTİLDİ: == 'acil_cagri' yerine contains('acil') yapıldı, ana sayfaya düşmesin diye
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => AcilIlanlarSayfasi()));
    } else if (type == 'chat') {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => ChatDetaySayfasi(
          ilanId: dataMap['ilanId']?.toString() ?? '',
          ustaId: dataMap['ustaId']?.toString() ?? dataMap['gonderenId']?.toString() ?? '',
          ustaAd: dataMap['aliciAd']?.toString() ?? "Sohbet",
        ),
      ));
    } else if (type == 'offer') {
      final ilanId = dataMap['ilanId']?.toString();
      if (ilanId != null && ilanId.isNotEmpty) {
        final ilanDoc = await FirebaseFirestore.instance.collection('ilanlar').doc(ilanId).get();
        if (ilanDoc.exists) {
          final ilan = IlanModel.fromMap(ilanDoc.data() as Map<String, dynamic>, ilanDoc.id);
          navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => IsTeklifDetaySayfasi(ilan: ilan)));
        }
      }
    }
  }

  Future<String?> getToken() async => await _messaging.getToken();
}