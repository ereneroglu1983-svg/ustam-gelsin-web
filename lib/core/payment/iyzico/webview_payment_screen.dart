// lib/core/payment/iyzico/webview_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ustam_gelsin/features/wallet/screens/odeme_sonuc_screen.dart';
import 'iyzico_config.dart';
import 'dart:html' as html;

class WebviewPaymentScreen extends StatefulWidget {
  final String? paymentUrl;
  final String? checkoutFormContent;
  final String orderId;
  final String conversationId;

  const WebviewPaymentScreen({
    super.key,
    this.paymentUrl,
    this.checkoutFormContent,
    required this.orderId,
    this.conversationId = '',
  });

  factory WebviewPaymentScreen.fromUrl({Key? key, required String paymentUrl, required String orderId}) {
    return WebviewPaymentScreen(key: key, paymentUrl: paymentUrl, orderId: orderId);
  }

  @override
  State<WebviewPaymentScreen> createState() => _WebviewPaymentScreenState();
}

class _WebviewPaymentScreenState extends State<WebviewPaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasFinished = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initWebForWeb();
    } else {
      _initWebViewMobile();
    }
  }

  void _initWebForWeb() {
    debugPrint("========== WEB PAYMENT INIT ==========");
    debugPrint("PAYMENT URL = ${widget.paymentUrl}");
    debugPrint("ORDER ID = ${widget.orderId}");

    if (widget.paymentUrl == null || widget.paymentUrl!.isEmpty) {
      debugPrint("HATA: paymentPageUrl null veya bos!");
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    // RESMI IYZICO REDIRECT YONTEMI
    // cpp.iyzipay.com iframe'i engelliyor (X-Frame-Options: DENY)
    // Bu yuzden iframe kullanmiyoruz, direkt redirect yapiyoruz
    final redirectUrl = widget.paymentUrl!;
    debugPrint("REDIRECTING TO = $redirectUrl");
    debugPrint("======================================");

    // Tarayiciyi direkt Iyzico odeme sayfasina yonlendir
    html.window.location.href = redirectUrl;
  }

  void _initWebViewMobile() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            final url = request.url;
            debugPrint("WEBVIEW NAVIGATION: $url");

            if (url.startsWith('hemenustam://payment-success') || url.startsWith(IyzicoConfig.successUrl)) {
              _finishWithResult(true, "Ödeme başarılı! Bakiye güncelleniyor...");
              return NavigationDecision.prevent;
            }
            if (url.startsWith('hemenustam://payment-fail') || url.startsWith(IyzicoConfig.failUrl)) {
              _finishWithResult(false, "Ödeme başarısız veya iptal edildi.");
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    if (widget.checkoutFormContent != null && widget.checkoutFormContent!.isNotEmpty) {
      final htmlContent =
          '<html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head><body style="margin:0;padding:0;"><div id="iyzipay-checkout-form" class="responsive"></div>${widget.checkoutFormContent}</body></html>';
      _controller.loadHtmlString(htmlContent, baseUrl: IyzicoConfig.baseUrl);
    } else if (widget.paymentUrl != null && widget.paymentUrl!.isNotEmpty) {
      _controller.loadRequest(Uri.parse(widget.paymentUrl!));
    }
  }

  void _finishWithResult(bool success, String message) {
    if (_hasFinished) return;
    _hasFinished = true;
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => OdemeSonucScreen(isSuccess: success, message: message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // WEB'DE: Redirect yapiliyor, o yuzden sadece loading goster
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text("Güvenli Ödeme'ye Yonlendiriliyor...")),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Iyzico Güvenli Ödeme Sayfasına Yönlendiriliyorsunuz..."),
            ],
          ),
        ),
      );
    }

    // MOBIL: Eski gibi WebView ile calisir, HIC BOZULMADI
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _finishWithResult(false, "Ödeme iptal edildi.");
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Güvenli Ödeme"),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => _finishWithResult(false, "Ödeme iptal edildi.")),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}