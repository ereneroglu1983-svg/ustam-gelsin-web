// lib/core/services/location_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  static List<dynamic>? _cachedSehirler;
  static List<dynamic>? _cachedIlceler;

  static Future<List<dynamic>> loadSehirler() async {
    if (_cachedSehirler != null) return _cachedSehirler!;
    try {
      final String response = await rootBundle.loadString('assets/data/sehirler.json');
      _cachedSehirler = json.decode(response);
      return _cachedSehirler!;
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> loadIlceler(String sehirId) async {
    try {
      if (_cachedIlceler == null) {
        final String response = await rootBundle.loadString('assets/data/ilceler.json');
        _cachedIlceler = json.decode(response);
      }
      return _cachedIlceler!.where((ilce) =>
      ilce['sehir_id'].toString().trim() == sehirId.toString().trim()
      ).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, double>> getSehirKoordinat(String sehirAdi) async {
    try {
      List<Location> locations = await locationFromAddress("$sehirAdi, Türkiye");
      if (locations.isNotEmpty) {
        return {'lat': locations[0].latitude, 'lng': locations[0].longitude};
      }
    } catch (e) {
      debugPrint("Sehir koordinat hatası: $e");
    }
    return {'lat': 0.0, 'lng': 0.0};
  }

  static Future<Map<String, double>> getIlceKoordinat(String ilceAdi, String sehirAdi) async {
    try {
      List<Location> locations = await locationFromAddress("$ilceAdi, $sehirAdi, Türkiye");
      if (locations.isNotEmpty) {
        return {'lat': locations[0].latitude, 'lng': locations[0].longitude};
      }
    } catch (e) {
      debugPrint("İlçe koordinat hatası: $e");
    }
    return {'lat': 0.0, 'lng': 0.0};
  }

  static Future<String> getSehirIsim(String sehirId) async {
    if (sehirId == '0' || sehirId.isEmpty) return "İl Belirtilmemiş";
    try {
      final sehirler = await loadSehirler();
      final sehir = sehirler.firstWhere(
            (s) => s['sehir_id'].toString().trim() == sehirId.toString().trim(),
        orElse: () => null,
      );
      return sehir != null ? sehir['sehir_adi'] : "İl Bulunamadı ($sehirId)";
    } catch (e) {
      return "Hata: $sehirId";
    }
  }

  static Future<String> getIlceIsim(String ilceId) async {
    if (ilceId == '0' || ilceId.isEmpty) return "İlçe Belirtilmemiş";
    try {
      if (_cachedIlceler == null) {
        final String response = await rootBundle.loadString('assets/data/ilceler.json');
        _cachedIlceler = json.decode(response);
      }
      final ilce = _cachedIlceler!.firstWhere(
            (i) => i['ilce_id'].toString().trim() == ilceId.toString().trim(),
        orElse: () => null,
      );
      return ilce != null ? ilce['ilce_adi'] : "İlçe Bulunamadı ($ilceId)";
    } catch (e) {
      return "Hata: $ilceId";
    }
  }

  static Future<String?> getSehirIdByIsim(String sehirAdi) async {
    try {
      final sehirler = await loadSehirler();
      final sehir = sehirler.firstWhere(
            (s) => s['sehir_adi'].toString().toLowerCase().trim() == sehirAdi.toLowerCase().trim(),
        orElse: () => null,
      );
      return sehir != null ? sehir['sehir_id'].toString() : null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> loadMahalleler(String ilceId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('mahalleler_v2')
          .where('ilce_id', isEqualTo: ilceId)
          .get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> otomatikKonumTespitEt() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String bulunanSehirRaw = (place.administrativeArea ?? "").toLowerCase().trim();
          String bulunanIlceRaw = (place.subAdministrativeArea ?? "").toLowerCase().trim();

          final sehirler = await loadSehirler();
          if (sehirler.isEmpty) return null;

          var sehirObj = sehirler.firstWhere(
                (s) => (s['sehir_adi'] ?? "").toString().toLowerCase().trim().contains(bulunanSehirRaw) ||
                bulunanSehirRaw.contains((s['sehir_adi'] ?? "").toString().toLowerCase().trim()),
            orElse: () => null,
          );

          if (sehirObj != null) {
            String sehirId = (sehirObj['sehir_id'] ?? "").toString();
            String sehirAdi = (sehirObj['sehir_adi'] ?? "Bilinmiyor").toString();

            final ilceler = await loadIlceler(sehirId);
            var ilceObj = ilceler.isNotEmpty ? ilceler.firstWhere(
                  (i) => (i['ilce_adi'] ?? "").toString().toLowerCase().trim().contains(bulunanIlceRaw) ||
                  bulunanIlceRaw.contains((i['ilce_adi'] ?? "").toString().toLowerCase().trim()),
              orElse: () => null,
            ) : null;

            return {
              'sehir_adi': sehirAdi,
              'sehir_id': sehirId,
              'ilce_adi': ilceObj != null ? ilceObj['ilce_adi']?.toString() : null,
              'ilce_id': ilceObj != null ? ilceObj['ilce_id']?.toString() : null,
              'latitude': position.latitude,
              'longitude': position.longitude,
            };
          }
        }
      }
    } catch (e) {
      debugPrint("LocationService -> otomatikKonumTespitEt Hatası: $e");
    }
    return null;
  }
}