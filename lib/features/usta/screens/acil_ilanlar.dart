// lib/features/usta/screens/acil_ilanlar.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/theme/usta_theme.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/services/acil_is_yonetim_servisi.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_acil_is_detay_sayfasi.dart';

class AcilIlanlarSayfasi extends StatelessWidget {
  AcilIlanlarSayfasi({super.key});

  final AdService _adService = AdService();
  final AcilIsYonetimServisi _acilServis = AcilIsYonetimServisi();

  Future<String> _formatKonumMetni(String raw) async {
    if (raw.isEmpty || raw == " / " || raw == "/" || raw.trim() == "") return "Konum Belirtilmedi";
    final parts = raw.split('/').map((e) => e.trim()).toList();
    if (parts.length >= 2 && (RegExp(r'^\d+$').hasMatch(parts[0]))) {
      return "${await LocationService.getSehirIsim(parts[0])} / ${await LocationService.getIlceIsim(parts[1])}";
    }
    return raw;
  }

  void _cuzdanSayfasiniAc(BuildContext context, String uid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('wallets').doc(uid).snapshots(),
          builder: (context, snapshot) {
            double bakiye = 0.0;
            if (snapshot.hasData && snapshot.data!.exists) {
              bakiye = (snapshot.data!.data() as Map<String, dynamic>)['balance']?.toDouble() ?? 0.0;
            }
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(color: Color(0xFFF8F9FA), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Cüzdanım", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Text("Mevcut Bakiye: ${bakiye.toStringAsFixed(2)} TL\n\nBakiye yüklemek için profil sayfanızdaki cüzdan panelini kullanabilirsiniz."),
                  ),
                ],
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: UstaTheme.ustaArkaPlanDecor,
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text("ACİL İŞ FIRSATLARI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  // REVİZE ALANI: Hem string hem de liste kontrolü sağlayan sorgu mantığı
                  stream: FirebaseFirestore.instance
                      .collection('acil_cagri')
                      .where('durum', isEqualTo: 'bekliyor')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _bosDurumWidget();

                    // İlanları filtrele (Hem kategoriId bazlı hem teknikDetaylar.acilDurumTipi listesi bazlı)
                    List<IlanModel> acilIlanlar = snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return IlanModel.fromMap(data, doc.id);
                    }).toList();

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: acilIlanlar.length,
                      itemBuilder: (context, index) => _firsatKarti(context, acilIlanlar[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firsatKarti(BuildContext context, IlanModel ilan) {
    final String rawKonum = "${ilan.ilId} / ${ilan.ilceId}";

    return Card(
      color: Colors.red.shade900,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: _formatKonumMetni(rawKonum),
                  builder: (context, snapshot) {
                    return Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white54, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          snapshot.data ?? "Yükleniyor...",
                          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Icon(Icons.flash_on, color: Colors.white),
                const SizedBox(height: 8),
                Text(ilan.baslik.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(ilan.detaylar, style: const TextStyle(color: Colors.white70, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red.shade900, minimumSize: const Size(double.infinity, 45)),
              onPressed: () async {
                try {
                  await _acilServis.konumKontrolVeAl();
                  bool basarili = await _acilServis.acilIsiKap(ilan.id);
                  if (!context.mounted) return;
                  if (basarili == true) {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const UstaAcilIsDetaySayfasi()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bu ilan başkası tarafından alındı veya bakiye yetersiz!")));
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) _cuzdanSayfasiniAc(context, user.uid);
                  }
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("İşlem sırasında hata oluştu.")));
                }
              },
              child: const Text("HEMEN İŞİ AL (250.00 TL)", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bosDurumWidget() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.timer_off_rounded, size: 80, color: Colors.white.withOpacity(0.1)), const SizedBox(height: 20), const Text("Şu an acil ilan bulunmuyor.", style: TextStyle(color: Colors.white))]));
}