// DOSYA: lib/features/home/screens/ai_auth_wall.dart
import 'package:flutter/material.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_register.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_register.dart';

class AiAuthWall extends StatelessWidget {
  const AiAuthWall({super.key});

  @override
  Widget build(BuildContext context) {
    const kirmizi = Color(0xFFD32F2F);
    const bg = Color(0xFFF8F8FA);
    const dark = Color(0xFF121214);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // ARKA PLAN GRADYAN TOPLAR - PREMIUM HİSSİ
          Positioned(top: -80, right: -80, child: Container(width: 250, height: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: kirmizi.withOpacity(0.12)))),
          Positioned(bottom: -100, left: -60, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange.withOpacity(0.08)))),

          SafeArea(
            child: Column(
              children: [
                // APPBAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)]), child: const Icon(Icons.close_rounded, size: 20, color: dark)),
                      ),
                      const Spacer(),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withOpacity(0.06))), child: const Row(children: [Icon(Icons.verified_user_rounded, size: 14, color: Colors.green), SizedBox(width: 4), Text("Güvenli Giriş", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))])),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                    child: Column(
                      children: [
                        // KİLİT İKONU - GLASSMORPHISM
                        Container(
                          width: 96, height: 96,
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 15)), BoxShadow(color: kirmizi.withOpacity(0.15), blurRadius: 20)]),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(width: 72, height: 72, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [kirmizi, kirmizi.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight))),
                              const Icon(Icons.lock_rounded, color: Colors.white, size: 32),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text("Devam Etmek İçin\nGiriş Yapın", textAlign: TextAlign.center, style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: dark, height: 1.1, letterSpacing: -1)),
                        const SizedBox(height: 14),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text("Yapay zeka destekli fiyat analizini görmek ve binlerce doğrulanmış ustaya ulaşmak için hesabınızı seçin.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: dark.withOpacity(0.55), height: 1.6, fontWeight: FontWeight.w500))),
                        const SizedBox(height: 32),

                        // MÜŞTERİ KARTI - PREMIUM WHITE
                        _PremiumCard(
                          borderColor: kirmizi.withOpacity(0.15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: kirmizi.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.person_rounded, color: kirmizi, size: 20)),
                                  const SizedBox(width: 12),
                                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Müşteri Girişi", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: dark)), Text("Hizmet almak istiyorum", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500))]),
                                  const Spacer(),
                                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text("ÖNERİLEN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.green))),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _FeatureRow(icon: Icons.bolt_rounded, text: "Anında AI fiyat analizi"),
                              const SizedBox(height: 8),
                              _FeatureRow(icon: Icons.shield_rounded, text: "Doğrulanmış ustalardan teklif al"),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity, height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: kirmizi, foregroundColor: Colors.white, elevation: 0, shadowColor: kirmizi.withOpacity(0.4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MusteriRegisterPage(role: 'customer'))),
                                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Müşteri Olarak Devam Et", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), SizedBox(width: 8), Icon(Icons.arrow_forward_rounded, size: 18)]),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // USTA KARTI - DARK PREMIUM
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(colors: [Color(0xFF1C1C1E), Color(0xFF2C2C2E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 25, offset: const Offset(0, 12))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.handyman_rounded, color: Colors.white, size: 20)), const SizedBox(width: 12), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Usta Girişi", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white)), Text("İş almak istiyorum", style: TextStyle(fontSize: 12, color: Colors.white54))])]),
                              const SizedBox(height: 16),
                              const _FeatureRowDark(icon: Icons.workspaces_filled, text: "Sana özel yüzlerce ilan"),
                              const SizedBox(height: 8),
                              const _FeatureRowDark(icon: Icons.payments_rounded, text: "Kazancını anında yönet"),
                              const SizedBox(height: 20),
                              SizedBox(width: double.infinity, height: 56, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UstaRegisterPage(role: 'usta'))), child: const Text("Usta Olarak Devam Et", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.lock_outline_rounded, size: 12, color: dark.withOpacity(0.3)), const SizedBox(width: 6), Text("256-bit SSL ile korunuyor • KVKK uyumlu", style: TextStyle(fontSize: 11, color: dark.withOpacity(0.4), fontWeight: FontWeight.w500))]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// YARDIMCI WIDGETLER
class _PremiumCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  const _PremiumCard({required this.child, required this.borderColor});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor, width: 1.2), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 12))]), child: child);
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon; final String text;
  const _FeatureRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon, size: 16, color: const Color(0xFFD32F2F).withOpacity(0.8)), const SizedBox(width: 8), Text(text, style: TextStyle(fontSize: 13.5, color: const Color(0xFF121214).withOpacity(0.7), fontWeight: FontWeight.w500))]);
  }
}

class _FeatureRowDark extends StatelessWidget {
  final IconData icon; final String text;
  const _FeatureRowDark({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon, size: 16, color: Colors.white.withOpacity(0.8)), const SizedBox(width: 8), Text(text, style: TextStyle(fontSize: 13.5, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500))]);
  }
}