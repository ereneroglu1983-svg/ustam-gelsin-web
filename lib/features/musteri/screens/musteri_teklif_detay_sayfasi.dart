// lib/features/musteri/screens/musteri_teklif_detay_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/services/offer_service.dart';
import 'package:ustam_gelsin/core/repositories/offer_repository.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_is_gecmisi_sayfasi.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';
import 'package:ustam_gelsin/features/chat/screens/chat_detay_sayfasi.dart';

class MusteriTeklifDetaySayfasi extends StatelessWidget {
  final IlanModel ilan;
  final String ilanId;

  const MusteriTeklifDetaySayfasi({super.key, required this.ilan, required this.ilanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("Gelen Teklifler", style: TextStyle(color: Colors.white)),
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
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('tamamlanan_isler').doc(ilanId).snapshots(),
          builder: (context, arsivSnapshot) {
            if (arsivSnapshot.hasData && arsivSnapshot.data!.exists) {
              return Center(
                child: _durumEtiketi("BU İŞ TAMAMLANDI", Colors.blue),
              );
            }

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('teklifler')
                  .where('ilanId', isEqualTo: ilanId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Colors.blue));
                }

                bool ilanOnaylandiMi = snapshot.data!.docs.any((doc) => (doc.data() as Map<String, dynamic>)['durum'] == 'onaylandi');

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final teklif = doc.data() as Map<String, dynamic>;
                    return _buildUstaTeklifKarti(context, doc.id, teklif, ilanOnaylandiMi);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildUstaTeklifKarti(BuildContext context, String docId, Map<String, dynamic> teklif, bool ilanOnaylandiMi) {
    final NumberFormat format = NumberFormat("#,###", "tr_TR");
    final String durum = teklif['durum'] ?? 'beklemede';
    final String ustaId = teklif['ustaId'] ?? "";

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(ustaId).get(),
      builder: (context, userSnapshot) {
        final ustaData = userSnapshot.data?.data() as Map<String, dynamic>?;
        final ustaAd = ustaData?['name'] ?? "Bilinmeyen Usta";
        final ustaTel = ustaData?['phone'] ?? "Belirtilmemiş";

        return FutureBuilder<String>(
          future: _getKonumIsim(ustaData?['sehir_id'], ustaData?['ilce_id']),
          builder: (context, konumSnapshot) {
            final ustaKonum = konumSnapshot.data ?? "Konum bilgisi yok";

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ustaAd.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            const Text("Teklif Veren Usta", style: TextStyle(color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        "${format.format(teklif['teklifFiyat'] ?? 0)} ₺",
                        style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text(ustaTel, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(width: 20),
                      const Icon(Icons.location_on, size: 16, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text(ustaKonum, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text("USTANIN NOTU:", style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    teklif['not'] ?? 'Açıklama belirtilmedi.',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Divider(color: Colors.white10, height: 25),
                  if (durum == 'onaylandi')
                    _durumEtiketi("TEKLİFİ ONAYLADINIZ", Colors.green)
                  else if (durum == 'reddedildi')
                    _durumEtiketi("TEKLİFİNİZ REDDEDİLDİ", Colors.red)
                  else if (ilanOnaylandiMi && durum != 'onaylandi')
                      _durumEtiketi("TEKLİFİNİZ REDDEDİLDİ", Colors.red)
                    else
                      Row(
                        children: [
                          Expanded(child: _buton(Colors.red.shade700, "REDDET", () => _teklifIslemi(context, docId, "reddedildi", teklif))),
                          const SizedBox(width: 10),
                          Expanded(child: _buton(Colors.green.shade700, "ONAYLA", () => _teklifIslemi(context, docId, "onaylandi", teklif))),
                        ],
                      ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buton(Colors.blue.shade700, "SOHBETİ BAŞLAT", () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetaySayfasi(ustaAd: ustaAd, ustaId: ustaId, ilanId: ilanId)));
                      })),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _durumEtiketi(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: color)),
      child: Center(child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold))),
    );
  }

  Future<void> _teklifIslemi(BuildContext context, String offerId, String durum, Map<String, dynamic> teklif) async {
    final service = OfferService(OfferRepository(FirebaseFirestore.instance));
    final musteriUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    try {
      await service.processOffer(offerId: offerId, durum: durum, ilanId: ilanId, ilanBaslik: ilan.baslik, offer: teklif, musteriUid: musteriUid);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("İşlem Başarılı: $durum")));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  Future<String> _getKonumIsim(dynamic sehirId, dynamic ilceId) async {
    if (sehirId == null || ilceId == null) return "Konum bilgisi yok";
    String il = await LocationService.getSehirIsim(sehirId.toString());
    String ilce = await LocationService.getIlceIsim(ilceId.toString());
    return "$il / $ilce";
  }

  Widget _buton(Color color, String text, VoidCallback? onPressed) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
  );
}