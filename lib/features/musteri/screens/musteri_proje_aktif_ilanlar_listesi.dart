// lib/features/musteri/screens/musteri_proje_aktif_ilanlar_listesi.dart - YENİ - HUG PROJE
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'musteri_proje_teklif_detay_sayfasi.dart';

class MusteriProjeAktifIlanlarListesi extends StatelessWidget {
  const MusteriProjeAktifIlanlarListesi({super.key});

  Future<void> _ilaniSil(BuildContext context, String projeId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF203A43),
        title: const Text("Proje İlanını Sil", style: TextStyle(color: Colors.white)),
        content: const Text("Bu proje ilanını silmek istediğinize emin misiniz? Tüm teklifler reddedilecek.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("İptal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("SİL", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final batch = FirebaseFirestore.instance.batch();
      final teklifler = await FirebaseFirestore.instance.collection('hug_pro_teklifler').where('projeId', isEqualTo: projeId).get();
      for (var doc in teklifler.docs) {
        batch.update(doc.reference, {'durum': 'REDDEDILDI'});
      }
      batch.delete(FirebaseFirestore.instance.collection('hug_projects').doc(projeId));
      await batch.commit();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Proje ilanı ve teklifler kaldırıldı.")));
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  String _formatYapi(String raw) {
    return raw.replaceAll('_', ' / ').replaceAll('TICARI', 'TİCARİ');
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hug_projects')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'PROFESYONEL_ARANIYOR')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC8A45D)));
        }
        if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}", style: const TextStyle(color: Colors.white70)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz aktif proje ilanınız yok.", style: TextStyle(color: Colors.white70)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildProjeKarti(context, data, doc.id);
          },
        );
      },
    );
  }

  Widget _buildProjeKarti(BuildContext context, Map<String, dynamic> data, String projeId) {
    final yapi = (data['yapiTuruDisplay'] ?? data['yapiTuruId'] ?? 'PROJE').toString();
    final asama = (data['asamaDisplay'] ?? data['asama'] ?? '').toString();
    final konum = data['konum'] as Map<String, dynamic>?;
    final il = (konum?['il'] ?? data['il'] ?? '').toString();
    final ilce = (konum?['ilce'] ?? data['ilce'] ?? '').toString();
    final aciklama = (data['aciklama'] ?? '').toString();
    final ihtiyacIds = (data['ihtiyacIds'] as List?)?.length ?? 0;
    final fotoUrls = (data['fotoUrls'] as List?)?.cast<String>() ?? [];
    final olcek = data['olcekBirimli'] as Map<String, dynamic>? ?? data['olcek'] as Map<String, dynamic>?;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC8A45D).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MusteriProjeTeklifDetaySayfasi(projeId: projeId, projeData: data))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFC8A45D), borderRadius: BorderRadius.circular(4)),
                        child: const Text("PROJE İLANI", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), borderRadius: BorderRadius.circular(4)),
                        child: const Text("YAYINDA", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: Colors.white38),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_formatYapi(yapi).toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(asama, style: const TextStyle(color: Color(0xFFC8A45D), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.orangeAccent),
                      const SizedBox(width: 4),
                      Expanded(child: Text("$il / $ilce", style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 12),
                      const Icon(Icons.people, size: 14, color: Color(0xFFC8A45D)),
                      const SizedBox(width: 4),
                      Text("$ihtiyacIds ihtiyaç", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  if (olcek != null && olcek.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 6,
                      children: olcek.entries.map((e) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                        child: Text("${e.key}: ${e.value}", style: const TextStyle(color: Colors.white60, fontSize: 11)),
                      )).toList(),
                    ),
                  ],
                  if (aciklama.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(aciklama, style: const TextStyle(color: Colors.white70, fontSize: 13), maxLines: 3, overflow: TextOverflow.ellipsis),
                  ],
                  if (fotoUrls.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: fotoUrls.length > 3 ? 3 : fotoUrls.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(fotoUrls[i], width: 100, height: 70, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 100, height: 70, color: Colors.white10, child: const Icon(Icons.image, color: Colors.white24))),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Row(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('hug_pro_teklifler').where('projeId', isEqualTo: projeId).snapshots(),
                  builder: (context, tSnap) {
                    int count = 0;
                    if (tSnap.hasData) {
                      count = tSnap.data!.docs.where((d) {
                        final dd = d.data() as Map<String, dynamic>;
                        return (dd['durum'] ?? '') == 'BEKLEMEDE';
                      }).length;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(count > 0 ? "PROJENİZE $count TEKLİF VAR" : "Henüz teklif gelmedi", style: TextStyle(color: count > 0 ? Colors.greenAccent : Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                    );
                  },
                ),
              ),
              IconButton(icon: const Icon(Icons.delete_forever, color: Colors.redAccent), onPressed: () => _ilaniSil(context, projeId)),
            ],
          ),
        ],
      ),
    );
  }
}