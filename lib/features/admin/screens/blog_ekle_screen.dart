import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minio/minio.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:slugify/slugify.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogEkleScreen extends StatefulWidget {
  const BlogEkleScreen({super.key});

  @override
  State<BlogEkleScreen> createState() => _BlogEkleScreenState();
}

class _BlogEkleScreenState extends State<BlogEkleScreen> {
  final baslikController = TextEditingController();
  final youtubeController = TextEditingController();
  final icerikController = TextEditingController();
  XFile? secilenResim;
  bool yukleniyor = false;
  bool isUstaPosteri = false;

  Minio _minioClient() {
    final endpoint = Env.r2FlutterEndpoint;
    final host = endpoint.replaceAll('https://', '').replaceAll('http://', '').split('/').first.trim();
    return Minio(
      endPoint: host,
      accessKey: Env.r2FlutterAccessKey,
      secretKey: Env.r2FlutterSecretKey,
      useSSL: true,
      region: 'auto',
    );
  }

  Future<String?> resimYukle(String slug, int ts) async {
    if (secilenResim == null) return null;
    final minio = _minioClient();
    final bytes = await secilenResim!.readAsBytes();
    final dosyaAdi = '$slug-$ts.webp';
    final yol = isUstaPosteri ? 'images/ustalar/$dosyaAdi' : 'images/$dosyaAdi';
    await minio.putObject(
      'ustam-gelsin-medya',
      yol,
      Stream.value(bytes),
      size: bytes.length,
      metadata: {'Content-Type': 'image/webp'},
    );
    return yol;
  }

  Future<String?> metinYukle(String slug, int ts) async {
    if (icerikController.text.trim().isEmpty) return null;
    final minio = _minioClient();
    final bytes = Uint8List.fromList(utf8.encode(icerikController.text.trim()));
    final dosyaAdi = '$slug-$ts.txt';
    final yol = 'posts/$dosyaAdi';
    await minio.putObject(
      'ustam-gelsin-medya',
      yol,
      Stream.value(bytes),
      size: bytes.length,
      metadata: {'Content-Type': 'text/plain; charset=utf-8'},
    );
    return yol;
  }

  Future<void> blogKaydet() async {
    if (baslikController.text.isEmpty || secilenResim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlık ve resim zorunlu kanka')),
      );
      return;
    }
    if (!isUstaPosteri && icerikController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İçerik boş olamaz!')),
      );
      return;
    }

    setState(() => yukleniyor = true);

    try {
      final slug = slugify(baslikController.text, lowercase: true, delimiter: '-');
      final ts = DateTime.now().millisecondsSinceEpoch;
      final imagePath = await resimYukle(slug, ts);

      if (isUstaPosteri) {
        await FirebaseFirestore.instance.collection('karisik_slider').doc(slug).set({
          'baslik': baslikController.text.trim(),
          'slug': slug,
          'imagePath': imagePath,
          'tarih': FieldValue.serverTimestamp(),
        });
      } else {
        final contentPath = await metinYukle(slug, ts);
        if (contentPath == null) throw Exception('Metin R2\'ye yüklenemedi!');

        final data = {
          'baslik': baslikController.text.trim(),
          'slug': slug,
          'imagePath': imagePath,
          'contentPath': contentPath,
          'tarih': FieldValue.serverTimestamp(),
          'seoUrl': '/rehber/$slug',
        };

        if (youtubeController.text.trim().isNotEmpty) {
          data['youtubeId'] = youtubeController.text.trim();
        }

        await FirebaseFirestore.instance.collection('icerikler').doc(slug).set(data);

        try {
          await http.post(
            Uri.parse('https://hemenustamgelsin.com/api/revalidate'),
            headers: {
              'Content-Type': 'application/json',
              'x-secret-key': 'hemenustamgelsin-super-gizli-123',
            },
            body: jsonEncode({'slug': slug}),
          );
        } catch (_) {}
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('YAYINDA: $slug OK')),
      );

      baslikController.clear();
      youtubeController.clear();
      icerikController.clear();
      setState(() => secilenResim = null);
    } catch (e, stack) {
      print('❌ HATA: $e');
      print(stack);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e'), duration: Duration(seconds: 5)),
      );
    }

    if (mounted) {
      setState(() => yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isUstaPosteri ? 'Usta Posteri Ekle' : 'Rehber Ekle - Admin FIXLENDİ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(isUstaPosteri ? 'Mod: USTA POSTERİ (Yazısız)' : 'Mod: İNŞAAT REHBERİ (Yazılı)'),
              subtitle: Text(isUstaPosteri ? 'Sadece resim yüklenecek' : 'Resim + Yazı yüklenecek'),
              value: isUstaPosteri,
              onChanged: (v) => setState(() => isUstaPosteri = v),
            ),
            const SizedBox(height: 16),
            TextField(controller: baslikController, decoration: InputDecoration(labelText: isUstaPosteri ? 'Usta Adı (örn: Ahmet Usta - Boyacı)' : 'Blog Başlığı')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final resim = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (resim != null) setState(() => secilenResim = resim);
              },
              child: Text(secilenResim == null ? 'Kapak Resmi / Poster Seç' : 'Resim Seçildi ✓'),
            ),
            const SizedBox(height: 16),
            if (!isUstaPosteri) ...[
              TextField(controller: youtubeController, decoration: const InputDecoration(labelText: 'YouTube Video ID (opsiyonel)')),
              const SizedBox(height: 16),
              TextField(controller: icerikController, decoration: const InputDecoration(labelText: 'Blog İçeriği'), maxLines: 10),
              const SizedBox(height: 24),
            ],
            yukleniyor
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: blogKaydet,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)),
              child: Text(isUstaPosteri ? 'USTA POSTERİNİ YAYINLA' : 'REHBERİ YAYINLA', style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}