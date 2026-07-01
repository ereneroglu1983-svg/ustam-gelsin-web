// lib/core/services/notification_service.dart

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ustam_gelsin/features/chat/screens/chat_detay_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/is_teklif_detay_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/acil_ilanlar.dart'; // Liste sayfasına yönlendirme için
import 'package:ustam_gelsin/core/models/ilan_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Arka plan mesajı alındı: ${message.data}");
  await NotificationService().showLocalNotification(message);
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleMessageNavigation(message.data);
        });
      }
    });

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            _handleMessageNavigationPayload(response.payload!);
          }
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigation(message.data);
    });
  }

  Future<void> updateUserToken(String uid, List<String> uzmanliklar) async {
    String? token = await _messaging.getToken();
    if (token == null) return;

    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('fcm_token_cache');

    if (savedToken == token) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fcmToken': token,
      'uzmanliklar': uzmanliklar,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await prefs.setString('fcm_token_cache', token);
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel', 'Bildirimler',
      importance: Importance.max, priority: Priority.high,
      playSound: true, enableLights: true,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? message.data['title'] ?? "Yeni Bildirim",
      message.notification?.body ?? message.data['body'] ?? "Bildiriminiz var.",
      const NotificationDetails(android: androidDetails),
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageNavigationPayload(String payload) {
    try {
      final Map<String, dynamic> dataMap = jsonDecode(payload);
      _handleMessageNavigation(dataMap);
    } catch (e) {
      debugPrint("Payload ayrıştırma hatası: $e");
    }
  }

  void _handleMessageNavigation(Map<String, dynamic> dataMap) async {
    String type = dataMap['type']?.toString().trim() ?? '';

    if (type == 'acil_cagri') {
      // GÜVENLİK REVİZE: Detaya doğrudan atma, Acil İşler listesine yönlendir.
      // Usta buradan "Hemen İşi Al" butonuna basarak komisyon kontrolünden geçecek.
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => AcilIlanlarSayfasi()),
      );
    } else if (type == 'chat') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => ChatDetaySayfasi(
            ilanId: dataMap['ilanId']?.toString() ?? '',
            ustaId: dataMap['ustaId']?.toString() ?? '',
            ustaAd: "Sohbet",
          ),
        ),
      );
    } else if (type == 'offer') {
      final ilanId = dataMap['ilanId']?.toString();
      if (ilanId != null && ilanId.isNotEmpty) {
        final ilanDoc = await FirebaseFirestore.instance.collection('ilanlar').doc(ilanId).get();
        if (ilanDoc.exists) {
          final ilan = IlanModel.fromMap(ilanDoc.data() as Map<String, dynamic>, ilanDoc.id);
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => IsTeklifDetaySayfasi(ilan: ilan)),
          );
        }
      }
    }
  }

  Future<String?> getToken() async => await _messaging.getToken();
}