import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'hug_ontoloji.dart' as master;
import 'hug_proje_olustur.dart' as brief;
import 'hug_proje_service.dart';
import 'hug_pro_tahmini.dart';
import 'package:ustam_gelsin/core/services/hug_pro_orkestra_servisi.dart';

// HOME PAGE İLE AYNI TEMA - KİLİTLİ
const _black = Color(0xFF0B0B0B);
const _dark = Color(0xFF111111);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

class HugProjeOlusturPage extends StatefulWidget {
  const HugProjeOlusturPage({super.key});
  @override
  State<HugProjeOlusturPage> createState() => _HugProjeOlusturPageState();
}

class _HugProjeOlusturPageState extends State<HugProjeOlusturPage> {
  final PageController _pageCtrl = PageController();
  int _step = 0;

  String? _yapiTuruId;
  brief.ProjeAsamasi _asama = brief.ProjeAsamasi.FIKIR;
  Map<String, String> _olcek = {};
  List<String> _ihtiyacIds = [];
  String _il = 'Manisa';
  String _ilce = 'Salihli';

  final TextEditingController _aciklamaCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _fotolar = [];

  // YENİ: DİNAMİK JSON SİSTEMİ
  Map<String, dynamic>? _secilenSablon;
  List<Map<String, dynamic>> _dinamikAlanlar = [];
  Map<String, dynamic> _detaylar = {}; // Grok için kritik detaylar
  bool _sablonYukleniyor = false;
  String? _sablonHata;

  // FIRESTORE ENTEGRASYON
  final _service = HugProjeService();
  bool _kaydediliyor = false;

  // HUG PRO - TAHMİNİ FİYAT SİSTEMİ
  Map<String, dynamic>? _valuation;
  bool _fiyatHesaplaniyor = false;
  String? _fiyatHata;

  // KATEGORİ -> DOSYA HARİTASI
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
      final Map<String, dynamic> tumSablonlar = jsonDecode(jsonStr);
      final sablon = tumSablonlar[yapiTuruId] ?? tumSablonlar[yapiTuruId.replaceAll('_', '')];

      if (sablon == null) {
        // Fallback: genel kategori dene
        final genelId = yapiTuruId.split('_').first;
        final genelSablon = tumSablonlar[genelId];
        if (genelSablon != null) {
          setState(() {
            _secilenSablon = Map<String, dynamic>.from(genelSablon);
            _dinamikAlanlar = List<Map<String, dynamic>>.from(genelSablon['alanlar'].map((e) => Map<String, dynamic>.from(e)));
            _sablonYukleniyor = false;
          });
          return;
        }
        throw Exception('Şablon bulunamadı: $yapiTuruId - $dosyaAdi');
      }

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

  Future<void> _tahminiFiyatGoster() async {
    if (_yapiTuruId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen önce yapı türü seçin')));
      return;
    }
    if (_aciklamaCtrl.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen en az 10 karakter açıklama yazın')));
      return;
    }

    setState(() {
      _fiyatHesaplaniyor = true;
      _fiyatHata = null;
    });

    try {
      final sonuc = await HugProOrkestraServisi.silsileYurut(
        projeId: "preview_${DateTime.now().millisecondsSinceEpoch}",
        yapiTuruId: _yapiTuruId!,
        asama: _asama.name,
        olcek: _olcek,
        detaylar: _detaylar,
        il: _il,
        ilce: _ilce,
        aciklama: _aciklamaCtrl.text.trim(),
        ihtiyacIds: _ihtiyacIds,
        sablonBaslik: _secilenSablon?['baslik'],
      );

      if (mounted) {
        setState(() {
          _valuation = sonuc['valuation'] as Map<String, dynamic>?;
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

  Future<void> _projeyiYayinla() async {
    if (_yapiTuruId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen yapı türü seçin')));
      return;
    }
    if (_aciklamaCtrl.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen en az 10 karakter açıklama yazın')));
      return;
    }
    // FİYAT KONTROLÜ - Fiyat görmeden yayınlama yok
    if (_valuation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen önce TAHMİNİ FİYATI GÖR butonuna basın'), backgroundColor: _black));
      return;
    }
    // Dinamik alanların zorunlularını kontrol et
    for (var alan in _dinamikAlanlar) {
      if (alan['zorunlu'] == true) {
        // Koşullu alanları atla
        if (alan.containsKey('kosul') && alan['kosul'] != null) {
          // Basit koşul kontrolü atlanabilir, şimdilik es geç
          continue;
        }
        if (!_detaylar.containsKey(alan['id']) || _detaylar[alan['id']] == null || _detaylar[alan['id']].toString().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lütfen zorunlu alanı doldurun: ${alan['label']}')));
          return;
        }
      }
    }

    setState(() => _kaydediliyor = true);
    try {
      final id = await _service.createProje(
        yapiTuruId: _yapiTuruId!,
        asama: _asama,
        olcek: _olcek,
        ihtiyacIds: _ihtiyacIds,
        il: _il,
        ilce: _ilce,
        aciklama: _aciklamaCtrl.text.trim(),
        fotolar: _fotolar,
        detaylar: _detaylar, // YENİ: Grok için detaylar
        sablonBaslik: _secilenSablon?['baslik'],
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Proje yayınlandı: $id'), backgroundColor: _black));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _kaydediliyor = false);
    }
  }

  String _formatYapiAdi(String raw) {
    return raw
        .replaceAll('_', ' / ')
        .replaceAll('KONUT / MUSTAKIL', 'KONUT / MÜSTAKİL')
        .replaceAll('TICARI', 'TİCARİ')
        .replaceAll('OFIS', 'OFİS')
        .replaceAll('MAGAZA', 'MAĞAZA')
        .replaceAll('URETIM', 'ÜRETİM')
        .replaceAll('BETONARME', 'BETONARME')
        .replaceAll('CELIK', 'ÇELİK')
        .replaceAll('PREFABRIK', 'PREFABRİK');
  }

  String _formatOlcekBirim(String key) {
    switch (key) {
      case 'arsa': return 'm²';
      case 'yapi': return 'm²';
      case 'kat': return 'kat';
      case 'guc': return 'kWp';
      default: return '';
    }
  }

  String _formatOlcekLabel(String key) {
    switch (key) {
      case 'arsa': return 'ARSA ALANI';
      case 'yapi': return 'YAPI ALANI';
      case 'kat': return 'KAT SAYISI';
      case 'guc': return 'KURULU GÜÇ';
      default: return key.toUpperCase();
    }
  }

  @override
  void dispose() {
    _aciklamaCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFoto() async {
    if (_fotolar.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('En fazla 10 foto ekleyebilirsiniz')));
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: _black,
      builder: (c) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 2, color: Colors.white24),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library, color: _gold),
              title: const Text('Galeriden Seç', style: TextStyle(color: Colors.white)),
              subtitle: Text(kIsWeb ? 'Web: çoklu seçim' : 'Telefondan: galeri', style: const TextStyle(color: Colors.white38, fontSize: 10)),
              onTap: () async {
                Navigator.pop(c);
                final List<XFile> selected = await _picker.pickMultiImage(imageQuality: 80);
                if (selected.isNotEmpty) {
                  setState(() {
                    final kalan = 10 - _fotolar.length;
                    _fotolar.addAll(selected.take(kalan));
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: _gold),
              title: const Text('Kameradan Çek', style: TextStyle(color: Colors.white)),
              subtitle: Text(kIsWeb ? 'Webde kamera varsa' : 'Telefon kamerası', style: const TextStyle(color: Colors.white38, fontSize: 10)),
              onTap: () async {
                Navigator.pop(c);
                final XFile? foto = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                if (foto != null) {
                  setState(() => _fotolar.add(foto));
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
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
                  _stepYapiTuru(),
                  _stepAsama(),
                  _stepOlcek(),
                  _stepDinamikDetay(), // YENİ ADIM
                  _stepIhtiyac(),
                  _stepOzet(),
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('H U G', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 6, fontWeight: FontWeight.w300)),
              SizedBox(height: 4),
              Text('P R O J E  O L U Ş T U R', style: TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.w300)),
            ],
          ),
          const Spacer(),
          Text('0${_step + 1} / 06', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _progress() {
    return Container(
      color: _black,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: List.generate(6, (i) {
          return Expanded(
            child: Container(
              height: 1,
              margin: EdgeInsets.only(right: i == 5 ? 0 : 8),
              color: i <= _step ? _gold : Colors.white10,
            ),
          );
        }),
      ),
    );
  }

  Widget _stepYapiTuru() {
    final turler = brief.ProjeTuruKaynagi.secilebilirTurler;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), const Text('NE İNŞA EDECEKSİNİZ?', style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
          const SizedBox(height: 20),
          const Text('Yapı Türünü Seçin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
          const SizedBox(height: 8),
          const Text('Projene en yakın türü seç, gerisini biz eşleştireceğiz.', style: TextStyle(fontSize: 11, color: _gray, height: 1.5)),
          const SizedBox(height: 24),
          ..._buildKategoriler(turler),
        ],
      ),
    );
  }

  List<Widget> _buildKategoriler(List<master.YapiTuru> turler) {
    final Map<String, List<master.YapiTuru>> grouped = {};
    for (var t in turler) {
      grouped.putIfAbsent(t.kategori, () => []).add(t);
    }
    return grouped.entries.map((e) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(e.key, style: const TextStyle(fontSize: 8, letterSpacing: 2, color: _gray)),
          const SizedBox(height: 8),
          ...e.value.map((t) => _yapiCard(t)),
        ],
      );
    }).toList();
  }

  Widget _yapiCard(master.YapiTuru t) {
    final selected = _yapiTuruId == t.id;
    final display = _formatYapiAdi(t.displayName);
    return GestureDetector(
      onTap: () {
        setState(() {
          _yapiTuruId = t.id;
          _ihtiyacIds = brief.IhtiyacSablonlari.getOnerilenIhtiyaclar(yapiTuruId: t.id, asama: _asama).map((e) => e.id).toList();
          // Fiyat sıfırla - yeni yapı türü seçildi
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
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: selected ? _gold : Colors.black12, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(display, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.bold : FontWeight.w500))),
            if (selected) const Icon(Icons.check, size: 14, color: _gold),
            const SizedBox(width: 8),
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

  Widget _stepAsama() {
    return Container(
      color: _dark,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 10), const Text('HANGİ AŞAMADASINIZ?', style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 2))]),
          const SizedBox(height: 24),
          const Text('Proje Aşaması', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 28),
          ...brief.ProjeAsamasi.values.map((a) => _asamaRow(a)),
        ],
      ),
    );
  }

  Widget _asamaRow(brief.ProjeAsamasi a) {
    final selected = _asama == a;
    return GestureDetector(
      onTap: () {
        setState(() {
          _asama = a;
          if (_yapiTuruId != null) {
            _ihtiyacIds = brief.IhtiyacSablonlari.getOnerilenIhtiyaclar(yapiTuruId: _yapiTuruId!, asama: a).map((e) => e.id).toList();
          }
          _valuation = null;
          _fiyatHata = null;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Column(
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: selected ? _gold : Colors.white24, shape: BoxShape.circle)),
                if (a != brief.ProjeAsamasi.UYGULAMA) Container(width: 1, height: 20, color: Colors.white10, margin: const EdgeInsets.only(top: 6)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('0${a.index + 1}', style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: selected ? _gold : Colors.white30)),
                  const SizedBox(height: 4),
                  Text(a.displayName.toUpperCase(), style: TextStyle(color: selected ? _gold : Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Container(height: 1, color: selected ? _gold.withOpacity(0.3) : Colors.white10),
                ],
              ),
            ),
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
          const Text('Ölçeği Girin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Birimler otomatik eklenecek: m², kat, kWp', style: TextStyle(fontSize: 10, color: _gray)),
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
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                suffixText: suffix,
                suffixStyle: const TextStyle(color: _gold, fontSize: 11, fontWeight: FontWeight.bold),
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (v) {
                setState(() {
                  _olcek[key] = v;
                  _valuation = null;
                  _fiyatHata = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // YENİ: DİNAMİK DETAY ADIMI
  Widget _stepDinamikDetay() {
    if (_yapiTuruId == null) {
      return const Center(child: Text('Önce yapı türü seçin', style: TextStyle(color: _gray)));
    }
    if (_sablonYukleniyor) {
      return const Center(child: CircularProgressIndicator(color: _gold));
    }
    if (_sablonHata != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 32),
              const SizedBox(height: 12),
              Text('Şablon yüklenemedi:\n$_sablonHata', style: const TextStyle(color: Colors.red, fontSize: 11), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => _loadSablon(_yapiTuruId!), child: const Text('Tekrar Dene')),
            ],
          ),
        ),
      );
    }
    if (_dinamikAlanlar.isEmpty) {
      return const Center(child: Text('Bu yapı türü için ek detay yok', style: TextStyle(color: _gray)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 32, height: 1, color: _gold),
            const SizedBox(width: 10),
            Text('${_secilenSablon?['baslik'] ?? _formatYapiAdi(_yapiTuruId!)} DETAYLARI', style: const TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray)),
          ]),
          const SizedBox(height: 20),
          Text(_secilenSablon?['baslik'] ?? 'Detaylar', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Grok maliyet hesabı için nokta atış sorular', style: TextStyle(fontSize: 11, color: _gray, height: 1.5)),
          const SizedBox(height: 24),
          ..._dinamikAlanlar.map((alan) => _buildDinamikField(alan)).toList(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            color: _black,
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: _gold, size: 14),
                const SizedBox(width: 8),
                Expanded(child: Text('${_detaylar.length}/${_dinamikAlanlar.length} detay dolduruldu', style: const TextStyle(color: Colors.white54, fontSize: 10))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDinamikField(Map<String, dynamic> alan) {
    final id = alan['id'] as String;
    final label = alan['label'] as String;
    final tip = alan['tip'] as String;
    final zorunlu = alan['zorunlu'] == true;
    final aciklama = alan['aciklama'] as String?;
    final kosul = alan['kosul'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _black))),
              if (zorunlu) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), color: _gold, child: const Text('ZORUNLU', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, letterSpacing: 1, color: _black))),
            ],
          ),
          if (aciklama != null) ...[
            const SizedBox(height: 4),
            Text(aciklama, style: const TextStyle(fontSize: 9, color: _gray, fontStyle: FontStyle.italic)),
          ],
          if (kosul != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: _offWhite,
              child: Text('Koşul: $kosul', style: const TextStyle(fontSize: 8, color: _gray)),
            ),
          ],
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
    final currentValue = _detaylar[id];

    return DropdownButtonFormField<String>(
      value: currentValue,
      dropdownColor: Colors.white,
      style: const TextStyle(fontSize: 11, color: _black, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        filled: true,
        fillColor: _offWhite,
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
      hint: const Text('Seçiniz', style: TextStyle(fontSize: 11, color: _gray)),
      items: secenekler.map((s) {
        return DropdownMenuItem(value: s, child: Text(s.replaceAll('_', ' '), style: const TextStyle(fontSize: 11, color: _black)));
      }).toList(),
      onChanged: (v) {
        setState(() {
          _detaylar[id] = v;
          _valuation = null;
          _fiyatHata = null;
        });
      },
    );
  }

  Widget _buildNumberField(Map<String, dynamic> alan) {
    final id = alan['id'] as String;
    final min = alan['min'];
    final max = alan['max'];
    final currentValue = _detaylar[id]?.toString() ?? '';

    return TextFormField(
      initialValue: currentValue,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _black),
      decoration: InputDecoration(
        filled: true,
        fillColor: _offWhite,
        hintText: min != null && max != null ? '$min - $max arası' : 'Sayı girin',
        hintStyle: const TextStyle(fontSize: 10, color: _gray),
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
      onChanged: (v) {
        setState(() {
          _detaylar[id] = v;
          _valuation = null;
          _fiyatHata = null;
        });
      },
    );
  }

  Widget _buildTextField(Map<String, dynamic> alan) {
    final id = alan['id'] as String;
    final currentValue = _detaylar[id]?.toString() ?? '';

    return TextFormField(
      initialValue: currentValue,
      style: const TextStyle(fontSize: 13, color: _black),
      decoration: InputDecoration(
        filled: true,
        fillColor: _offWhite,
        hintText: 'Örn: 4x10m',
        hintStyle: const TextStyle(fontSize: 10, color: _gray),
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
      onChanged: (v) {
        setState(() {
          _detaylar[id] = v;
          _valuation = null;
          _fiyatHata = null;
        });
      },
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
          onTap: () {
            setState(() {
              if (selected) {
                currentValues.remove(s);
              } else {
                currentValues.add(s);
              }
              _detaylar[id] = currentValues;
              _valuation = null;
              _fiyatHata = null;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? _black : _offWhite,
              border: Border.all(color: selected ? _black : const Color(0xFFD6D6D6)),
            ),
            child: Text(s.replaceAll('_', ' '), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: selected ? Colors.white : _black)),
          ),
        );
      }).toList(),
    );
  }

  Widget _stepIhtiyac() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), Text('${_yapiTuruId != null ? _formatYapiAdi(_yapiTuruId!) : ''} İÇİN İHTİYAÇLAR', style: const TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
          const SizedBox(height: 20),
          const Text('Kimler Lazım?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${_asama.displayName} aşaması için önerilenler otomatik seçili', style: const TextStyle(fontSize: 11, color: _gray)),
          const SizedBox(height: 20),
          ...brief.IhtiyacKatalogu.katalog.values.map((i) => _ihtiyacCard(i)),
        ],
      ),
    );
  }

  Widget _ihtiyacCard(brief.ProjeIhtiyacMapping i) {
    final selected = _ihtiyacIds.contains(i.id);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) _ihtiyacIds.remove(i.id);
          else _ihtiyacIds.add(i.id);
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
            Container(width: 18, height: 18, decoration: BoxDecoration(border: Border.all(color: selected ? _gold : Colors.black26), color: selected ? _gold : Colors.transparent), child: selected ? const Icon(Icons.check, size: 12, color: Colors.black) : null),
            const SizedBox(width: 12),
            Expanded(child: Text(i.displayName, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.bold : FontWeight.w500))),
            Text(i.grup, style: const TextStyle(fontSize: 7, letterSpacing: 1, color: _gray)),
          ],
        ),
      ),
    );
  }

  Widget _stepOzet() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), const Text('SON KONTROL', style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
          const SizedBox(height: 20),
          const Text('Projeni Yayınla', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _ozetRow('YAPI TÜRÜ', _yapiTuruId != null ? _formatYapiAdi(_yapiTuruId!) : '-'),
          _ozetRow('AŞAMA', _asama.displayName),
          _ozetRow('ÖLÇEK', _olcek.entries.isEmpty ? '-' : _olcek.entries.map((e) => '${e.value} ${_formatOlcekBirim(e.key)} ${_formatOlcekLabel(e.key)}').join(' • ')),
          _ozetRow('DETAY', '${_detaylar.length} detay • ${_detaylar.entries.map((e) => '${e.key}:${e.value}').take(3).join(', ')}${_detaylar.length > 3 ? '...' : ''}'),
          _ozetRow('İHTİYAÇ', '${_ihtiyacIds.length} profesyonel'),
          _ozetRow('KONUM', '$_il / $_ilce'),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            color: _black,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 24, height: 1, color: _gold),
                    const SizedBox(width: 8),
                    const Text('PROJE DETAYI', style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 2)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _aciklamaCtrl,
                  maxLines: 6,
                  minLines: 4,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'Lütfen projenizi detaylı şekilde açıklayınız...\n\nÖrnek: Arsanın konumu, eğimi, manzara durumu, bütçe aralığı, özel istekler, teslim süresi beklentiniz gibi detayları yazın.',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11, height: 1.5),
                    border: InputBorder.none,
                    filled: false,
                  ),
                  onChanged: (v) {
                    setState(() {
                      _valuation = null;
                      _fiyatHata = null;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Container(height: 1, color: Colors.white10),
                const SizedBox(height: 8),
                Text('${_aciklamaCtrl.text.length} karakter', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 8, letterSpacing: 1)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('FOTOĞRAFLAR', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray)),
                    const Spacer(),
                    Text('${_fotolar.length}/10', style: const TextStyle(fontSize: 9, color: _gold, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Varsa arsa, mevcut yapı veya referans foto ekleyin (zorunlu değil)', style: TextStyle(fontSize: 10, color: _gray)),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                  itemCount: _fotolar.length + (_fotolar.length < 10 ? 1 : 0),
                  itemBuilder: (c, i) {
                    if (i == _fotolar.length) {
                      return GestureDetector(
                        onTap: _pickFoto,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6D6D6), width: 0.8)),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 20, color: _gray),
                              SizedBox(height: 6),
                              Text('FOTO EKLE', style: TextStyle(fontSize: 7, letterSpacing: 1, color: _gray)),
                              SizedBox(height: 2),
                              Text('Kamera / Galeri', style: TextStyle(fontSize: 6, color: _gray)),
                            ],
                          ),
                        ),
                      );
                    }
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: FutureBuilder<Uint8List>(
                            future: _fotolar[i].readAsBytes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(snapshot.data!, fit: BoxFit.cover);
                              }
                              return Container(color: _black, child: const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1, color: _gold))));
                            },
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => setState(() => _fotolar.removeAt(i)),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(color: _black, shape: BoxShape.circle),
                              child: const Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            color: _black,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('EŞLEŞEN PROFESYONELLER', style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 2)),
                const SizedBox(height: 12),
                Text('${_ihtiyacIds.length} ihtiyaç için doğrulanmış profesyoneller aranacak', style: const TextStyle(color: Colors.white, fontSize: 11, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // TAHMİNİ FİYAT BÖLÜMÜ - YAYINLA'DAN ÖNCE
          HugProFiyatHesaplaButton(
            onPressed: _tahminiFiyatGoster,
            isLoading: _fiyatHesaplaniyor,
            fiyatGosterildi: _valuation != null,
          ),
          const SizedBox(height: 16),
          HugProFiyatKarti(
            valuation: _valuation,
            isLoading: _fiyatHesaplaniyor,
            error: _fiyatHata,
            onRetry: _tahminiFiyatGoster,
          ),
          const SizedBox(height: 24),
          if (_valuation == null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: _gold.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: _gold.withOpacity(0.3))),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, size: 14, color: _black),
                  SizedBox(width: 8),
                  Expanded(child: Text('İlanı yayınlamak için önce tahmini fiyatı görmelisiniz', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _black))),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _ozetRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0F000000)))),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 8, letterSpacing: 1, color: _gray))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    final bool fiyatGoruldu = _valuation != null;
    final bool isLastStep = _step == 5;
    final bool yayinlaAktif = !isLastStep || fiyatGoruldu;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          if (_step > 0)
            Expanded(
              child: GestureDetector(
                onTap: _kaydediliyor || _fiyatHesaplaniyor ? null : () {
                  setState(() => _step--);
                  _pageCtrl.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6D6D6), width: 0.8)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.arrow_back, size: 12), SizedBox(width: 6), Text('GERİ', style: TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold))]),
                ),
              ),
            ),
          if (_step > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _kaydediliyor || _fiyatHesaplaniyor ? null : () {
                if (_step < 5) {
                  setState(() => _step++);
                  _pageCtrl.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                } else {
                  // Son adımda fiyat görülmeden yayınlama yok
                  if (!fiyatGoruldu) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Önce TAHMİNİ FİYATI GÖR butonuna basın'), backgroundColor: _black));
                    return;
                  }
                  _projeyiYayinla();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                color: _kaydediliyor || _fiyatHesaplaniyor ? const Color(0xFF222222) : (isLastStep && !fiyatGoruldu ? const Color(0xFFCCCCCC) : _gold),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_kaydediliyor)
                      const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: _gold))
                    else if (_fiyatHesaplaniyor)
                      const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: _black))
                    else
                      Text(
                        _step == 5 ? (fiyatGoruldu ? 'PROJEYİ YAYINLA' : 'ÖNCE FİYATI GÖR') : 'DEVAM ET',
                        style: TextStyle(color: (isLastStep && !fiyatGoruldu) ? _gray : _black, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                    if (!_kaydediliyor && !_fiyatHesaplaniyor) ...[
                      const SizedBox(width: 8),
                      Icon(isLastStep && !fiyatGoruldu ? Icons.lock : Icons.arrow_outward, size: 12, color: (isLastStep && !fiyatGoruldu) ? _gray : _black),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
