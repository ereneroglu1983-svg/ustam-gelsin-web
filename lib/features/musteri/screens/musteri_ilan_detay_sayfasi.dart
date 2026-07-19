// lib/features/musteri/screens/musteri_ilan_detay_sayfasi.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/managers/price_calculation_manager.dart';
import 'package:ustam_gelsin/core/models/yerel_form_alan_model.dart';
import 'package:ustam_gelsin/core/constants/is_sorulari_data.dart';
import 'package:intl/intl.dart';
import 'package:ustam_gelsin/core/managers/ilan_yayinlama_motoru.dart';
import 'package:ustam_gelsin/features/musteri/screens/is_resimleri.dart';

class MusteriIlanDetaySayfasi extends StatefulWidget {
  final IlanModel ilan;
  const MusteriIlanDetaySayfasi({super.key, required this.ilan});
  @override
  State<MusteriIlanDetaySayfasi> createState() => _MusteriIlanDetaySayfasiState();
}

class _MusteriIlanDetaySayfasiState extends State<MusteriIlanDetaySayfasi> {
  final PriceCalculationManager _priceManager = PriceCalculationManager();

  final Map<String, dynamic> _secilenDetaylar = {};
  final TextEditingController _notController = TextEditingController();
  final TextEditingController _anketFiyatController = TextEditingController();

  late String _guncelFiyat;
  bool _isCalculating = false;
  bool _fiyatHesaplandi = false;

  String _fiyatAraligi = "";
  double _minButce = 0;
  double _maxButce = 0;
  double _komisyonTutari = 0;

  // YENI - Yasal onay icin
  bool _kullanimKosullariOnaylandi = false;

  String? _secilenGeriBildirim;

  String? _secilenIl;
  String? _secilenIlce;
  String? _secilenIlId;
  String? _secilenIlceId;
  double _lat = 0.0;
  double _lng = 0.0;

  List<dynamic> _sehirListesi = [];
  List<Map<String, String>> _filtrelenmisIlceler = [];
  bool _konumYukleniyor = true;

  bool _resimEklemeIstiyor = false;
  List<String> _resimUrlListesi = [];

  @override
  void initState() {
    super.initState();
    _guncelFiyat = "LÜTFEN TÜM ALANLARI DOLDURUNUZ";
    _konumVerileriniHazirla();
  }

  Future<void> _konumVerileriniHazirla() async {
    try {
      final sehirler = await LocationService.loadSehirler();
      if (!mounted) return;
      setState(() => _sehirListesi = sehirler);
      await _otomatikKonumAl();
    } catch (e) {
      debugPrint("Konum hazırlama hatası: $e");
    } finally {
      if (mounted) setState(() => _konumYukleniyor = false);
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
        if (_secilenIl != null) _ilceFiltrele(_secilenIl!);
      });
    }
  }

  Future<void> _ilceFiltrele(String sehirAdi) async {
    if (_secilenIlId == null) return;
    final hamIlceler = await LocationService.loadIlceler(_secilenIlId!);
    if (mounted) {
      setState(() {
        _filtrelenmisIlceler = hamIlceler.map((e) => {'ad': e['ilce_adi'].toString(), 'id': e['ilce_id'].toString()}).toList();
      });
    }
  }

  @override
  void dispose() {
    _notController.dispose();
    _anketFiyatController.dispose();
    super.dispose();
  }

  bool _alanGorunurMu(Map<String, dynamic> alanHamVerisi) {
    if (alanHamVerisi.containsKey('visibleIf')) {
      final dynamic visibleIfRaw = alanHamVerisi['visibleIf'];
      if (visibleIfRaw is Map) {
        for (final entry in visibleIfRaw.entries) {
          final String key = entry.key.toString();
          final dynamic beklenenRaw = entry.value;
          final List<String> beklenenList = beklenenRaw is List
              ? beklenenRaw.map((e) => e.toString().toLowerCase().trim()).toList()
              : [beklenenRaw.toString().toLowerCase().trim()];
          final dynamic secilen = _secilenDetaylar[key];
          if (secilen == null) return false;
          if (secilen is List) {
            final secilenler = secilen.map((e) => e.toString().toLowerCase().trim()).toList();
            if (!beklenenList.any((b) => secilenler.contains(b))) return false;
          } else {
            if (!beklenenList.contains(secilen.toString().toLowerCase().trim())) return false;
          }
        }
      }
    }
    final dynamic dependsOnIdRaw = alanHamVerisi['dependsOnId'];
    final dynamic dependsOnId2Raw = alanHamVerisi['dependsOnId2'];
    final dynamic dependsOnValueRaw = alanHamVerisi['dependsOnValue'];
    if (dependsOnIdRaw == null && dependsOnId2Raw == null) return true;
    final List<String> parentIds = [];
    if (dependsOnIdRaw != null) {
      if (dependsOnIdRaw is List) {
        parentIds.addAll(dependsOnIdRaw.map((e) => e.toString()));
      } else {
        parentIds.add(dependsOnIdRaw.toString());
      }
    }
    if (dependsOnId2Raw != null) {
      if (dependsOnId2Raw is List) {
        parentIds.addAll(dependsOnId2Raw.map((e) => e.toString()));
      } else {
        parentIds.add(dependsOnId2Raw.toString());
      }
    }
    if (dependsOnValueRaw == null) {
      for (final pid in parentIds) {
        final v = _secilenDetaylar[pid];
        if (v != null && (v is List ? v.isNotEmpty : v.toString().trim().isNotEmpty)) {
          return true;
        }
      }
      return false;
    }
    final List<dynamic> dependsOnValueList = dependsOnValueRaw is List ? dependsOnValueRaw : [dependsOnValueRaw];
    if (dependsOnValueList.isEmpty) return false;
    final List<String> beklenenOrijinaller = dependsOnValueList.map((v) => v.toString().toLowerCase().trim()).toList();
    for (final pid in parentIds) {
      final ustAlanDegeri = _secilenDetaylar[pid];
      if (ustAlanDegeri == null) continue;
      if (ustAlanDegeri is String && ustAlanDegeri.trim().isEmpty) continue;
      if (ustAlanDegeri is List && ustAlanDegeri.isEmpty) continue;
      if (ustAlanDegeri is List) {
        final List<String> secilenOrijinaller = ustAlanDegeri.map((e) => e.toString().toLowerCase().trim()).toList();
        if (beklenenOrijinaller.any((v) => secilenOrijinaller.contains(v))) return true;
      } else {
        final String secilenOrijinal = ustAlanDegeri.toString().toLowerCase().trim();
        if (beklenenOrijinaller.contains(secilenOrijinal)) return true;
      }
    }
    return false;
  }

  void _altCevaplariTemizle(String ustAlanId, List<Map<String, dynamic>> hamSorular) {
    for (var x in hamSorular) {
      final dynamic rawId = x['dependsOnId'];
      final List<String> bagliIdler = rawId == null ? [] : rawId is List ? rawId.map((e) => e.toString()).toList() : [rawId.toString()];
      final String? bagliId2 = x['dependsOnId2']?.toString();
      if (bagliId2 != null) bagliIdler.add(bagliId2);
      final bool isChild = bagliIdler.contains(ustAlanId);
      bool isVisibleIfChild = false;
      if (x.containsKey('visibleIf') && x['visibleIf'] is Map) {
        isVisibleIfChild = (x['visibleIf'] as Map).keys.map((e) => e.toString()).contains(ustAlanId);
      }
      if (isChild || isVisibleIfChild) {
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

  void _secimYapildi() {
    if (_fiyatHesaplandi) {
      setState(() {
        _fiyatHesaplandi = false;
        _guncelFiyat = "LÜTFEN FİYATI YENİDEN HESAPLAYIN";
        _fiyatAraligi = "";
        _kullanimKosullariOnaylandi = false;
        _secilenGeriBildirim = null;
        _anketFiyatController.clear();
      });
    }
  }

  Future<void> _fiyatHesapla() async {
    setState(() => _isCalculating = true);
    try {
      final String bolgeKodu = _secilenIlId ?? _secilenIl ?? "diger";
      final String talepId = widget.ilan.id.isNotEmpty ? widget.ilan.id : widget.ilan.userId;
      final Map<String, dynamic> sonucMap = await _priceManager.orkestraFiyatHesapla(
        userId: widget.ilan.userId,
        talepId: talepId,
        baslik: widget.ilan.baslik,
        kategori: widget.ilan.kategori,
        kategoriId: widget.ilan.kategoriId,
        detaylar: _secilenDetaylar,
        bolgeKodu: bolgeKodu,
      );
      if (mounted) {
        setState(() {
          _minButce = (sonucMap['minimumButce'] as num).toDouble();
          _maxButce = (sonucMap['maksimumButce'] as num).toDouble();
          _komisyonTutari = (sonucMap['komisyonTutari'] as num?)?.toDouble() ?? 0;
          _fiyatAraligi = sonucMap['aralikliFiyatBilgisi']?.toString() ?? "${sonucMap['minimumButce'].toString()} - ${sonucMap['maksimumButce'].toString()} ₺";
          _guncelFiyat = _fiyatAraligi;
          _isCalculating = false;
          _fiyatHesaplandi = true;
          _kullanimKosullariOnaylandi = false;
          _secilenGeriBildirim = null;
          _anketFiyatController.clear();
        });
      }
    } catch (e) {
      if (mounted) setState(() {
        _guncelFiyat = "HESAPLAMA HATASI";
        _fiyatAraligi = "HESAPLAMA HATASI";
        _isCalculating = false;
        _fiyatHesaplandi = false;
      });
    }
  }

  void _kullanimKosullariGoster() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF203A43),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFE53935)),
            SizedBox(width: 8),
            Text("KULLANIM KOŞULLARI", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            "Bu ekranda gösterilen tutar, kullanıcı tarafından girilen bilgiler doğrultusunda yapay zekâ tarafından oluşturulan yaklaşık bir maliyet tahminidir.\n\n"
                "Bu tutar kesin fiyat teklifi değildir ve herhangi bir usta veya hizmet sağlayıcı için bağlayıcı nitelik taşımaz. Gerçek iş bedeli; yapılacak keşif, işin mevcut durumu, kullanılacak malzeme, işçilik, bölgesel fiyat farklılıkları ve ek talepler gibi unsurlara göre değişiklik gösterebilir.\n\n"
                "Nihai fiyat, işi gerçekleştirecek usta tarafından yapılacak keşif sonrasında belirlenir.\n\n"
                "Hemen Ustam Gelsin, yapay zekâ tarafından oluşturulan tahmini maliyet ile ustalar tarafından sunulan nihai teklifler arasında oluşabilecek fiyat farklılıklarından sorumlu değildir. Bu hizmet, kullanıcıların yaklaşık bütçe planlaması yapabilmesi amacıyla sunulmaktadır.",
            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("KAPAT", style: TextStyle(color: Color(0xFF2DB34A), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2DB34A)),
            onPressed: () {
              setState(() => _kullanimKosullariOnaylandi = true);
              Navigator.pop(context);
            },
            child: const Text("OKUDUM, ONAYLIYORUM", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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
                      _buildResimSorguAlani(),
                      _buildMusteriNotuInput(),
                      const SizedBox(height: 20),
                      _buildFiyatCard(),
                      if (_fiyatHesaplandi && !_isCalculating) ...[
                        _buildFeedbackAlani(),
                        const SizedBox(height: 20),
                        _buildYasalUyariVeOnay(),
                      ],
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

  Widget _buildDropdown(String? seciliDeger, String hint, List<String> items, Function(String?) onChanged) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: const Color(0xFF203A43)),
      child: DropdownButtonFormField<String>(
        value: items.contains(seciliDeger) ? seciliDeger : null,
        isExpanded: true,
        hint: Text(hint, style: const TextStyle(color: Colors.white54, fontSize: 14)),
        dropdownColor: const Color(0xFF203A43),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70),
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
        items: items.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 14)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildKonumSeciciCard() {
    return _buildGlassCard("HİZMET YERİ", [
      _buildDropdown(_secilenIl, "İl Seçiniz", _sehirListesi.map((s) => s['sehir_adi'].toString()).toList(), (val) async {
        if (val == null) return;
        var sObj = _sehirListesi.firstWhere((s) => s['sehir_adi'].toString() == val);
        final coords = await LocationService.getSehirKoordinat(val);
        setState(() {
          _secilenIl = val; _secilenIlId = sObj['sehir_id'].toString();
          _secilenIlce = null; _secilenIlceId = null; _filtrelenmisIlceler = [];
          _lat = coords['lat'] ?? 0.0; _lng = coords['lng'] ?? 0.0;
        });
        _ilceFiltrele(val);
        _secimYapildi();
      }),
      const SizedBox(height: 12),
      _buildDropdown(_secilenIlce, "İlçe Seçiniz", _filtrelenmisIlceler.map((i) => i['ad']!).toList(), (val) async {
        if (val == null) return;
        var iObj = _filtrelenmisIlceler.firstWhere((i) => i['ad'] == val);
        final coords = await LocationService.getIlceKoordinat(val, _secilenIl!);
        setState(() {
          _secilenIlce = val; _secilenIlceId = iObj['id'];
          _lat = coords['lat'] ?? _lat; _lng = coords['lng'] ?? _lng;
        });
        _secimYapildi();
      }),
    ]);
  }

  Widget _buildTeknikSoruFormu() {
    final List<Map<String, dynamic>> hamSorular = IsSorulariData.getSorularByKategori(widget.ilan.kategori);
    final List<Map<String, dynamic>> kokSorular = hamSorular.where((s) => s['dependsOnId'] == null).toList();
    final List<Map<String, dynamic>> bagimliSorular = hamSorular.where((s) => s['dependsOnId'] != null).toList();
    Widget _soruWidgetOlustur(Map<String, dynamic> x) {
      final alan = YerelFormAlanModel.fromMap(x);
      switch (alan.type) {
        case 'single': case 'select': case 'dropdown':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(alan.label, style: const TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
                value: alan.options.contains(_secilenDetaylar[alan.id]) ? _secilenDetaylar[alan.id] : null,
                isExpanded: true, dropdownColor: const Color(0xFF203A43),
                decoration: InputDecoration(filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
                items: alan.options.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white)))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() { _secilenDetaylar[alan.id] = val; _altCevaplariTemizle(alan.id, hamSorular); });
                    _secimYapildi();
                  }
                }),
          ]),
        );
        case 'text': case 'segmented': case 'tab':
        final List<String> segmentSecenekleri = (x['options'] != null) ? List<String>.from(x['options']) : ["Standart Ölçü", "Orta Ölçü", "Büyük Ölçü"];
        final String? seciliDeger = _secilenDetaylar[alan.id];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(alan.label, style: const TextStyle(color: Colors.white, fontSize: 14)), const SizedBox(height: 10),
            LayoutBuilder(builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.all(4),
                child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(10), selectedColor: Colors.white, fillColor: const Color(0xFF2DB34A), color: Colors.white54,
                    constraints: BoxConstraints(minHeight: 40, minWidth: (constraints.maxWidth - 8) / segmentSecenekleri.length.clamp(1, 4)),
                    isSelected: segmentSecenekleri.map((e) => e == seciliDeger).toList(), renderBorder: false,
                    children: segmentSecenekleri.map((opt) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child: Text(opt, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center))).toList(),
                    onPressed: (int index) {
                      setState(() { _secilenDetaylar[alan.id] = segmentSecenekleri[index]; _altCevaplariTemizle(alan.id, hamSorular); });
                      _secimYapildi();
                    },
                  ),
                ),
              );
            }),
          ]),
        );
        case 'multi':
          final List<String> seciliListe = List<String>.from(_secilenDetaylar[alan.id] ?? []);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(15)),
              child: ExpansionTile(title: Text(alan.label, style: const TextStyle(color: Colors.white)), iconColor: Colors.white70, collapsedIconColor: Colors.white70,
                children: alan.options.map((String secenek) {
                  return CheckboxListTile(
                    title: Text(secenek, style: const TextStyle(color: Colors.white70)), value: seciliListe.contains(secenek), activeColor: const Color(0xFF2DB34A),
                    onChanged: (bool? s) {
                      setState(() {
                        if (s == true) seciliListe.add(secenek); else seciliListe.remove(secenek);
                        _secilenDetaylar[alan.id] = List<String>.from(seciliListe);
                        _altCevaplariTemizle(alan.id, hamSorular);
                      });
                      _secimYapildi();
                    },
                  );
                }).toList(),
              ),
            ),
          );
        default: return const SizedBox.shrink();
      }
    }
    List<Widget> _bagimliGruplariOlustur() {
      if (bagimliSorular.isEmpty) return [];
      final gorunurBagimlilar = bagimliSorular.where((s) => _alanGorunurMu(s)).toList();
      if (gorunurBagimlilar.isEmpty) return [];
      final Map<String, List<Map<String, dynamic>>> gruplar = {};
      for (var soru in gorunurBagimlilar) {
        final key = (soru['dependsOnValue'] is List) ? (soru['dependsOnValue'] as List).first.toString() : soru['dependsOnValue'].toString();
        gruplar.putIfAbsent(key, () => []).add(soru);
      }
      return gruplar.entries.map((entry) {
        return Padding(padding: const EdgeInsets.only(top: 12.0),
          child: Container(decoration: BoxDecoration(color: const Color(0xFF2DB34A).withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2DB34A).withOpacity(0.25))),
            child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(initiallyExpanded: true, tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16), iconColor: const Color(0xFF2DB34A), collapsedIconColor: Colors.white70,
                title: Row(children: [Container(width: 4, height: 18, decoration: BoxDecoration(color: const Color(0xFF2DB34A), borderRadius: BorderRadius.circular(2))), const SizedBox(width: 10), Expanded(child: Text(entry.key.toUpperCase(), style: const TextStyle(color: Color(0xFF2DB34A), fontSize: 12, fontWeight: FontWeight.bold)))]),
                children: entry.value.map((s) => _soruWidgetOlustur(s)).toList(),
              ),
            ),
          ),
        );
      }).toList();
    }
    return _buildGlassCard("İLAN DETAYLARI", [Theme(data: Theme.of(context).copyWith(canvasColor: const Color(0xFF203A43)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [...kokSorular.map((x) => _soruWidgetOlustur(x)).toList(), ..._bagimliGruplariOlustur()]))]);
  }

  Widget _buildResimSorguAlani() {
    return _buildGlassCard("İLAN RESİMLERİ", [
      const Text("İlanınızla ilgili resim eklemek ister misiniz?", style: TextStyle(color: Colors.white)), const SizedBox(height: 10),
      Row(children: [
        Expanded(child: RadioListTile(title: const Text("Evet", style: TextStyle(color: Colors.white)), value: true, groupValue: _resimEklemeIstiyor, activeColor: const Color(0xFF2DB34A), onChanged: (v) => setState(() => _resimEklemeIstiyor = v!))),
        Expanded(child: RadioListTile(title: const Text("Hayır", style: TextStyle(color: Colors.white)), value: false, groupValue: _resimEklemeIstiyor, activeColor: const Color(0xFF2DB34A), onChanged: (v) => setState(() => _resimEklemeIstiyor = v!))),
      ]),
      if (_resimEklemeIstiyor) ...[const SizedBox(height: 10), IsResimleri(key: ValueKey(_resimEklemeIstiyor), onResimYuklendi: (urls) => setState(() => _resimUrlListesi = urls))],
    ]);
  }

  Widget _buildMusteriNotuInput() => _buildGlassCard("EK NOTLAR", [
    TextField(controller: _notController, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: InputDecoration(border: InputBorder.none, hintText: "Varsa eklemek istediğiniz detayları yazın...", hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)))),
    const SizedBox(height: 15), _buildHesaplaButonu(),
  ]);

  Widget _buildHesaplaButonu() {
    final bool formTamam = _tumGorunurZorunluAlanlarSecildiMi() && _secilenIl != null && _secilenIlce != null;
    return SizedBox(width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: formTamam ? const Color(0xFF2DB34A) : Colors.white10, padding: const EdgeInsets.symmetric(vertical: 15)),
        onPressed: formTamam ? () => _fiyatHesapla() : null,
        child: Text(formTamam ? "FİYATI HESAPLA" : "TÜM ALANLARI DOLDURUN", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // SADECE TAHMINI BUTCE + ARALIK GOSTERIR
  Widget _buildFiyatCard() {
    final bool gosterilmeyecek = _guncelFiyat.contains("DOLDURUNUZ") || _guncelFiyat.contains("YENİDEN");
    if (_isCalculating) {
      return Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
        child: const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))),
      );
    }
    if (gosterilmeyecek) {
      return Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
        child: Text(_guncelFiyat, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      );
    }
    return Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20), decoration: BoxDecoration(color: const Color(0xFF2DB34A).withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF2DB34A).withOpacity(0.4))),
      child: Column(
        children: [
          const Text("TAHMİNİ BÜTÇE", style: TextStyle(color: Color(0xFF2DB34A), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          Text(_fiyatAraligi, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 0.5), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildGlassCard(String title, List<Widget> children) => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Color(0xFF2DB34A), fontSize: 13, fontWeight: FontWeight.bold)), const SizedBox(height: 12), ...children]));

  Widget _buildFeedbackAlani() {
    return Padding(padding: const EdgeInsets.only(top: 20),
      child: _buildGlassCard("FİYAT GERİ BİLDİRİMİ", [
        const Text("Hesaplanan fiyat hakkında ne düşünüyorsun?", style: TextStyle(color: Colors.white70, fontSize: 13)), const SizedBox(height: 12),
        Wrap(spacing: 8, children: ["Fiyat uygun", "Fiyat çok yüksek"].map((geriBildirim) {
          final bool secili = _secilenGeriBildirim == geriBildirim;
          return GestureDetector(onTap: () => setState(() => _secilenGeriBildirim = geriBildirim),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: secili ? const Color(0xFF2DB34A) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: secili ? const Color(0xFF2DB34A) : Colors.white10)),
                child: Text(geriBildirim, style: TextStyle(color: secili ? Colors.white : Colors.white70, fontSize: 13, fontWeight: secili ? FontWeight.w600 : FontWeight.normal))),
          );
        }).toList()),
        if (_secilenGeriBildirim == "Fiyat çok yüksek") ...[
          const SizedBox(height: 16),
          TextField(controller: _anketFiyatController, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(hintText: "Sizce ne kadar olmalıydı?", hintStyle: const TextStyle(color: Colors.white38), filled: true, fillColor: Colors.white.withOpacity(0.05), suffixText: "₺", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
          const SizedBox(height: 6), const Text("Bu tutar ilanın fiyatını değiştirmez, sadece anket için kullanılır.", style: TextStyle(color: Colors.white30, fontSize: 11)),
        ]
      ]),
    );
  }

  // YENI - YASAL UYARI + ONAY KUTUSU
  Widget _buildYasalUyariVeOnay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AI Maliyet Tahmini yalnızca bilgilendirme ve yaklaşık bütçe planlaması amacıyla sunulmaktadır. Gösterilen tutar kesin fiyat teklifi değildir, teklif, taahhüt veya sözleşme niteliği taşımaz. Nihai fiyat, işi gerçekleştirecek usta tarafından yapılacak keşif sonrasında belirlenir.",
            style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 11.5, height: 1.5),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _kullanimKosullariOnaylandi,
                  activeColor: const Color(0xFF2DB34A),
                  checkColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.4), width: 1.2),
                  onChanged: (v) => setState(() => _kullanimKosullariOnaylandi = v ?? false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  children: [
                    Text("Kullanım koşullarını ", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12.5)),
                    GestureDetector(
                      onTap: _kullanimKosullariGoster,
                      child: const Text(
                        "okudum ve anladım",
                        style: TextStyle(color: Color(0xFFE53935), fontSize: 12.5, decoration: TextDecoration.underline, decorationColor: Color(0xFFE53935), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final bool yayinlanabilir = _fiyatHesaplandi && !_isCalculating && !_guncelFiyat.contains("HATASI") && _kullanimKosullariOnaylandi;
    return Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ElevatedButton(
          onPressed: !yayinlanabilir ? null : () => _baslatYayinlamaMotoru(),
          style: ElevatedButton.styleFrom(
            backgroundColor: yayinlanabilir ? const Color(0xFF2DB34A) : Colors.white10,
            disabledBackgroundColor: Colors.white10,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Text(
            !yayinlanabilir && _fiyatHesaplandi && !_kullanimKosullariOnaylandi ? "KOŞULLARI ONAYLAYIN" : yayinlanabilir ? "İLANIMI YAYINLA" : "ÖNCE FİYATI HESAPLA",
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.only(bottom: 25.0), child: Text("hemenustamgelsin@gmail.com", style: TextStyle(color: Colors.white30, fontSize: 12))),
    ]);
  }

  Future<void> _baslatYayinlamaMotoru() async {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))));
    try {
      final String fiyatMetni = _fiyatAraligi.isNotEmpty ? _fiyatAraligi : _guncelFiyat;
      await IlanYayinlamaMotoru.ilanYayinla(
        context: context, ilan: widget.ilan, detaylar: _secilenDetaylar, resimler: _resimUrlListesi, notlar: _notController.text,
        fiyatBilgisi: fiyatMetni,
        secilenIl: _secilenIl!, secilenIlce: _secilenIlce!, secilenIlId: _secilenIlId!, secilenIlceId: _secilenIlceId!,
        secilenGeriBildirim: _secilenGeriBildirim,
        ozelFiyatGoster: false,
        fiyatDuzenleMetin: _anketFiyatController.text,
        lat: _lat, lng: _lng,
        onResult: (title, content) {
          Navigator.pop(context);
          showDialog(context: context, barrierDismissible: false, builder: (context) => AlertDialog(backgroundColor: const Color(0xFF203A43), title: Text(title, style: const TextStyle(color: Colors.white)), content: Text(content, style: const TextStyle(color: Colors.white70)), actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/musteri_profil'); }, child: const Text("Tamam", style: TextStyle(color: Color(0xFF2DB34A))))]));
        },
      );
    } catch (e) {
      if (context.mounted) { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata oluştu: $e"), backgroundColor: Colors.redAccent)); }
    }
  }
}