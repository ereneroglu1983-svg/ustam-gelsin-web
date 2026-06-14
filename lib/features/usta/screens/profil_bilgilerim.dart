// lib/features/usta/screens/profil_bilgilerim.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/core/constants/meslekler_data.dart';

class ProfilBilgilerim extends StatefulWidget {
  const ProfilBilgilerim({super.key});

  @override
  State<ProfilBilgilerim> createState() => _ProfilBilgilerimState();
}

class _ProfilBilgilerimState extends State<ProfilBilgilerim> {
  final AuthService _authService = AuthService();

  String _ad = "";
  String _soyad = "";

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

    if (mounted) {
      setState(() {
        _sehirler = jsonDecode(sehirString);
        _tumIlceler = jsonDecode(ilceString);

        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;

          // HEM ESKİ (name) HEM YENİ (firstName/lastName) YAPIYI YAKALA
          if (data.containsKey('firstName') || data.containsKey('lastName')) {
            _ad = data['firstName']?.toString() ?? "";
            _soyad = data['lastName']?.toString() ?? "";
          } else if (data.containsKey('name')) {
            String fullName = data['name'].toString();
            List<String> parts = fullName.split(' ');
            _ad = parts.isNotEmpty ? parts[0] : "";
            _soyad = parts.length > 1 ? parts.sublist(1).join(' ') : "";
          }

          secilenMeslekler = List<String>.from(data['uzmanliklar'] ?? []);
          _selectedSehirId = data['sehir_id']?.toString();
          if (_selectedSehirId != null) _onSehirChanged(_selectedSehirId);
          _selectedIlceId = data['ilce_id']?.toString();
        }
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
      'uzmanliklar': secilenMeslekler,
      'sehir_id': _selectedSehirId,
      'ilce_id': _selectedIlceId,
    });
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
            // Salt okunur Ad Soyad
            Text("Ad: $_ad", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Soyad: $_soyad", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(height: 30),

            // Şehir İlçe Seçimi
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedSehirId,
                    items: _sehirler.map((s) => DropdownMenuItem(value: s['sehir_id'].toString(), child: Text(s['sehir_adi'], overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: _onSehirChanged,
                    decoration: const InputDecoration(labelText: "Şehir", border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedIlceId,
                    items: _filtrelenmisIlceler.map((i) => DropdownMenuItem(value: i['ilce_id'].toString(), child: Text(i['ilce_adi'], overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (val) => setState(() => _selectedIlceId = val),
                    decoration: const InputDecoration(labelText: "İlçe", border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mevcut Meslekler
            const Text("Mesleklerim", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: secilenMeslekler.map((m) => Chip(
                label: Text(m, style: const TextStyle(fontSize: 12)),
                onDeleted: () => setState(() => secilenMeslekler.remove(m)),
                backgroundColor: Colors.red.shade100,
              )).toList(),
            ),
            const SizedBox(height: 10),

            // Uzmanlık Alanı Ekle / Çıkar
            ExpansionTile(
              title: const Text("Uzmanlık Alanı Ekle / Çıkar"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    children: MesleklerData.tumMeslekler.map((meslek) => FilterChip(
                      label: Text(meslek),
                      selected: secilenMeslekler.contains(meslek),
                      onSelected: (val) => setState(() => val ? secilenMeslekler.add(meslek) : secilenMeslekler.remove(meslek)),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(onPressed: _guncelle, child: const Text("GÜNCELLE")),
          ),
        ),
      ),
    );
  }
}