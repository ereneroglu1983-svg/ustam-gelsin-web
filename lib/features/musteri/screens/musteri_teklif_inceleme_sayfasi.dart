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

  // --- APPLE 1.2 - SIKAYET ET ---
  Future<void> _sikayetEt(BuildContext context, String ustaId, String offerId) async {
    final neden = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Şikayet Et"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            "Uygunsuz içerik",
            "Sahte teklif",
            "Hakaret / Küfür",
            "Dolandırıcılık",
            "Diğer",
          ].map((e) => ListTile(title: Text(e), onTap: () => Navigator.pop(c, e))).toList(),
        ),
      ),
    );
    if (neden == null) return;
    final me = FirebaseAuth.instance.currentUser;
    if (me == null) return;
    await FirebaseFirestore.instance.collection('sikayetler').add({
      'sikayetEdenId': me.uid,
      'sikayetEdilenUserId': ustaId,
      'ilanId': ilanId,
      'offerId': offerId,
      'neden': neden,
      'tarih': DateTime.now().toIso8601String(),
      'durum': 'beklemede',
      'tip': 'teklif',
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şikayetiniz alındı, incelenecek.")));
    }
  }

  // --- APPLE 1.2 - ENGELLE ---
  Future<void> _engelle(BuildContext context, String ustaId, String ustaAd) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Kullanıcıyı Engelle"),
        content: Text("$ustaAd adlı ustayı engellemek istiyor musun? Bu ustanın tekliflerini bir daha görmeyeceksin."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("Vazgeç")),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text("Engelle")),
        ],
      ),
    );
    if (onay != true) return;
    final me = FirebaseAuth.instance.currentUser;
    if (me == null) return;
    await FirebaseFirestore.instance.collection('engellenenler').add({
      'engelleyenId': me.uid,
      'engellenenUserId': ustaId,
      'tarih': DateTime.now().toIso8601String(),
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kullanıcı engellendi.")));
    }
  }

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
              final String ustaId = data['ustaId'] ?? "";
              final String ustaAd = data['ustaAd'] ?? "İsimsiz Usta";

              return ListTile(
                title: Text(ustaAd),
                subtitle: Text("Fiyat: ${data['teklifFiyat'] ?? 0}₺"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (data['durum'] == 'tamamlandi')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        onPressed: () => _puanlamaDialogGoster(context, ustaId),
                        child: const Text("PUAN VER"),
                      )
                    else if (data['durum'] == 'onaylandi')
                      const Text("TEKLİFİ ONAYLADINIZ", style: TextStyle(color: Colors.green))
                    else
                      Row(
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
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (v) {
                        if (v == 'sikayet') _sikayetEt(context, ustaId, doc.id);
                        if (v == 'engelle') _engelle(context, ustaId, ustaAd);
                      },
                      itemBuilder: (c) => const [
                        PopupMenuItem(value: 'sikayet', child: Text("Şikayet Et")),
                        PopupMenuItem(value: 'engelle', child: Text("Kullanıcıyı Engelle")),
                      ],
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