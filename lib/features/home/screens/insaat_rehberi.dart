import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
            // INAKTIF SEO CHIPLER - WEB ILE AYNI
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Tadilat Rehberi','Dekorasyon Fikirleri','Mutfak Tadilatı','Banyo Yenileme',
                  'Elektrik Tesisatı','Su Tesisatı','Boya Badana','Isı Yalıtım',
                  'Çatı Tamiri','Fayans Döşeme','Parke Döşeme','Alçıpan İşleri'
                ].map((k) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.grey.shade200)),
                  child: Text(k, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF57534E))),
                )).toList(),
              ),
            ),

            // REHBER LISTESI - KOMPAKT YATAY KARTLAR
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('icerikler').orderBy('tarih', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0f2233))));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Padding(padding: const EdgeInsets.all(24), child: Center(child: Text("Henüz içerik eklenmemiş.", style: GoogleFonts.poppins())));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return _RehberCompactCard(
                      baslik: data['baslik']?? 'Başlıksız',
                      kategori: data['kategori']?? 'TADİLAT',
                      tarih: data['tarih'] as Timestamp?,
                      imagePath: _fixUrl(data['imagePath']?? ''),
                      contentPath: _fixUrl(data['contentPath']?? ''),
                      youtubeId: data['youtubeId']?? '',
                      slug: data['slug']?? doc.id,
                    );
                  },
                );
              },
            ),

            // YENI KATILAN USTALAR - SABIT GRID - WEB ILE AYNI
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text("Yeni Katılan Ustalar", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('karisik_slider').orderBy('tarih', descending: true).limit(8).snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (context, i) {
                    final d = snap.data!.docs[i].data() as Map<String, dynamic>;
                    return Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(_fixUrl(d['imagePath']?? ''), fit: BoxFit.cover, errorBuilder: (_,__,___)=> Container(color: Colors.grey.shade100, child: const Icon(Icons.person))),
                            Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87])), child: Text(d['baslik']?? '', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis))),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
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
    final tarihStr = tarih!= null? "${tarih!.toDate().day} ${_ayAdi(tarih!.toDate().month)} ${tarih!.toDate().year}" : "12 Nisan 2025";
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE7E5E4))),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => RehberDetayScreen(baslik: baslik, contentUrl: contentPath, resimUrl: imagePath, youtubeId: youtubeId)));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(imagePath, width: 110, height: 82, fit: BoxFit.cover, errorBuilder: (_,__,___)=> Container(width: 110, height: 82, color: Colors.grey.shade100, child: const Icon(Icons.broken_image)))),
                  Positioned(top: 6, left: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFF6B00), borderRadius: BorderRadius.circular(4)), child: Text(kategori.toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)))),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📅 $tarihStr", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(baslik, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, height: 1.3, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
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
    const aylar = ["Ocak","Şubat","Mart","Nisan","Mayıs","Haziran","Temmuz","Ağustos","Eylül","Ekim","Kasım","Aralık"];
    return aylar[ay-1];
  }
}

// DETAY SAYFASI - ICERIK + YOUTUBE
class RehberDetayScreen extends StatefulWidget {
  final String baslik;
  final String contentUrl;
  final String resimUrl;
  final String youtubeId;
  const RehberDetayScreen({super.key, required this.baslik, required this.contentUrl, required this.resimUrl, required this.youtubeId});

  @override
  State<RehberDetayScreen> createState() => _RehberDetayScreenState();
}

class _RehberDetayScreenState extends State<RehberDetayScreen> {
  String _icerik = "";
  bool _loading = true;
  YoutubePlayerController? _ytController;

  @override
  void initState() {
    super.initState();
    _getir();
    if (widget.youtubeId.isNotEmpty) {
      _ytController = YoutubePlayerController.fromVideoId(videoId: widget.youtubeId, autoPlay: false, params: const YoutubePlayerParams(showControls: true, showFullscreenButton: true));
    }
  }

  Future<void> _getir() async {
    if (widget.contentUrl.isEmpty) { setState(() => _loading = false); return; }
    try {
      final r = await http.get(Uri.parse(widget.contentUrl));
      if (r.statusCode == 200) setState(() { _icerik = utf8.decode(r.bodyBytes); _loading = false; });
      else setState(() { _icerik = "İçerik yüklenemedi"; _loading = false; });
    } catch (_) { setState(() { _icerik = "Hata oluştu"; _loading = false; }); }
  }

  @override
  void dispose() { _ytController?.close(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text(widget.baslik, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)), iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(widget.resimUrl, width: double.infinity, fit: BoxFit.cover)),
            const SizedBox(height: 16),
            Text(widget.baslik, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            if (_loading) const Center(child: CircularProgressIndicator()) else Text(_icerik, style: GoogleFonts.poppins(fontSize: 14.5, height: 1.6)),
            if (_ytController!= null)...[const SizedBox(height: 24), ClipRRect(borderRadius: BorderRadius.circular(12), child: YoutubePlayer(controller: _ytController!, aspectRatio: 16/9))],
          ],
        ),
      ),
    );
  }
}