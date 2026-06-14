import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SosyalMedyaMotoru {
  // FIRESTORE'DAN VERİ ÇEKMEK İÇİN YENİ METOT
  static Future<Map<String, dynamic>> _getSosyalMedyaConfig() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('settings')
        .doc('sosyal_medya_config')
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  // ROBOT GÜNLÜĞÜNE HATA KAYDETME METODU
  static Future<void> _logRobot(String message) async {
    try {
      await FirebaseFirestore.instance.collection('robot_logs').add({
        'message': "🚨 KRİTİK HATA: $message",
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'error'
      });
    } catch (e) {
      print("Robot günlüğü yazılamadı: $e");
    }
  }

  static Future<String> _getPublicUrl(String gorselUrl) async {
    try {
      // Eğer zaten http/https ile başlıyorsa public bir linktir
      if (gorselUrl.startsWith('http')) return gorselUrl;

      // Firebase Storage içinden gelen path ise URL'e çevir
      return await FirebaseStorage.instance.ref(gorselUrl).getDownloadURL();
    } catch (e) {
      return "https://hemenustamgelsin.com/default-image.jpg";
    }
  }

  // Orijinal yapıyı koruyarak eklenen güvenli metin dönüştürücü
  static String _detaylariDuzgunMetneCevir(Map<String, dynamic> detaylar) {
    return detaylar.entries.map((e) {
      String deger = e.value is List ? (e.value as List).join(", ") : e.value.toString();
      return "${e.key}: $deger";
    }).join("\n");
  }

  static Future<void> facebookPaylas(String baslik, String sehir, String kategori, Map<String, dynamic> detaylar, String gorselUrl) async {
    try {
      // AYARLARI FIRESTORE'DAN AL
      final config = await _getSosyalMedyaConfig();
      final String pageId = config['fb_page_id'];
      final String accessToken = config['fb_access_token'];

      if (pageId.isEmpty || accessToken.isEmpty) {
        String err = "Facebook yapılandırma değerleri boş!";
        print("❌ Hata: $err");
        await _logRobot(err);
        return;
      }

      // Detayları güvenli metod ile dönüştür
      String detayMetni = _detaylariDuzgunMetneCevir(detaylar);

      String message = "UstamGelsin'de Yeni İş Fırsatı!\n\nİş Tanımı: $baslik\nKategori: $kategori\nBölge: $sehir\n\nDetaylar:\n$detayMetni\n\nDetaylar için uygulamayı indir!";

      var response = await http.post(
        Uri.parse('https://graph.facebook.com/v20.0/$pageId/feed'),
        body: {
          'message': message,
          'access_token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        print("🚀 Facebook paylaşımı başarılı!");
      } else {
        String err = "Facebook API Hatası (${response.statusCode}): ${response.body}";
        print("❌ $err");
        await _logRobot(err);
      }
    } catch (e) {
      String err = "Facebook Paylaşım Hatası: $e";
      print("❌ $err");
      await _logRobot(err);
    }
  }
}