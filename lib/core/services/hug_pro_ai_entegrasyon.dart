// lib/features/hug_pro/presentation/hug_pro_ai_entegrasyon.dart - HUG PRO - AI ENTEGRASYON ÖRNEĞİ
// Bu dosyayı HugProjeOlusturPage'e entegre et - COPY/PASTE HAZIR
// HUG PRO - %4 SİSTEMİ ÇAĞIRMA + FIRESTORE KAYIT

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/hug_pro_orkestra_servisi.dart';

class HugProAiEntegrasyon {

  // PROJE OLUŞTURULDUKTAN SONRA ÇAĞIR - AI DEĞERLEME BAŞLAT
  static Future<void> aiDegerlemeBaslatVeKaydet({
    required String projeId,
    required String yapiTuruId,
    required String asama,
    required Map<String, String> olcek,
    required Map<String, dynamic> detaylar,
    required String il,
    required String ilce,
    required String aciklama,
    required List<String> ihtiyacIds,
    String? sablonBaslik,
  }) async {
    try {
      debugPrint("🤖 [HUG PRO AI] Değerleme başlatılıyor: $projeId");

      // 1. AI ORKESTRAYI ÇAĞIR (3 katmanlı - GROK→GROQ→LLAMA)
      final aiSonuc = await HugProOrkestraServisi.silsileYurut(
        projeId: projeId,
        yapiTuruId: yapiTuruId,
        asama: asama,
        olcek: olcek,
        detaylar: detaylar,
        il: il,
        ilce: ilce,
        aciklama: aciklama,
        ihtiyacIds: ihtiyacIds,
        sablonBaslik: sablonBaslik,
      );

      final valuation = aiSonuc['valuation'] as Map<String, dynamic>;
      final kaynak = aiSonuc['kaynak'];

      debugPrint("🤖✅ [HUG PRO AI BAŞARILI] Kaynak: $kaynak | Hizmet: ${valuation['services']?.length} | Toplam HUG: ${valuation['total']?['hug_access_fee_total_tl']} TL");

      // 2. FIRESTORE'A KAYDET - hug_projeler koleksiyonu
      final firestore = FirebaseFirestore.instance;

      // Ana projeye AI valuation ekle
      await firestore.collection('hug_projeler').doc(projeId).update({
        'aiValuation': valuation,
        'aiKaynak': kaynak,
        'aiDurum': 'BASARILI',
        'aiTarih': FieldValue.serverTimestamp(),
        'hugAccessFeeTotal': valuation['total']?['hug_access_fee_total_tl'] ?? 0,
      });

      // 3. HER PROFESYONEL İÇİN AYRI KART OLUŞTUR - hug_pro_hizmet_kartlari
      final services = valuation['services'] as List? ?? [];
      for (final svc in services) {
        if (svc['status'] != 'estimated') continue;

        final kartId = "${projeId}_${svc['service_id']}";
        await firestore.collection('hug_pro_hizmet_kartlari').doc(kartId).set({
          'projeId': projeId,
          'yapiTuruId': yapiTuruId,
          'serviceId': svc['service_id'],
          'serviceName': svc['service_name'],
          'minTl': svc['min_tl'],
          'estimatedTl': svc['estimated_tl'],
          'maxTl': svc['max_tl'],
          'hugAccessFeeTl': svc['hug_access_fee_tl'], // %4
          'hugAccessRate': 0.04,
          'vatIncluded': svc['vat_included'] ?? false,
          'scope': svc['scope'] ?? '',
          'pricingBasis': svc['pricing_basis'] ?? '',
          'assumptions': svc['assumptions'] ?? [],
          'confidence': svc['confidence'] ?? 'medium',
          'status': 'BEKLEMEDE', // ÖDEME BEKLİYOR
          'odendi': false,
          'olusturmaTarihi': FieldValue.serverTimestamp(),
          'il': il,
          'ilce': ilce,
          'aiKaynak': kaynak,
        });
      }

      debugPrint("🤖✅ [HUG PRO AI] Firestore kaydı tamam: $projeId | ${services.length} kart oluşturuldu");

    } catch (e, s) {
      debugPrint("🤖❌ [HUG PRO AI HATA] $e | Stack: ${s.toString().substring(0, 500)}");

      // HATA DURUMUNDA DA KAYDET - DEBUG İÇİN
      try {
        await FirebaseFirestore.instance.collection('hug_projeler').doc(projeId).update({
          'aiDurum': 'HATA',
          'aiHata': e.toString(),
          'aiTarih': FieldValue.serverTimestamp(),
        });
      } catch (_) {}

      rethrow;
    }
  }

  // PROFESYONEL ÖDEME YAPTI MI KONTROL
  static Future<bool> hizmetKartiOdendiMi({
    required String projeId,
    required String serviceId,
  }) async {
    final docId = "${projeId}_$serviceId";
    final doc = await FirebaseFirestore.instance
        .collection('hug_pro_hizmet_kartlari')
        .doc(docId)
        .get();

    if (!doc.exists) return false;
    return doc.data()?['odendi'] == true;
  }

  // TOPLAM HUG GELİRİ HESAPLA (BİR PROJE İÇİN)
  static int toplamHugGeliriHesapla(Map<String, dynamic> valuation) {
    final total = valuation['total'] as Map<String, dynamic>?;
    return (total?['hug_access_fee_total_tl'] as num?)?.toInt() ?? 0;
  }
}

// ==================== HUG PROJE OLUSTUR PAGE ENTEGRASYON ÖRNEĞİ ====================
// Aşağıdaki kodu mevcut HugProjeOlusturPage'in proje kaydetme metoduna ekle:

/*
Future<void> _projeOlusturVeAiCalistir() async {
  // ... mevcut kodun - proje Firestore'a kaydediliyor ...

  final projeRef = await FirebaseFirestore.instance.collection('hug_projeler').add({
    'yapiTuruId': _yapiTuruId,
    'asama': _asama.name,
    'olcek': _olcek,
    'detaylar': _detaylar, // 60+ alan!
    'il': _il,
    'ilce': _ilce,
    'aciklama': _aciklamaCtrl.text,
    'ihtiyacIds': _ihtiyacIds,
    'sablonBaslik': _secilenSablon?['baslik'],
    'durum': 'AKTIF',
    'olusturmaTarihi': FieldValue.serverTimestamp(),
    // ... diğer alanlar ...
  });

  final projeId = projeRef.id;
  debugPrint("✅ Proje oluşturuldu: $projeId");

  // AI DEĞERLEMEYİ ARKA PLANDA BAŞLAT - UI BLOKLANMAZ!
  // Kullanıcıya "Projeniz oluşturuldu, AI analiz ediliyor" göster

  // Fire-and-forget - await yok, arka planda çalışır
  HugProAiEntegrasyon.aiDegerlemeBaslatVeKaydet(
    projeId: projeId,
    yapiTuruId: _yapiTuruId!,
    asama: _asama.name,
    olcek: _olcek,
    detaylar: _detaylar,
    il: _il,
    ilce: _ilce,
    aciklama: _aciklamaCtrl.text,
    ihtiyacIds: _ihtiyacIds,
    sablonBaslik: _secilenSablon?['baslik'],
  ).then((_) {
    debugPrint("🎉 HUG PRO AI tamamlandı!");
    // UI güncelle, bildirim göster vs.
  }).catchError((e) {
    debugPrint("⚠ HUG PRO AI hata ama proje oluşturuldu: $e");
  });

  // HEMEN SONRAKİ SAYFAYA GEÇ - AI arka planda
  Navigator.push(... proje detay sayfası ...);
}
*/
