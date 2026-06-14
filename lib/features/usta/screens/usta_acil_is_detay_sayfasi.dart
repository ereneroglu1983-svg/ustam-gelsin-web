// lib/features/usta/screens/usta_acil_is_detay_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/acil_is_yonetim_servisi.dart';
import 'package:url_launcher/url_launcher.dart';

class UstaAcilIsDetaySayfasi extends StatefulWidget {
  final Map<String, dynamic> ilanData;
  final String ilanId;

  const UstaAcilIsDetaySayfasi({
    super.key,
    required this.ilanData,
    required this.ilanId,
  });

  @override
  State<UstaAcilIsDetaySayfasi> createState() => _UstaAcilIsDetaySayfasiState();
}

class _UstaAcilIsDetaySayfasiState extends State<UstaAcilIsDetaySayfasi> {
  final AcilIsYonetimServisi _yonetimServisi = AcilIsYonetimServisi();
  bool _isProcessing = false;
  final String _currentUstaId = FirebaseAuth.instance.currentUser?.uid ?? '';

  String _maskeleMusteriAdi(String tamAd) {
    if (tamAd.isEmpty) return "Müşteri";
    List<String> parcalar = tamAd.trim().split(" ");
    if (parcalar.length > 1) {
      String soyad = parcalar.last;
      String adlar = parcalar.sublist(0, parcalar.length - 1).join(" ");
      if (soyad.isNotEmpty) {
        return "$adlar ${soyad[0]}.";
      }
    }
    return tamAd;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('ilanlar').doc(widget.ilanId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFF0F2027),
            body: Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))),
          );
        }

        var currentIlan = snapshot.data!.data() as Map<String, dynamic>? ?? widget.ilanData;
        String durum = currentIlan['durum'] ?? 'aktif';
        String? secilenUstaId = currentIlan['secilenUstaId'];
        bool kilitAcik = (durum == 'eslesti' && secilenUstaId == _currentUstaId);

        String musteriTelefon = currentIlan['musteriTelefon'] ?? "05xxxxxxxxx";
        String orijinalMusteriAdi = currentIlan['musteriAd'] ?? "Müşteri";

        return Scaffold(
          backgroundColor: const Color(0xFF0F2027),
          appBar: AppBar(
            title: const Text("7/24 ACİL İŞ DETAYI", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
          ),
          body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF203A43)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.redAccent.withOpacity(0.3))),
                    child: const Row(children: [Icon(Icons.flash_on, color: Colors.amber, size: 24), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("7/24 ANLIK ACİL ÇAĞRI", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)), SizedBox(height: 2), Text("İlk onaylayan usta işi alır. Sabit komisyon 250 TL'dir.", style: TextStyle(color: Colors.white70, fontSize: 12))]))]),
                  ),
                  const SizedBox(height: 25),
                  Text(currentIlan['kategori'] ?? 'Kategori', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [const Icon(Icons.location_on, color: Color(0xFF2DB34A), size: 16), const SizedBox(width: 5), Text(currentIlan['konumMetin'] ?? 'Konum Bilgisi', style: const TextStyle(color: Colors.white70, fontSize: 14))]),
                  const Divider(color: Colors.white10, height: 40),
                  const Text("MÜŞTERİ BİLGİLERİ", style: TextStyle(color: Color(0xFF2DB34A), fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 12),
                  Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(15)), child: Row(children: [Icon(kilitAcik ? Icons.person : Icons.person_outline, color: Colors.white70), const SizedBox(width: 15), Text(kilitAcik ? orijinalMusteriAdi : _maskeleMusteriAdi(orijinalMusteriAdi), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))])),
                  const SizedBox(height: 15),
                  Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(15)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(kilitAcik ? Icons.phone : Icons.phone_locked, color: kilitAcik ? const Color(0xFF2DB34A) : Colors.white38), const SizedBox(width: 15), Text(kilitAcik ? musteriTelefon : "05XX XXX XX XX", style: TextStyle(color: kilitAcik ? Colors.white : Colors.white38, fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: 1.2))]), if (kilitAcik) IconButton(icon: const Icon(Icons.phone_forwarded, color: Color(0xFF2DB34A)), onPressed: () async { final Uri launchUri = Uri(scheme: 'tel', path: musteriTelefon); if (await canLaunchUrl(launchUri)) { await launchUrl(launchUri); } })])),
                  const Divider(color: Colors.white10, height: 40),
                  const Text("MÜŞTERİNİN AÇIKLAMASI", style: TextStyle(color: Color(0xFF2DB34A), fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 12),
                  Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)), child: Text(currentIlan['detaylar'] ?? 'Açıklama belirtilmedi.', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.4))),
                  const SizedBox(height: 40),
                  if (durum == 'aktif')
                    SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _isProcessing ? null : () async { setState(() => _isProcessing = true); bool basarili = await _yonetimServisi.acilIsiKap(widget.ilanId); setState(() => _isProcessing = false); if (!basarili && context.mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bu iş başka bir usta tarafından kapıldı veya bakiye yetersiz."))); } }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2DB34A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: _isProcessing ? const CircularProgressIndicator(color: Colors.white) : const Text("250 TL KOMİSYON ÖDE VE İŞİ AL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))))
                  else if (kilitAcik)
                    SizedBox(width: double.infinity, height: 55, child: ElevatedButton.icon(onPressed: () { /* Navigator.pushNamed(context, '/chat', arguments: {'ilanId': 'acil_${widget.ilanId}'}); */ }, icon: const Icon(Icons.chat, color: Colors.white), label: const Text("MÜŞTERİ İLE CHAT BAŞLAT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF203A43), side: const BorderSide(color: Color(0xFF2DB34A), width: 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
                  else
                    Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)), alignment: Alignment.center, child: const Text("BU ÇAĞRI BAŞKA BİR USTA TARAFINDAN ALINDI", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 13))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}