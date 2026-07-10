// lib/core/services/gemini_service.dart

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:cloud_functions/cloud_functions.dart';

class GeminiService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'europe-west3');

  Future<String> getFiyatTahmini({
    required String musteriId,
    required String isAdi,
    required String kategoriAdi,
    required String kategoriId,
    Map<String, dynamic>? detaylar,
  }) async {
    try {
      // 1. Prompt hazırla - MASTER PROMPT v2.0 - DEĞİŞMEDİ
      String teknikDetaylar = detaylar?.entries
          .map((e) => "${e.key.toUpperCase()}: ${e.value}")
          .join(", ") ?? "Belirtilmedi";

      final String userPrompt = """
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

      // 2. Cloud Function çağır - HttpsCallableOptions ile timeout eklendi
      final callable = _functions.httpsCallable(
        'hesaplaFiyat',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 60),
        ),
      );

      final result = await callable.call(<String, dynamic>{
        'prompt': userPrompt,
      });

      // 3. Cevabı parse et
      String rawText = result.data['fiyat']?.toString().trim() ?? "";

      final String? formatliFiyat = _formatSafePrice(rawText);

      if (formatliFiyat == null) {
        throw Exception("AI geçersiz veya yasaklı format üretti: $rawText");
      }

      return formatliFiyat;

    } on FirebaseFunctionsException catch (e) {
      debugPrint("❌ CLOUD FUNCTION HATASI: ${e.code} - ${e.message}");
      throw Exception("AI başarısız: ${e.message}");
    } catch (e) {
      debugPrint("❌ AI SERVİS HATASI: $e");
      throw Exception("AI başarısız");
    }
  }

  // DEĞİŞMEDİ
  String? _formatSafePrice(String text) {
    int? price = int.tryParse(text);

    if (price == null || price < 1000 || price > 100000000) {
      return null;
    }

    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} ₺";
  }
}