// lib/features/chat/screens/mesajlarim_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_detay_sayfasi.dart';

class MesajlarimSayfasi extends StatelessWidget {
  const MesajlarimSayfasi({super.key});

  // PARA FORMATLAMA FONKSİYONU
  String _formatPara(dynamic fiyat) {
    if (fiyat == null) return "0";
    String s = fiyat.toString();
    // Eğer sayı virgüllü gelirse virgülden sonrasını atıyoruz
    if (s.contains('.')) s = s.split('.')[0];
    // RegExp ile 3'lü gruplara nokta koyuyoruz
    return s.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  String _kullaniciAdiniGetir(Map<String, dynamic> data) {
    if (data.containsKey('firstName') || data.containsKey('lastName')) {
      String ad = data['firstName'] ?? '';
      String soyad = data['lastName'] ?? '';
      return "$ad $soyad".trim();
    }
    if (data.containsKey('name')) {
      return data['name'].toString().trim();
    }
    return "Kullanıcı";
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Mesajlarım")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var myChats = snapshot.data!.docs.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['gonderenId'] == uid || data['aliciId'] == uid;
          }).toList();

          Map<String, dynamic> uniqueChats = {};
          for (var doc in myChats) {
            var data = doc.data() as Map<String, dynamic>;
            String ilanId = data['ilanId'];
            if (!uniqueChats.containsKey(ilanId)) uniqueChats[ilanId] = data;
          }

          var chatList = uniqueChats.values.toList();

          return ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              var data = chatList[index];
              String ilanId = data['ilanId'] ?? '';
              String ustaId = (data['gonderenId'] == uid) ? data['aliciId'] : data['gonderenId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('ilanlar').doc(ilanId).get(),
                builder: (context, ilanSnapshot) {
                  if (!ilanSnapshot.hasData) return const ListTile(title: Text("Yükleniyor..."));

                  var ilanData = ilanSnapshot.data!.data() as Map<String, dynamic>;
                  String musteriUid = ilanData['userId'] ?? '';

                  return FutureBuilder<List<dynamic>>(
                    future: Future.wait([
                      FirebaseFirestore.instance.collection('users').doc(musteriUid).get(),
                      FirebaseFirestore.instance.collection('users').doc(ustaId).get(),
                      FirebaseFirestore.instance.collection('teklifler').where('ilanId', isEqualTo: ilanId).get()
                    ]),
                    builder: (context, infoSnapshot) {
                      String musteriAd = "Müşteri";
                      String ustaAd = "Usta";
                      String ilanBaslik = ilanData['baslik'] ?? "İlan";
                      String fiyat = "Teklif bekleniyor";

                      if (infoSnapshot.hasData) {
                        var musteriDoc = infoSnapshot.data![0] as DocumentSnapshot;
                        var ustaDoc = infoSnapshot.data![1] as DocumentSnapshot;
                        var teklifDocs = infoSnapshot.data![2] as QuerySnapshot;

                        if (musteriDoc.exists) musteriAd = _kullaniciAdiniGetir(musteriDoc.data() as Map<String, dynamic>);
                        if (ustaDoc.exists) ustaAd = _kullaniciAdiniGetir(ustaDoc.data() as Map<String, dynamic>);

                        if (teklifDocs.docs.isNotEmpty) {
                          var tData = teklifDocs.docs.first.data() as Map<String, dynamic>;
                          // BURADA FORMATLIYORUZ
                          fiyat = "${_formatPara(tData['teklifFiyat'])} TL";
                        }
                      }

                      return ListTile(
                        leading: CircleAvatar(child: Text(musteriAd.isNotEmpty ? musteriAd[0].toUpperCase() : "?")),
                        title: Text(musteriAd, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ilanBaslik, style: const TextStyle(fontWeight: FontWeight.w500)),
                            Text("Teklif: $fiyat", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                            ChatDetaySayfasi(ilanId: ilanId, ustaId: ustaId, ustaAd: ustaAd))),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}