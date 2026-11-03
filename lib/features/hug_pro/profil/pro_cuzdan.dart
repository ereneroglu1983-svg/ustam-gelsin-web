import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';

const _black = Color(0xFF0B0B0B);
const _dark = Color(0xFF111111);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

enum PaketTipi { MONTHLY, THREE_MONTH, SIX_MONTH, YEARLY }

class ProCuzdanScreen extends StatefulWidget {
  const ProCuzdanScreen({super.key});
  @override
  State<ProCuzdanScreen> createState() => _ProCuzdanScreenState();
}

class _ProCuzdanScreenState extends State<ProCuzdanScreen> {
  Map<String, dynamic>? _proData;
  bool _loading = true;
  bool _odemeLoading = false;

  final Map<PaketTipi, Map<String, dynamic>> _paketler = {
    PaketTipi.MONTHLY: {'ad': 'AYLIK', 'fiyat': 2990, 'fiyatStr': '2.990 TL', 'aciklama': '1 Ay - 1 Ücretsiz Başvuru', 'renk': _black},
    PaketTipi.THREE_MONTH: {'ad': '3 AYLIK', 'fiyat': 7490, 'fiyatStr': '7.490 TL', 'aciklama': '3 Ay - 3 Ücretsiz Başvuru - %16 Kar', 'renk': _dark},
    PaketTipi.SIX_MONTH: {'ad': '6 AYLIK', 'fiyat': 12990, 'fiyatStr': '12.990 TL', 'aciklama': '6 Ay - 6 Ücretsiz Başvuru - %27 Kar', 'renk': _black},
    PaketTipi.YEARLY: {'ad': 'YILLIK', 'fiyat': 21990, 'fiyatStr': '21.990 TL', 'aciklama': '12 Ay - 12 Ücretsiz Başvuru - %38 Kar - ÖNERİLEN', 'renk': _gold},
  };

  @override
  void initState() {
    super.initState();
    _loadPro();
  }

  Future<void> _loadPro() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('users_pro').doc(uid).get();
    if (doc.exists) setState(() { _proData = doc.data(); _loading = false; });
  }

  Future<void> _iyzicoIleSatinAl(PaketTipi tip) async {
    setState(() => _odemeLoading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final paket = _paketler[tip]!;
      final amount = paket['fiyat'] as int;

      // SENİN GERÇEK FUNCTION ADIN: checkout - europe-west3
      final functions = FirebaseFunctions.instanceFor(region: 'europe-west3');
      final callable = functions.httpsCallable('checkout');

      final res = await callable.call({
        'amount': amount.toDouble(),
        'platform': 'mobile',
        'paketTipi': tip.name, // ekstra bilgi
        'isPro': true,
      });

      final data = res.data as Map<String, dynamic>;
      final paymentPageUrl = data['paymentPageUrl'] as String?;
      final checkoutFormContent = data['checkoutFormContent'] as String?;

      if (paymentPageUrl != null && paymentPageUrl.isNotEmpty) {
        final uri = Uri.parse(paymentPageUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else if (checkoutFormContent != null) {
        // WebView içinde gösterilmesi gerekiyor - şimdilik log
        print('CheckoutFormContent alındı, WebView ile gösterilmeli');
      }

      // Ödeme kaydı - senin sistemin pending_payments + payments kullanıyor
      await FirebaseFirestore.instance.collection('pending_payments').doc(data['token']).set({
        'uid': uid,
        'amount': amount,
        'paketTipi': tip.name,
        'type': 'HUG_PRO_ABONELIK',
        'status': 'initialized',
        'token': data['token'],
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ödeme sayfasına yönlendiriliyor...'), backgroundColor: _gold));
      }

    } on FirebaseFunctionsException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('İyzico Hata: ${e.message}'), backgroundColor: Colors.red));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    } finally {
      setState(() => _odemeLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(backgroundColor: _black, body: Center(child: CircularProgressIndicator(color: _gold)));
    final data = _proData!;
    final bakiye = data['bakiye'] ?? 0;
    final abonelikBitis = data['subscriptionExpiry'] as Timestamp?;
    final isActive = data['isActive'] ?? false;
    final paketAdi = data['subscriptionType'] ?? 'YOK';

    return Scaffold(
      backgroundColor: _offWhite,
      appBar: AppBar(backgroundColor: _black, iconTheme: const IconThemeData(color: Colors.white), title: const Text('CÜZDAN - HUG PRO', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 3))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 1, color: _gold.withOpacity(0.6)),
            Container(
              width: double.infinity,
              color: _black,
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('BAKİYE & ABONELİK', style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 2))]),
                const SizedBox(height: 16),
                Text('$bakiye TL', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(isActive ? 'AKTİF - $paketAdi' : 'PASİF - ABONELİK YOK', style: TextStyle(color: isActive ? _gold : Colors.white30, fontSize: 10, letterSpacing: 1)),
                if (abonelikBitis != null) Text('Bitiş: ${abonelikBitis.toDate().day}.${abonelikBitis.toDate().month}.${abonelikBitis.toDate().year}', style: const TextStyle(color: Colors.white38, fontSize: 9)),
                const SizedBox(height: 16),
                Container(height: 1, color: Colors.white10),
              ]),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('ABONELİK PAKETLERİ - IYZICO', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                const SizedBox(height: 16),
                ...PaketTipi.values.map((tip) {
                  final p = _paketler[tip]!;
                  final isYearly = tip == PaketTipi.YEARLY;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: isYearly ? _offWhite : Colors.white, border: Border.all(color: isYearly ? _gold : Colors.black12, width: isYearly ? 1.2 : 0.8)),
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        child: Row(children: [
                          Container(width: 4, height: 40, color: p['renk']),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(p['ad'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            Text(p['aciklama'], style: const TextStyle(fontSize: 9, color: _gray)),
                            const SizedBox(height: 6),
                            Text(p['fiyatStr'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isYearly ? _black : _gold)),
                          ])),
                          _odemeLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: _gold)) : GestureDetector(onTap: () => _iyzicoIleSatinAl(tip), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), color: isYearly ? _gold : _black, child: Text('SATIN AL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isYearly ? _black : Colors.white, letterSpacing: 1)))),
                        ]),
                      ),
                      if (isYearly) Container(width: double.infinity, color: _gold, padding: const EdgeInsets.symmetric(vertical: 4), child: const Center(child: Text('EN AVANTAJLI - %38 KAR', style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 1, color: _black)))),
                    ]),
                  );
                }),
              ]),
            ),
            const SizedBox(height: 24),
            const Text('© 2026 HUG PROJE - IYZICO GÜVENLİ ÖDEME', style: TextStyle(color: _gray, fontSize: 8, letterSpacing: 1)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}