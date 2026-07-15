// lib/core/payment/iyzico/webview_payment_screen.dart

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ustam_gelsin/features/wallet/screens/odeme_sonuc_screen.dart';
import 'iyzico_config.dart';

class WebviewPaymentScreen extends StatefulWidget {
  // 1. REVİZE: Artık URL değil form içeriği, geriye uyum için ikisi de opsiyonel
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

  // Eski kullanım için factory
  factory WebviewPaymentScreen.fromUrl({
    Key? key,
    required String paymentUrl,
    required String orderId,
  }) {
    return WebviewPaymentScreen(
      key: key,
      paymentUrl: paymentUrl,
      orderId: orderId,
    );
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
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            final url = request.url;
            // 2. REVİZE: Gerçek callback - hemenustam://
            if (url.startsWith('hemenustam://payment-success')) {
              _finishWithResult(true, "Ödeme başarılı! Bakiye güncelleniyor...");
              return NavigationDecision.prevent;
            }
            if (url.startsWith('hemenustam://payment-fail')) {
              _finishWithResult(false, "Ödeme başarısız veya iptal edildi.");
              return NavigationDecision.prevent;
            }
            // Geriye uyum: Eski IyzicoConfig URL'leri hala çalışsın
            if (url.startsWith(IyzicoConfig.successUrl)) {
              _finishWithResult(true, "Ödeme başarılı! Bakiye güncelleniyor...");
              return NavigationDecision.prevent;
            }
            if (url.startsWith(IyzicoConfig.failUrl)) {
              _finishWithResult(false, "Ödeme başarısız veya iptal edildi.");
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    // 1. REVİZE: Form içeriği varsa HTML bas, yoksa URL yükle
    if (widget.checkoutFormContent != null && widget.checkoutFormContent!.isNotEmpty) {
      final html = '''
        <html>
          <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
          <body style="margin:0;padding:0;">
            <div id="iyzipay-checkout-form" class="responsive"></div>
            ${widget.checkoutFormContent}
          </body>
        </html>
      ''';
      _controller.loadHtmlString(html, baseUrl: "https://sandbox-api.iyzipay.com");
    } else if (widget.paymentUrl != null && widget.paymentUrl!.isNotEmpty) {
      _controller.loadRequest(Uri.parse(widget.paymentUrl!));
    } else {
      debugPrint('[WEBVIEW] Ne URL ne de checkoutFormContent var!');
    }
  }

  void _finishWithResult(bool success, String message) {
    if (_hasFinished) return;
    _hasFinished = true;

    if (!mounted) return;

    // YENİ AKIŞ: SnackBar + pop yerine tam sayfa sonuç ekranı
    // Bu ekran kendi içinde 3 sn sonra UstaProfilSayfasi'na atacak
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OdemeSonucScreen(
          isSuccess: success,
          message: message,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Çift pop engellendi, tek noktadan çıkış -> başarısız ekranına git
        _finishWithResult(false, "Ödeme iptal edildi.");
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Güvenli Ödeme"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _finishWithResult(false, "Ödeme iptal edildi."),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}