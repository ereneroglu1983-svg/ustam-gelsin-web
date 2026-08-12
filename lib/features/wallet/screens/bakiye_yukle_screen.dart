// lib/features/wallet/screens/bakiye_yukle_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'odeme_sonuc_screen.dart';

class BakiyeYukleScreen extends StatefulWidget {
  const BakiyeYukleScreen({super.key});

  @override
  State<BakiyeYukleScreen> createState() => _BakiyeYukleScreenState();
}

class _BakiyeYukleScreenState extends State<BakiyeYukleScreen> {
  final Color primaryRed = const Color(0xFFDC143C);
  final Color navyBlue = const Color(0xFF000080);
  final Color darkBg = const Color(0xFF0F0F0F);
  final Color cardBg = const Color(0xFF1A1A1A);
  final Color borderColor = const Color(0xFF2A2A2A);

  int? _secilenTutar;
  final TextEditingController _manuelTutarController = TextEditingController();
  bool _kvkkOnay = false;
  bool _sozlesmeOnay = false;
  bool _isProcessing = false;

  final List<int> hazirTutarlar = [50, 100, 250, 500, 1000];

  @override
  void dispose() {
    _manuelTutarController.dispose();
    super.dispose();
  }

  int get _yuklenecekTutar {
    if (_secilenTutar!= null) return _secilenTutar!;
    return int.tryParse(_manuelTutarController.text)?? 0;
  }

  bool get _odemeAktif {
    return _yuklenecekTutar >= 10 && _kvkkOnay && _sozlesmeOnay &&!_isProcessing;
  }

  void _tutarSec(int? tutar) {
    setState(() {
      _secilenTutar = tutar;
      if (tutar!= null) _manuelTutarController.clear();
    });
  }

  Future<Map<String, String>> _konumCozumle() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userData = userDoc.data()?? {};

      final sehirId = (userData['sehir_id']?? '34').toString();
      final ilceId = (userData['ilce_id']?? '').toString();
      final adres = (userData['faturaAdresi']?? userData['adres']?? 'Manisa Salihli Merkez').toString();

      final String ilcelerStr = await rootBundle.loadString('assets/data/ilceler.json');
      final List ilceler = jsonDecode(ilcelerStr);

      Map? bulunanIlce;
      if (ilceId.isNotEmpty) {
        try {
          bulunanIlce = ilceler.firstWhere((e) => e['ilce_id'].toString() == ilceId) as Map;
        } catch (_) {}
      }
      bulunanIlce??= ilceler.firstWhere((e) => e['sehir_id'].toString() == sehirId, orElse: () => null) as Map?;

      String normalize(String s) {
        if (s.isEmpty) return s;
        final lower = s.toLowerCase();
        return lower[0].toUpperCase() + lower.substring(1);
      }

      if (bulunanIlce!= null) {
        return {
          'city': normalize(bulunanIlce['sehir_adi'].toString()),
          'district': normalize(bulunanIlce['ilce_adi'].toString()),
          'address': adres,
        };
      }
      return {'city': 'Istanbul', 'district': 'Kadikoy', 'address': adres};
    } catch (e) {
      return {'city': 'Istanbul', 'district': 'Kadikoy', 'address': 'Adres bilgisi'};
    }
  }

  Future<void> _iyzicoOdemeBaslat({required bool iyzicoIleOde}) async {
    if (!_odemeAktif) return;

    setState(() => _isProcessing = true);
    HapticFeedback.mediumImpact();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Kullanıcı girişi gerekli');

      final konum = await _konumCozumle();
      final functions = FirebaseFunctions.instanceFor(region: 'europe-west3');
      final callable = functions.httpsCallable('checkout');

      final requestData = {
        'amount': _yuklenecekTutar,
        'city': konum['city'],
        'district': konum['district'],
        'address': konum['address'],
        'platform': kIsWeb? 'web' : 'mobile',
      };

      final result = await callable.call(requestData);
      final data = result.data as Map;
      final checkoutFormContent = data['checkoutFormContent'] as String?;

      if (checkoutFormContent == null || checkoutFormContent.isEmpty) {
        throw Exception('Ödeme formu alınamadı');
      }

      if (!mounted) return;

      final int gonderilenTutar = _yuklenecekTutar;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(backgroundColor: cardBg, title: const Text("Güvenli Ödeme", style: TextStyle(color: Colors.white))),
            body: InAppWebView(
              initialData: InAppWebViewInitialData(
                baseUrl: WebUri("https://api.iyzipay.com"),
                data: '''
                  <html>
                    <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
                    <body style="margin:0;padding:0;background:#fff;">
                      <div id="iyzipay-checkout-form" class="responsive"></div>
                      $checkoutFormContent
                    </body>
                  </html>
                ''',
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                allowUniversalAccessFromFileURLs: true,
                javaScriptCanOpenWindowsAutomatically: true,
              ),
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url.toString();
                debugPrint('[IYZICO_WEBVIEW] URL: $url');

                if (url.contains('odeme-basarili') || url.contains('payment-success') || url.startsWith('hemenustam://payment-success')) {
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => OdemeSonucScreen(isSuccess: true, message: "$gonderilenTutar TL", amount: gonderilenTutar)),
                          (route) => route.isFirst,
                    );
                  }
                  return NavigationActionPolicy.CANCEL;
                }

                if (url.contains('odeme-basarisiz') || url.contains('payment-fail') || url.startsWith('hemenustam://payment-fail')) {
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const OdemeSonucScreen(isSuccess: false, message: "Ödeme tamamlanamadı")),
                          (route) => route.isFirst,
                    );
                  }
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _dokumanGoster(String docId, String title) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('config').doc(docId).get();
      if (!doc.exists) return;
      final data = doc.data();
      final String baslik = data?['baslik']?? title;
      final String metin = data?['metin']?? 'İçerik bulunamadı.';
      if (!mounted) return;
      showDialog(context: context, builder: (context) => AlertDialog(backgroundColor: cardBg, title: Text(baslik, style: const TextStyle(color: Colors.white)), content: Text(metin, style: const TextStyle(color: Colors.grey)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Kapat', style: TextStyle(color: primaryRed)))]));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(backgroundColor: cardBg, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)), title: const Text('Bakiye Yükle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Cüzdanınıza güvenli ödeme ile bakiye yükleyin', style: TextStyle(color: Colors.grey, fontSize: 14)), const SizedBox(height: 32),
        _buildSectionTitle('Yüklenecek Tutar'), const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 12, children: hazirTutarlar.map((tutar) { final secili = _secilenTutar == tutar; return GestureDetector(onTap: () => _tutarSec(tutar), child: Container(width: 100, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: secili? primaryRed : cardBg, border: Border.all(color: secili? primaryRed : borderColor, width: 1.5), borderRadius: BorderRadius.circular(12)), child: Column(children: [Text('$tutar', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text('TL', style: TextStyle(color: secili? Colors.white70 : Colors.grey, fontSize: 12))])));}).toList()),
        const SizedBox(height: 16),
        TextField(controller: _manuelTutarController, style: const TextStyle(color: Colors.white, fontSize: 18), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], onChanged: (_) => setState(() => _secilenTutar = null), decoration: InputDecoration(hintText: 'Başka bir tutar gir', hintStyle: const TextStyle(color: Colors.grey), prefixIcon: const Icon(Icons.edit, color: Colors.grey), suffixText: 'TL', suffixStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), filled: true, fillColor: cardBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryRed, width: 1.5)))),
        const SizedBox(height: 32), _buildSectionTitle('Onaylar'), const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: cardBg, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(12)), child: Column(children: [CheckboxListTile(value: _kvkkOnay, onChanged: (v) => setState(() => _kvkkOnay = v?? false), activeColor: primaryRed, checkColor: Colors.white, side: const BorderSide(color: Colors.grey), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, title: GestureDetector(onTap: () => _dokumanGoster('gizlilik_politikasi', 'KVKK'), child: RichText(text: TextSpan(style: const TextStyle(color: Colors.white, fontSize: 13), children: [const TextSpan(text: 'KVKK Aydınlatma Metni'), TextSpan(text: '\'ni okudum, onaylıyorum.', style: TextStyle(color: primaryRed, decoration: TextDecoration.underline))])))), CheckboxListTile(value: _sozlesmeOnay, onChanged: (v) => setState(() => _sozlesmeOnay = v?? false), activeColor: primaryRed, checkColor: Colors.white, side: const BorderSide(color: Colors.grey), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, title: GestureDetector(onTap: () => _dokumanGoster('mesafeli_satis', 'Mesafeli Satış'), child: RichText(text: TextSpan(style: const TextStyle(color: Colors.white, fontSize: 13), children: [const TextSpan(text: 'Mesafeli Satış Sözleşmesi'), TextSpan(text: '\'ni okudum, onaylıyorum.', style: TextStyle(color: primaryRed, decoration: TextDecoration.underline))]))))])),
        const SizedBox(height: 32), _buildSectionTitle('Ödeme Yöntemi'), const SizedBox(height: 12),
        _OdemeButon(aktif: _odemeAktif, onTap: () => _iyzicoOdemeBaslat(iyzicoIleOde: false), icon: Icons.credit_card, title: 'Kredi/Banka Kartı ile Öde', subtitle: 'Visa, Mastercard, Troy', primaryColor: navyBlue, loading: _isProcessing), const SizedBox(height: 16),
        _OdemeButon(aktif: _odemeAktif, onTap: () => _iyzicoOdemeBaslat(iyzicoIleOde: true), icon: Icons.account_balance_wallet, title: 'iyzico ile Öde', subtitle: 'iyzico bakiyesi veya kayıtlı kartınla', primaryColor: primaryRed, loading: _isProcessing),
      ]))),
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600));
}

class _OdemeButon extends StatelessWidget {
  final bool aktif; final VoidCallback onTap; final IconData icon; final String title; final String subtitle; final Color primaryColor; final bool loading;
  const _OdemeButon({required this.aktif, required this.onTap, required this.icon, required this.title, required this.subtitle, required this.primaryColor, this.loading = false});
  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: aktif? 1 : 0.4, child: GestureDetector(onTap: aktif? onTap : null, child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF1A1A1A), border: Border.all(color: aktif? primaryColor : const Color(0xFF2A2A2A), width: 1.5), borderRadius: BorderRadius.circular(16)), child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: primaryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: loading? SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor)) : Icon(icon, color: primaryColor, size: 28)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12))])), if (!loading) const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)]))));
  }
}