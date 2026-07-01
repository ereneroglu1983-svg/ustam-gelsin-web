import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GEMINI_API_KEY')
  static const String geminiApiKey = _Env.geminiApiKey;

  @EnviedField(varName: 'R2_ACCESS_KEY')
  static const String r2AccessKey = _Env.r2AccessKey;

  @EnviedField(varName: 'R2_SECRET_KEY')
  static const String r2SecretKey = _Env.r2SecretKey;

  @EnviedField(varName: 'R2_ENDPOINT')
  static const String r2Endpoint = _Env.r2Endpoint;

  @EnviedField(varName: 'FIREBASE_API_KEY_ANDROID')
  static const String firebaseApiKeyAndroid = _Env.firebaseApiKeyAndroid;

  @EnviedField(varName: 'FIREBASE_API_KEY_WEB')
  static const String firebaseApiKeyWeb = _Env.firebaseApiKeyWeb;

  @EnviedField(varName: 'FIREBASE_API_KEY_IOS')
  static const String firebaseApiKeyIos = _Env.firebaseApiKeyIos;

  @EnviedField(varName: 'ADMIN_PHONE_TOKEN')
  static const String adminPhoneToken = _Env.adminPhoneToken;

  @EnviedField(varName: 'BILLING_API_URL')
  static const String billingApiUrl = _Env.billingApiUrl;

  @EnviedField(varName: 'BILLING_API_KEY')
  static const String billingApiKey = _Env.billingApiKey;

  @EnviedField(varName: 'IG_APP_ID')
  static const String igAppId = _Env.igAppId;

  @EnviedField(varName: 'IG_APP_SECRET')
  static const String igAppSecret = _Env.igAppSecret;

  @EnviedField(varName: 'AKBANK_MERCHANT_ID')
  static const String akbankMerchantId = _Env.akbankMerchantId;

  @EnviedField(varName: 'AKBANK_API_KEY')
  static const String akbankApiKey = _Env.akbankApiKey;

  @EnviedField(varName: 'AKBANK_SECRET_KEY')
  static const String akbankSecretKey = _Env.akbankSecretKey;

  @EnviedField(varName: 'AKBANK_BASE_URL')
  static const String akbankBaseUrl = _Env.akbankBaseUrl;

  @EnviedField(varName: 'AKBANK_STORE_KEY')
  static const String akbankStoreKey = _Env.akbankStoreKey;

  @EnviedField(varName: 'BASE_APP_URL')
  static const String baseAppUrl = _Env.baseAppUrl;

  @EnviedField(varName: 'R2_FLUTTER_ACCESS_KEY')
  static const String r2FlutterAccessKey = _Env.r2FlutterAccessKey;

  @EnviedField(varName: 'R2_FLUTTER_SECRET_KEY')
  static const String r2FlutterSecretKey = _Env.r2FlutterSecretKey;

  @EnviedField(varName: 'R2_FLUTTER_ENDPOINT')
  static const String r2FlutterEndpoint = _Env.r2FlutterEndpoint;

  @EnviedField(varName: 'FACEBOOK_PAGE_TOKEN')
  static const String facebookPageToken = _Env.facebookPageToken;

  @EnviedField(varName: 'FACEBOOK_PAGE_ID')
  static const String facebookPageId = _Env.facebookPageId;

  @EnviedField(varName: 'INSTAGRAM_BUSINESS_ID')
  static const String instagramBusinessId = _Env.instagramBusinessId;

  @EnviedField(varName: 'INSTAGRAM_TOKEN')
  static const String instagramToken = _Env.instagramToken;
}