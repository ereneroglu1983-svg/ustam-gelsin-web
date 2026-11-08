// lib/features/hug_pro/profil/pro_profil_kartlari_listesi.dart
// PRO PROFIL KARTLARI LISTESI v1.3 - MÜŞTERİ PARA GÖRMEZ - ŞİKAYET / ENGELLE EKLENDİ - APPLE 1.2 / 5.1.1
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pro_profil_karti.dart';

const Color _black = Color(0xFF0B0B0B);
const Color _dark = Color(0xFF111111);
const Color _offWhite = Color(0xFFF7F5F0);
const Color _gold = Color(0xFFC8A45D);
const Color _gray = Color(0xFF8E8E8E);

class ProProfilKartlariListesiScreen extends StatefulWidget {
  final List<String> ihtiyacIds;
  final String? projeId;
  final Map<String, dynamic>? projeData;
  final String? davetId;
  final Map<String, dynamic>? valuation;

  const ProProfilKartlariListesiScreen({
    super.key,
    required this.ihtiyacIds,
    this.projeId,
    this.projeData,
    this.davetId,
    this.valuation,
  });

  @override
  State<ProProfilKartlariListesiScreen> createState() => _ProProfilKartlariListesiScreenState();
}

class _ProProfilKartlariListesiScreenState extends State<ProProfilKartlariListesiScreen> {
  final Set<String> _secilenProIds = {};
  final Map<String, Map<String, dynamic>> _secilenProData = {};
  final Set<String> _engellenenIds = {};
  bool _gonderiliyor = false;

  String _mapAltDalToServiceId(String altDalId) {
    final map = {
      '01.01': 'MIMARI_PROJE', '01.02': 'IC_MIMARI', '01.03': 'PEYZAJ',
      '01.04': 'RESTORASYON', '01.05': 'GORSELLESTIRME',
      '02.01': 'STATIK_PROJE', '02.02': 'MEKANIK_PROJE', '02.03': 'ELEKTRIK_PROJE',
      '02.04': 'ELEKTRIK_PROJE', '02.05': 'ZEMIN_ETUDU', '02.06': 'ZEMIN_ETUDU',
      '02.07': 'HARITA', '03.01': 'MUTEAHHIT', '04.01': 'PROJE_YONETIMI',
      '04.04': 'BIM', '05.01': 'YAPI_DENETIM', '08.01': 'CEPHE', '08.02': 'CATI',
      '08.03': 'YALITIM', '09.01': 'CELIK_YAPI', '11.01': 'ALTYAPI',
      '11.05': 'PEYZAJ_UYGULAMA', '12.02': 'GES_PROJE',
    };
    return map[altDalId] ?? altDalId;
  }

  int _getErisimUcreti(Map<String, dynamic> proData) {
    if (widget.valuation == null) return 0;
    final services = widget.valuation!['services'] as List? ?? [];
    final meslekler = proData['meslekler'] as List? ?? [];
    final Set<String> proAltIds = {};
    for (final m in meslekler) {
      if (m is Map) {
        final alt = (m['altDalId'] ?? '').toString();
        final unvan = (m['unvanId'] ?? '').toString();
        if (alt.isNotEmpty) proAltIds.add(alt);
        if (unvan.isNotEmpty) proAltIds.add(unvan);
      }
    }
    for (final svc in services) {
      if (svc['status'] != 'estimated') continue;
      final sid = (svc['service_id'] ?? '').toString();
      final sname = (svc['service_name'] ?? '').toString().toUpperCase();
      for (final altId in proAltIds) {
        final mapped = _mapAltDalToServiceId(altId);
        if (sid.contains(mapped) || mapped.contains(sid) || sname.contains(altId) || sid == altId) {
          return (svc['hug_access_fee_tl'] as num?)?.toInt() ?? 0;
        }
      }
    }
    if (services.isNotEmpty) {
      return (services.first['hug_access_fee_tl'] as num?)?.toInt() ?? 0;
    }
    return 0;
  }

  bool _proUygunMu(Map<String, dynamic> proData, List<String> ihtiyacIds) {
    final meslekler = proData['meslekler'] as List?;
    if (meslekler == null || meslekler.isEmpty) return false;
    final Set<String> proKodlari = {};
    for (final m in meslekler) {
      if (m is Map) {
        final ana = (m['anaDalId'] ?? '').toString();
        final alt = (m['altDalId'] ?? m['serviceId'] ?? '').toString();
        final unvan = (m['unvanId'] ?? '').toString();
        if (ana.isNotEmpty) proKodlari.add(ana);
        if (alt.isNotEmpty) {
          proKodlari.add(alt);
          proKodlari.add(_mapAltDalToServiceId(alt));
        }
        if (unvan.isNotEmpty) proKodlari.add(unvan);
        if (alt.contains('.')) proKodlari.add(alt.replaceAll('.', '_'));
      }
    }
    for (final ihtiyac in ihtiyacIds) {
      if (proKodlari.contains(ihtiyac)) return true;
      if (proKodlari.contains(ihtiyac.replaceAll('_', '.'))) return true;
      if (proKodlari.contains(ihtiyac.replaceAll('.', '_'))) return true;
    }
    return false;
  }

  // --- YENİ: ŞİKAYET ET ---
  Future<void> _sikayetEt(String proId) async {
    final sebepCtrl = TextEditingController();
    final sebep = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: _dark,
        title: const Text("Profesyoneli Şikayet Et", style: TextStyle(color: Colors.white, fontSize: 13)),
        content: TextField(controller: sebepCtrl, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Şikayet sebebini yaz...", hintStyle: TextStyle(color: Colors.white38), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("İptal", style: TextStyle(color: _gray))),
          TextButton(onPressed: () => Navigator.pop(c, sebepCtrl.text.trim()), child: const Text("GÖNDER", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
        ],
      ),
    );
    if (sebep == null || sebep.isEmpty) return;
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('sikayetler').add({
        'sikayetEdenId': uid,
        'sikayetEdilenId': proId,
        'projeId': widget.projeId ?? widget.davetId ?? 'GENEL',
        'tur': 'hug_pro',
        'sebep': sebep,
        'createdAt': FieldValue.serverTimestamp(),
        'durum': 'bekliyor',
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şikayetiniz alındı. İnceleyeceğiz.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  // --- YENİ: ENGELLE ---
  Future<void> _engelle(String proId) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: _dark,
        title: const Text("Profesyoneli Engelle", style: TextStyle(color: Colors.white, fontSize: 13)),
        content: const Text("Bu profesyoneli engellemek istiyor musun? Artık sana teklif gönderemeyecek ve listede görünmeyecek.", style: TextStyle(color: Colors.white70, fontSize: 11)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("İptal", style: TextStyle(color: _gray))),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text("ENGELLE", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
        ],
      ),
    );
    if (onay != true) return;
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('engellenenler').add({
        'engelleyenId': uid,
        'engellenenId': proId,
        'projeId': widget.projeId ?? widget.davetId ?? 'GENEL',
        'tur': 'hug_pro',
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() {
        _engellenenIds.add(proId);
        _secilenProIds.remove(proId);
        _secilenProData.remove(proId);
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profesyonel engellendi.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  Future<void> _talepleriGonder() async {
    if (_secilenProIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("En az 1 profesyonel seç", style: TextStyle(color: Colors.white)), backgroundColor: _black));
      return;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => _gonderiliyor = true);
    try {
      final fs = FirebaseFirestore.instance;
      final batch = fs.batch();
      final musteriDoc = await fs.collection('users').doc(uid).get();
      final musteriAdi = (musteriDoc.data()?['displayName'] ?? musteriDoc.data()?['ad'] ?? 'Müşteri').toString();

      if (widget.davetId != null) {
        final masterRef = fs.collection('hug_pro_ozel_davetler').doc(widget.davetId);
        batch.update(masterRef, {
          'davetEdilenProIds': FieldValue.arrayUnion(_secilenProIds.toList()),
          'guncellenmeTarihi': FieldValue.serverTimestamp(),
        });
      }

      for (final proId in _secilenProIds) {
        final existing = await fs.collection('hug_pro_ozel_davetler').where('musteriId', isEqualTo: uid).where('proId', isEqualTo: proId).where('projeId', isEqualTo: widget.projeId ?? widget.davetId ?? 'GENEL').limit(1).get();
        final zatenVar = existing.docs.isNotEmpty;
        final davetRef = fs.collection('hug_pro_ozel_davetler').doc();
        final erisimUcreti = _getErisimUcreti(_secilenProData[proId] ?? {});

        batch.set(davetRef, {
          'davetId': davetRef.id,
          'parentDavetId': widget.davetId,
          'musteriId': uid,
          'musteriAdi': musteriAdi,
          'proId': proId,
          'projeId': widget.projeId ?? widget.davetId ?? 'GENEL',
          'projeData': widget.projeData,
          'ihtiyacIds': widget.ihtiyacIds,
          'valuation': widget.valuation,
          'erisimUcreti': erisimUcreti,
          'erisimUcretiAciklama': '${erisimUcreti} TL Teklif Erişim Ücreti',
          'durum': 'BEKLEMEDE',
          'zatenErisimVar': zatenVar,
          'olusturmaTarihi': FieldValue.serverTimestamp(),
          'bildirimGonderildi': false,
        });

        final bildirimRef = fs.collection('users_pro').doc(proId).collection('bildirimler').doc();
        batch.set(bildirimRef, {
          'bildirimId': bildirimRef.id,
          'tip': 'OZEL_DAVET',
          'baslik': 'İŞ VAR - MÜŞTERİ SENİ SEÇTİ',
          'mesaj': '$musteriAdi sana doğrudan talep gönderdi. ${erisimUcreti > 0 ? "$erisimUcreti TL erişim bedeli ile" : ""} Erişim bedelini öde veya bedava hakkını kullan.',
          'musteriId': uid,
          'projeId': widget.projeId ?? widget.davetId ?? 'GENEL',
          'davetId': davetRef.id,
          'parentDavetId': widget.davetId,
          'erisimUcreti': erisimUcreti,
          'okundu': false,
          'olusturmaTarihi': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${_secilenProIds.length} profesyonele talep gönderildi", style: const TextStyle(color: Colors.white)), backgroundColor: _black));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _gonderiliyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _offWhite,
      appBar: AppBar(
        backgroundColor: _black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('PROFESYONELLER', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 3, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            width: double.infinity,
            color: _black,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 20, height: 1, color: _gold),
                    const SizedBox(width: 8),
                    Expanded(child: Text("${widget.ihtiyacIds.length} SEÇİLEN MESLEKTEKİ PROFESYONELLER • SINIRSIZ SEÇİM", style: const TextStyle(color: Colors.white70, fontSize: 8, letterSpacing: 1.2), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(border: Border.all(color: _gold.withOpacity(0.4))),
                      child: Text("${_secilenProIds.length} SEÇİLDİ", style: const TextStyle(color: _gold, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ],
                ),
                if (widget.valuation != null) ...[
                  const SizedBox(height: 6),
                  Text("TOPLAM TAHMİN: ${widget.valuation!['total']?['estimated_tl'] ?? 0} TL • PRO SAYISI SINIRSIZ", style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 7, letterSpacing: 1)),
                ],
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(height: 1, color: _gold.withOpacity(0.6)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users_pro').where('isActive', isEqualTo: true).where('isVerified', isEqualTo: true).where('durum', isEqualTo: 'ONAYLANDI').snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _gold, strokeWidth: 1.5));
                if (snap.hasError) return Center(child: Text("HATA: ${snap.error}", style: const TextStyle(fontSize: 10, color: _gray)));
                if (!snap.hasData || snap.data!.docs.isEmpty) return const Center(child: Text("UYGUN PROFESYONEL BULUNAMADI", style: TextStyle(fontSize: 11, color: _gray)));

                final uygunProlar = snap.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (_engellenenIds.contains(doc.id)) return false;
                  return _proUygunMu(data, widget.ihtiyacIds);
                }).toList();

                if (uygunProlar.isEmpty) {
                  return Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _gold.withOpacity(0.4))), child: const Icon(Icons.search_off, size: 28, color: _gold)),
                      const SizedBox(height: 12),
                      const Text("BU MESLEKLERDE PRO YOK", style: TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold, color: _black)),
                      const SizedBox(height: 6),
                      Text(widget.ihtiyacIds.join(", "), style: const TextStyle(fontSize: 8, color: _gray)),
                    ]),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: uygunProlar.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final doc = uygunProlar[i];
                    final proId = doc.id;
                    final data = doc.data() as Map<String, dynamic>;
                    final isSelected = _secilenProIds.contains(proId);
                    return Column(
                      children: [
                        ProProfilKarti(
                          proData: {...data, 'id': proId},
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _secilenProIds.remove(proId);
                                _secilenProData.remove(proId);
                              } else {
                                _secilenProIds.add(proId);
                                _secilenProData[proId] = {...data, 'id': proId};
                              }
                            });
                          },
                          onSelectChanged: () {
                            setState(() {
                              if (isSelected) {
                                _secilenProIds.remove(proId);
                                _secilenProData.remove(proId);
                              } else {
                                _secilenProIds.add(proId);
                                _secilenProData[proId] = {...data, 'id': proId};
                              }
                            });
                          },
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _sikayetEt(proId),
                                icon: const Icon(Icons.flag_outlined, size: 13, color: Colors.orange),
                                label: const Text("Şikayet Et", style: TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600)),
                                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(0, 28), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                              ),
                              const SizedBox(width: 4),
                              TextButton.icon(
                                onPressed: () => _engelle(proId),
                                icon: const Icon(Icons.block, size: 13, color: Colors.red),
                                label: const Text("Engelle", style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.w600)),
                                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(0, 28), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black.withOpacity(0.08)))),
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: _gonderiliyor ? null : _talepleriGonder,
              child: Container(
                width: double.infinity,
                color: _secilenProIds.isEmpty ? _gray : _black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_gonderiliyor) const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: _gold, strokeWidth: 1.5)) else Container(width: 14, height: 1, color: _gold),
                    const SizedBox(width: 8),
                    Text(_gonderiliyor ? "GÖNDERİLİYOR..." : _secilenProIds.isEmpty ? "PROFESYONEL SEÇ - SINIRSIZ" : "${_secilenProIds.length} PRO'YA TALEP GÖNDER - SINIRSIZ", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}