import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/core/constants/meslekler_data.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_hesapsil.dart'; // Import eklendi

class ProfilBilgilerim extends StatefulWidget {
  const ProfilBilgilerim({super.key});

  @override
  State<ProfilBilgilerim> createState() => _ProfilBilgilerimState();
}

class _ProfilBilgilerimState extends State<ProfilBilgilerim> {
  final AuthService _authService = AuthService();
  bool _isEditing = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _faturaAdresController = TextEditingController();
  final TextEditingController _sirketUnvaniController = TextEditingController();
  final TextEditingController _vergiDairesiController = TextEditingController();
  final TextEditingController _vergiNoController = TextEditingController();

  String _ad = "";
  String _soyad = "";
  String _tc = "";
  String _vergiTuru = "Şahıs";
  bool _ustalikBelgesiVarMi = false;
  bool _faturaAdresiFarkli = false;

  List<String> secilenMeslekler = [];
  List<dynamic> _sehirler = [];
  List<dynamic> _tumIlceler = [];
  List<dynamic> _filtrelenmisIlceler = [];
  String? _selectedSehirId;
  String? _selectedIlceId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _hazirlikYap();
  }

  Future<void> _hazirlikYap() async {
    final sehirString = await rootBundle.loadString('assets/data/sehirler.json');
    final ilceString = await rootBundle.loadString('assets/data/ilceler.json');
    final user = _authService.currentUser;
    var doc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

    if (mounted && doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      setState(() {
        _sehirler = jsonDecode(sehirString);
        _tumIlceler = jsonDecode(ilceString);

        if (data.containsKey('firstName') || data.containsKey('lastName')) {
          _ad = data['firstName'] ?? "";
          _soyad = data['lastName'] ?? "";
        } else if (data.containsKey('name')) {
          List<String> parts = data['name'].toString().split(' ');
          _ad = parts.isNotEmpty ? parts[0] : "";
          _soyad = parts.length > 1 ? parts.sublist(1).join(' ') : "";
        }

        _tc = data['tcNo']?.toString() ?? "Belirtilmemiş";
        _emailController.text = data['email'] ?? "";
        _telController.text = data['phone'] ?? "";
        _adresController.text = data['adres'] ?? "";
        _vergiTuru = data['vergiTuru'] ?? "Şahıs";
        _sirketUnvaniController.text = data['sirketUnvani'] ?? "";
        _vergiDairesiController.text = data['vergiDairesi'] ?? "";
        _vergiNoController.text = data['vergiNo'] ?? "";
        _ustalikBelgesiVarMi = data['ustalikBelgesiVarMi'] ?? false;
        _faturaAdresiFarkli = data['faturaAdresiFarkli'] ?? false;
        _faturaAdresController.text = data['faturaAdresi'] ?? "";

        secilenMeslekler = List<String>.from(data['uzmanliklar'] ?? []);
        _selectedSehirId = data['sehir_id']?.toString();
        if (_selectedSehirId != null) _onSehirChanged(_selectedSehirId);
        _selectedIlceId = data['ilce_id']?.toString();

        _isLoading = false;
      });
    }
  }

  void _onSehirChanged(String? val) {
    setState(() {
      _selectedSehirId = val;
      _selectedIlceId = null;
      _filtrelenmisIlceler = _tumIlceler.where((item) => item['sehir_id'].toString() == val).toList();
    });
  }

  Future<void> _guncelle() async {
    await FirebaseFirestore.instance.collection('users').doc(_authService.currentUser!.uid).update({
      'email': _emailController.text,
      'phone': _telController.text,
      'adres': _adresController.text,
      'vergiTuru': _vergiTuru,
      'sirketUnvani': _sirketUnvaniController.text,
      'vergiDairesi': _vergiDairesiController.text,
      'vergiNo': _vergiNoController.text,
      'faturaAdresiFarkli': _faturaAdresiFarkli,
      'faturaAdresi': _faturaAdresController.text,
      'uzmanliklar': secilenMeslekler,
      'sehir_id': _selectedSehirId,
      'ilce_id': _selectedIlceId,
      'ustalikBelgesiVarMi': _ustalikBelgesiVarMi,
    });
    setState(() => _isEditing = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil güncellendi!")));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text("Profil Bilgilerim")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_ustalikBelgesiVarMi)
              Center(child: Image.asset('assets/images/usta_rozet.png', height: 80)),

            const SizedBox(height: 20),

            Text("Ad: $_ad", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Soyad: $_soyad", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text("TC Kimlik No: $_tc", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            if (_isEditing)
              SwitchListTile(
                title: Text("Ustalık Belgesi: ${_ustalikBelgesiVarMi ? 'Var' : 'Yok'}"),
                value: _ustalikBelgesiVarMi,
                onChanged: (val) => setState(() => _ustalikBelgesiVarMi = val),
              )
            else
              Text("Ustalık Belgesi: ${_ustalikBelgesiVarMi ? 'Var' : 'Yok'}", style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _vergiTuru,
              decoration: const InputDecoration(labelText: "Vergi Türü", border: OutlineInputBorder()),
              items: ["Şahıs", "Şirket"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: _isEditing ? (val) => setState(() => _vergiTuru = val!) : null,
            ),
            const SizedBox(height: 15),

            if (_vergiTuru == "Şirket") ...[
              TextFormField(controller: _sirketUnvaniController, enabled: _isEditing, decoration: const InputDecoration(labelText: "Şirket Adı", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextFormField(controller: _vergiDairesiController, enabled: _isEditing, decoration: const InputDecoration(labelText: "Vergi Dairesi", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextFormField(controller: _vergiNoController, enabled: _isEditing, decoration: const InputDecoration(labelText: "Vergi No", border: OutlineInputBorder())),
            ],

            const Divider(height: 30),
            TextFormField(controller: _emailController, enabled: _isEditing, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextFormField(controller: _telController, enabled: _isEditing, decoration: const InputDecoration(labelText: "Telefon", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextFormField(controller: _adresController, enabled: _isEditing, decoration: const InputDecoration(labelText: "Adres", border: OutlineInputBorder())),

            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedSehirId,
                    items: _sehirler.map((s) => DropdownMenuItem(value: s['sehir_id'].toString(), child: Text(s['sehir_adi']))).toList(),
                    onChanged: _isEditing ? _onSehirChanged : null,
                    decoration: const InputDecoration(labelText: "Şehir", border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedIlceId,
                    items: _filtrelenmisIlceler.map((i) => DropdownMenuItem(value: i['ilce_id'].toString(), child: Text(i['ilce_adi']))).toList(),
                    onChanged: _isEditing ? (val) => setState(() => _selectedIlceId = val) : null,
                    decoration: const InputDecoration(labelText: "İlçe", border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            SwitchListTile(
              title: const Text("Fatura Adresi Farklı"),
              value: _faturaAdresiFarkli,
              onChanged: _isEditing ? (val) => setState(() => _faturaAdresiFarkli = val) : null,
            ),
            if (_faturaAdresiFarkli)
              TextFormField(controller: _faturaAdresController, enabled: _isEditing, decoration: const InputDecoration(labelText: "Fatura Adresi", border: OutlineInputBorder())),

            const SizedBox(height: 20),
            const Text("Mesleklerim", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: secilenMeslekler.map((m) => Chip(
                label: Text(m),
                onDeleted: _isEditing ? () => setState(() => secilenMeslekler.remove(m)) : null,
              )).toList(),
            ),

            if (_isEditing)
              ExpansionTile(
                title: const Text("Uzmanlık Alanı Ekle / Çıkar"),
                children: [
                  Wrap(
                    spacing: 8,
                    children: MesleklerData.tumMeslekler.map((meslek) => FilterChip(
                      label: Text(meslek),
                      selected: secilenMeslekler.contains(meslek),
                      onSelected: (val) => setState(() => val ? secilenMeslekler.add(meslek) : secilenMeslekler.remove(meslek)),
                    )).toList(),
                  ),
                ],
              ),

            // HESAP SİLME BUTONU EKLENDİ
            const SizedBox(height: 30),
            const Center(child: UstaHesapSil()),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isEditing
              ? Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: () => setState(() => _isEditing = false), child: const Text("İPTAL")),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(onPressed: _guncelle, child: const Text("KAYDET")),
              ),
            ],
          )
              : ElevatedButton(
            onPressed: () => setState(() => _isEditing = true),
            child: const Text("BİLGİLERİMİ GÜNCELLE"),
          ),
        ),
      ),
    );
  }
}