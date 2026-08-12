// DOSYA: lib/features/home/screens/home_page_ai.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/features/home/screens/ai_auth_wall.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_is_secimi_sayfasi.dart';

class HomePageAI extends StatefulWidget {
  const HomePageAI({super.key});
  @override
  State<HomePageAI> createState() => _HomePageAIState();
}

class _HomePageAIState extends State<HomePageAI> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnim;
  final Color _bg = const Color(0xFFF9F9FB);
  final Color _dark = const Color(0xFF111113);
  final Color _red = const Color(0xFFD32F2F);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -10, end: 10).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  Future<void> _hemenBaslayalimTiklandi() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) { if (!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (_) => AiAuthWall())); return; }
    showDialog(context: context, barrierDismissible: false, builder: (_) => Center(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: CircularProgressIndicator(color: _red))));
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!mounted) return; Navigator.pop(context);
      if (!doc.exists) { Navigator.push(context, MaterialPageRoute(builder: (_) => AiAuthWall())); return; }
      final role = (doc.data() as Map<String, dynamic>)['role']?.toString().toLowerCase().trim() ?? '';
      if (role == 'customer') { Navigator.push(context, MaterialPageRoute(builder: (_) => MusteriIsSecimiSayfasi())); }
      else if (role == 'usta') {
        showDialog(context: context, builder: (ctx) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.12), shape: BoxShape.circle), child: const Icon(Icons.info_rounded, color: Color(0xFFF57C00), size: 32)), const SizedBox(height: 16), const Text("Bilgilendirme", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 10), Text("Bu hizmet sadece müşterilerimiz için sunulmaktadır.\n\nUstalarımız ilanlara teklif verme ekranından devam edebilir.", textAlign: TextAlign.center, style: TextStyle(height: 1.6, fontSize: 14, color: _dark.withOpacity(0.65))), const SizedBox(height: 20), SizedBox(width: double.infinity, height: 48, child: FilledButton(style: FilledButton.styleFrom(backgroundColor: _red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () => Navigator.pop(ctx), child: const Text("Anladım", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))))]))));
      }
    } catch (e) { if (!mounted) return; Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e"))); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Positioned(top: -120, left: -60, child: Container(width: 320, height: 320, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [_red.withOpacity(0.18), Colors.transparent])))),
          Positioned(bottom: 100, right: -80, child: Container(width: 280, height: 280, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.deepPurple.withOpacity(0.12), Colors.transparent])))),
          SafeArea(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: _dark, borderRadius: BorderRadius.circular(20)), child: const Row(children: [Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14), SizedBox(width: 6), Text("YAPAY ZEKA", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5))])), const Spacer(), Container(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)]), child: IconButton(icon: Icon(Icons.close_rounded, size: 18, color: _dark.withOpacity(0.7)), onPressed: () => Navigator.pop(context)))])),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        RichText(textAlign: TextAlign.center, text: TextSpan(style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: _dark, height: 1.1, letterSpacing: -1), children: [const TextSpan(text: "Ustam Gelsin\n"), WidgetSpan(child: ShaderMask(shaderCallback: (b) => LinearGradient(colors: [_red, Color(0xFFFF6B6B)]).createShader(b), child: const Text("AI ile tanışın.", style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white))))])),
                        const SizedBox(height: 16),
                        Text("Tadilat ve ustalık gerektiren işleriniz için en hızlı, en güvenilir ve yapay zeka destekli deneyime hazır mısınız?", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: _dark.withOpacity(0.58), height: 1.6, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 30),
                        // BÜYÜK RESİM - OKUNUR
                        AnimatedBuilder(
                          animation: _floatAnim,
                          builder: (context, child) => Transform.translate(offset: Offset(0, _floatAnim.value), child: child),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(width: 360, height: 360, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [_red.withOpacity(0.13), Colors.transparent]))),
                              Container(
                                width: double.infinity,
                                height: 360,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 40, offset: const Offset(0, 20))], border: Border.all(color: Colors.white)),
                                child: ClipRRect(borderRadius: BorderRadius.circular(28), child: Image.asset('assets/images/ai_page.png', fit: BoxFit.contain)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withOpacity(0.04))),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_MiniFeature(icon: Icons.category_rounded, label: "İşi\nSeç"), _Dot(), _MiniFeature(icon: Icons.edit_note_rounded, label: "İlanı\nOluştur"), _Dot(), _MiniFeature(icon: Icons.handshake_rounded, label: "Teklif\nAl")]),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.92), border: Border(top: BorderSide(color: Colors.black.withOpacity(0.06))), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, -10))]),
              child: Column(
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, height: 60,
                    child: DecoratedBox(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(colors: [_red, Color(0xFFE53935)]), boxShadow: [BoxShadow(color: _red.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 10))]),
                      child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: _hemenBaslayalimTiklandi, child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("HEMEN BAŞLAYALIM", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)), SizedBox(width: 8), Icon(Icons.arrow_forward_rounded, color: Colors.white)])),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Ücretsiz • Kredi kartı gerektirmez", style: TextStyle(fontSize: 11.5, color: _dark.withOpacity(0.4), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniFeature extends StatelessWidget {
  final IconData icon; final String label;
  const _MiniFeature({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) { return Column(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF5F5F7), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 18, color: const Color(0xFF111113))), const SizedBox(height: 8), Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6), height: 1.3))]); }
}
class _Dot extends StatelessWidget { @override Widget build(BuildContext context) { return Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), shape: BoxShape.circle)); } }