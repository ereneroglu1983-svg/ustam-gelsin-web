import 'package:flutter/material.dart';
import '../cozum_ortagi_page.dart';
import '../sepet_sayfasi.dart';

// lib/features/hug_market/kategoriler/mutfak_banyo.dart - BOYA İSKELETİ - BANYO & MUTFAK

class MutfakBanyoKategoriPage extends StatefulWidget {
  const MutfakBanyoKategoriPage({super.key});

  @override
  State<MutfakBanyoKategoriPage> createState() => _MutfakBanyoKategoriPageState();
}

class _MutfakBanyoKategoriPageState extends State<MutfakBanyoKategoriPage> {
  static const Color kCategoryColor = Color(0xFF0EA5A0);
  static const Color kCategoryLight = Color(0xFFE0F5F4);

  bool _isUrunTipiOpen = true;
  bool _isHacimOpen = true;

  final List<String> _altKategoriler = [
    'Vitrifiye',
    'Armatür & Duş Sistemleri',
    'Duşakabin',
    'Banyo Mobilyaları',
    'Mutfak Mobilyaları',
    'Mutfak Evyeleri',
    'Tezgâh & Yüzeyler',
  ];

  final Map<String, List<String>> _kategoriHacimMap = {
    'Vitrifiye': ['Asma Klozet', 'Takım Klozet', 'Lavabo 60cm', 'Soft Close'],
    'Armatür & Duş Sistemleri': ['Yağmurlama Set', 'Krom', 'Siyah', 'Ankastre Duş'],
    'Duşakabin': ['80x80', '90x90 Kare', '90x120 Dikdörtgen', '6mm Temperli'],
    'Banyo Mobilyaları': ['60cm Dolap', '80cm Çekmeceli', '100cm', 'Lavabo Dahil'],
    'Mutfak Mobilyaları': ['Alt Modül 60cm', 'Üst Modül 60cm', 'Frenli Kapak', 'Çekmeceli'],
    'Mutfak Evyeleri': ['Tek Gözlü', 'Çift Gözlü Granit', 'Çelik 60cm', 'Köşe Evye'],
    'Tezgâh & Yüzeyler': ['Kuvars 1 Metre 60cm', 'Granit 1 Metre', 'Mermer', 'Laminat'],
  };

  final Set<String> _seciliTipler = {'Vitrifiye'};
  final Set<String> _seciliHacim = {'Standart'};

  List<String> get _aktifHacimListesi {
    if (_seciliTipler.isEmpty) return ['60cm', '80cm', '90x90', 'Standart'];
    final Set<String> all = {};
    for (var tip in _seciliTipler) {
      all.addAll(_kategoriHacimMap[tip]?? []);
    }
    return all.toList();
  }

  final List<Map<String, dynamic>> _urunler = [
    {'ad': 'HUG Vitrifiye Klozet Takımı', 'detay': 'Asma Klozet • Vitrifiye • Soft Close', 'fiyat': 4250},
    {'ad': 'HUG Duş Sistemi Seti', 'detay': 'Armatür & Duş • Tepe Yağmurlama • Krom', 'fiyat': 3890},
    {'ad': 'HUG Duşakabin 90x90', 'detay': 'Duşakabin • Kare • 6mm Temperli Cam', 'fiyat': 6750},
    {'ad': 'HUG Banyo Dolabı 80cm', 'detay': 'Banyo Mobilyası • 80cm • Çekmeceli', 'fiyat': 5120},
    {'ad': 'HUG Mutfak Alt Modül 60cm', 'detay': 'Mutfak Mobilyası • Alt Modül • Frenli', 'fiyat': 2850},
    {'ad': 'HUG Granit Mutfak Evyesi', 'detay': 'Mutfak Evyesi • Granit • Çift Gözlü', 'fiyat': 3450},
    {'ad': 'HUG Kuvars Tezgâh 1 Metre', 'detay': 'Tezgâh & Yüzey • Kuvars • 60cm Derinlik', 'fiyat': 2980},
    {'ad': 'HUG Lavabo Dolabı 65cm', 'detay': 'Banyo Mobilyası • Lavabo Dahil • Beyaz', 'fiyat': 4340},
  ];

  bool _isMobile(double w) => w < 600;
  bool _isDesktop(double w) => w >= 1100;
  int _gridCount(double w) => w < 600? 2 : w < 1100? 3 : 4;

  void _goBack() => Navigator.of(context).pop();
  void _goSepet() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SepetSayfasi()));
  void _goCozumOrtagi() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CozumOrtagiPage()));

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = _isMobile(w);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: isMobile? _mobileAppBar() : null,
      body: CustomScrollView(
        slivers: [
          if (!isMobile) SliverToBoxAdapter(child: _topNav()),
          SliverToBoxAdapter(child: _buildTopBreadcrumb(w)),
          SliverToBoxAdapter(child: _cozumOrtagiBanner()),
          SliverToBoxAdapter(child: _breadcrumbAndFilterBar(w)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: w < 600? 12 : 24, vertical: 8),
            sliver: SliverToBoxAdapter(child: _isDesktop(w)? _buildDesktopContent(w) : _buildProductGrid(w)),
          ),
          SliverToBoxAdapter(child: _buildFooter()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildTopBreadcrumb(double w) {
    return Container(
      padding: EdgeInsets.fromLTRB(w < 600? 12 : 24, 12, w < 600? 12 : 24, 4),
      child: const Text('ANA SAYFA > YAPI MARKET > BANYO & MUTFAK',
          style: TextStyle(color: Colors.black, fontSize: 13.5, fontWeight: FontWeight.w700, letterSpacing: 0.2)),
    );
  }

  Widget _realLogo({double height = 44}) {
    return Image.asset('assets/hug_market/hug_logo.png',
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (c, e, s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF0B3D91), borderRadius: BorderRadius.circular(8)),
            child: const Text('HUG MARKET', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))));
  }

  Widget _topNav() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Stack(alignment: Alignment.center, children: [
        Row(children: [
          IconButton(onPressed: _goBack, icon: const Icon(Icons.arrow_back_ios_new, size: 20)),
          const Spacer(),
          IconButton(onPressed: _goSepet, icon: const Icon(Icons.shopping_cart_outlined))
        ]),
        InkWell(onTap: _goBack, child: _realLogo(height: 46)),
      ]),
    );
  }

  AppBar _mobileAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(onPressed: _goBack, icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20)),
      title: _realLogo(height: 38),
      centerTitle: true,
      actions: [
        IconButton(onPressed: _goSepet, icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87)),
        const SizedBox(width: 4)
      ],
    );
  }

  Widget _cozumOrtagiBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: InkWell(
        onTap: _goCozumOrtagi,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset('assets/hug_market/cozum_ortagi.png', width: double.infinity, fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(height: 100, decoration: BoxDecoration(color: kCategoryLight, borderRadius: BorderRadius.circular(12)), child: const Center(child: Text('cozum_ortagi.png bulunamadı', style: TextStyle(color: Colors.black54)))),
          ),
        ),
      ),
    );
  }

  Widget _breadcrumbAndFilterBar(double w) {
    final isMobile = _isMobile(w);
    final filterCount = _seciliTipler.length + _seciliHacim.length;
    return Container(
      padding: EdgeInsets.fromLTRB(w < 600? 12 : 24, 12, w < 600? 12 : 24, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
          if (isMobile) SizedBox(height: 32, child: OutlinedButton.icon(onPressed: _openFilterSheet, icon: const Icon(Icons.tune, size: 14, color: Colors.black87), label: Text(filterCount > 0? 'Filtrele ($filterCount)' : 'Filtrele', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 11)), style: OutlinedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0)))),
          ..._seciliTipler.map((e) => _buildTextFilter(e, () => setState(() => _seciliTipler.remove(e)))),
          ..._seciliHacim.map((e) => _buildTextFilter(e, () => setState(() => _seciliHacim.remove(e)))),
        ]),
        const SizedBox(height: 8),
        Text('${_urunler.length} ÜRÜN SERGİLENMEKTEDİR...', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.black54, letterSpacing: 0.3)),
      ]),
    );
  }

  Widget _buildTextFilter(String text, VoidCallback onRemove) {
    return InkWell(onTap: onRemove, borderRadius: BorderRadius.circular(4), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(text, style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500)), const SizedBox(width: 3), const Icon(Icons.close, size: 12, color: Colors.black54)])));
  }

  void _openFilterSheet() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), builder: (ctx) {
      return DraggableScrollableSheet(initialChildSize: 0.85, maxChildSize: 0.95, minChildSize: 0.5, expand: false, builder: (context, scrollController) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Column(children: [
            Container(margin: const EdgeInsets.only(top: 8), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            Padding(padding: const EdgeInsets.fromLTRB(16, 16, 8, 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Filtreler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black)), TextButton(onPressed: () { setState(() { _seciliTipler.clear(); _seciliHacim.clear(); }); setSheetState(() {}); }, child: const Text('Temizle', style: TextStyle(color: kCategoryColor, fontWeight: FontWeight.bold)))])),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            Expanded(child: ListView(controller: scrollController, children: [
              _filterSectionSheet('Ürün Tipi', _isUrunTipiOpen, () { _isUrunTipiOpen =!_isUrunTipiOpen; setSheetState(() {}); setState(() {}); }, Column(children: _altKategoriler.map((k) => CheckboxListTile(dense: true, activeColor: kCategoryColor, checkColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 16), title: Text(k, style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600)), value: _seciliTipler.contains(k), onChanged: (v) { setState(() { if (v == true) _seciliTipler.add(k); else _seciliTipler.remove(k); }); setSheetState(() {}); })).toList())),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),
              _filterSectionSheet('Ölçü / Model (${_seciliTipler.isEmpty? "Tümü" : _seciliTipler.first})', _isHacimOpen, () { _isHacimOpen =!_isHacimOpen; setSheetState(() {}); }, Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Wrap(spacing: 8, runSpacing: 8, children: _aktifHacimListesi.map((e) { final sel = _seciliHacim.contains(e); return ChoiceChip(label: Text(e, style: TextStyle(fontSize: 12, color: sel? Colors.white : Colors.black, fontWeight: FontWeight.w600)), selected: sel, selectedColor: kCategoryColor, backgroundColor: Colors.white, side: BorderSide(color: sel? kCategoryColor : Colors.grey.shade400), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), showCheckmark: false, onSelected: (v) { setState(() { if (v) _seciliHacim.add(e); else _seciliHacim.remove(e); }); setSheetState(() {}); }); }).toList()))),
            ])),
            SafeArea(child: Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + MediaQuery.of(context).viewPadding.bottom), child: SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: kCategoryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Filtrele', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))))),
          ]);
        });
      });
    });
  }

  Widget _filterSectionSheet(String title, bool isOpen, VoidCallback onTap, Widget child) {
    return Column(children: [InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black)), Icon(isOpen? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black)]))), AnimatedCrossFade(firstChild: child, secondChild: const SizedBox.shrink(), crossFadeState: isOpen? CrossFadeState.showFirst : CrossFadeState.showSecond, duration: const Duration(milliseconds: 200))]);
  }

  Widget _buildDesktopContent(double w) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 300, child: _buildDesktopFilters()), const SizedBox(width: 16), Expanded(child: _buildProductGrid(w))]);

  Widget _buildDesktopFilters() {
    return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]), child: Column(children: [
      Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Filtreler', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black)), TextButton(onPressed: () => setState(() { _seciliTipler.clear(); _seciliHacim.clear(); }), child: const Text('Temizle', style: TextStyle(color: kCategoryColor, fontWeight: FontWeight.bold)))])),
      const Divider(height: 1),
      _filterSectionSheet('Ürün Tipi', _isUrunTipiOpen, () => setState(() => _isUrunTipiOpen =!_isUrunTipiOpen), Column(children: _altKategoriler.map((k) => CheckboxListTile(dense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 8), activeColor: kCategoryColor, checkColor: Colors.white, title: Text(k, style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600)), value: _seciliTipler.contains(k), onChanged: (v) => setState(() { if (v == true) _seciliTipler.add(k); else _seciliTipler.remove(k); }))).toList())),
      const Divider(height: 1),
      _filterSectionSheet('Ölçü / Model', _isHacimOpen, () => setState(() => _isHacimOpen =!_isHacimOpen), Padding(padding: const EdgeInsets.all(12), child: Wrap(spacing: 6, runSpacing: 6, children: _aktifHacimListesi.map((e) { final sel = _seciliHacim.contains(e); return ChoiceChip(label: Text(e, style: TextStyle(fontSize: 11, color: sel? Colors.white : Colors.black, fontWeight: FontWeight.w600)), selected: sel, selectedColor: kCategoryColor, backgroundColor: Colors.white, side: BorderSide(color: sel? kCategoryColor : Colors.grey.shade400), onSelected: (v) => setState(() { if (v) _seciliHacim.add(e); else _seciliHacim.remove(e); })); }).toList()))),
    ]));
  }

  Widget _buildProductGrid(double w) {
    return GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _gridCount(w), childAspectRatio: w < 600? 0.52 : 0.60, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: _urunler.length, itemBuilder: (context, i) {
      final u = _urunler[i];
      return InkWell(onTap: _goCozumOrtagi, borderRadius: BorderRadius.circular(12), child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: kCategoryColor, width: 1.5)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(flex: 4, child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(10.5)), child: Container(color: Colors.white, child: Image.asset('assets/hug_market/reklam_karti.png', fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (c, e, s) => Container(color: Colors.white, child: const Center(child: Icon(Icons.image_not_supported_outlined, color: kCategoryColor, size: 28))))))),
        Expanded(flex: 3, child: Padding(padding: const EdgeInsets.fromLTRB(8, 6, 8, 6), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(u['ad'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black, height: 1.1)), const SizedBox(height: 2), Text(u['detay'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, color: Colors.black54, height: 1.1)), const Spacer(), Text('${u['fiyat']},00 TL', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.black)), const SizedBox(height: 4), SizedBox(width: double.infinity, height: 28, child: ElevatedButton(onPressed: _goCozumOrtagi, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D91), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: const Text('Çözüm Ortağı Ol', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))))])))])));
    });
  }

  Widget _buildFooter() {
    return Container(width: double.infinity, margin: const EdgeInsets.fromLTRB(12, 24, 12, 12), padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: const Center(child: Text('Hemen Ustam Gelsin Her Hakkı Saklıdır © 2026', style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3), textAlign: TextAlign.center)));
  }
}