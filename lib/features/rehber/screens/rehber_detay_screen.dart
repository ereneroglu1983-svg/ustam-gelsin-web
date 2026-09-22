import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RehberDetayScreen extends StatelessWidget {
  final String slug;
  const RehberDetayScreen({super.key, required this.slug});

  String _fixR2Url(String url) {
    if (url.trim().isEmpty) return url;
    const cdnBase = 'https://cdn.hemenustamgelsin.com';
    const oldR2 = 'https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev';
    String fixed = url.replaceAll(oldR2, cdnBase);
    fixed = fixed.replaceAll('$cdnBase/ustam-gelsin-medya/', '$cdnBase/');
    fixed = fixed.replaceAll('/ustam-gelsin-medya/', '/');
    fixed = fixed.replaceAll('ustam-gelsin-medya/', '');
    if (fixed.startsWith('http')) return fixed;
    if (fixed.startsWith('images/')) return '$cdnBase/$fixed';
    if (fixed.startsWith('/')) return '$cdnBase$fixed';
    return fixed;
  }

  Future<DocumentSnapshot?> _getDoc() async {
    final q = await FirebaseFirestore.instance.collection('icerikler').where('slug', isEqualTo: slug).limit(1).get();
    if (q.docs.isNotEmpty) return q.docs.first;
    final doc = await FirebaseFirestore.instance.collection('icerikler').doc(slug).get();
    if (doc.exists) return doc;
    return null;
  }

  Future<String> _getContent(Map<String, dynamic> data) async {
    final direct = (data['icerik'] ?? data['content'] ?? data['aciklama'] ?? '').toString().trim();
    if (direct.isNotEmpty) return direct;

    final String cPath = _fixR2Url((data['contentPath'] ?? '').toString());
    if (cPath.isNotEmpty && cPath.startsWith('http')) {
      try {
        final res = await http.get(Uri.parse(cPath));
        if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) {
          return utf8.decode(res.bodyBytes);
        }
      } catch (e) {
        return "R2'den yazı çekilemedi: $e\nURL: $cPath";
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = slug.replaceAll('-', ' ');

    return FutureBuilder<DocumentSnapshot?>(
      future: _getDoc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(appBar: AppBar(title: Text(displayTitle)), body: const Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data == null || !snapshot.data!.exists) {
          return Scaffold(appBar: AppBar(title: Text(displayTitle)), body: const Center(child: Text("Rehber bulunamadı")));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final baslik = data['baslik'] ?? displayTitle;
        final imagePath = data['imagePath'] ?? '';
        final kategori = data['kategori'] ?? 'TADİLAT';

        return Title(
          title: "$baslik | Hemen Ustam Gelsin",
          color: Theme.of(context).primaryColor,
          child: Scaffold(
            backgroundColor: const Color(0xFFFFFBF5),
            appBar: AppBar(
              backgroundColor: const Color(0xFF0f2233),
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(baslik, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            body: FutureBuilder<String>(
              future: _getContent(data),
              builder: (context, contentSnap) {
                if (contentSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF0f2233)));
                }
                final icerik = contentSnap.data ?? "";
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imagePath.toString().isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(_fixR2Url(imagePath), fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => Container(height: 200, color: Colors.grey.shade200)),
                        ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFF6B00), borderRadius: BorderRadius.circular(6)),
                        child: Text(kategori.toString().toUpperCase(), style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(height: 12),
                      Text(baslik, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, height: 1.3)),
                      const SizedBox(height: 8),
                      Text("hemenustamgelsin.com/rehber/$slug", style: GoogleFonts.poppins(color: Colors.green, fontSize: 11)),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      SelectableText(
                        icerik.isEmpty ? "Yazı yok. Keys: ${data.keys.join(', ')}" : icerik,
                        style: GoogleFonts.poppins(fontSize: 14, height: 1.7, color: Colors.black87),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}