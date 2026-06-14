import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TokenYenilemeServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Instagram/Facebook App Bilgileri
  static const String appId = "1431847685643581";
  static const String appSecret = "66b8676e6c67e3eb762eaa2f44264907";

  Future<void> tokenKontrolVeYenile() async {
    try {
      DocumentSnapshot metaDoc = await _firestore.collection('settings').doc('sosyal_medya_config').get();

      if (!metaDoc.exists) return;

      Map<String, dynamic> data = metaDoc.data() as Map<String, dynamic>;
      Timestamp sonYenilemeTs = data['son_yenileme'] as Timestamp;
      DateTime sonYenileme = sonYenilemeTs.toDate();

      // 50 gün geçtiyse yenileme sürecini başlat
      if (DateTime.now().difference(sonYenileme).inDays >= 50) {
        debugPrint("⏳ Token süresi yaklaşmış, yenileniyor...");
        await _tokenExchange(data['long_lived_token']);
      } else {
        debugPrint("✅ Token geçerli, yenilemeye gerek yok.");
      }
    } catch (e) {
      debugPrint("❌ Token kontrol hatası: $e");
    }
  }

  Future<void> _tokenExchange(String oldToken) async {
    try {
      final url = Uri.parse('https://graph.facebook.com/v20.0/oauth/access_token?'
          'grant_type=fb_exchange_token&'
          'client_id=$appId&'
          'client_secret=$appSecret&'
          'fb_exchange_token=$oldToken');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final newTokens = json.decode(response.body);

        await _firestore.collection('settings').doc('sosyal_medya_config').update({
          'long_lived_token': newTokens['access_token'],
          'son_yenileme': FieldValue.serverTimestamp(),
        });

        debugPrint("🚀 Token başarıyla yenilendi.");
      } else {
        debugPrint("❌ Token yenileme API Hatası: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Token exchange hatası: $e");
    }
  }
}