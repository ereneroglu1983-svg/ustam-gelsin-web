// lib/core/models/ilan_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class IlanModel {
  final String id;
  final String baslik;
  final String kategoriId;
  final String kategori;
  final String durum;
  final String tarih;
  final String userId;
  final String fiyatBilgisi;
  final String detaylar;
  final String musteriAd;
  final String maskeliAd;
  final String musteriTelefon;
  final String konumMetin;
  final String acikAdres;
  final String ilId;
  final String ilceId;
  final String ilanCode;
  final String isTanimi;
  final double komisyonTutari;
  final bool komisyonOdendiMi;
  final bool isAcil;
  final String? metreKare;
  final String? odaSayisi;
  final String? hizmetTipi;
  final Map<String, dynamic> teknikDetaylar;
  final double latitude;
  final double longitude;
  final String? musteriAdSoyad;
  final String? sehirIlceMetni;

  IlanModel({
    required this.id,
    required this.baslik,
    required this.kategoriId,
    this.kategori = '',
    required this.durum,
    required this.tarih,
    required this.userId,
    required this.fiyatBilgisi,
    required this.detaylar,
    this.musteriAd = '',
    this.maskeliAd = '',
    this.musteriTelefon = '',
    this.konumMetin = '',
    this.acikAdres = '',
    this.ilId = '',
    this.ilceId = '',
    this.ilanCode = '',
    this.isTanimi = '',
    this.komisyonTutari = 0.0,
    this.komisyonOdendiMi = false,
    this.isAcil = false,
    this.metreKare,
    this.odaSayisi,
    this.hizmetTipi,
    this.teknikDetaylar = const {},
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.musteriAdSoyad,
    this.sehirIlceMetni,
  });

  IlanModel copyWith({
    String? id,
    String? baslik,
    String? kategoriId,
    String? kategori,
    String? durum,
    String? tarih,
    String? userId,
    String? fiyatBilgisi,
    String? detaylar,
    String? musteriAd,
    String? maskeliAd,
    String? musteriTelefon,
    String? konumMetin,
    String? acikAdres,
    String? ilId,
    String? ilceId,
    String? ilanCode,
    String? isTanimi,
    double? komisyonTutari,
    bool? komisyonOdendiMi,
    bool? isAcil,
    String? metreKare,
    String? odaSayisi,
    String? hizmetTipi,
    Map<String, dynamic>? teknikDetaylar,
    double? latitude,
    double? longitude,
    String? musteriAdSoyad,
    String? sehirIlceMetni,
  }) {
    return IlanModel(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      kategoriId: kategoriId ?? this.kategoriId,
      kategori: kategori ?? this.kategori,
      durum: durum ?? this.durum,
      tarih: tarih ?? this.tarih,
      userId: userId ?? this.userId,
      fiyatBilgisi: fiyatBilgisi ?? this.fiyatBilgisi,
      detaylar: detaylar ?? this.detaylar,
      musteriAd: musteriAd ?? this.musteriAd,
      maskeliAd: maskeliAd ?? this.maskeliAd,
      musteriTelefon: musteriTelefon ?? this.musteriTelefon,
      konumMetin: konumMetin ?? this.konumMetin,
      acikAdres: acikAdres ?? this.acikAdres,
      ilId: ilId ?? this.ilId,
      ilceId: ilceId ?? this.ilceId,
      ilanCode: ilanCode ?? this.ilanCode,
      isTanimi: isTanimi ?? this.isTanimi,
      komisyonTutari: komisyonTutari ?? this.komisyonTutari,
      komisyonOdendiMi: komisyonOdendiMi ?? this.komisyonOdendiMi,
      isAcil: isAcil ?? this.isAcil,
      metreKare: metreKare ?? this.metreKare,
      odaSayisi: odaSayisi ?? this.odaSayisi,
      hizmetTipi: hizmetTipi ?? this.hizmetTipi,
      teknikDetaylar: teknikDetaylar ?? this.teknikDetaylar,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      musteriAdSoyad: musteriAdSoyad ?? this.musteriAdSoyad,
      sehirIlceMetni: sehirIlceMetni ?? this.sehirIlceMetni,
    );
  }

  static String _maskele(String adSoyad) {
    if (adSoyad.isEmpty) return "Müşteri";
    List<String> parcalar = adSoyad.trim().split(" ");
    if (parcalar.length > 1) {
      String ad = parcalar[0][0].toUpperCase() + parcalar[0].substring(1).toLowerCase();
      String soyadIlkHarf = parcalar[parcalar.length - 1][0].toUpperCase();
      return "$ad $soyadIlkHarf.";
    }
    return adSoyad.toUpperCase();
  }

  static double _komisyonHesapla(String fiyat) {
    String temizFiyat = fiyat.replaceAll(RegExp(r'[^0-9]'), '');
    double tutar = double.tryParse(temizFiyat) ?? 0.0;
    return tutar * 0.01;
  }

  static Map<String, dynamic> _teknikDetaylariNormalizeEt(Map<String, dynamic> hamDetaylar) {
    final Map<String, dynamic> normalizeHarita = Map<String, dynamic>.from(hamDetaylar);
    return normalizeHarita;
  }

  factory IlanModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    String ad = map['musteriAd']?.toString() ?? map['name']?.toString() ?? '';
    String fiyat = map['fiyatBilgisi']?.toString() ?? '0';

    Map<String, dynamic> hamTeknikDetaylar = map['teknikDetaylar'] is Map
        ? Map<String, dynamic>.from(map['teknikDetaylar'])
        : {};

    Map<String, dynamic> temizTeknikDetaylar = _teknikDetaylariNormalizeEt(hamTeknikDetaylar);

    return IlanModel(
      id: docId ?? map['id']?.toString() ?? '',
      baslik: map['baslik']?.toString() ?? '',
      kategoriId: map['kategoriId']?.toString() ?? '',
      kategori: map['kategori']?.toString() ?? '',
      durum: map['durum']?.toString() ?? 'aktif',
      tarih: map['tarih']?.toString() ?? DateTime.now().toIso8601String(),
      userId: map['userId']?.toString() ?? map['uid']?.toString() ?? '',
      fiyatBilgisi: fiyat,
      detaylar: map['detaylar']?.toString() ?? '',
      musteriAd: ad,
      maskeliAd: _maskele(ad),
      musteriTelefon: map['musteriTelefon']?.toString() ?? map['phone']?.toString() ?? '',
      konumMetin: map['konumMetin']?.toString() ?? '',
      acikAdres: map['acikAdres']?.toString() ?? map['adres']?.toString() ?? '',
      ilId: map['ilId']?.toString() ?? map['sehir_id']?.toString() ?? '',
      ilceId: map['ilceId']?.toString() ?? map['ilce_id']?.toString() ?? '',
      ilanCode: map['ilanCode']?.toString() ?? '',
      isTanimi: map['isTanimi']?.toString() ?? '',
      komisyonTutari: _komisyonHesapla(fiyat),
      komisyonOdendiMi: map['komisyonOdendiMi'] ?? false,
      isAcil: map['isAcil'] ?? (hamTeknikDetaylar['isAcil'] == true),
      metreKare: map['metreKare']?.toString(),
      odaSayisi: map['odaSayisi']?.toString(),
      hizmetTipi: map['hizmetTipi']?.toString(),
      teknikDetaylar: temizTeknikDetaylar,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      musteriAdSoyad: map['musteriAdSoyad']?.toString(),
      sehirIlceMetni: map['sehirIlceMetni']?.toString() ?? map['konumMetin']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baslik': baslik,
      'kategoriId': kategoriId,
      'kategori': kategori,
      'durum': durum,
      'tarih': tarih,
      'userId': userId,
      'fiyatBilgisi': fiyatBilgisi,
      'detaylar': detaylar,
      'musteriAd': musteriAd,
      'maskeliAd': maskeliAd,
      'musteriTelefon': musteriTelefon,
      'konumMetin': konumMetin,
      'acikAdres': acikAdres,
      'ilId': ilId,
      'ilceId': ilceId,
      'ilanCode': ilanCode,
      'isTanimi': isTanimi,
      'komisyonTutari': komisyonTutari,
      'komisyonOdendiMi': komisyonOdendiMi,
      'isAcil': isAcil,
      'metreKare': metreKare,
      'odaSayisi': odaSayisi,
      'hizmetTipi': hizmetTipi,
      'teknikDetaylar': teknikDetaylar,
      'latitude': latitude,
      'longitude': longitude,
      'musteriAdSoyad': musteriAdSoyad,
      'sehirIlceMetni': sehirIlceMetni,
    };
  }
}