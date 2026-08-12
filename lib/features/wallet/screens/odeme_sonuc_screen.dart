import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_profil_sayfasi.dart';

class OdemeSonucScreen extends StatefulWidget {
  final bool isSuccess;
  final String message;
  final int? amount;
  const OdemeSonucScreen({super.key, required this.isSuccess, this.message = '', this.amount});

  @override
  State<OdemeSonucScreen> createState() => _OdemeSonucScreenState();
}

class _OdemeSonucScreenState extends State<OdemeSonucScreen> with SingleTickerProviderStateMixin {
  int _countdown = 4;
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  final Color primaryRed = const Color(0xFFDC143C);
  final Color darkBg = const Color(0xFF0F0F0F);
  final Color cardBg = const Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const UstaProfilSayfasi()),
                (route) => false,
          );
        }
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        children: [
          // Arka plan gradient ışıklar
          Positioned(top: -100, left: -100, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: (widget.isSuccess ? Colors.green : Colors.red).withOpacity(0.15), boxShadow: [BoxShadow(color: (widget.isSuccess ? Colors.green : Colors.red).withOpacity(0.15), blurRadius: 80, spreadRadius: 30)]))),
          Positioned(bottom: -100, right: -100, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: primaryRed.withOpacity(0.1), boxShadow: [BoxShadow(color: primaryRed.withOpacity(0.1), blurRadius: 80, spreadRadius: 30)]))),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Dış pulsing halkalar
                          Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, color: (widget.isSuccess ? Colors.green : Colors.red).withOpacity(0.08))),
                          Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, color: (widget.isSuccess ? Colors.green : Colors.red).withOpacity(0.12))),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: widget.isSuccess ? [Colors.green.shade400, Colors.green.shade700] : [Colors.red.shade400, Colors.red.shade700]),
                              boxShadow: [BoxShadow(color: (widget.isSuccess ? Colors.green : Colors.red).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                            ),
                            child: Icon(widget.isSuccess ? Icons.check_rounded : Icons.close_rounded, size: 56, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(widget.isSuccess ? "ÖDEME BAŞARILI" : "ÖDEME BAŞARISIZ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
                  const SizedBox(height: 12),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: (widget.isSuccess ? Colors.green : Colors.red).withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: (widget.isSuccess ? Colors.green : Colors.red).withOpacity(0.3))), child: Text(widget.isSuccess ? "• Güvenli ödeme ile tamamlandı" : "• İşlem tamamlanamadı", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.isSuccess ? Colors.green.shade300 : Colors.red.shade300))),
                  const SizedBox(height: 32),

                  // Tutar Kartı - Premium
                  if (widget.isSuccess)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.06))),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Yüklenen Tutar", style: TextStyle(color: Colors.grey.shade400, fontSize: 13)), Text("Durum", style: TextStyle(color: Colors.grey.shade400, fontSize: 13))]),
                          const SizedBox(height: 12),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(widget.message.isNotEmpty ? widget.message : "Bakiyenize eklendi", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text("BAŞARILI", style: TextStyle(color: Colors.green.shade300, fontSize: 10, fontWeight: FontWeight.bold))),
                          ]),
                          const SizedBox(height: 16),
                          Divider(color: Colors.white.withOpacity(0.06)),
                          const SizedBox(height: 12),
                          Row(children: [Icon(Icons.account_balance_wallet, color: Colors.grey.shade500, size: 16), const SizedBox(width: 8), Text("Bakiyeniz anlık olarak güncellendi", style: TextStyle(color: Colors.grey.shade500, fontSize: 12))]),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.red.withOpacity(0.15))),
                      child: Text(widget.message.isNotEmpty ? widget.message : "Bir sorun oluştu, lütfen tekrar deneyin.", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ),

                  const Spacer(),

                  // Alt kısım - Geri sayım ve buton
                  Column(
                    children: [
                      Text("$_countdown saniye sonra profile dönülüyor", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      const SizedBox(height: 12),
                      ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(height: 4, child: TweenAnimationBuilder<double>(tween: Tween(begin: 0, end: 1), duration: Duration(seconds: _countdown), builder: (context, value, _) => LinearProgressIndicator(value: value, backgroundColor: Colors.white.withOpacity(0.06), color: widget.isSuccess ? Colors.green : primaryRed)))),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            _timer?.cancel();
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const UstaProfilSayfasi()), (route) => false);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                          child: const Text("Profile Dön", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text("Hemen Ustam Gelsin • Güvenli Ödeme - Iyzico", style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}