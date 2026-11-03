// lib/features/hug_pro/pro_bul/pro_bul_screen.dart
// HUG PRO - PROFESYONEL BUL v2.1 CANONICAL LOCK - HUGAI ONLY + FOTO UPLOAD
// FULL ONTOLOJİ ACCORDION (12 ANA DAL, TÜM ALT DALLAR ÇOK SEÇMELİ, DİĞER YOK)
// TEK YAPI TÜRÜ + DİNAMİK JSON + HUGAI PER-MESLEK BREAKDOWN - %4 GİZLİ KASA
// - GROK markası YOK, sadece HUGAI
// - Sadece seçili meslekler fiyatlanır, fatura şişmez
// - Müşteri erişim ücreti GÖRMEZ, sadece pro görür
// - Makas %30 kilitli, fiyatlar 2025-2026 TR gerçekçi
// - FIX v2.1: FOTO UPLOAD EKLENDİ

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../hug_ontoloji.dart' as master;
import 'pro_bul_orkestra.dart';
import 'pro_bul_hugai_provider.dart';
import '../profil/pro_profil_kartlari_listesi.dart';

const _black = Color(0xFF0B0B0B);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

class ProBulScreen extends StatefulWidget {
  const ProBulScreen({super.key});
  @override
  State<ProBulScreen> createState() => _ProBulScreenState();
}

class _ProBulScreenState extends State<ProBulScreen> {
  final PageController _pageCtrl = PageController();
  int _step = 0;
  final Set<String> _secilenAltDalIds = {};
  final Set<String> _expandedAnaDalIds = {};
  String? _yapiTuruId;
  Map<String, String> _olcek = {};
  Map<String, dynamic>? _secilenSablon;
  List<Map<String, dynamic>> _dinamikAlanlar = [];
  Map<String, dynamic> _detaylar = {};
  bool _sablonYukleniyor = false;
  String? _sablonHata;
  final TextEditingController _aciklamaCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _fotolar = [];
  String _il = 'Manisa';
  String _ilce = 'Salihli';
  Map<String, dynamic>? _valuation;
  String? _kaynak;
  bool _fiyatHesaplaniyor = false;
  String? _fiyatHata;
  bool _kaydediliyor = false;

  String _getDosyaAdi(String yapiTuruId) {
    if (yapiTuruId.startsWith('KONUT_') || yapiTuruId == 'KONUT') return 'konut.json';
    if (yapiTuruId.startsWith('TICARI_') || yapiTuruId == 'TICARI') return 'ticari.json';
    if (yapiTuruId.startsWith('ENDUSTRIYEL_') || yapiTuruId == 'ENDUSTRIYEL') return 'endustriyel.json';
    if (yapiTuruId.startsWith('KAMU_') || yapiTuruId == 'KAMU') return 'kamu.json';
    if (yapiTuruId.startsWith('ALTYAPI_') || yapiTuruId == 'ALTYAPI') return 'altyapi.json';
    if (yapiTuruId.startsWith('ENERJI_') || yapiTuruId == 'ENERJI') return 'enerji.json';
    if (yapiTuruId.startsWith('SU_') || yapiTuruId == 'SU') return 'su.json';
    if (yapiTuruId.startsWith('SISTEM_') || yapiTuruId == 'SISTEM') return 'sistem.json';
    return 'konut.json';
  }

  Future<void> _loadSablon(String yapiTuruId) async {
    setState(() {
      _sablonYukleniyor = true;
      _sablonHata = null;
      _dinamikAlanlar = [];
      _detaylar = {};
    });
    try {
      final dosyaAdi = _getDosyaAdi(yapiTuruId);
      final jsonStr = await rootBundle.loadString('assets/hug_pro/$dosyaAdi');
      final Map<String, dynamic> tum = jsonDecode(jsonStr);
      final sablon = tum[yapiTuruId];
      if (sablon == null) throw Exception('Şablon yok: $yapiTuruId - $dosyaAdi');
      setState(() {
        _secilenSablon = Map<String, dynamic>.from(sablon);
        _dinamikAlanlar = List<Map<String, dynamic>>.from(sablon['alanlar'].map((e) => Map<String, dynamic>.from(e)));
        _sablonYukleniyor = false;
      });
    } catch (e) {
      setState(() {
        _sablonHata = e.toString();
        _sablonYukleniyor = false;
      });
    }
  }

  List<master.YapiTuru> _getFilteredYapiTurleri() {
    if (_secilenAltDalIds.isEmpty) {
      return master.YapiTurleriMaster.tumYapiTurleri.where((e) => e.parentId == null).toList();
    }
    final Set<String> onerilenIds = {};
    for (final ana in master.HugProMasterOntologyV5.anaDallar) {
      for (final alt in ana.altDallar) {
        if (_secilenAltDalIds.contains(alt.id)) {
          onerilenIds.addAll(alt.onerilenYapiTuruIds);
        }
      }
    }
    if (onerilenIds.isEmpty) return master.YapiTurleriMaster.tumYapiTurleri;
    return master.YapiTurleriMaster.tumYapiTurleri.where((e) => onerilenIds.contains(e.id)).toList();
  }

  Future<void> _tahminiFiyatGoster() async {
    if (_yapiTuruId == null || _aciklamaCtrl.text.trim().length < 10 || _secilenAltDalIds.isEmpty) return;
    setState(() {
      _fiyatHesaplaniyor = true;
      _fiyatHata = null;
    });
    try {
      final sonuc = await ProBulOrkestra.silsileYurut(
        yapiTuru: _yapiTuruId!,
        ihtiyacIds: _secilenAltDalIds.toList(),
        detaylar: {
          ..._detaylar,
          'olcek': _olcek,
          'aciklama': _aciklamaCtrl.text.trim(),
          'sablonBaslik': _secilenSablon?['baslik'],
          'sablonId': _yapiTuruId,
        },
        il: _il,
        ilce: _ilce,
      );
      if (mounted) {
        setState(() {
          _valuation = sonuc;
          _kaynak = (sonuc['kaynak'] ?? 'HUGAI').toString();
          _fiyatHesaplaniyor = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fiyatHata = e.toString();
          _fiyatHesaplaniyor = false;
        });
      }
    }
  }

  Future<void> _profesyonellereGozAt() async {
    if (_valuation == null) return;
    setState(() => _kaydediliyor = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Giriş yap');
      final fs = FirebaseFirestore.instance;
      final totalAccess = (_valuation?['total']?['hug_access_total_tl'] ?? _valuation?['total']?['hug_access_fee_total_tl'] ?? 0);
      final tempRef = fs.collection('hug_pro_ozel_davetler').doc();
      final davetId = tempRef.id;
      final List<String> fotoUrls = [];
      if (_fotolar.isNotEmpty) {
        for (int i = 0; i < _fotolar.length; i++) {
          final foto = _fotolar[i];
          try {
            final bytes = await foto.readAsBytes();
            final storageRef = FirebaseStorage.instance.ref().child('hug_pro_direkt').child(davetId).child('foto_$i.jpg');
            final uploadTask = await storageRef.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
            final url = await uploadTask.ref.getDownloadURL();
            fotoUrls.add(url);
          } catch (e) {
            print("❌ Foto yükleme hatası $i: $e");
          }
        }
      }
      await tempRef.set({
        'davetId': davetId,
        'musteriId': user.uid,
        'secilenAltDalIds': _secilenAltDalIds.toList(),
        'ihtiyacIds': _secilenAltDalIds.toList(),
        'yapiTuruId': _yapiTuruId,
        'olcek': _olcek,
        'detaylar': _detaylar,
        'aciklama': _aciklamaCtrl.text.trim(),
        'il': _il,
        'ilce': _ilce,
        'sablonBaslik': _secilenSablon?['baslik'],
        'valuation': _valuation,
        'fotoUrls': fotoUrls,
        'kaynak': _kaynak ?? 'HUGAI',
        'durum': 'AKTIF',
        'davetEdilenProIds': [],
        'olusturmaTarihi': FieldValue.serverTimestamp(),
        'toplamErisimUcreti': totalAccess,
      });
      if (!mounted) return;
      setState(() => _kaydediliyor = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProProfilKartlariListesiScreen(
            ihtiyacIds: _secilenAltDalIds.toList(),
            davetId: davetId,
            valuation: _valuation,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _kaydediliyor = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  void dispose() {
    _aciklamaCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _offWhite,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _progress(),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _stepMeslekSecimi(),
                  _stepYapiTuru(),
                  _stepOlcek(),
                  _stepDetay(),
                  _stepFiyat(),
                ],
              ),
            ),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      color: _black,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('H U G', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 6, fontWeight: FontWeight.w300)),
              const SizedBox(height: 4),
              Text('P R O  B U L  0${_step + 1} / 05', style: const TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.w300)),
            ],
          ),
          const Spacer(),
          Text('${_secilenAltDalIds.length} MESLEK', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _progress() {
    return Container(
      color: _black,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: List.generate(5, (i) {
          return Expanded(
            child: Container(height: 1, margin: EdgeInsets.only(right: i == 4 ? 0 : 8), color: i <= _step ? _gold : Colors.white10),
          );
        }),
      ),
    );
  }

  Widget _stepMeslekSecimi() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), const Text('PROJE İHTİYACINIZI BELİRLEYİN', style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
          const SizedBox(height: 20),
          const Text('Hangi profesyoneller lazım?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
          const SizedBox(height: 8),
          const SizedBox(height: 24),
          ...master.HugProMasterOntologyV5.anaDallar.map((ana) => _anaDalCard(ana)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            color: _black,
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: _gold, size: 14),
                const SizedBox(width: 8),
                Expanded(child: Text('${_secilenAltDalIds.length} alt dal seçili: ${_secilenAltDalIds.join(', ')}', style: const TextStyle(color: Colors.white54, fontSize: 10))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _anaDalCard(master.AnaDal ana) {
    final expanded = _expandedAnaDalIds.contains(ana.id);
    final seciliCount = ana.altDallar.where((alt) => _secilenAltDalIds.contains(alt.id)).length;
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (expanded) _expandedAnaDalIds.remove(ana.id);
                else _expandedAnaDalIds.add(ana.id);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              color: _black,
              child: Row(
                children: [
                  Container(width: 24, height: 1, color: _gold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ana.ad, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        const SizedBox(height: 2),
                        Text('${ana.id} • ${ana.altDallar.length} alt dal', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 8, letterSpacing: 1)),
                      ],
                    ),
                  ),
                  if (seciliCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: _gold,
                      child: Text('$seciliCount SEÇİLİ', style: const TextStyle(color: _black, fontSize: 7, fontWeight: FontWeight.bold)),
                    ),
                  const SizedBox(width: 8),
                  Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
                ],
              ),
            ),
          ),
          if (expanded) ...ana.altDallar.map((alt) => _altDalCard(alt)),
        ],
      ),
    );
  }

  Widget _altDalCard(master.AltDal alt) {
    final selected = _secilenAltDalIds.contains(alt.id);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) _secilenAltDalIds.remove(alt.id);
          else _secilenAltDalIds.add(alt.id);
          _valuation = null;
          _fiyatHata = null;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.all(14),
        color: selected ? Colors.white : const Color(0xFFFCFBF9),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(border: Border.all(color: selected ? _gold : Colors.black26), color: selected ? _gold : Colors.transparent),
              child: selected ? const Icon(Icons.check, size: 12, color: Colors.black) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alt.ad, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.bold : FontWeight.w600, color: _black)),
                  const SizedBox(height: 2),
                  Text('${alt.unvanIds.join(', ')} • ${alt.id}', style: const TextStyle(fontSize: 8, color: _gray, letterSpacing: 0.5)),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: selected ? _gold.withOpacity(0.5) : const Color(0xFFD6D6D6), width: 0.8)),
              child: Icon(Icons.arrow_outward, size: 11, color: selected ? _gold : const Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepYapiTuru() {
    final turler = _getFilteredYapiTurleri();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), Text('${_secilenAltDalIds.length} MESLEK İÇİN YAPI TÜRÜ', style: const TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
          const SizedBox(height: 20),
          const Text('Yapı Türünü Seç', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${turler.length} tür filtrelendi', style: const TextStyle(fontSize: 11, color: _gray)),
          const SizedBox(height: 24),
          ...turler.map((t) => _yapiCard(t)),
        ],
      ),
    );
  }

  Widget _yapiCard(master.YapiTuru t) {
    final selected = _yapiTuruId == t.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _yapiTuruId = t.id;
          _valuation = null;
          _fiyatHata = null;
        });
        _loadSablon(t.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        color: selected ? Colors.white : const Color(0xFFFCFBF9),
        child: Row(
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: selected ? _gold : Colors.black12, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Expanded(child: Text(t.displayName, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.bold : FontWeight.w500))),
            if (selected) const Icon(Icons.check, size: 14, color: _gold),
          ],
        ),
      ),
    );
  }

  Widget _stepOlcek() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), const Text('ÖLÇEK NEDİR?', style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
          const SizedBox(height: 20),
          const Text('Ölçeği Gir', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _olcekField('Arsa Alanı', 'm²', 'arsa'),
          _olcekField('Yapı Alanı', 'm²', 'yapi'),
          _olcekField('Kat Sayısı', 'kat', 'kat'),
          if (_yapiTuruId == 'ENERJI_GES') _olcekField('Kurulu Güç', 'kWp', 'guc'),
        ],
      ),
    );
  }

  Widget _olcekField(String label, String suffix, String key) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      color: _black,
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white))),
          SizedBox(
            width: 120,
            child: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: InputDecoration(hintText: '0', hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)), suffixText: suffix, suffixStyle: const TextStyle(color: _gold, fontSize: 11, fontWeight: FontWeight.bold), border: InputBorder.none, isDense: true),
              onChanged: (v) {
                setState(() {
                  _olcek[key] = v;
                  _valuation = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepDetay() {
    if (_yapiTuruId == null) return const Center(child: Text('Önce yapı türü seç', style: TextStyle(color: _gray)));
    if (_sablonYukleniyor) return const Center(child: CircularProgressIndicator(color: _gold));
    if (_sablonHata != null) return Center(child: Text('Hata: $_sablonHata', style: const TextStyle(color: Colors.red, fontSize: 11)));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), Text('${_secilenSablon?['baslik'] ?? _yapiTuruId} DETAY', style: const TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
          const SizedBox(height: 20),
          ..._dinamikAlanlar.map((alan) => _buildDinamikField(alan)),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            color: _black,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PROJE DETAYI', style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 2)),
                const SizedBox(height: 12),
                TextField(
                  controller: _aciklamaCtrl,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                  decoration: InputDecoration(hintText: 'Detaylı açıklama yaz...', hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11), border: InputBorder.none),
                  onChanged: (_) => setState(() => _valuation = null),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _fotoGrid(),
        ],
      ),
    );
  }

  Widget _buildDinamikField(Map<String, dynamic> alan) {
    final id = alan['id'] as String;
    final label = alan['label'] as String;
    final tip = alan['tip'] as String;
    final zorunlu = alan['zorunlu'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _black))), if (zorunlu) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), color: _gold, child: const Text('ZORUNLU', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: _black)))]),
          const SizedBox(height: 12),
          if (tip == 'select') _buildSelectField(alan),
          if (tip == 'number') _buildNumberField(alan),
          if (tip == 'text') _buildTextField(alan),
          if (tip == 'multi_select') _buildMultiSelectField(alan),
        ],
      ),
    );
  }

  Widget _buildSelectField(Map<String, dynamic> alan) {
    final id = alan['id'] as String;
    final secenekler = List<String>.from(alan['secenekler'] ?? []);
    return DropdownButtonFormField<String>(
      value: _detaylar[id],
      dropdownColor: Colors.white,
      style: const TextStyle(fontSize: 11, color: _black, fontWeight: FontWeight.w600),
      decoration: InputDecoration(filled: true, fillColor: _offWhite, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(2)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), isDense: true),
      hint: const Text('Seçiniz', style: TextStyle(fontSize: 11, color: _gray)),
      items: secenekler.map((s) => DropdownMenuItem(value: s, child: Text(s.replaceAll('_', ' '), style: const TextStyle(fontSize: 11, color: _black)))).toList(),
      onChanged: (v) => setState(() {
        _detaylar[id] = v;
        _valuation = null;
      }),
    );
  }

  Widget _buildNumberField(Map<String, dynamic> alan) {
    final id = alan['id'] as String;
    return TextFormField(
      initialValue: _detaylar[id]?.toString() ?? '',
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _black),
      decoration: InputDecoration(filled: true, fillColor: _offWhite, hintText: 'Sayı', hintStyle: const TextStyle(fontSize: 10, color: _gray), border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(2)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), isDense: true),
      onChanged: (v) => setState(() {
        _detaylar[id] = v;
        _valuation = null;
      }),
    );
  }

  Widget _buildTextField(Map<String, dynamic> alan) {
    final id = alan['id'] as String;
    return TextFormField(
      initialValue: _detaylar[id]?.toString() ?? '',
      style: const TextStyle(fontSize: 13, color: _black),
      decoration: InputDecoration(filled: true, fillColor: _offWhite, hintText: 'Örn: 4x10m', hintStyle: const TextStyle(fontSize: 10, color: _gray), border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(2)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), isDense: true),
      onChanged: (v) => setState(() {
        _detaylar[id] = v;
        _valuation = null;
      }),
    );
  }

  Widget _buildMultiSelectField(Map<String, dynamic> alan) {
    final id = alan['id'] as String;
    final secenekler = List<String>.from(alan['secenekler'] ?? []);
    final currentValues = List<String>.from(_detaylar[id] ?? []);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: secenekler.map((s) {
        final selected = currentValues.contains(s);
        return GestureDetector(
          onTap: () => setState(() {
            if (selected) currentValues.remove(s);
            else currentValues.add(s);
            _detaylar[id] = currentValues;
            _valuation = null;
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: selected ? _black : _offWhite, border: Border.all(color: selected ? _black : const Color(0xFFD6D6D6))),
            child: Text(s.replaceAll('_', ' '), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: selected ? Colors.white : _black)),
          ),
        );
      }).toList(),
    );
  }

  Widget _fotoGrid() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [const Text('FOTOĞRAFLAR', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray)), const Spacer(), Text('${_fotolar.length}/10', style: const TextStyle(fontSize: 9, color: _gold, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: _fotolar.length + (_fotolar.length < 10 ? 1 : 0),
            itemBuilder: (c, i) {
              if (i == _fotolar.length) {
                return GestureDetector(
                  onTap: () async {
                    final List<XFile> selected = await _picker.pickMultiImage(imageQuality: 80);
                    if (selected.isNotEmpty) setState(() => _fotolar.addAll(selected.take(10 - _fotolar.length)));
                  },
                  child: Container(decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6D6D6), width: 0.8)), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo, size: 20, color: _gray), SizedBox(height: 6), Text('FOTO EKLE', style: TextStyle(fontSize: 7, letterSpacing: 1, color: _gray))])),
                );
              }
              return Stack(
                fit: StackFit.expand,
                children: [
                  FutureBuilder<Uint8List>(future: _fotolar[i].readAsBytes(), builder: (context, snap) => snap.hasData ? Image.memory(snap.data!, fit: BoxFit.cover) : Container(color: _black)),
                  Positioned(top: 4, right: 4, child: GestureDetector(onTap: () => setState(() => _fotolar.removeAt(i)), child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: _black, shape: BoxShape.circle), child: const Icon(Icons.close, size: 12, color: Colors.white)))),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _stepFiyat() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), const Text('HUGAI TAHMİNİ FİYAT', style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
          const SizedBox(height: 20),
          const Text('Teklif Bedelleri', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _black)),
          const SizedBox(height: 8),
          Text('${_secilenAltDalIds.length} meslek için HugAI tahmini fiyat aralığı. Seçtiğiniz meslekler için özel hesaplandı.', style: const TextStyle(fontSize: 11, color: _gray, height: 1.5)),
          const SizedBox(height: 24),
          if (_fiyatHesaplaniyor)
            Container(width: double.infinity, padding: const EdgeInsets.all(32), color: _black, child: const Column(children: [SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 1.5, color: _gold)), SizedBox(height: 12), Text('HUGAI HESAPLIYOR...', style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 2))])),
          if (_fiyatHata != null)
            Container(width: double.infinity, padding: const EdgeInsets.all(16), color: Colors.red.withOpacity(0.08), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('HATA', style: TextStyle(color: Colors.red, fontSize: 8, letterSpacing: 2)), const SizedBox(height: 8), Text(_fiyatHata!, style: const TextStyle(color: Colors.red, fontSize: 10)), const SizedBox(height: 12), GestureDetector(onTap: _tahminiFiyatGoster, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), color: Colors.red, child: const Text('TEKRAR DENE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))))])),
          if (_valuation == null && !_fiyatHesaplaniyor && _fiyatHata == null)
            GestureDetector(
              onTap: _tahminiFiyatGoster,
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16), color: _gold, child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.auto_awesome, size: 14, color: _black), SizedBox(width: 8), Text('HUGAI İLE TAHMİNİ FİYATI GÖR', style: TextStyle(color: _black, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1))])),
            ),
          if (_valuation != null) _buildBreakdownCard(),
          const SizedBox(height: 24),
          if (_valuation != null)
            GestureDetector(
              onTap: _kaydediliyor ? null : _profesyonellereGozAt,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: _black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_kaydediliyor) const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1.5, color: _gold)) else const Icon(Icons.people, size: 14, color: _gold),
                    const SizedBox(width: 8),
                    Text(_kaydediliyor ? 'KAYDEDİLİYOR...' : 'PROFESYONELLERE GÖZ AT', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
    final services = _valuation?['services'] as List? ?? [];
    final total = _valuation?['total'] as Map<String, dynamic>?;
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _black.withOpacity(0.08))),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: _black,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), Text('KAYNAK: ${_kaynak ?? 'HUGAI'}', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 8, letterSpacing: 2))]),
                const SizedBox(height: 12),
                const Text('HUGAI MESLEK BAZLI TAHMİN', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Container(height: 1, width: 14, color: _gold),
              ],
            ),
          ),
          ...services.where((s) => s['status'] == 'estimated').map((svc) {
            final name = (svc['service_name'] ?? svc['service_id'] ?? '').toString().toUpperCase();
            final min = (svc['min_tl'] as num?)?.toInt() ?? 0;
            final est = (svc['estimated_tl'] as num?)?.toInt() ?? 0;
            final max = (svc['max_tl'] as num?)?.toInt() ?? 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0F000000)))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: _black))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${_formatMoney(min)} - ${_formatMoney(max)} TL', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _black)),
                      const SizedBox(width: 8),
                      Text('Ort: ${_formatMoney(est)} TL', style: const TextStyle(fontSize: 10, color: _gray)),
                    ],
                  ),
                ],
              ),
            );
          }),
          if (total != null)
            Container(
              width: double.infinity,
              color: _offWhite,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(children: [const Expanded(child: Text('TOPLAM TAHMİNİ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: _black))), Text('${_formatMoney((total['min_tl'] as num?)?.toInt() ?? 0)} - ${_formatMoney((total['max_tl'] as num?)?.toInt() ?? 0)} TL', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _black))]),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatMoney(int v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)}K'.replaceAll('.0K', 'K');
    return v.toString();
  }

  Widget _bottomNav() {
    final canNext = _canNext();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          if (_step > 0)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _step--);
                  _pageCtrl.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                },
                child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6D6D6), width: 0.8)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.arrow_back, size: 12), SizedBox(width: 6), Text('GERİ', style: TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold))])),
              ),
            ),
          if (_step > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: !canNext || _fiyatHesaplaniyor || _kaydediliyor
                  ? null
                  : () {
                if (_step < 4) {
                  setState(() => _step++);
                  _pageCtrl.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                } else {
                  _profesyonellereGozAt();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                color: !canNext ? const Color(0xFFCCCCCC) : _gold,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_step == 4 ? 'PROFESYONELLERE GÖZ AT' : 'DEVAM ET', style: TextStyle(color: !canNext ? _gray : _black, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(width: 8),
                    Icon(_step == 4 ? Icons.people : Icons.arrow_outward, size: 12, color: !canNext ? _gray : _black),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canNext() {
    switch (_step) {
      case 0:
        return _secilenAltDalIds.isNotEmpty;
      case 1:
        return _yapiTuruId != null;
      case 2:
        return true;
      case 3:
        return _aciklamaCtrl.text.trim().length >= 10;
      case 4:
        return _valuation != null;
      default:
        return false;
    }
  }
}