import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileImageService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Galeriden veya Kameradan resim seçer
  Future<File?> resimSec(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 60, // Boyutu optimize etmek için
        maxWidth: 500,    // Gereksiz büyük resimleri küçültür
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      return null;
    }
  }

  // Resmi Firebase Storage'a yükler ve indirme linkini döndürür
  Future<String?> resimYukle(File imageFile) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      // Profil resimlerini 'profil_resimleri' klasöründe UID ismiyle saklar
      Reference ref = _storage.ref().child('profil_resimleri').child('$uid.jpg');

      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}