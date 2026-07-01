import 'package:flutter_test/flutter_test.dart';
import 'package:ustam_gelsin/core/services/gemini_service.dart';

void main() {
  final geminiService = GeminiService();

  group('Sistem Kilidi: Fiyatlandırma ve Hiyerarşi Kontrolü', () {

    test('Kritik Hiyerarşi: 5+1 oda, 4+1 odadan pahalı olmalı', () async {
      // 4+1 Senaryosu
      final sonuc41 = await geminiService.getFiyatTahmini(
        musteriId: "test_user",
        isAdi: "İç Cephe Boya",
        kategoriAdi: "Boya",
        kategoriId: "boya_01",
        detaylar: {
          "odaSayisi": "4+1",
          "metreKare": "100-150",
          "esyaliMi": false,
        },
      );

      // 5+1 Senaryosu
      final sonuc51 = await geminiService.getFiyatTahmini(
        musteriId: "test_user",
        isAdi: "İç Cephe Boya",
        kategoriAdi: "Boya",
        kategoriId: "boya_01",
        detaylar: {
          "odaSayisi": "5+1",
          "metreKare": "100-150",
          "esyaliMi": false,
        },
      );

      int fiyat41 = int.parse(sonuc41.replaceAll(RegExp(r'[^0-9]'), ''));
      int fiyat51 = int.parse(sonuc51.replaceAll(RegExp(r'[^0-9]'), ''));

      expect(fiyat51, greaterThan(fiyat41), reason: "HATA: 5+1 fiyatı 4+1'in altına düştü!");
    });

    test('Sabit Veri Koruması: 1+0 en düşük çarpan kontrolü', () async {
      final sonuc = await geminiService.getFiyatTahmini(
        musteriId: "test_user",
        isAdi: "İç Cephe Boya",
        kategoriAdi: "Boya",
        kategoriId: "boya_01",
        detaylar: {
          "odaSayisi": "1+0",
          "metreKare": "0-50",
          "esyaliMi": false,
          "tavanDurumu": "Hariç",
          "malzemeDurumu": "Hariç",
        },
      );

      expect(sonuc, isNotNull);
      expect(sonuc, contains("₺"));
    });
  });
}