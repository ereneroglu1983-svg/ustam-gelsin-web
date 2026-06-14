// lib/features/musteri/screens/musteri_acil_ustam_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';

class MusteriAcilUstamSayfasi extends StatefulWidget {
  const MusteriAcilUstamSayfasi({super.key});

  @override
  State<MusteriAcilUstamSayfasi> createState() => _MusteriAcilUstamSayfasiState();
}

class _MusteriAcilUstamSayfasiState extends State<MusteriAcilUstamSayfasi> {
  final TextEditingController _sorunController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _geoHasher = GeoHasher();

  String? _secilenKategori;
  String? _secilenKategoriId;

  String? _secilenIl;
  String? _secilenIlce;
  String? _secilenIlId;
  String? _secilenIlceId;

  double? _lat;
  double? _long;

  bool _konumYukleniyor = true;
  bool _isPublishing = false;

  final List<Map<String, String>> _acilKategoriler = [
    {'ad': '💧 Tesisatçı', 'id': 'tesisatci'},
    {'ad': '⚡ Elektrikçi', 'id': 'elektrikci'},
    {'ad': '🔑 Çilingir', 'id': 'cilingir'},
    {'ad': '❄️ Kombi / Klima', 'id': 'kombi_klima'},
  ];

  @override
  void initState() {
    super.initState();
    _otomatikKonumHazirla();
  }

  Future<void> _otomatikKonumHazirla() async {
    try {
      await LocationService.loadSehirler();
      final sonuc = await LocationService.otomatikKonumTespitEt();

      if (sonuc != null && mounted) {
        setState(() {
          _secilenIl = sonuc['sehir_adi'];
          _secilenIlId = sonuc['sehir_id'];
          _secilenIlce = sonuc['ilce_adi'];
          _secilenIlceId = sonuc['ilce_id'];
          _lat = (sonuc['latitude'] ?? 0.0).toDouble();
          _long = (sonuc['longitude'] ?? 0.0).toDouble();
        });
      }
    } catch (e) {
      debugPrint("Acil konum tespiti hatası: $e");
    } finally {
      if (mounted) {
        setState(() => _konumYukleniyor = false);
      }
    }
  }

  @override
  void dispose() {
    _sorunController.dispose();
    super.dispose();
  }

  Future<void> _acilCagriOlustur() async {
    if (!_formKey.currentState!.validate() || _secilenKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen bir kategori seçin ve sorununuzu belirtin.")),
      );
      return;
    }

    if (_secilenIl == null || _secilenIlce == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konumunuz tespit edilemedi.")),
      );
      return;
    }

    // Konum doğrulama
    if (_lat == null || _long == null || _lat == 0.0 || _long == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konum verisi alınamadığı için ilan oluşturulamaz.")),
      );
      return;
    }

    setState(() => _isPublishing = true);

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      String musteriAd = "Müşteri";
      String musteriTelefon = "";

      if (userDoc.exists) {
        var data = userDoc.data();
        if (data != null) {
          String ad = data['firstName'] ?? "";
          String soyad = data['lastName'] ?? "";
          musteriAd = (ad.isNotEmpty || soyad.isNotEmpty) ? "$ad $soyad" : (data['name'] ?? "Müşteri");
          musteriTelefon = data['phoneNumber'] ?? data['phone'] ?? "";
        }
      }

      String geo = _geoHasher.encode(_long!, _lat!, precision: 5);

      final acilIlan = IlanModel(
        id: '',
        baslik: "7/24 ACİL ${_secilenKategori!.substring(2).toUpperCase()}",
        kategori: _secilenKategori!,
        kategoriId: _secilenKategoriId!,
        teknikDetaylar: {
          'isAcil': true,
          'acilDurumTipi': _secilenKategoriId,
          'kilitAcildi': false,
          'musteriKonumGeohash': geo,
        },
        detaylar: _sorunController.text.trim(),
        fiyatBilgisi: "ACİL SERVİS / İLK ONAYLAYAN ALIR",
        tarih: DateTime.now().toIso8601String(),
        durum: 'aktif',
        userId: user.uid,
        musteriAd: musteriAd,
        musteriTelefon: musteriTelefon,
        maskeliAd: musteriAd.toUpperCase(),
        konumMetin: "$_secilenIl / $_secilenIlce",
        ilId: _secilenIlId ?? '',
        ilceId: _secilenIlceId ?? '',
        komisyonTutari: 250.0,
      );

      await AdService().ilanOlustur(acilIlan);

      if (mounted) _basariEkraniniGoster();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  void _basariEkraniniGoster() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Color(0xFF203A43),
        title: Row(children: [Icon(Icons.check_circle, color: Color(0xFF2DB34A)), SizedBox(width: 10), Text("Çağrı Gönderildi", style: TextStyle(color: Colors.white, fontSize: 18))]),
        content: Text("Acil çağrınız bölgedeki 7/24 aktif ustalara iletildi.", style: TextStyle(color: Colors.white70)),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () { if (mounted) { Navigator.pop(context); Navigator.pop(context); } });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("7/24 ACİL USTA ÇAĞRISI", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF203A43)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: _konumYukleniyor ? const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))) : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
                  child: Row(children: [const Icon(Icons.my_location, color: Color(0xFF2DB34A), size: 20), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Mevcut Konumunuz", style: TextStyle(color: Colors.white54, fontSize: 11)), Text((_secilenIl != null) ? "$_secilenIl / $_secilenIlce".toUpperCase() : "KONUM ALINAMADI", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))]))]),
                ),
                const SizedBox(height: 25),
                const Text("ACİL İHTİYACINIZ OLAN KATEGORİ", style: TextStyle(color: Color(0xFF2DB34A), fontWeight: FontWeight.bold, fontSize: 12)),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.2),
                  itemCount: _acilKategoriler.length,
                  itemBuilder: (context, index) {
                    final kat = _acilKategoriler[index];
                    final isSelected = _secilenKategoriId == kat['id'];
                    return InkWell(
                      onTap: () => setState(() { _secilenKategori = kat['ad']; _secilenKategoriId = kat['id']; }),
                      child: Container(decoration: BoxDecoration(color: isSelected ? const Color(0xFF2DB34A).withOpacity(0.2) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: isSelected ? const Color(0xFF2DB34A) : Colors.white10)), alignment: Alignment.center, child: Text(kat['ad']!, style: TextStyle(color: isSelected ? Colors.white : Colors.white70))),
                    );
                  },
                ),
                const SizedBox(height: 30),
                const Text("SORUNUNUZ NEDİR?", style: TextStyle(color: Color(0xFF2DB34A), fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _sorunController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
                  validator: (value) => (value == null || value.trim().isEmpty) ? "Lütfen açıklayın." : null,
                ),
                const SizedBox(height: 40),
                SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _isPublishing ? null : _acilCagriOlustur, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("ACİL ÇAĞRI OLUŞTUR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}