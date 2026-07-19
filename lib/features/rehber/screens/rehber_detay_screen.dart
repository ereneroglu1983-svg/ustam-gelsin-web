import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
// dart:js'i SİLDİK, yerine güvenli yöntem
import 'package:web/web.dart' as web;

class RehberDetayScreen extends StatelessWidget {
  final String slug;
  const RehberDetayScreen({super.key, required this.slug});

  String _fixR2Url(String url) {
    const cdnBase = 'https://cdn.hemenustamgelsin.com/ustam-gelsin-medya';
    if (url.startsWith('http')) {
      return url.replaceAll('https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev', cdnBase);
    }
    if (url.startsWith('images/')) return '$cdnBase/$url';
    return url;
  }

  void _setTitle(String title) {
    if (kIsWeb) {
      web.document.title = "$title | Hemen Ustam Gelsin";
    }
  }

  @override
  Widget build(BuildContext context) {
    _setTitle(slug.replaceAll('-', ' '));

    return Scaffold(
      appBar: AppBar(title: Text(slug)),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('icerikler').doc(slug).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (!snapshot.data!.exists) return const Center(child: Text("Rehber bulunamadı"));

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final baslik = data['baslik'] ?? slug;
          final imagePath = data['imagePath'] ?? '';

          _setTitle(baslik);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_fixR2Url(imagePath), fit: BoxFit.contain),
                  ),
                const SizedBox(height: 16),
                Text(baslik, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text("URL: hemenustamgelsin.com/rehber/$slug", style: const TextStyle(color: Colors.green)),
              ],
            ),
          );
        },
      ),
    );
  }
}