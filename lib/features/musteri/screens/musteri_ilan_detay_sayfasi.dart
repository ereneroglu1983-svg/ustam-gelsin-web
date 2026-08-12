// lib/features/musteri/screens/musteri_ilan_detay_sayfasi.dart - FINAL - YAZI EKLEMELİ - REVIZE EDİLDİ
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/managers/price_calculation_manager.dart';
import 'package:ustam_gelsin/core/models/yerel_form_alan_model.dart';
import 'package:ustam_gelsin/core/constants/is_sorulari_data.dart';
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
  double _muhtemelButce = 0;
  double _komisyonTutari = 0;
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

  bool _alanGorunurMu(Map<String, dynamic> alan) {
    final id = alan['id'].toString();
    if (id == 'yapi_cesidi' || alan['dependsOnId'] == null && alan['dependsOnId2'] == null && !alan.containsKey('visibleIf')) {
      if (id == 'yapi_cesidi') return true;
    }
    if (id == 'alan_kademe') {
      final yapi = _secilenDetaylar['yapi_cesidi']?.toString().toLowerCase().trim();
      final oda = _secilenDetaylar['oda_sayisi'];
      if (yapi == 'ofis' || yapi == 'iş yeri' || yapi == 'is yeri') return true;
      if (oda != null && oda.toString().trim().isNotEmpty) return true;
      return false;
    }
    final dependsId = alan['dependsOnId'];
    final dependsId2 = alan['dependsOnId2'];
    final dependsVal = alan['dependsOnValue'];
    List<String> parentIds = [];
    if (dependsId != null) {
      if (dependsId is List) parentIds.addAll(dependsId.map((e) => e.toString()));
      else parentIds.add(dependsId.toString());
    }
    if (dependsId2 != null) {
      if (dependsId2 is List) parentIds.addAll(dependsId2.map((e) => e.toString()));
      else parentIds.add(dependsId2.toString());
    }
    if (parentIds.isEmpty) return true;
    String? parentVal;
    dynamic parentRaw;
    for (final pid in parentIds) {
      if (_secilenDetaylar.containsKey(pid) && _secilenDetaylar[pid] != null) {
        parentRaw = _secilenDetaylar[pid];
        parentVal = parentRaw.toString().toLowerCase().trim();
        break;
      }
    }
    if (parentRaw == null) return false;
    if (parentRaw is String && parentRaw.trim().isEmpty) return false;
    if (parentRaw is List && parentRaw.isEmpty) return false;
    if (dependsVal == null) return true;
    List<String> beklenen = dependsVal is List ? dependsVal.map((e) => e.toString().toLowerCase().trim()).toList() : [dependsVal.toString().toLowerCase().trim()];
    if (parentRaw is List) {
      final secilenler = parentRaw.map((e) => e.toString().toLowerCase().trim()).toList();
      return beklenen.any((b) => secilenler.contains(b));
    } else {
      return beklenen.contains(parentVal);
    }
  }

  void _altCevaplariTemizle(String ustAlanId, List<Map<String, dynamic>> hamSorular) {
    for (var x in hamSorular) {
      final rawId = x['dependsOnId'];
      List<String> bagli = rawId == null ? [] : rawId is List ? rawId.map((e) => e.toString()).toList() : [rawId.toString()];
      final id2 = x['dependsOnId2']?.toString();
      if (id2 != null) bagli.add(id2);
      if (bagli.contains(ustAlanId) || (x['visibleIf'] is Map && (x['visibleIf'] as Map).containsKey(ustAlanId))) {
        if (!_alanGorunurMu(x)) {
          final altId = x['id'].toString();
          if (_secilenDetaylar.containsKey(altId)) {
            _secilenDetaylar.remove(altId);
            _altCevaplariTemizle(altId, hamSorular);
          }
        }
      }
    }
  }

  bool _tumGorunurZorunluAlanlarSecildiMi() {
    final hamSorular = IsSorulariData.getSorularByKategori(widget.ilan.kategori);
    if (hamSorular.isEmpty) return false;
    for (var x in hamSorular) {
      if (_alanGorunurMu(x)) {
        final isRequired = x['required'] ?? false;
        final alanId = x['id'].toString();
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
      final bolgeKodu = _secilenIlId ?? _secilenIl ?? "diger";
      final talepId = widget.ilan.id.isNotEmpty ? widget.ilan.id : widget.ilan.userId;
      final sonucMap = await _priceManager.orkestraFiyatHesapla(
        userId: widget.ilan.userId, talepId: talepId, baslik: widget.ilan.baslik,
        kategori: widget.ilan.kategori, kategoriId: widget.ilan.kategoriId,
        detaylar: _secilenDetaylar, bolgeKodu: bolgeKodu,
      );
      if (mounted) {
        setState(() {
          _minButce = (sonucMap['minimumButce'] as num).toDouble();
          _maxButce = (sonucMap['maksimumButce'] as num).toDouble();
          _muhtemelButce = (sonucMap['muhtemelButce'] as num?)?.toDouble() ?? ((_minButce + _maxButce) / 2);
          _komisyonTutari = (sonucMap['komisyonTutari'] as num?)?.toDouble() ?? 0;
          _fiyatAraligi = sonucMap['aralikliFiyatBilgisi']?.toString() ?? "${_minButce.toStringAsFixed(0)} - ${_maxButce.toStringAsFixed(0)} ₺";
          _guncelFiyat = _fiyatAraligi;
          _isCalculating = false; _fiyatHesaplandi = true;
          _kullanimKosullariOnaylandi = false; _secilenGeriBildirim = null; _anketFiyatController.clear();
        });
      }
    } catch (e) {
      if (mounted) setState(() { _guncelFiyat = "HESAPLAMA HATASI"; _fiyatAraligi = "HESAPLAMA HATASI"; _isCalculating = false; _fiyatHesaplandi = false; });
    }
  }

  void _kullanimKosullariGoster() {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF203A43), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(children: [Icon(Icons.warning_amber_rounded, color: Color(0xFFE53935)), SizedBox(width: 8), Text("BİLGİLENDİRME", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))]),
      content: SingleChildScrollView(child: Text(
          "Bu ekranda gösterilen maliyet aralığının; kullanıcı tarafından girilen bilgiler, bölgesel piyasa verileri ve yapay zekâ destekli analizler kullanılarak otomatik olarak oluşturulan tahmini bir hesaplama olduğunu kabul ediyorum. Nihai fiyat; işin keşfi, uygulanacak malzeme kalitesi, işçilik durumu, proje detayları ve yerinde yapılacak inceleme sonucunda değişiklik gösterebilir. Bu hesaplamanın bağlayıcı bir teklif, taahhüt veya sözleşme niteliği taşımadığını; yalnızca ön bilgilendirme amacıyla sunulduğunu okudum ve anladım.",
          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, height: 1.6))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("KAPAT", style: TextStyle(color: Color(0xFF2DB34A)))), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2DB34A)), onPressed: () { setState(() => _kullanimKosullariOnaylandi = true); Navigator.pop(context); }, child: const Text("OKUDUM, ONAYLIYORUM", style: TextStyle(color: Colors.white, fontSize: 12)))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027), extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(widget.ilan.baslik.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context))),
      body: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: _konumYukleniyor ? const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))) : SafeArea(child: Column(children: [Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 20), child: Column(children: [_buildKonumSeciciCard(), const SizedBox(height: 16), _buildTeknikSoruFormu(), const SizedBox(height: 10), _buildResimSorguAlani(), _buildMusteriNotuInput(), const SizedBox(height: 20), _buildFiyatCard(), if (_fiyatHesaplandi && !_isCalculating) ...[_buildFeedbackAlani(), const SizedBox(height: 20), _buildYasalUyariVeOnay()]]))), _buildActionButtons()])),
      ),
    );
  }

  Widget _buildDropdown(String? secili, String hint, List<String> items, Function(String?) onChanged) {
    return Theme(data: Theme.of(context).copyWith(canvasColor: const Color(0xFF203A43)), child: DropdownButtonFormField<String>(value: items.contains(secili) ? secili : null, isExpanded: true, hint: Text(hint, style: const TextStyle(color: Colors.white54, fontSize: 14)), dropdownColor: const Color(0xFF203A43), icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70), decoration: InputDecoration(filled: true, fillColor: Colors.white.withOpacity(0.05), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)), items: items.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 14)))).toList(), onChanged: onChanged));
  }

  Widget _buildKonumSeciciCard() => _buildGlassCard("HİZMET YERİ", [_buildDropdown(_secilenIl, "İl Seçiniz", _sehirListesi.map((s) => s['sehir_adi'].toString()).toList(), (val) async { if (val == null) return; var sObj = _sehirListesi.firstWhere((s) => s['sehir_adi'].toString() == val); final coords = await LocationService.getSehirKoordinat(val); setState(() { _secilenIl = val; _secilenIlId = sObj['sehir_id'].toString(); _secilenIlce = null; _secilenIlceId = null; _filtrelenmisIlceler = []; _lat = coords['lat'] ?? 0.0; _lng = coords['lng'] ?? 0.0; }); _ilceFiltrele(val); _secimYapildi(); }), const SizedBox(height: 12), _buildDropdown(_secilenIlce, "İlçe Seçiniz", _filtrelenmisIlceler.map((i) => i['ad']!).toList(), (val) async { if (val == null) return; var iObj = _filtrelenmisIlceler.firstWhere((i) => i['ad'] == val); final coords = await LocationService.getIlceKoordinat(val, _secilenIl!); setState(() { _secilenIlce = val; _secilenIlceId = iObj['id']; _lat = coords['lat'] ?? _lat; _lng = coords['lng'] ?? _lng; }); _secimYapildi(); })]);

  Widget _buildTeknikSoruFormu() {
    final List<Map<String, dynamic>> hamSorular = IsSorulariData.getSorularByKategori(widget.ilan.kategori);
    Widget soruWidgetOlustur(Map<String, dynamic> x) {
      final alan = YerelFormAlanModel.fromMap(x);
      switch (alan.type) {
        case 'single': case 'select': case 'dropdown':
        return Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(alan.label, style: const TextStyle(color: Colors.white, fontSize: 14)), const SizedBox(height: 8), DropdownButtonFormField<String>(value: alan.options.contains(_secilenDetaylar[alan.id]) ? _secilenDetaylar[alan.id] : null, isExpanded: true, dropdownColor: const Color(0xFF203A43), decoration: InputDecoration(filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)), items: alan.options.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white)))).toList(), onChanged: (val) { if (val != null) { setState(() { _secilenDetaylar[alan.id] = val; _altCevaplariTemizle(alan.id, hamSorular); }); _secimYapildi(); } })]));
        case 'text': case 'segmented': case 'tab':
        final List<String> seg = (x['options'] != null) ? List<String>.from(x['options']) : ["Standart", "Orta", "Büyük"];
        final secili = _secilenDetaylar[alan.id];
        return Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(alan.label, style: const TextStyle(color: Colors.white, fontSize: 14)), const SizedBox(height: 10), Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.all(4), child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: ToggleButtons(borderRadius: BorderRadius.circular(10), selectedColor: Colors.white, fillColor: const Color(0xFF2DB34A), color: Colors.white54, isSelected: seg.map((e) => e == secili).toList(), renderBorder: false, children: seg.map((o) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child: Text(o, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)))).toList(), onPressed: (i) { setState(() { _secilenDetaylar[alan.id] = seg[i]; _altCevaplariTemizle(alan.id, hamSorular); }); _secimYapildi(); }))) ]));
        case 'multi':
          final seciliListe = List<String>.from(_secilenDetaylar[alan.id] ?? []);
          return Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(15)), child: ExpansionTile(title: Text(alan.label, style: const TextStyle(color: Colors.white)), iconColor: Colors.white70, collapsedIconColor: Colors.white70, children: alan.options.map((secenek) { return CheckboxListTile(title: Text(secenek, style: const TextStyle(color: Colors.white70)), value: seciliListe.contains(secenek), activeColor: const Color(0xFF2DB34A), onChanged: (s) { setState(() { if (s == true) seciliListe.add(secenek); else seciliListe.remove(secenek); _secilenDetaylar[alan.id] = List<String>.from(seciliListe); _altCevaplariTemizle(alan.id, hamSorular); }); _secimYapildi(); }); }).toList())));
        default: return const SizedBox.shrink();
      }
    }
    final gorunurSorular = hamSorular.where((s) => _alanGorunurMu(s)).toList();
    return _buildGlassCard("İLAN DETAYLARI", [Column(children: gorunurSorular.map((s) => soruWidgetOlustur(s)).toList())]);
  }

  Widget _buildResimSorguAlani() => _buildGlassCard("İLAN RESİMLERİ", [const Text("Resim eklemek ister misiniz?", style: TextStyle(color: Colors.white)), const SizedBox(height: 10), Row(children: [Expanded(child: RadioListTile(title: const Text("Evet", style: TextStyle(color: Colors.white)), value: true, groupValue: _resimEklemeIstiyor, activeColor: const Color(0xFF2DB34A), onChanged: (v) => setState(() => _resimEklemeIstiyor = v!))), Expanded(child: RadioListTile(title: const Text("Hayır", style: TextStyle(color: Colors.white)), value: false, groupValue: _resimEklemeIstiyor, activeColor: const Color(0xFF2DB34A), onChanged: (v) => setState(() => _resimEklemeIstiyor = v!)))]), if (_resimEklemeIstiyor) ...[const SizedBox(height: 10), IsResimleri(key: ValueKey(_resimEklemeIstiyor), onResimYuklendi: (urls) => setState(() => _resimUrlListesi = urls))]]);
  Widget _buildMusteriNotuInput() => _buildGlassCard("EK NOTLAR", [TextField(controller: _notController, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: InputDecoration(border: InputBorder.none, hintText: "Ek detay yazın...", hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)))), const SizedBox(height: 15), _buildHesaplaButonu()]);
  Widget _buildHesaplaButonu() { final formTamam = _tumGorunurZorunluAlanlarSecildiMi() && _secilenIl != null && _secilenIlce != null; return SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: formTamam ? const Color(0xFF2DB34A) : Colors.white10, padding: const EdgeInsets.symmetric(vertical: 15)), onPressed: formTamam ? () => _fiyatHesapla() : null, child: Text(formTamam ? "FİYATI HESAPLA" : "TÜM ALANLARI DOLDURUN", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))); }

  Widget _buildFiyatCard() {
    final gosterilmeyecek = _guncelFiyat.contains("DOLDURUNUZ") || _guncelFiyat.contains("YENİDEN");
    if (_isCalculating) return Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)), child: const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))));
    if (gosterilmeyecek) return Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)), child: Text(_guncelFiyat, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center));
    return Column(
      children: [
        Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20), decoration: BoxDecoration(color: const Color(0xFF2DB34A).withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF2DB34A).withOpacity(0.4))), child: Column(children: [const Text("TAHMİNİ BÜTÇE", style: TextStyle(color: Color(0xFF2DB34A), fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 10), Text(_fiyatAraligi, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900), textAlign: TextAlign.center)])),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Bu tutar, yapay zekâ destekli analiz sonucunda oluşturulmuş tahmini maliyet aralığıdır; bilgilendirme amaçlıdır ve kesin teklif niteliği taşımaz.",
            style: TextStyle(color: Colors.white.withOpacity(0.70), fontSize: 12, height: 1.4, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(String t, List<Widget> c) => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(color: Color(0xFF2DB34A), fontSize: 13, fontWeight: FontWeight.bold)), const SizedBox(height: 12), ...c]));
  Widget _buildFeedbackAlani() => Padding(padding: const EdgeInsets.only(top: 20), child: _buildGlassCard("FİYAT GERİ BİLDİRİMİ", [Wrap(spacing: 8, children: ["Fiyat uygun", "Fiyat çok yüksek"].map((g) { final s = _secilenGeriBildirim == g; return GestureDetector(onTap: () => setState(() => _secilenGeriBildirim = g), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: s ? const Color(0xFF2DB34A) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: Text(g, style: TextStyle(color: s ? Colors.white : Colors.white70, fontSize: 13)))); }).toList())]));

  Widget _buildYasalUyariVeOnay() => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: _kullanimKosullariOnaylandi, activeColor: const Color(0xFF2DB34A), onChanged: (v) => setState(() => _kullanimKosullariOnaylandi = v ?? false)),
        const SizedBox(width: 4),
        Expanded(
          child: GestureDetector(
            onTap: _kullanimKosullariGoster,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white.withOpacity(0.80), fontSize: 12.5, height: 1.4),
                  children: [
                    const TextSpan(text: "Tahmini maliyet bilgilendirmesini "),
                    TextSpan(
                      text: "okudum ve anladım.",
                      style: const TextStyle(color: Color(0xFFE53935), decoration: TextDecoration.underline, decorationColor: Color(0xFFE53935), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildActionButtons() { final yayinlanabilir = _fiyatHesaplandi && !_isCalculating && !_guncelFiyat.contains("HATASI") && _kullanimKosullariOnaylandi; return Column(children: [Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 10), child: ElevatedButton(onPressed: !yayinlanabilir ? null : () => _baslatYayinlamaMotoru(), style: ElevatedButton.styleFrom(backgroundColor: yayinlanabilir ? const Color(0xFF2DB34A) : Colors.white10, minimumSize: const Size(double.infinity, 60)), child: Text(!yayinlanabilir && _fiyatHesaplandi && !_kullanimKosullariOnaylandi ? "KOŞULLARI ONAYLAYIN" : yayinlanabilir ? "İLANIMI YAYINLA" : "ÖNCE FİYATI HESAPLA", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))))]); }

  // === REVİZE EDİLDİ - BÜTÇE PARAMETRELERİ EKLENDİ ===
  Future<void> _baslatYayinlamaMotoru() async {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))));
    try {
      final fiyatMetni = _fiyatAraligi.isNotEmpty ? _fiyatAraligi : _guncelFiyat;
      await IlanYayinlamaMotoru.ilanYayinla(
          context: context,
          ilan: widget.ilan,
          detaylar: _secilenDetaylar,
          resimler: _resimUrlListesi,
          notlar: _notController.text,
          fiyatBilgisi: fiyatMetni,
          minimumButce: _minButce,
          maksimumButce: _maxButce,
          muhtemelButce: _muhtemelButce,
          secilenIl: _secilenIl!,
          secilenIlce: _secilenIlce!,
          secilenIlId: _secilenIlId!,
          secilenIlceId: _secilenIlceId!,
          secilenGeriBildirim: _secilenGeriBildirim,
          ozelFiyatGoster: false,
          fiyatDuzenleMetin: _anketFiyatController.text,
          lat: _lat,
          lng: _lng,
          onResult: (t, c) {
            Navigator.pop(context);
            showDialog(context: context, builder: (context) => AlertDialog(backgroundColor: const Color(0xFF203A43), title: Text(t, style: const TextStyle(color: Colors.white)), content: Text(c, style: const TextStyle(color: Colors.white70)), actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/musteri_profil'); }, child: const Text("Tamam", style: TextStyle(color: Color(0xFF2DB34A))))]));
          }
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.redAccent));
      }
    }
  }
}