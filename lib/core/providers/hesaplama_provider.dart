// lib/core/providers/hesaplama_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/fiyat_hesaplama_robotu.dart';

class HesaplamaProvider extends ChangeNotifier {
  Map<String, dynamic>? _kategoriVerisi;
  double _sonuc = 0.0;
  bool _isLoading = false;

  double get sonuc => _sonuc;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get kategoriVerisi => _kategoriVerisi;

  /// Firebase'den kategoriyi yükle
  Future<void> kategoriYukle(String kategoriId) async {
    _isLoading = true;
    notifyListeners();

    var doc = await FirebaseFirestore.instance.collection('kategoriler').doc(kategoriId).get();
    if (doc.exists) {
      _kategoriVerisi = doc.data();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Hesaplama Robotunu tetikle
  void hesapla(Map<String, dynamic> secilenler, String sehir) {
    if (_kategoriVerisi == null) return;

    _sonuc = FiyatHesaplamaRobotu.hesapla(
      kategoriVerisi: _kategoriVerisi!,
      secilenler: secilenler,
      sehir: sehir,
    );
    notifyListeners();
  }
}