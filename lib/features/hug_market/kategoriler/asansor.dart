import 'package:flutter/material.dart';
import '../cozum_ortagi_page.dart';
import '../sepet_sayfasi.dart';

class AsansorKategoriPage extends StatefulWidget {
  const AsansorKategoriPage({super.key});
  @override
  State<AsansorKategoriPage> createState() => _AsansorKategoriPageState();
}

class _AsansorKategoriPageState extends State<AsansorKategoriPage> {
  // Asansör, Yürüyen Merdiven & Mekanik Taşıma - Endüstriyel Sarı / Paslanmaz Çelik
  static const Color kCategoryColor = Color(0xFFCA8A04);
  static const Color kCategoryLight = Color(0xFFFEF9C3);

  bool _isUrunTipiOpen = true;
  bool _isHacimOpen = true;

  final List<String> _altKategoriler = [
    'İnsan Asansörü Sistemleri',
    'Yük Asansörü & Sedye Asansörleri',
    'Araç Asansörü & Otopark Asansörleri',
    'Engelli Asansörü & Platform Sistemleri',
    'Yürüyen Merdiven & Yürüyen Bant Sistemleri',
    'Mekanik Otopark & Araç Park Sistemleri',
    'Asansör Kabin, Kapı & Revizyon Sistemleri',
    'Vinç, Caraskal & Kaldırma Sistemleri',
  ];

  final Map<String, List<String>> _kategoriHacimMap = {
    'İnsan Asansörü Sistemleri': ['6 Kişilik 480kg', '8 Kişilik 630kg', '10 Kişilik 800kg', '13 Kişilik 1000kg', 'Makine Daireli', 'Makine Dairesiz MRL'],
    'Yük Asansörü & Sedye Asansörleri': ['1000kg Yük', '2000kg Yük', '3000kg Yük', '5000kg Yük', 'Sedye 1600kg', 'Mutfak Servis 100kg'],
    'Araç Asansörü & Otopark Asansörleri': ['2500kg Araç', '3000kg Araç', '5000kg Araç', '4 Sütunlu', 'Makaslı Platform', 'Döner Tabla'],
    'Engelli Asansörü & Platform Sistemleri': ['Dikey Platform 2m', 'Dikey Platform 3m', 'Merdiven Tipi Platform', 'Eğimli Platform', 'Hidrolik Platform', 'Vakum Asansör'],
    'Yürüyen Merdiven & Yürüyen Bant Sistemleri': ['30° Yürüyen Merdiven', '35° Yürüyen Merdiven', '0° Yürüyen Bant', '12° Yürüyen Bant', 'İç Mekan Tipi', 'Dış Mekan Tipi'],
    'Mekanik Otopark & Araç Park Sistemleri': ['2 Katlı Puzzle', '4 Katlı Tower', 'Döner Otopark 8 Araç', 'Shuttle Sistem', 'AGV Robotik', 'Çukur Tipi 2 Araç'],
    'Asansör Kabin, Kapı & Revizyon Sistemleri': ['Otomatik Kapı 2 Panel', 'Otomatik Kapı 4 Panel', 'Yarı Otomatik Kapı', 'Kabin Inox', 'Revizyon Paketi', 'Regülatör & Fren'],
    'Vinç, Caraskal & Kaldırma Sistemleri': ['Monoray Vinç 1 Ton', 'Pergel Vinç 2 Ton', 'Caraskal 500kg', 'Makara Takımı', 'Hidrolik Kaldırma', 'Tavan Vinç 5 Ton'],
  };

  final Set<String> _seciliTipler = {'İnsan Asansörü Sistemleri'};
  final Set<String> _seciliHacim = {};

  List<String> get _aktifHacimListesi {
    if (_seciliTipler.isEmpty) return ['8 Kişilik 630kg', '2000kg Yük', '30° Yürüyen Merdiven', 'Puzzle Otopark'];
    final Set<String> all = {};
    for (var tip in _seciliTipler) {
      all.addAll(_kategoriHacimMap[tip] ?? []);
    }
    return all.toList();
  }

  final List<Map<String, dynamic>> _urunler = [
    {'ad': 'HUG İnsan Asansörü 8 Kişilik 630kg - MRL - 6 Durak', 'detay': 'İnsan Asansörü • 8 Kişilik 630kg • MRL', 'fiyat': 485000},
    {'ad': 'HUG Yük Asansörü 2000kg - Hidrolik - 3 Durak', 'detay': 'Yük Asansörü • 2000kg Yük • Hidrolik', 'fiyat': 620000},
    {'ad': 'HUG Yürüyen Merdiven 35° - 1000mm Basamak - İç Mekan', 'detay': 'Yürüyen Merdiven • 35° • 1000mm Basamak', 'fiyat': 1250000},
    {'ad': 'HUG Mekanik Otopark Puzzle 2 Katlı - 4 Araçlık', 'detay': 'Mekanik Otopark • 2 Katlı Puzzle • 4 Araç', 'fiyat': 780000},
    {'ad': 'Asansör Otomatik Kapı 800mm - 2 Panel - Fermator', 'detay': 'Kabin & Kapı • Otomatik Kapı 2 Panel', 'fiyat': 45000},
    {'ad': 'Monoray Vinç 1 Ton - 6m Bom - Elektrikli Yürüyüş', 'detay': 'Vinç & Caraskal • Monoray Vinç 1 Ton', 'fiyat': 125000},
  ];

  bool _isMobile(double w) => w < 600;
  bool _isDesktop(double w) => w >= 1100;
  int _gridCount(double w) => w < 600 ? 2 : w < 1100 ? 3 : 4;

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _goSepet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SepetSayfasi()),
    );
  }

  void _goCozumOrtagi() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CozumOrtagiPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = _isMobile(w);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: isMobile ? _mobileAppBar() : null,
      body: CustomScrollView(
        slivers: [
          if (!isMobile) SliverToBoxAdapter(child: _topNav()),
          SliverToBoxAdapter(child: _buildTopBreadcrumb(w)),
          SliverToBoxAdapter(child: _cozumOrtagiBanner()),
          SliverToBoxAdapter(child: _breadcrumbAndFilterBar(w)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: w < 600 ? 12 : 24, vertical: 8),
            sliver: SliverToBoxAdapter(child: _isDesktop(w) ? _buildDesktopContent(w) : _buildProductGrid(w)),
          ),
          SliverToBoxAdapter(child: _buildFooter()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildTopBreadcrumb(double w) {
    return Container(
      padding: EdgeInsets.fromLTRB(w < 600 ? 12 : 24, 12, w < 600 ? 12 : 24, 4),
      child: const Text('ANA SAYFA > YAPI MARKET > ASANSÖR, YÜRÜYEN MERDİVEN & MEKANİK TAŞIMA SİSTEMLERİ',
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
      leading: IconButton(
          onPressed: _goBack, icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20)),
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
          child: Image.asset(
            'assets/hug_market/cozum_ortagi.png',
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              height: 100,
              decoration: BoxDecoration(color: kCategoryLight, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('cozum_ortagi.png bulunamadı', style: TextStyle(color: Colors.black54))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _breadcrumbAndFilterBar(double w) {
    final isMobile = _isMobile(w);
    final filterCount = _seciliTipler.length + _seciliHacim.length;
    return Container(
      padding: EdgeInsets.fromLTRB(w < 600 ? 12 : 24, 12, w < 600 ? 12 : 24, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (isMobile)
              SizedBox(
                height: 32,
                child: OutlinedButton.icon(
                  onPressed: _openFilterSheet,
                  icon: const Icon(Icons.tune, size: 14, color: Colors.black87),
                  label: Text(filterCount > 0 ? 'Filtrele ($filterCount)' : 'Filtrele',
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0)),
                ),
              ),
            ..._seciliTipler.map((e) => _buildTextFilter(e, () => setState(() => _seciliTipler.remove(e)))),
            ..._seciliHacim.map((e) => _buildTextFilter(e, () => setState(() => _seciliHacim.remove(e)))),
          ],
        ),
        const SizedBox(height: 8),
        Text('${_urunler.length} ÜRÜN SERGİLENMEKTEDİR...',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.black54, letterSpacing: 0.3)),
      ]),
    );
  }

  Widget _buildTextFilter(String text, VoidCallback onRemove) {
    return InkWell(
      onTap: onRemove,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500)),
            const SizedBox(width: 3),
            const Icon(Icons.close, size: 12, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setSheetState) {
                return Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Filtreler',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black)),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _seciliTipler.clear();
                                  _seciliHacim.clear();
                                });
                                setSheetState(() {});
                              },
                              child: const Text('Temizle',
                                  style: TextStyle(color: kCategoryColor, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          _filterSectionSheet(
                            'Ürün Tipi',
                            _isUrunTipiOpen,
                                () {
                              _isUrunTipiOpen = !_isUrunTipiOpen;
                              setSheetState(() {});
                              setState(() {});
                            },
                            Column(
                                children: _altKategoriler.map((k) {
                                  return CheckboxListTile(
                                    dense: true,
                                    activeColor: kCategoryColor,
                                    checkColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                    title: Text(k,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600)),
                                    value: _seciliTipler.contains(k),
                                    onChanged: (v) {
                                      setState(() {
                                        if (v == true) _seciliTipler.add(k);
                                        else _seciliTipler.remove(k);
                                      });
                                      setSheetState(() {});
                                    },
                                  );
                                }).toList()),
                          ),
                          const Divider(height: 1, color: Color(0xFFE0E0E0)),
                          _filterSectionSheet(
                            'Kapasite / Tip (${_seciliTipler.isEmpty ? "Tümü" : _seciliTipler.first})',
                            _isHacimOpen,
                                () {
                              _isHacimOpen = !_isHacimOpen;
                              setSheetState(() {});
                            },
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _aktifHacimListesi.map((e) {
                                    final sel = _seciliHacim.contains(e);
                                    return ChoiceChip(
                                      label: Text(e,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: sel ? Colors.white : Colors.black,
                                              fontWeight: FontWeight.w600)),
                                      selected: sel,
                                      selectedColor: kCategoryColor,
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: sel ? kCategoryColor : Colors.grey.shade400),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      showCheckmark: false,
                                      onSelected: (v) {
                                        setState(() {
                                          if (v) _seciliHacim.add(e);
                                          else _seciliHacim.remove(e);
                                        });
                                        setSheetState(() {});
                                      },
                                    );
                                  }).toList()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + MediaQuery.of(context).viewPadding.bottom),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kCategoryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: const Text('Filtrele',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _filterSectionSheet(String title, bool isOpen, VoidCallback onTap, Widget child) {
    return Column(children: [
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black)),
            Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black),
          ]),
        ),
      ),
      AnimatedCrossFade(
          firstChild: child,
          secondChild: const SizedBox.shrink(),
          crossFadeState: isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200)),
    ]);
  }

  Widget _buildDesktopContent(double w) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 300, child: _buildDesktopFilters()),
      const SizedBox(width: 16),
      Expanded(child: _buildProductGrid(w)),
    ]);
  }

  Widget _buildDesktopFilters() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Filtreler', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black)),
              TextButton(
                  onPressed: () => setState(() {
                    _seciliTipler.clear();
                    _seciliHacim.clear();
                  }),
                  child: const Text('Temizle', style: TextStyle(color: kCategoryColor, fontWeight: FontWeight.bold)))
            ])),
        const Divider(height: 1),
        _filterSectionSheet(
            'Ürün Tipi',
            _isUrunTipiOpen,
                () => setState(() => _isUrunTipiOpen = !_isUrunTipiOpen),
            Column(
                children: _altKategoriler
                    .map((k) => CheckboxListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    activeColor: kCategoryColor,
                    checkColor: Colors.white,
                    title: Text(k,
                        style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600)),
                    value: _seciliTipler.contains(k),
                    onChanged: (v) => setState(() {
                      if (v == true) _seciliTipler.add(k);
                      else _seciliTipler.remove(k);
                    })))
                    .toList())),
        const Divider(height: 1),
        _filterSectionSheet(
            'Kapasite / Tip',
            _isHacimOpen,
                () => setState(() => _isHacimOpen = !_isHacimOpen),
            Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _aktifHacimListesi.map((e) {
                      final sel = _seciliHacim.contains(e);
                      return ChoiceChip(
                          label: Text(e,
                              style: TextStyle(
                                  fontSize: 11, color: sel ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                          selected: sel,
                          selectedColor: kCategoryColor,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: sel ? kCategoryColor : Colors.grey.shade400),
                          onSelected: (v) => setState(() {
                            if (v) _seciliHacim.add(e);
                            else _seciliHacim.remove(e);
                          }));
                    }).toList()))),
      ]),
    );
  }

  Widget _buildProductGrid(double w) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gridCount(w),
          childAspectRatio: w < 600 ? 0.52 : 0.60,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: _urunler.length,
      itemBuilder: (context, i) {
        final u = _urunler[i];
        return InkWell(
          onTap: _goCozumOrtagi,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kCategoryColor, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10.5)),
                    child: Container(
                      color: Colors.white,
                      child: Image.asset(
                        'assets/hug_market/reklam_karti.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (c, e, s) => Container(
                          color: Colors.white,
                          child: const Center(
                            child: Icon(Icons.image_not_supported_outlined, color: kCategoryColor, size: 28),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u['ad'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black, height: 1.1)),
                        const SizedBox(height: 2),
                        Text(u['detay'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 9, color: Colors.black54, height: 1.1)),
                        const Spacer(),
                        Text('${u['fiyat']},00 TL',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.black)),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: ElevatedButton(
                            onPressed: _goCozumOrtagi,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B3D91),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Çözüm Ortağı Ol',
                                style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 24, 12, 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: Text(
          'Hemen Ustam Gelsin Her Hakkı Saklıdır © 2026',
          style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
