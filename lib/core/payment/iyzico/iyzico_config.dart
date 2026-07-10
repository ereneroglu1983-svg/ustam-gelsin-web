// lib/core/payment/iyzico/iyzico_config.dart

class IyzicoConfig {
  // SADECE BACKEND BİLİR - FRONTEND'DE KEY YOK
  // baseUrl da yok. iyzico ile direkt konuşmuyoruz.

  // Firebase Function endpointleri - callable kullandığımız için URL yok
  // Direkt function adını kullanacağız

  // Kullanıcı ödeme sonrası yönleneceği sayfalar
  static const String successUrl = "https://ustamgelsin.com/odeme/basarili";
  static const String failUrl = "https://ustamgelsin.com/odeme/basarisiz";

// Callback'i Firebase Function handle ediyor, bizim URL vermemize gerek yok
// iyzicoCallback function'ı otomatik /iyzicoCallback endpointini açıyor
}