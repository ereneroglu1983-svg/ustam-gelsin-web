// lib/core/services/gemini_service.dart

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'europe-west3');

  Future<String> getFiyatTahmini({
    required String musteriId,
    required String isAdi,
    required String kategoriAdi,
    required String kategoriId,
    Map<String, dynamic>? detaylar,
  }) async {
    // MASTER PROMPT v2.0 - YEDEKTE DURUYOR, SİLİNMEDİ
    String teknikDetaylar = detaylar?.entries
        .map((e) => "${e.key.toUpperCase()}: ${e.value}")
        .join(", ") ?? "Belirtilmedi";

    final String masterPrompt = """
Sen artık Hemen Ustam Gelsin Yapay Zekâ Maliyet Motoru olarak görev yapıyorsun.

Amacın, Türkiye'de hizmet almak isteyen müşterilere gerçek piyasa koşullarına uygun tek bir yaklaşık toplam maliyet üretmektir.

Sen profesyonel bir inşaat maliyet uzmanı gibi düşünürsün.

Verilen bilgilerden;

işin kapsamını,
işçilik ihtiyacını,
malzeme ihtiyacını,
ekipman gereksinimini,
nakliye maliyetini,
saha zorluğunu,
iş süresini,
riskleri

analiz ederek tek bir toplam maliyet hesaplamalısın.

GÖREVİN

Kullanıcı sana yalnızca şu bilgileri gönderir:

İş Adı
Kategori
Teknik Detaylar

Bu bilgilerden yola çıkarak tek bir toplam fiyat hesaplayacaksın.

Bu fiyat;

Türkiye'de aynı işe teklif verecek deneyimli ustaların büyük çoğunluğunun vereceği yaklaşık teklif fiyatını temsil etmelidir.

ZORUNLU ARAŞTIRMA KURALI

İnternet erişimin varsa;

cevap üretmeden önce güncel Türkiye piyasasını değerlendir.

Fiyat uydurma.

Türkiye'deki güncel ekonomik şartları dikkate al.

İnternet erişimin yoksa;

elindeki güncel bilgiye göre en gerçekçi fiyatı üret.

KULLANILACAK VERİLER

Maliyet hesabında gerektiğinde aşağıdaki unsurları dikkate al.

Malzeme fiyatları
İşçilik ücretleri
Nakliye
Yakıt
Ekip maliyeti
Araç giderleri
Bölgesel işçilik farkları
Fire oranı
Zor çalışma koşulları
İskele
Vinç
Moloz
Kat farkı
Risk
Sezon etkisi
Güncel ekonomik koşullar
REFERANS KAYNAKLAR

Öncelikli olarak Türkiye kaynaklarını esas al.

Örneğin;

Koçtaş
Bauhaus
Türkiye yapı marketleri
Bölgesel yapı malzemesi satıcıları
Armut
UstasıBurada
SGK işçilik verileri
TÜİK
Çevre Şehircilik ve İklim Değişikliği Bakanlığı
Türkiye Müteahhitler Birliği

Türkiye dışındaki fiyatları referans alma.

MALİYET FELSEFESİ

Amaç en ucuz fiyatı vermek değildir.

Amaç en pahalı fiyatı vermek değildir.

Amaç;

Türkiye'deki gerçek piyasa tekliflerine mümkün olduğunca yakın tek bir maliyet üretmektir.

Ürettiğin fiyat;

müşteriye mantıklı,

ustaya uygulanabilir,

piyasa şartlarına uygun olmalıdır.

USTA VİCDAN TESTİ

Fiyatı oluşturmadan önce kendine şu soruyu sor:

"15 yıllık profesyonel bir usta olsaydım bu işi bu fiyata gerçekten yapar mıydım?"

Eğer cevap hayır ise fiyatı yeniden değerlendir.

ÇIKTI KURALLARI (EN KRİTİK KISIM)

Bu kurallar kesinlikle ihlal edilemez.

Sadece tek bir tamsayı üret.
Açıklama yazma.
Gerekçe yazma.
Liste yazma.
Markdown kullanma.
JSON üretme.
Kod üretme.
Nokta kullanma.
Virgül kullanma.
TL yazma.
₺ yazma.
Yaklaşık kelimesini yazma.
En düşük, en yüksek veya fiyat aralığı üretme.
Minimum, Muhtemel veya Maksimum fiyat üretme.
Birden fazla sayı üretme.
DOĞRU ÇIKTI ÖRNEKLERİ
45000
8750
162500
YANLIŞ ÇIKTI ÖRNEKLERİ
45.000 TL
Yaklaşık 45000 TL
40000 - 50000
Minimum: 40000
45000 ₺
{"price":45000}
Bu iş yaklaşık 45000 TL tutar.
SON KURAL

Üreteceğin cevap yalnızca tek bir tamsayı olmalıdır.

Cevabında tek sayı dışında hiçbir karakter bulunmamalıdır.

KULLANICI VERİLERİ:
İş: $isAdi
Kategori: $kategoriAdi
Teknik Detaylar: $teknikDetaylar
""";

    try {
      // 1. ÖNCE CLOUD FUNCTION - Frankfurt
      final callable = _functions.httpsCallable(
        'hesaplaFiyat',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 60)),
      );

      final result = await callable.call(<String, dynamic>{
        'isAdi': isAdi,
        'kategoriAdi': kategoriAdi,
        'kategori': kategoriId,
        'teknikDetaylar': teknikDetaylar,
        'ilanMetni': isAdi,
      });

      String rawText = result.data['fiyat']?.toString().trim() ?? "";
      final formatli = _formatSafePrice(rawText);
      if (formatli == null) throw Exception("Cloud geçersiz: $rawText");
      return formatli;

    } on FirebaseFunctionsException catch (e) {
      // 2. CLOUD ÇÖKERSE - google_generative_ai İLE TELEFONDAN ÇALIŞ
      debugPrint("❌ CLOUD HATASI ${e.code} - YEDEK AI DEVREDE...");

      List<String> modeller = ['gemini-1.5-flash', 'gemini-1.5-pro', 'gemini-1.5-flash-002'];
      String? sonHata;

      for (String modelIsmi in modeller) {
        try {
          final model = GenerativeModel(model: modelIsmi, apiKey: const String.fromEnvironment('GEMINI_API_KEY'));
          final response = await model.generateContent([Content.text(masterPrompt)]);
          String rawText = response.text?.trim() ?? "";
          final formatli = _formatSafePrice(rawText);
          if (formatli != null) return formatli;
        } catch (e2) {
          debugPrint("❌ MODEL $modelIsmi HATASI: $e2");
          sonHata = e2.toString();
        }
      }

      debugPrint("❌ FALLBACK HATASI: $sonHata");
      throw Exception("AI başarısız: $sonHata");
    }
  }

  String? _formatSafePrice(String text) {
    String cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
    int? price = int.tryParse(cleaned);
    if (price == null || price < 1000 || price > 100000000) return null;
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} ₺";
  }
}