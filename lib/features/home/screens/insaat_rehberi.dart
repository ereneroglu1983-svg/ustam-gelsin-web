import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class InsaatRehberiScreen extends StatelessWidget {
  const InsaatRehberiScreen({super.key});

  String _fixUrl(String path) {
    path = path.trim();
    if (path.isEmpty) return path;
    const String cdnBase = "https://cdn.hemenustamgelsin.com";
    const String oldR2 = "https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev";
    path = path.replaceAll(oldR2, cdnBase);
    path = path.replaceAll('$cdnBase/ustam-gelsin-medya/', '$cdnBase/');
    path = path.replaceAll('/ustam-gelsin-medya/', '/');
    path = path.replaceAll('ustam-gelsin-medya/', '');
    if (path.startsWith('http')) return path;
    if (path.startsWith('/')) return '$cdnBase$path';
    return '$cdnBase/$path';
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb || MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f2233),
        surfaceTintColor: const Color(0xFF0f2233),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📖 İnşaat Rehberi", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            Text("Ev tadilatı hakkında bilmeniz gereken her şey", style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('icerikler').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0f2233))));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Padding(padding: const EdgeInsets.all(24), child: Center(child: Text("Henüz içerik eklenmemiş.", style: GoogleFonts.poppins())));
                }
                final docs = List.from(snapshot.data!.docs);
                docs.sort((a, b) {
                  final da = (a.data() as Map<String, dynamic>);
                  final db = (b.data() as Map<String, dynamic>);
                  final ta = da['tarih'] is Timestamp? (da['tarih'] as Timestamp).toDate().millisecondsSinceEpoch : 0;
                  final tb = db['tarih'] is Timestamp? (db['tarih'] as Timestamp).toDate().millisecondsSinceEpoch : 0;
                  return tb.compareTo(ta);
                });
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 24 : 16, vertical: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return _RehberCompactCard(
                      baslik: data['baslik'] ?? 'Başlıksız',
                      kategori: data['kategori'] ?? 'TADİLAT',
                      tarih: data['tarih'] is Timestamp ? data['tarih'] as Timestamp : null,
                      imagePath: _fixUrl(data['imagePath'] ?? data['resim'] ?? ''),
                      contentPath: _fixUrl(data['contentPath'] ?? ''),
                      youtubeId: data['youtubeId'] ?? '',
                      slug: data['slug'] ?? doc.id,
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('karisik_slider').snapshots(),
              builder: (context, snap) {
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                }
                final docs = List.from(snap.data!.docs);
                docs.sort((a, b) {
                  final da = (a.data() as Map<String, dynamic>);
                  final db = (b.data() as Map<String, dynamic>);
                  final ta = da['tarih'] is Timestamp? (da['tarih'] as Timestamp).toDate().millisecondsSinceEpoch : 0;
                  final tb = db['tarih'] is Timestamp? (db['tarih'] as Timestamp).toDate().millisecondsSinceEpoch : 0;
                  return tb.compareTo(ta);
                });
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(isWeb ? 24 : 16, 8, isWeb ? 24 : 16, 8),
                      child: Text("Yeni Katılan Ustalar (${docs.length})", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: isWeb ? 14 : 16)),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: isWeb ? 1200 : double.infinity),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: isWeb ? 24 : 16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isWeb ? 6 : 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: isWeb ? 8 : 12,
                            mainAxisSpacing: isWeb ? 8 : 12,
                          ),
                          itemCount: docs.length,
                          itemBuilder: (context, i) {
                            final d = docs[i].data() as Map<String, dynamic>;
                            final img = _fixUrl(d['imagePath'] ?? d['image'] ?? d['resim'] ?? d['photoURL'] ?? '');
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(isWeb ? 8 : 12),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: isWeb ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))] : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(isWeb ? 8 : 12),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade100, child: const Icon(Icons.person))),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(isWeb ? 5 : 8),
                                        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87])),
                                        child: Text(d['baslik'] ?? d['adSoyad'] ?? d['displayName'] ?? 'Usta', style: GoogleFonts.poppins(color: Colors.white, fontSize: isWeb ? 9 : 11, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Color(0xFFE7E5E4)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Popüler Konular", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      'Tadilat Rehberi',
                      'Dekorasyon Fikirleri',
                      'Mutfak Tadilatı',
                      'Banyo Yenileme',
                      'Elektrik Tesisatı',
                      'Su Tesisatı',
                      'Boya Badana',
                      'Isı Yalıtım',
                      'Çatı Tamiri',
                      'Fayans Döşeme',
                      'Parke Döşeme',
                      'Alçıpan İşleri'
                    ]
                        .map((k) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F4), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFE7E5E4))),
                      child: Text(k, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w500, color: const Color(0xFF78716C))),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
            // FOOTER - KIRMIZI LEGO KALDIRILDI + NAV TUŞU FIX
            Container(
              width: double.infinity,
              color: const Color(0xFF0f2233),
              padding: EdgeInsets.fromLTRB(24, 28, 24, 28 + MediaQuery.of(context).padding.bottom),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Text("HEMEN USTAM GELSİN", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    Text(
                      "İnşaat, tadilat ve dekorasyonda\ngüvenilir ustanın adresi",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    Container(height: 1, color: Colors.white10),
                    const SizedBox(height: 16),
                    Text(
                      "© 2026 Hemen Ustam Gelsin\nHer Hakkı Saklıdır",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10, height: 1.5, fontWeight: FontWeight.w400),
                    ),
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

class _RehberCompactCard extends StatelessWidget {
  final String baslik;
  final String kategori;
  final Timestamp? tarih;
  final String imagePath;
  final String contentPath;
  final String youtubeId;
  final String slug;

  const _RehberCompactCard({
    required this.baslik,
    required this.kategori,
    required this.tarih,
    required this.imagePath,
    required this.contentPath,
    required this.youtubeId,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    final tarihStr = tarih != null ? "${tarih!.toDate().day} ${_ayAdi(tarih!.toDate().month)} ${tarih!.toDate().year}" : "31 Ağustos 2026";
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE7E5E4))),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          context.push('/rehber/$slug');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imagePath,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 110, height: 110, color: Colors.grey.shade100, child: const Icon(Icons.broken_image)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📅 $tarihStr", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text(
                      baslik,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13.5, height: 1.35, color: Colors.black87),
                      maxLines: 4,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 10),
                    Text("Devamını oku →", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF2563EB))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _ayAdi(int ay) {
    const aylar = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
    return aylar[ay - 1];
  }
}
