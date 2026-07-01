// lib/core/payment/akbank/akbank_hash_service.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:ustam_gelsin/env.dart';

class AkbankHashService {
  /// ÖDEME BAŞLATMA HASH'İ - Bankaya istek atarken kullanılır
  /// Sıralama: MerchantID + OrderID + Amount + StoreKey + SecretKey
  /// NOT: Banka dokümanı gelince sıralama değişirse güncellenecek.
  static String generateHash(String orderId, String amount) {
    final String data = "${Env.akbankMerchantId}$orderId$amount${Env.akbankStoreKey}${Env.akbankSecretKey}";
    final bytes = utf8.encode(data);
    return sha256.convert(bytes).toString();
  }

  /// CALLBACK HASH'İ - Bankadan gelen isteği doğrulamak için kullanılır
  /// Sıralama: MerchantID + OrderID + Amount + Status + StoreKey + SecretKey
  /// NOT: Bankalar genelde callback'te status de ekler. Dokümana göre revize edilir.
  static String generateCallbackHash({
    required String orderId,
    required String amount,
    required String status,
  }) {
    final String data = "${Env.akbankMerchantId}$orderId$amount$status${Env.akbankStoreKey}${Env.akbankSecretKey}";
    final bytes = utf8.encode(data);
    return sha256.convert(bytes).toString();
  }

  /// 3D FORM HASH'İ - Bazı bankalar 3D formu için ayrı hash ister
  /// Sıralama dokümana göre değişir. Şimdilik standart.
  static String generate3DHash({
    required String orderId,
    required String amount,
    required String okUrl,
    required String failUrl,
  }) {
    final String data = "${Env.akbankMerchantId}$orderId$amount$okUrl$failUrl${Env.akbankStoreKey}${Env.akbankSecretKey}";
    final bytes = utf8.encode(data);
    return sha256.convert(bytes).toString();
  }
}