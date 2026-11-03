import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

const _black = Color(0xFF0B0B0B);
const _gold = Color(0xFFC8A45D);
const _offWhite = Color(0xFFF7F5F0);
const _gray = Color(0xFF8E8E8E);

class HugProAdminScreen extends StatefulWidget {
  const HugProAdminScreen({super.key});
  @override
  State<HugProAdminScreen> createState() => _HugProAdminScreenState();
}

class _HugProAdminScreenState extends State<HugProAdminScreen> {
  String? _acikOlanUid; // hangi kart açık

  Future<void> _onayla(String uid, Map<String, dynamic> data) async {
    final batch = FirebaseFirestore.instance.batch();
    final proRef = FirebaseFirestore.instance.collection('users_pro').doc(uid);
    final bekleyenRef = FirebaseFirestore.instance.collection('admin_onay_bekleyenler').doc(uid);

    final belgeler = (data['belgeler'] as List?) ?? [];
    final guncelBelgeler = belgeler.map((b) {
      final m = Map<String, dynamic>.from(b as Map);
      m['dogrulamaDurumu'] = 'ONAYLANDI';
      m['aktifYetki'] = true;
      return m;
    }).toList();

    batch.update(proRef, {
      'durum': 'ONAYLANDI', 'isActive': true, 'isVerified': true,
      'belgeler': guncelBelgeler,
      'onayTarihi': FieldValue.serverTimestamp(),
    });
    batch.delete(bekleyenRef);

    // TEK BİLDİRİM
    final notifId = '${uid}_${DateTime.now().millisecondsSinceEpoch}';
    batch.set(FirebaseFirestore.instance.collection('notifications').doc(notifId), {
      'uid': uid, 'type': 'PROFESYONEL_ONAY', 'title': 'Profesyonel Hesabınız Onaylandı!',
      'body': 'HUG PROJE hesabınız aktif.', 'isRead': false, 'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    setState(() => _acikOlanUid = null);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Onaylandı'), backgroundColor: _gold));
  }

  Future<void> _reddet(String uid) async {
    await FirebaseFirestore.instance.collection('users_pro').doc(uid).update({'durum': 'REDDEDILDI', 'isActive': false});
    await FirebaseFirestore.instance.collection('admin_onay_bekleyenler').doc(uid).delete();
    setState(() => _acikOlanUid = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      appBar: AppBar(backgroundColor: _black, title: const Text('HUG PRO / BEKLEYENLER', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 3)), iconTheme: const IconThemeData(color: Colors.white)),
      body: Column(
        children: [
          Container(height: 1, color: _gold.withOpacity(0.6)),
          Expanded(
            child: Container(
              color: _offWhite,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users_pro').where('durum', isEqualTo: 'ONAY_BEKLIYOR').snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) return const Center(child: CircularProgressIndicator(color: _gold));
                  if (snap.data!.docs.isEmpty) return const Center(child: Text('BEKLEYEN YOK', style: TextStyle(color: _gray, letterSpacing: 2, fontSize: 10)));

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context, i) {
                      final doc = snap.data!.docs[i];
                      final data = doc.data() as Map<String, dynamic>;
                      final uid = doc.id;
                      final isAcik = _acikOlanUid == uid;
                      final meslekler = (data['meslekler'] as List?) ?? [];
                      final belgeler = (data['belgeler'] as List?) ?? [];
                      final isim = '${data['ad'] ?? data['sirketUnvan'] ?? ''} ${data['soyad'] ?? ''}'.trim();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: isAcik ? _gold : Colors.black12, width: isAcik ? 1.2 : 0.8)),
                        child: Column(
                          children: [
                            // ÜST - İSİM SATIRI - TIKLANIR
                            InkWell(
                              onTap: () => setState(() => _acikOlanUid = isAcik ? null : uid),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: data['profilFotoUrl'] != null
                                          ? CachedNetworkImage(imageUrl: data['profilFotoUrl'], width: 44, height: 44, fit: BoxFit.cover, errorWidget: (_,__,___) => Container(width: 44, height: 44, color: Colors.black12, child: const Icon(Icons.person, size: 18)))
                                          : Container(width: 44, height: 44, color: Colors.black12, child: const Icon(Icons.person, size: 18)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(isim, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                        Text(data['email'] ?? '', style: const TextStyle(fontSize: 10, color: _gray)),
                                        const SizedBox(height: 4),
                                        Wrap(spacing: 4, children: meslekler.take(2).map<Widget>((m) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(border: Border.all(color: _gold.withOpacity(0.3))), child: Text('${m['anaDalId']}', style: const TextStyle(fontSize: 7)))).toList()),
                                      ]),
                                    ),
                                    Icon(isAcik ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 18, color: _gray),
                                  ],
                                ),
                              ),
                            ),

                            // AÇILIR KISIM - DETAY
                            if (isAcik) ...[
                              Container(height: 1, color: Colors.black12),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('KİMLİK / VERGİ', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                                  const SizedBox(height: 8),
                                  Text('Tip: ${data['kayitTipi']} | TC: ${data['tcMasked'] ?? '-'}', style: const TextStyle(fontSize: 10)),
                                  Text('Vergi: ${data['vergiNo'] ?? '-'} / ${data['vergiDairesi'] ?? ''} | MERSİS: ${data['mersisNo'] ?? '-'}', style: const TextStyle(fontSize: 10)),
                                  Text('Şirket: ${data['sirketUnvan'] ?? '-'} | Yetkili: ${data['yetkiliAdSoyad'] ?? '-'}', style: const TextStyle(fontSize: 10)),
                                  const SizedBox(height: 8),
                                  Text('Tel: ${data['telefon'] ?? ''} | Adres: ${data['adres'] ?? ''}', style: const TextStyle(fontSize: 10, color: _gray)),

                                  const SizedBox(height: 16),
                                  Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('MESLEK (58 UNVAN)', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                                  const SizedBox(height: 8),
                                  ...meslekler.map((m) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('${m['anaDalId']}/${m['altDalId']} - ${m['unvanId']} | Uz: ${(m['uzmanlikIds'] as List?)?.join(',') ?? '-'}', style: const TextStyle(fontSize: 9)))),

                                  const SizedBox(height: 16),
                                  Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('BELGELER R2', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                                  const SizedBox(height: 8),
                                  ...belgeler.map((b) => Container(margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(border: Border.all(color: Colors.black12)), child: Column(children: [
                                    CachedNetworkImage(imageUrl: b['belgeUrl'] ?? '', width: double.infinity, height: 160, fit: BoxFit.cover, errorWidget: (_,__,___) => Container(height: 160, color: Colors.black12, child: const Icon(Icons.image))),
                                    Padding(padding: const EdgeInsets.all(8), child: Row(children: [Expanded(child: Text('${b['belgeTuru']} - No:${b['belgeNo']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))), Text(b['dogrulamaDurumu'] ?? 'BEKLEMEDE', style: const TextStyle(fontSize: 7))])),
                                  ]))),

                                  const SizedBox(height: 16),
                                  Row(children: [
                                    Expanded(child: GestureDetector(onTap: () => _reddet(uid), child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(border: Border.all(color: Colors.black12)), child: const Center(child: Text('REDDET', style: TextStyle(fontSize: 10, letterSpacing: 1.5)))))),
                                    const SizedBox(width: 8),
                                    Expanded(child: GestureDetector(onTap: () => _onayla(uid, data), child: Container(padding: const EdgeInsets.symmetric(vertical: 14), color: _gold, child: const Center(child: Text('ONAYLA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _black, letterSpacing: 1.5)))))),
                                  ]),
                                ]),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}