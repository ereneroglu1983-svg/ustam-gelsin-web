import 'package:flutter/material.dart';
import '../cozum_ortagi_page.dart';
import '../sepet_sayfasi.dart';

class CamAluminyumKategoriPage extends StatefulWidget {
  const CamAluminyumKategoriPage({super.key});
  @override
  State<CamAluminyumKategoriPage> createState() => _CamAluminyumKategoriPageState();
}

class _CamAluminyumKategoriPageState extends State<CamAluminyumKategoriPage> {
  // Cam, Alüminyum & Cephe - Buz Mavisi / Gümüş
  static const Color kCategoryColor = Color(0xFF2F6B8F);
  static const Color kCategoryLight = Color(0xFFE6F0F7);

  bool _isUrunTipiOpen = true;
  bool _isHacimOpen = true;

  final List<String> _altKategoriler = [
    'Cam & Şişecam Sistemleri',
    'Alüminyum Doğrama & Pencere Sistemleri',
    'Cephe Giydirme & Curtain Wall Sistemleri',
    'Sürme, Hebeschiebe & Katlanır Kapı Sistemleri',
    'Küpeşte, Korkuluk & Balkon Sistemleri',
    'Güneş Kırıcı, Louver & Gölgeleme Sistemleri',
    'Otomatik Kapı, Fotoselli & Geçiş Sistemleri',
    'Alüminyum Kompozit & Kaplama Aksesuar Sistemleri',
  ];

  final Map<String, List<String>> _kategoriHacimMap = {
    'Cam & Şişecam Sistemleri': ['4mm Düz Cam', 'Isıcam 24mm', 'Isıcam 28mm', 'Temperli 8mm', 'Lamine 4+4', 'Reflekte Cam'],
    'Alüminyum Doğrama & Pencere Sistemleri': ['50\'lik Seri', '60\'lık Seri', '70\'lik Isı Yalıtımlı', 'Sürme Seri', 'Giyotin Seri'],
    'Cephe Giydirme & Curtain Wall Sistemleri': ['50mm Cephe', '60mm Cephe', 'Strüktürel Silikon', 'Yarı Kapaklı', 'Unitized Sistem'],
    'Sürme, Hebeschiebe & Katlanır Kapı Sistemleri': ['Tek Ray Sürme', 'Çift Ray Sürme', 'Hebeschiebe 156', 'Katlanır 70', 'Akordiyon Sistem'],
    'Küpeşte, Korkuluk & Balkon Sistemleri': ['Alüminyum Küpeşte', 'Camlı Korkuluk', 'Inox Küpeşte', 'Fransız Balkon', 'Balkon Kapama'],
    'Güneş Kırıcı, Louver & Gölgeleme Sistemleri': ['Z Güneş Kırıcı', 'C Güneş Kırıcı', 'Louver Panel', 'Mesh Gölgeleme', 'Kanat Gölgeleme'],
    'Otomatik Kapı, Fotoselli & Geçiş Sistemleri': ['Tek Kanat Fotoselli', 'Çift Kanat Fotoselli', 'Teleskopik', 'Dairesel Döner', '90 Derece Döner'],
    'Alüminyum Kompozit & Kaplama Aksesuar Sistemleri': ['4mm Kompozit', 'Burgu & Vidalama', 'Fitil & Conta', 'Köşe Bağlantı', 'Cephe Ankraj'],
  };

  final Set<String> _seciliTipler = {'Cam & Şişecam Sistemleri'};
  final Set<String> _seciliHacim = {};

  List<String> get _aktifHacimListesi {
    if (_seciliTipler.isEmpty) return ['50\'lik Seri', 'Isıcam 24mm', 'Temperli 8mm', 'Curtain Wall'];
    final Set<String> all = {};
    for (var tip in _seciliTipler) {
      all.addAll(_kategoriHacimMap[tip] ?? []);
    }
    return all.toList();
  }

  final List<Map<String, dynamic>> _urunler = [
    {'ad': 'Şişecam Isıcam Konfor 24mm (4+16+4)', 'detay': 'Cam & Şişecam • Isıcam 24mm', 'fiyat': 850},
    {'ad': 'Alüminyum Doğrama 70\'lik Isı Yalıtımlı Pencere Sistemi', 'detay': 'Doğrama & Pencere • 70\'lik Seri', 'fiyat': 4200},
    {'ad': 'Curtain Wall 50mm Cephe Giydirme Profili 6m', 'detay': 'Cephe Giydirme • 50mm Cephe', 'fiyat': 3150},
    {'ad': 'Hebeschiebe Sürme Kapı Sistemi 156 Seri - Eşikli', 'detay': 'Sürme & Hebeschiebe • Hebeschiebe 156', 'fiyat': 5800},
    {'ad': 'Camlı Alüminyum Korkuluk Sistemi - Eloksal', 'detay': 'Küpeşte & Korkuluk • Camlı Korkuluk', 'fiyat': 1950},
    {'ad': 'Fotoselli Otomatik Kapı Çift Kanat - Dorma Motorlu', 'detay': 'Otomatik Kapı • Çift Kanat Fotoselli', 'fiyat': 24500},
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
      child: const Text('ANA SAYFA > YAPI MARKET > CAM, ALÜMİNYUM & CEPHE SİSTEMLERİ',
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
                            'Seri / Ölçü (${_seciliTipler.isEmpty ? "Tümü" : _seciliTipler.first})',
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
            'Seri / Ölçü',
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
