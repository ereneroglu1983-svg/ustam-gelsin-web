import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class RehberDetayScreen extends StatelessWidget {
  final String slug;
  const RehberDetayScreen({super.key, required this.slug});

  String _fixR2Url(String url) {
    const cdnBase = 'https://cdn.hemenustamgelsin.com/ustam-gelsin-medya';
    if (url.startsWith('http')) {
      return url.replaceAll(
          'https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev', cdnBase);
    }
    if (url.startsWith('images/')) return '$cdnBase/$url';
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = slug.replaceAll('-', ' ');

    return FutureBuilder<DocumentSnapshot>(
      future:
      FirebaseFirestore.instance.collection('icerikler').doc(slug).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text(displayTitle)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text(displayTitle)),
            body: const Center(child: Text("Rehber bulunamadı")),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final baslik = data['baslik'] ?? displayTitle;
        final imagePath = data['imagePath'] ?? '';

        // WEB'DE SEO TITLE, APP'TE ETKİSİ YOK - import gerektirmez
        return Title(
          title: "$baslik | Hemen Ustam Gelsin",
          color: Theme.of(context).primaryColor,
          child: Scaffold(
            appBar: AppBar(title: Text(baslik)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imagePath.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(_fixR2Url(imagePath),
                          fit: BoxFit.contain),
                    ),
                  const SizedBox(height: 16),
                  Text(baslik,
                      style: GoogleFonts.poppins(
                          fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text("URL: hemenustamgelsin.com/rehber/$slug",
                      style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}