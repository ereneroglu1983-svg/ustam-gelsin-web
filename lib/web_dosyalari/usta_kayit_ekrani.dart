// lib/web_dosyalari/usta_kayit_ekrani.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UstaKayitEkrani extends StatefulWidget {
  const UstaKayitEkrani({super.key});

  @override
  State<UstaKayitEkrani> createState() => _UstaKayitEkraniState();
}

class _UstaKayitEkraniState extends State<UstaKayitEkrani> {
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final _ticariUnvanController = TextEditingController();
  final _tcVergiController = TextEditingController();
  final _mernisController = TextEditingController();
  final _mailController = TextEditingController();
  final _telefonController = TextEditingController();
  final _adresController = TextEditingController();
  final _faturaAdresController = TextEditingController();
  final _sifre1Controller = TextEditingController();
  final _sifre2Controller = TextEditingController();

  String? _tcVergiTipi;
  String _faturaAdresTipi = 'ayni';
  bool _mernisYok = false;
  bool _ustalikBelgesiVarMi = false;
  bool _isLoading = true;
  List<String> tumMeslekler = [];
  List<String> secilenMeslekler = [];
  List<dynamic> _sehirler = [];
  List<dynamic> _tumIlceler = [];
  List<dynamic> _filtrelenmisIlceler = [];
  String? _selectedSehirId;
  String? _selectedIlceId;
  bool _sozlesmeKabul = false;
  bool _kvkkKabul = false;
  bool _acikRizaKabul = false;
  bool _yasalYukumlulukKabul = false;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    try {
      final sehirString = await rootBundle.loadString('assets/data/sehirler.json');
      final ilceString = await rootBundle.loadString('assets/data/ilceler.json');
      final meslekString = await rootBundle.loadString('assets/data/meslekler.json');
      setState(() {
        _sehirler = jsonDecode(sehirString);
        _tumIlceler = jsonDecode(ilceString);
        tumMeslekler = List<String>.from(jsonDecode(meslekString));
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onSehirChanged(String? val) {
    setState(() {
      _selectedSehirId = val;
      _selectedIlceId = null;
      _filtrelenmisIlceler = _tumIlceler.where((item) => item['sehir_id'].toString() == val).toList();
    });
  }

  bool _isFormValid() {
    if (_tcVergiTipi == null) return false;
    if (_mailController.text.isEmpty || _telefonController.text.isEmpty || _sifre1Controller.text.isEmpty) return false;
    if (_selectedSehirId == null || _selectedIlceId == null || secilenMeslekler.isEmpty) return false;
    return _sozlesmeKabul && _kvkkKabul && _acikRizaKabul && _yasalYukumlulukKabul;
  }

  Future<void> _sozlesmeyiGoster(BuildContext context) async {
    try {
      final String response = await rootBundle.loadString('assets/data/usta_sozlesme.json');
      final data = await json.decode(response);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(data['baslik'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(child: Text(data['metin'])),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Kapat"))],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sözleşme yüklenirken hata oluştu.")));
    }
  }

  Future<void> _kayitOl() async {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm alanları ve onayları doldurun!")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _mailController.text.trim(),
        password: _sifre1Controller.text.trim(),
      );
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'name': _tcVergiTipi == 'sirket' ? _ticariUnvanController.text.trim() : "${_adController.text.trim()} ${_soyadController.text.trim()}",
        'firstName': _adController.text.trim(),
        'lastName': _soyadController.text.trim(),
        'ticariUnvan': _ticariUnvanController.text.trim(),
        'tcVergiNo': _tcVergiController.text.trim(),
        'mernisNo': _mernisYok ? "MERNIS_YOK" : _mernisController.text.trim(),
        'ustalikBelgesiVarMi': _ustalikBelgesiVarMi,
        'tcVergiTipi': _tcVergiTipi,
        'email': _mailController.text.trim(),
        'phone': _telefonController.text.trim(),
        'adres': _adresController.text.trim(),
        'faturaAdresi': _faturaAdresTipi == 'ayni' ? _adresController.text.trim() : _faturaAdresController.text.trim(),
        'uzmanliklar': secilenMeslekler,
        'sehir_id': _selectedSehirId,
        'ilce_id': _selectedIlceId,
        'role': 'usta',
        'createdAt': FieldValue.serverTimestamp(),
        'ipKaydi': 'Web Kayıt',
        'riza_tarihleri': {
          'sozlesme': _sozlesmeKabul ? FieldValue.serverTimestamp() : null,
          'kvkk': _kvkkKabul ? FieldValue.serverTimestamp() : null,
          'acikRiza': _acikRizaKabul ? FieldValue.serverTimestamp() : null,
          'yasalYukumluluk': _yasalYukumlulukKabul ? FieldValue.serverTimestamp() : null,
        },
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kayıt başarılı!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text("Usta Kayıt Formu", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 2,
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
                const Text("Usta Kayıt Formu", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(child: RadioListTile(title: const Text("Şahıs", style: TextStyle(color: Colors.white)), value: 'sahis', groupValue: _tcVergiTipi, onChanged: (v) => setState(() => _tcVergiTipi = v))),
                    Expanded(child: RadioListTile(title: const Text("Şirket", style: TextStyle(color: Colors.white)), value: 'sirket', groupValue: _tcVergiTipi, onChanged: (v) => setState(() => _tcVergiTipi = v))),
                  ],
                ),
                if (_tcVergiTipi != null) ...[
                  const SizedBox(height: 40),
                  if (_tcVergiTipi == 'sahis') ...[
                    TextField(controller: _adController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Ad", labelStyle: TextStyle(color: Colors.white70))),
                    TextField(controller: _soyadController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Soyad", labelStyle: TextStyle(color: Colors.white70))),
                    TextField(controller: _tcVergiController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "T.C. Kimlik No", labelStyle: TextStyle(color: Colors.white70))),
                  ] else ...[
                    TextField(controller: _ticariUnvanController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Ticari Ünvan", labelStyle: TextStyle(color: Colors.white70))),
                    TextField(controller: _tcVergiController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Vergi No", labelStyle: TextStyle(color: Colors.white70))),
                    TextField(controller: _mernisController, enabled: !_mernisYok, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Mernis No", labelStyle: TextStyle(color: Colors.white70))),
                    CheckboxListTile(value: _mernisYok, title: const Text("Mernis No Yok", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _mernisYok = v!)),
                  ],
                  const SizedBox(height: 25),
                  TextField(controller: _mailController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "E-Mail", labelStyle: TextStyle(color: Colors.white70))),
                  TextField(controller: _telefonController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Telefon No", labelStyle: TextStyle(color: Colors.white70))),
                  TextField(controller: _adresController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Adres", labelStyle: TextStyle(color: Colors.white70))),
                  const SizedBox(height: 30),
                  DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: "Şehir", labelStyle: TextStyle(color: Colors.white70)), dropdownColor: const Color(0xFF1A1A1A), style: const TextStyle(color: Colors.white), value: _selectedSehirId, items: _sehirler.map((s) => DropdownMenuItem(value: s['sehir_id'].toString(), child: Text(s['sehir_adi'], style: const TextStyle(color: Colors.white)))).toList(), onChanged: _onSehirChanged),
                  DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: "İlçe", labelStyle: TextStyle(color: Colors.white70)), dropdownColor: const Color(0xFF1A1A1A), style: const TextStyle(color: Colors.white), value: _selectedIlceId, items: _filtrelenmisIlceler.map((i) => DropdownMenuItem(value: i['ilce_id'].toString(), child: Text(i['ilce_adi'], style: const TextStyle(color: Colors.white)))).toList(), onChanged: (v) => setState(() => _selectedIlceId = v)),
                  const SizedBox(height: 30),
                  CheckboxListTile(value: _sozlesmeKabul, title: const Text("Kullanıcı Sözleşmesini okudum ve kabul ediyorum.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _sozlesmeKabul = v!)),
                  CheckboxListTile(value: _kvkkKabul, title: const Text("KVKK Aydınlatma Metnini okudum.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _kvkkKabul = v!)),
                  CheckboxListTile(value: _acikRizaKabul, title: const Text("Kişisel verilerimin işlenmesine ve paylaşılmasına açık rıza veriyorum.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _acikRizaKabul = v!)),
                  CheckboxListTile(value: _yasalYukumlulukKabul, title: const Text("Hizmet sağlayıcı olarak tüm yasal yükümlülüklerin (vergi, SGK, sigorta vb.) tarafıma ait olduğunu kabul ederim.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _yasalYukumlulukKabul = v!)),
                  const SizedBox(height: 50),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}