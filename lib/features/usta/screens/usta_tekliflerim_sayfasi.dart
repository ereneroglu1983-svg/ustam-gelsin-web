// lib/features/usta/screens/usta_tekliflerim_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

// GÜNCEL IMPORTLAR
import 'package:ustam_gelsin/features/usta/screens/teklif_detay_sayfasi.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';

class UstaTekliflerimSayfasi extends StatelessWidget {
  const UstaTekliflerimSayfasi({super.key});

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} TL";
  }

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
    if (parts.length >= 2 && (RegExp(r'^\d+$').hasMatch(parts[0]) || RegExp(r'^\d+$').hasMatch(parts[1]))) {
      final ilIsim = await LocationService.getSehirIsim(parts[0]);
      final ilceIsim = await LocationService.getIlceIsim(parts[1]);
      return "$ilIsim / $ilceIsim";
    }
    return raw;
  }

  Future<void> _ara(String tel) async {
    final Uri url = Uri.parse('tel:$tel');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final String? ustaId = authService.currentUser?.uid;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
          title: const Text("Teklif Yönetimi", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.white, elevation: 0, centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [Tab(text: "Aktif"), Tab(text: "Tamamlanan"), Tab(text: "Reddedilen")],
          ),
        ),
        body: ustaId == null
            ? const Center(child: Text("Oturum açmanız gerekiyor."))
            : TabBarView(
          children: [
            _teklifListesiOlustur(FirebaseFirestore.instance.collection('teklifler').where('ustaId', isEqualTo: ustaId).where('durum', whereIn: ['beklemede', 'onaylandi', 'anlasildi']), ustaId),
            _tamamlananIsListesi(ustaId),
            _teklifListesiOlustur(FirebaseFirestore.instance.collection('teklifler').where('ustaId', isEqualTo: ustaId).where('durum', isEqualTo: 'reddedildi'), ustaId),
          ],
        ),
      ),
    );
  }

  Widget _tamamlananIsListesi(String ustaId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tamamlanan_isler').where('ustaId', isEqualTo: ustaId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text("Hata oluştu: ${snapshot.error}"));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz tamamlanmış işiniz yok."));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(data['baslik'] ?? "İş Tamamlandı", style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Tarih: ${_formatDate(data['tamamlanmaTarihi'])}"),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            );
          },
        );
      },
    );
  }

  Widget _teklifListesiOlustur(Query query, String ustaId) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.blue));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.history_rounded, size: 80, color: Colors.grey[300]), const SizedBox(height: 16), const Text("Henüz teklif kaydınız bulunmuyor.", style: TextStyle(color: Colors.grey, fontSize: 15))]));
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
                    String musteriTel = "";
                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                      String ad = userData['firstName'] ?? '';
                      String soyad = userData['lastName'] ?? '';
                      String birlesikAd = "$ad $soyad".trim();
                      musteriAdi = birlesikAd.isNotEmpty ? birlesikAd : (userData['name'] ?? "Müşteri");
                      musteriTel = userData['phone'] ?? userData['phoneNumber'] ?? "";
                    }

                    return FutureBuilder<String>(
                        future: _formatKonumMetni(ilanData['konumMetin'] ?? ""),
                        builder: (context, konumSnapshot) {
                          String formatliKonum = konumSnapshot.data ?? "Konum Belirtilmedi";
                          String displayId = doc.id.length > 5 ? doc.id.substring(0, 5) : doc.id;
                          String durum = teklifData['durum'] ?? 'beklemede';
                          bool isApproved = durum == 'onaylandi';
                          bool isRejected = durum == 'reddedildi';
                          Color durumRenk = isApproved ? Colors.green : (isRejected ? Colors.redAccent : Colors.orange);
                          String durumMetni = isApproved ? "Anlaşıldı" : (isRejected ? "Reddedildi" : "Beklemede");

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                            child: InkWell(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeklifDetaySayfasi(ilanId: teklifData['ilanId'] ?? "", teklifId: doc.id))),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [const Icon(Icons.tag, size: 16, color: Colors.blueGrey), Text("Teklif: #$displayId", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))]), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: durumRenk.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Text(durumMetni, style: TextStyle(color: durumRenk, fontSize: 12, fontWeight: FontWeight.bold)))]),
                                    const Divider(height: 20),
                                    Text(ilanBaslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 5), Text(formatliKonum, style: const TextStyle(color: Colors.grey, fontSize: 12)),

                                    if (ilanData['teknikDetaylar'] != null) ...[
                                      const SizedBox(height: 12),
                                      Wrap(spacing: 8, runSpacing: 8, children: (ilanData['teknikDetaylar'] as Map<String, dynamic>).entries.where((e) => !["adet", "alan_kademe", "alan_segmenti"].contains(e.key.toLowerCase())).map((e) {
                                        String baslik = e.key.replaceAll('_', ' '); baslik = baslik.substring(0, 1).toUpperCase() + baslik.substring(1);
                                        return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)), child: Text("$baslik: ${e.value}", style: TextStyle(color: Colors.blue.shade800, fontSize: 11, fontWeight: FontWeight.w600)));
                                      }).toList()),
                                    ],
                                    const Divider(height: 30, color: Color(0xFFF1F1F1)),
                                    _bilgiSatiri(Icons.payments_outlined, "Teklifiniz:", _formatPrice((teklifData['teklifFiyat'] ?? 0).toDouble()), Colors.blue),
                                    const SizedBox(height: 12),
                                    _bilgiSatiri(Icons.access_time_rounded, "Teklif Tarihi:", _formatDate(teklifData['tarih']), Colors.grey),

                                    const SizedBox(height: 20),
                                    _musteriIletisimKutusu(musteriAdi, musteriTel, formatliKonum),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _bilgiSatiri(IconData ikon, String etiket, String deger, Color iconColor) {
    return Row(children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(ikon, size: 16, color: iconColor)), const SizedBox(width: 12), Text(etiket, style: const TextStyle(color: Colors.black54, fontSize: 13)), const SizedBox(width: 6), Expanded(child: Text(deger, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14), overflow: TextOverflow.ellipsis))]);
  }

  Widget _musteriIletisimKutusu(String ad, String tel, String adres) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.blue.shade50.withOpacity(0.4), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue.shade100)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [CircleAvatar(radius: 15, backgroundColor: Colors.blue.shade100, child: const Icon(Icons.person, size: 16, color: Colors.blue)), const SizedBox(width: 10), Expanded(child: Text(ad, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))), if (tel.isNotEmpty) IconButton(onPressed: () => _ara(tel), icon: const Icon(Icons.phone_in_talk, color: Colors.green), style: IconButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.all(8)))]),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.location_on_outlined, size: 16, color: Colors.redAccent), const SizedBox(width: 8), Expanded(child: Text(adres, style: const TextStyle(color: Colors.black87, fontSize: 12)))])
      ]),
    );
  }
}