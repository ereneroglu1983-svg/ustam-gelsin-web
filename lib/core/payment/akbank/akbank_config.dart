// lib/core/payment/akbank/akbank_config.dart

import 'package:ustam_gelsin/env.dart';

class AkbankConfig {
  // Banka tarafından verilen kimlik bilgileri
  static String get merchantId => Env.akbankMerchantId;
  static String get apiKey => Env.akbankApiKey;
  static String get secretKey => Env.akbankSecretKey;
  static String get storeKey => Env.akbankStoreKey; // Hash için zorunlu
  static String get baseUrl => Env.akbankBaseUrl;

  // 3D Secure callback ve yönlendirme URL'leri - BANKA BUNLARI İSTER
  static String get callbackUrl => "${Env.baseAppUrl}/api/payment/akbank/callback";
  static String get successUrl => "${Env.baseAppUrl}/odeme/basarili";
  static String get failUrl => "${Env.baseAppUrl}/odeme/basarisiz";
}