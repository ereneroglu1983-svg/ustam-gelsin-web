import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// lib/features/hug_market/kategoriler/yapi_malzemeleri.dart - DÜZELTİLMİŞ TAM HALİ - 0 HATA

class YapiMalzemeleriKategoriPage extends StatefulWidget {
  const YapiMalzemeleriKategoriPage({super.key});

  @override
  State<YapiMalzemeleriKategoriPage> createState() => _YapiMalzemeleriKategoriPageState();
}

class _YapiMalzemeleriKategoriPageState extends State<YapiMalzemeleriKategoriPage> {
  static const Color kCategoryColor = Color(0xFFC1983A);
  static const Color kCategoryLight = Color(0xFFFFF5D6);
  static const Color kCategoryGradientStart = Color(0xFFC1983A);
  static const Color kCategoryGradientEnd = Color(0xFFE5C06A);

  final List<String> _altKategoriler = [
    'Çimento & Harç Sistemleri',
    'Beton & Hazır Beton',
    'Tuğla, Blok & Duvar Sistemleri',
    'Alçı, Sıva & Şap',
    'Kuru Yapı Sistemleri',
    'Cephe Sistemleri',
    'Yapı Kimyasalları',
    'Çatı & Çatı Sistemleri',
  ];

  final Set<String> _seciliTipler = {'Çimento & Harç Sistemleri'};
  final Set<String> _seciliHacim = {'Standart'};

  final List<Map<String, dynamic>> _urunler = [
    {
      'ad': 'HUG Portland Çimento 50kg',
      'detay': 'Çimento & Harç • 50kg • CEM I 42.5R',
      'fiyat': 195,
      'ikon': Icons.inventory_2_outlined,
    },
    {
      'ad': 'HUG Hazır Sıva Harcı 25kg',
      'detay': 'Alçı, Sıva & Şap • 25kg • El ile Uygulama',
      'fiyat': 125,
      'ikon': Icons.layers_outlined,
    },
    {
      'ad': 'HUG Gazbeton Blok 600x250x200',
      'detay': 'Tuğla, Blok & Duvar • 600x250x200 • G2',
      'fiyat': 45,
      'ikon': Icons.view_module_outlined,
    },
    {
      'ad': 'HUG Alçıpan 12.5mm 120x250',
      'detay': 'Kuru Yapı Sistemleri • 12.5mm • 120x250',
      'fiyat': 165,
      'ikon': Icons.crop_square_outlined,
    },
    {
      'ad': 'HUG Isı Yalıtım Levhası EPS 5cm',
      'detay': 'Cephe Sistemleri • 5cm • 100x50 • Karbonlu',
      'fiyat': 85,
      'ikon': Icons.thermostat_outlined,
    },
    {
      'ad': 'HUG Su Yalıtım Membranı 10m',
      'detay': 'Yapı Kimyasalları • 10m • 3mm • Polyester',
      'fiyat': 450,
      'ikon': Icons.shield_outlined, // DÜZELTİLDİ - waterproof_outlined yok
    },
    {
      'ad': 'HUG Çatı Kiremidi Kırmızı',
      'detay': 'Çatı & Çatı Sistemleri • Kırmızı • 15adet/m²',
      'fiyat': 18,
      'ikon': Icons.roofing_outlined,
    },
    {
      'ad': 'HUG İnşaat Demiri Nervürlü 12mm',
      'detay': 'Beton & Hazır Beton • 12mm • 12m • B500B',
      'fiyat': 220,
      'ikon': Icons.construction_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Image.asset('assets/hug_market/hug_logo.png', height: 42, errorBuilder: (c, e, s) => Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF0B3D91), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.home, color: Colors.white)), const SizedBox(width: 8), const Text('HUG\nMARKET', style: TextStyle(fontWeight: FontWeight.w900, height: 0.9, color: Color(0xFF0B3D91)))],)),
                  const SizedBox(width: 32),
                  if (!isMobile) ...[
                    _navItem('Ana Sayfa', false, () => context.go('/')),
                    _navItem('Yapı Malzemeleri & İnşaat', true, null),
                    _navItem('Kategoriler', false, () => context.go('/hug-market')),
                    _navItem('Projeleriniz', false, null),
                    _navItem('Destek', false, null),
                  ],
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  const SizedBox(width: 4),
                  Stack(children: [IconButton(onPressed: () => context.go('/hug-market/sepet'), icon: const Icon(Icons.shopping_cart_outlined)), Positioned(right: 4, top: 4, child: Container(padding: const EdgeInsets.all(3), decoration: const BoxDecoration(color: kCategoryColor, shape: BoxShape.circle), child: const Text('0', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold))))]),
                  const SizedBox(width: 8),
                  const Icon(Icons.account_circle_outlined),
                  if (!isMobile) ...[const SizedBox(width: 6), const Text('Hesabım', style: TextStyle(fontWeight: FontWeight.w600))]
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 1),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF5D6), Color(0xFFFFE9A8), Color(0xFFFFF5D6)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: Row(
                children: [
                  Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: kCategoryColor, width: 2)), child: const Icon(Icons.handshake_outlined, color: kCategoryColor, size: 32)),
                  const SizedBox(width: 20),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [RichText(text: const TextSpan(style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0B1E42)), children: [TextSpan(text: 'HUG MARKET '), TextSpan(text: 'Çözüm Ortağı', style: TextStyle(color: kCategoryColor)), TextSpan(text: ' Olmak İster Misiniz?')])), const SizedBox(height: 4), const Text('Ürünlerinizi doğru projelerle buluşturalım, ustanın sahadaki gerçek ihtiyacına birlikte cevap verelim.', style: TextStyle(fontSize: 14, color: Color(0xFF334155), fontWeight: FontWeight.w500))])),
                  const SizedBox(width: 20),
                  ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: kCategoryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0), child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Çözüm Ortağı Ol', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 18)])),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                children: [
                  const Text('Ana Sayfa › Yapı Market › Yapı Malzemeleri & İnşaat', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const Spacer(),
                  Text('${_urunler.length} ürün bulundu', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 16),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)), child: const Row(children: [Text('Sırala: Önerilen ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), Icon(Icons.keyboard_arrow_down, size: 18)])),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: isMobile ? _buildMobileContent() : _buildDesktopContent())),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _navItem(String label, bool active, VoidCallback? onTap) => Padding(padding: const EdgeInsets.only(right: 24), child: InkWell(onTap: onTap, child: Text(label, style: TextStyle(fontWeight: active ? FontWeight.bold : FontWeight.w600, color: active ? kCategoryColor : Colors.black87, decoration: active ? TextDecoration.underline : null, decorationColor: kCategoryColor, decorationThickness: 2))));

  Widget _buildDesktopContent() => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 280, child: _buildFilters()), const SizedBox(width: 20), Expanded(child: _buildProductGrid())]);
  Widget _buildMobileContent() => Column(children: [_buildFilters(), const SizedBox(height: 16), _buildProductGrid()]);

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Filtreler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), TextButton(onPressed: () => setState(() { _seciliTipler.clear(); _seciliHacim.clear(); }), child: const Text('Temizle', style: TextStyle(color: kCategoryColor)))]),
        const Divider(),
        const Text('Ürün Tipi', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._altKategoriler.map((k) => CheckboxListTile(dense: true, contentPadding: EdgeInsets.zero, title: Text(k, style: const TextStyle(fontSize: 13)), value: _seciliTipler.contains(k), activeColor: kCategoryColor, onChanged: (v) => setState(() { if (v == true) _seciliTipler.add(k); else _seciliTipler.remove(k); }))),
        const SizedBox(height: 12),
        const Text('Ölçü / Hacim', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: ['50kg', '25kg', '12.5mm', '5cm', '3m'].map((e) { final sel = _seciliHacim.contains(e); return ChoiceChip(label: Text(e, style: TextStyle(fontSize: 12, color: sel ? Colors.white : Colors.black87)), selected: sel, selectedColor: kCategoryColor, onSelected: (v) => setState(() { if (v) _seciliHacim.add(e); else _seciliHacim.remove(e); })); }).toList()),
        const SizedBox(height: 16),
        const Text('Fiyat', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        RangeSlider(min: 10, max: 15000, divisions: 20, activeColor: kCategoryColor, values: const RangeValues(50, 5000), labels: const RangeLabels('50 TL', '5000 TL'), onChanged: (v) {}),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: kCategoryColor, foregroundColor: Colors.white), child: const Text('Uygula'))),
      ]),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.68, crossAxisSpacing: 14, mainAxisSpacing: 14),
      itemCount: _urunler.length,
      itemBuilder: (context, i) {
        final u = _urunler[i];
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(flex: 3, child: Container(decoration: BoxDecoration(color: kCategoryLight, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))), child: Stack(children: [Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width: 72, height: 72, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: kCategoryColor.withOpacity(0.15), blurRadius: 12)]), child: Icon(u['ikon'] as IconData, size: 36, color: kCategoryColor)), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: kCategoryColor, shape: BoxShape.circle)), const SizedBox(width: 4), const Text('HUG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF0B3D91)))])),])), Positioned(top: 10, right: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: kCategoryColor, borderRadius: BorderRadius.circular(6)), child: const Text('YENİ', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))))]))),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(u['ad'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), const SizedBox(height: 2), Text(u['detay'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)), const Spacer(), Text('${(u['fiyat'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')},00 TL', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0B1E42))), const SizedBox(height: 6), SizedBox(width: double.infinity, height: 34, child: ElevatedButton(onPressed: () => context.go('/hug-market/sepet'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D91), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.zero, elevation: 0), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Sepete Ekle', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), SizedBox(width: 4), Icon(Icons.shopping_cart_outlined, size: 14)])))]))),
          ]),
        );
      },
    );
  }
}
