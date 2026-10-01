// lib/services/b2b_notification_service.dart - FINAL HATASIZ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class B2BNotificationService {
  static final B2BNotificationService _instance = B2BNotificationService._internal();
  factory B2BNotificationService() => _instance;
  B2BNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    const AndroidInitializationSettings android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);

    await _fcm.requestPermission(alert: true, badge: true, sound: true, provisional: false);
    await _fcm.subscribeToTopic('b2b_admin');
    debugPrint('B2B: b2b_admin topic subscribed');

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageClick);

    final RemoteMessage? initial = await _fcm.getInitialMessage();
    if (initial != null) {
      _handleMessageClick(initial);
    }

    _listenCorporateLeads();
  }

  void _listenCorporateLeads() {
    // Composite index gerektirmesin diye sadece where kullaniyoruz
    _firestore
        .collection('corporate_leads')
        .where('status', isEqualTo: 'Yeni')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docChanges.isEmpty) return;
      for (final DocumentChange change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          final Timestamp? ts = data['createdAt'] as Timestamp?;
          if (ts == null) continue;
          final DateTime createdAt = ts.toDate();
          final int diffMinutes = DateTime.now().difference(createdAt).inMinutes;
          // Only last 2 minutes
          if (diffMinutes <= 2) {
            _showLocalNotification(data, change.doc.id);
          }
        }
      }
    });
  }

  Future<void> _handleForegroundMessage(RemoteMessage msg) async {
    final String title = msg.notification?.title ?? 'Yeni B2B Basvurusu';
    final String body = msg.notification?.body ?? 'HUG MARKET Cozum Ortagi';
    await _local.show(
      msg.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'b2b_leads_channel',
          'B2B Basvurulari',
          channelDescription: 'Yeni cozum ortagi basvurulari',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: msg.data['leadId'],
    );
  }

  void _handleMessageClick(RemoteMessage msg) {
    final String? leadId = msg.data['leadId'] as String?;
    debugPrint('B2B bildirime tiklandi leadId: $leadId');
  }

  Future<void> _showLocalNotification(Map<String, dynamic> data, String docId) async {
    final String firma = (data['firma'] as String?) ?? 'Bilinmeyen Firma';
    final String kategoriler = (data['kategoriler'] as List?)?.join(', ') ?? '';
    final String yetkili = (data['yetkili'] as String?) ?? '';
    await _local.show(
      docId.hashCode,
      'Yeni B2B Basvurusu: $firma',
      '$kategoriler - $yetkili',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'b2b_leads_channel',
          'B2B Basvurulari',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: docId,
    );
  }

  Stream<int> unreadCountStream() {
    return _firestore
        .collection('corporate_leads')
        .where('status', isEqualTo: 'Yeni')
        .snapshots()
        .map((QuerySnapshot s) => s.docs.length);
  }
}