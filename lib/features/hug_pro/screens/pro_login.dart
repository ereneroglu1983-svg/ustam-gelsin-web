import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/features/hug_pro/hug_ontoloji.dart';

const _black = Color(0xFF0B0B0B);
const _dark = Color(0xFF111111);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

class ProLoginScreen extends StatefulWidget {
  const ProLoginScreen({super.key});
  @override
  State<ProLoginScreen> createState() => _ProLoginScreenState();
}

class _ProLoginScreenState extends State<ProLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      final uid = cred.user!.uid;
      final doc = await FirebaseFirestore.instance.collection('users_pro').doc(uid).get();
      if (!doc.exists) {
        throw Exception('Bu hesap HUG Professional değil');
      }
      final data = doc.data()!;
      if (data['durum'] != 'ONAYLANDI' || data['isActive'] == false) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: _dark,
            title: const Text('Onay Bekleniyor', style: TextStyle(color: Colors.white)),
            content: const Text('Bilgileriniz inceleniyor. Kısa süre içinde onaylanacak ve size bildirim göndereceğiz.', style: TextStyle(color: Colors.white70)),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam', style: TextStyle(color: _gold)))],
          ),
        );
        await FirebaseAuth.instance.signOut();
        return;
      }
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/pro-dashboard');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Giriş başarısız')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO - AYNI TEMA: HUG + IŞIK + PROJE + BÜYÜK PROJELER YAZISI
            Container(
              width: double.infinity,
              color: _black,
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: _ArchGridPainter())),
                  const _HeroHeader(),
                ],
              ),
            ),
            // FORM ALANI - OFFWHITE
            Container(
              width: double.infinity,
              color: _offWhite,
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 48),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), const Text('PROFESYONEL GİRİŞ', style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailCtrl,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(labelText: 'E-MAIL', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold))),
                      validator: (v) => !v!.contains('@') ? 'Geçersiz email' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'ŞİFRE',
                        labelStyle: const TextStyle(fontSize: 9, letterSpacing: 2, color: _gray),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _gold)),
                        suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, size: 18), onPressed: () => setState(() => _obscure = !_obscure)),
                      ),
                      validator: (v) => v!.length < 8 ? 'En az 8 karakter' : null,
                    ),
                    const SizedBox(height: 36),
                    _loading ? const Center(child: CircularProgressIndicator(color: _gold)) : _CtaWithLight(label: 'GİRİŞ YAP', big: true, intensity: 0.85, onTap: _login),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Hesabın yok mu? ', style: TextStyle(fontSize: 11, color: _gray)),
                      GestureDetector(onTap: () => Navigator.pushNamed(context, '/pro-register'), child: const Text('KAYIT OL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1, color: _black))),
                    ]),
                    const SizedBox(height: 40),
                    Container(height: 1, color: Colors.black12),
                    const SizedBox(height: 12),
                    const Text('© 2026 HUG PROJE - PROFESSIONAL', style: TextStyle(color: _gray, fontSize: 8, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// AYNI HERO HEADER - REGISTER'DA DA KULLANILACAK
class _HeroHeader extends StatefulWidget {
  const _HeroHeader();
  @override
  State<_HeroHeader> createState() => _HeroHeaderState();
}
class _HeroHeaderState extends State<_HeroHeader> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _hugFade, _lineFade, _projeFade, _titleFade;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _hugFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.25, curve: Curves.easeOut));
    _lineFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.15, 0.40, curve: Curves.easeOut));
    _projeFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.40, 0.60, curve: Curves.easeOut));
    _titleFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.55, 0.85, curve: Curves.easeOut));
    _ctrl.forward();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        FadeTransition(opacity: _hugFade, child: const Text('H U G', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300, letterSpacing: 9))),
        const SizedBox(height: 20),
        FadeTransition(opacity: _lineFade, child: const _LightSweepLine(width: 88, height: 1)),
        const SizedBox(height: 20),
        FadeTransition(opacity: _projeFade, child: const Text('P R O J E', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w300, letterSpacing: 7))),
        const SizedBox(height: 24),
        FadeTransition(opacity: _titleFade, child: const Text('BÜYÜK PROJELER - YAPI - TEKNİK', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 3.5))),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _LightSweepLine extends StatefulWidget {
  final double width; final double height;
  const _LightSweepLine({this.width = 88, this.height = 1});
  @override
  State<_LightSweepLine> createState() => _LightSweepLineState();
}
class _LightSweepLineState extends State<_LightSweepLine> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(period: const Duration(milliseconds: 4200)); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: widget.width, height: 10, child: AnimatedBuilder(animation: _controller, builder: (_, __) => CustomPaint(painter: _LightSweepPainter(progress: _controller.value))));
  }
}
class _LightSweepPainter extends CustomPainter {
  final double progress; _LightSweepPainter({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final basePaint = Paint()..color = _gold.withOpacity(0.7)..strokeWidth = 1;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), basePaint);
    final lightX = progress * (size.width + 30) - 15;
    final gradient = LinearGradient(colors: [Colors.transparent, _gold.withOpacity(0.08), _gold.withOpacity(0.6), Colors.white.withOpacity(0.75), _gold.withOpacity(0.6), _gold.withOpacity(0.08), Colors.transparent]);
    final rect = Rect.fromCenter(center: Offset(lightX, y), width: 30, height: 1.5);
    final lightPaint = Paint()..shader = gradient.createShader(rect)..strokeWidth = 1.5;
    canvas.drawLine(Offset(lightX - 15, y), Offset(lightX + 15, y), lightPaint);
  }
  @override
  bool shouldRepaint(covariant _LightSweepPainter old) => old.progress != progress;
}
class _ArchGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.03)..strokeWidth = 0.5;
    canvas.drawLine(Offset(size.width * 0.15, 0), Offset(size.width * 0.15, size.height), p);
    canvas.drawLine(Offset(size.width * 0.85, 0), Offset(size.width * 0.85, size.height), p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
class _CtaWithLight extends StatefulWidget {
  final String label; final bool big; final double intensity; final VoidCallback? onTap;
  const _CtaWithLight({required this.label, this.big = false, this.intensity = 0.70, this.onTap});
  @override
  State<_CtaWithLight> createState() => _CtaWithLightState();
}
class _CtaWithLightState extends State<_CtaWithLight> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(period: const Duration(milliseconds: 3500)); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final whiteOpacity = 0.15 + (widget.intensity * 0.10);
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Stack(children: [
          Container(padding: EdgeInsets.symmetric(horizontal: widget.big ? 28 : 20, vertical: widget.big ? 16 : 12), color: _gold, child: Row(mainAxisSize: MainAxisSize.min, children: [Text(widget.label, style: TextStyle(color: _black, fontSize: widget.big ? 11 : 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(width: 12), Container(width: widget.big ? 28 : 20, height: 1, color: Colors.black54)])),
          Positioned.fill(child: ClipRect(child: Transform.translate(offset: Offset((_controller.value * 200) - 50, 0), child: Container(width: 36, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.white.withOpacity(whiteOpacity), Colors.transparent])))))),
        ]),
      ),
    );
  }
}