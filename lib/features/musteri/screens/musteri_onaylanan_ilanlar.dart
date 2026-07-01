// lib/features/musteri/screens/musteri_onaylanan_ilanlar.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:intl/intl.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/features/chat/screens/chat_detay_sayfasi.dart';

class MusteriOnaylananIlanlar extends StatelessWidget {
  const MusteriOnaylananIlanlar({super.key});

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
        title: const Text("Onaylanan İlanlar", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: userId == null
          ? const Center(child: Text("Giriş yapmadınız", style: TextStyle(color: Colors.white)))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ilanlar')
            .where('userId', isEqualTo: userId)
            .where('durum', isEqualTo: 'is_verildi')
            .orderBy('tarih', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Henüz onaylanan ilanınız yok.", style: TextStyle(color: Colors.white70)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final ilan = IlanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
              return _OnaylananIlanKarti(ilan: ilan, tarihFormatla: _tarihFormatla, formatKonum: _formatKonumMetni);
            },
          );
        },
      ),
    );
  }
}

// Usta bilgisini 'teklifler' üzerinden çeken özel widget
class _OnaylananIlanKarti extends StatelessWidget {
  final IlanModel ilan;
  final Function(String) tarihFormatla;
  final Future<String> Function(String) formatKonum;

  const _OnaylananIlanKarti({required this.ilan, required this.tarihFormatla, required this.formatKonum});

  @override
  Widget build(BuildContext context) {
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

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('teklifler')
          .where('ilanId', isEqualTo: ilan.id)
          .where('durum', isEqualTo: 'onaylandi')
          .limit(1)
          .get(),
      builder: (context, teklifSnapshot) {
        if (!teklifSnapshot.hasData || teklifSnapshot.data!.docs.isEmpty) return const SizedBox();

        final teklifDoc = teklifSnapshot.data!.docs.first;
        final ustaId = teklifDoc.get('ustaId');
        final teklifFiyat = teklifDoc.get('teklifFiyat');

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(ustaId).get(),
          builder: (context, ustaSnapshot) {
            if (!ustaSnapshot.hasData) return const SizedBox();
            final ustaData = ustaSnapshot.data!.data() as Map<String, dynamic>;

            // Hibrit isim yakalama mantığı
            String ustaGorunenAd = (ustaData['firstName'] != null && ustaData['lastName'] != null)
                ? "${ustaData['firstName']} ${ustaData['lastName']}"
                : (ustaData['name'] ?? "İsimsiz Usta");

            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ilan.baslik.toUpperCase(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.orangeAccent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: FutureBuilder<String>(
                            future: formatKonum(ilan.konumMetin),
                            builder: (context, s) => Text(s.data ?? "Konum getiriliyor...", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Icon(Icons.calendar_month, size: 14, color: Colors.blueAccent),
                        const SizedBox(width: 4),
                        Text(tarihFormatla(ilan.tarih), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (detaylar.isNotEmpty) ...[
                      Wrap(spacing: 10, runSpacing: 6, children: detaylar.map((d) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)), child: Text(d, style: const TextStyle(color: Colors.white60, fontSize: 11)))).toList()),
                      const SizedBox(height: 12),
                    ],
                    const Divider(color: Colors.white24),
                    const Text("Usta Bilgileri:", style: TextStyle(color: Colors.white70, fontSize: 11)),
                    Text("Usta: $ustaGorunenAd", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("Telefon: ${ustaData['phone'] ?? 'Belirtilmedi'}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Text("Puan: ${ustaData['rating'] ?? '0'}", style: const TextStyle(color: Colors.amber, fontSize: 12)),
                    Text("Teklif Tutarı: $teklifFiyat TL", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetaySayfasi(
                                ustaAd: ustaGorunenAd,
                                ustaId: ustaId,
                                ilanId: ilan.id,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.message, color: Colors.white),
                        label: const Text("Ustayla Mesajlaş", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}