// lib/features/usta/screens/ilan_vitrini_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/models/user_model.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_ilan_detay_sayfasi.dart';

class IlanVitriniSayfasi extends StatelessWidget {
  final UserModel usta;
  final List<IlanModel> gelenIlanlar;

  const IlanVitriniSayfasi({
    super.key,
    required this.usta,
    required this.gelenIlanlar
  });

  List<IlanModel> get filtrelenmisVeSiraliListe {
    final DateTime simdi = DateTime.now();

    List<IlanModel> liste = gelenIlanlar.where((ilan) {
      try {
        if (ilan.tarih.isEmpty) return false;
        final DateTime ilanTarihi = DateTime.parse(ilan.tarih);
        final fark = simdi.difference(ilanTarihi).inDays;

        // Sadece son 7 gün ve durumu "aktif" olanlar
        return fark < 7 && ilan.durum == "aktif";
      } catch (e) {
        return false;
      }
    }).toList();

    // Adres verilerini güvenli çekiyoruz
    final String ustaIlceId = usta.address['ilce_id']?.toString() ?? "";
    final String ustaIlId = usta.address['il_id']?.toString() ?? "";

    liste.sort((a, b) {
      // Önce ilçe bazlı, sonra il bazlı sıralama
      if (a.ilceId == ustaIlceId && b.ilceId != ustaIlceId) return -1;
      if (a.ilceId != ustaIlceId && b.ilceId == ustaIlceId) return 1;
      if (a.ilId == ustaIlId && b.ilId != ustaIlId) return -1;
      if (a.ilId != ustaIlId && b.ilId == ustaIlId) return 1;
      return 0;
    });
    return liste;
  }

  @override
  Widget build(BuildContext context) {
    final ilanlar = filtrelenmisVeSiraliListe;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Tüm İlanlar", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ilanlar.isEmpty
          ? const Center(child: Text("Şu an uygun ilan bulunmamaktadır."))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: ilanlar.length,
        itemBuilder: (context, index) => _buildIlanKarti(context, ilanlar[index]),
      ),
    );
  }

  Widget _buildIlanKarti(BuildContext context, IlanModel ilan) {
    String gorunurAd = ilan.komisyonOdendiMi ? ilan.musteriAd : _isimMaskele(ilan.musteriAd);

    // VERİ KONTROLÜ
    String konum = (ilan.konumMetin.isEmpty || ilan.konumMetin == "Belirtilmemiş") ? "Konum bilgisi yok" : ilan.konumMetin;
    String tanim = (ilan.isTanimi.isEmpty || ilan.isTanimi == "Belirtilmemiş") ? "İş tanımı girilmemiş" : ilan.isTanimi;
    String fiyat = (ilan.fiyatBilgisi.isEmpty || ilan.fiyatBilgisi == "Belirtilmemiş") ? "Teklif bekleniyor" : ilan.fiyatBilgisi;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(ilan.baslik.isEmpty ? "Başlıksız İlan" : ilan.baslik,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                  child: Text(fiyat,
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
            const Divider(height: 24),
            _bilgiSatiri(Icons.person, "Müşteri: $gorunurAd"),
            _bilgiSatiri(Icons.location_on, "Konum: $konum"),
            _bilgiSatiri(Icons.description, "İş Tanımı: $tanim"),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UstaIlanDetaySayfasi(ilan: ilan, usta: usta),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ilan.komisyonOdendiMi ? Colors.blue : const Color(0xFF2DB34A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  ilan.komisyonOdendiMi ? "Detayları Gör" : "Komisyonu Öde ve Detayları Gör",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bilgiSatiri(IconData icon, String metin) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(child: Text(metin, style: TextStyle(color: Colors.grey[800], fontSize: 14))),
        ],
      ),
    );
  }

  String _isimMaskele(String tamAd) {
    if (tamAd.isEmpty) return "Müşteri";
    List<String> parcalar = tamAd.trim().split(" ");
    if (parcalar.isNotEmpty) {
      String ilkIsim = parcalar[0];
      if (parcalar.length > 1) {
        return "$ilkIsim ${parcalar.last[0]}.";
      }
      return ilkIsim;
    }
    return "Müşteri";
  }
}