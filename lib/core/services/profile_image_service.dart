// lib/core/services/profile_image_service.dart

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // debugPrint için

class ProfileImageService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File?> resimSec(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 60,
        maxWidth: 500,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      debugPrint("Resim seçme hatası: $e");
      return null;
    }
  }

  Future<String?> resimYukle(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      String uid = user.uid;

      // OPTİMİZASYON: Yükleme işlemine metadata ekleyerek dosya tipini sabitledik
      // Bu sayede Storage tarafında dosya türü okuma hataları azalır.
      final ref = _storage.ref().child('profil_resimleri').child('$uid.jpg');

      final uploadTask = await ref.putFile(
          imageFile,
          SettableMetadata(contentType: 'image/jpeg')
      );

      if (uploadTask.state == TaskState.success) {
        return await ref.getDownloadURL();
      }

      return null;
    } catch (e) {
      debugPrint("Resim yükleme hatası: $e");
      return null;
    }
  }
}