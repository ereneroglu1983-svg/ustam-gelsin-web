import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';

class UstaReddedilenTeklif extends StatelessWidget {
  final String ustaId;
  const UstaReddedilenTeklif({super.key, required this.ustaId});

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} TL";
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) return DateFormat('dd/MM/yy').format(date.toDate());
    return "Tarih belirtilmedi";
  }

  Future<String> _formatKonumMetni(String raw) async {
    if (raw.isEmpty || raw == " / " || raw == "/") return "Konum Belirtilmedi";
    final parts = raw.split('/').map((e) => e.trim()).toList();
    if (parts.length >= 2 && (RegExp(r'^\d+$').hasMatch(parts[0]))) {
      return "${await LocationService.getSehirIsim(parts[0])} / ${await LocationService.getIlceIsim(parts[1])}";
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('teklifler')
          .where('ustaId', isEqualTo: ustaId)
          .where('durum', isEqualTo: 'reddedildi')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz reddedilen teklifiniz yok.", style: TextStyle(color: Colors.black)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            var data = doc.data() as Map<String, dynamic>;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('ilanlar').doc(data['ilanId']).get(),
              builder: (context, ilanSnapshot) {
                if (!ilanSnapshot.hasData) return const SizedBox.shrink();
                var ilanData = ilanSnapshot.data!.data() as Map<String, dynamic>;

                return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(ilanData['userId']).get(),
                    builder: (context, userSnapshot) {
                      String musteriAdi = "Müşteri";
                      if (userSnapshot.hasData && userSnapshot.data!.exists) {
                        var u = userSnapshot.data!.data() as Map<String, dynamic>;
                        musteriAdi = "${u['firstName'] ?? ''} ${u['lastName'] ?? ''}".trim();
                      }

                      return FutureBuilder<String>(
                          future: _formatKonumMetni(ilanData['konumMetin'] ?? ""),
                          builder: (context, konumSnapshot) {
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.close, color: Colors.white)),
                                title: Text(ilanData['isBasligi'] ?? ilanData['kategori'] ?? "Reddedilen Teklif", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text("Tarih: ${_formatDate(data['reddedilmeTarihi'] ?? data['teklifTarihi'])}", style: const TextStyle(color: Colors.black)),
                                    Text("Müşteri: $musteriAdi", style: const TextStyle(color: Colors.black)),
                                    Text("Konum: ${konumSnapshot.data ?? 'Konum Belirtilmedi'}", style: const TextStyle(color: Colors.black)),
                                    Text("Ücret: ${_formatPrice((data['teklifFiyat'] ?? 0).toDouble())}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }
                );
              },
            );
          },
        );
      },
    );
  }
}