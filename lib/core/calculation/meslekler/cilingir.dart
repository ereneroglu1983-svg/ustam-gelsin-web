// lib/core/calculation/meslekler/cilingir_hesaplayici.dart

class CilingirHesaplayici {
  static Map<String, dynamic> hesapla(List<dynamic> gelenCevaplar) {
    // Çilingir acil iş olduğu için soru setimiz boş,
    // doğrudan sabit bir acil müdahale/servis bedeli dönüyoruz.
    return {
      "tahminiButce": 1500, // Sabit servis/acil müdahale bedeli
      "birim": "TRY",
      "durum": "BAŞARILI",
      "aciklama": "Acil çilingir servis bedeli. Usta lokasyona göre yönlendirilecektir."
    };
  }
}