import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minio/minio.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:slugify/slugify.dart';

// lib/features/admin/screens/admin_reklam_board.dart
// Admin -> Reklam Board (HUG MARKET sag taraf icin)
// Sadece resim yuklenir, 5sn arayla reklam_board_slider.dart'ta doner
// Resim dosyasi HİÇBİR DEĞİŞİKLİK YAPILMADAN R2'ye yüklenir.

class AdminReklamBoardScreen extends StatefulWidget {
  const AdminReklamBoardScreen({super.key});
  @override
  State<AdminReklamBoardScreen> createState() => _AdminReklamBoardScreenState();
}

class _AdminReklamBoardScreenState extends State<AdminReklamBoardScreen> {
  final baslikController = TextEditingController(); // sadece adminde gormek icin isim
  final linkController = TextEditingController(); // tiklayinca gidecegi link (opsiyonel)
  final siraController = TextEditingController(text: "1");
  XFile? secilenResim;
  bool yukleniyor = false;
  bool aktif = true;

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

  String _contentTypeFromName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.bmp')) return 'image/bmp';
    if (lower.endsWith('.svg')) return 'image/svg+xml';
    return 'application/octet-stream';
  }

  /// Seçilen dosyayı HİÇBİR değişikliğe uğratmadan R2'ye yükler.
  /// Dosya adı, uzantı ve format aynen korunur.
  Future<String?> resimYukle() async {
    if (secilenResim == null) return null;

    final minio = _minioClient();
    final bytes = await secilenResim!.readAsBytes();

    // Orijinal dosya adını olduğu gibi kullan
    final orijinalDosyaAdi = secilenResim!.name;
    final yol = 'images/reklam_board/$orijinalDosyaAdi';
    final contentType = _contentTypeFromName(orijinalDosyaAdi);

    await minio.putObject(
      'ustam-gelsin-medya',
      yol,
      Stream.value(bytes),
      size: bytes.length,
      metadata: {'Content-Type': contentType},
    );

    return yol;
  }

  Future<void> reklamKaydet() async {
    if (secilenResim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resim secmek zorunlu kanka')),
      );
      return;
    }

    setState(() => yukleniyor = true);

    try {
      final rawBaslik = baslikController.text.trim().isEmpty
          ? 'reklam-${DateTime.now().millisecondsSinceEpoch}'
          : baslikController.text.trim();

      // Firestore document ID için slug kullanıyoruz (sadece doc id, dosya adı değil)
      final slug = slugify(rawBaslik, lowercase: true, delimiter: '-') +
          '-${DateTime.now().millisecondsSinceEpoch}';

      // Resmi olduğu gibi yükle (isim/uzantı/format değişmez)
      final imagePath = await resimYukle();
      if (imagePath == null) throw Exception('Resim yuklenemedi');

      await FirebaseFirestore.instance.collection('reklam_board').doc(slug).set({
        'baslik': rawBaslik,
        'slug': slug,
        'imagePath': imagePath,
        'imageUrl': 'https://cdn.hemenustamgelsin.com/$imagePath',
        'link': linkController.text.trim(),
        'sira': int.tryParse(siraController.text) ?? 0,
        'sure': 5,
        'aktif': aktif,
        'tarih': FieldValue.serverTimestamp(),
        'tiklama': 0,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('YAYINDA: $slug OK')),
      );
      baslikController.clear();
      linkController.clear();
      siraController.text = "1";
      setState(() => secilenResim = null);
    } catch (e, s) {
      print('❌ REKLAM HATA: $e $s');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), duration: const Duration(seconds: 5)),
        );
      }
    }

    if (mounted) setState(() => yukleniyor = false);
  }

  Future<void> toggleAktif(String docId, bool current) async {
    await FirebaseFirestore.instance
        .collection('reklam_board')
        .doc(docId)
        .update({'aktif': !current});
  }

  Future<void> silReklam(String docId, String imagePath) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Silinsin mi?'),
        content: const Text('Bu reklam board kaydi silinecek'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Iptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      // R2'den silmeyi istersen buraya ekle, simdilik sadece firestore siliyoruz
      await FirebaseFirestore.instance.collection('reklam_board').doc(docId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silindi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Silme hata: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reklam Board - Admin'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EKLEME FORMU
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  const Text(
                    'Yeni Reklam Ekle (Sadece Resim)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: baslikController,
                    decoration: const InputDecoration(
                      labelText: 'Reklam Adi (admin icin, orn: Marshall Banner)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(
                      labelText: 'Tiklayinca Gidecek Link (opsiyonel)',
                      hintText: '/kategori/boya veya https://...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: siraController,
                          decoration: const InputDecoration(
                            labelText: 'Sira (1 en ust)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Aktif'),
                          value: aktif,
                          onChanged: (v) => setState(() => aktif = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          // imageQuality KULLANILMIYOR → dosya olduğu gibi alınır
                          final r = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (r != null) setState(() => secilenResim = r);
                        },
                        icon: const Icon(Icons.image),
                        label: Text(
                          secilenResim == null ? 'Resim Sec' : 'Resim Secildi ✓',
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (secilenResim != null)
                        Expanded(
                          child: Text(
                            secilenResim!.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  yukleniyor
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: reklamKaydet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text(
                        'REKLAMI YAYINLA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Mevcut Reklamlar (5sn arayla doner)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reklam_board')
                  .orderBy('sira')
                  .orderBy('tarih', descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs;
                if (docs.isEmpty) return const Text('Henuz reklam yok');

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final d = docs[i].data() as Map<String, dynamic>;
                    final id = docs[i].id;
                    return Container(
                      decoration: BoxDecoration(
                        color: d['aktif'] == true
                            ? Colors.white
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            d['imageUrl'] ??
                                'https://cdn.hemenustamgelsin.com/${d['imagePath']}',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                          ),
                        ),
                        title: Text(
                          d['baslik'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: d['aktif'] == true
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        subtitle: Text(
                          'Sira: ${d['sira']} | Sure: ${d['sure']}sn | Link: ${d['link'] ?? '-'}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                d['aktif'] == true
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: d['aktif'] == true
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              onPressed: () =>
                                  toggleAktif(id, d['aktif'] == true),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  silReklam(id, d['imagePath'] ?? ''),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}