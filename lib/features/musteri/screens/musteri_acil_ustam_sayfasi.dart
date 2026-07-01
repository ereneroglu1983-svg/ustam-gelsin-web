// lib/features/musteri/screens/musteri_acil_ustam_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/services/acil_is_yonetim_servisi.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:geolocator/geolocator.dart';

class MusteriAcilUstamSayfasi extends StatefulWidget {
  const MusteriAcilUstamSayfasi({super.key});

  @override
  State<MusteriAcilUstamSayfasi> createState() => _MusteriAcilUstamSayfasiState();
}

class _MusteriAcilUstamSayfasiState extends State<MusteriAcilUstamSayfasi> {
  final TextEditingController _sorunController = TextEditingController();
  final TextEditingController _adresDetayController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _geoHasher = GeoHasher();
  final AcilIsYonetimServisi _acilServis = AcilIsYonetimServisi();

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
    {'ad': '💧 Tesisatçı', 'id': 'SIHHİ TESİSAT VE PİS SU TESİSATI'},
    {'ad': '⚡ Elektrikçi', 'id': 'ELEKTRİK TESİSATI'},
    {'ad': '🔑 Çilingir', 'id': 'ÇİLİNGİR'},
    {'ad': '❄️ Kombi / Klima', 'id': 'KLİMA MONTAJ , BAKIM VE GAZ DOLUMU'},
    {'ad': '🛗 Asansör Bakım', 'id': 'ASANSÖR BAKIM VE ONARIM'},
  ];

  @override
  void initState() {
    super.initState();
    _konumVeIzinKontrolu();
  }

  Future<void> _konumVeIzinKontrolu() async {
    bool servisAktif = await LocationService.konumServisiAktifMi();
    if (!servisAktif) {
      if (mounted) _konumKapaliUyarisiGoster();
      return;
    }

    try {
      await _acilServis.konumKontrolVeAl();
      await _otomatikKonumHazirla();
    } catch (e) {
      debugPrint("Konum servisi devre dışı veya hata: $e");
      setState(() => _konumYukleniyor = false);
    }
  }

  void _konumKapaliUyarisiGoster() {
    setState(() => _konumYukleniyor = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Konum Servisi Kapalı!"),
        content: const Text("Ustamın sizi bulabilmesi için lütfen telefonunuzun konum (GPS) özelliğini aktif edin."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("TAMAM")),
        ],
      ),
    );
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
      debugPrint("Konum otomatik alınamadı: $e");
    } finally {
      if (mounted) setState(() => _konumYukleniyor = false);
    }
  }

  @override
  void dispose() {
    _sorunController.dispose();
    _adresDetayController.dispose();
    super.dispose();
  }

  Future<void> _acilCagriOlustur() async {
    // Kategori, adres ve sorun alanlarını kontrol et
    if (!_formKey.currentState!.validate() || _secilenKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen kategori seçin ve gerekli tüm alanları doldurun.")));
      return;
    }

    if (_lat == null || _lat == 0.0 || _long == null || _long == 0.0) {
      bool servisAktif = await LocationService.konumServisiAktifMi();
      if (!servisAktif) {
        _konumKapaliUyarisiGoster();
        return;
      }
      await _otomatikKonumHazirla();
    }

    setState(() => _isPublishing = true);

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Oturum bulunamadı");
      if (_lat == 0.0 || _long == 0.0) throw Exception("Konumunuz alınamadı, lütfen tekrar deneyin.");

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      String musteriAd = "Müşteri";
      String musteriTelefon = "";
      if (userDoc.exists) {
        var data = userDoc.data();
        if (data != null) {
          musteriAd = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
          musteriTelefon = data['phoneNumber'] ?? data['phone'] ?? "";
        }
      }

      String geo = _geoHasher.encode(_long!, _lat!, precision: 5);
      final String standardizedKategoriId = _secilenKategoriId!.trim().toUpperCase();

      dynamic acilDurumTipi = standardizedKategoriId;
      if (standardizedKategoriId == 'KLİMA MONTAJ , BAKIM VE GAZ DOLUMU') {
        acilDurumTipi = [
          'KLİMA MONTAJ , BAKIM VE GAZ DOLUMU',
          'DOĞALGAZ TESİSATI VE KOMBİ MONTAJI/BAKIMI'
        ];
      }

      final acilIlan = IlanModel(
        id: '',
        isAcil: true,
        baslik: "7/24 ACİL ${_secilenKategori!.toUpperCase()}",
        kategori: _secilenKategori!,
        kategoriId: standardizedKategoriId,
        teknikDetaylar: {
          'isAcil': true,
          'acilDurumTipi': acilDurumTipi,
          'kilitAcildi': false,
          'musteriKonumGeohash': geo,
          'latitude': _lat,
          'longitude': _long,
          'acikAdres': _adresDetayController.text.trim(),
        },
        detaylar: _sorunController.text.trim(),
        fiyatBilgisi: "ACİL SERVİS",
        tarih: DateTime.now().toIso8601String(),
        durum: 'bekliyor',
        userId: user.uid,
        musteriAd: musteriAd,
        musteriTelefon: musteriTelefon,
        maskeliAd: musteriAd.toUpperCase(),
        konumMetin: (_secilenIl != null) ? "$_secilenIl / $_secilenIlce" : "Konum Belirtilmedi",
        ilId: _secilenIlId ?? '',
        ilceId: _secilenIlceId ?? '',
        komisyonTutari: 250.0,
      );

      await AdService().ilanOlustur(acilIlan);
      if (mounted) _basariEkraniniGoster();

    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: ${e.toString().replaceAll("Exception: ", "")}")));
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
        content: Text("Acil çağrınız bölgedeki ustalara iletildi.", style: TextStyle(color: Colors.white70)),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
                onPressed: _isPublishing ? null : _acilCagriOlustur,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: _isPublishing
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("ACİL ÇAĞRI OLUŞTUR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            ),
          ),
        ),
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
                const SizedBox(height: 15),
                const Text("ADRES DETAYI (Bina No / Daire / Kat)", style: TextStyle(color: Color(0xFF2DB34A), fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _adresDetayController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(hintText: "Örn: Örnek Mah. 12. Sokak No:5 Daire:3", hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
                  validator: (value) => (value == null || value.trim().isEmpty) ? "Lütfen adres detayını girin." : null,
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}