// lib/core/models/ilan_model.dart

class IlanModel {
  final String id;
  final String musteriAd; // Tam ad (Ödeme sonrası görünür)
  final String musteriTelefon; // Ödeme sonrası görünür
  final String sehirIlce;
  final String baslik;
  final String isTanimi;
  final String tarih;
  final String konumMetin;
  final String acikAdres; // Ödeme sonrası görünür
  final double tahminiButce;
  final List<String> etiketler;
  final int teklifSayisi;

  IlanModel({
    required this.id,
    required this.musteriAd,
    required this.musteriTelefon,
    required this.sehirIlce,
    required this.baslik,
    required this.isTanimi,
    required this.tarih,
    required this.konumMetin,
    required this.acikAdres,
    required this.tahminiButce,
    required this.etiketler,
    this.teklifSayisi = 0,
  });

  // Müşterinin adını ödeme öncesi maskeler (Örn: Fatih Y.)
  String get maskeliAd {
    if (musteriAd.isEmpty) return "Müşteri";
    List<String> parcalar = musteriAd.trim().split(" ");
    if (parcalar.length > 1) {
      String soyad = parcalar.last;
      return "${parcalar[0]} ${soyad[0]}.";
    }
    return musteriAd;
  }

  // Sistem komisyonunu hesaplar (%1)
  // 100.000 TL ve üzeri yüksek değerlerde veri kaybı yaşanmaması için double korunmuştur.
  double get komisyonTutari => tahminiButce * 0.01;

  // JSON dönüşüm metotları (Firebase/API entegrasyonu için gerekebilir)
  factory IlanModel.fromJson(Map<String, dynamic> json) {
    return IlanModel(
      id: json['id'] ?? '',
      musteriAd: json['musteriAd'] ?? '',
      musteriTelefon: json['musteriTelefon'] ?? '',
      sehirIlce: json['sehirIlce'] ?? '',
      baslik: json['baslik'] ?? '',
      isTanimi: json['isTanimi'] ?? '',
      tarih: json['tarih'] ?? '',
      konumMetin: json['konumMetin'] ?? '',
      acikAdres: json['acikAdres'] ?? '',
      tahminiButce: (json['tahminiButce'] ?? 0).toDouble(),
      etiketler: List<String>.from(json['etiketler'] ?? []),
      teklifSayisi: json['teklifSayisi'] ?? 0,
    );
  }
}