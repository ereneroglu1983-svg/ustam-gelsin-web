// lib/core/services/sosyal_medya_motoru.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SosyalMedyaMotoru {
  // RAM CACHE: Ayarları her seferinde okumaması için
  static Map<String, dynamic>? _cachedConfig;

  static Future<Map<String, dynamic>> _getSosyalMedyaConfig() async {
    // Eğer cache doluysa Firebase'e hiç gitme
    if (_cachedConfig != null) return _cachedConfig!;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('settings')
        .doc('sosyal_medya_config')
        .get();

    _cachedConfig = doc.data() as Map<String, dynamic>;
    return _cachedConfig!;
  }

  // ROBOT GÜNLÜĞÜNE HATA KAYDETME METODU
  static Future<void> _logRobot(String message) async {
    try {
      // Sadece kritik hataları logla
      await FirebaseFirestore.instance.collection('robot_logs').add({
        'message': "🚨 KRİTİK HATA: $message",
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'error'
      });
    } catch (e) {
      // Firebase'e log atılamazsa sessiz kal (Sistemi kilitleme)
    }
  }

  static Future<String> _getPublicUrl(String gorselUrl) async {
    try {
      if (gorselUrl.startsWith('http')) return gorselUrl;
      return await FirebaseStorage.instance.ref(gorselUrl).getDownloadURL();
    } catch (e) {
      return "https://hemenustamgelsin.com/default-image.jpg";
    }
  }

  static String _detaylariDuzgunMetneCevir(Map<String, dynamic> detaylar) {
    return detaylar.entries.map((e) {
      String deger = e.value is List ? (e.value as List).join(", ") : e.value.toString();
      return "${e.key}: $deger";
    }).join("\n");
  }

  static Future<void> facebookPaylas(String baslik, String sehir, String kategori, Map<String, dynamic> detaylar, String gorselUrl) async {
    try {
      // CACHE'LENMİŞ AYARLARI KULLAN
      final config = await _getSosyalMedyaConfig();
      final String pageId = config['fb_page_id'] ?? '';
      final String accessToken = config['fb_access_token'] ?? '';

      if (pageId.isEmpty || accessToken.isEmpty) {
        await _logRobot("Facebook yapılandırma değerleri boş!");
        return;
      }

      String detayMetni = _detaylariDuzgunMetneCevir(detaylar);
      String message = "UstamGelsin'de Yeni İş Fırsatı!\n\nİş Tanımı: $baslik\nKategori: $kategori\nBölge: $sehir\n\nDetaylar:\n$detayMetni\n\nDetaylar için uygulamayı indir!";

      var response = await http.post(
        Uri.parse('https://graph.facebook.com/v20.0/$pageId/feed'),
        body: {
          'message': message,
          'access_token': accessToken,
        },
      );

      if (response.statusCode != 200) {
        await _logRobot("Facebook API Hatası (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      await _logRobot("Facebook Paylaşım Hatası: $e");
    }
  }
}