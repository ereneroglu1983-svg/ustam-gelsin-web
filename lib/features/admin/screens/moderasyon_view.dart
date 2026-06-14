// lib/features/admin/screens/moderasyon_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';

class ModerasyonView extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AdService _adService = AdService();
  final String _adminUstaUid = "xCFUejsM5fOnXW8WnNwdKGwLtxE3";

  ModerasyonView({super.key});

  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader("BLOKE UYGULANAN BÖLGELER", Icons.block),
        Expanded(
          flex: 2,
          child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('settings').doc('moderasyon_ayarlari').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 2));
              var data = snapshot.data!.data() as Map<String, dynamic>?;
              List<dynamic> bolgeler = data?['secili_bolgeler'] ?? [];

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bolgeler.length + 1,
                itemBuilder: (context, i) {
                  if (i == bolgeler.length) {
                    return TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: primaryRed),
                      onPressed: () => _yeniBolgeEkleModal(context),
                      icon: const Icon(Icons.add, size: 16), label: const Text("BÖLGE BLOKE ET", style: TextStyle(fontSize: 11)),
                    );
                  }
                  var b = bolgeler[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(6)),
                    child: ListTile(
                      dense: true,
                      title: Text("${b['sehir_adi']}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      subtitle: Text(b['ilceler'].map((i) => i['ad']).join(', '), overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                      trailing: IconButton(icon: Icon(Icons.delete, color: primaryRed, size: 16), onPressed: () {
                        bolgeler.removeAt(i);
                        _firestore.collection('settings').doc('moderasyon_ayarlari').update({'secili_bolgeler': bolgeler});
                      }),
                    ),
                  );
                },
              );
            },
          ),
        ),
        _buildSectionHeader("ONAY BEKLEYEN İLANLAR", Icons.pending_actions),
        Expanded(
          flex: 3,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('ilanlar').where('durum', isEqualTo: 'onay_bekliyor').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 2));
              var ilanlar = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ilanlar.length,
                itemBuilder: (context, i) {
                  var data = ilanlar[i].data() as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(6)),
                    child: ListTile(
                      dense: true,
                      title: Text(data['baslik'] ?? "İlan", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      subtitle: Text(data['konumMetin'] ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.local_offer, color: Colors.amber, size: 16), onPressed: () => _teklifVer(context, ilanlar[i].id)),
                          IconButton(icon: const Icon(Icons.check_circle, color: Colors.green, size: 16), onPressed: () => _firestore.collection('ilanlar').doc(ilanlar[i].id).update({'durum': 'aktif'})),
                          IconButton(icon: Icon(Icons.cancel, color: primaryRed, size: 16), onPressed: () => _firestore.collection('ilanlar').doc(ilanlar[i].id).update({'durum': 'reddedildi'})),
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
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Row(children: [
      Icon(icon, color: primaryRed, size: 14),
      const SizedBox(width: 8),
      Flexible(child: Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))
    ]),
  );

  Future<void> _teklifVer(BuildContext context, String ilanId) async {
    try {
      // REVİZE UYGULANDI: Sehir parametresi kaldırıldı.
      await _adService.teklifVerVeBakiyeDus(
        ilanId: ilanId,
        ustaId: _adminUstaUid,
        teklifFiyat: 0.0,
        mesaj: "Yetkili usta teklifi.",
        komisyonTutari: 0.0,
        isMuaf: true,
        kategoriId: "admin_teklifi",
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teklif iletildi.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  Future<void> _yeniBolgeEkleModal(BuildContext context) async {
    String? seciliSehirId;
    List<dynamic> seciliIlceler = [];
    showDialog(context: context, builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
      return AlertDialog(
        backgroundColor: cardBg,
        title: const Text("Bölgeyi Bloke Et", style: TextStyle(color: Colors.white, fontSize: 14)),
        content: SizedBox(width: 300, height: 350, child: Column(children: [
          FutureBuilder(future: LocationService.loadSehirler(), builder: (context, snap) {
            if (!snap.hasData) return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2));
            return DropdownButton<String>(
              isExpanded: true, style: const TextStyle(fontSize: 12, color: Colors.white), dropdownColor: cardBg,
              value: seciliSehirId, hint: const Text("Şehir Seç", style: TextStyle(color: Colors.white30, fontSize: 12)),
              items: (snap.data as List).map((s) => DropdownMenuItem(value: s['sehir_id'].toString(), child: Text(s['sehir_adi']))).toList(),
              onChanged: (val) { setDialogState(() { seciliSehirId = val; seciliIlceler = []; }); },
            );
          }),
          if (seciliSehirId != null) Expanded(child: FutureBuilder(future: LocationService.loadIlceler(seciliSehirId!), builder: (context, snap) {
            if (!snap.hasData) return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2));
            return ListView(children: (snap.data as List).map((i) => CheckboxListTile(
              dense: true, title: Text(i['ilce_adi'], style: const TextStyle(fontSize: 12, color: Colors.white)),
              activeColor: primaryRed, value: seciliIlceler.any((x) => x['id'] == i['ilce_id'].toString()),
              onChanged: (v) => setDialogState(() {
                if (v!) seciliIlceler.add({'id': i['ilce_id'].toString(), 'ad': i['ilce_adi']});
                else seciliIlceler.removeWhere((x) => x['id'] == i['ilce_id'].toString());
              }),
            )).toList());
          }))
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İPTAL", style: TextStyle(fontSize: 11))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
            onPressed: () async {
              if (seciliSehirId == null) return;
              var sehirler = await LocationService.loadSehirler();
              var sehirAdi = sehirler.firstWhere((s) => s['sehir_id'].toString() == seciliSehirId)['sehir_adi'];
              await _firestore.collection('settings').doc('moderasyon_ayarlari').set({
                'secili_bolgeler': FieldValue.arrayUnion([{'sehir_id': seciliSehirId, 'sehir_adi': sehirAdi, 'ilceler': seciliIlceler}])
              }, SetOptions(merge: true));
              Navigator.pop(context);
            },
            child: const Text("KAYDET", style: TextStyle(fontSize: 11)),
          )
        ],
      );
    }));
  }
}