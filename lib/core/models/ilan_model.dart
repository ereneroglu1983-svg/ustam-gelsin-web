// lib/core/models/ilan_model.dart

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
  final String? metreKare;
  final String? odaSayisi;
  final String? hizmetTipi;
  final Map<String, dynamic> teknikDetaylar;
  final double latitude;
  final double longitude;

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
    this.metreKare,
    this.odaSayisi,
    this.hizmetTipi,
    this.teknikDetaylar = const {},
    this.latitude = 0.0,
    this.longitude = 0.0,
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
    String? metreKare,
    String? odaSayisi,
    String? hizmetTipi,
    Map<String, dynamic>? teknikDetaylar,
    double? latitude,
    double? longitude,
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
      metreKare: metreKare ?? this.metreKare,
      odaSayisi: odaSayisi ?? this.odaSayisi,
      hizmetTipi: hizmetTipi ?? this.hizmetTipi,
      teknikDetaylar: teknikDetaylar ?? this.teknikDetaylar,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
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

    hamDetaylar.forEach((key, value) {
      final String stringKey = key.toString().toLowerCase();
      final String stringValue = value.toString().toLowerCase();

      if (stringKey == 'alan_m2' || stringKey == 'adet' || stringKey == 'secilen_is_tipi') return;

      if (stringKey.contains('metrekare') || stringKey.contains('m²') || stringKey.contains('ölçü') || stringKey.contains('metraj') || stringKey.contains('alan')) {
        double bulunanM2 = _stringIcerisindenSayiAyikla(stringValue);
        if (bulunanM2 > 0) {
          normalizeHarita['alan_m2'] = bulunanM2;
          normalizeHarita['alan_segmenti'] = value.toString();
        }
      }

      if (stringKey.contains('sayı') || stringKey.contains('adet') || stringKey.contains('pencere') || stringKey.contains('kapı') || stringKey.contains('oda')) {
        double bulunanAdet = _stringIcerisindenSayiAyikla(stringValue);
        if (bulunanAdet > 0) {
          normalizeHarita['adet'] = bulunanAdet;
        }
      }

      if (stringKey.contains('tipi') || stringKey.contains('türü') || stringKey.contains('kalite')) {
        normalizeHarita['secilen_is_tipi'] = value;
      }
    });

    final List<dynamic> ortakEkstralar = [];
    hamDetaylar.forEach((key, value) {
      if (key == 'ekstra_ozellikler' || key == 'ekstra_detaylar') return;

      if (value is List) {
        ortakEkstralar.addAll(value);
      } else if (value is bool && value == true) {
        ortakEkstralar.add(key);
      }
    });

    if (ortakEkstralar.isNotEmpty) {
      normalizeHarita['ekstra_ozellikler'] = ortakEkstralar;
    }

    return normalizeHarita;
  }

  static double _stringIcerisindenSayiAyikla(String metin) {
    if (metin.isEmpty) return 0.0;

    if (metin.contains('-')) {
      final parcalar = metin.split('-');
      return _tekilSayiAyikla(parcalar[1]);
    }

    return _tekilSayiAyikla(metin);
  }

  static double _tekilSayiAyikla(String hamMetin) {
    String temiz = hamMetin.trim();

    if (RegExp(r'[\.,]\d{3}$').hasMatch(temiz)) {
      temiz = temiz.replaceAll('.', '').replaceAll(',', '');
    } else {
      temiz = temiz.replaceAll(',', '.');
    }

    temiz = temiz.replaceAll(RegExp(r'[^0-9.]'), '');

    return double.tryParse(temiz) ?? 0.0;
  }

  factory IlanModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    String ad = map['musteriAd']?.toString() ?? '';
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
      userId: map['userId']?.toString() ?? '',
      fiyatBilgisi: fiyat,
      detaylar: map['detaylar']?.toString() ?? '',
      musteriAd: ad,
      maskeliAd: _maskele(ad),
      musteriTelefon: map['musteriTelefon']?.toString() ?? '',
      konumMetin: map['konumMetin']?.toString() ?? '',
      acikAdres: map['acikAdres']?.toString() ?? '',
      ilId: map['ilId']?.toString() ?? '',
      ilceId: map['ilceId']?.toString() ?? '',
      ilanCode: map['ilanCode']?.toString() ?? '',
      isTanimi: map['isTanimi']?.toString() ?? '',
      komisyonTutari: _komisyonHesapla(fiyat),
      komisyonOdendiMi: map['komisyonOdendiMi'] ?? false,
      metreKare: map['metreKare']?.toString(),
      odaSayisi: map['odaSayisi']?.toString(),
      hizmetTipi: map['hizmetTipi']?.toString(),
      teknikDetaylar: temizTeknikDetaylar,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
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
      'metreKare': metreKare,
      'odaSayisi': odaSayisi,
      'hizmetTipi': hizmetTipi,
      'teknikDetaylar': teknikDetaylar,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}