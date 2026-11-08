// lib/features/musteri/screens/musteri_proje_onaylanan_ilanlar.dart - YENİ - HUG PROJE ONAYLANAN
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/features/chat/screens/chat_detay_sayfasi.dart';

class MusteriProjeOnaylananIlanlar extends StatelessWidget {
  const MusteriProjeOnaylananIlanlar({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Center(child: Text("Giriş yapmadınız", style: TextStyle(color: Colors.white)));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hug_pro_teklifler')
          .where('musteriId', isEqualTo: userId)
          .where('durum', isEqualTo: 'ONAYLANDI')
          .orderBy('olusturmaTarihi', descending: true)
          .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC8A45D)));
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz onaylanan proje teklifiniz yok.", style: TextStyle(color: Colors.white70)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snap.data!.docs.length,
          itemBuilder: (context, i) {
            final teklifDoc = snap.data!.docs[i];
            final teklif = teklifDoc.data() as Map<String, dynamic>;
            return _OnaylananProjeKarti(teklif: teklif, teklifId: teklifDoc.id);
          },
        );
      },
    );
  }
}

class _OnaylananProjeKarti extends StatelessWidget {
  final Map<String, dynamic> teklif;
  final String teklifId;
  const _OnaylananProjeKarti({required this.teklif, required this.teklifId});

  @override
  Widget build(BuildContext context) {
    final projeId = (teklif['projeId'] ?? '').toString();
    final proId = (teklif['profesyonelId'] ?? teklif['proId'] ?? '').toString();
    final teklifBedeli = teklif['teklifBedeli'] ?? 0;
    final teklifNotu = (teklif['teklifNotu'] ?? '').toString();

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('hug_projects').doc(projeId).get(),
      builder: (context, projeSnap) {
        final proje = projeSnap.data?.data() as Map<String, dynamic>?;
        final yapi = (proje?['yapiTuruDisplay'] ?? proje?['yapiTuruId'] ?? 'PROJE').toString();
        final konum = proje?['konum'] as Map<String, dynamic>?;
        final il = (konum?['il'] ?? '').toString();
        final ilce = (konum?['ilce'] ?? '').toString();

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users_pro').doc(proId).get(),
          builder: (context, proSnap) {
            final proData = proSnap.data?.data() as Map<String, dynamic>?;
            return FutureBuilder<DocumentSnapshot>(
              future: proData == null ? FirebaseFirestore.instance.collection('users').doc(proId).get() : null,
              builder: (context, fallbackSnap) {
                Map<String, dynamic>? finalPro = proData;
                if (finalPro == null && fallbackSnap.hasData && fallbackSnap.data!.exists) {
                  finalPro = fallbackSnap.data!.data() as Map<String, dynamic>?;
                }
                String proAd = "PROFESYONEL";
                if (finalPro != null) {
                  if (finalPro['hesapTuru'] == 'SIRKET') {
                    final s = (finalPro['sirketAdi'] ?? finalPro['firmaAdi'] ?? '').toString();
                    proAd = s.length > 3 ? "${s.substring(0, 3).toUpperCase()}...." : s;
                  } else {
                    final ad = (finalPro['ad'] ?? finalPro['firstName'] ?? '').toString();
                    final soyad = (finalPro['soyad'] ?? finalPro['lastName'] ?? '').toString();
                    proAd = soyad.isNotEmpty ? "$ad ${soyad[0].toUpperCase()}...." : ad;
                  }
                }
                final puan = (finalPro?['ortalamaPuan'] ?? finalPro?['puan'] ?? 0).toString();
                final tel = (finalPro?['telefon'] ?? finalPro?['phone'] ?? 'Belirtilmedi').toString();

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFC8A45D).withOpacity(0.3))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFC8A45D), borderRadius: BorderRadius.circular(4)), child: const Text("PROJE İLANI", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold))),
                          const SizedBox(width: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), borderRadius: BorderRadius.circular(4)), child: const Text("ONAYLANDI", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(yapi.replaceAll('_', ' / ').toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text("$il / $ilce", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const Divider(color: Colors.white24, height: 24),
                      const Text("Profesyonel Bilgileri:", style: TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text("Pro: $proAd", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("Telefon: $tel", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      Text("Puan: $puan", style: const TextStyle(color: Colors.amber, fontSize: 12)),
                      Text("Teklif Tutarı: $teklifBedeli TL", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                      if (teklifNotu.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text("Not: $teklifNotu", style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC8A45D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetaySayfasi(ustaAd: proAd, ustaId: proId, ilanId: projeId)));
                          },
                          icon: const Icon(Icons.message, color: Colors.black),
                          label: const Text("Pro ile Mesajlaş", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}