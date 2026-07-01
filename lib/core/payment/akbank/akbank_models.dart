// lib/core/payment/akbank/akbank_models.dart

/// Bankaya 3D ödeme başlatma için gönderilecek istek modeli
/// DİKKAT: Kart bilgileri ASLA buraya gelmez. Banka kendi sayfasında alır.
class AkbankPaymentRequest {
  final String merchantId;
  final String orderId;
  final String amount; // "100.00" formatında string
  final String okUrl; // 3D başarılı olunca yönlenecek URL
  final String failUrl; // 3D başarısız olunca yönlenecek URL
  final String callbackUrl; // Bankanın sunucu-sunucu POST atacağı URL
  final String hash; // Güvenlik imzası
  final String storeKey;
  final String lang; // "tr" veya "en"
  final String userEmail; // Fatura bilgisi için
  final String userId; // Takip için

  AkbankPaymentRequest({
    required this.merchantId,
    required this.orderId,
    required this.amount,
    required this.okUrl,
    required this.failUrl,
    required this.callbackUrl,
    required this.hash,
    required this.storeKey,
    this.lang = 'tr',
    required this.userEmail,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'orderId': orderId,
      'amount': amount,
      'okUrl': okUrl,
      'failUrl': failUrl,
      'callbackUrl': callbackUrl,
      'hash': hash,
      'storeKey': storeKey,
      'lang': lang,
      'email': userEmail,
      'userId': userId,
    };
  }
}

/// Bankadan ödeme başlatma sonrası dönen yanıt modeli
/// Genelde 3D'ye yönlendirecek URL veya HTML form döner
class AkbankInitiateResponse {
  final bool isSuccess;
  final String redirectUrl; // 3D sayfası URL'i
  final String form3D; // Bazı bankalar HTML form döner
  final String message;
  final String orderId;

  AkbankInitiateResponse({
    required this.isSuccess,
    required this.redirectUrl,
    required this.form3D,
    required this.message,
    required this.orderId,
  });

  factory AkbankInitiateResponse.fromJson(Map<String, dynamic> json) {
    return AkbankInitiateResponse(
      isSuccess: json['status']?.toString().toLowerCase() == 'success' ||
          json['resultCode']?.toString() == '0000',
      redirectUrl: json['redirectUrl']?.toString() ??
          json['paymentUrl']?.toString() ?? '',
      form3D: json['form3d']?.toString() ?? json['html']?.toString() ?? '',
      message: json['message']?.toString() ?? json['resultMsg']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
    );
  }
}

/// Bankadan callback ile gelen ödeme sonucu modeli
class AkbankCallbackResponse {
  final String orderId;
  final String status; // "success", "failed", "approved"
  final String amount;
  final String transactionId; // Bankanın ref no
  final String hash; // İmza doğrulama için
  final String message;
  final String authCode; // Provizyon kodu

  AkbankCallbackResponse({
    required this.orderId,
    required this.status,
    required this.amount,
    required this.transactionId,
    required this.hash,
    required this.message,
    required this.authCode,
  });

  factory AkbankCallbackResponse.fromJson(Map<String, dynamic> json) {
    return AkbankCallbackResponse(
      orderId: json['orderId']?.toString() ?? '',
      status: json['status']?.toString() ?? json['result']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0.00',
      transactionId: json['transactionId']?.toString() ??
          json['refNo']?.toString() ??
          json['transId']?.toString() ?? '',
      hash: json['hash']?.toString() ?? json['signature']?.toString() ?? '',
      message: json['message']?.toString() ?? json['resultMsg']?.toString() ?? '',
      authCode: json['authCode']?.toString() ?? json['provisionCode']?.toString() ?? '',
    );
  }

  bool get isSuccess =>
      status.toLowerCase() == 'success' ||
          status.toLowerCase() == 'approved' ||
          status == '0000';
}