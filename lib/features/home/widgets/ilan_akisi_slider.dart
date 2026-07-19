// lib/features/home/widgets/ilan_akisi_slider.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/constants/meslekler_data.dart'; // MesleklerData'yı import ettik
import 'package:ustam_gelsin/features/usta/screens/usta_auth_page.dart';

class IlanAkisiSlider extends StatelessWidget {
  final double ustaLat;
  final double ustaLng;

  const IlanAkisiSlider({super.key, required this.ustaLat, required this.ustaLng});

  // Artık manuel Map yok, MesleklerData'dan yardım alıyoruz
  String? _getKategoriResmi(String kategori) {
    try {
      final meslek = MesleklerData.hizmetlerDetayli.firstWhere(
            (m) => m.isim.toUpperCase() == kategori.toUpperCase(),
      );
      return meslek.resimYolu;
    } catch (e) {
      return null;
    }
  }

  Future<String> _getMaskeliIsim(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        String ad = userDoc.get('firstName') ?? "";
        String soyad = userDoc.get('lastName') ?? "";
        if (ad.isEmpty) return "MÜŞTERİ";
        String soyadHarf = soyad.isNotEmpty ? soyad[0].toUpperCase() : "";
        return "${ad[0].toUpperCase()}${ad.substring(1).toLowerCase()} $soyadHarf.";
      }
    } catch (e) { return "MÜŞTERİ"; }
    return "MÜŞTERİ";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<IlanModel>>(
      stream: AdService().getAktifIlanlar(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Hata oluştu."));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("İlan bulunmuyor."));

        List<IlanModel> ilanlar = snapshot.data!.where((i) {
          bool modelAcilMi = i.isAcil == true;
          bool detayAcilMi = i.teknikDetaylar['isAcil'] == true;
          return !modelAcilMi && !detayAcilMi;
        }).toList()
          ..sort((a, b) => b.tarih.compareTo(a.tarih));

        ilanlar = ilanlar.take(3).toList();

        if (ilanlar.isEmpty) return const SizedBox.shrink();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: ilanlar.length,
          itemBuilder: (context, index) => _ilanKarti(context, ilanlar[index]),
        );
      },
    );
  }

  Widget _ilanKarti(BuildContext context, IlanModel ilan) {
    // MesleklerData'dan resim yolunu çek
    final String? kategoriResimYolu = _getKategoriResmi(ilan.kategori);

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaAuthPage(role: "usta"))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: (ilan.resimler.isNotEmpty && ilan.resimler.first.isNotEmpty)
                    ? CachedNetworkImage(
                  imageUrl: ilan.resimler.first,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => kategoriResimYolu != null
                      ? Image.asset(kategoriResimYolu, fit: BoxFit.cover)
                      : Container(color: Colors.grey[200], child: const Icon(Icons.build)),
                )
                    : (kategoriResimYolu != null
                    ? Image.asset(kategoriResimYolu, fit: BoxFit.cover)
                    : Container(color: Colors.grey[200], child: const Icon(Icons.build))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                    future: _getMaskeliIsim(ilan.userId),
                    builder: (context, s) => Text(
                      s.data ?? "MÜŞTERİ",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(ilan.sehirIlceMetni ?? "Konum yok", style: const TextStyle(fontSize: 11, color: Colors.grey))
                  ]),
                  const SizedBox(height: 6),
                  Text(ilan.kategori, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 4),
                  if (ilan.teknikDetaylar.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      children: ilan.teknikDetaylar.values
                          .where((e) => e != null && e.toString().isNotEmpty && e.toString() != "false")
                          .take(3)
                          .map((e) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(e.toString(), style: const TextStyle(fontSize: 10, color: Colors.black54)),
                      ))
                          .toList(),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaAuthPage(role: "usta"))),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 12)),
                  child: const Text("Teklif Ver", style: TextStyle(fontSize: 11, color: Colors.white)),
                ),
                const SizedBox(height: 4),
                Text("${ilan.teklifSayisi} Teklif", style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }
}