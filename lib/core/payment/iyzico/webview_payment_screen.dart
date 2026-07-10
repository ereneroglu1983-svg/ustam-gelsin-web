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
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _finishWithResult(bool success, String message) {
    if (_hasFinished) return;
    _hasFinished = true;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      Navigator.of(context).pop(success);
    }
  }

  @override
  Widget build(BuildContext context) {
    // PopScope kullanımı
    return PopScope(
      canPop: false, // Kullanıcının geri tuşuyla çat diye çıkmasını engelle
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
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