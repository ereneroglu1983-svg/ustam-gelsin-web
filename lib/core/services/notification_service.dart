// lib/core/services/notification_service.dart - FIXED
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

  static String? _sonKaydedilenToken;
  static bool _yaziliyor = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    const AndroidNotificationChannel mesajKanali = AndroidNotificationChannel(
      'mesaj_kanali', 'Mesaj Bildirimleri',
      description: 'Müşteriden gelen mesajlar',
      importance: Importance.max, playSound: true, enableVibration: true,
    );
    const AndroidNotificationChannel genelKanal = AndroidNotificationChannel(
      'high_importance_channel', 'Genel Bildirimler',
      importance: Importance.max, playSound: true,
    );
    const AndroidNotificationChannel adminBazKanali = AndroidNotificationChannel(
      'admin_baz_channel', 'Admin Baz İstasyonu',
      description: 'Yönetici bildirimleri',
      importance: Importance.max, playSound: true, enableVibration: true,
    );

    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(mesajKanali);
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(genelKanal);
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(adminBazKanali);

    // ✅ FIX - launcher_icon
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) _handleMessageNavigationPayload(response.payload!);
        });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Future.delayed(const Duration(milliseconds: 1500), () => _handleMessageNavigation(message.data));
      }
    });
    FirebaseMessaging.onMessage.listen((message) => showLocalNotification(message));
    FirebaseMessaging.onMessageOpenedApp.listen((message) => _handleMessageNavigation(message.data));
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (newToken != _sonKaydedilenToken) {
        final prefs = await SharedPreferences.getInstance();
        final uid = prefs.getString('son_uid');
        if (uid != null) await _guvenliYaz(uid, newToken, []);
      }
    });
  }

  Future<void> updateUserToken(String uid, List<String> uzmanliklar) async {
    if (_yaziliyor) return;
    String? token = await _messaging.getToken();
    if (token == null) return;
    if (token == _sonKaydedilenToken) return;
    await _guvenliYaz(uid, token, uzmanliklar);
  }

  Future<void> _guvenliYaz(String uid, String token, List<String> uzmanliklar) async {
    if (_yaziliyor) return;
    _yaziliyor = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheToken = prefs.getString('fcm_token_cache');
      if (cacheToken == token && _sonKaydedilenToken == token) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': token, 'uzmanliklar': uzmanliklar,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await prefs.setString('fcm_token_cache', token);
      await prefs.setString('son_uid', uid);
      _sonKaydedilenToken = token;
      debugPrint("✅ [TOKEN KAYDEDİLDİ - TEK SEFER]");
    } catch (e) {
      debugPrint("❌ Token yazma hatası: $e");
    } finally {
      _yaziliyor = false;
    }
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    final String type = message.data['type'] ?? '';
    String channelId = 'high_importance_channel';
    String channelName = 'Bildirimler';
    if (type == 'chat') {
      channelId = 'mesaj_kanali'; channelName = 'Mesaj Bildirimleri';
    } else if (type.startsWith('yeni_') || type == 'para_girisi' || type == 'odeme' || type == 'cozum_ortakligi' || type == 'sistem_mesaj') {
      channelId = 'admin_baz_channel'; channelName = 'Admin Baz İstasyonu';
    }
    // ✅ FIX - launcher_icon
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId, channelName,
      importance: Importance.max, priority: Priority.high,
      playSound: true, enableVibration: true,
      icon: '@mipmap/launcher_icon',
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
    } catch (e) { debugPrint("Payload hatası: $e"); }
  }

  void _handleMessageNavigation(Map<String, dynamic> dataMap) async {
    String type = dataMap['type']?.toString().trim() ?? '';
    String typeLower = type.toLowerCase();
    if (typeLower.contains('acil')) {
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