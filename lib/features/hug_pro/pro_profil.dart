import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'profil/pro_tekliflerim.dart';
import 'profil/pro_gelen_teklifler.dart';
import 'profil/pro_projelerim.dart';
import 'profil/pro_tamamlanan.dart';
import 'profil/pro_cuzdan.dart';

const _black = Color(0xFF0B0B0B);
const _dark = Color(0xFF111111);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

class ProProfilScreen extends StatefulWidget {
  const ProProfilScreen({super.key});
  @override
  State<ProProfilScreen> createState() => _ProProfilScreenState();
}

class _ProProfilScreenState extends State<ProProfilScreen> {
  Map<String, dynamic>? _proData;
  bool _loading = true;

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

  Future<void> _cikisYap() async {
    final router = GoRouter.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _black,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(milliseconds: 900),
        content: Row(
          children: [
            Container(width: 22, height: 22, decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle), child: const Icon(Icons.check, size: 12, color: _black)),
            const SizedBox(width: 10),
            const Expanded(child: Text('BAŞARIYLA ÇIKIŞ YAPILDI', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))),
            Container(width: 24, height: 1, color: _gold),
          ],
        ),
      ),
    );
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) {
      router.go('/home');
      return;
    }
    if (Navigator.canPop(context)) Navigator.pop(context);
    router.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(backgroundColor: _black, body: Center(child: CircularProgressIndicator(color: _gold)));
    final data = _proData!;
    final isim = '${data['ad'] ?? data['sirketUnvan'] ?? ''} ${data['soyad'] ?? ''}'.trim();
    final meslekler = (data['meslekler'] as List?) ?? [];
    final tamamlanan = data['tamamlananProjeSayisi'] ?? 0;
    final isActive = data['isActive'] ?? false;
    final subscriptionType = data['subscriptionType'] as String? ?? 'YOK';
    final subscriptionExpiry = data['subscriptionExpiry'] as Timestamp?;
    final lastPaymentAmount = data['lastPaymentAmount'];
    DateTime? bitisTarihi = subscriptionExpiry?.toDate();
    int? kalanGun;
    if (bitisTarihi != null) {
      kalanGun = bitisTarihi.difference(DateTime.now()).inDays;
      if (kalanGun < 0) kalanGun = 0;
    }
    String paketAdStr = 'ABONELİK YOK';
    if (subscriptionType == 'MONTHLY') paketAdStr = 'AYLIK';
    if (subscriptionType == 'THREE_MONTH') paketAdStr = '3 AYLIK';
    if (subscriptionType == 'SIX_MONTH') paketAdStr = '6 AYLIK';
    if (subscriptionType == 'YEARLY') paketAdStr = 'YILLIK';

    return Scaffold(
      backgroundColor: _offWhite,
      appBar: AppBar(
        backgroundColor: _black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text('PROFİL', style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: _black,
                child: Stack(
                  children: [
                    Positioned.fill(child: CustomPaint(painter: _ArchGridPainter())),
                    Column(
                      children: [
                        const SizedBox(height: 56),
                        const Text('H U G', style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 9, fontWeight: FontWeight.w300)),
                        const SizedBox(height: 14),
                        const _LightSweepLine(width: 88, height: 1),
                        const SizedBox(height: 14),
                        const Text('P R O J E', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 7, fontWeight: FontWeight.w300)),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _gold.withOpacity(0.5), width: 1)),
                          padding: const EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(56),
                            child: data['profilFotoUrl'] != null
                                ? CachedNetworkImage(imageUrl: data['profilFotoUrl'], width: 112, height: 112, fit: BoxFit.cover, errorWidget: (_,__,___) => Container(width: 112, height: 112, color: _dark, child: const Icon(Icons.person, color: Colors.white30, size: 48)))
                                : Container(width: 112, height: 112, color: _dark, child: const Icon(Icons.person, color: Colors.white30, size: 48)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(isim.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        const SizedBox(height: 6),
                        Text(data['email'] ?? '', style: const TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(border: Border.all(color: _gold.withOpacity(0.4))), child: Text('$tamamlanan TAMAMLANAN PROJE', style: const TextStyle(color: _gold, fontSize: 8, letterSpacing: 1.5))),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: isActive ? _black : const Color(0xFF1A1A1A),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(width: 24, height: 1, color: _gold),
                        const SizedBox(width: 8),
                        Text(isActive ? 'ABONELİK AKTİF' : 'ABONELİK PASİF', style: TextStyle(color: isActive ? _gold : Colors.white38, fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: isActive ? Colors.green : Colors.red, shape: BoxShape.circle)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(paketAdStr, style: TextStyle(color: isActive ? Colors.white : Colors.white30, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              const SizedBox(height: 4),
                              if (isActive && bitisTarihi != null)
                                Text('BİTİŞ: ${bitisTarihi.day.toString().padLeft(2, '0')}.${bitisTarihi.month.toString().padLeft(2, '0')}.${bitisTarihi.year} • $kalanGun GÜN KALDI', style: const TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 0.5))
                              else
                                const Text('ABONELİK ALMAK İÇİN CÜZDAN\'A GİT', style: const TextStyle(color: Colors.white30, fontSize: 9, letterSpacing: 0.5)),
                              if (lastPaymentAmount != null && isActive)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text('SON ÖDEME: $lastPaymentAmount TL', style: const TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 0.5)),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: isActive ? _gold : Colors.white10, border: Border.all(color: isActive ? _gold : Colors.white24, width: 0.8)),
                          child: Text(isActive ? 'AKTİF' : 'PASİF', style: TextStyle(color: isActive ? _black : Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ),
                      ],
                    ),
                    if (!isActive) ...[
                      const SizedBox(height: 14),
                      Container(height: 1, color: Colors.white10),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProCuzdanScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.account_balance_wallet_outlined, size: 12, color: _gold),
                            const SizedBox(width: 6),
                            const Text('ABONELİK AL →', style: TextStyle(color: _gold, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(height: 1, color: _gold.withOpacity(0.6)),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('YETKİNLİKLER', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: meslekler.map<Widget>((m) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: _offWhite, border: Border.all(color: Colors.black12)), child: Text('${m['anaDalId']}/${m['altDalId']} - ${m['unvanId']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)))).toList()),
                  if (meslekler.isEmpty) const Text('Yetkinlik yok', style: TextStyle(fontSize: 10, color: _gray)),
                ]),
              ),
              const SizedBox(height: 8),
              _proMenuTile(n: '01', title: 'TEKLİF VERDİĞİM PROJELER', desc: 'Gönderdiğin teklifler', icon: Icons.send_outlined, onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const ProTekliflerimScreen())); }),
              _proMenuTile(n: '02', title: 'GELEN TEKLİFLER', desc: 'Sana gelen proje davetleri', icon: Icons.inbox_outlined, onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const ProGelenTekliflerScreen())); }),
              _proMenuTile(n: '03', title: 'PROJELER', desc: 'TEKLİF VERİLEN - RED EDİLEN - DEVAM EDEN', icon: Icons.folder_open_outlined, onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const ProProjelerimScreen())); }, hasBadge: true),
              _proMenuTile(n: '04', title: 'TAMAMLANAN PROJELER', desc: 'Künyende görünecek - $tamamlanan proje', icon: Icons.verified_outlined, isGold: true, onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const ProTamamlananScreen())); }),
              _proMenuTile(n: '05', title: 'CÜZDAN', desc: 'Abonelik al / Para yükle / Bakiye', icon: Icons.account_balance_wallet_outlined, onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const ProCuzdanScreen())); }),
              const SizedBox(height: 24),
              Container(height: 1, color: Colors.black12, margin: const EdgeInsets.symmetric(horizontal: 16)),
              const SizedBox(height: 8),
              _proMenuTile(n: '06', title: 'ÇIKIŞ YAP', desc: 'Hesaptan çık', icon: Icons.logout, isExit: true, onTap: () => _cikisYap()),
              _proMenuTile(n: '07', title: 'HESABIMI KALICI OLARAK SİL', desc: 'Tüm veriler silinir - geri alınamaz', icon: Icons.delete_forever_outlined, isDanger: true, onTap: () => _showDeleteDialog()),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    final router = GoRouter.of(context);
                    if (Navigator.canPop(context)) Navigator.pop(context);
                    router.go('/home');
                  },
                  child: Container(
                    width: double.infinity,
                    color: _black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 14, height: 1, color: _gold),
                        const SizedBox(width: 8),
                        const Text('ANA SAYFAYA DÖN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('© 2026 HUG PROJE - PROFESSIONAL', style: TextStyle(color: _gray, fontSize: 8, letterSpacing: 1)),
              SizedBox(height: 24 + MediaQuery.of(context).padding.bottom + 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _proMenuTile({required String n, required String title, required String desc, required IconData icon, required VoidCallback onTap, bool isGold = false, bool isExit = false, bool isDanger = false, bool hasBadge = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Row(
          children: [
            SizedBox(width: 28, child: Text(n, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w200, color: isGold ? _gold : _gold.withOpacity(0.8)))),
            Container(width: 36, height: 36, decoration: BoxDecoration(border: Border.all(color: isDanger ? Colors.red.withOpacity(0.3) : isGold ? _gold.withOpacity(0.4) : const Color(0xFFD6D6D6), width: 0.8), shape: BoxShape.circle), child: Icon(icon, size: 16, color: isDanger ? Colors.red : isExit ? _gray : isGold ? _gold : _black)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: -0.2, color: isDanger ? Colors.red : _black)), const SizedBox(height: 3), Text(desc, style: const TextStyle(fontSize: 9, color: _gray, height: 1.3))])),
            if (hasBadge) Container(width: 6, height: 6, decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Container(width: 28, height: 28, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6D6D6), width: 0.8), shape: BoxShape.circle), child: const Icon(Icons.arrow_outward, size: 12, color: _gray)),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _dark,
        title: const Text('Hesabı sil?', style: TextStyle(color: Colors.white, fontSize: 13)),
        content: const Text('Tüm projelerin, tekliflerin ve belgelerin kalıcı olarak silinecek. Bu işlem geri alınamaz.', style: TextStyle(color: Colors.white70, fontSize: 11)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('VAZGEÇ', style: TextStyle(color: _gray))),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              final uid = user?.uid;
              if (uid == null) return;
              try {
                final teklifler1 = await FirebaseFirestore.instance.collection('hug_pro_teklifler').where('profesyonelId', isEqualTo: uid).get();
                final teklifler2 = await FirebaseFirestore.instance.collection('hug_pro_teklifler').where('proId', isEqualTo: uid).get();
                final batch = FirebaseFirestore.instance.batch();
                for (final d in teklifler1.docs) batch.delete(d.reference);
                for (final d in teklifler2.docs) batch.delete(d.reference);
                batch.delete(FirebaseFirestore.instance.collection('users_pro').doc(uid));
                await batch.commit();
                await user?.delete();
                if (mounted) context.go('/home');
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silmek için tekrar giriş yapman gerekli, çıkıp tekrar girip dene.')),
                  );
                }
              }
            },
            child: const Text('KALICI SİL', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
  Widget build(BuildContext context) => SizedBox(width: widget.width, height: 10, child: AnimatedBuilder(animation: _controller, builder: (_, __) => CustomPaint(painter: _LightSweepPainter(progress: _controller.value))));
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