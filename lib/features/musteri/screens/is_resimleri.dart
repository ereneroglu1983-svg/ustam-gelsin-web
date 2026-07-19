import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ustam_gelsin/services/r2_service.dart';

class IsResimleri extends StatefulWidget {
  final Function(List<String>) onResimYuklendi;
  const IsResimleri({super.key, required this.onResimYuklendi});

  @override
  State<IsResimleri> createState() => _IsResimleriState();
}

class _IsResimleriState extends State<IsResimleri> {
  final R2Service _r2Service = R2Service();
  final ImagePicker _picker = ImagePicker();
  final List<String> _yuklenenUrlList = [];
  final List<File> _localFiles = []; // Önizleme için lokal
  bool _yukleniyor = false;

  Future<void> _resimSecVeYukle() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null) return;

    setState(() => _yukleniyor = true);
    final file = File(picked.path);
    final fileName = "ilanlar/${DateTime.now().millisecondsSinceEpoch}_${picked.name}";

    try {
      final url = await _r2Service.uploadFile(file, fileName);
      setState(() {
        _yuklenenUrlList.add(url);
        _localFiles.add(file);
      });
      widget.onResimYuklendi(_yuklenenUrlList);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Resminiz yüklendi (${_yuklenenUrlList.length})"), backgroundColor: const Color(0xFF2DB34A)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Yükleme hatası: $e"), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  Future<void> _resimSil(int index) async {
    final url = _yuklenenUrlList[index];
    try {
      await _r2Service.deleteFile(url);
    } catch (_) {}
    setState(() {
      _yuklenenUrlList.removeAt(index);
      _localFiles.removeAt(index);
    });
    widget.onResimYuklendi(_yuklenenUrlList);
  }

  void _resmiBuyut(File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            InteractiveViewer(child: Image.file(file, fit: BoxFit.contain)),
            Positioned(top: 10, right: 10, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _yukleniyor? null : _resimSecVeYukle,
            icon: _yukleniyor? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.add_a_photo_rounded),
            label: Text(_yukleniyor? "YÜKLENİYOR..." : "RESİM EKLE"),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2DB34A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
        if (_localFiles.isNotEmpty)...[
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _localFiles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemBuilder: (context, i) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => _resmiBuyut(_localFiles[i]),
                    child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(_localFiles[i], width: double.infinity, height: double.infinity, fit: BoxFit.cover)),
                  ),
                  Positioned(top: 4, right: 4, child: InkWell(onTap: () => _resimSil(i), child: Container(decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), padding: const EdgeInsets.all(4), child: const Icon(Icons.close, size: 14, color: Colors.white)))),
                  Positioned(bottom: 4, left: 4, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.zoom_in, size: 14, color: Colors.white))),
                ],
              );
            },
          ),
          const SizedBox(height: 6),
          Text("${_localFiles.length} resim yüklendi - Silmek için X'e, büyütmek için resme dokunun", style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ],
    );
  }
}