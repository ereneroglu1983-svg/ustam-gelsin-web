// lib/features/usta/screens/usta_register.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, FilteringTextInputFormatter, LengthLimitingTextInputFormatter;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:ustam_gelsin/core/theme/app_theme.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';

class UstaRegisterPage extends StatefulWidget {
  final String role;
  const UstaRegisterPage({super.key, required this.role});

  @override
  State<UstaRegisterPage> createState() => _UstaRegisterPageState();
}

class _UstaRegisterPageState extends State<UstaRegisterPage> {
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

  String? _tcVergiTipi; // null, sahis veya sirket
  String _faturaAdresTipi = 'ayni';
  bool _mernisYok = false;
  bool _ustalikBelgesiVarMi = false;

  bool _sozlesmeKabul = false;
  bool _kvkkKabul = false;
  bool _acikRizaKabul = false;
  bool _yasalYukumlulukKabul = false;

  List<String> tumMeslekler = [];
  List<String> secilenMeslekler = [];
  List<dynamic> _sehirler = [];
  List<dynamic> _filtrelenmisIlceler = [];
  List<dynamic> _tumIlceler = [];
  String? _selectedSehirId;
  String? _selectedIlceId;
  bool _isLoading = true;
  Map<String, dynamic>? _gpsVerisi;

  @override
  void initState() {
    super.initState();
    _loadJsonData().then((_) => _otomatikKonumAlgila());
  }

  bool _isFormValid() {
    if (_tcVergiTipi == null) return false;
    if (_mailController.text.isEmpty || _telefonController.text.isEmpty || _sifre1Controller.text.isEmpty) return false;
    if (_selectedSehirId == null || _selectedIlceId == null || secilenMeslekler.isEmpty) return false;
    return _sozlesmeKabul && _kvkkKabul && _acikRizaKabul && _yasalYukumlulukKabul;
  }

  Future<void> _sozlesmeyiGoster(BuildContext context) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('usta_sozlesme')
          .get();

      String metin = "";
      if (doc.exists && (doc.data() as Map<String, dynamic>).containsKey('metin')) {
        metin = doc['metin'];
      } else {
        final String response = await rootBundle.loadString('assets/data/usta_sozlesme.json');
        final data = await json.decode(response);
        metin = data['metin'];
      }

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Usta Sözleşmesi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      final meslekString = await rootBundle.loadString('assets/data/meslekler.json');
      if (mounted) {
        setState(() {
          _sehirler = jsonDecode(sehirString);
          _tumIlceler = jsonDecode(ilceString);
          tumMeslekler = List<String>.from(jsonDecode(meslekString));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _otomatikKonumAlgila() async {
    try {
      final sonuc = await LocationService.otomatikKonumTespitEt();
      if (sonuc != null && mounted) {
        setState(() {
          _gpsVerisi = sonuc;
          _selectedSehirId = sonuc['sehir_id'].toString();
          _onSehirChanged(_selectedSehirId);
          _selectedIlceId = sonuc['ilce_id']?.toString();
        });
      }
    } catch (e) { debugPrint("Konum hatası: $e"); }
  }

  void _onSehirChanged(String? val) {
    setState(() {
      _selectedSehirId = val;
      _selectedIlceId = null;
      _filtrelenmisIlceler = _tumIlceler.where((item) => item['sehir_id'].toString() == val).toList();
    });
  }

  Future<void> _kayitOl() async {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm alanları eksiksiz doldurun ve onayları işaretleyin!")));
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

      final Map<String, dynamic> kayitVerisi = {
        'name': _tcVergiTipi == 'sirket'
            ? _ticariUnvanController.text.trim()
            : "${_adController.text.trim()} ${_soyadController.text.trim()}",
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
        'role': widget.role,
        'createdAt': FieldValue.serverTimestamp(),
        'uid': credential.user!.uid,
        'ipKaydi': ipAddress,
        'riza_tarihleri': {
          'sozlesme': Timestamp.now(),
          'kvkk': Timestamp.now(),
          'acikRiza': Timestamp.now(),
          'yasalYukumluluk': Timestamp.now(),
        },
      };

      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(kayitVerisi);
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd])),
        child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white)) : SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text("Usta Kaydı", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text("Lütfen vergi türünüzü seçiniz:", style: TextStyle(color: Colors.white)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Expanded(child: RadioListTile(title: const Text("Şahıs", style: TextStyle(color: Colors.white)), value: 'sahis', groupValue: _tcVergiTipi, onChanged: (v) => setState(() => _tcVergiTipi = v!))),
                    Expanded(child: RadioListTile(title: const Text("Şirket", style: TextStyle(color: Colors.white)), value: 'sirket', groupValue: _tcVergiTipi, onChanged: (v) => setState(() => _tcVergiTipi = v!))),
                  ]),
                ),
                if (_tcVergiTipi != null) ...[
                  if (_tcVergiTipi == 'sahis') ...[
                    TextField(controller: _adController, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Ad")),
                    const SizedBox(height: 10),
                    TextField(controller: _soyadController, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Soyad")),
                    const SizedBox(height: 10),
                    TextField(controller: _tcVergiController, keyboardType: TextInputType.number, decoration: AppDecorations.inputDecoration.copyWith(labelText: "T.C. Kimlik No")),
                  ] else ...[
                    TextField(controller: _ticariUnvanController, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Ticari Ünvan")),
                    const SizedBox(height: 10),
                    TextField(controller: _tcVergiController, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Vergi No")),
                    const SizedBox(height: 10),
                    TextField(controller: _mernisController, enabled: !_mernisYok, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Mernis No")),
                    CheckboxListTile(value: _mernisYok, title: const Text("Mernis No Yok", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _mernisYok = v!)),
                  ],
                  const SizedBox(height: 10),
                  TextField(controller: _mailController, decoration: AppDecorations.inputDecoration.copyWith(labelText: "E-Mail")),
                  const Padding(padding: EdgeInsets.only(top: 2, left: 10), child: Align(alignment: Alignment.centerLeft, child: Text("Geçerli bir e-mail adresi giriniz.", style: TextStyle(color: Colors.white70, fontSize: 10)))),
                  const SizedBox(height: 10),
                  TextField(controller: _telefonController, keyboardType: TextInputType.phone, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Tel No")),
                  const SizedBox(height: 10),
                  TextField(controller: _adresController, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Adres"), maxLines: 2),
                  const SizedBox(height: 10),
                  RadioListTile(title: const Text("Fatura Adresi Aynı", style: TextStyle(color: Colors.white)), value: 'ayni', groupValue: _faturaAdresTipi, onChanged: (v) => setState(() => _faturaAdresTipi = v!)),
                  RadioListTile(title: const Text("Fatura Adresi Farklı", style: TextStyle(color: Colors.white)), value: 'farkli', groupValue: _faturaAdresTipi, onChanged: (v) => setState(() => _faturaAdresTipi = v!)),
                  if (_faturaAdresTipi == 'farkli') TextField(controller: _faturaAdresController, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Farklı Fatura Adresi"), maxLines: 2),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: DropdownButtonFormField<String>(isExpanded: true, value: _selectedSehirId, dropdownColor: AppColors.primaryGradientMid, style: const TextStyle(color: Colors.white), decoration: AppDecorations.inputDecoration.copyWith(labelText: "Şehir"), items: _sehirler.map((s) => DropdownMenuItem(value: s['sehir_id'].toString(), child: Text(s['sehir_adi']))).toList(), onChanged: _onSehirChanged)),
                    const SizedBox(width: 10),
                    Expanded(child: DropdownButtonFormField<String>(isExpanded: true, value: _selectedIlceId, dropdownColor: AppColors.primaryGradientMid, style: const TextStyle(color: Colors.white), decoration: AppDecorations.inputDecoration.copyWith(labelText: "İlçe"), items: _filtrelenmisIlceler.map((i) => DropdownMenuItem(value: i['ilce_id'].toString(), child: Text(i['ilce_adi']))).toList(), onChanged: (val) => setState(() => _selectedIlceId = val))),
                  ]),
                  const SizedBox(height: 15),
                  ExpansionTile(title: const Text("Uzmanlık Alanı", style: TextStyle(color: Colors.white)), children: [
                    Container(height: 150, child: ListView.builder(itemCount: tumMeslekler.length, itemBuilder: (context, index) => CheckboxListTile(dense: true, title: Text(tumMeslekler[index], style: const TextStyle(color: Colors.white, fontSize: 12)), value: secilenMeslekler.contains(tumMeslekler[index]), onChanged: (val) => setState(() => val! ? secilenMeslekler.add(tumMeslekler[index]) : secilenMeslekler.remove(tumMeslekler[index])))))
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("Ustalık Belgesi Durumu:", style: TextStyle(color: Colors.white)),
                      Row(children: [
                        Expanded(child: RadioListTile(title: const Text("Var", style: TextStyle(color: Colors.white)), value: true, groupValue: _ustalikBelgesiVarMi, onChanged: (v) => setState(() => _ustalikBelgesiVarMi = v!))),
                        Expanded(child: RadioListTile(title: const Text("Yok", style: TextStyle(color: Colors.white)), value: false, groupValue: _ustalikBelgesiVarMi, onChanged: (v) => setState(() => _ustalikBelgesiVarMi = v!))),
                      ]),
                    ]),
                  ),
                  TextField(controller: _sifre1Controller, obscureText: true, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Şifre")),
                  const SizedBox(height: 10),
                  TextField(controller: _sifre2Controller, obscureText: true, decoration: AppDecorations.inputDecoration.copyWith(labelText: "Şifre Tekrar")),
                  const SizedBox(height: 15),
                  CheckboxListTile(value: _sozlesmeKabul, title: const Text("Kullanıcı Sözleşmesini okudum ve kabul ediyorum.", style: TextStyle(color: Colors.white, fontSize: 12)), onChanged: (v) => setState(() => _sozlesmeKabul = v!)),
                  CheckboxListTile(value: _kvkkKabul, title: const Text("KVKK Aydınlatma Metnini okudum.", style: TextStyle(color: Colors.white, fontSize: 12)), onChanged: (v) => setState(() => _kvkkKabul = v!)),
                  CheckboxListTile(value: _acikRizaKabul, title: const Text("Kişisel verilerimin işlenmesine ve paylaşılmasına açık rıza veriyorum.", style: TextStyle(color: Colors.white, fontSize: 12)), onChanged: (v) => setState(() => _acikRizaKabul = v!)),
                  CheckboxListTile(value: _yasalYukumlulukKabul, title: const Text("Hizmet sağlayıcı olarak tüm yasal yükümlülüklerin (vergi, SGK, sigorta vb.) tarafıma ait olduğunu kabul ederim.", style: TextStyle(color: Colors.white, fontSize: 12)), onChanged: (v) => setState(() => _yasalYukumlulukKabul = v!)),
                  Center(child: TextButton(onPressed: () => _sozlesmeyiGoster(context), child: const Text("Sözleşme Metnini İncele", style: TextStyle(color: Colors.orange)))),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: _isFormValid() ? _kayitOl : () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm alanları doldurun!"))), style: ElevatedButton.styleFrom(backgroundColor: _isFormValid() ? Colors.orange : Colors.grey, minimumSize: const Size(double.infinity, 55)), child: const Text("KAYIT OL", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}