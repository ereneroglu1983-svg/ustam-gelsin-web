// lib/features/musteri/screens/musteri_register.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:ustam_gelsin/core/theme/app_theme.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';

class MusteriRegisterPage extends StatefulWidget {
  final String role;

  const MusteriRegisterPage({super.key, required this.role});

  @override
  State<MusteriRegisterPage> createState() => _MusteriRegisterPageState();
}

class _MusteriRegisterPageState extends State<MusteriRegisterPage> {
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final _mailController = TextEditingController();
  final _telefonController = TextEditingController();
  final _adresController = TextEditingController();
  final _sifre1Controller = TextEditingController();
  final _sifre2Controller = TextEditingController();

  List<dynamic> _sehirler = [];
  List<dynamic> _tumIlceler = [];
  List<dynamic> _filtrelenmisIlceler = [];
  String? _selectedSehirId;
  String? _selectedIlceId;
  bool _isLoading = true;

  // YASAL ONAY DEĞİŞKENLERİ
  bool _sozlesmeKabul = false;
  bool _kvkkKabul = false;
  bool _acikRizaKabul = false;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _mailController.dispose();
    _telefonController.dispose();
    _adresController.dispose();
    _sifre1Controller.dispose();
    _sifre2Controller.dispose();
    super.dispose();
  }

  Future<void> _sozlesmeyiGoster(BuildContext context) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('musteri_sozlesme')
          .get();

      String metin = "";
      if (doc.exists && (doc.data() as Map<String, dynamic>).containsKey('metin')) {
        metin = doc['metin'];
      } else {
        final String response = await rootBundle.loadString('assets/data/musteri_sozlesme.json');
        final data = await json.decode(response);
        metin = data['metin'];
      }

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Müşteri Sözleşmesi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(child: Text(metin)),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Kapat"))],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sözleşme yüklenirken hata oluştu.")));
    }
  }

  Future<void> _loadJsonData() async {
    try {
      final sehirString = await rootBundle.loadString('assets/data/sehirler.json');
      final ilceString = await rootBundle.loadString('assets/data/ilceler.json');
      if (mounted) {
        setState(() {
          _sehirler = jsonDecode(sehirString);
          _tumIlceler = jsonDecode(ilceString);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("JSON Yükleme Hatası: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSehirChanged(String? val) {
    if (val == null) return;
    setState(() {
      _selectedSehirId = val;
      _selectedIlceId = null;
      _filtrelenmisIlceler = _tumIlceler
          .where((item) => item['sehir_id'].toString() == val)
          .toList();
    });
  }

  Future<void> _kayitOl() async {
    if (!_sozlesmeKabul || !_kvkkKabul || !_acikRizaKabul) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm yasal onayları işaretleyin!")));
      return;
    }
    if (_selectedSehirId == null || _selectedIlceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen şehir ve ilçe seçin!")));
      return;
    }

    if (_adController.text.trim().isEmpty || _soyadController.text.trim().isEmpty || _mailController.text.trim().isEmpty || _sifre1Controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen zorunlu alanları doldurun!")));
      return;
    }

    if (_sifre1Controller.text != _sifre2Controller.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şifreler uyuşmuyor!")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      String ipAddress = await Ipify.ipv4();

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _mailController.text.trim(),
        password: _sifre1Controller.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'firstName': _adController.text.trim(),
        'lastName': _soyadController.text.trim(),
        'name': "${_adController.text.trim()} ${_soyadController.text.trim()}",
        'email': _mailController.text.trim(),
        'phone': _telefonController.text.trim(),
        'sehir_id': _selectedSehirId,
        'ilce_id': _selectedIlceId,
        'adres': _adresController.text.trim(),
        'role': widget.role,
        'createdAt': FieldValue.serverTimestamp(),
        'uid': credential.user!.uid,
        'ipKaydi': ipAddress,
        'cihazBilgisi': Platform.operatingSystem,
        // YASAL RIZA KAYITLARI (GÜVENLİK PROTOKOLÜ)
        'riza_tarihleri': {
          'sozlesme': _sozlesmeKabul ? Timestamp.now() : null,
          'kvkk': _kvkkKabul ? Timestamp.now() : null,
          'acikRiza': _acikRizaKabul ? Timestamp.now() : null,
        },
      });

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MusteriProfilSayfasi()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(label, style: const TextStyle(color: AppColors.white70, fontSize: 13)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Müşteri İşlemleri", style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientMid,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.white))
            : SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Müşteri Kaydı", style: TextStyle(color: AppColors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Ad"),
                          TextField(
                              controller: _adController,
                              style: const TextStyle(color: AppColors.white),
                              decoration: AppDecorations.inputDecoration.copyWith(hintText: "Adınız")),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Soyad"),
                          TextField(
                              controller: _soyadController,
                              style: const TextStyle(color: AppColors.white),
                              decoration: AppDecorations.inputDecoration.copyWith(hintText: "Soyadınız")),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInputLabel("E-Mail"),
                TextField(
                    controller: _mailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.white),
                    decoration: AppDecorations.inputDecoration.copyWith(hintText: "E-mail adresiniz")),
                const SizedBox(height: 20),
                _buildInputLabel("Telefon"),
                TextField(
                    controller: _telefonController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: AppColors.white),
                    decoration: AppDecorations.inputDecoration.copyWith(hintText: "Telefon numaranız")),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Şehir"),
                          DropdownButtonFormField<String>(
                            value: _selectedSehirId,
                            isExpanded: true,
                            dropdownColor: AppColors.primaryGradientMid,
                            style: const TextStyle(color: AppColors.white, fontSize: 14),
                            decoration: AppDecorations.inputDecoration,
                            items: _sehirler.map((sehir) {
                              return DropdownMenuItem<String>(
                                value: sehir['sehir_id'].toString(),
                                child: Text(sehir['sehir_adi'], overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: _onSehirChanged,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("İlçe"),
                          DropdownButtonFormField<String>(
                            value: _selectedIlceId,
                            isExpanded: true,
                            dropdownColor: AppColors.primaryGradientMid,
                            style: const TextStyle(color: AppColors.white, fontSize: 14),
                            decoration: AppDecorations.inputDecoration,
                            items: _filtrelenmisIlceler.map((ilce) {
                              return DropdownMenuItem<String>(
                                value: ilce['ilce_id'].toString(),
                                child: Text(ilce['ilce_adi'], overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedIlceId = val),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInputLabel("Açık Adres"),
                TextField(
                    controller: _adresController,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: AppColors.white),
                    maxLines: 2,
                    decoration: AppDecorations.inputDecoration.copyWith(hintText: "Adres bilgileriniz...")),
                const SizedBox(height: 20),
                _buildInputLabel("Şifre"),
                TextField(
                    controller: _sifre1Controller,
                    style: const TextStyle(color: AppColors.white),
                    obscureText: true,
                    decoration: AppDecorations.inputDecoration.copyWith(hintText: "Şifre oluşturun")),
                const SizedBox(height: 20),
                _buildInputLabel("Şifre Tekrar"),
                TextField(
                    controller: _sifre2Controller,
                    style: const TextStyle(color: AppColors.white),
                    obscureText: true,
                    decoration: AppDecorations.inputDecoration.copyWith(hintText: "Şifreyi tekrar girin")),
                const SizedBox(height: 20),
                CheckboxListTile(
                  value: _sozlesmeKabul,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text("Kullanıcı Sözleşmesini okudum ve kabul ediyorum.", style: TextStyle(color: Colors.white, fontSize: 12)),
                  onChanged: (v) => setState(() => _sozlesmeKabul = v!),
                ),
                CheckboxListTile(
                  value: _kvkkKabul,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text("KVKK Aydınlatma Metnini okudum.", style: TextStyle(color: Colors.white, fontSize: 12)),
                  onChanged: (v) => setState(() => _kvkkKabul = v!),
                ),
                CheckboxListTile(
                  value: _acikRizaKabul,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text("Kişisel verilerimin eşleştirme amacıyla paylaşılmasına açık rıza veriyorum.", style: TextStyle(color: Colors.white, fontSize: 12)),
                  onChanged: (v) => setState(() => _acikRizaKabul = v!),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => _sozlesmeyiGoster(context),
                    child: const Text("Sözleşme Metnini İncele", style: TextStyle(color: Colors.orange)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _kayitOl,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5E9),
                      foregroundColor: const Color(0xFF2D4B2A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: AppColors.primaryGradientMid)
                        : const Text("KAYIT OL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}