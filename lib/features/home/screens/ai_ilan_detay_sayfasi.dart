// lib/features/home/screens/ai_ilan_detay_sayfasi.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/managers/price_calculation_manager.dart';
import 'package:ustam_gelsin/core/models/yerel_form_alan_model.dart';
import 'package:ustam_gelsin/core/constants/is_sorulari_data.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_auth_page.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_auth_page.dart';

class AiIlanDetaySayfasi extends StatefulWidget {
  final IlanModel ilan;
  const AiIlanDetaySayfasi({super.key, required this.ilan});
  @override
  State<AiIlanDetaySayfasi> createState() => _MusteriIlanDetaySayfasiState();
}

class _MusteriIlanDetaySayfasiState extends State<AiIlanDetaySayfasi> {
  final PriceCalculationManager _priceManager = PriceCalculationManager();
  final Map<String, dynamic> _secilenDetaylar = {};
  Timer? _debounceTimer;
  String _guncelFiyat = "LÜTFEN TÜM ALANLARI DOLDURUNUZ";
  bool _isCalculating = false;

  String? _secilenIl;
  String? _secilenIlce;
  String? _secilenIlId;
  List<dynamic> _sehirListesi = [];
  List<Map<String, String>> _filtrelenmisIlceler = [];
  bool _konumYukleniyor = true;

  @override
  void initState() {
    super.initState();
    _konumVerileriniHazirla();
  }

  // --- YENİ DOĞRULAMA MANTIĞI ---
  bool _tumAlanlarDoluMu() {
    if (_secilenIl == null || _secilenIlce == null) return false;

    final List<Map<String, dynamic>> hamSorular = IsSorulariData.getSorularByKategori(widget.ilan.kategori);
    for (var x in hamSorular) {
      // Sadece o an görünür olması gereken alanları kontrol et
      if (_alanGorunurMu(x)) {
        String id = x['id'].toString();
        if (_secilenDetaylar[id] == null || _secilenDetaylar[id].toString().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> _fiyatHesapla() async {
    // Sadece tüm alanlar doluysa hesapla
    if (!_tumAlanlarDoluMu()) {
      setState(() => _guncelFiyat = "LÜTFEN TÜM ALANLARI DOLDURUNUZ");
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      setState(() => _isCalculating = true);
      final String sonuc = await _priceManager.orkestraFiyatHesapla(
          userId: widget.ilan.userId, baslik: widget.ilan.baslik, kategori: widget.ilan.kategori,
          kategoriId: widget.ilan.kategoriId, detaylar: _secilenDetaylar);
      if (mounted) setState(() { _guncelFiyat = sonuc; _isCalculating = false; });
    });
  }
  // ------------------------------

  Future<void> _konumVerileriniHazirla() async {
    try {
      final sehirler = await LocationService.loadSehirler();
      setState(() => _sehirListesi = sehirler);
      await _otomatikKonumAl();
    } catch (e) { debugPrint("Hata: $e"); } finally { if (mounted) setState(() => _konumYukleniyor = false); }
  }

  Future<void> _otomatikKonumAl() async {
    final sonuc = await LocationService.otomatikKonumTespitEt();
    if (sonuc != null && mounted) {
      setState(() {
        _secilenIl = sonuc['sehir_adi']; _secilenIlId = sonuc['sehir_id'];
        _secilenIlce = sonuc['ilce_adi'];
        if (_secilenIl != null) _ilceFiltrele(_secilenIl!);
      });
    }
  }

  Future<void> _ilceFiltrele(String sehirAdi) async {
    if (_secilenIlId == null) return;
    final hamIlceler = await LocationService.loadIlceler(_secilenIlId!);
    if (mounted) {
      setState(() => _filtrelenmisIlceler = hamIlceler.map((e) => {'ad': e['ilce_adi'].toString(), 'id': e['ilce_id'].toString()}).toList());
    }
  }

  String _metniYalinHaleGetir(dynamic input) => input?.toString().toLowerCase().trim() ?? "";

  bool _alanGorunurMu(Map<String, dynamic> alanHamVerisi) {
    final dynamic dependsOnId = alanHamVerisi['dependsOnId'];
    if (dependsOnId == null) return true;
    final ustAlanDegeri = _secilenDetaylar[dependsOnId.toString()];
    if (ustAlanDegeri == null) return false;
    final List<dynamic> dependsOnValueList = alanHamVerisi['dependsOnValue'] is List ? alanHamVerisi['dependsOnValue'] : [alanHamVerisi['dependsOnValue']];
    return dependsOnValueList.map((v) => _metniYalinHaleGetir(v)).contains(_metniYalinHaleGetir(ustAlanDegeri));
  }

  void _altCevaplariTemizle(String ustAlanId, List<Map<String, dynamic>> hamSorular) {
    for (var x in hamSorular) {
      if (x['dependsOnId']?.toString() == ustAlanId) {
        if (!_alanGorunurMu(x)) {
          _secilenDetaylar.remove(x['id'].toString());
          _altCevaplariTemizle(x['id'].toString(), hamSorular);
        }
      }
    }
  }

  OutlineInputBorder _kirmiziKenarlik() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.red, width: 2)
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.ilan.baslik.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black), elevation: 0),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildActionButtons(),
        ),
      ),
      body: _konumYukleniyor ? const Center(child: CircularProgressIndicator(color: Colors.red)) : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          _buildKonumSeciciCard(),
          _buildTeknikSoruFormu(),
          _buildFiyatCard(),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _buildGlassCard(String title, List<Widget> children) => Container(
    width: double.infinity, padding: const EdgeInsets.all(20), margin: const EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.red, width: 2)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 10), ...children
    ]),
  );

  Widget _buildDropdown(String? value, String hint, List<String> items, Function(String?) onChanged) => DropdownButtonFormField<String>(
    value: items.contains(value) ? value : null,
    isExpanded: true,
    hint: Text(hint, style: const TextStyle(color: Colors.black)),
    style: const TextStyle(color: Colors.black),
    dropdownColor: Colors.white,
    iconEnabledColor: Colors.black,
    decoration: InputDecoration(
      filled: true, fillColor: Colors.white,
      enabledBorder: _kirmiziKenarlik(),
      focusedBorder: _kirmiziKenarlik(),
      border: _kirmiziKenarlik(),
    ),
    items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: Colors.black)))).toList(),
    onChanged: onChanged,
  );

  Widget _buildKonumSeciciCard() => _buildGlassCard("HİZMET YERİ", [
    _buildDropdown(_secilenIl, "İl Seçiniz", _sehirListesi.map((s) => s['sehir_adi'].toString()).toList(), (val) {
      setState(() { _secilenIl = val; _secilenIlce = null; });
      _ilceFiltrele(val!);
      _fiyatHesapla();
    }),
    const SizedBox(height: 12),
    _buildDropdown(_secilenIlce, "İlçe Seçiniz", _filtrelenmisIlceler.map((i) => i['ad']!).toList(), (val) {
      setState(() => _secilenIlce = val);
      _fiyatHesapla();
    }),
  ]);

  Widget _buildTeknikSoruFormu() {
    final List<Map<String, dynamic>> hamSorular = IsSorulariData.getSorularByKategori(widget.ilan.kategori);
    List<Widget> soruWidgetlari = hamSorular.map((x) {
      if (!_alanGorunurMu(x)) return const SizedBox.shrink();
      final alan = YerelFormAlanModel.fromMap(x);
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alan.label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: alan.options.contains(_secilenDetaylar[alan.id]) ? _secilenDetaylar[alan.id] : null,
              isExpanded: true,
              style: const TextStyle(color: Colors.black),
              dropdownColor: Colors.white,
              iconEnabledColor: Colors.black,
              decoration: InputDecoration(
                filled: true, fillColor: Colors.white,
                enabledBorder: _kirmiziKenarlik(),
                focusedBorder: _kirmiziKenarlik(),
                border: _kirmiziKenarlik(),
              ),
              items: alan.options.map((s) => DropdownMenuItem(
                value: s,
                child: Text(s, style: const TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis),
              )).toList(),
              onChanged: (val) {
                setState(() {
                  _secilenDetaylar[alan.id] = val;
                  _altCevaplariTemizle(alan.id, hamSorular);
                });
                _fiyatHesapla();
              },
            ),
          ],
        ),
      );
    }).toList();
    return _buildGlassCard("İLAN DETAYLARI", soruWidgetlari);
  }

  Widget _buildFiyatCard() => _buildGlassCard("FİYAT BİLGİSİ", [
    Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(15)),
      child: Text(_guncelFiyat, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    )
  ]);

  Widget _buildActionButtons() => ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("LÜTFEN SEÇİM YAPINIZ", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
            title: const Text("Müşteri olarak giriş yapınız / Üye olunuz", style: TextStyle(color: Colors.black)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerAuthPage(role: "customer")))
        ),
        const Divider(color: Colors.red),
        ListTile(
            title: const Text("Usta olarak giriş yapınız / Üye olunuz", style: TextStyle(color: Colors.black)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaAuthPage(role: "usta")))
        ),
      ]),
    )),
    child: const Text("DEVAM ET", style: TextStyle(fontWeight: FontWeight.bold)),
  );
}