
// lib/features/admin/screens/moderasyon_view.dart - V2 SADE - CONST UYUMLU - OPTIMIZE

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';

class ModerasyonView extends StatefulWidget {
  const ModerasyonView({super.key});

  @override
  State<ModerasyonView> createState() => _ModerasyonViewState();
}

class _ModerasyonViewState extends State<ModerasyonView> {
  static const Color primaryRed = Color(0xFFDC143C);
  static const Color cardBg = Color(0xFF1A1A1A);
  static const Color bgBlack = Color(0xFF0F0F0F);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgBlack,
      child: Column(
        children: [
          _buildSectionHeader("BLOKE UYGULANAN BÖLGELER", Icons.block),
          Expanded(
            flex: 2,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('settings')
                  .doc('moderasyon_ayarlari')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Colors.white30, strokeWidth: 2));
                }
                var data = snapshot.data!.data() as Map<String, dynamic>?;
                List<dynamic> bolgeler = List.from(data?['secili_bolgeler'] ?? []);

                if (bolgeler.isEmpty) {
                  return Column(
                    children: [
                      const Expanded(
                        child: Center(
                          child: Text("Henüz bloke bölge yok",
                              style: TextStyle(color: Colors.white30, fontSize: 12)),
                        ),
                      ),
                      _buildBlokeEkleButton(context),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bolgeler.length + 1,
                  itemBuilder: (context, i) {
                    if (i == bolgeler.length) {
                      return _buildBlokeEkleButton(context);
                    }
                    var b = bolgeler[i] as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white10)),
                      child: ListTile(
                        dense: true,
                        title: Text("${b['sehir_adi']}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            (b['ilceler'] as List? ?? []).map((e) => e['ad']).join(', '),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 10)),
                        trailing: IconButton(
                            icon: Icon(Icons.delete_forever,
                                color: primaryRed, size: 18),
                            onPressed: () => _bolgeSilOnay(context, bolgeler, i)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          _buildSectionHeader("ONAY BEKLEYEN İLANLAR", Icons.pending_actions),
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ilanlar')
                  .where('durum', isEqualTo: 'onay_bekliyor')
                  .orderBy('olusturma_tarihi', descending: true)
                  .limit(25)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Colors.white30, strokeWidth: 2));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white24, size: 32),
                        SizedBox(height: 8),
                        Text("Onay bekleyen ilan yok",
                            style: TextStyle(color: Colors.white30, fontSize: 12)),
                        Text("Tertemiz moruk!",
                            style: TextStyle(color: Colors.white24, fontSize: 10)),
                      ],
                    ),
                  );
                }
                var ilanlar = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: ilanlar.length,
                  itemBuilder: (context, i) {
                    var doc = ilanlar[i];
                    var data = doc.data() as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white10)),
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        title: Text(data['baslik'] ?? "Başlıksız İlan",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(data['konumMetin'] ?? data['adres'] ?? 'Konum yok',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 10)),
                            if (data['kategori_adi'] != null)
                              Text("${data['kategori_adi']}",
                                  style: const TextStyle(
                                      color: Colors.white30, fontSize: 9)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _actionBtn(
                                icon: Icons.check_circle,
                                color: Colors.green,
                                onTap: () => _ilanDurumDegis(doc.id, 'aktif')),
                            const SizedBox(width: 4),
                            _actionBtn(
                                icon: Icons.cancel,
                                color: primaryRed,
                                onTap: () => _ilanDurumDegis(doc.id, 'reddedildi')),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Row(children: [
      Icon(icon, color: primaryRed, size: 14),
      const SizedBox(width: 8),
      Flexible(
          child: Text(title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5)))
    ]),
  );

  Widget _buildBlokeEkleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton.icon(
        style: TextButton.styleFrom(foregroundColor: primaryRed),
        onPressed: () => _yeniBolgeEkleModal(context),
        icon: const Icon(Icons.add_location_alt, size: 16),
        label: const Text("BÖLGE BLOKE ET",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _bolgeSilOnay(BuildContext context, List<dynamic> bolgeler, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: cardBg,
        title: const Text("Blokeyi Kaldır?", style: TextStyle(color: Colors.white, fontSize: 14)),
        content: Text("${bolgeler[index]['sehir_adi']} blokesi kaldırılacak.",
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("İPTAL")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
              onPressed: () => Navigator.pop(c, true),
              child: const Text("KALDIR")),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final ref = FirebaseFirestore.instance.collection('settings').doc('moderasyon_ayarlari');
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snap = await tx.get(ref);
        var current = List.from((snap.data()?['secili_bolgeler'] ?? []));
        if (index < current.length) current.removeAt(index);
        tx.set(ref, {'secili_bolgeler': current}, SetOptions(merge: true));
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
      }
    }
  }

  Future<void> _ilanDurumDegis(String ilanId, String yeniDurum) async {
    try {
      await FirebaseFirestore.instance.collection('ilanlar').doc(ilanId).update({
        'durum': yeniDurum,
        'moderasyon_tarihi': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Moderasyon hata: $e");
    }
  }

  Future<void> _yeniBolgeEkleModal(BuildContext context) async {
    String? seciliSehirId;
    String? seciliSehirAdi;
    List<dynamic> seciliIlceler = [];
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text("Bölgeyi Bloke Et",
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            content: SizedBox(
                width: 320,
                height: 380,
                child: Column(children: [
                  FutureBuilder(
                      future: LocationService.loadSehirler(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const LinearProgressIndicator(color: primaryRed);
                        }
                        return DropdownButton<String>(
                          isExpanded: true,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          dropdownColor: const Color(0xFF222222),
                          value: seciliSehirId,
                          hint: const Text("Şehir Seç",
                              style: TextStyle(color: Colors.white30, fontSize: 12)),
                          items: (snap.data as List)
                              .map((s) => DropdownMenuItem(
                              value: s['sehir_id'].toString(),
                              child: Text(s['sehir_adi'])))
                              .toList(),
                          onChanged: (val) {
                            setDialogState(() {
                              seciliSehirId = val;
                              seciliIlceler = [];
                              var sehirler = snap.data as List;
                              seciliSehirAdi = sehirler.firstWhere((s) => s['sehir_id'].toString() == val)['sehir_adi'];
                            });
                          },
                        );
                      }),
                  const SizedBox(height: 12),
                  if (seciliSehirId != null)
                    Expanded(
                        child: FutureBuilder(
                            future: LocationService.loadIlceler(seciliSehirId!),
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${seciliIlceler.length} ilçe seçili",
                                      style: const TextStyle(color: Colors.white54, fontSize: 10)),
                                  const SizedBox(height: 6),
                                  Expanded(
                                    child: ListView(
                                        children: (snap.data as List)
                                            .map((i) => CheckboxListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(i['ilce_adi'],
                                              style: const TextStyle(
                                                  fontSize: 12, color: Colors.white)),
                                          activeColor: primaryRed,
                                          value: seciliIlceler.any((x) =>
                                          x['id'] == i['ilce_id'].toString()),
                                          onChanged: (v) => setDialogState(() {
                                            if (v!) {
                                              seciliIlceler.add({
                                                'id': i['ilce_id'].toString(),
                                                'ad': i['ilce_adi']
                                              });
                                            } else {
                                              seciliIlceler.removeWhere((x) =>
                                              x['id'] == i['ilce_id'].toString());
                                            }
                                          }),
                                        ))
                                            .toList()),
                                  ),
                                ],
                              );
                            }))
                ])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("İPTAL", style: TextStyle(fontSize: 11, color: Colors.white54))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
                onPressed: () async {
                  if (seciliSehirId == null) return;
                  try {
                    await FirebaseFirestore.instance
                        .collection('settings')
                        .doc('moderasyon_ayarlari')
                        .set({
                      'secili_bolgeler': FieldValue.arrayUnion([
                        {
                          'sehir_id': seciliSehirId,
                          'sehir_adi': seciliSehirAdi,
                          'ilceler': seciliIlceler,
                          'createdAt': FieldValue.serverTimestamp(),
                        }
                      ])
                    }, SetOptions(merge: true));
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
                    }
                  }
                },
                child: const Text("KAYDET", style: TextStyle(fontSize: 11, color: Colors.white)),
              )
            ],
          );
        }));
  }
}
