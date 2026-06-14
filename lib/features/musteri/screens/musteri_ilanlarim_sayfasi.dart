// lib/features/musteri/screens/musteri_ilanlarim_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:intl/intl.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';

import 'musteri_teklif_detay_sayfasi.dart';

class MusteriIlanlarimSayfasi extends StatelessWidget {
  const MusteriIlanlarimSayfasi({super.key});

  Future<void> _ilaniSil(BuildContext context, String ilanId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF203A43),
        title: const Text("İlanı Sil", style: TextStyle(color: Colors.white)),
        content: const Text("Bu ilanı silmek istediğinize emin misiniz? Tüm teklifler reddedilecek.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // İptal (Hayır)
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Sil (Evet)
            child: const Text("SİL", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final batch = FirebaseFirestore.instance.batch();
        final teklifler = await FirebaseFirestore.instance.collection('teklifler').where('ilanId', isEqualTo: ilanId).get();

        for (var doc in teklifler.docs) {
          batch.update(doc.reference, {'durum': 'reddedildi'});
        }

        batch.delete(FirebaseFirestore.instance.collection('ilanlar').doc(ilanId));
        await batch.commit();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("İlan ve teklifler başarıyla kaldırıldı.")));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
        }
      }
    }
  }

  String _tarihFormatla(String tarihStr) {
    try {
      DateTime dt = DateTime.parse(tarihStr);
      return DateFormat('dd.MM.yyyy - HH:mm').format(dt);
    } catch (e) {
      return tarihStr;
    }
  }

  Future<String> _formatKonumMetni(String raw) async {
    if (raw.isEmpty || raw == " / " || raw == "/" || raw.trim() == "") {
      return "Konum Belirtilmedi";
    }
    final String trimmed = raw.trim();
    if (trimmed.contains('/') && trimmed.split('/').every((e) => e.trim().isEmpty)) {
      return "Konum Belirtilmedi";
    }
    final parts = trimmed.split('/').map((e) => e.trim()).toList();
    if (parts.length >= 2) {
      final String firstPart = parts[0];
      final String secondPart = parts[1];
      if (RegExp(r'^\d+$').hasMatch(firstPart)) {
        final ilIsim = await LocationService.getSehirIsim(firstPart);
        final ilceIsim = await LocationService.getIlceIsim(secondPart);
        return "$ilIsim / $ilceIsim";
      }
      if (RegExp(r'^\d+$').hasMatch(secondPart)) {
        final ilIsim = await LocationService.getSehirIsim(firstPart);
        final ilceIsim = await LocationService.getIlceIsim(secondPart);
        return "$ilIsim / $ilceIsim";
      }
    }
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("İlanlarım", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: userId == null
            ? const Center(child: Text("Giriş yapmadınız", style: TextStyle(color: Colors.white)))
            : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ilanlar')
              .where('userId', isEqualTo: userId)
              .orderBy('tarih', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Henüz ilanınız yok.", style: TextStyle(color: Colors.white70)));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final ilan = IlanModel.fromMap(data, doc.id);
                return _buildIlanKarti(context, ilan, doc.id);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildIlanKarti(BuildContext context, IlanModel ilan, String docId) {
    List<String> detaylar = [];
    if (ilan.teknikDetaylar.isNotEmpty) {
      ilan.teknikDetaylar.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          String label = key.replaceAll('_', ' ');
          label = label[0].toUpperCase() + label.substring(1);
          if (value is List) {
            detaylar.add("$label: ${value.join(', ')}");
          } else {
            detaylar.add("$label: $value");
          }
        }
      });
    }

    Color durumRenk = ilan.durum == 'aktif' ? Colors.green : (ilan.durum == 'reddedildi' ? Colors.red : Colors.orange);
    String durumText = ilan.durum == 'aktif' ? "YAYINDA" : (ilan.durum == 'reddedildi' ? "REDDEDİLDİ" : "ONAY BEKLİYOR");

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MusteriTeklifDetaySayfasi(ilan: ilan, ilanId: docId))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(ilan.baslik.toUpperCase(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: durumRenk.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                        child: Text(durumText, style: TextStyle(color: durumRenk, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, color: Colors.white38),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.orangeAccent),
                      const SizedBox(width: 4),
                      Expanded(
                        child: FutureBuilder<String>(
                          future: _formatKonumMetni(ilan.konumMetin),
                          builder: (context, snapshot) {
                            return Text(snapshot.data ?? "Konum getiriliyor...", style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis);
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.calendar_month, size: 14, color: Colors.blueAccent),
                      const SizedBox(width: 4),
                      Text(_tarihFormatla(ilan.tarih), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (detaylar.isNotEmpty) ...[
                    Wrap(spacing: 10, runSpacing: 6, children: detaylar.map((d) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)), child: Text(d, style: const TextStyle(color: Colors.white60, fontSize: 11)))).toList()),
                    const SizedBox(height: 12),
                  ],
                  Text("Tahmin: ${ilan.fiyatBilgisi}", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Row(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('teklifler').where('ilanId', isEqualTo: docId).snapshots(),
                  builder: (context, tSnapshot) {
                    int count = tSnapshot.hasData ? tSnapshot.data!.docs.length : 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(count > 0 ? "İLANINIZA $count TEKLİF VAR" : "Henüz teklif gelmedi", style: TextStyle(color: count > 0 ? Colors.green : Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                onPressed: () => _ilaniSil(context, docId),
              ),
            ],
          ),
        ],
      ),
    );
  }
}