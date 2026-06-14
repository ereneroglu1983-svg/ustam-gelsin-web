import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/repositories/offer_repository.dart';
import '../../../core/services/offer_service.dart';

class MusteriTeklifIncelemeSayfasi extends StatelessWidget {
  final String ilanId;
  final String ilanBaslik;

  final OfferService _service = OfferService(
    OfferRepository(FirebaseFirestore.instance),
  );

  MusteriTeklifIncelemeSayfasi({
    super.key,
    required this.ilanId,
    required this.ilanBaslik,
  });

  Future<void> _puanlamaDialogGoster(BuildContext context, String ustaId) async {
    int secilenPuan = 5;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ustayı Puanlayın"),
        content: StatefulBuilder(
          builder: (context, setModalState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Bu ustaya kaç puan verirsiniz?"),
              Slider(
                value: secilenPuan.toDouble(),
                min: 1, max: 5, divisions: 4,
                label: secilenPuan.toString(),
                onChanged: (val) => setModalState(() => secilenPuan = val.round()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () async {
              final ustaRef = FirebaseFirestore.instance.collection('users').doc(ustaId);
              await FirebaseFirestore.instance.runTransaction((transaction) async {
                DocumentSnapshot ustaDoc = await transaction.get(ustaRef);
                Map<String, dynamic> data = ustaDoc.data() as Map<String, dynamic>;
                double currentRating = (data['rating'] ?? 0.0).toDouble();
                int count = (data['ratingCount'] ?? 0).toInt();

                double yeniPuan = ((currentRating * count) + secilenPuan) / (count + 1);
                transaction.update(ustaRef, {'rating': yeniPuan, 'ratingCount': count + 1});
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Puan Ver"),
          ),
        ],
      ),
    );
  }

  Future<void> _teklifIslemiBaslat(
      BuildContext context,
      String offerId,
      String durum,
      Map<String, dynamic> offer,
      ) async {
    final musteriUid = FirebaseAuth.instance.currentUser?.uid;

    if (musteriUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Oturum bulunamadı!")));
      return;
    }

    try {
      await _service.processOffer(
        offerId: offerId,
        durum: durum,
        ilanId: ilanId,
        ilanBaslik: ilanBaslik,
        offer: offer,
        musteriUid: musteriUid,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(durum == 'onaylandi' ? "TEKLİF ONAYLANDI" : "TEKLİF REDDEDİLDİ"),
            backgroundColor: durum == 'onaylandi' ? Colors.green : Colors.red,
          ),
        );

        if (durum == 'onaylandi') {
          Navigator.pushReplacementNamed(context, '/musteri_is_gecmisim');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("HATA: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _showDialog(
      BuildContext context,
      String offerId,
      String durum,
      Map<String, dynamic> offer,
      ) async {
    final bool isOnay = durum == 'onaylandi';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isOnay ? "Teklifi Onayla" : "Teklifi Reddet"),
        content: Text(isOnay ? "Bu teklifi onaylamak istiyor musunuz?" : "Bu teklifi reddetmek istediğinize emin misiniz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _teklifIslemiBaslat(context, offerId, durum, offer);
            },
            child: Text(isOnay ? "Onayla" : "Reddet"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ilanBaslik)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teklifler')
            .where('ilanId', isEqualTo: ilanId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("HATA OLUŞTU: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Henüz teklif yok."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['ustaAd'] ?? "İsimsiz Usta"),
                subtitle: Text("Fiyat: ${data['teklifFiyat'] ?? 0}₺"),
                trailing: data['durum'] == 'tamamlandi'
                    ? ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () => _puanlamaDialogGoster(context, data['ustaId']),
                  child: const Text("PUAN VER"),
                )
                    : data['durum'] == 'onaylandi'
                    ? const Text("TEKLİFİ ONAYLADINIZ", style: TextStyle(color: Colors.green))
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => _showDialog(context, doc.id, 'reddedildi', data),
                      child: const Text("Reddet", style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: () => _showDialog(context, doc.id, 'onaylandi', data),
                      child: const Text("Onayla"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}