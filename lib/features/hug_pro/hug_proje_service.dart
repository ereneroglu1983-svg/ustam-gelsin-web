import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'hug_proje_olustur.dart' as brief;
import '../../services/r2_service.dart';

class HugProjeService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _r2 = R2Service();

  Future<List<String>> uploadFotolar(List<XFile> fotolar, String projeId) async {
    List<String> urls = [];
    for (int i = 0; i < fotolar.length; i++) {
      final xfile = fotolar[i];
      final String fileName = 'foto_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String folder = 'hug_projects/$projeId';
      final String fullPath = '$folder/$fileName';
      try {
        String url;
        if (kIsWeb) {
          final bytes = await xfile.readAsBytes();
          url = await _r2.uploadBytes(bytes, fullPath);
        } else {
          final file = io.File(xfile.path);
          url = await _r2.uploadFile(file, folder, fileName);
        }
        urls.add(url);
      } catch (e) {
        print('Foto $i yüklenemedi: $e');
      }
    }
    return urls;
  }

  Future<String> createProje({
    required String yapiTuruId,
    required brief.ProjeAsamasi asama,
    required Map<String, String> olcek,
    required List<String> ihtiyacIds,
    required String il,
    required String ilce,
    required String aciklama,
    required List<XFile> fotolar,
    Map<String, dynamic>? detaylar, // YENİ - GROK için kritik detaylar (optional)
    String? sablonBaslik, // YENİ - şablon başlığı (optional)
  }) async {
    final user = _auth.currentUser;
    final docRef = _db.collection('hug_projects').doc();

    List<String> fotoUrls = [];
    if (fotolar.isNotEmpty) {
      fotoUrls = await uploadFotolar(fotolar, docRef.id);
    }

    await docRef.set({
      'yapiTuruId': yapiTuruId,
      'yapiTuruDisplay': yapiTuruId.replaceAll('_', ' / '),
      'asama': asama.name,
      'asamaDisplay': asama.displayName,
      'olcek': olcek,
      'olcekBirimli': olcek.map((k, v) {
        String birim = k == 'kat' ? 'kat' : k == 'guc' ? 'kWp' : 'm²';
        return MapEntry(k, '$v $birim');
      }),
      'detaylar': detaylar ?? {}, // YENİ - GROK maliyet hesabı için
      'sablonBaslik': sablonBaslik ?? '', // YENİ
      'ihtiyacIds': ihtiyacIds,
      'konum': {'il': il, 'ilce': ilce},
      'aciklama': aciklama,
      'fotoUrls': fotoUrls,
      'userId': user?.uid ?? 'anonim',
      'status': 'PROFESYONEL_ARANIYOR',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }
}
