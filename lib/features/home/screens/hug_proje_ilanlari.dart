// lib/features/home/screens/hug_proje_ilanlari.dart - KAPIDA KESME v5.2
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'hug_pro_detay_sayfasi.dart';
import '../../hug_pro/hug_pro_meslek_eslestirme.dart';

const _black = Color(0xFF0B0B0B);
const _dark = Color(0xFF111111);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

class HugProjeIlanlari extends StatelessWidget {
  const HugProjeIlanlari({super.key});

  String _formatYapiAdi(String raw) {
    return raw.replaceAll('_', ' / ').replaceAll('TICARI', 'TİCARİ').replaceAll('OFIS', 'OFİS').replaceAll('MAGAZA', 'MAĞAZA');
  }

  String _maskName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty || fullName == 'Müşteri') return 'Müşteri';
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0];
    final ad = parts.first;
    final soyad = parts.last;
    if (soyad.isEmpty) return ad;
    return '$ad ${soyad[0]}....';
  }

  Future<String?> _fetchMusteriFromUserDoc(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      final d = doc.data()!;
      return d['adSoyad'] ?? d['displayName'] ?? d['name'] ?? d['ad'] ?? d['fullName'];
    } catch (_) {
      return null;
    }
  }

  String _timeAgo(Timestamp? ts) {
    if (ts == null) return 'Az önce';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    if (diff.inDays == 1) return 'Dün';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    return '${ts.toDate().day}.${ts.toDate().month}';
  }

  String _ihtiyacDisplay(String id) {
    const map = {
      'MIMARI_PROJE': 'MİMARİ PROJE',
      'STATIK_PROJE': 'STATİK PROJE',
      'MEKANIK_PROJE': 'MEKANİK PROJE',
      'ELEKTRIK_PROJE': 'ELEKTRİK PROJE',
      'PEYZAJ_PROJE': 'PEYZAJ PROJE',
      'IC_MIMARI': 'İÇ MİMARİ',
      '3D_GORSELLESTIRME': '3D GÖRSELLEŞTİRME',
      'RUHSAT_DANISMANLIGI': 'RUHSAT DANIŞMANLIĞI',
      'ZEMIN_ETUDU': 'ZEMİN ETÜDÜ',
      'ENERJI_KIMLIK': 'ENERJİ KİMLİK BELGESİ',
      'YAPI_DENETIM': 'YAPI DENETİM',
      'HARITA_KADASTRO': 'HARİTA & KADASTRO',
      'IS_GUVENLIGI': 'İŞ GÜVENLİĞİ',
      'BUTCE_METRAJ': 'BÜTÇE & METRAJ',
      'SANTIE_SEFLIGI': 'ŞANTİYE ŞEFLİĞİ',
      'MUTEAHHITLIK': 'MÜTEAHHİTLİK',
      'YAPI_MALZEME': 'YAPI MALZEME TEDARİK',
      'BOYA_BADANA': 'BOYA & KAPLAMA',
      'YALITIM': 'YALITIM & İZOLASYON',
      'DIGER': 'DİĞER',
    };
    return map[id] ?? id.replaceAll('_', ' ');
  }

  String _olcekLabel(String key) {
    const map = {
      'arsa': 'ARSA ALANI',
      'arsaAlani': 'ARSA ALANI',
      'ARSA_ALANI': 'ARSA ALANI',
      'yapi': 'YAPI ALANI',
      'yapiAlani': 'YAPI ALANI',
      'YAPI_ALANI': 'YAPI ALANI',
      'kapali': 'KAPALI ALAN',
      'kapaliAlan': 'KAPALI ALAN',
      'KAPALI_ALAN': 'KAPALI ALAN',
      'kat': 'KAT SAYISI',
      'katSayisi': 'KAT SAYISI',
      'KAT_SAYISI': 'KAT SAYISI',
      'guc': 'KURULU GÜÇ',
      'kuruluGuc': 'KURULU GÜÇ',
      'KURULU_GUC': 'KURULU GÜÇ',
      'birim': 'BİRİM SAYISI',
      'birimSayisi': 'BİRİM SAYISI',
      'BIRIM_SAYISI': 'BİRİM SAYISI',
    };
    return map[key] ?? key.toUpperCase();
  }

  List<MapEntry<String, String>> _parseOlcek(Map<String, dynamic>? olcek, Map<String, dynamic>? olcekBirimli) {
    if (olcekBirimli != null && olcekBirimli.isNotEmpty) {
      return olcekBirimli.entries.map((e) => MapEntry(e.key, e.value.toString())).toList();
    }
    if (olcek != null && olcek.isNotEmpty) {
      return olcek.entries.map((e) {
        final k = e.key;
        final v = e.value.toString();
        String birim = '';
        if (k.contains('kat') || k == 'kat') birim = ' kat';
        else if (k.contains('guc')) birim = ' kWp';
        else if (k.contains('birim')) birim = ' birim';
        else birim = ' m²';
        return MapEntry(k, '$v$birim');
      }).toList();
    }
    return [];
  }

  Future<void> _handleDetayClick(BuildContext context, String projeId, List<String> ihtiyacIds) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showBlockedDialog(context, 'Giriş yapmanız gerekiyor. Bu ilanların detayları sadece doğrulanmış profesyonellere açıktır.');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: _gold, strokeWidth: 1.5)),
    );

    try {
      final sonuc = await HugProMeslekEslestirmeServisi.checkProYetki(
        uid: user.uid,
        ihtiyacIds: ihtiyacIds,
      );

      if (!context.mounted) return;
      Navigator.pop(context);

      if (!sonuc.isAuthorized) {
        _showBlockedDialog(context, sonuc.failReason ?? 'Bu ilanın detaylarını görüntülemek için yeterli mesleki yetkinliğiniz bulunmamaktadır. İlan sadece ilgili alanda doğrulanmış profesyonellere açıktır.');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HugProDetaySayfasi(projeId: projeId),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      _showBlockedDialog(context, 'Yetki kontrolü sırasında hata: $e');
    }
  }

  void _showBlockedDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (c) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: _black,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Container(width: 16, height: 1, color: _gold),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('ERİŞİM KISITLI', style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: _black, border: Border.all(color: _gold.withOpacity(0.3))),
                    child: const Icon(Icons.lock, size: 14, color: _gold),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 12, height: 1.6, color: _black, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => Navigator.pop(c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: _black,
                    child: const Center(child: Text('ANLADIM', style: TextStyle(fontSize: 9, letterSpacing: 2, color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('hug_projects').orderBy('createdAt', descending: true).limit(10).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(color: _black, padding: const EdgeInsets.all(12), child: Text('HUG PROJE HATA: ${snapshot.error}', style: const TextStyle(color: Colors.white, fontSize: 10))),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(padding: EdgeInsets.all(20), child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 1.5, color: _gold))));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(width: double.infinity, color: Colors.white, padding: const EdgeInsets.all(16), child: const Text('Henüz HUG Proje ilanı yok - İlk ilanı sen ver', style: TextStyle(fontSize: 11, color: _gray))),
          );
        }

        final docs = snapshot.data!.docs.where((d) {
          final data = d.data() as Map<String, dynamic>;
          return data['status'] == 'PROFESYONEL_ARANIYOR' || data['status'] == null;
        }).toList();

        if (docs.isEmpty) return const SizedBox.shrink();

        if (isWeb) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch}, scrollbars: false),
            child: SizedBox(
              height: 560,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                cacheExtent: 1000,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: docs.length,
                itemBuilder: (context, index) => SizedBox(width: 400, child: _projeKarti(context, docs[index])),
              ),
            ),
          );
        } else {
          return Column(children: docs.map((d) => _projeKarti(context, d)).toList());
        }
      },
    );
  }

  Widget _projeKarti(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final yapiTuru = _formatYapiAdi(data['yapiTuruId'] ?? '-');
    final asama = data['asamaDisplay'] ?? data['asama'] ?? '-';
    final konum = data['konum'] as Map<String, dynamic>? ?? {};
    final il = konum['il'] ?? data['il'] ?? '';
    final ilce = konum['ilce'] ?? data['ilce'] ?? '';
    final olcek = data['olcek'] as Map<String, dynamic>?;
    final olcekBirimli = data['olcekBirimli'] as Map<String, dynamic>?;
    final olcekList = _parseOlcek(olcek, olcekBirimli);
    final ihtiyacIds = (data['ihtiyacIds'] as List?)?.cast<String>() ?? [];
    final aciklama = data['aciklama'] as String? ?? '';
    final fotoUrls = (data['fotoUrls'] as List?)?.cast<String>() ?? [];
    final createdAt = data['createdAt'] as Timestamp?;
    final detaylar = data['detaylar'] as Map<String, dynamic>?;
    final detaySayisi = detaylar?.length ?? 0;

    final musteriAdiRaw = data['musteriAdi'] as String? ??
        data['adSoyad'] as String? ??
        data['userDisplayName'] as String? ??
        data['displayName'] as String? ??
        data['musteriAdSoyad'] as String? ??
        data['musteriName'] as String?;
    final musteriId = data['musteriId'] as String? ?? data['userId'] as String? ?? data['uid'] as String? ?? data['ownerId'] as String?;

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 12),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.06))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: _black,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  Container(width: 20, height: 1, color: _gold),
                  const SizedBox(width: 8),
                  Expanded(child: Text('$il / $ilce'.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Text(_timeAgo(createdAt), style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 8, letterSpacing: 1)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 12, color: _gold),
                      const SizedBox(width: 6),
                      Flexible(
                        child: musteriAdiRaw != null && musteriAdiRaw.trim().isNotEmpty
                            ? Text(_maskName(musteriAdiRaw), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.3), overflow: TextOverflow.ellipsis)
                            : musteriId != null
                            ? FutureBuilder<String?>(
                          future: _fetchMusteriFromUserDoc(musteriId),
                          builder: (ctx, snap) {
                            if (!snap.hasData) return const Text('Müşteri', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
                            return Text(_maskName(snap.data), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.3), overflow: TextOverflow.ellipsis);
                          },
                        )
                            : Text(_maskName(musteriAdiRaw), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.3), overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Flexible(child: Text('$il / $ilce', style: const TextStyle(fontSize: 8, letterSpacing: 1, color: _gray), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _detayRow('YAPI', yapiTuru),
                  _detayRow('AŞAMA', asama.toString().toUpperCase()),
                  if (olcekList.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.06))),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: _black,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Row(
                              children: [
                                Container(width: 12, height: 1, color: _gold),
                                const SizedBox(width: 6),
                                const Expanded(child: Text('PROJE ÖLÇEKLERİ', style: TextStyle(color: Colors.white, fontSize: 7, letterSpacing: 1.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                          ...olcekList.map((entry) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.04)))),
                              child: Row(
                                children: [
                                  SizedBox(width: 95, child: Text(_olcekLabel(entry.key), style: const TextStyle(fontSize: 7, letterSpacing: 1, color: _gray, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                                  const SizedBox(width: 8),
                                  Container(width: 1, height: 12, color: Colors.black.withOpacity(0.1)),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.2), overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF7F5F0),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 16, height: 1, color: _gold),
                            const SizedBox(width: 8),
                            const Expanded(child: Text('PROJE İÇİN ARANAN PROFESYONELLER', style: TextStyle(fontSize: 7, letterSpacing: 1.5, color: _gray, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 8),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), color: _black, child: Text('${ihtiyacIds.length}', style: const TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.bold))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: ihtiyacIds.map((id) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.08))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Flexible(child: Text(_ihtiyacDisplay(id), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.3), overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (aciklama.isNotEmpty) ...[
                    Container(height: 1, color: Colors.black.withOpacity(0.06)),
                    const SizedBox(height: 10),
                    Text(aciklama, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, height: 1.5, color: Color(0xFF333333))),
                    const SizedBox(height: 10),
                    Container(height: 1, color: Colors.black.withOpacity(0.06)),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      if (fotoUrls.isNotEmpty)
                        GestureDetector(
                          onTap: () => _showGallery(context, fotoUrls),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6D6D6))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.photo_library, size: 12, color: _black),
                                const SizedBox(width: 6),
                                Flexible(child: Text('${fotoUrls.length} FOTOĞRAF', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () => _handleDetayClick(context, doc.id, ihtiyacIds),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(color: _gold, border: Border.all(color: _gold)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  detaySayisi > 0 ? 'DETAY ($detaySayisi ALAN) + TEKLİF VER' : 'DETAY + TEKLİF VER',
                                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1, color: _black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_outward, size: 12, color: _black),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detayRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 50, child: Text(label, style: const TextStyle(fontSize: 7, letterSpacing: 1, color: _gray))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 2)),
        ],
      ),
    );
  }

  void _showGallery(BuildContext context, List<String> urls) {
    showDialog(
      context: context,
      builder: (c) => Dialog(
        backgroundColor: _black,
        insetPadding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 500,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                color: _dark,
                child: Row(
                  children: [
                    const Expanded(child: Text('PROJE FOTOĞRAFLARI', style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    GestureDetector(onTap: () => Navigator.pop(c), child: const Icon(Icons.close, color: Colors.white, size: 18)),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: urls.length,
                  itemBuilder: (context, i) => CachedNetworkImage(
                    imageUrl: urls[i],
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(child: CircularProgressIndicator(color: _gold, strokeWidth: 1)),
                    errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.white24)),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                color: _dark,
                child: Text('${urls.length} foto - R2 CDN', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 8, letterSpacing: 1), textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
