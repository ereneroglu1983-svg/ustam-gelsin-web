// lib/features/musteri/screens/musteri_acil_ilanlarim.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MusteriAcilIlanlarim extends StatelessWidget {
  const MusteriAcilIlanlarim({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("Acil Usta İlanlarım", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('acil_cagri')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
                child: Text("Henüz acil çağrınız bulunmuyor.", style: TextStyle(color: Colors.white60)));
          }

          docs.sort((a, b) {
            var aData = a.data() as Map<String, dynamic>;
            var bData = b.data() as Map<String, dynamic>;
            var aVal = aData['kabulEdilmeTarihi'] ?? aData['tarih'];
            var bVal = bData['kabulEdilmeTarihi'] ?? bData['tarih'];

            DateTime aTime = (aVal is Timestamp) ? aVal.toDate() : (aVal != null ? DateTime.tryParse(aVal.toString()) ?? DateTime(2000) : DateTime(2000));
            DateTime bTime = (bVal is Timestamp) ? bVal.toDate() : (bVal != null ? DateTime.tryParse(bVal.toString()) ?? DateTime(2000) : DateTime(2000));

            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return _buildAcilIlanKarti(data);
            },
          );
        },
      ),
    );
  }

  Widget _buildAcilIlanKarti(Map<String, dynamic> data) {
    bool isAtandi = data['durum'] == 'atandi';
    bool isTamamlandi = data['durum'] == 'tamamlandi';
    String kategori = data['kategoriId'] ?? "Acil İş";
    String aciklama = data['detaylar'] ?? "Açıklama girilmemiş.";

    var tarihRaw = data['tarih'];
    String tarihStr = "";
    if (tarihRaw is String) {
      try { tarihStr = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(tarihRaw)); } catch (_) {}
    } else if (tarihRaw is Timestamp) {
      tarihStr = DateFormat('dd/MM/yyyy HH:mm').format(tarihRaw.toDate());
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isTamamlandi
                ? Colors.greenAccent
                : (isAtandi ? Colors.green.withOpacity(0.3) : Colors.redAccent.withOpacity(0.3))
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  kategori.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Text(tarihStr, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Text(aciklama, style: const TextStyle(color: Colors.white70, fontSize: 14)),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(color: Colors.white10),
          ),

          // Durum Kontrol Mantığı
          if (isTamamlandi) ...[
            const Center(
              child: Text("İŞİNİZ TAMAMLANMIŞTIR",
                  style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ] else if (isAtandi) ...[
            const Text("Ustamız Size Yönlendirilmiştir",
                style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildUstaBilgisi(data),
          ] else ...[
            const Text(
              "Bölgenizde işinize uygun usta aranıyor. Ustanız en kısa sürede sizinle iletişime geçecektir.",
              style: TextStyle(color: Colors.orangeAccent, fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildUstaBilgisi(Map<String, dynamic> data) {
    String ustaAd = data['ustaAd'] ?? "İsimsiz Usta";
    String ustaTel = data['ustaTelefon'] ?? "";
    String? profilResmi = data['ustaProfilResmi'];
    bool hasRozet = data['ustaUstalikBelgesi'] ?? false;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white10,
          backgroundImage: (profilResmi != null && profilResmi.isNotEmpty) ? NetworkImage(profilResmi) : null,
          child: (profilResmi == null || profilResmi.isEmpty) ? const Icon(Icons.person, color: Colors.white) : null,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ustaAd, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(ustaTel, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                ],
              ),
              if (hasRozet)
                Image.asset("assets/images/usta_rozet.png", width: 40, height: 40),
            ],
          ),
        ),
      ],
    );
  }
}