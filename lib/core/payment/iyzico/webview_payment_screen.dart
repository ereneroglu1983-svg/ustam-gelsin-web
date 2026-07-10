// lib/core/payment/iyzico/webview_payment_screen.dart

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'iyzico_config.dart';

class WebviewPaymentScreen extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const WebviewPaymentScreen({
    super.key,
    required this.paymentUrl,
    required this.orderId,
  });

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

            // SİLİNDİ: AkbankConfig → IyzicoConfig
            if (url.startsWith(IyzicoConfig.successUrl)) {
              _finishWithResult(true, "Ödeme başarılı! Bakiye yükleniyor...");
              return NavigationDecision.prevent;
            }

            if (url.startsWith(IyzicoConfig.failUrl)) {
              _finishWithResult(false, "Ödeme başarısız veya iptal edildi.");
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            debugPrint("WebView Error: ${error.description}");
            _finishWithResult(false, "Bağlantı hatası oluştu");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  // SİLİNDİ: _handlePaymentResult komple gitti
  // Sebep: verifyAndCompletePayment yok. Bakiye yüklemeyi backend yaptı.

  void _finishWithResult(bool success, String message) {
    if (_hasFinished) return;
    _hasFinished = true;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      // true dönerse bir önceki sayfa "bakiye stream'i dinle" diyecek
      Navigator.of(context).pop(success);
    }
  }

  Future<bool> _onWillPop() async {
    _finishWithResult(false, "Ödeme iptal edildi.");
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Güvenli Ödeme"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _finishWithResult(false, "Ödeme iptal edildi."),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}