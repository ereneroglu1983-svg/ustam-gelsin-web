import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';

class UstaTamamlananTeklif extends StatelessWidget {
  final String ustaId;
  const UstaTamamlananTeklif({super.key, required this.ustaId});

  String _formatDate(dynamic date) {
    if (date is Timestamp) return DateFormat('dd/MM/yy').format(date.toDate());
    return "Tarih belirtilmedi";
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} TL";
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
          .collection('tamamlanan_isler')
          .where('ustaId', isEqualTo: ustaId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz tamamlanmış işiniz yok.", style: TextStyle(color: Colors.black)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('ilanlar').doc(data['ilanId']).get(),
              builder: (context, ilanSnapshot) {
                if (!ilanSnapshot.hasData) return const SizedBox.shrink();

                var ilanData = ilanSnapshot.data!.data() as Map<String, dynamic>;
                String baslik = ilanData['isBasligi'] ?? ilanData['kategori'] ?? "İş Tamamlandı";

                // Ustanın teklifini teklifler koleksiyonundan çekmek için FutureBuilder
                return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('teklifler')
                        .where('ilanId', isEqualTo: data['ilanId'])
                        .where('ustaId', isEqualTo: ustaId)
                        .limit(1)
                        .get(),
                    builder: (context, teklifSnapshot) {
                      double ucret = (data['teklifFiyat'] ?? 0).toDouble();
                      if (teklifSnapshot.hasData && teklifSnapshot.data!.docs.isNotEmpty) {
                        ucret = (teklifSnapshot.data!.docs.first.data() as Map<String, dynamic>)['teklifFiyat']?.toDouble() ?? ucret;
                      }

                      return FutureBuilder<String>(
                          future: _formatKonumMetni(ilanData['konumMetin'] ?? data['konumMetin'] ?? ""),
                          builder: (context, konumSnapshot) {
                            return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance.collection('users').doc(ilanData['userId']).get(),
                                builder: (context, userSnapshot) {
                                  String musteri = "Müşteri";
                                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                                    var u = userSnapshot.data!.data() as Map<String, dynamic>;
                                    musteri = "${u['firstName'] ?? ''} ${u['lastName'] ?? ''}".trim();
                                  }

                                  return Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: ListTile(
                                      leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white)),
                                      title: Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text("Tarih: ${_formatDate(data['tamamlanmaTarihi'])}", style: const TextStyle(color: Colors.black)),
                                          Text("Müşteri: $musteri", style: const TextStyle(color: Colors.black)),
                                          Text("Konum: ${konumSnapshot.data ?? 'Konum Belirtilmedi'}", style: const TextStyle(color: Colors.black)),
                                          Text("Ücret: ${_formatPrice(ucret)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  );
                                }
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