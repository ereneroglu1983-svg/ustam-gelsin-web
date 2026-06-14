// lib/features/usta/screens/teklif_detay_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ustam_gelsin/core/services/chat_service.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';

class TeklifDetaySayfasi extends StatefulWidget {
  final String ilanId;
  final String teklifId;

  const TeklifDetaySayfasi({
    super.key,
    required this.ilanId,
    required this.teklifId,
  });

  @override
  State<TeklifDetaySayfasi> createState() => _TeklifDetaySayfasiState();
}

class _TeklifDetaySayfasiState extends State<TeklifDetaySayfasi> {
  final ChatService _chatService = ChatService();
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} TL";
  }

  Future<void> _ara(String tel) async {
    final Uri url = Uri.parse('tel:$tel');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _isiTamamla() async {
    try {
      final String? currentUstaId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUstaId == null) return;

      final ilanDoc = FirebaseFirestore.instance.collection('ilanlar').doc(widget.ilanId);
      final teklifDoc = FirebaseFirestore.instance.collection('teklifler').doc(widget.teklifId);

      final ilanSnapshot = await ilanDoc.get();
      final teklifSnapshot = await teklifDoc.get();

      if (!ilanSnapshot.exists || !teklifSnapshot.exists) return;

      final ilanData = ilanSnapshot.data() as Map<String, dynamic>;
      final teklifData = teklifSnapshot.data() as Map<String, dynamic>;

      final batch = FirebaseFirestore.instance.batch();

      // 1. Teklif durumunu güncelle
      batch.update(teklifDoc, {'durum': 'tamamlandi'});

      // 2. Tamamlanan işler koleksiyonuna ekle
      final tamamlananIsRef = FirebaseFirestore.instance.collection('tamamlanan_isler').doc();

      batch.set(tamamlananIsRef, {
        'ustaId': currentUstaId, // FirebaseAuth'tan gelen kesin ID
        'ilanId': widget.ilanId,
        'teklifId': widget.teklifId,
        'baslik': ilanData['isBasligi'] ?? ilanData['isAdi'] ?? "İş Tamamlandı",
        'tamamlanmaTarihi': FieldValue.serverTimestamp(),
        'ilanDetay': ilanData,
        'teklifDetay': teklifData,
      });

      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("İş başarıyla tamamlandı!")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
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

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2DB34A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Teklif ve İş Detayı",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('teklifler').doc(widget.teklifId).get(),
        builder: (context, teklifSnapshot) {
          if (!teklifSnapshot.hasData) return const Center(child: CircularProgressIndicator(color: primaryGreen));
          var teklif = teklifSnapshot.data!.data() as Map<String, dynamic>?;
          bool isOnaylandi = teklif?['durum'] == 'onaylandi';
          bool isTamamlandi = teklif?['durum'] == 'tamamlandi';

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('ilanlar').doc(widget.ilanId).get(),
            builder: (context, ilanSnapshot) {
              if (!ilanSnapshot.hasData) return const Center(child: CircularProgressIndicator(color: primaryGreen));
              var ilan = ilanSnapshot.data!.data() as Map<String, dynamic>?;
              String musteriId = ilan?['userId'] ?? "";

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(musteriId).get(),
                builder: (context, userSnapshot) {
                  var musteri = userSnapshot.data?.data() as Map<String, dynamic>?;

                  return FutureBuilder<String>(
                      future: _formatKonumMetni(ilan?['konumMetin'] ?? ""),
                      builder: (context, konumSnapshot) {
                        String formatliKonum = konumSnapshot.data ?? ilan?['konumMetin'] ?? "Konum bilgisi yok";

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _bolumBasligi("Müşteri Bilgileri"),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                                child: Column(
                                  children: [
                                    _iletisimSatiri(Icons.person_outline, "Ad Soyad",
                                        "${musteri?['firstName'] ?? ""} ${musteri?['lastName'] ?? ""}".trim().isEmpty ? (musteri?['name'] ?? "Müşteri") : "${musteri?['firstName'] ?? ""} ${musteri?['lastName'] ?? ""}"),
                                    const Divider(height: 1),
                                    _iletisimSatiri(Icons.phone_outlined, "Telefon", musteri?['phone'] ?? "Gizli",
                                        trailing: musteri?['phone'] != null ? IconButton(icon: const Icon(Icons.call, color: primaryGreen), onPressed: () => _ara(musteri?['phone'])) : null),
                                    const Divider(height: 1),
                                    _iletisimSatiri(Icons.map_outlined, "Adres", musteri?['address_detail'] ?? musteri?['adres'] ?? "Adres bilgisi mevcut değil"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              _bolumBasligi("İş Konumu"),
                              _bilgiKarti(icon: Icons.location_on_outlined, baslik: "Konum", icerik: formatliKonum),
                              const SizedBox(height: 20),

                              _bolumBasligi("İşin Detayları"),
                              _bilgiKarti(baslik: ilan?['baslik'] ?? "İlan Başlığı", icerik: ilan?['aciklama'] ?? ilan?['isTanimi'] ?? "Detay belirtilmemiş."),

                              if (ilan?['teknikDetaylar'] != null && ilan!['teknikDetaylar'] is Map)
                                ...((ilan['teknikDetaylar'] as Map<String, dynamic>).entries.map((e) {
                                  String label = e.key.replaceAll('_', ' ');
                                  return _bilgiKarti(baslik: label[0].toUpperCase() + label.substring(1), icerik: e.value.toString());
                                })),

                              const SizedBox(height: 20),

                              _bolumBasligi("Gönderdiğiniz Teklif"),
                              _bilgiKarti(icon: Icons.payments_outlined, baslik: "Teklif Tutarınız", icerik: _formatPrice((teklif?['teklifFiyat'] ?? 0).toDouble()), highlightColor: primaryGreen),

                              _bilgiKarti(
                                  icon: Icons.info_outline,
                                  baslik: "Teklif Durumu",
                                  icerik: isTamamlandi ? "TAMAMLANDI" : (isOnaylandi ? "ONAYLANDI" : "BEKLEMEDE"),
                                  highlightColor: isTamamlandi ? Colors.blue : (isOnaylandi ? Colors.green : Colors.orange)
                              ),

                              if (teklif != null && teklif['mesaj'] is String && teklif['mesaj'].toString().trim().isNotEmpty)
                                _bilgiKarti(icon: Icons.chat_bubble_outline, baslik: "Teklif Mesajınız", icerik: teklif['mesaj']),

                              const SizedBox(height: 30),

                              if (isOnaylandi) ...[
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isiTamamla,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text("İŞİ TAMAMLA VE TESLİM ET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryGreen,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                                  label: const Text("Müşteriye Mesaj Yaz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        );
                      }
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _iletisimSatiri(IconData icon, String baslik, String icerik, {Widget? trailing}) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[50], shape: BoxShape.circle), child: Icon(icon, color: Colors.blueGrey, size: 18)),
      title: Text(baslik, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      subtitle: Text(icerik, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
      trailing: trailing,
    );
  }

  Widget _bolumBasligi(String baslik) => Padding(padding: const EdgeInsets.only(bottom: 12, left: 4), child: Text(baslik, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 0.5)));

  Widget _bilgiKarti({IconData? icon, required String baslik, required String icerik, Color? highlightColor}) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))]
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: highlightColor ?? Colors.grey[400], size: 22),
          const SizedBox(width: 12),
        ],
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(baslik, style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
          const SizedBox(height: 6),
          Text(icerik, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: highlightColor ?? Colors.black87, height: 1.4))
        ])),
      ],
    ),
  );
}