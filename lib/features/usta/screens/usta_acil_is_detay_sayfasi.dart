// lib/features/usta/screens/usta_acil_is_detay_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class UstaAcilIsDetaySayfasi extends StatelessWidget {
  // Orijinal yapı korunmuştur, hiçbir parametre silinmemiştir.
  const UstaAcilIsDetaySayfasi({super.key});

  Future<void> _telefonuAra(String telefon) async {
    final Uri launchUri = Uri(scheme: 'tel', path: telefon);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ustaId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("DEVAM EDEN ACİL İŞLERİM", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      // MANTIĞI KURDUK: Ustanın kendi ID'si ile 'atandi' durumundaki TÜM işleri buluyoruz
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('acil_cagri')
            .where('secilenUstaId', isEqualTo: ustaId)
            .where('durum', isEqualTo: 'atandi')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Şu an devam eden bir acil işiniz bulunmuyor."));
          }

          // Çoklu iş desteği için ListView kullanıldı, yapı korunarak listelendi
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;
              var ilanId = doc.id;

              return Column(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bilgiKutusu("MÜŞTERİ ADI SOYADI", data['musteriAd'] ?? "Belirtilmedi"),
                        _bilgiKutusu("KONUM", data['konumMetin'] ?? "Belirtilmedi"),
                        _bilgiKutusu("AÇIK ADRES", data['acikAdres'] ?? "Belirtilmedi"),

                        const Divider(height: 40, color: Colors.grey),

                        _bilgiKutusu("ACİL İŞİN NE OLDUĞU", data['baslik'] ?? "Belirtilmedi"),
                        _bilgiKutusu("MÜŞTERİNİN İŞ TANIMI", data['detaylar'] ?? "Belirtilmedi"),

                        const SizedBox(height: 10),

                        GestureDetector(
                          onTap: () => _telefonuAra(data['musteriTelefon'] ?? ""),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                            child: Row(
                                children: [
                                  const Icon(Icons.phone, color: Colors.black),
                                  const SizedBox(width: 10),
                                  Text(data['musteriTelefon'] ?? "Telefon Yok", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                                ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // İŞİ TAMAMLA TUŞU - Her iş kartı için ayrı ayrı render edilir
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection('acil_cagri').doc(ilanId).update({
                            'durum': 'tamamlandi'
                          });
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: const Text("İŞİ TAMAMLA", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const Divider(thickness: 5, color: Color(0xFFF2F2F2)), // İşler arası ayrım
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _bilgiKutusu(String baslik, String icerik) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(baslik, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(icerik, style: const TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }
}