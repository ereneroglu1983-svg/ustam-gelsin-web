import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minio/minio.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:slugify/slugify.dart';

// lib/features/admin/screens/admin_reklam_board.dart
// Admin -> Reklam Board (HUG MARKET sag taraf icin) - FINAL
// Sadece resim, 5sn arayla reklam_board_slider.dart'ta doner

class AdminReklamBoardScreen extends StatefulWidget {
  const AdminReklamBoardScreen({super.key});
  @override State<AdminReklamBoardScreen> createState() => _AdminReklamBoardScreenState();
}

class _AdminReklamBoardScreenState extends State<AdminReklamBoardScreen> {
  final baslikController = TextEditingController();
  final linkController = TextEditingController();
  final siraController = TextEditingController(text: "1");
  XFile? secilenResim;
  bool yukleniyor = false;
  bool aktif = true;

  Minio _minioClient() {
    final endpoint = Env.r2FlutterEndpoint;
    final host = endpoint.replaceAll('https://', '').replaceAll('http://', '').split('/').first.trim();
    return Minio(endPoint: host, accessKey: Env.r2FlutterAccessKey, secretKey: Env.r2FlutterSecretKey, useSSL: true, region: 'auto');
  }

  Future<String?> resimYukle(String baseSlug, int ts) async {
    if (secilenResim == null) return null;
    final minio = _minioClient();
    final bytes = await secilenResim!.readAsBytes();
    final dosyaAdi = '$baseSlug-$ts.webp'; // SADECE 1 TANE TIMESTAMP
    final yol = 'images/reklam_board/$dosyaAdi';
    await minio.putObject('ustam-gelsin-medya', yol, Stream.value(bytes), size: bytes.length, metadata: {'Content-Type': 'image/webp'});
    return yol;
  }

  Future<void> reklamKaydet() async {
    if (secilenResim == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resim secmek zorunlu kanka')));
      return;
    }
    setState(() => yukleniyor = true);
    try {
      final ts = DateTime.now().millisecondsSinceEpoch; // SADECE 1 KERE
      final rawBaslik = baslikController.text.trim().isEmpty? 'reklam' : baslikController.text.trim();
      final baseSlug = slugify(rawBaslik, lowercase: true, delimiter: '-');
      final slug = '$baseSlug-$ts'; // TEK ID
      final imagePath = await resimYukle(baseSlug, ts);
      if (imagePath == null) throw Exception('Resim yuklenemedi');

      await FirebaseFirestore.instance.collection('reklam_board').doc(slug).set({
        'baslik': rawBaslik,
        'slug': slug,
        'imagePath': imagePath,
        'imageUrl': 'https://cdn.hemenustamgelsin.com/$imagePath',
        'link': linkController.text.trim(),
        'sira': int.tryParse(siraController.text)?? 0,
        'order': int.tryParse(siraController.text)?? 0,
        'sure': 5,
        'aktif': aktif,
        'isActive': aktif,
        'tarih': FieldValue.serverTimestamp(),
        'tiklama': 0,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('YAYINDA: $slug OK')));
      baslikController.clear();
      linkController.clear();
      siraController.text = "1";
      setState(() => secilenResim = null);
    } catch (e, s) {
      print('❌ REKLAM HATA: $e $s');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), duration: const Duration(seconds: 5)));
    }
    if (mounted) setState(() => yukleniyor = false);
  }

  Future<void> toggleAktif(String docId, bool current) async {
    await FirebaseFirestore.instance.collection('reklam_board').doc(docId).update({'aktif':!current, 'isActive':!current});
  }

  Future<void> silReklam(String docId) async {
    final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Silinsin mi?'), content: const Text('Bu reklam silinecek'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Iptal')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil'))]));
    if (confirm!= true) return;
    await FirebaseFirestore.instance.collection('reklam_board').doc(docId).delete();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silindi')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reklam Board - Admin'), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)), child: Column(children: [
          const Text('Yeni Reklam Ekle (Sadece Resim)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          TextField(controller: baslikController, decoration: const InputDecoration(labelText: 'Reklam Adi (admin icin)', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: linkController, decoration: const InputDecoration(labelText: 'Tiklayinca Gidecek Link (opsiyonel)', hintText: '/kategori/boya veya https://...', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: siraController, decoration: const InputDecoration(labelText: 'Sira', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: SwitchListTile(title: const Text('Aktif'), value: aktif, onChanged: (v) => setState(() => aktif = v))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton.icon(onPressed: () async { final r = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85); if (r!= null) setState(() => secilenResim = r); }, icon: const Icon(Icons.image), label: Text(secilenResim == null? 'Resim Sec' : 'Resim Secildi ✓')),
            const SizedBox(width: 12),
            if (secilenResim!= null) Expanded(child: Text(secilenResim!.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))),
          ]),
          const SizedBox(height: 16),
          yukleniyor? const CircularProgressIndicator() : SizedBox(width: double.infinity, child: ElevatedButton(onPressed: reklamKaydet, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 48)), child: const Text('REKLAMI YAYINLA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
        ])),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 12),
        const Text('Mevcut Reklamlar (5sn arayla doner)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('reklam_board').orderBy('sira').snapshots(), builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Text('Henuz reklam yok');
          return ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: docs.length, separatorBuilder: (_, __) => const SizedBox(height: 8), itemBuilder: (context, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final id = docs[i].id;
            return Container(decoration: BoxDecoration(color: d['aktif'] == true? Colors.white : Colors.grey.shade200, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)), child: ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(d['imageUrl']?? 'https://cdn.hemenustamgelsin.com/${d['imagePath']}', width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))),
              title: Text(d['baslik']?? '', style: TextStyle(fontWeight: FontWeight.bold, color: d['aktif'] == true? Colors.black : Colors.grey)),
              subtitle: Text('Sira: ${d['sira']} | Link: ${d['link']?? '-'}'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: Icon(d['aktif'] == true? Icons.visibility : Icons.visibility_off, color: d['aktif'] == true? Colors.green : Colors.grey), onPressed: () => toggleAktif(id, d['aktif'] == true)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => silReklam(id)),
              ]),
            ));
          });
        }),
      ])),
    );
  }
}