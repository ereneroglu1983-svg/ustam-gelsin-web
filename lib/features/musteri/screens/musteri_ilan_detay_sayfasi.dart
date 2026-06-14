// lib/features/musteri/screens/musteri_ilan_detay_sayfasi.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/managers/price_calculation_manager.dart';
import 'package:ustam_gelsin/core/models/yerel_form_alan_model.dart';
import 'package:ustam_gelsin/core/constants/is_sorulari_data.dart';
import 'package:intl/intl.dart';
import 'package:ustam_gelsin/core/managers/ilan_yayinlama_motoru.dart';

class MusteriIlanDetaySayfasi extends StatefulWidget {
  final IlanModel ilan;

  const MusteriIlanDetaySayfasi({
    super.key,
    required this.ilan,
  });

  @override
  State<MusteriIlanDetaySayfasi> createState() => _MusteriIlanDetaySayfasiState();
}

class _MusteriIlanDetaySayfasiState extends State<MusteriIlanDetaySayfasi> {
  final PriceCalculationManager _priceManager = PriceCalculationManager();

  final Map<String, dynamic> _secilenDetaylar = {};
  final TextEditingController _notController = TextEditingController();
  final TextEditingController _fiyatDuzenleController = TextEditingController();
  Timer? _debounceTimer;
  late String _guncelFiyat;
  bool _isCalculating = false;

  String? _secilenGeriBildirim;
  bool _ozelFiyatGoster = false;

  String? _secilenIl;
  String? _secilenIlce;
  String? _secilenIlId;
  String? _secilenIlceId;
  double _lat = 0.0;
  double _lng = 0.0;

  List<dynamic> _sehirListesi = [];
  List<Map<String, String>> _filtrelenmisIlceler = [];
  bool _konumYukleniyor = true;

  @override
  void initState() {
    super.initState();
    _guncelFiyat = "LÜTFEN TÜM ALANLARI DOLDURUNUZ";
    _konumVerileriniHazirla();
  }

  Future<void> _konumVerileriniHazirla() async {
    try {
      final sehirler = await LocationService.loadSehirler();
      setState(() {
        _sehirListesi = sehirler;
      });
      await _otomatikKonumAl();
    } catch (e) {
      debugPrint("Konum hazırlama hatası: $e");
    } finally {
      setState(() => _konumYukleniyor = false);
    }
  }

  Future<void> _otomatikKonumAl() async {
    final sonuc = await LocationService.otomatikKonumTespitEt();
    if (sonuc != null && mounted) {
      setState(() {
        _secilenIl = sonuc['sehir_adi'];
        _secilenIlId = sonuc['sehir_id'];
        _secilenIlce = sonuc['ilce_adi'];
        _secilenIlceId = sonuc['ilce_id'];
        _lat = (sonuc['latitude'] ?? 0.0).toDouble();
        _lng = (sonuc['longitude'] ?? 0.0).toDouble();

        if (_secilenIl != null) {
          _ilceFiltrele(_secilenIl!);
        }
      });
    }
  }

  Future<void> _ilceFiltrele(String sehirAdi) async {
    if (_secilenIlId == null) return;
    final hamIlceler = await LocationService.loadIlceler(_secilenIlId!);
    if (mounted) {
      setState(() {
        _filtrelenmisIlceler = hamIlceler
            .map((e) => {'ad': e['ilce_adi'].toString(), 'id': e['ilce_id'].toString()})
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _notController.dispose();
    _fiyatDuzenleController.dispose();
    super.dispose();
  }

  String _formatMusteriAdi(String? adSoyad) {
    if (adSoyad == null || adSoyad.isEmpty) return "MÜŞTERİ";
    List<String> parcalar = adSoyad.trim().split(" ");
    if (parcalar.length > 1) {
      String ad = parcalar[0][0].toUpperCase() + parcalar[0].substring(1).toLowerCase();
      return "$ad ${parcalar.last[0].toUpperCase()}.";
    }
    return adSoyad.toUpperCase();
  }

  String _metniYalinHaleGetir(dynamic input) {
    if (input == null) return "";
    return input.toString().toLowerCase().trim();
  }

  bool _alanGorunurMu(Map<String, dynamic> alanHamVerisi) {
    final dynamic dependsOnId = alanHamVerisi['dependsOnId'];
    final dynamic dependsOnValueRaw = alanHamVerisi['dependsOnValue'];

    if (dependsOnId == null) return true;
    if (dependsOnValueRaw == null) return false;
    final List<dynamic> dependsOnValueList = dependsOnValueRaw is List ? dependsOnValueRaw : [dependsOnValueRaw];
    if (dependsOnValueList.isEmpty) return false;

    final ustAlanDegeri = _secilenDetaylar[dependsOnId.toString()];
    if (ustAlanDegeri == null) return false;

    final List<String> beklenenOrijinaller = dependsOnValueList.map((v) => _metniYalinHaleGetir(v)).toList();

    if (ustAlanDegeri is List) {
      final List<String> secilenOrijinaller = ustAlanDegeri.map((e) => _metniYalinHaleGetir(e)).toList();
      return beklenenOrijinaller.any((v) => secilenOrijinaller.contains(v));
    } else {
      final String secilenOrijinal = _metniYalinHaleGetir(ustAlanDegeri);
      return beklenenOrijinaller.contains(secilenOrijinal);
    }
  }

  void _altCevaplariTemizle(String ustAlanId, List<Map<String, dynamic>> hamSorular) {
    for (var x in hamSorular) {
      if (x['dependsOnId']?.toString() == ustAlanId) {
        if (!_alanGorunurMu(x)) {
          final String altAlanId = x['id'].toString();
          if (_secilenDetaylar.containsKey(altAlanId)) {
            _secilenDetaylar.remove(altAlanId);
            _altCevaplariTemizle(altAlanId, hamSorular);
          }
        }
      }
    }
  }

  bool _tumGorunurZorunluAlanlarSecildiMi() {
    final List<Map<String, dynamic>> hamSorular = IsSorulariData.getSorularByKategori(widget.ilan.kategori);
    if (hamSorular.isEmpty) return false;
    for (var x in hamSorular) {
      if (_alanGorunurMu(x)) {
        final bool isRequired = x['required'] ?? false;
        final String alanId = x['id'].toString();
        if (isRequired) {
          if (!_secilenDetaylar.containsKey(alanId) || _secilenDetaylar[alanId] == null) return false;
          if (_secilenDetaylar[alanId] is List && (_secilenDetaylar[alanId] as List).isEmpty) return false;
        }
      }
    }
    return true;
  }

  Future<void> _fiyatHesapla() async {
    _debounceTimer?.cancel();

    if (!_tumGorunurZorunluAlanlarSecildiMi() || _secilenIl == null || _secilenIlce == null) {
      if (mounted) {
        setState(() {
          _guncelFiyat = "LÜTFEN TÜM ALANLARI DOLDURUNUZ";
          _isCalculating = false;
        });
      }
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 1200), () async {
      if (!mounted) return;
      setState(() => _isCalculating = true);
      try {
        final String hesaplananSonuc = await _priceManager.orkestraFiyatHesapla(
          userId: widget.ilan.userId,
          baslik: widget.ilan.baslik,
          kategori: widget.ilan.kategori,
          kategoriId: widget.ilan.kategoriId,
          detaylar: _secilenDetaylar,
        );
        if (mounted) setState(() { _guncelFiyat = hesaplananSonuc; _isCalculating = false; });
      } catch (e) {
        if (mounted) setState(() => _isCalculating = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.ilan.baslik.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: _konumYukleniyor ? const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))) : SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    children: [
                      _buildKonumSeciciCard(),
                      const SizedBox(height: 16),
                      _buildTeknikSoruFormu(),
                      const SizedBox(height: 10),
                      _buildMusteriNotuInput(),
                      const SizedBox(height: 20),
                      _buildFiyatCard(),
                      if (!_isCalculating && !_guncelFiyat.contains("DOLDURUNUZ")) _buildFeedbackAlani(),
                    ],
                  ),
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackAlani() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("FİYATI NASIL BULDUNUZ?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ["UYGUN", "ORTA", "YÜKSEK"].map((secenek) {
            bool secili = _secilenGeriBildirim == secenek;
            return ChoiceChip(
              label: Text(secenek, style: TextStyle(color: secili ? Colors.white : Colors.white70)),
              selected: secili,
              selectedColor: const Color(0xFF2DB34A),
              backgroundColor: Colors.white.withOpacity(0.1),
              onSelected: (val) {
                setState(() {
                  _secilenGeriBildirim = secenek;
                  _ozelFiyatGoster = (secenek == "ORTA" || secenek == "YÜKSEK");
                });
              },
            );
          }).toList(),
        ),
        if (_ozelFiyatGoster) ...[
          const SizedBox(height: 15),
          const Text("SİZCE NE KADAR OLMALI?", style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          TextField(
            controller: _fiyatDuzenleController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) return newValue;
                final number = int.tryParse(newValue.text);
                if (number == null) return oldValue;
                final formatter = NumberFormat("#,###");
                final newText = formatter.format(number).replaceAll(',', '.');
                return TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(offset: newText.length),
                );
              })
            ],
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              hintText: "Örn: 25.000",
              hintStyle: const TextStyle(color: Colors.white30),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildKonumSeciciCard() { return _buildGlassCard("HİZMET YERİ", [ _buildDropdown(_secilenIl, "İl Seçiniz", _sehirListesi.map((s) => s['sehir_adi'].toString()).toList(), (val) async { var sObj = _sehirListesi.firstWhere((s) => s['sehir_adi'].toString() == val); final coords = await LocationService.getSehirKoordinat(val!); setState(() { _secilenIl = val; _secilenIlId = sObj['sehir_id'].toString(); _secilenIlce = null; _secilenIlceId = null; _filtrelenmisIlceler = []; _lat = coords['lat'] ?? 0.0; _lng = coords['lng'] ?? 0.0; }); _ilceFiltrele(val); _fiyatHesapla(); }), const SizedBox(height: 12), _buildDropdown(_secilenIlce, "İlçe Seçiniz", _filtrelenmisIlceler.map((i) => i['ad']!).toList(), (val) async { var iObj = _filtrelenmisIlceler.firstWhere((i) => i['ad'] == val); final coords = await LocationService.getIlceKoordinat(val!, _secilenIl!); setState(() { _secilenIlce = val; _secilenIlceId = iObj['id']; _lat = coords['lat'] ?? _lat; _lng = coords['lng'] ?? _lng; }); _fiyatHesapla(); }), ]); }
  Widget _buildDropdown(String? value, String hint, List<String> items, Function(String?) onChanged) { return DropdownButtonFormField<String>(value: (items.contains(value)) ? value : null, isExpanded: true, hint: Text(hint, style: const TextStyle(color: Colors.white54, fontSize: 14)), dropdownColor: const Color(0xFF203A43), decoration: InputDecoration(filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)), items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: Colors.white, fontSize: 14), overflow: TextOverflow.ellipsis))).toList(), onChanged: onChanged); }

  Widget _buildTeknikSoruFormu() {
    final List<Map<String, dynamic>> hamSorular = IsSorulariData.getSorularByKategori(widget.ilan.kategori);
    return _buildGlassCard("İLAN DETAYLARI", [
      Theme(
        data: Theme.of(context).copyWith(canvasColor: const Color(0xFF203A43)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: hamSorular.map((x) {
            if (!_alanGorunurMu(x)) return const SizedBox.shrink();
            final alan = YerelFormAlanModel.fromMap(x);
            switch (alan.type) {
              case 'single':
              case 'select':
              case 'dropdown':
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alan.label, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                          value: alan.options.contains(_secilenDetaylar[alan.id]) ? _secilenDetaylar[alan.id] : null,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF203A43),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
                          items: alan.options.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white)))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _secilenDetaylar[alan.id] = val;
                                _altCevaplariTemizle(alan.id, hamSorular);
                              });
                              _fiyatHesapla();
                            }
                          }),
                    ],
                  ),
                );
              case 'text':
              case 'segmented':
              case 'tab':
                final List<String> segmentSecenekleri = (x['options'] != null) ? List<String>.from(x['options']) : ["Standart Ölçü", "Orta Ölçü", "Büyük Ölçü"];
                final String? seciliDeger = _secilenDetaylar[alan.id];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alan.label, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      const SizedBox(height: 10),
                      LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(4),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ToggleButtons(
                              direction: Axis.horizontal,
                              borderRadius: BorderRadius.circular(10),
                              selectedColor: Colors.white,
                              fillColor: const Color(0xFF2DB34A),
                              color: Colors.white54,
                              constraints: BoxConstraints(
                                  minHeight: 40,
                                  minWidth: (constraints.maxWidth - 12) / (segmentSecenekleri.length > 3 ? 3 : segmentSecenekleri.length)),
                              isSelected: segmentSecenekleri.map((e) => e == seciliDeger).toList(),
                              renderBorder: false,
                              children: segmentSecenekleri.map((String opt) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(opt, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center));
                              }).toList(),
                              onPressed: (int index) {
                                setState(() {
                                  _secilenDetaylar[alan.id] = segmentSecenekleri[index];
                                  _altCevaplariTemizle(alan.id, hamSorular);
                                });
                                _fiyatHesapla();
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              case 'multi':
                final List<String> seciliListe = List<String>.from(_secilenDetaylar[alan.id] ?? []);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(15)),
                    child: ExpansionTile(
                      title: Text(alan.label, style: const TextStyle(color: Colors.white)),
                      children: alan.options.map((String secenek) {
                        return CheckboxListTile(
                          title: Text(secenek, style: const TextStyle(color: Colors.white70)),
                          value: seciliListe.contains(secenek),
                          onChanged: (bool? s) {
                            setState(() {
                              if (s == true)
                                seciliListe.add(secenek);
                              else
                                seciliListe.remove(secenek);
                              _secilenDetaylar[alan.id] = List<String>.from(seciliListe);
                              _altCevaplariTemizle(alan.id, hamSorular);
                            });
                            _fiyatHesapla();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              default:
                return const SizedBox.shrink();
            }
          }).toList(),
        ),
      ),
    ]);
  }

  Widget _buildMusteriNotuInput() => _buildGlassCard("EK NOTLAR", [TextField(controller: _notController, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(border: InputBorder.none))]);
  Widget _buildFiyatCard() { final bool alanlarEksik = _guncelFiyat.contains("DOLDURUNUZ"); return Column(children: [ Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)), child: _isCalculating ? const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))) : Text(alanlarEksik ? _guncelFiyat : _priceManager.formatFiyatGosterim(_guncelFiyat), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center), ), ], ); }
  Widget _buildGlassCard(String title, List<Widget> children) => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Color(0xFF2DB34A))), ...children]));

  Widget _buildActionButtons() {
    final bool alanlarEksik = _guncelFiyat.contains("DOLDURUNUZ");
    final bool formTamamlandi = _tumGorunurZorunluAlanlarSecildiMi() &&
        _secilenIl != null &&
        _secilenIlce != null &&
        !alanlarEksik &&
        !_isCalculating;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      child: ElevatedButton(
        onPressed: !formTamamlandi ? null : () async {
          final double tahminEdilen = PriceCalculationManager.fiyatTemizle(_guncelFiyat);
          bool anomaliVar = false;

          if (_ozelFiyatGoster && _fiyatDuzenleController.text.isNotEmpty) {
            final double kullaniciGirdisi = double.parse(_fiyatDuzenleController.text.replaceAll('.', ''));
            final double altSinir = tahminEdilen * 0.70;
            final double ustSinir = tahminEdilen * 1.30;
            if (kullaniciGirdisi < altSinir || kullaniciGirdisi > ustSinir) {
              anomaliVar = true;
            }
          }

          if (anomaliVar) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Fiyat Dikkat Çekiyor"),
                content: const Text("Girdiğiniz fiyat piyasa ortalamasının dışında görünüyor. Yine de bu fiyatla devam etmek istiyor musunuz?"),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Düzenle")),
                  TextButton(onPressed: () { Navigator.pop(context); _baslatYayinlamaMotoru(); }, child: const Text("Devam Et")),
                ],
              ),
            );
          } else {
            _baslatYayinlamaMotoru();
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: formTamamlandi ? const Color(0xFF2DB34A) : Colors.white10, minimumSize: const Size(double.infinity, 60)),
        child: const Text("İLANIMI YAYINLA"),
      ),
    );
  }

  Future<void> _baslatYayinlamaMotoru() async {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      await IlanYayinlamaMotoru.ilanYayinla(
        context: context,
        ilan: widget.ilan,
        detaylar: _secilenDetaylar,
        notlar: _notController.text,
        guncelFiyat: _guncelFiyat,
        secilenIl: _secilenIl!,
        secilenIlce: _secilenIlce!,
        secilenIlId: _secilenIlId!,
        secilenIlceId: _secilenIlceId!,
        secilenGeriBildirim: _secilenGeriBildirim,
        ozelFiyatGoster: _ozelFiyatGoster,
        fiyatDuzenleMetin: _fiyatDuzenleController.text,
        lat: _lat,
        lng: _lng,
        onResult: (title, content) {
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [TextButton(onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/musteri_profil');
              }, child: const Text("Tamam"))],
            ),
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata oluştu: $e")));
      }
    }
  }
}