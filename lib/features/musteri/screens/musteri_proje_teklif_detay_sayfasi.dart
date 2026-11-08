// lib/features/musteri/screens/musteri_proje_teklif_detay_sayfasi.dart - YENİ - PRO TEKLİFLERİ + KABUL / RED / ENGELLE / ŞİKAYET
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/features/chat/screens/chat_detay_sayfasi.dart';

class MusteriProjeTeklifDetaySayfasi extends StatelessWidget {
  final String projeId;
  final Map<String, dynamic> projeData;
  const MusteriProjeTeklifDetaySayfasi({super.key, required this.projeId, required this.projeData});

  Future<void> _teklifKabulEt(BuildContext context, String teklifId) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF203A43),
        title: const Text("Teklifi Onayla", style: TextStyle(color: Colors.white)),
        content: const Text("Bu profesyonelin teklifini onaylıyor musun? Diğer teklifler otomatik reddedilecek.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("İptal")),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text("ONAYLA", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))),
        ],
      ),
    );
    if (onay != true) return;
    try {
      final batch = FirebaseFirestore.instance.batch();
      final hepsi = await FirebaseFirestore.instance.collection('hug_pro_teklifler').where('projeId', isEqualTo: projeId).get();
      for (var d in hepsi.docs) {
        batch.update(d.reference, {'durum': d.id == teklifId ? 'ONAYLANDI' : 'REDDEDILDI'});
      }
      batch.update(FirebaseFirestore.instance.collection('hug_projects').doc(projeId), {'status': 'ONAYLANDI'});
      await batch.commit();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teklif onaylandı. Pro Onaylanan Teklifler'e taşındı.")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  Future<void> _teklifReddet(BuildContext context, String teklifId) async {
    try {
      await FirebaseFirestore.instance.collection('hug_pro_teklifler').doc(teklifId).update({'durum': 'REDDEDILDI'});
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teklif reddedildi.")));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  Future<void> _sikayetEt(BuildContext context, String proId, String teklifId) async {
    final sebepCtrl = TextEditingController();
    final sebep = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF203A43),
        title: const Text("Profesyoneli Şikayet Et", style: TextStyle(color: Colors.white)),
        content: TextField(controller: sebepCtrl, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Şikayet sebebini yaz...", hintStyle: TextStyle(color: Colors.white38), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("İptal")),
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
        'teklifId': teklifId,
        'projeId': projeId,
        'tur': 'hug_pro',
        'sebep': sebep,
        'createdAt': FieldValue.serverTimestamp(),
        'durum': 'bekliyor',
      });
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şikayetiniz alındı. İnceleyeceğiz.")));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  Future<void> _engelle(BuildContext context, String proId, String teklifId) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF203A43),
        title: const Text("Profesyoneli Engelle", style: TextStyle(color: Colors.white)),
        content: const Text("Bu profesyoneli engellemek istiyor musun? Artık sana teklif gönderemeyecek.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("İptal")),
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
        'teklifId': teklifId,
        'projeId': projeId,
        'tur': 'hug_pro',
        'createdAt': FieldValue.serverTimestamp(),
      });
      await FirebaseFirestore.instance.collection('hug_pro_teklifler').doc(teklifId).update({'durum': 'REDDEDILDI'});
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profesyonel engellendi.")));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final yapi = (projeData['yapiTuruDisplay'] ?? projeData['yapiTuruId'] ?? 'PROJE').toString();
    final asama = (projeData['asamaDisplay'] ?? projeData['asama'] ?? '').toString();
    final konum = projeData['konum'] as Map<String, dynamic>?;
    final il = (konum?['il'] ?? '').toString();
    final ilce = (konum?['ilce'] ?? '').toString();

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("Proje Teklifleri", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFC8A45D).withOpacity(0.3))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFC8A45D), borderRadius: BorderRadius.circular(4)), child: const Text("PROJE İLANI", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold))),
                const SizedBox(height: 10),
                Text(yapi.replaceAll('_', ' / ').toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("$asama • $il / $ilce", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                if ((projeData['aciklama'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(projeData['aciklama'].toString(), style: const TextStyle(color: Colors.white60, fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('hug_pro_teklifler').where('projeId', isEqualTo: projeId).orderBy('olusturmaTarihi', descending: true).snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFC8A45D)));
                }
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text("Henüz bu projeye teklif gelmedi.\nPro'lar teklif verince burada görünecek.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70))));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (context, i) {
                    final doc = snap.data!.docs[i];
                    final t = doc.data() as Map<String, dynamic>;
                    return _ProTeklifKarti(
                      teklifId: doc.id,
                      teklif: t,
                      onKabul: () => _teklifKabulEt(context, doc.id),
                      onRed: () => _teklifReddet(context, doc.id),
                      onSikayet: () => _sikayetEt(context, (t['profesyonelId'] ?? t['proId'] ?? '').toString(), doc.id),
                      onEngel: () => _engelle(context, (t['profesyonelId'] ?? t['proId'] ?? '').toString(), doc.id),
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
}

class _ProTeklifKarti extends StatelessWidget {
  final String teklifId;
  final Map<String, dynamic> teklif;
  final VoidCallback onKabul;
  final VoidCallback onRed;
  final VoidCallback onSikayet;
  final VoidCallback onEngel;
  const _ProTeklifKarti({required this.teklifId, required this.teklif, required this.onKabul, required this.onRed, required this.onSikayet, required this.onEngel});

  @override
  Widget build(BuildContext context) {
    final proId = (teklif['profesyonelId'] ?? teklif['proId'] ?? '').toString();
    final bedel = teklif['teklifBedeli'] ?? 0;
    final not = (teklif['teklifNotu'] ?? '').toString();
    final durum = (teklif['durum'] ?? 'BEKLEMEDE').toString();
    final serviceId = (teklif['serviceId'] ?? '').toString();

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users_pro').doc(proId).get(),
      builder: (context, proSnap) {
        final proData = proSnap.data?.data() as Map<String, dynamic>?;
        String proAd = "PROFESYONEL";
        String meslek = serviceId.replaceAll('_', ' ').toLowerCase();
        if (proData != null) {
          if (proData['hesapTuru'] == 'SIRKET') {
            final s = (proData['sirketAdi'] ?? proData['firmaAdi'] ?? '').toString();
            proAd = s.length > 3 ? "${s.substring(0, 3).toUpperCase()}...." : s;
          } else {
            final ad = (proData['ad'] ?? proData['firstName'] ?? '').toString();
            final soyad = (proData['soyad'] ?? proData['lastName'] ?? '').toString();
            proAd = soyad.isNotEmpty ? "$ad ${soyad[0].toUpperCase()}...." : ad;
          }
          final meslekler = proData['meslekler'];
          if (meslekler is List && meslekler.isNotEmpty && meslekler.first is Map) {
            meslek = (meslekler.first['anaDalId'] ?? serviceId).toString().replaceAll('_', ' ');
          }
        }
        final puan = (proData?['ortalamaPuan'] ?? proData?['puan'] ?? 0).toString();
        final tamamlanan = (proData?['tamamlananProjeSayisi'] ?? 0).toString();
        final foto = (proData?['profilFotoUrl'] ?? proData?['fotoUrl'] ?? '').toString();

        Color durumRenk = Colors.amber;
        if (durum == 'ONAYLANDI') durumRenk = Colors.greenAccent;
        if (durum == 'REDDEDILDI') durumRenk = Colors.redAccent;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: foto.isNotEmpty ? NetworkImage(foto) : null,
                      child: foto.isEmpty ? const Icon(Icons.person, color: Colors.grey) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(proAd, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black))),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: durumRenk.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text(durum, style: TextStyle(color: durumRenk, fontSize: 9, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(meslek, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 12, color: Color(0xFFC8A45D)),
                              const SizedBox(width: 3),
                              Text("$puan • $tamamlanan iş", style: const TextStyle(fontSize: 11, color: Colors.black54)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("$bedel TL", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                          if (not.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(not, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.black54),
                      onSelected: (v) {
                        if (v == 'sikayet') onSikayet();
                        if (v == 'engel') onEngel();
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'sikayet', child: Row(children: [Icon(Icons.flag, size: 16, color: Colors.orange), SizedBox(width: 8), Text("Şikayet Et")])),
                        PopupMenuItem(value: 'engel', child: Row(children: [Icon(Icons.block, size: 16, color: Colors.red), SizedBox(width: 8), Text("Engelle")])),
                      ],
                    ),
                  ],
                ),
              ),
              if (durum == 'BEKLEMEDE')
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onKabul,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Text("KABUL ET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onRed,
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Text("REDDET", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetaySayfasi(ustaAd: proAd, ustaId: proId, ilanId: (teklif['projeId'] ?? '').toString())));
                        },
                        icon: const Icon(Icons.message, color: Colors.blue),
                        tooltip: "Mesajlaş",
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}