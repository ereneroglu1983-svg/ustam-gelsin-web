// lib/core/payment/akbank/webview_payment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'akbank_config.dart';
import 'akbank_manager.dart';

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
  final AkbankManager _manager = AkbankManager();
  bool _isLoading = true;
  bool _isProcessing = false;
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

            if (url.startsWith(AkbankConfig.successUrl)) {
              // DÜZELTME: async kaldırıldı, Future microtask
              Future.microtask(() => _handlePaymentResult(true));
              return NavigationDecision.prevent;
            }

            if (url.startsWith(AkbankConfig.failUrl)) {
              Future.microtask(() => _handlePaymentResult(false));
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            debugPrint("WebView Error: ${error.description}");
            _handlePaymentResult(false, errorMsg: "Bağlantı hatası oluştu");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  Future<void> _handlePaymentResult(bool isSuccess, {String? errorMsg}) async {
    if (_isProcessing || _hasFinished) return;
    _isProcessing = true;
    if (mounted) setState(() {});

    try {
      if (isSuccess) {
        final verified = await _manager.verifyAndCompletePayment(widget.orderId);
        if (!mounted) return;

        if (verified) {
          _finishWithResult(true, "Ödeme başarılı! Bakiyeniz yüklendi.");
        } else {
          _finishWithResult(false, "Ödeme doğrulanamadı. Lütfen bakiyenizi kontrol edin.");
        }
      } else {
        _finishWithResult(false, errorMsg ?? "Ödeme iptal edildi veya başarısız oldu.");
      }
    } catch (e) {
      _finishWithResult(false, "İşlem sırasında hata: $e");
    } finally {
      _isProcessing = false;
    }
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

  Future<bool> _onWillPop() async {
    if (_isProcessing) return false;
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
              onPressed: _isProcessing ? null : () => _finishWithResult(false, "Ödeme iptal edildi."),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading || _isProcessing)
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