// lib/features/ads/screens/usta_ilan_detay_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/models/user_model.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/services/wallet_service.dart';
import 'package:intl/intl.dart';

class UstaIlanDetaySayfasi extends StatefulWidget {
  final IlanModel ilan;
  final UserModel? usta; // UserModel opsiyonel yapıldı

  const UstaIlanDetaySayfasi({super.key, required this.ilan, this.usta});

  @override
  State<UstaIlanDetaySayfasi> createState() => _UstaIlanDetaySayfasiState();
}

class _UstaIlanDetaySayfasiState extends State<UstaIlanDetaySayfasi> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color _ustaRengi = Colors.orange;
  final WalletService _walletService = WalletService();

  final TextEditingController _fiyatController = TextEditingController();
  final TextEditingController _mesajController = TextEditingController();

  String _maskeliAd = "Yükleniyor...";
  String _formatliKonum = "Yükleniyor...";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _verileriYukle();
  }

  @override
  void dispose() {
    _fiyatController.dispose();
    _mesajController.dispose();
    super.dispose();
  }

  Future<void> _verileriYukle() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.ilan.userId).get();
      if (userDoc.exists) {
        String ad = userDoc.get('firstName') ?? "Müşteri";
        String soyad = userDoc.get('lastName') ?? "";
        String soyadHarf = soyad.isNotEmpty ? soyad[0].toUpperCase() : "";
        setState(() => _maskeliAd = "${ad[0].toUpperCase()}${ad.substring(1).toLowerCase()} $soyadHarf.");
      }
    } catch (_) { setState(() => _maskeliAd = "Müşteri"); }

    final k = await _formatKonumMetni(widget.ilan.konumMetin);
    setState(() => _formatliKonum = k);
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

  double _fiyatSayiyaCevir(String? fiyat) {
    if (fiyat == null) return 0.0;
    String temizFiyat = fiyat.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(temizFiyat) ?? 0.0;
  }

  Future<void> _teklifVer() async {
    final ustaId = FirebaseAuth.instance.currentUser!.uid;
    final komisyon = _fiyatSayiyaCevir(widget.ilan.fiyatBilgisi) * 0.01;
    final teklifFiyat = double.tryParse(_fiyatController.text.replaceAll('.', '')) ?? 0.0;

    if (teklifFiyat <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen geçerli bir fiyat girin!")));
      return;
    }

    try {
      bool basarili = await _walletService.bakiyeDus(ustaId, komisyon);
      if (!basarili) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Yetersiz bakiye!")));
        return;
      }

      await FirebaseFirestore.instance.collection('teklifler').add({
        'ilanId': widget.ilan.id,
        'ustaId': ustaId,
        'tarih': DateTime.now().toIso8601String(),
        'durum': 'beklemede',
        'kesilenKomisyon': komisyon,
        'teklifFiyat': teklifFiyat,
        'not': _mesajController.text,
        'ilanBaslik': widget.ilan.baslik.isNotEmpty ? widget.ilan.baslik : "İş İlanı",
        'ilanKonum': _formatliKonum,
        'musteriAdi': _maskeliAd,
        'musteriUserId': widget.ilan.userId,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teklifiniz başarıyla iletildi!")));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("İlan Detayı", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        bottom: TabBar(controller: _tabController, indicatorColor: _ustaRengi, tabs: const [Tab(text: "Detay"), Tab(text: "Mesajlar")]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildGlassCard("İş Bilgileri", [
                  _detayRow("Müşteri:", _maskeliAd),
                  _detayRow("Konum:", _formatliKonum),
                  ...widget.ilan.teknikDetaylar.entries.map((e) {
                    String label = e.key.replaceAll('_', ' ');
                    if (label.toLowerCase() == 'zemin durumu') label = 'Zemin Tadilatı';
                    return _detayRow("${label[0].toUpperCase() + label.substring(1)}:", e.value.toString());
                  }),
                ]),
                const SizedBox(height: 20),
                _buildGlassCard("Teklif Ver", [
                  TextField(
                    controller: _fiyatController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: "Fiyat Teklifiniz (TL)", labelStyle: TextStyle(color: Colors.white70)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _mesajController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: "Müşteriye Notunuz", labelStyle: TextStyle(color: Colors.white70)),
                  ),
                ]),
                const SizedBox(height: 80),
              ],
            ),
          ),
          const Center(child: Text("Teklif sonrası açılır.", style: TextStyle(color: Colors.white60))),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    double komisyon = _fiyatSayiyaCevir(widget.ilan.fiyatBilgisi) * 0.01;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _teklifVer,
          style: ElevatedButton.styleFrom(backgroundColor: _ustaRengi, minimumSize: const Size(double.infinity, 60)),
          child: Text("TEKLİF VER (${komisyon.toStringAsFixed(0)} TL)", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _detayRow(String l, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l, style: const TextStyle(color: Colors.white60)),
            const SizedBox(width: 15),
            Expanded(child: Text(v, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
          ]
      )
  );

  Widget _buildGlassCard(String title, List<Widget> children) => Container(padding: const EdgeInsets.all(20), margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(title, style: TextStyle(color: _ustaRengi, fontWeight: FontWeight.bold)), ...children]));
}