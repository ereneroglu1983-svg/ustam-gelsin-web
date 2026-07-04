import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minio/minio.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:slugify/slugify.dart';
import 'dart:typed_data';
import 'dart:convert';

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

  // R2'ye resim yükle (YÜKLEME İÇİN S3 API)
  Future<String?> resimYukle() async {
    if (secilenResim == null) return null;

    final minio = Minio(
      endPoint: 'ustam-gelsin-medya.${Env.r2FlutterEndpoint.replaceAll('https://', '')}',
      accessKey: Env.r2FlutterAccessKey,
      secretKey: Env.r2FlutterSecretKey,
      useSSL: true,
      region: 'auto',
    );

    final bytes = await secilenResim!.readAsBytes();
    final dosyaAdi = '${slugify(baslikController.text)}-${DateTime.now().millisecondsSinceEpoch}.webp';
    final yol = 'images/$dosyaAdi';

    await minio.putObject(
      'ustam-gelsin-medya',
      yol,
      Stream.value(bytes),
      metadata: {'Content-Type': 'image/webp'},
    );

    return yol; // SADECE PATH DÖN
  }

  // R2'ye metin yükle (YÜKLEME İÇİN S3 API)
  Future<String?> metinYukle() async {
    final minio = Minio(
      endPoint: 'ustam-gelsin-medya.${Env.r2FlutterEndpoint.replaceAll('https://', '')}',
      accessKey: Env.r2FlutterAccessKey,
      secretKey: Env.r2FlutterSecretKey,
      useSSL: true,
      region: 'auto',
    );

    final bytes = utf8.encode(icerikController.text);
    final dosyaAdi = '${slugify(baslikController.text)}-${DateTime.now().millisecondsSinceEpoch}.txt';
    final yol = 'posts/$dosyaAdi';

    await minio.putObject(
      'ustam-gelsin-medya',
      yol,
      Stream.value(bytes),
      metadata: {'Content-Type': 'text/plain'},
    );

    return yol; // SADECE PATH DÖN
  }

  // Firebase'e kaydet
  Future<void> blogKaydet() async {
    if (baslikController.text.isEmpty || secilenResim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlık ve resim zorunlu kanka')),
      );
      return;
    }

    setState(() => yukleniyor = true);

    try {
      final imagePath = await resimYukle();
      final contentPath = await metinYukle();
      final slug = slugify(baslikController.text);

      // DÜZELTİLDİ: Firestore'a sadece path yazıyoruz, tam URL değil
      await FirebaseFirestore.instance.collection('icerikler').doc(slug).set({
        'baslik': baslikController.text,
        'imagePath': imagePath, // SADECE PATH: images/dosya.webp
        'contentPath': contentPath, // SADECE PATH: posts/dosya.txt
        'youtubeId': youtubeController.text,
        'kategori': 'Tadilat',
        'tarih': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('YAYINDA: $slug')),
      );

      baslikController.clear();
      youtubeController.clear();
      icerikController.clear();
      setState(() => secilenResim = null);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }

    setState(() => yukleniyor = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rehber Ekle - Admin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: baslikController,
              decoration: const InputDecoration(labelText: 'Blog Başlığı'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final resim = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (resim != null) setState(() => secilenResim = resim);
              },
              child: Text(secilenResim == null ? 'Kapak Resmi Seç' : 'Resim Seçildi ✓'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: youtubeController,
              decoration: const InputDecoration(labelText: 'YouTube Video ID (opsiyonel)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: icerikController,
              decoration: const InputDecoration(labelText: 'Blog İçeriği'),
              maxLines: 10,
            ),
            const SizedBox(height: 24),
            yukleniyor
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: blogKaydet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('YAYINLA', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}