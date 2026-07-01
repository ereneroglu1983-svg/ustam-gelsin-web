// lib/core/payment/akbank/akbank_provider.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'akbank_config.dart';
import 'akbank_hash_service.dart';

class AkbankProvider {
  /// 3D Secure ödeme başlatma isteği
  /// Banka sana 3D HTML form veya redirectUrl döner
  Future<Map<String, dynamic>> initiatePayment({
    required String orderId,
    required String amount,
    required String userEmail,
    required String userId,
  }) async {
    // 1. Hash üret - storeKey dahil
    final String hash = AkbankHashService.generateHash(orderId, amount);

    // 2. Banka 3D için bunları ister
    final Map<String, String> body = {
      "merchantId": AkbankConfig.merchantId,
      "storeKey": AkbankConfig.storeKey,
      "orderId": orderId,
      "amount": amount, // "100.00" formatında
      "currency": "949", // TL kodu
      "successUrl": AkbankConfig.successUrl,
      "failUrl": AkbankConfig.failUrl,
      "hash": hash,
      "lang": "tr",
      "userEmail": userEmail,
      "userId": userId,
      "rnd": DateTime.now().microsecondsSinceEpoch.toString(), // Cache engelle
    };

    try {
      final response = await http.post(
        Uri.parse("${AkbankConfig.baseUrl}/payment/3d"), // Dokümana göre değişir
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
        },
        body: body,
      ).timeout(const Duration(seconds: 30));

      debugPrint("Akbank initiate status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Banka genelde 3 şekilde döner:
        // 1. {"status":"success", "redirectUrl":"https://..."}
        // 2. {"status":"success", "htmlForm":"<form>...</form>"}
        // 3. {"result":"approved", "url":"https://..."}

        if (data['status']?.toString().toLowerCase() == 'success' ||
            data['result']?.toString().toLowerCase() == 'approved') {
          return {
            "status": "success",
            "redirectUrl": data['redirectUrl'] ?? data['url'] ?? '',
            "htmlForm": data['htmlForm'] ?? data['form3d'] ?? '',
            "message": "3D formu hazır",
          };
        } else {
          return {
            "status": "error",
            "message": data['message'] ?? data['error'] ?? 'Banka ödeme başlatamadı',
          };
        }
      } else {
        return {
          "status": "error",
          "message": "Banka sunucusu hata döndü: ${response.statusCode}",
        };
      }
    } catch (e) {
      debugPrint("Akbank initiate hata: $e");
      return {
        "status": "error",
        "message": "Bağlantı hatası: $e",
      };
    }
  }

  /// Ödeme durumunu sorgula - Callback gelmezse manuel kontrol
  Future<Map<String, dynamic>?> queryPaymentStatus(String orderId) async {
    // Sorgu için de hash gerekir
    final String hash = AkbankHashService.generateHash(orderId, "0.00"); // Amount 0 genelde

    final Map<String, String> body = {
      "merchantId": AkbankConfig.merchantId,
      "storeKey": AkbankConfig.storeKey,
      "orderId": orderId,
      "hash": hash,
    };

    try {
      final response = await http.post(
        Uri.parse("${AkbankConfig.baseUrl}/payment/status"), // Dokümana göre
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
        },
        body: body,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      debugPrint("Akbank status query hata: $e");
      return null;
    }
  }
}