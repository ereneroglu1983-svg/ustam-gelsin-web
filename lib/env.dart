import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'GEMINI_API_KEY')
  static final String geminiApiKey = _Env.geminiApiKey;

  @EnviedField(varName: 'R2_ACCESS_KEY')
  static final String r2AccessKey = _Env.r2AccessKey;

  @EnviedField(varName: 'R2_SECRET_KEY')
  static final String r2SecretKey = _Env.r2SecretKey;

  @EnviedField(varName: 'R2_ENDPOINT')
  static final String r2Endpoint = _Env.r2Endpoint;

  @EnviedField(varName: 'FIREBASE_API_KEY_ANDROID')
  static final String firebaseApiKeyAndroid = _Env.firebaseApiKeyAndroid;

  @EnviedField(varName: 'FIREBASE_API_KEY_WEB')
  static final String firebaseApiKeyWeb = _Env.firebaseApiKeyWeb;

  @EnviedField(varName: 'FIREBASE_API_KEY_IOS')
  static final String firebaseApiKeyIos = _Env.firebaseApiKeyIos;

  @EnviedField(varName: 'ADMIN_PHONE_TOKEN')
  static final String adminPhoneToken = _Env.adminPhoneToken;

  @EnviedField(varName: 'BILLING_API_URL')
  static final String billingApiUrl = _Env.billingApiUrl;

  @EnviedField(varName: 'BILLING_API_KEY')
  static final String billingApiKey = _Env.billingApiKey;

  @EnviedField(varName: 'IG_APP_ID')
  static final String igAppId = _Env.igAppId;

  @EnviedField(varName: 'IG_APP_SECRET')
  static final String igAppSecret = _Env.igAppSecret;

  @EnviedField(varName: 'AKBANK_MERCHANT_ID')
  static final String akbankMerchantId = _Env.akbankMerchantId;

  @EnviedField(varName: 'AKBANK_API_KEY')
  static final String akbankApiKey = _Env.akbankApiKey;

  @EnviedField(varName: 'AKBANK_SECRET_KEY')
  static final String akbankSecretKey = _Env.akbankSecretKey;

  @EnviedField(varName: 'AKBANK_BASE_URL')
  static final String akbankBaseUrl = _Env.akbankBaseUrl;

  @EnviedField(varName: 'AKBANK_STORE_KEY')
  static final String akbankStoreKey = _Env.akbankStoreKey;

  @EnviedField(varName: 'BASE_APP_URL')
  static final String baseAppUrl = _Env.baseAppUrl;

  @EnviedField(varName: 'R2_FLUTTER_ACCESS_KEY')
  static final String r2FlutterAccessKey = _Env.r2FlutterAccessKey;

  @EnviedField(varName: 'R2_FLUTTER_SECRET_KEY')
  static final String r2FlutterSecretKey = _Env.r2FlutterSecretKey;

  @EnviedField(varName: 'R2_FLUTTER_ENDPOINT')
  static final String r2FlutterEndpoint = _Env.r2FlutterEndpoint;

  @EnviedField(varName: 'R2_PUBLIC_URL')
  static final String r2PublicUrl = _Env.r2PublicUrl;

  @EnviedField(varName: 'FACEBOOK_PAGE_TOKEN')
  static final String facebookPageToken = _Env.facebookPageToken;

  @EnviedField(varName: 'FACEBOOK_PAGE_ID')
  static final String facebookPageId = _Env.facebookPageId;

  @EnviedField(varName: 'INSTAGRAM_BUSINESS_ID')
  static final String instagramBusinessId = _Env.instagramBusinessId;

  @EnviedField(varName: 'INSTAGRAM_TOKEN')
  static final String instagramToken = _Env.instagramToken;

  @EnviedField(varName: 'GROQ_API_KEY')
  static final String groqApiKey = _Env.groqApiKey;

  // ✅ YENİ EKLENDİ - XAI GROK
  @EnviedField(varName: 'XAI_API_KEY')
  static final String xaiApiKey = _Env.xaiApiKey;
}