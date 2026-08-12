// lib/core/payment/iyzico/iyzico_config.dart

class IyzicoConfig {
  // Kullanıcı ödeme sonrası yönleneceği sayfalar
  static const String successUrl = "https://hemenustamgelsin.com/odeme-basarili";
  static const String failUrl = "https://hemenustamgelsin.com/odeme-basarisiz";

  // CANLI / SANDBOX AYARI - TEK YERDEN KONTROL
  static const String liveBaseUrl = "https://api.iyzipay.com";
  static const String sandboxBaseUrl = "https://sandbox-api.iyzipay.com";

  // CANLIDAYIZ - değiştirmek istersen liveBaseUrl -> sandboxBaseUrl yap
  static const String baseUrl = liveBaseUrl;
}