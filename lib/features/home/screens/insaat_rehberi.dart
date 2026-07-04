// lib/features/home/screens/insaat_rehberi.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsaatRehberiScreen extends StatelessWidget {
  const InsaatRehberiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String r2PublicUrl = "https://cdn.hemenustamgelsin.com/ustam-gelsin-medya";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "İnşaat Rehberi",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        elevation: 0.5,
        shadowColor: Colors.grey.shade200,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('icerikler').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Henüz içerik eklenmemiş.", style: GoogleFonts.poppins()));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              String baslik = data['baslik'] ?? 'Başlıksız';
              String imagePath = data['imagePath'] ?? '';
              String contentPath = data['contentPath'] ?? '';
              String youtubeId = data['youtubeId'] ?? '';
              String resimUrl = imagePath.startsWith('http') ? imagePath : "$r2PublicUrl/$imagePath";

              return RehberPostCard(
                baslik: baslik,
                contentUrl: contentPath.startsWith('http') ? contentPath : "$r2PublicUrl/$contentPath",
                resimUrl: resimUrl,
                youtubeId: youtubeId,
              );
            },
          );
        },
      ),
    );
  }
}

class RehberPostCard extends StatefulWidget {
  final String baslik;
  final String contentUrl;
  final String resimUrl;
  final String youtubeId;

  const RehberPostCard({
    super.key,
    required this.baslik,
    required this.contentUrl,
    required this.resimUrl,
    required this.youtubeId,
  });

  @override
  State<RehberPostCard> createState() => _RehberPostCardState();
}

class _RehberPostCardState extends State<RehberPostCard> {
  bool _isExpanded = false;
  String _icerikMetni = "";
  bool _isLoading = true;
  YoutubePlayerController? _ytController;

  @override
  void initState() {
    super.initState();
    _icerigiGetir();

    if (widget.youtubeId.isNotEmpty) {
      _ytController = YoutubePlayerController.fromVideoId(
        videoId: widget.youtubeId,
        autoPlay: false,
        params: const YoutubePlayerParams(showControls: true, showFullscreenButton: true),
      );
    }
  }

  @override
  void dispose() {
    _ytController?.close();
    super.dispose();
  }

  Future<void> _icerigiGetir() async {
    if (widget.contentUrl.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final response = await http.get(Uri.parse(widget.contentUrl));
      if (response.statusCode == 200) {
        if (mounted) setState(() {
          _icerikMetni = utf8.decode(response.bodyBytes);
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() { _icerikMetni = "İçerik yüklenemedi."; _isLoading = false; });
      }
    } catch (e) {
      if (mounted) setState(() { _icerikMetni = "Hata oluştu."; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ÜST BİLGİ
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade400, Colors.orange.shade400],
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFF1A237E),
                          child: Icon(Icons.article, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "hemenustamgelsin",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Icon(Icons.more_horiz, size: 22),
                  ],
                ),
              ),

              // BAŞLIK
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.baslik,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // RESİM
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 520),
                child: Image.network(
                  widget.resimUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Container(
                    height: 300,
                    color: Colors.grey[100],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),

              // İÇERİK METNİ
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _isLoading
                    ? const Text("Yükleniyor...", style: TextStyle(color: Colors.grey, fontSize: 14))
                    : InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: RichText(
                    maxLines: _isExpanded ? null : 4,
                    overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    text: TextSpan(
                      style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14.5, height: 1.45),
                      children: [
                        TextSpan(text: _icerikMetni),
                      ],
                    ),
                  ),
                ),
              ),

              // DEVAMINI GÖR
              if (!_isExpanded && _icerikMetni.length > 120)
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _isExpanded = true),
                    child: Text(
                      "devamını gör",
                      style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),

              // YOUTUBE VİDEO
              if (_isExpanded && widget.youtubeId.isNotEmpty && _ytController != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: YoutubePlayer(controller: _ytController!, aspectRatio: 16 / 9),
                  ),
                ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}