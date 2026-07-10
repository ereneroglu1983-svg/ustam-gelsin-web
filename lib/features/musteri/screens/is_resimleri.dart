import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:ustam_gelsin/services/r2_service.dart'; // SENİN PATH'İN BU
import 'package:permission_handler/permission_handler.dart';

class IsResimleri extends StatefulWidget {
  final String? ilanId;
  final Function(List<String>) onResimYuklendi;
  final int maxResimSayisi;

  const IsResimleri({
    super.key,
    this.ilanId,
    required this.onResimYuklendi,
    this.maxResimSayisi = 5,
  });

  @override
  State<IsResimleri> createState() => _IsResimleriState();
}

class _IsResimleriState extends State<IsResimleri> {
  final R2Service _r2Service = R2Service();
  final String _tempId = const Uuid().v4();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  List<String> _uploadedImageUrls = [];

  Future<void> _checkPermissionsAndPick(ImageSource source) async {
    if (_uploadedImageUrls.length >= widget.maxResimSayisi) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("En fazla ${widget.maxResimSayisi} resim ekleyebilirsin")),
        );
      }
      return;
    }

    Permission permission = (source == ImageSource.camera) ? Permission.camera : Permission.photos;
    var status = await permission.request();

    if (status.isGranted) {
      _pickAndUploadImage(source);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kamera veya galeri izni reddedildi")),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF203A43),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white70),
              title: const Text("Galeriden Seç", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _checkPermissionsAndPick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white70),
              title: const Text("Kamera ile Çek", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _checkPermissionsAndPick(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1080,
      imageQuality: 85,
    );
    if (pickedFile == null) return;

    setState(() => _isLoading = true);

    try {
      // SENİN R2Service 2 parametre alıyor: File ve fileName
      // folder yapısını fileName içine gömüyoruz
      final String folder = widget.ilanId != null ? "ilanlar/${widget.ilanId}" : "temp/$_tempId";
      final String fileName = "$folder/img_${DateTime.now().millisecondsSinceEpoch}.jpg";

      String url = await _r2Service.uploadFile(File(pickedFile.path), fileName);

      if (!mounted) return;
      setState(() {
        _uploadedImageUrls.add(url);
      });

      widget.onResimYuklendi(_uploadedImageUrls);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Resim başarıyla yüklendi"),
            backgroundColor: Color(0xFF2DB34A),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDelete(String url) async {
    setState(() => _isLoading = true);
    try {
      await _r2Service.deleteFile(url);
      if (!mounted) return;
      setState(() {
        _uploadedImageUrls.remove(url);
      });
      widget.onResimYuklendi(_uploadedImageUrls);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Silme hatası: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_uploadedImageUrls.isNotEmpty) ...[
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _uploadedImageUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = _uploadedImageUrls[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 90,
                              height: 90,
                              color: Colors.white10,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF2DB34A),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stack) => Container(
                            width: 90,
                            height: 90,
                            color: Colors.white10,
                            child: const Icon(Icons.error, color: Colors.redAccent),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _handleDelete(imageUrl),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoading || _uploadedImageUrls.length >= widget.maxResimSayisi
                ? null
                : _showImageSourceDialog,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            icon: _isLoading
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
            )
                : const Icon(Icons.add_photo_alternate_outlined),
            label: Text(_uploadedImageUrls.isEmpty
                ? "Resim Ekle"
                : "${_uploadedImageUrls.length}/${widget.maxResimSayisi} Resim Eklendi"),
          ),
        ),
      ],
    );
  }
}