import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// lib/features/hug_market/kategoriler/temizlik.dart

class TemizlikKategoriPage extends StatefulWidget {
  const TemizlikKategoriPage({super.key});

  @override
  State<TemizlikKategoriPage> createState() => _TemizlikKategoriPageState();
}

class _TemizlikKategoriPageState extends State<TemizlikKategoriPage> {
  // KATEGORİ RENGİ - Görselden alınan Temizlik & Hijyen koyu lacivert-antrasit tonu
  static const Color kCategoryColor = Color(0xFF324A67);
  static const Color kCategoryLight = Color(0xFFE8EEF4);
  static const Color kCategoryGradientStart = Color(0xFF324A67);
  static const Color kCategoryGradientEnd = Color(0xFF5A7A9C);

  final List<String> _altKategoriler = [
    'Profesyonel Temizlik Ürünleri',
    'Dezenfeksiyon & Hijyen',
    'Yüzey Temizleme Sistemleri',
    'Zemin Temizlik & Bakım',
    'Cam & Cephe Temizliği',
    'Endüstriyel Temizlik',
    'Temizlik Ekipmanları',
    'Hijyen Dispenser Sistemleri',
  ];

  final Set<String> _seciliTipler = {'Profesyonel Temizlik Ürünleri'};
  final Set<String> _seciliHacim = {'5L'};

  final List<Map<String, dynamic>> _urunler = [
    {
      'ad': 'HUG Profesyonel Yüzey Temizleyici 5L',
      'detay': 'Yüzey Temizleme • Konsantre • 5L',
      'fiyat': 320,
      'ikon': Icons.cleaning_services_outlined,
    },
    {
      'ad': 'HUG Dezenfektan Konsantre 5L',
      'detay': 'Dezenfeksiyon & Hijyen • Hastane Tipi • 5L',
      'fiyat': 485,
      'ikon': Icons.sanitizer_outlined,
    },
    {
      'ad': 'HUG Endüstriyel Süpürge 3600W',
      'detay': 'Temizlik Ekipmanları • Islak-Kuru • 60L',
      'fiyat': 8750,
      'ikon': Icons.build_circle_outlined,
    },
    {
      'ad': 'HUG Zemin Temizleme Makinesi',
      'detay': 'Zemin Temizlik & Bakım • Otomatik • 50cm',
      'fiyat': 24500,
      'ikon': Icons.local_laundry_service_outlined,
    },
    {
      'ad': 'HUG Cam Temizleme Seti Pro',
      'detay': 'Cam & Cephe Temizliği • Teleskopik • 6m',
      'fiyat': 1240,
      'ikon': Icons.window_outlined,
    },
    {
      'ad': 'HUG Endüstriyel Deterjan 20L',
      'detay': 'Endüstriyel Temizlik • Yağ Sökücü • 20L',
      'fiyat': 890,
      'ikon': Icons.local_drink_outlined,
    },
    {
      'ad': 'HUG Temizlik Arabası Seti',
      'detay': 'Temizlik Ekipmanları • Presli Kovalı • Set',
      'fiyat': 2150,
      'ikon': Icons.shopping_cart_outlined,
    },
    {
      'ad': 'HUG Köpük Sabun Dispenseri',
      'detay': 'Hijyen Dispenser • Otomatik • Paslanmaz',
      'fiyat': 650,
      'ikon': Icons.soap_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      body: CustomScrollView(
        slivers: [
          // TOP BAR - LOGO - assets/hug_market/hug_logo.png
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Image.asset(
                    'assets/hug_market/hug_logo.png',
                    height: 42,
                    errorBuilder: (c, e, s) => Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B3D91),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.home, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Text('HUG\nMARKET',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                height: 0.9,
                                color: Color(0xFF0B3D91))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  if (!isMobile) ...[
                    _navItem('Ana Sayfa', false, () => context.go('/')),
                    _navItem('Temizlik & Hijyen', true, null),
                    _navItem('Kategoriler', false, () => context.go('/hug-market')),
                    _navItem('Projeleriniz', false, null),
                    _navItem('Destek', false, null),
                  ],
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  const SizedBox(width: 4),
                  Stack(
                    children: [
                      IconButton(onPressed: () => context.go('/hug-market/sepet'), icon: const Icon(Icons.shopping_cart_outlined)),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: kCategoryColor, shape: BoxShape.circle),
                          child: const Text('0', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.account_circle_outlined),
                  if (!isMobile) ...[
                    const SizedBox(width: 6),
                    const Text('Hesabım', style: TextStyle(fontWeight: FontWeight.w600)),
                  ]
                ],
              ),
            ),
          ),

          // ÇÖZÜM ORTAĞI BANNER
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 1),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8EEF4), Color(0xFFD0DDEA), Color(0xFFE8EEF4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: kCategoryColor, width: 2),
                    ),
                    child: const Icon(Icons.handshake_outlined, color: kCategoryColor, size: 32),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0B1E42)),
                            children: [
                              TextSpan(text: 'HUG MARKET '),
                              TextSpan(text: 'Çözüm Ortağı', style: TextStyle(color: kCategoryColor)),
                              TextSpan(text: ' Olmak İster Misiniz?'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ürünlerinizi doğru projelerle buluşturalım, ustanın sahadaki gerçek ihtiyacına birlikte cevap verelim.',
                          style: TextStyle(fontSize: 14, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Çözüm ortağı başvuru formu yakında...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kCategoryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Çözüm Ortağı Ol', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BREADCRUMB + BAŞLIK
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                children: [
                  const Text('Ana Sayfa › Yapı Market › Temizlik & Hijyen', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const Spacer(),
                  Text('${_urunler.length} ürün bulundu', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                    child: const Row(
                      children: [
                        Text('Sırala: Önerilen ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ANA İÇERİK
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: isMobile ? _buildMobileContent() : _buildDesktopContent(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _navItem(String label, bool active, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: active ? FontWeight.bold : FontWeight.w600,
            color: active ? kCategoryColor : Colors.black87,
            decoration: active ? TextDecoration.underline : null,
            decorationColor: kCategoryColor,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 280, child: _buildFilters()),
        const SizedBox(width: 20),
        Expanded(child: _buildProductGrid()),
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
        _buildFilters(),
        const SizedBox(height: 16),
        _buildProductGrid(),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filtreler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () => setState(() { _seciliTipler.clear(); _seciliHacim.clear(); }), child: const Text('Temizle', style: TextStyle(color: kCategoryColor))),
            ],
          ),
          const Divider(),
          const Text('Ürün Tipi', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._altKategoriler.map((k) => CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(k, style: const TextStyle(fontSize: 13)),
            value: _seciliTipler.contains(k),
            activeColor: kCategoryColor,
            onChanged: (v) => setState(() {
              if (v == true) _seciliTipler.add(k); else _seciliTipler.remove(k);
            }),
          )),
          const SizedBox(height: 12),
          const Text('Kapasite / Tip', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['5L', '20L', '60L', 'Set', 'Otomatik', 'Konsantre'].map((e) {
              final sel = _seciliHacim.contains(e);
              return ChoiceChip(
                label: Text(e, style: TextStyle(fontSize: 12, color: sel ? Colors.white : Colors.black87)),
                selected: sel,
                selectedColor: kCategoryColor,
                onSelected: (v) => setState(() { if (v) _seciliHacim.add(e); else _seciliHacim.remove(e); }),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Fiyat', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          RangeSlider(
            min: 100,
            max: 30000,
            divisions: 20,
            activeColor: kCategoryColor,
            values: const RangeValues(500, 10000),
            labels: const RangeLabels('500 TL', '10000 TL'),
            onChanged: (v) {},
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: kCategoryColor, foregroundColor: Colors.white),
              child: const Text('Uygula'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.68,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: _urunler.length,
      itemBuilder: (context, i) {
        final u = _urunler[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: kCategoryLight,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [BoxShadow(color: kCategoryColor.withOpacity(0.15), blurRadius: 12)],
                              ),
                              child: Icon(u['ikon'] as IconData, size: 36, color: kCategoryColor),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: kCategoryColor, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  const Text('HUG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF0B3D91))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: kCategoryColor, borderRadius: BorderRadius.circular(6)),
                          child: const Text('YENİ', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u['ad'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(u['detay'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      const Spacer(),
                      Text('${(u['fiyat'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')},00 TL',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0B1E42))),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        height: 34,
                        child: ElevatedButton(
                          onPressed: () => context.go('/hug-market/sepet'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B3D91),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Sepete Ekle', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              SizedBox(width: 4),
                              Icon(Icons.shopping_cart_outlined, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
