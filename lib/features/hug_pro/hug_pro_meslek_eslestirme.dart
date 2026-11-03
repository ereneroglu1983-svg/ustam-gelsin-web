// lib/features/hug_pro/hug_pro_meslek_eslestirme.dart
// HUG PRO - KAPI KONTROL SERVISI - ONTOLOJI BAZLI DOGRU ESLESME
// v5.2 - CANONICAL
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hug_ontoloji.dart';

class ProYetkiSonucu {
  final bool isAuthorized;
  final List<String> matchingIhtiyacIds;
  final List<String> proMeslekKodlari;
  final Map<String, dynamic>? proData;
  final String? failReason;
  const ProYetkiSonucu({required this.isAuthorized, this.matchingIhtiyacIds = const [], this.proMeslekKodlari = const [], this.proData, this.failReason});
}

class HugProMeslekEslestirmeServisi {
  static final _db = FirebaseFirestore.instance;
  static const Map<String, List<String>> _ihtiyacToProKodlari = {
    'MIMARI_PROJE': ['MIMAR','YAPI_MIMARI','VILLA_MIMARI','MIMARLIK','KONSEPT_TASARIM','MIMARI_TASARIM','AVAM_PROJE','RUHSAT_PROJESI','UYGULAMA_PROJESI','DETAY_PROJESI','KONSEPT_PROJE','RUHSAT_PROJESI_HIZ','UYGULAMA_PROJESI_HIZ','MIMARI_PROJE'],
    'STATIK_PROJE': ['INSAAT_MUHENDISI','STATIK','BETONARME','CELIK','YAPI','DEPREM','GUCLENDIRME','STATIK_PROJE','BETONARME_STATIK','CELIK_STATIK','DEPREM_ANALIZI','GUCLENDIRME_PROJESI'],
    'MEKANIK_PROJE': ['MAKINE_MUHENDISI','MEKANIK_TESISAT','HVAC','ISITMA','SOGUTMA','SIHHI_TESISAT','YANGIN_TESISATI','DOGALGAZ','MEKANIK_TESISAT_PROJESI','HVAC_PROJESI','YANGIN_TESISAT_PROJESI','MEKANIK_PROJE'],
    'ELEKTRIK_PROJE': ['ELEKTRIK_MUHENDISI','EE_MUHENDISI','ELEKTRIK_PROJESI','KUVVETLI_AKIM','ZAYIF_AKIM','AYDINLATMA','GES','TRAFO','ELEKTRIK_TAAHHUT_FIRMASI','ELEKTRIK_SISTEMLERI_FIRMASI','ELEKTRIK_PROJE'],
    'PEYZAJ_PROJE': ['PEYZAJ_MIMARI','PEYZAJ_TASARIMI','BITKILENDIRME','PEYZAJ_PROJESI','BAHCE_TASARIMI','PEYZAJ_PROJE'],
    'IC_MIMARI': ['IC_MIMAR','IC_MEKAN_TASARIMI','MOBILYA_YERLESIMI','VILLA_IC_MIMARI','OFIS_TASARIMI','IC_MIMARI'],
    '3D_GORSELLESTIRME': ['GORSELLISTIRME_UZMANI','MIMAR','IC_MIMAR','MODELLEME_3D','RENDER','DIS_CEPHE_RENDER','IC_MEKAN_RENDER','3D_GORSELLESTIRME'],
    'RUHSAT_DANISMANLIGI': ['MIMAR','INSAAT_MUHENDISI','PROJE_YONETICISI','RUHSAT_PROJESI','RUHSAT_PROJESI_HIZ','RUHSAT_DANISMANLIGI'],
    'ZEMIN_ETUDU': ['JEOLOJI_MUHENDISI','JEOFIZIK_MUHENDISI','INSAAT_MUHENDISI','JEOLOJIK_ETUT','ZEMIN','SONDAJ','ZEMIN_ETUDU','JEOLOJIK_ETUT_RAPORU'],
    'ENERJI_KIMLIK': ['ENERJI_PERFORMANS_UZMANI','ENERJI_MUHENDISI','MAKINE_MUHENDISI','ENERJI_PERFORMANSI','ENERJI_KIMLIK_BELGESI','ENERJI_KIMLIK'],
    'YAPI_DENETIM': ['YAPI_DENETIM_UZMANI','YAPI_LABORATUVARI','KALITE_KONTROL_FIRMASI','YAPI_DENETIMI','PROJE_KONTROLU','YAPI_DENETIM'],
    'HARITA_KADASTRO': ['HARITA_MUHENDISI','ARAZI_OLCUMU','KADASTRO','APLIKASYON','PLANKOTE','HALIHAZIR_HARITA','HARITA_KADASTRO'],
    'IS_GUVENLIGI': ['ISG_UZMANI','ISG_FIRMASI','IS_GUVENLIGI','ISG_DANISMANLIGI','RISK_ANALIZI'],
    'BUTCE_METRAJ': ['TEKNIK_OFIS_SEFI','PROJE_YONETICISI','INSAAT_MUHENDISI','METRAJ','KESIF','HAKEDIS','BUTCE_METRAJ'],
    'SANTIE_SEFLIGI': ['SANTIYE_SEFI','INSAAT_MUHENDISI','SANTIYE_YONETIMI','SAHA_YONETIMI','SANTIE_SEFLIGI'],
    'MUTEAHHITLIK': ['ANA_YUKLENICI','ALT_YUKLENICI','YAPI_UYGULAMA_FIRMASI','OZEL_YAPI_MUTEAHHIDI','ANAHTAR_TESLIM_YAPIM','VILLA_YAPIMI','MUTEAHHITLIK'],
    'YAPI_MALZEME': ['YAPI_UYGULAMA_FIRMASI','YAPI_MALZEME'],
    'BOYA_BADANA': ['BOYA_FIRMASI','ALCI_SIVA_FIRMASI','BOYA_BADANA','BOYA'],
    'YALITIM': ['YALITIM_FIRMASI','AKUSTIK_FIRMASI','YANGIN_YALITIM_FIRMASI','CEPHE_FIRMASI','CATI_FIRMASI','SU_YALITIMI','MANTOLAMA','ISI_YALITIMI','SES_YALITIMI','YALITIM'],
  };

  static Future<ProYetkiSonucu> checkProYetki({required String? uid, required List<String> ihtiyacIds}) async {
    if (uid == null || uid.isEmpty) {
      return const ProYetkiSonucu(isAuthorized: false, failReason: 'Giriş yapmanız gerekiyor');
    }
    if (ihtiyacIds.isEmpty) {
      return const ProYetkiSonucu(isAuthorized: false, failReason: 'İlan için meslek bilgisi bulunamadı');
    }
    try {
      final doc = await _db.collection('users_pro').doc(uid).get();
      if (!doc.exists) {
        return const ProYetkiSonucu(isAuthorized: false, failReason: 'Bu ilanın detaylarını görüntülemek için yeterli mesleki yetkinliğiniz bulunmamaktadır. İlan sadece ilgili alanda doğrulanmış profesyonellere açıktır.');
      }
      final data = doc.data()!;
      final bool isActive = data['isActive'] == true;
      final bool isVerified = data['isVerified'] == true;
      final String durum = (data['durum'] ?? '').toString().toUpperCase();
      if (!isActive || !isVerified) {
        return ProYetkiSonucu(isAuthorized: false, proData: data, failReason: 'Hesabınız henüz aktif değil. Admin onayı bekleniyor.');
      }
      if (durum.contains('BEKLIYOR') || durum.contains('RED') || durum.contains('PASIF')) {
        return ProYetkiSonucu(isAuthorized: false, proData: data, failReason: 'Hesabınız onay aşamasında. Detaylar sadece onaylı profesyonellere açıktır.');
      }
      final List<dynamic> mesleklerRaw = data['meslekler'] ?? [];
      final Set<String> proKodlar = {};
      for (var m in mesleklerRaw) {
        if (m is! Map) continue;
        final ana = _norm((m['anaDalId'] ?? '').toString());
        final alt = _norm((m['altDalId'] ?? '').toString());
        final unvan = _norm((m['unvanId'] ?? '').toString());
        final List<dynamic> uzmanliklar = m['uzmanlikIds'] ?? [];
        final List<dynamic> hizmetler = m['hizmetIds'] ?? [];
        if (ana.isNotEmpty) proKodlar.add(ana);
        if (alt.isNotEmpty) proKodlar.add(alt);
        if (unvan.isNotEmpty) proKodlar.add(unvan);
        for (var u in uzmanliklar) { final n = _norm(u.toString()); if (n.isNotEmpty) proKodlar.add(n); }
        for (var h in hizmetler) { final n = _norm(h.toString()); if (n.isNotEmpty) proKodlar.add(n); }
        final anaDal = _findAnaDalById(ana);
        if (anaDal != null) {
          try {
            final altDal = anaDal.altDallar.firstWhere((e) => _norm(e.id) == alt);
            for (var uid in altDal.unvanIds) proKodlar.add(_norm(uid));
            for (var uz in altDal.uzmanlikIds) proKodlar.add(_norm(uz));
            for (var hz in altDal.hizmetIds) proKodlar.add(_norm(hz));
          } catch (_) {}
        }
      }
      if (proKodlar.isEmpty) {
        return ProYetkiSonucu(isAuthorized: false, proData: data, failReason: 'Mesleki yetkinlik kaydı bulunamadı.');
      }
      final List<String> matchingIhtiyac = [];
      for (var ihtiyacRaw in ihtiyacIds) {
        final ihtiyac = _norm(ihtiyacRaw);
        if (ihtiyac.isEmpty) continue;
        if (proKodlar.contains(ihtiyac)) { matchingIhtiyac.add(ihtiyacRaw); continue; }
        final allowedKodlar = _ihtiyacToProKodlari[ihtiyac] ?? _ihtiyacToProKodlari[ihtiyacRaw.toUpperCase()] ?? [];
        bool found = false;
        for (var allowed in allowedKodlar) { if (proKodlar.contains(_norm(allowed))) { found = true; break; } }
        if (found) { matchingIhtiyac.add(ihtiyacRaw); continue; }
        for (var proKod in proKodlar) { if (_fuzzy(ihtiyac, proKod)) { matchingIhtiyac.add(ihtiyacRaw); break; } }
      }
      if (matchingIhtiyac.isEmpty) {
        return ProYetkiSonucu(isAuthorized: false, proData: data, proMeslekKodlari: proKodlar.toList(), failReason: 'Bu ilanın detaylarını görüntülemek için yeterli mesleki yetkinliğiniz bulunmamaktadır. İlan sadece ilgili alanda doğrulanmış profesyonellere açıktır.');
      }
      return ProYetkiSonucu(isAuthorized: true, matchingIhtiyacIds: matchingIhtiyac, proMeslekKodlari: proKodlar.toList(), proData: data);
    } catch (e) {
      return ProYetkiSonucu(isAuthorized: false, failReason: 'Yetki kontrolü hatası: $e');
    }
  }

  static List<Map<String, dynamic>> filterValuationServices({required Map<String, dynamic>? valuation, required List<String> matchingIhtiyacIds}) {
    if (valuation == null) return [];
    final List<dynamic> services = valuation['services'] ?? [];
    if (services.isEmpty) return [];
    final Set<String> matchSet = matchingIhtiyacIds.map((e) => _norm(e)).toSet();
    final List<Map<String, dynamic>> filtered = [];
    for (var s in services) {
      if (s is! Map<String, dynamic>) continue;
      final String meslek = _norm((s['meslek'] ?? s['id'] ?? '').toString());
      if (matchSet.contains(meslek)) { filtered.add(s); continue; }
      for (var m in matchSet) {
        final allowed = _ihtiyacToProKodlari[m] ?? [];
        if (allowed.map((e) => _norm(e)).contains(meslek)) { filtered.add(s); break; }
        if (_fuzzy(m, meslek)) { filtered.add(s); break; }
      }
    }
    return filtered;
  }

  static String _norm(String input) { return input.trim().toUpperCase().replaceAll(' ', '_').replaceAll('-', '_'); }
  static bool _fuzzy(String a, String b) {
    if (a == b) return true;
    if (a.contains(b) || b.contains(a)) return true;
    final aCore = a.replaceAll('_PROJE', '').replaceAll('PROJE_', '').replaceAll('_PROJESI', '');
    final bCore = b.replaceAll('_PROJE', '').replaceAll('PROJE_', '').replaceAll('_PROJESI', '');
    if (aCore == bCore && aCore.length >= 3) return true;
    return false;
  }
  static AnaDal? _findAnaDalById(String id) {
    try { return HugProMasterOntologyV5.anaDallar.firstWhere((e) => _norm(e.id) == _norm(id)); } catch (_) {
      try { return HugProMasterOntologyV5.anaDallar.firstWhere((e) => _norm(e.kod) == _norm(id)); } catch (_) { return null; }
    }
  }
}
