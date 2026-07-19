// lib/core/services/sosyal_medya_motoru.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../env.dart';

class SosyalMedyaMotoru {

  // DEFAULT GÖRSEL - MÜŞTERİ RESİM EKLEMEZSE BU GİDER
  static const String _defaultIlanGorseli = "https://pub-63efa1c2a7de49f4a20c67bfcefeb342.r2.dev/default.jpg";

  static Future<void> _logRobot(String message) async {
    try {
      await FirebaseFirestore.instance.collection('robot_logs').add({
        'message': "🚨 KRİTİK HATA: $message",
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'error'
      });
    } catch (e) {}
  }

  static Future<String> _getPublicUrl(String gorselUrl) async {
    try {
      if (gorselUrl.startsWith('http')) return gorselUrl;
      return await FirebaseStorage.instance.ref(gorselUrl).getDownloadURL();
    } catch (e) {
      return _defaultIlanGorseli;
    }
  }

  static String _detaylariDuzgunMetneCevir(Map<String, dynamic> detaylar) {
    return detaylar.entries.map((e) {
      String deger = e.value is List ? (e.value as List).join(", ") : e.value.toString();
      return "${e.key}: $deger";
    }).join("\n");
  }

  // FACEBOOK
  static Future<void> facebookPaylas(String baslik, String sehir, String kategori, Map<String, dynamic> detaylar, String gorselUrl) async {
    try {
      final String pageId = Env.facebookPageId;
      final String accessToken = Env.facebookPageToken;

      if (pageId.isEmpty || accessToken.isEmpty) {
        await _logRobot("Facebook yapılandırma değerleri boş! .env kontrol et");
        return;
      }

      String detayMetni = _detaylariDuzgunMetneCevir(detaylar);
      String message = "UstamGelsin'de Yeni İş Fırsatı!\n\nİş Tanımı: $baslik\nKategori: $kategori\nBölge: $sehir\n\nDetaylar:\n$detayMetni\n\nDetaylar için uygulamayı indir!";

      final String kullanilacakGorsel = gorselUrl.isNotEmpty ? gorselUrl : _defaultIlanGorseli;
      String publicUrl = await _getPublicUrl(kullanilacakGorsel);

      final response = await http.post(
        Uri.parse('https://graph.facebook.com/v20.0/$pageId/photos'),
        body: {
          'url': publicUrl,
          'caption': message,
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

  // INSTAGRAM - REVİZE EDİLDİ
  static Future<void> instagramPaylas(String baslik, String sehir, String kategori, Map<String, dynamic> detaylar, String gorselUrl) async {
    try {
      final String igBusinessId = Env.instagramBusinessId;
      final String accessToken = Env.instagramToken;

      if (igBusinessId.isEmpty || accessToken.isEmpty) {
        await _logRobot("Instagram yapılandırma değerleri boş! .env kontrol et");
        return;
      }

      String detayMetni = _detaylariDuzgunMetneCevir(detaylar);
      String caption = "$baslik\n\n📍 $sehir\n\nKategori: $kategori\n\nDetaylar:\n$detayMetni\n\n#${kategori.replaceAll(' ', '')} #hemenustamgelsin";

      final String kullanilacakGorsel = gorselUrl.isNotEmpty ? gorselUrl : _defaultIlanGorseli;
      String publicUrl = await _getPublicUrl(kullanilacakGorsel);

      // 1. Container oluştur - POST body ile
      final uploadRes = await http.post(
        Uri.parse('https://graph.facebook.com/v20.0/$igBusinessId/media'),
        body: {
          'image_url': publicUrl,
          'caption': caption,
          'access_token': accessToken,
        },
      );

      if (uploadRes.statusCode != 200) {
        await _logRobot("Instagram Upload Hatası (${uploadRes.statusCode}): ${uploadRes.body}");
        return;
      }

      final String creationId = jsonDecode(uploadRes.body)['id'];

      // 2. Yayınla - POST body ile
      final publishRes = await http.post(
        Uri.parse('https://graph.facebook.com/v20.0/$igBusinessId/media_publish'),
        body: {
          'creation_id': creationId,
          'access_token': accessToken,
        },
      );

      if (publishRes.statusCode != 200) {
        await _logRobot("Instagram Publish Hatası (${publishRes.statusCode}): ${publishRes.body}");
      }
    } catch (e) {
      await _logRobot("Instagram Paylaşım Hatası: $e");
    }
  }
}