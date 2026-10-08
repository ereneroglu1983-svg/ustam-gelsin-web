import 'package:flutter/material.dart';

// KİLİTLİ: HugProHomePage
// RÖTUŞ SÜRÜMÜ 9.5+ - TAM VE EKSİKSİZ - HİÇBİR YER KISALMADI
// 1. Kayan ışık 28-32px (zarif) - 42 değil
// 2. CTA ışığı 0.35 -> 0.18-0.22 (premium hissi)
// 3. Hero CTA aralığı 64 -> 48
// 4. HUG 16-18 / PROJE 11-12, letterSpacing azaltıldı
// 5. Intent ok arrow_outward, border 0.8 D6D6D6
// 6. Aktif proje kartına küçük ↗ geri geldi
// 7. Proje aşamaları dikey timeline
// 8. Verified çift doğrulama sadeleşti
// 9. Footer 2026
// 10. Signature Motion - Hero açılış animasyonu
// 11. v5.2: YAPI PROFESYONELLERİ → gerçek 12 ANA DAL

const _black = Color(0xFF0B0B0B);
const _dark = Color(0xFF111111);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

class HugProHomePage extends StatelessWidget {
  const HugProHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _offWhite,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 24),
          child: Column(
            children: [
              _hero(),
              _intent(),
              _profVeTurler(),
              _aktifProjeler(),
              _asamalar(),
              _verified(),
              _ecosystemClean(),
              _ctaFinal(),
            ],
          ),
        ),
      ),
    );
  }

  // HERO - SIGNATURE MOTION İLE
  Widget _hero() {
    return Container(
      width: double.infinity,
      color: _black,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _ArchGridPainter(),
            ),
          ),
          _HeroWithEntrance(),
        ],
      ),
    );
  }

  Widget _intent() {
    return Container(
      color: _offWhite,
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), const Text('NE YAPMAK İSTİYORSUNUZ?', style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
          const SizedBox(height: 8),
          const _IntentStatic(n: '01', title: 'PROJE OLUŞTURMAK İSTİYORUM', desc: "Projemi anlatayım, doğru profesyoneller teklifi getirsin. A'dan Z'ye planlama."),
          const _IntentStatic(n: '02', title: 'PROFESYONEL ARIYORUM', desc: 'Mimar, mühendis, müteahhit — doğrulanmış, portfolyolu, referanslı.'),
          const _IntentStatic(n: '03', title: 'TEKLİF ALMAK İSTİYORUM', desc: 'Mevcut projem için teknik ve maliyet teklifi toplayayım, karşılaştırayım.'),
          const _IntentStatic(n: '04', title: 'PROJE / İŞ ORTAĞI ARIYORUM', desc: 'Arsa geliştirme, yatırım, ortak proje — ciddi ölçek, ciddi partner.'),
        ],
      ),
    );
  }

  Widget _profVeTurler() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 600;
          if (narrow) {
            return Column(children: [_profList(), const SizedBox(height: 28), _turList()]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: _profList()), const SizedBox(width: 16), Expanded(child: _turList())]);
        },
      ),
    );
  }

  Widget _profList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [const Text('YAPI PROFESYONELLERİ', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray)), const SizedBox(width: 6), Expanded(child: Container(height: 1, color: Colors.black12))]),
        const SizedBox(height: 16),
        _profRow('01', 'MİMARLIK & TASARIM'),
        _profRow('02', 'MÜHENDİSLİK'),
        _profRow('03', 'MÜTEAHHİTLİK & YAPIM'),
        _profRow('04', 'PROJE & ŞANTİYE YÖNETİMİ'),
        _profRow('05', 'YAPI DENETİM & KONTROL'),
        _profRow('06', 'HARİTA & ARAZİ'),
        _profRow('07', 'YAPI SİSTEMLERİ & TESİSAT'),
        _profRow('08', 'CEPHE, ÇATI & YALITIM'),
        _profRow('09', 'ÇELİK, METAL & PREFABRİK'),
        _profRow('10', 'İÇ MEKAN & YAPI İMALATLARI'),
        _profRow('11', 'ALTYAPI & PEYZAJ'),
        _profRow('12', 'ÖZEL PROJELER'),
      ],
    );
  }

  Widget _turList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [const Text('PROJE TÜRLERİ', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray)), const SizedBox(width: 6), Expanded(child: Container(height: 1, color: Colors.black12))]),
        const SizedBox(height: 16),
        _turRow('01', 'VİLLA'),
        _turRow('02', 'BUNGALOV / TESİS'),
        _turRow('03', 'FABRİKA'),
        _turRow('04', 'TİCARİ YAPI'),
        _turRow('05', 'GES'),
        _turRow('06', 'ÇELİK / PREFABRİK'),
        _turRow('07', 'ARSA GELİŞTİRME'),
        _turRow('08', 'GÜÇLENDİRME'),
      ],
    );
  }

  Widget _profRow(String n, String t) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0F000000)))),
      child: Row(
        children: [
          Text(n, style: const TextStyle(fontSize: 9, color: _gold)),
          const SizedBox(width: 10),
          Expanded(child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
          Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), shape: BoxShape.circle)),
        ],
      ),
    );
  }

  Widget _turRow(String n, String t) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0D000000)))),
      child: Row(
        children: [
          Text(n, style: TextStyle(fontSize: 9, color: _gold.withOpacity(0.7))),
          const SizedBox(width: 6),
          Container(width: 16, height: 1, color: Colors.black12),
          const SizedBox(width: 6),
          Expanded(child: Text(t, style: const TextStyle(fontSize: 11, letterSpacing: 1))),
        ],
      ),
    );
  }

  Widget _aktifProjeler() {
    return Container(
      color: const Color(0xFFFCFBF9),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('AKTİF PROJELER', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('12 AKTİF PROJE', style: TextStyle(fontSize: 8, letterSpacing: 1.2, color: _gray)),
                  const SizedBox(height: 3),
                  Container(width: 48, height: 1, color: Colors.black12),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _ActiveProject(no: '01', status: 'PROFESYONEL ARANIYOR', title: '500 M² VİLLA PROJESİ İÇİN MİMAR VE MÜTEAHHİT ARANIYOR', loc: 'MANİSA / SALİHLİ', type: 'Villa', scale: '500 m²', stage: 'Tasarım'),
          const _ActiveProject(no: '02', status: 'TEKLİF AŞAMASINDA', title: '1200 M² FABRİKA + İDARİ BİNA ÇELİK KONSTRÜKSİYON PROJESİ', loc: 'İZMİR / TORBALI', type: 'Fabrika', scale: '1200 m²', stage: 'Teknik Proje'),
          const _ActiveProject(no: '03', status: 'PROFESYONEL ARANIYOR', title: 'BUNGALOV TESİSİ — 12 ÜNİTE PEYZAJ VE MİMARİ PROJE', loc: 'MUĞLA / FETHİYE', type: 'Turizm', scale: '2800 m² Arazi', stage: 'Fikir'),
          const _ActiveProject(no: '04', status: 'RUHSAT BEKLİYOR', title: 'GES PROJESİ — ÇATI ÜSTÜ 240 KWP TEKNİK UYGULAMA', loc: 'KONYA / KARATAY', type: 'GES', scale: '240 kWp', stage: 'Ruhsat'),
        ],
      ),
    );
  }

  // DİKEY TIMELINE - PREMIUM
  Widget _asamalar() {
    return Container(
      color: _dark,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 10), const Text('PROJE AŞAMALARI', style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 2))]),
          const SizedBox(height: 28),
          const _VerticalTimeline(),
        ],
      ),
    );
  }

  Widget _verified() {
    return Container(
      color: _offWhite,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DOĞRULANMIŞ PROFESYONELLER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 0.95)),
          const SizedBox(height: 20),
          const _VerifiedCard(name: 'MİMAR AHMET Y.', loc: 'İZMİR', proj: '12 TAMAMLANAN PROJE', type: 'MİMARLIK'),
          const _VerifiedCard(name: 'MÜH. ELİF K.', loc: 'ANKARA', proj: '28 TAMAMLANAN PROJE', type: 'STATİK'),
          const _VerifiedCard(name: 'MÜTEAHHİT CEM S.', loc: 'MANİSA', proj: '19 TAMAMLANAN PROJE', type: 'YAPI'),
        ],
      ),
    );
  }

  Widget _ecosystemClean() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HUG İLE SÜREÇ', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _ecoStep('PROJE', 'Planla.', 'Planlama ve profesyonel hizmetler')),
              Container(width: 1, height: 40, color: Colors.black12, margin: const EdgeInsets.symmetric(horizontal: 12)),
              Expanded(child: _ecoStep('USTA', 'Uygula.', 'Uygulama ve işçilik')),
              Container(width: 1, height: 40, color: Colors.black12, margin: const EdgeInsets.symmetric(horizontal: 12)),
              Expanded(child: _ecoStep('MARKET', 'Tedarik et.', 'Malzeme ve ekipman')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ecoStep(String title, String verb, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(verb, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(desc, style: const TextStyle(fontSize: 9, color: _gray, height: 1.3)),
      ],
    );
  }

  Widget _ctaFinal() {
    return Container(
      width: double.infinity,
      color: _black,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), const Text('SON ADIM', style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 2))]),
          const SizedBox(height: 20),
          const Text('Projenizi hayata\ngeçirmeye hazır\nmısınız?', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 0.95)),
          const SizedBox(height: 12),
          const Text("Her proje doğrulanmış profesyonellerle eşleşir.", style: TextStyle(color: Colors.white30, fontSize: 10, letterSpacing: 0.8, height: 1.5)),
          const SizedBox(height: 28),
          _CtaWithLight(label: 'PROJEMİ OLUŞTUR', big: true, intensity: 0.85),
          const SizedBox(height: 10),
          const Text('2 dakikada — ücretsiz ön değerlendirme', style: TextStyle(color: Colors.white30, fontSize: 8, letterSpacing: 1)),
          const SizedBox(height: 40),
          Container(height: 1, color: Colors.white10),
          const SizedBox(height: 12),
          const Text('© 2026 HUG PROJE', style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 1)),
        ],
      ),
    );
  }
}

// HERO SIGNATURE MOTION - 0.00s HUG, 0.20s çizgi, 0.40s ışık, 0.55s PROJE, 0.70s başlık, 0.90s CTA
class _HeroWithEntrance extends StatefulWidget {
  @override
  State<_HeroWithEntrance> createState() => _HeroWithEntranceState();
}

class _HeroWithEntranceState extends State<_HeroWithEntrance> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _hugFade;
  late final Animation<double> _lineFade;
  late final Animation<double> _projeFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _ctaFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _hugFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.25, curve: Curves.easeOut));
    _lineFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.15, 0.40, curve: Curves.easeOut));
    _projeFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.40, 0.60, curve: Curves.easeOut));
    _titleFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.55, 0.85, curve: Curves.easeOut));
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic)));
    _ctaFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.75, 1.0, curve: Curves.easeOut));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 64),
        Column(
          children: [
            FadeTransition(
              opacity: _hugFade,
              child: const Text('H U G', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300, letterSpacing: 9)),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _lineFade,
              child: const _LightSweepLine(width: 88, height: 1),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _projeFade,
              child: const Text('P R O J E', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w300, letterSpacing: 7)),
            ),
          ],
        ),
        const SizedBox(height: 48),
        FadeTransition(opacity: _titleFade, child: const Text('BÜYÜK PROJELER • YAPI • TEKNİK', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 3.5))),
        const SizedBox(height: 40),
        SlideTransition(
          position: _titleSlide,
          child: FadeTransition(
            opacity: _titleFade,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Projenizi planlayın,\ndoğru profesyonellerle\nbuluşturun.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, height: 1.1, letterSpacing: -0.5)),
            ),
          ),
        ),
        const SizedBox(height: 48),
        FadeTransition(
          opacity: _ctaFade,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _CtaWithLight(label: 'PROJE OLUŞTUR', intensity: 0.70),
              _CtaWithLight(label: 'PROFESYONEL BUL', intensity: 0.70),
            ],
          ),
        ),
        const SizedBox(height: 80),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Align(alignment: Alignment.centerRight, child: Text('01', style: TextStyle(color: Colors.white.withOpacity(0.06), fontSize: 56, fontWeight: FontWeight.w200))),
        ),
      ],
    );
  }
}

// KAYAN IŞIK - 28-32px ZARİF, 42 DEĞİL
class _LightSweepLine extends StatefulWidget {
  final double width;
  final double height;
  const _LightSweepLine({this.width = 88, this.height = 1});
  @override
  State<_LightSweepLine> createState() => _LightSweepLineState();
}

class _LightSweepLineState extends State<_LightSweepLine> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(period: const Duration(milliseconds: 4200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 10,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(painter: _LightSweepPainter(progress: _controller.value)),
      ),
    );
  }
}

class _LightSweepPainter extends CustomPainter {
  final double progress;
  _LightSweepPainter({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final basePaint = Paint()..color = _gold.withOpacity(0.7)..strokeWidth = 1;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), basePaint);
    final lightX = progress * (size.width + 30) - 15;
    // 30px zarif ışık - 42 değil
    final gradient = LinearGradient(colors: [Colors.transparent, _gold.withOpacity(0.08), _gold.withOpacity(0.6), Colors.white.withOpacity(0.75), _gold.withOpacity(0.6), _gold.withOpacity(0.08), Colors.transparent]);
    final rect = Rect.fromCenter(center: Offset(lightX, y), width: 30, height: 1.5);
    final lightPaint = Paint()..shader = gradient.createShader(rect)..strokeWidth = 1.5;
    canvas.drawLine(Offset(lightX - 15, y), Offset(lightX + 15, y), lightPaint);
  }

  @override
  bool shouldRepaint(covariant _LightSweepPainter oldDelegate) => oldDelegate.progress != progress;
}

class _ArchGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.03)..strokeWidth = 0.5;
    canvas.drawLine(Offset(size.width * 0.15, 0), Offset(size.width * 0.15, size.height), p);
    canvas.drawLine(Offset(size.width * 0.85, 0), Offset(size.width * 0.85, size.height), p);
    canvas.drawLine(Offset(0, size.height * 0.2), Offset(size.width, size.height * 0.2), p);
    final r = Paint()..color = Colors.white.withOpacity(0.02)..style = PaintingStyle.stroke..strokeWidth = 0.5;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.3, size.height * 0.5, size.width * 0.15, size.height * 0.08), r);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.45, size.height * 0.5, size.width * 0.1, size.height * 0.06), r);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// CTA IŞIĞI 0.18-0.22 PREMIUM HİSSİ - 0.35 DEĞİL
class _CtaWithLight extends StatefulWidget {
  final String label;
  final bool big;
  final double intensity; // 0.7 hero, 0.85 final, 1.0 logo
  const _CtaWithLight({required this.label, this.big = false, this.intensity = 0.70});
  @override
  State<_CtaWithLight> createState() => _CtaWithLightState();
}

class _CtaWithLightState extends State<_CtaWithLight> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(period: const Duration(milliseconds: 3500));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final whiteOpacity = 0.15 + (widget.intensity * 0.10); // 0.22 max, 0.18 min
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: widget.big ? 28 : 20, vertical: widget.big ? 16 : 12),
              color: _gold,
              child: Row(mainAxisSize: MainAxisSize.min, children: [Text(widget.label, style: TextStyle(color: _black, fontSize: widget.big ? 11 : 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(width: 12), Container(width: widget.big ? 28 : 20, height: 1, color: Colors.black54)]),
            ),
            Positioned.fill(
              child: ClipRect(
                child: Transform.translate(
                  offset: Offset((_controller.value * 200) - 50, 0),
                  child: Container(
                    width: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.white.withOpacity(whiteOpacity), Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// STATİK - SARI IŞIK / HOVER YOK - SADECE GRİ + BOŞ OK - arrow_outward + ince border
class _IntentStatic extends StatelessWidget {
  final String n, title, desc;
  const _IntentStatic({required this.n, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x14000000)))),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 48, child: Text(n, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w200, color: _gold.withOpacity(0.8), letterSpacing: -1))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.2, color: Colors.black)),
                    const SizedBox(height: 6),
                    Text(desc, style: const TextStyle(fontSize: 11, color: _gray, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: const Color(0xFFD6D6D6), width: 0.8),
                ),
                child: const Icon(Icons.arrow_outward, size: 13, color: Color(0xFF999999)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: const Color(0xFFE5E5E5)),
        ],
      ),
    );
  }
}

class _ActiveProject extends StatefulWidget {
  final String no, status, title, loc, type, scale, stage;
  const _ActiveProject({required this.no, required this.status, required this.title, required this.loc, required this.type, required this.scale, required this.stage});
  @override
  State<_ActiveProject> createState() => _ActiveProjectState();
}

class _ActiveProjectState extends State<_ActiveProject> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        color: const Color(0xFFFCFBF9),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(border: Border.all(color: Colors.black12)), child: Text(widget.status, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 7, letterSpacing: 1, color: _gray)))),
                const SizedBox(width: 8),
                Text(widget.no, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200, color: _gold.withOpacity(_hover ? 1 : 0.6))),
              ],
            ),
            const SizedBox(height: 14),
            Text(widget.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, height: 1.15)),
            const SizedBox(height: 8),
            Text(widget.loc, style: const TextStyle(fontSize: 8, letterSpacing: 1, color: _gray)),
            const SizedBox(height: 14),
            Container(height: 1, color: _hover ? _gold.withOpacity(0.35) : Colors.black12),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Wrap(spacing: 10, runSpacing: 4, children: [_meta('TÜRÜ', widget.type), _meta('ÖLÇEK', widget.scale), _meta('AŞAMA', widget.stage)]),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.arrow_outward, size: 14, color: _hover ? _gold : Colors.black26),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _meta(String l, String v) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$l ', style: TextStyle(fontSize: 7, color: Colors.black.withOpacity(0.35), letterSpacing: 0.6)),
        Text(v, style: const TextStyle(fontSize: 8, letterSpacing: 0.6)),
      ],
    );
  }
}

// DİKEY TIMELINE - PREMIUM
class _VerticalTimeline extends StatelessWidget {
  const _VerticalTimeline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _timelineItem('01', 'FİKİR', isFirst: true, active: true),
        _timelineItem('02', 'TASARIM'),
        _timelineItem('03', 'TEKNİK PROJELER'),
        _timelineItem('04', 'RUHSAT'),
        _timelineItem('05', 'TEKLİF'),
        _timelineItem('06', 'UYGULAMA', isLast: true),
      ],
    );
  }

  Widget _timelineItem(String n, String t, {bool isFirst = false, bool isLast = false, bool active = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst) Container(width: 1, height: 12, color: Colors.white10),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: active ? _gold : Colors.white24, shape: BoxShape.circle),
            ),
            if (!isLast) Container(width: 1, height: 32, color: Colors.white10),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(n, style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: active ? _gold : Colors.white30)),
                    const SizedBox(width: 12),
                    Text(t, style: TextStyle(color: active ? _gold : Colors.white70, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 1, color: active ? _gold.withOpacity(0.3) : Colors.white10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _VerifiedCard extends StatelessWidget {
  final String name, loc, proj, type;
  const _VerifiedCard({required this.name, required this.loc, required this.proj, required this.type});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(border: Border.all(color: _gold.withOpacity(0.25))),
                child: Text(type, style: const TextStyle(color: _gold, fontSize: 7, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
              ),
              Text(loc, style: const TextStyle(fontSize: 8, letterSpacing: 1, color: _gray)),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: -0.2)),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.black.withOpacity(0.06)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              const Flexible(child: Text('MESLEKİ BELGE DOĞRULANDI', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 8, letterSpacing: 0.8))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.black.withOpacity(0.12), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Flexible(child: Text(proj, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8, letterSpacing: 0.8, color: _gray))),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: _gold.withOpacity(0.35))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 7, color: _black),
                ),
                const SizedBox(width: 6),
                const Text('DOĞRULANDI', style: TextStyle(fontSize: 7, letterSpacing: 1, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
