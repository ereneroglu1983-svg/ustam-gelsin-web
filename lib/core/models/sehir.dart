class Sehir {
  final String id;
  final String isim;

  Sehir({required this.id, required this.isim});

  // JSON'dan nesne üreten fabrika metodu
  factory Sehir.fromJson(Map<String, dynamic> json) {
    return Sehir(
      id: json['sehir_id'],
      isim: json['sehir_adi'],
    );
  }
}