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
  final double minimumButce;
  final double muhtemelButce;
  final double maksimumButce;
  final String fiyatAraligi;
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
  final double komisyonTabani;
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
  final List<String> resimler;
  final int teklifSayisi;

  IlanModel({
    required this.id,
    required this.baslik,
    required this.kategoriId,
    this.kategori = '',
    required this.durum,
    required this.tarih,
    required this.userId,
    required this.fiyatBilgisi,
    this.minimumButce = 0,
    this.muhtemelButce = 0,
    this.maksimumButce = 0,
    this.fiyatAraligi = '',
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
    this.komisyonTabani = 0.0,
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
    this.resimler = const [],
    this.teklifSayisi = 0,
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
    double? minimumButce,
    double? muhtemelButce,
    double? maksimumButce,
    String? fiyatAraligi,
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
    double? komisyonTabani,
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
    List<String>? resimler,
    int? teklifSayisi,
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
      minimumButce: minimumButce ?? this.minimumButce,
      muhtemelButce: muhtemelButce ?? this.muhtemelButce,
      maksimumButce: maksimumButce ?? this.maksimumButce,
      fiyatAraligi: fiyatAraligi ?? this.fiyatAraligi,
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
      komisyonTabani: komisyonTabani ?? this.komisyonTabani,
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
      resimler: resimler ?? this.resimler,
      teklifSayisi: teklifSayisi ?? this.teklifSayisi,
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

  static Map<String, dynamic> _teknikDetaylariNormalizeEt(Map<String, dynamic> hamDetaylar) {
    return Map<String, dynamic>.from(hamDetaylar);
  }

  factory IlanModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    String ad = map['musteriAd']?.toString() ?? map['name']?.toString() ?? '';
    String fiyat = map['fiyatBilgisi']?.toString() ?? map['fiyatAraligi']?.toString() ?? '0 ₺';

    double min = (map['minimumButce'] as num?)?.toDouble() ?? 0;
    double muhtemel = (map['muhtemelButce'] as num?)?.toDouble() ?? 0;
    double max = (map['maksimumButce'] as num?)?.toDouble() ?? 0;
    String aralik = map['fiyatAraligi']?.toString() ?? map['aralikliFiyatBilgisi']?.toString() ?? '';

    if (aralik.isNotEmpty) fiyat = aralik;

    Map<String, dynamic> hamTeknikDetaylar = map['teknikDetaylar'] is Map ? Map<String, dynamic>.from(map['teknikDetaylar']) : {};

    return IlanModel(
      id: docId ?? map['id']?.toString() ?? '',
      baslik: map['baslik']?.toString() ?? '',
      kategoriId: map['kategoriId']?.toString() ?? '',
      kategori: map['kategori']?.toString() ?? '',
      durum: map['durum']?.toString() ?? 'aktif',
      tarih: map['tarih']?.toString() ?? DateTime.now().toIso8601String(),
      userId: map['userId']?.toString() ?? map['uid']?.toString() ?? '',
      fiyatBilgisi: fiyat,
      minimumButce: min,
      muhtemelButce: muhtemel,
      maksimumButce: max,
      fiyatAraligi: aralik,
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
      komisyonTutari: (map['komisyonTutari'] as num?)?.toDouble() ?? 0.0,
      komisyonTabani: (map['komisyonTabani'] as num?)?.toDouble() ?? 0.0,
      komisyonOdendiMi: map['komisyonOdendiMi'] ?? false,
      isAcil: map['isAcil'] ?? (hamTeknikDetaylar['isAcil'] == true),
      metreKare: map['metreKare']?.toString(),
      odaSayisi: map['odaSayisi']?.toString(),
      hizmetTipi: map['hizmetTipi']?.toString(),
      teknikDetaylar: _teknikDetaylariNormalizeEt(hamTeknikDetaylar),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      musteriAdSoyad: map['musteriAdSoyad']?.toString(),
      sehirIlceMetni: map['sehirIlceMetni']?.toString() ?? map['konumMetin']?.toString(),
      resimler: map['resimler'] != null ? List<String>.from(map['resimler']) : [],
      teklifSayisi: (map['teklifSayisi'] as num?)?.toInt() ?? 0,
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
      'minimumButce': minimumButce,
      'muhtemelButce': muhtemelButce,
      'maksimumButce': maksimumButce,
      'fiyatAraligi': fiyatAraligi,
      'aralikliFiyatBilgisi': fiyatAraligi,
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
      'komisyonTabani': komisyonTabani,
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
      'resimler': resimler,
      'teklifSayisi': teklifSayisi,
    };
  }
}