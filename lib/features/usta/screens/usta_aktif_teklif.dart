import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/features/usta/screens/teklif_detay_sayfasi.dart';

class UstaAktifTeklif extends StatelessWidget {
  final String ustaId;
  const UstaAktifTeklif({super.key, required this.ustaId});

  @override
  Widget build(BuildContext context) {
    // Aktif teklif sorgusu: Reddedilen ve Tamamlananlar dışındakiler
    final query = FirebaseFirestore.instance
        .collection('teklifler')
        .where('ustaId', isEqualTo: ustaId)
        .where('durum', whereNotIn: ['reddedildi', 'tamamlandi']);

    return _teklifListesiOlustur(query, context);
  }

  // Yardımcı metodlar
  String _formatPrice(double price) => "${NumberFormat("#,###", "tr_TR").format(price).replaceAll(',', '.')} TL";

  String _formatDate(dynamic date) {
    if (date == null) return "Tarih belirtilmedi";
    try {
      if (date is Timestamp) {
        return DateFormat('dd/MM/yy').format(date.toDate());
      } else if (date is String) {
        DateTime dt = DateTime.parse(date);
        return DateFormat('dd/MM/yy').format(dt);
      }
      return date.toString();
    } catch (e) {
      return "Geçersiz Tarih";
    }
  }

  Future<String> _formatKonumMetni(String raw) async {
    if (raw.isEmpty || raw == " / " || raw == "/") return "Konum Belirtilmedi";
    final parts = raw.split('/').map((e) => e.trim()).toList();
    if (parts.length >= 2 && (RegExp(r'^\d+$').hasMatch(parts[0]))) {
      return "${await LocationService.getSehirIsim(parts[0])} / ${await LocationService.getIlceIsim(parts[1])}";
    }
    return raw;
  }

  Widget _teklifListesiOlustur(Query query, BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz aktif teklifiniz bulunmuyor."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            var teklifData = doc.data() as Map<String, dynamic>;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('ilanlar').doc(teklifData['ilanId']).get(),
              builder: (context, ilanSnapshot) {
                if (!ilanSnapshot.hasData) return const SizedBox.shrink();
                var ilanData = ilanSnapshot.data!.data() as Map<String, dynamic>;
                String ilanBaslik = ilanData['isBasligi'] ?? ilanData['isAdi'] ?? "İş İlanı";
                String userId = ilanData['userId'] ?? "";

                return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                    builder: (context, userSnapshot) {
                      String musteriAdi = "Müşteri";
                      if (userSnapshot.hasData && userSnapshot.data!.exists) {
                        var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        String ad = userData['firstName'] ?? '';
                        String soyad = userData['lastName'] ?? '';
                        musteriAdi = "$ad $soyad".trim();
                      }

                      return FutureBuilder<String>(
                          future: _formatKonumMetni(ilanData['konumMetin'] ?? ""),
                          builder: (context, konumSnapshot) {
                            String durum = teklifData['durum'] ?? 'beklemede';
                            Color durumRenk = (durum == 'onaylandi') ? Colors.green : Colors.yellow.shade700;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                              child: InkWell(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeklifDetaySayfasi(ilanId: teklifData['ilanId'], teklifId: doc.id))),
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Durum etiketi buradan kaldırıldı
                                      Text(ilanData['kategori'] ?? "İş Kolu", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),

                                      const Divider(),
                                      Text(ilanBaslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                      const SizedBox(height: 8),
                                      Text("Müşteri: $musteriAdi", style: const TextStyle(color: Colors.black)),
                                      Text("Konum: ${konumSnapshot.data ?? "..."}", style: const TextStyle(color: Colors.black)),
                                      const SizedBox(height: 8),

                                      // Durum etiketi buraya, fiyat satırına taşındı
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Teklif: ${_formatPrice((teklifData['teklifFiyat'] ?? 0).toDouble())}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: durumRenk, borderRadius: BorderRadius.circular(6)),
                                            child: Text(durum.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
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