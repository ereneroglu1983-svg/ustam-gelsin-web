// lib/core/repositories/address_repository.dart

import 'dart:convert';
import 'package:flutter/services.dart';

class AddressRepository {
  List<dynamic> _sehirListesi = [];
  List<dynamic> _ilceListesi = [];

  List<dynamic> get sehirListesi => _sehirListesi;

  /// JSON dosyalarını yükler ve hafızaya alır
  Future<void> verileriYukle() async {
    final String sehirData = await rootBundle.loadString('assets/data/sehirler.json');
    final String ilceData = await rootBundle.loadString('assets/data/ilceler.json');
    _sehirListesi = json.decode(sehirData);
    _ilceListesi = json.decode(ilceData);
  }

  /// Seçilen şehre ait ilçeleri filtreleyip harita listesi olarak döner
  List<Map<String, String>> ilceleriFiltrele(String sehirAdi) {
    return _ilceListesi
        .where((i) => i['sehir_adi'].toString() == sehirAdi)
        .map((e) => {
      'ad': e['ilce_adi'].toString(),
      'id': e['ilce_id'].toString(),
    })
        .toList();
  }

  /// GPS'ten gelen ham kelimelere göre eşleşen şehri bulur
  Map<String, dynamic>? hamKelimeIleSehirBul(String hamSehir) {
    for (var s in _sehirListesi) {
      String sehirAdi = s['sehir_adi'].toString().toLowerCase().trim();
      if (sehirAdi.contains(hamSehir) || hamSehir.contains(sehirAdi)) {
        return s as Map<String, dynamic>;
      }
    }
    return null;
  }
}