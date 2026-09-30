// lib/web_dosyalari/usta_kayit_ekrani.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, FilteringTextInputFormatter, LengthLimitingTextInputFormatter;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  // SADECE ONAY VERILEN EKLEMELER
  String? _tcHata;
  String? _mailHata;
  String? _sifreHata;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _ticariUnvanController.dispose();
    _tcVergiController.dispose();
    _mernisController.dispose();
    _mailController.dispose();
    _telefonController.dispose();
    _adresController.dispose();
    _faturaAdresController.dispose();
    _sifre1Controller.dispose();
    _sifre2Controller.dispose();
    super.dispose();
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

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordValid(String pass) {
    if (pass.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(pass)) return false;
    if (!RegExp(r'[0-9]').hasMatch(pass)) return false;
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(pass)) return false;
    return true;
  }

  void _tcKontrol(String val) {
    if (_tcVergiTipi == 'sahis') {
      if (val.isNotEmpty && val.length!= 11) {
        setState(() => _tcHata = 'TC NUMARANIZI LÜTFEN KONTROL EDİNİZ');
      } else {
        setState(() => _tcHata = null);
      }
    }
  }

  void _mailKontrol(String val) {
    if (val.isNotEmpty &&!_isEmailValid(val)) {
      setState(() => _mailHata = 'LÜTFEN MAİL ADRESİNİZİ KONTROL EDİNİZ');
    } else {
      setState(() => _mailHata = null);
    }
  }

  void _sifreKontrol(String val) {
    if (val.isNotEmpty &&!_isPasswordValid(val)) {
      setState(() => _sifreHata = 'Şifre 8 karakter, 1 büyük harf, 1 rakam ve 1 noktalama içermeli');
    } else {
      setState(() => _sifreHata = null);
    }
  }

  // DÜZELTME 1: iyzico için tüm zorunlu alanlar kontrol ediliyor
  bool _isFormValid() {
    if (_tcVergiTipi == null) return false;
    if (_mailController.text.isEmpty || _telefonController.text.length < 10 || _sifre1Controller.text.isEmpty) return false;
    if (_adresController.text.isEmpty) return false; // iyzico zorunlu
    if (_selectedSehirId == null || _selectedIlceId == null || secilenMeslekler.isEmpty) return false;

    if (_tcVergiTipi == 'sahis') {
      if (_adController.text.isEmpty || _soyadController.text.isEmpty || _tcVergiController.text.length!= 11) return false;
    } else {
      if (_ticariUnvanController.text.isEmpty || _tcVergiController.text.length!= 10) return false;
    }

    if (!_isEmailValid(_mailController.text.trim())) return false;
    if (!_isPasswordValid(_sifre1Controller.text)) return false;

    return _sozlesmeKabul && _kvkkKabul && _acikRizaKabul && _yasalYukumlulukKabul;
  }

  Future<void> _sozlesmeyiGoster(BuildContext context) async {
    try {
      String metin = "Sözleşme metni yükleniyor...";

      if (kIsWeb) {
        final doc = await FirebaseFirestore.instance.collection('config').doc('usta_sozlesme').get();
        metin = doc.exists? (doc['metin']?? metin) : "Sözleşme metni şu anda yüklenemedi.";
      } else {
        final String response = await rootBundle.loadString('assets/data/usta_sozlesme.json');
        final data = json.decode(response);
        metin = data['metin']?? metin;
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Usta Sözleşmesi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(child: Text(metin)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Kapat"))
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sözleşme yüklenirken hata oluştu.")));
      }
    }
  }

  // DÜZELTME 2: Telefon +90 formatla
  String _formatPhone(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }
    if (!cleaned.startsWith('90')) {
      cleaned = '90$cleaned';
    }
    return '+$cleaned';
  }

  Future<void> _kayitOl() async {
    if (_tcVergiTipi == 'sahis' && _tcVergiController.text.length!= 11) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("TC NUMARANIZI LÜTFEN KONTROL EDİNİZ")));
      return;
    }
    if (!_isEmailValid(_mailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("LÜTFEN MAİL ADRESİNİZİ KONTROL EDİNİZ")));
      return;
    }
    if (!_isPasswordValid(_sifre1Controller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şifreniz en az 8 karakter olmalı, bir büyük harf, bir rakam ve bir noktalama işareti içermelidir.")));
      return;
    }
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm alanları ve onayları doldurun!")));
      return;
    }
    if (_sifre1Controller.text!= _sifre2Controller.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şifreler uyuşmuyor!")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _mailController.text.trim(),
        password: _sifre1Controller.text.trim(),
      );

      final bool isSahis = _tcVergiTipi == 'sahis';
      final secilenSehir = _sehirler.firstWhere((s) => s['sehir_id'].toString() == _selectedSehirId);
      final secilenIlce = _filtrelenmisIlceler.firstWhere((i) => i['ilce_id'].toString() == _selectedIlceId);

      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': _mailController.text.trim(),
        'role': 'usta',
        'createdAt': FieldValue.serverTimestamp(),
        'ipKaydi': 'Web Kayıt',
        'name': isSahis? "${_adController.text.trim()} ${_soyadController.text.trim()}" : _ticariUnvanController.text.trim(),
        'firstName': isSahis? _adController.text.trim() : '',
        'lastName': isSahis? _soyadController.text.trim() : '',
        'ticariUnvan': _ticariUnvanController.text.trim(),
        'tcVergiTipi': _tcVergiTipi,
        'tcVergiNo': _tcVergiController.text.trim(),
        'mernisNo': _mernisYok? "MERNIS_YOK" : _mernisController.text.trim(),
        'phone': _formatPhone(_telefonController.text.trim()),
        'adres': _adresController.text.trim(),
        'faturaAdresi': _faturaAdresTipi == 'ayni'? _adresController.text.trim() : _faturaAdresController.text.trim(),
        'sehir_id': _selectedSehirId,
        'sehir_adi': secilenSehir['sehir_adi'],
        'ilce_id': _selectedIlceId,
        'ilce_adi': secilenIlce['ilce_adi'],
        'uzmanliklar': secilenMeslekler,
        'ustalikBelgesiVarMi': _ustalikBelgesiVarMi,
        'riza_tarihleri': {
          'sozlesme': _sozlesmeKabul? FieldValue.serverTimestamp() : null,
          'kvkk': _kvkkKabul? FieldValue.serverTimestamp() : null,
          'acikRiza': _acikRizaKabul? FieldValue.serverTimestamp() : null,
          'yasalYukumluluk': _yasalYukumlulukKabul? FieldValue.serverTimestamp() : null,
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
          : LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final isMobile = w < 600;
          final isTablet = w >= 600 && w < 1100;
          final isDesktop = w >= 1100;
          final double containerWidth = isDesktop? 900 : isTablet? 700 : double.infinity;
          final double pngHeight = isMobile? 180 : isTablet? 260 : 320;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: containerWidth,
                margin: EdgeInsets.symmetric(vertical: isMobile? 20 : 40, horizontal: isMobile? 12 : 20),
                child: Column(
                  children: [
                    Container(
                      height: pngHeight,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/usta_register.png'),
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(isMobile? 20 : isTablet? 36 : 52),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Vergi Tipinizi Seçin *", style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: RadioListTile(title: const Text("Şahıs", style: TextStyle(color: Colors.white)), value: 'sahis', groupValue: _tcVergiTipi, onChanged: (v) => setState(() => _tcVergiTipi = v))),
                              Expanded(child: RadioListTile(title: const Text("Şirket", style: TextStyle(color: Colors.white)), value: 'sirket', groupValue: _tcVergiTipi, onChanged: (v) => setState(() => _tcVergiTipi = v))),
                            ],
                          ),
                          if (_tcVergiTipi!= null)...[
                            const SizedBox(height: 40),
                            if (_tcVergiTipi == 'sahis')...[
                              TextField(controller: _adController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Ad *", labelStyle: TextStyle(color: Colors.white70))),
                              TextField(controller: _soyadController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Soyad *", labelStyle: TextStyle(color: Colors.white70))),
                              TextField(
                                controller: _tcVergiController,
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                                onChanged: _tcKontrol,
                                decoration: InputDecoration(
                                  labelText: "T.C. Kimlik No *",
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  errorText: _tcHata,
                                  helperText: "11 haneli olmalı",
                                  helperStyle: const TextStyle(color: Colors.white38),
                                ),
                              ),
                            ] else...[
                              TextField(controller: _ticariUnvanController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Ticari Ünvan *", labelStyle: TextStyle(color: Colors.white70))),
                              TextField(
                                  controller: _tcVergiController,
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                                  decoration: const InputDecoration(labelText: "Vergi No *", labelStyle: TextStyle(color: Colors.white70))),
                              TextField(controller: _mernisController, enabled:!_mernisYok, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Mernis No", labelStyle: TextStyle(color: Colors.white70))),
                              CheckboxListTile(value: _mernisYok, title: const Text("Mernis No Yok", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _mernisYok = v!)),
                            ],
                            const SizedBox(height: 25),
                            TextField(
                              controller: _mailController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: _mailKontrol,
                              decoration: InputDecoration(
                                labelText: "E-Mail *",
                                labelStyle: const TextStyle(color: Colors.white70),
                                errorText: _mailHata,
                              ),
                            ),
                            TextField(
                                controller: _telefonController,
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                                decoration: const InputDecoration(labelText: "Telefon No * (05xxxxxxxxx)", labelStyle: TextStyle(color: Colors.white70))),
                            TextField(controller: _adresController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Adres *", labelStyle: TextStyle(color: Colors.white70))),
                            const SizedBox(height: 30),
                            DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: "Şehir *", labelStyle: TextStyle(color: Colors.white70)), dropdownColor: const Color(0xFF1A1A1A), style: const TextStyle(color: Colors.white), value: _selectedSehirId, items: _sehirler.map((s) => DropdownMenuItem(value: s['sehir_id'].toString(), child: Text(s['sehir_adi'], style: const TextStyle(color: Colors.white)))).toList(), onChanged: _onSehirChanged),
                            DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: "İlçe *", labelStyle: TextStyle(color: Colors.white70)), dropdownColor: const Color(0xFF1A1A1A), style: const TextStyle(color: Colors.white), value: _selectedIlceId, items: _filtrelenmisIlceler.map((i) => DropdownMenuItem(value: i['ilce_id'].toString(), child: Text(i['ilce_adi'], style: const TextStyle(color: Colors.white)))).toList(), onChanged: (v) => setState(() => _selectedIlceId = v)),
                            const SizedBox(height: 30),
                            ExpansionTile(title: const Text("Uzmanlık Alanı *", style: TextStyle(color: Colors.white)), children: [
                              SizedBox(height: 150, child: ListView.builder(itemCount: tumMeslekler.length, itemBuilder: (context, index) => CheckboxListTile(dense: true, title: Text(tumMeslekler[index], style: const TextStyle(color: Colors.white, fontSize: 12)), value: secilenMeslekler.contains(tumMeslekler[index]), onChanged: (val) => setState(() => val!? secilenMeslekler.add(tumMeslekler[index]) : secilenMeslekler.remove(tumMeslekler[index])))))
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
                            TextField(
                              controller: _sifre1Controller,
                              obscureText: true,
                              onChanged: _sifreKontrol,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Şifre *",
                                labelStyle: const TextStyle(color: Colors.white70),
                                helperText: "Şifreniz en az 8 karakter olmalı, bir büyük harf, bir rakam ve bir noktalama işareti içermelidir.",
                                helperMaxLines: 3,
                                helperStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                                errorText: _sifreHata,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(controller: _sifre2Controller, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Şifre Tekrar *", labelStyle: TextStyle(color: Colors.white70))),
                            const SizedBox(height: 15),
                            CheckboxListTile(value: _sozlesmeKabul, title: const Text("Kullanıcı Sözleşmesini okudum ve kabul ediyorum.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _sozlesmeKabul = v!)),
                            CheckboxListTile(value: _kvkkKabul, title: const Text("KVKK Aydınlatma Metnini okudum.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _kvkkKabul = v!)),
                            CheckboxListTile(value: _acikRizaKabul, title: const Text("Kişisel verilerimin işlenmesine ve paylaşılmasına açık rıza veriyorum.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _acikRizaKabul = v!)),
                            CheckboxListTile(value: _yasalYukumlulukKabul, title: const Text("Hizmet sağlayıcı olarak tüm yasal yükümlülüklerin (vergi, SGK, sigorta vb.) tarafıma ait olduğunu kabul ederim.", style: TextStyle(color: Colors.white)), onChanged: (v) => setState(() => _yasalYukumlulukKabul = v!)),
                            const SizedBox(height: 30),
                            Center(
                              child: ElevatedButton(
                                onPressed: () => _sozlesmeyiGoster(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC143C),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text("SÖZLEŞME METNİNİ İNCELE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}