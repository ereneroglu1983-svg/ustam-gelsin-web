class Sehir {
  final String id;
  final String isim;

  const Sehir({required this.id, required this.isim});

  // Senin ilceler.json ve sehirler.json ikisiyle de uyumlu fabrika
  factory Sehir.fromJson(Map<String, dynamic> json) {
    return Sehir(
      id: (json['sehir_id']?? json['id']?? '').toString(),
      isim: _normalize(json['sehir_adi']?? json['isim']?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'sehir_id': id,
    'sehir_adi': isim,
  };

  // iyzico için MANİSA -> Manisa, İSTANBUL -> Istanbul
  static String _normalize(String raw) {
    if (raw.isEmpty) return raw;
    final lower = raw.toLowerCase();
    // Türkçe karakterler için basit title case
    return lower[0].toUpperCase() + lower.substring(1);
  }

  @override
  bool operator ==(Object other) => other is Sehir && other.id == id;
  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Sehir(id: $id, isim: $isim)';
}

// Bunu da yanına ekle, ilceler.json'ı doğrudan bu modele parse edeceksin
class Ilce {
  final String id;
  final String isim;
  final String sehirId;
  final String sehirAdi;

  const Ilce({required this.id, required this.isim, required this.sehirId, required this.sehirAdi});

  factory Ilce.fromJson(Map<String, dynamic> json) {
    return Ilce(
      id: (json['ilce_id']?? '').toString(),
      isim: Sehir._normalize(json['ilce_adi']?? ''),
      sehirId: (json['sehir_id']?? '').toString(),
      sehirAdi: Sehir._normalize(json['sehir_adi']?? ''),
    );
  }

  Sehir get sehir => Sehir(id: sehirId, isim: sehirAdi);
}