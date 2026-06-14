// lib/core/services/notification_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ustam_gelsin/features/chat/screens/chat_detay_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/is_teklif_detay_sayfasi.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Arka plan bildirimleri için gerekli başlatma
  debugPrint("Arka plan mesajı alındı: ${message.data}");
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            _handleMessageNavigationPayload(response.payload!);
          }
        }
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null || message.data.isNotEmpty) {
        showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigation(message.data);
    });
  }

  Future<void> updateUserToken(String uid, String isKolu) async {
    String? token = await _messaging.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': token,
        'uzmanlikAlani': isKolu,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // Backend kritik alarm kanalı ile eşleştirildi
      'Bildirimler',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      ledColor: Colors.red,
      ledOnMs: 1000,
      ledOffMs: 500,
      enableVibration: true,
      showWhen: true,
    );

    final title = message.notification?.title ?? "Yeni Bildirim";
    final body = message.notification?.body ?? "Bildiriminiz var.";

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(android: androidDetails),
      payload: message.data.entries.map((e) => "${e.key}:${e.value}").join('|'),
    );
  }

  void _handleMessageNavigationPayload(String payload) {
    final Map<String, String> dataMap = {};
    final parts = payload.split('|');
    for (var part in parts) {
      final kv = part.split(':');
      if (kv.length == 2) dataMap[kv[0]] = kv[1];
    }
    _handleMessageNavigation(dataMap);
  }

  void _handleMessageNavigation(Map<String, dynamic> dataMap) async {
    String type = dataMap['type']?.toString().trim() ?? '';

    if (type == 'chat') {
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
            MaterialPageRoute(
              builder: (context) => IsTeklifDetaySayfasi(ilan: ilan),
            ),
          );
        }
      }
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}