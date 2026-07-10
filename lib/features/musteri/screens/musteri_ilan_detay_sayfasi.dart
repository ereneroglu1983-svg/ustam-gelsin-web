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
import 'package:ustam_gelsin/features/musteri/screens/is_resimleri.dart';

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

  // ==================== RESİM EKLEME DEĞİŞKENLERİ ====================
  bool _resimEklemeIstiyor = false;
  List<String> _resimUrlListesi = [];
  // =================================================================

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
      setState(() {
        _sehirListesi = sehirler;
      });
      await _otomatikKonumAl();
    } catch (e) {
      debugPrint("Konum hazırlama hatası: $e");
    } finally {
      if (mounted) setState(() => _konumYukleniyor = false);
    }
  }

  Future<void> _otomatikKonumAl() async {
    final sonuc = await LocationService.otomatikKonumTespitEt();
    if (sonuc!= null && mounted) {
      setState(() {
        _secilenIl = sonuc['sehir_adi'];
        _secilenIlId = sonuc['sehir_id'];
        _secilenIlce = sonuc['ilce_adi'];
        _secilenIlceId = sonuc['ilce_id'];
        _lat = (sonuc['latitude']?? 0.0).toDouble();
        _lng = (sonuc['longitude']?? 0.0).toDouble();

        if (_secilenIl!= null) {
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
    _notController.dispose();
    _fiyatDuzenleController.dispose();
    super.dispose();
  }

  bool _alanGorunurMu(Map<String, dynamic> alanHamVerisi) {
    final dynamic dependsOnId = alanHamVerisi['dependsOnId'];
    final dynamic dependsOnValueRaw = alanHamVerisi['dependsOnValue'];

    if (dependsOnId == null) return true;
    if (dependsOnValueRaw == null) return false;
    final List<dynamic> dependsOnValueList = dependsOnValueRaw is List? dependsOnValueRaw : [dependsOnValueRaw];
    if (dependsOnValueList.isEmpty) return false;

    final ustAlanDegeri = _secilenDetaylar[dependsOnId.toString()];
    if (ustAlanDegeri == null) return false;

    final List<String> beklenenOrijinaller = dependsOnValueList.map((v) => v.toString().toLowerCase().trim()).toList();

    if (ustAlanDegeri is List) {
      final List<String> secilenOrijinaller = ustAlanDegeri.map((e) => e.toString().toLowerCase().trim()).toList();
      return beklenenOrijinaller.any((v) => secilenOrijinaller.contains(v));
    } else {
      final String secilenOrijinal = ustAlanDegeri.toString().toLowerCase().trim();
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
        final bool isRequired = x['required']?? false;
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
      if (mounted) setState(() { _guncelFiyat = "HESAPLAMA HATASI"; _isCalculating = false; });
    }
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
        child: _konumYukleniyor? const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))) : SafeArea(
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
                      if (!_isCalculating &&!_guncelFiyat.contains("DOLDURUNUZ") &&!_guncelFiyat.contains("HATASI")) _buildFeedbackAlani(),
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
        value: items.contains(seciliDeger)? seciliDeger : null,
        isExpanded: true,
        hint: Text(hint, style: const TextStyle(color: Colors.white54, fontSize: 14)),
        dropdownColor: const Color(0xFF203A43),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        items: items
            .map((s) => DropdownMenuItem(
          value: s,
          child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildKonumSeciciCard() {
    return _buildGlassCard("HİZMET YERİ", [
      _buildDropdown(
          _secilenIl,
          "İl Seçiniz",
          _sehirListesi.map((s) => s['sehir_adi'].toString()).toList(),
              (val) async {
            if (val == null) return;
            var sObj = _sehirListesi.firstWhere((s) => s['sehir_adi'].toString() == val);
            final coords = await LocationService.getSehirKoordinat(val);
            setState(() {
              _secilenIl = val;
              _secilenIlId = sObj['sehir_id'].toString();
              _secilenIlce = null;
              _secilenIlceId = null;
              _filtrelenmisIlceler = [];
              _lat = coords['lat']?? 0.0;
              _lng = coords['lng']?? 0.0;
            });
            _ilceFiltrele(val);
          }
      ),
      const SizedBox(height: 12),
      _buildDropdown(
          _secilenIlce,
          "İlçe Seçiniz",
          _filtrelenmisIlceler.map((i) => i['ad']!).toList(),
              (val) async {
            if (val == null) return;
            var iObj = _filtrelenmisIlceler.firstWhere((i) => i['ad'] == val);
            final coords = await LocationService.getIlceKoordinat(val, _secilenIl!);
            setState(() {
              _secilenIlce = val;
              _secilenIlceId = iObj['id'];
              _lat = coords['lat']?? _lat;
              _lng = coords['lng']?? _lng;
            });
          }
      ),
    ]);
  }

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
                          value: alan.options.contains(_secilenDetaylar[alan.id])? _secilenDetaylar[alan.id] : null,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF203A43),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
                          items: alan.options.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white)))).toList(),
                          onChanged: (val) {
                            if (val!= null) {
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
                final List<String> segmentSecenekleri = (x['options']!= null)? List<String>.from(x['options']) : ["Standart Ölçü", "Orta Ölçü", "Büyük Ölçü"];
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
                                  minWidth: (constraints.maxWidth - 8) / segmentSecenekleri.length.clamp(1, 4)),
                              isSelected: segmentSecenekleri.map((e) => e == seciliDeger).toList(),
                              renderBorder: false,
                              children: segmentSecenekleri.map((String opt) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                final List<String> seciliListe = List<String>.from(_secilenDetaylar[alan.id]?? []);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(15)),
                    child: ExpansionTile(
                      title: Text(alan.label, style: const TextStyle(color: Colors.white)),
                      iconColor: Colors.white70,
                      collapsedIconColor: Colors.white70,
                      children: alan.options.map((String secenek) {
                        return CheckboxListTile(
                          title: Text(secenek, style: const TextStyle(color: Colors.white70)),
                          value: seciliListe.contains(secenek),
                          activeColor: const Color(0xFF2DB34A),
                          onChanged: (bool? s) {
                            setState(() {
                              if (s == true) {
                                seciliListe.add(secenek);
                              } else {
                                seciliListe.remove(secenek);
                              }
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

  Widget _buildResimSorguAlani() {
    return _buildGlassCard("İLAN RESİMLERİ", [
      const Text("İlanınızla ilgili resim eklemek ister misiniz?", style: TextStyle(color: Colors.white)),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: RadioListTile(
              title: const Text("Evet", style: TextStyle(color: Colors.white)),
              value: true,
              groupValue: _resimEklemeIstiyor,
              activeColor: const Color(0xFF2DB34A),
              onChanged: (v) => setState(() => _resimEklemeIstiyor = v!)
          )),
          Expanded(child: RadioListTile(
              title: const Text("Hayır", style: TextStyle(color: Colors.white)),
              value: false,
              groupValue: _resimEklemeIstiyor,
              activeColor: const Color(0xFF2DB34A),
              onChanged: (v) => setState(() => _resimEklemeIstiyor = v!)
          )),
        ],
      ),
      if (_resimEklemeIstiyor)...[
        const SizedBox(height: 10),
        IsResimleri(onResimYuklendi: (urls) => setState(() => _resimUrlListesi = urls)),
      ]
    ]);
  }

  Widget _buildMusteriNotuInput() => _buildGlassCard("EK NOTLAR", [
    TextField(
        controller: _notController,
        maxLines: 3,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Varsa eklemek istediğiniz detayları yazın...",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3))
        )
    ),
    const SizedBox(height: 15),
    _buildHesaplaButonu(),
  ]);

  Widget _buildHesaplaButonu() {
    final bool formTamam = _tumGorunurZorunluAlanlarSecildiMi() && _secilenIl!= null && _secilenIlce!= null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: formTamam? const Color(0xFF2DB34A) : Colors.white10,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: formTamam? () => _fiyatHesapla() : null,
        child: Text(formTamam? "FİYATI HESAPLA" : "TÜM ALANLARI DOLDURUN",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFiyatCard() {
    final bool alanlarEksik = _guncelFiyat.contains("DOLDURUNUZ") || _guncelFiyat.contains("HATASI");
    return Column(children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
        child: _isCalculating? const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))) : Text(
            alanlarEksik? _guncelFiyat : _priceManager.formatFiyatGosterim(_guncelFiyat),
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center
        ),
      ),
    ]);
  }

  Widget _buildGlassCard(String title, List<Widget> children) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Color(0xFF2DB34A), fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...children
      ])
  );

  Widget _buildFeedbackAlani() {
    final List<String> geriBildirimler = [
      "Fiyat çok yüksek",
      "Fiyat uygun",
      "Fiyat düşük geldi",
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: _buildGlassCard("FİYAT GERİ BİLDİRİMİ", [
        const Text(
          "Hesaplanan fiyat hakkında ne düşünüyorsun?",
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: geriBildirimler.map((geriBildirim) {
            final bool secili = _secilenGeriBildirim == geriBildirim;
            return GestureDetector(
              onTap: () => setState(() => _secilenGeriBildirim = geriBildirim),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: secili? const Color(0xFF2DB34A) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: secili? const Color(0xFF2DB34A) : Colors.white10,
                  ),
                ),
                child: Text(
                  geriBildirim,
                  style: TextStyle(
                    color: secili? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight: secili? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: _ozelFiyatGoster,
              activeColor: const Color(0xFF2DB34A),
              onChanged: (val) => setState(() {
                _ozelFiyatGoster = val?? false;
                if (!_ozelFiyatGoster) _fiyatDuzenleController.clear();
              }),
            ),
            const Expanded(
              child: Text(
                "Fiyatı kendim belirlemek istiyorum",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ],
        ),
        if (_ozelFiyatGoster)...[
          const SizedBox(height: 8),
          TextField(
            controller: _fiyatDuzenleController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: "Teklif fiyatını gir",
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              suffixText: "₺",
              suffixStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ]
      ]),
    );
  }

  Widget _buildActionButtons() {
    final bool alanlarEksik = _guncelFiyat.contains("DOLDURUNUZ") || _guncelFiyat.contains("HATASI");
    final bool formTamamlandi =!alanlarEksik &&!_isCalculating;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ElevatedButton(
            onPressed:!formTamamlandi? null : () async {
              final double tahminEdilen = PriceCalculationManager.fiyatTemizle(_guncelFiyat);
              bool anomaliVar = false;

              if (_ozelFiyatGoster && _fiyatDuzenleController.text.isNotEmpty) {
                final String temizMetin = _fiyatDuzenleController.text.replaceAll(RegExp(r'[^\d]'), '');
                if (temizMetin.isNotEmpty) {
                  final double kullaniciGirdisi = double.parse(temizMetin);
                  final double altSinir = tahminEdilen * 0.70;
                  final double ustSinir = tahminEdilen * 1.30;
                  if (kullaniciGirdisi < altSinir || kullaniciGirdisi > ustSinir) {
                    anomaliVar = true;
                  }
                }
              }

              if (anomaliVar) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF203A43),
                    title: const Text("Fiyat Dikkat Çekiyor", style: TextStyle(color: Colors.white)),
                    content: const Text("Girdiğiniz fiyat piyasa ortalamasının dışında görünüyor. Yine de bu fiyatla devam etmek istiyor musunuz?", style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Düzenle", style: TextStyle(color: Color(0xFF2DB34A)))),
                      TextButton(onPressed: () { Navigator.pop(context); _baslatYayinlamaMotoru(); }, child: const Text("Devam Et", style: TextStyle(color: Color(0xFF2DB34A)))),
                    ],
                  ),
                );
              } else {
                _baslatYayinlamaMotoru();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: formTamamlandi? const Color(0xFF2DB34A) : Colors.white10,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            child: const Text("İLANIMI YAYINLA", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: Text("hemenustamgelsin@gmail.com", style: TextStyle(color: Colors.white30, fontSize: 12)),
        ),
      ],
    );
  }

  // ==================== REVİZE: ESKİ SİSTEM UYUMLU ====================
  Future<void> _baslatYayinlamaMotoru() async {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFF2DB34A))));

    try {
      // ESKİ SİSTEM: Fiyat direkt String
      String fiyatMetni;

      if (_ozelFiyatGoster && _fiyatDuzenleController.text.isNotEmpty) {
        final String temizMetin = _fiyatDuzenleController.text.replaceAll(RegExp(r'[^\d]'), '');
        if (temizMetin.isNotEmpty) {
          final int tutar = int.parse(temizMetin);
          final formatter = NumberFormat("#,###", "tr_TR");
          fiyatMetni = "${formatter.format(tutar).replaceAll(',', '.')} ₺";
        } else {
          fiyatMetni = _guncelFiyat;
        }
      } else {
        fiyatMetni = _guncelFiyat;
      }

      await IlanYayinlamaMotoru.ilanYayinla(
        context: context,
        ilan: widget.ilan,
        detaylar: _secilenDetaylar,
        resimler: _resimUrlListesi,
        notlar: _notController.text,
        fiyatBilgisi: fiyatMetni, // Map yerine String
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
              backgroundColor: const Color(0xFF203A43),
              title: Text(title, style: const TextStyle(color: Colors.white)),
              content: Text(content, style: const TextStyle(color: Colors.white70)),
              actions: [TextButton(onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/musteri_profil');
              }, child: const Text("Tamam", style: TextStyle(color: Color(0xFF2DB34A))))],
            ),
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Hata oluştu: $e"),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }
// =====================================================================
}