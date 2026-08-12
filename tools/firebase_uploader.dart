import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ustam_gelsin/firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final dir = Directory('lib/firebase_fiyatlar');
  final firestore = FirebaseFirestore.instance;

  int sayac = 0;
  final batch = firestore.batch();

  await for (var file in dir.list()) {
    if (file is File && file.path.endsWith('.json')) {
      final content = await file.readAsString();
      if (content.trim() == '{}' || content.trim().isEmpty) continue;

      final data = jsonDecode(content) as Map<String, dynamic>;
      final meslekId = file.uri.pathSegments.last.replaceAll('.json','');

      final ref = firestore.collection('meslek_fiyat_tarifeleri').doc(meslekId);
      batch.set(ref, data, SetOptions(merge: true));
      sayac++;
      print('✅ $meslekId hazır');
    }
  }
  await batch.commit();
  print('\n🎉 BİTTİ USTAM! $sayac meslek Firebase\'e basıldı!');
  print('Koleksiyon: meslek_fiyat_tarifeleri');
}