// lib/web_dosyalari/musteri_kayit_ekrani.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusteriKayitEkrani extends StatefulWidget {
  const MusteriKayitEkrani({super.key});

  @override
  State<MusteriKayitEkrani> createState() => _MusteriKayitEkraniState();
}

class _MusteriKayitEkraniState extends State<MusteriKayitEkrani> {
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

  bool _sozlesmeKabul = false;
  bool _kvkkKabul = false;
  bool _acikRizaKabul = false;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sozlesmeyiGoster(BuildContext context) async {
    try {
      final String response = await rootBundle.loadString('assets/data/musteri_sozlesme.json');
      final data = await json.decode(response);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(data['baslik'] ?? "Sözleşme"),
          content: SingleChildScrollView(child: Text(data['metin'] ?? "")),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Kapat"))],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sözleşme yüklenirken hata oluştu.")));
    }
  }

  void _onSehirChanged(String? val) {
    setState(() {
      _selectedSehirId = val;
      _selectedIlceId = null;
      _filtrelenmisIlceler = _tumIlceler.where((item) => item['sehir_id'].toString() == val).toList();
    });
  }

  Future<void> _kayitOl() async {
    if (!_sozlesmeKabul || !_kvkkKabul || !_acikRizaKabul) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm yasal onayları işaretleyin!")));
      return;
    }
    if (_sifre1Controller.text != _sifre2Controller.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şifreler uyuşmuyor!")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _mailController.text.trim(),
        password: _sifre1Controller.text.trim(),
      );
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'firstName': _adController.text.trim(),
        'lastName': _soyadController.text.trim(),
        'email': _mailController.text.trim(),
        'phone': _telefonController.text.trim(),
        'sehir_id': _selectedSehirId,
        'ilce_id': _selectedIlceId,
        'adres': _adresController.text.trim(),
        'role': 'musteri',
        'createdAt': FieldValue.serverTimestamp(),
        'ipKaydi': "Web Kaydı",
        'riza_tarihleri': {
          'sozlesme': _sozlesmeKabul ? FieldValue.serverTimestamp() : null,
          'kvkk': _kvkkKabul ? FieldValue.serverTimestamp() : null,
          'acikRiza': _acikRizaKabul ? FieldValue.serverTimestamp() : null,
        },
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kayıt başarılı!")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildDarkTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFDC143C))),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text("Müşteri Kayıt", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC143C)))
          : Center(
        child: SingleChildScrollView(
          child: Container(
            width: 760,
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            padding: const EdgeInsets.all(52),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, spreadRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Müşteri Kayıt Bilgileri", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 50),
                _buildDarkTextField(_adController, "Ad"),
                _buildDarkTextField(_soyadController, "Soyad"),
                _buildDarkTextField(_mailController, "E-mail"),
                _buildDarkTextField(_telefonController, "Telefon"),
                DropdownButtonFormField<String>(
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: "Şehir", labelStyle: TextStyle(color: Colors.white70), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24))),
                  value: _selectedSehirId,
                  items: _sehirler.map((s) => DropdownMenuItem(value: s['sehir_id'].toString(), child: Text(s['sehir_adi'], style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: _onSehirChanged,
                ),
                const SizedBox(height: 25),
                DropdownButtonFormField<String>(
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: "İlçe", labelStyle: TextStyle(color: Colors.white70), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24))),
                  value: _selectedIlceId,
                  items: _filtrelenmisIlceler.map((i) => DropdownMenuItem(value: i['ilce_id'].toString(), child: Text(i['ilce_adi'], style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: (val) => setState(() => _selectedIlceId = val),
                ),
                const SizedBox(height: 25),
                _buildDarkTextField(_adresController, "Adres"),
                _buildDarkTextField(_sifre1Controller, "Şifre", obscure: true),
                _buildDarkTextField(_sifre2Controller, "Şifre Tekrar", obscure: true),
                CheckboxListTile(value: _sozlesmeKabul, title: const Text("Kullanici Sözleşmesini okudum ve kabul ediyorum.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _sozlesmeKabul = v!)),
                CheckboxListTile(value: _kvkkKabul, title: const Text("KVKK Aydinlatma Metnini okudum.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _kvkkKabul = v!)),
                CheckboxListTile(value: _acikRizaKabul, title: const Text("Kisisel verilerimin eslestirme amaciyla paylasilmasina açik riza veriyorum.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _acikRizaKabul = v!)),
                Center(child: TextButton(onPressed: () => _sozlesmeyiGoster(context), child: const Text("Sözleşme Metnini İncele", style: TextStyle(color: Colors.orange)))),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: ElevatedButton(
                    onPressed: _kayitOl,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: const Text("KAYIT OL", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}