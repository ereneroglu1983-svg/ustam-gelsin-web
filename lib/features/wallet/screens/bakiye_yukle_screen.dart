import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  final List<int> hazirTutarlar = [50, 100, 250, 500, 1000];

  @override
  void dispose() {
    _manuelTutarController.dispose();
    super.dispose();
  }

  int get _yuklenecekTutar {
    if (_secilenTutar != null) return _secilenTutar!;
    return int.tryParse(_manuelTutarController.text) ?? 0;
  }

  bool get _odemeAktif {
    return _yuklenecekTutar >= 10 && _kvkkOnay && _sozlesmeOnay;
  }

  void _tutarSec(int? tutar) {
    setState(() {
      _secilenTutar = tutar;
      if (tutar != null) _manuelTutarController.clear();
    });
  }

  Future<void> _iyzicoOdemeBaslat({required bool iyzicoIleOde}) async {
    if (!_odemeAktif) return;

    HapticFeedback.mediumImpact();

    try {
      final functions = FirebaseFunctions.instanceFor(region: 'europe-west3');
      final callable = functions.httpsCallable('bakiyeYukleCheckout');

      final result = await callable.call({
        'amount': _yuklenecekTutar,
        'channel': iyzicoIleOde ? 'iyzico_wallet' : 'card',
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });

      final checkoutUrl = result.data['checkoutFormContent'];

      if (!mounted) return;

      final bool? odemeBasarili = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IyzicoWebViewScreen(url: checkoutUrl),
        ),
      );

      if (!mounted) return;
      if (odemeBasarili == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bakiye yükleme başarılı'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (odemeBasarili == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ödeme iptal edildi veya başarısız'),
            backgroundColor: Colors.red,
          ),
        );
      }

    } on FirebaseFunctionsException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.message}'), backgroundColor: Colors.red),
      );
    }
  }

  void _sozlesmeGoster() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        title: const Text('Mesafeli Satış Sözleşmesi', style: TextStyle(color: Colors.white)),
        content: const SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              'Bu sözleşme... \n\n1. Hizmet...\n2. İade...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat', style: TextStyle(color: primaryRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Bakiye Yükle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cüzdanınıza güvenli ödeme ile bakiye yükleyin',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle('Yüklenecek Tutar'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: hazirTutarlar.map((tutar) {
                  final secili = _secilenTutar == tutar;
                  return GestureDetector(
                    onTap: () => _tutarSec(tutar),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: secili ? primaryRed : cardBg,
                        border: Border.all(color: secili ? primaryRed : borderColor, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$tutar',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('TL', style: TextStyle(color: secili ? Colors.white70 : Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _manuelTutarController,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() => _secilenTutar = null),
                decoration: InputDecoration(
                  hintText: 'Başka bir tutar gir',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.edit, color: Colors.grey),
                  suffixText: 'TL',
                  suffixStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: cardBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryRed, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle('Onaylar'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: _kvkkOnay,
                      onChanged: (v) => setState(() => _kvkkOnay = v ?? false),
                      activeColor: primaryRed,
                      checkColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'KVKK Aydınlatma Metni\'ni okudum, onaylıyorum.',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    CheckboxListTile(
                      value: _sozlesmeOnay,
                      onChanged: (v) => setState(() => _sozlesmeOnay = v ?? false),
                      activeColor: primaryRed,
                      checkColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: GestureDetector(
                        onTap: _sozlesmeGoster,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            children: [
                              const TextSpan(text: 'Mesafeli Satış Sözleşmesi'),
                              TextSpan(
                                text: ' \'ni okudum, onaylıyorum.',
                                style: TextStyle(color: primaryRed, decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle('Ödeme Yöntemi'),
              const SizedBox(height: 12),

              _OdemeButon(
                aktif: _odemeAktif,
                onTap: () => _iyzicoOdemeBaslat(iyzicoIleOde: false),
                icon: Icons.credit_card,
                title: 'Kredi/Banka Kartı ile Öde',
                subtitle: 'Visa, Mastercard, Troy',
                primaryColor: navyBlue,
              ),
              const SizedBox(height: 16),

              _OdemeButon(
                aktif: _odemeAktif,
                onTap: () => _iyzicoOdemeBaslat(iyzicoIleOde: true),
                icon: Icons.account_balance_wallet,
                title: 'iyzico ile Öde',
                subtitle: 'iyzico bakiyesi veya kayıtlı kartınla',
                primaryColor: primaryRed,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline, color: Colors.grey, size: 16),
                  SizedBox(width: 6),
                  Text(
                    '256-bit SSL ile güvenli ödeme',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

class _OdemeButon extends StatelessWidget {
  final bool aktif;
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;

  const _OdemeButon({
    required this.aktif,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: aktif ? 1 : 0.4,
      child: GestureDetector(
        onTap: aktif ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            border: Border.all(color: aktif ? primaryColor : const Color(0xFF2A2A2A), width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class IyzicoWebViewScreen extends StatefulWidget {
  final String url;
  const IyzicoWebViewScreen({super.key, required this.url});

  @override
  State<IyzicoWebViewScreen> createState() => _IyzicoWebViewScreenState();
}

class _IyzicoWebViewScreenState extends State<IyzicoWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains('odeme-basarili') || request.url.contains('success')) {
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            }
            if (request.url.contains('odeme-basarisiz') || request.url.contains('fail') || request.url.contains('cancel')) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Güvenli Ödeme', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}