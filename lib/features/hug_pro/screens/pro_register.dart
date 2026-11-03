
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ustam_gelsin/services/r2_service.dart';
import 'package:ustam_gelsin/features/hug_pro/hug_ontoloji.dart';

const _black = Color(0xFF0B0B0B);
const _dark = Color(0xFF111111);
const _offWhite = Color(0xFFF7F5F0);
const _gold = Color(0xFFC8A45D);
const _gray = Color(0xFF8E8E8E);

enum KayitTipi { sahis, sirket }

class ProRegisterScreen extends StatefulWidget {
  const ProRegisterScreen({super.key});
  @override
  State<ProRegisterScreen> createState() => _ProRegisterScreenState();
}

class _ProRegisterScreenState extends State<ProRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _r2 = R2Service();
  final _picker = ImagePicker();

  KayitTipi _kayitTipi = KayitTipi.sahis;
  final _tcCtrl = TextEditingController();
  final _adCtrl = TextEditingController();
  final _soyadCtrl = TextEditingController();
  final _vdCtrl = TextEditingController();
  final _vergiDairesiCtrl = TextEditingController();
  final _mersisCtrl = TextEditingController();
  final _sirketUnvanCtrl = TextEditingController();
  final _yetkiliCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _adresCtrl = TextEditingController();
  final _pass1Ctrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _obscure1 = true, _obscure2 = true;
  bool _kvkkOnay = false;
  Timestamp? _kvkkOnayZamani;
  bool _loading = false;

  final List<ProfesyonelDalSecimi> _secilenMeslekler = [];
  final List<Map<String, dynamic>> _belgeler = [];
  XFile? _profilFoto;
  Uint8List? _profilFotoBytes;

  @override
  void dispose() {
    _tcCtrl.dispose();
    _adCtrl.dispose();
    _soyadCtrl.dispose();
    _vdCtrl.dispose();
    _vergiDairesiCtrl.dispose();
    _mersisCtrl.dispose();
    _sirketUnvanCtrl.dispose();
    _yetkiliCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _adresCtrl.dispose();
    _pass1Ctrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  bool _isValidTC(String tc) {
    if (tc.length != 11) return false;
    if (tc[0] == '0') return false;
    if (!RegExp(r'^[0-9]{11}$').hasMatch(tc)) return false;
    final digits = tc.split('').map(int.parse).toList();
    final oddSum = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    final evenSum = digits[1] + digits[3] + digits[5] + digits[7];
    final d10 = ((oddSum * 7) - evenSum) % 10;
    if (d10 != digits[9]) return false;
    final total = digits.sublist(0, 10).reduce((a, b) => a + b);
    final d11 = total % 10;
    if (d11 != digits[10]) return false;
    return true;
  }

  String _hashTC(String tc) {
    try {
      final bytes = utf8.encode(tc + 'HUG_SALT_2026');
      int hash = 0;
      for (var b in bytes) {
        hash = ((hash << 5) - hash) + b;
        hash = hash & 0xFFFFFFFF;
      }
      return hash.toRadixString(16).padLeft(8, '0');
    } catch (_) {
      return tc.hashCode.toString();
    }
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Şifre zorunlu';
    if (v.length < 8) return 'En az 8 karakter';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return '1 büyük harf';
    if (!RegExp(r'[a-z]').hasMatch(v)) return '1 küçük harf';
    if (!RegExp(r'[^\w\s]').hasMatch(v)) return '1 noktalama (.!*?)';
    return null;
  }

  Future<String> _uploadBytesR2(Uint8List bytes, String path) async {
    final dynamic r2d = _r2;
    try {
      final res = await r2d.uploadBytes(bytes, path);
      if (res is String && res.isNotEmpty) return res;
    } catch (e) {
      debugPrint('R2 try1 fail: $e');
    }
    try {
      final res = await r2d.uploadFileBytes(bytes: bytes, path: path);
      if (res is String) return res;
    } catch (_) {}
    try {
      final res = await r2d.uploadBytes(bytes: bytes, fileName: path);
      if (res is String) return res;
    } catch (_) {}
    throw Exception('R2 upload basarisiz - R2Service.uploadBytes signature kontrol et');
  }

  Future<String> _uploadFileR2(File file, String path) async {
    final dynamic r2d = _r2;
    try {
      final res = await r2d.uploadFile(file, path);
      if (res is String && res.isNotEmpty) return res;
    } catch (e) {
      debugPrint('R2 file try1 fail: $e');
    }
    try {
      final res = await r2d.uploadFile(file: file, path: path);
      if (res is String) return res;
    } catch (_) {}
    try {
      final bytes = await file.readAsBytes();
      return await _uploadBytesR2(bytes, path);
    } catch (e) {
      throw Exception('R2 file upload fail: $e');
    }
  }

  Future<void> _openAnaDalSelector() async {
    final result = await showDialog<List<ProfesyonelDalSecimi>>(
      context: context,
      builder: (_) => const _ProMeslekSecimDialog(),
    );
    if (result == null || result.isEmpty) return;
    setState(() {
      for (var m in result) {
        final exists = _secilenMeslekler.any((e) => e.anaDalId == m.anaDalId && e.altDalId == m.altDalId && e.unvanId == m.unvanId);
        if (!exists) _secilenMeslekler.add(m);
      }
    });
  }

  Future<void> _pickProfilFoto() async {
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x != null) {
      final bytes = await x.readAsBytes();
      setState(() {
        _profilFoto = x;
        _profilFotoBytes = bytes;
      });
    }
  }

  Future<void> _addBelge() async {
    final belgeTuru = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Belge Türü Seç', style: TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var t in ['DIPLOMA', 'ODA_KAYIT', 'MYK_BELGE', 'YETKI_BELGESI', 'VERGI_LEVHASI', 'USTALIK_BELGESI', 'SANTIYE_SEFLIGI', 'YAPI_DENETIM_YETKI', 'ISG_YETKI', 'EKB_YETKI'])
                  ListTile(
                    dense: true,
                    title: Text(t, style: const TextStyle(color: _black, fontSize: 13, fontWeight: FontWeight.w600)),
                    onTap: () => Navigator.pop(context, t),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (belgeTuru == null) return;
    final noCtrl = TextEditingController();
    final no = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('$belgeTuru No', style: const TextStyle(color: _black)),
        content: TextField(
          controller: noCtrl,
          style: const TextStyle(color: _black),
          decoration: const InputDecoration(hintText: 'Belge numarasını gir', hintStyle: TextStyle(color: _gray)),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context, noCtrl.text), child: const Text('Tamam', style: TextStyle(color: _gold)))],
      ),
    );
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    setState(() => _belgeler.add({'belgeTuru': belgeTuru, 'belgeNo': no ?? '', 'file': file, 'dogrulamaDurumu': 'BEKLEMEDE', 'aktifYetki': false}));
  }

  Future<void> _showKvkkDialog() async {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              Container(
                color: _black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(width: 3, height: 18, color: _gold),
                    const SizedBox(width: 10),
                    const Expanded(child: Text('KVKK AYDINLATMA METNİ', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1))),
                    IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('config').doc('pro_kvkk').get(),
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: _gold));
                    }
                    if (!snap.hasData || !snap.data!.exists) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('KVKK metni yükleniyor... Firestore /config/pro_kvkk dokümanı kontrol edin.', style: TextStyle(color: _black)),
                      );
                    }
                    final data = snap.data!.data() as Map<String, dynamic>;
                    final baslik = data['baslik'] ?? 'KVKK Aydınlatma Metni';
                    final icerik = data['icerik'] ?? data['metin'] ?? 'Metin boş.';
                    final guncel = data['guncellemeTarihi'] ?? '';
                    final versiyon = data['versiyon'] ?? '';
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(baslik.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _black)),
                          const SizedBox(height: 8),
                          Row(children: [
                            if (guncel.toString().isNotEmpty) Text('Son Güncelleme: $guncel  ', style: const TextStyle(fontSize: 9, color: _gray)),
                            if (versiyon.toString().isNotEmpty) Text('Versiyon: $versiyon', style: const TextStyle(fontSize: 9, color: _gray)),
                          ]),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),
                          Text(icerik.toString(), style: const TextStyle(fontSize: 12.5, color: _black, height: 1.6)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _black),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('KAPAT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onKvkkChanged(bool? v) async {
    final now = Timestamp.now();
    setState(() {
      _kvkkOnay = v ?? false;
      if (_kvkkOnay) {
        _kvkkOnayZamani = now;
      } else {
        _kvkkOnayZamani = null;
      }
    });
    if (_kvkkOnay) {
      try {
        final email = _emailCtrl.text.trim();
        final docId = email.isNotEmpty ? email : 'anon_${DateTime.now().millisecondsSinceEpoch}';
        await FirebaseFirestore.instance.collection('kvkk_onay_log').doc(docId).set({
          'email': email,
          'telefon': _telCtrl.text.trim(),
          'ad': _adCtrl.text.trim(),
          'soyad': _soyadCtrl.text.trim(),
          'kvkkOnay': true,
          'kvkkOnayZamani': now,
          'kvkkVersiyon': 'v1.0',
          'kaynak': 'pro_kvkk',
          'configDoc': 'config/pro_kvkk',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('KVKK log fail: $e');
      }
    }
  }

  bool _areAllFieldsFilled() {
    if (_emailCtrl.text.trim().isEmpty) return false;
    if (_telCtrl.text.trim().isEmpty) return false;
    if (_adresCtrl.text.trim().isEmpty) return false;
    if (_pass1Ctrl.text.isEmpty || _pass2Ctrl.text.isEmpty) return false;
    if (_kayitTipi == KayitTipi.sahis) {
      if (_tcCtrl.text.trim().isEmpty) return false;
      if (_adCtrl.text.trim().isEmpty) return false;
      if (_soyadCtrl.text.trim().isEmpty) return false;
    } else {
      if (_vdCtrl.text.trim().isEmpty) return false;
      if (_vergiDairesiCtrl.text.trim().isEmpty) return false;
      if (_sirketUnvanCtrl.text.trim().isEmpty) return false;
      if (_yetkiliCtrl.text.trim().isEmpty) return false;
    }
    return true;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen tüm zorunlu alanları doldurun')));
      return;
    }
    if (!_areAllFieldsFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tüm bilgiler dolu olmadan onay gönderemezsiniz!')));
      return;
    }
    if (!_kvkkOnay) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('KVKK onayı zorunlu - Lütfen kutucuğu işaretleyin')));
      return;
    }
    if (_secilenMeslekler.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('En az 1 meslek seç - HAYATİ! Meslek olmadan ilan erişimi yok!')));
      return;
    }
    if (_belgeler.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mesleğinizle ilgili en az 1 belge eklemelisiniz! Belge zorunlu!')));
      return;
    }
    if (_pass1Ctrl.text != _pass2Ctrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Şifreler eşleşmiyor')));
      return;
    }
    if (_kayitTipi == KayitTipi.sahis && !_isValidTC(_tcCtrl.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Geçersiz TC Kimlik No')));
      return;
    }

    setState(() => _loading = true);
    UserCredential? cred;
    try {
      try {
        final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_emailCtrl.text.trim());
        if (methods.isNotEmpty) throw Exception('Bu email zaten kayıtlı');
      } catch (_) {}

      cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailCtrl.text.trim(), password: _pass1Ctrl.text);
      final uid = cred.user!.uid;

      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (_) {}

      String? profilFotoUrl;
      if (_profilFoto != null) {
        final path = 'users_pro/$uid/profil/profil.jpg';
        if (kIsWeb) {
          profilFotoUrl = await _uploadBytesR2(_profilFotoBytes!, path);
        } else {
          profilFotoUrl = await _uploadFileR2(File(_profilFoto!.path), path);
        }
      }

      final List<Map<String, dynamic>> uploadedBelgeler = [];
      for (var b in _belgeler) {
        final XFile f = b['file'];
        final path = 'users_pro/$uid/belgeler/${b['belgeTuru']}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String url;
        if (kIsWeb) {
          url = await _uploadBytesR2(await f.readAsBytes(), path);
        } else {
          url = await _uploadFileR2(File(f.path), path);
        }
        uploadedBelgeler.add({
          'belgeTuru': b['belgeTuru'],
          'belgeNo': b['belgeNo'],
          'belgeUrl': url,
          'dogrulamaDurumu': 'BEKLEMEDE',
          'aktifYetki': false,
          'yuklenmeTarihi': Timestamp.now(),
          'r2Path': path,
        });
      }

      final maskedTc = _kayitTipi == KayitTipi.sahis && _tcCtrl.text.length == 11 ? '*** *** ${_tcCtrl.text.substring(7)}' : '';

      final mesleklerForFirestore = _secilenMeslekler.map((e) {
        final anaDal = HugProMasterOntologyV5.anaDallar.firstWhere((a) => a.id == e.anaDalId);
        final altDal = anaDal.altDallar.firstWhere((a) => a.id == e.altDalId, orElse: () => anaDal.altDallar.first);
        return {
          ...e.toJson(),
          'anaDalAd': anaDal.ad,
          'altDalAd': altDal.ad,
          'uid': uid,
          'createdAt': Timestamp.now(),
        };
      }).toList();

      await FirebaseFirestore.instance.collection('users_pro').doc(uid).set({
        'uid': uid,
        'kayitTipi': _kayitTipi.name,
        'tcMasked': maskedTc,
        'tcHash': _hashTC(_tcCtrl.text),
        'ad': _adCtrl.text.trim(),
        'soyad': _soyadCtrl.text.trim(),
        'vergiNo': _vdCtrl.text.trim(),
        'vergiDairesi': _vergiDairesiCtrl.text.trim(),
        'mersisNo': _mersisCtrl.text.trim(),
        'sirketUnvan': _sirketUnvanCtrl.text.trim(),
        'yetkiliAdSoyad': _yetkiliCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'telefon': _telCtrl.text.trim(),
        'adres': _adresCtrl.text.trim(),
        'profilFotoUrl': profilFotoUrl,
        'meslekler': mesleklerForFirestore,
        'meslekAnaDallar': _secilenMeslekler.map((e) => e.anaDalId).toSet().toList(),
        'meslekAltDallar': _secilenMeslekler.map((e) => e.altDalId).toSet().toList(),
        'belgeler': uploadedBelgeler,
        'durum': 'ONAY_BEKLIYOR',
        'isActive': false,
        'isVerified': false,
        'fcmToken': fcmToken,
        'fcmTokens': fcmToken != null ? [fcmToken] : [],
        'kvkkOnay': _kvkkOnay,
        'kvkkOnayTarihi': _kvkkOnayZamani ?? FieldValue.serverTimestamp(),
        'kvkkOnayKaynak': 'config/pro_kvkk',
        'kvkkVersiyon': '1.0',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('admin_onay_bekleyenler').doc(uid).set({
        'uid': uid,
        'tip': 'PROFESYONEL',
        'email': _emailCtrl.text.trim(),
        'ad': _adCtrl.text.trim(),
        'meslekler': mesleklerForFirestore,
        'belgeler': uploadedBelgeler,
        'kvkkOnay': _kvkkOnay,
        'kvkkOnayTarihi': _kvkkOnayZamani ?? FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      for (var m in mesleklerForFirestore) {
        await FirebaseFirestore.instance.collection('pro_meslek_index').doc('${uid}_${m['anaDalId']}_${m['altDalId']}').set({
          'uid': uid,
          'anaDalId': m['anaDalId'],
          'altDalId': m['altDalId'],
          'anaDalAd': m['anaDalAd'],
          'altDalAd': m['altDalAd'],
          'unvanId': m['unvanId'],
          'email': _emailCtrl.text.trim(),
          'durum': 'ONAY_BEKLIYOR',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await FirebaseFirestore.instance.collection('kvkk_onay_log').doc(uid).set({
        'uid': uid,
        'email': _emailCtrl.text.trim(),
        'telefon': _telCtrl.text.trim(),
        'ad': _adCtrl.text.trim(),
        'soyad': _soyadCtrl.text.trim(),
        'kvkkOnay': true,
        'kvkkOnayZamani': _kvkkOnayZamani ?? FieldValue.serverTimestamp(),
        'kvkkVersiyon': '1.0',
        'kaynak': 'pro_kvkk',
        'configDoc': 'config/pro_kvkk',
        'meslekler': mesleklerForFirestore,
        'belgeSayisi': uploadedBelgeler.length,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: _dark,
          title: const Text('Başvurunuz Alındı', style: TextStyle(color: Colors.white)),
          content: const Text('Bilgileriniz, meslekleriniz ve belgeleriniz incelenmek üzere alındı. Onaylandığında ilanlara erişiminiz açılacak ve size bildirim göndereceğiz.', style: TextStyle(color: Colors.white70)),
          actions: [TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('Tamam', style: TextStyle(color: _gold)))],
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (cred != null) {
        try {
          await cred.user?.delete();
        } catch (_) {}
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Kayıt hatası')));
    } catch (e) {
      if (cred != null) {
        try {
          await cred.user?.delete();
        } catch (_) {}
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 10, letterSpacing: 1.5, color: _black, fontWeight: FontWeight.w600),
      hintStyle: const TextStyle(fontSize: 12, color: _gray),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _gold, width: 1.5)),
      errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      appBar: AppBar(
        backgroundColor: _black,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        title: const Text('Profesyonel Kayıt', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: _black,
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: _ArchGridPainter())),
                  const _HeroHeader(),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: _offWhite,
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 48),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Container(width: 32, height: 1.5, color: _gold), const SizedBox(width: 10), const Text('KAYIT TİPİ', style: TextStyle(fontSize: 10, letterSpacing: 2.5, color: _black, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 16),
                    // YENI KAYIT TIPI SELECTOR - SEGMENTED BUTTON KALDIRILDI, KAPKARA BUG FIX!
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black12)),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _kayitTipi = KayitTipi.sahis),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: _kayitTipi == KayitTipi.sahis ? _black : Colors.white,
                                  border: Border.all(color: _kayitTipi == KayitTipi.sahis ? _gold : Colors.black12, width: _kayitTipi == KayitTipi.sahis ? 1.2 : 0.8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_kayitTipi == KayitTipi.sahis) const Icon(Icons.check, size: 14, color: Colors.white),
                                    if (_kayitTipi == KayitTipi.sahis) const SizedBox(width: 6),
                                    if (_kayitTipi != KayitTipi.sahis) const Icon(Icons.person_outline, size: 14, color: _black),
                                    if (_kayitTipi != KayitTipi.sahis) const SizedBox(width: 6),
                                    Text('ŞAHIS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1, color: _kayitTipi == KayitTipi.sahis ? Colors.white : _black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _kayitTipi = KayitTipi.sirket),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: _kayitTipi == KayitTipi.sirket ? _black : Colors.white,
                                  border: Border.all(color: _kayitTipi == KayitTipi.sirket ? _gold : Colors.black12, width: _kayitTipi == KayitTipi.sirket ? 1.2 : 0.8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_kayitTipi == KayitTipi.sirket) const Icon(Icons.check, size: 14, color: Colors.white),
                                    if (_kayitTipi == KayitTipi.sirket) const SizedBox(width: 6),
                                    if (_kayitTipi != KayitTipi.sirket) const Icon(Icons.business_outlined, size: 14, color: _black),
                                    if (_kayitTipi != KayitTipi.sirket) const SizedBox(width: 6),
                                    Text('ŞİRKET', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1, color: _kayitTipi == KayitTipi.sirket ? Colors.white : _black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (_kayitTipi == KayitTipi.sahis) ...[
                      Row(children: [Container(width: 24, height: 1.5, color: _gold), const SizedBox(width: 8), const Text('ŞAHIS BİLGİLERİ', style: TextStyle(fontSize: 9, letterSpacing: 2, color: _black, fontWeight: FontWeight.bold))]),
                      const SizedBox(height: 16),
                      TextFormField(controller: _tcCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('TC NO (11 HANE) *'), maxLength: 11, keyboardType: TextInputType.number, validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : (v.length != 11 ? '11 hane gir' : (!_isValidTC(v) ? 'Geçersiz TC' : null))),
                      const SizedBox(height: 12),
                      TextFormField(controller: _adCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('AD *'), validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null),
                      const SizedBox(height: 12),
                      TextFormField(controller: _soyadCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('SOYAD *'), validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null),
                    ] else ...[
                      Row(children: [Container(width: 24, height: 1.5, color: _gold), const SizedBox(width: 8), const Text('ŞİRKET BİLGİLERİ', style: TextStyle(fontSize: 9, letterSpacing: 2, color: _black, fontWeight: FontWeight.bold))]),
                      const SizedBox(height: 16),
                      TextFormField(controller: _vdCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('VERGİ NO *'), validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null),
                      const SizedBox(height: 12),
                      TextFormField(controller: _vergiDairesiCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('VERGİ DAİRESİ *'), validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null),
                      const SizedBox(height: 12),
                      TextFormField(controller: _mersisCtrl, style: const TextStyle(color: _black), decoration: _inputDeco('MERSİS NO (VARSA)')),
                      const SizedBox(height: 12),
                      TextFormField(controller: _sirketUnvanCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('ŞİRKET UNVANI *'), validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null),
                      const SizedBox(height: 12),
                      TextFormField(controller: _yetkiliCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('YETKİLİ AD SOYAD *'), validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null),
                    ],
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1.5, color: _gold), const SizedBox(width: 8), const Text('İLETİŞİM', style: TextStyle(fontSize: 9, letterSpacing: 2, color: _black, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 16),
                    TextFormField(controller: _emailCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('E-MAIL *'), validator: (v) => v == null || !v.contains('@') ? 'Geçersiz email' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: _telCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('TELEFON *'), validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: _adresCtrl, style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600), decoration: _inputDeco('ADRES *'), maxLines: 2, validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null),
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1.5, color: _gold), const SizedBox(width: 8), const Text('PROFİL FOTOĞRAFI', style: TextStyle(fontSize: 9, letterSpacing: 2, color: _black, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: _profilFotoBytes != null ? CircleAvatar(radius: 24, backgroundImage: MemoryImage(_profilFotoBytes!)) : Container(width: 48, height: 48, decoration: BoxDecoration(color: _offWhite, border: Border.all(color: Colors.black12)), child: const Icon(Icons.camera_alt, size: 18, color: _black)),
                        title: const Text('Profil Fotoğrafı (R2)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _black)),
                        subtitle: const Text('users_pro/{uid}/profil/ - Cloudflare R2', style: TextStyle(fontSize: 8, color: _gray)),
                        trailing: Container(width: 36, height: 36, decoration: BoxDecoration(border: Border.all(color: Color(0xFFD6D6D6), width: 0.8), shape: BoxShape.circle), child: const Icon(Icons.arrow_outward, size: 14, color: _black)),
                        onTap: _pickProfilFoto,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1.5, color: _gold), const SizedBox(width: 8), const Text('MESLEKİ YETERLİLİK (12 ANA DAL - SINIRSIZ SEÇİM) *', style: TextStyle(fontSize: 9, letterSpacing: 1, color: _black, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 8),
                    const Text('Ana dala tıklayınca alt dalları görürsün, istediğin kadar meslek ekleyebilirsin. Seçtiklerin ilan erişimini belirler! Belge ile eşleşmeli!', style: TextStyle(fontSize: 10, color: _gray)),
                    const SizedBox(height: 16),
                    _CtaWithLight(label: '12 ANA DAL\'DAN MESLEK EKLE *', intensity: 0.7, onTap: _openAnaDalSelector),
                    const SizedBox(height: 16),
                    if (_secilenMeslekler.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _gold.withOpacity(0.4)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [Container(width: 3, height: 14, color: _gold), const SizedBox(width: 8), Text('SEÇİLEN MESLEKLER (${_secilenMeslekler.length}) - İLAN ERİŞİMİ', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: _black))]),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _secilenMeslekler.map((m) {
                                final anaDal = HugProMasterOntologyV5.anaDallar.firstWhere((a) => a.id == m.anaDalId);
                                final altDal = anaDal.altDallar.firstWhere((a) => a.id == m.altDalId, orElse: () => anaDal.altDallar.first);
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(color: _black, borderRadius: BorderRadius.circular(4), border: Border.all(color: _gold.withOpacity(0.3))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${anaDal.ad}', style: const TextStyle(fontSize: 9, color: _gold, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                          Text('${altDal.ad} • ${m.unvanId}', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () => setState(() => _secilenMeslekler.remove(m)),
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
                                          child: const Icon(Icons.close, size: 12, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.red.withOpacity(0.3))),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(child: Text('Henüz meslek seçilmedi! Yukarıdaki butondan meslek ekle. Meslek seçmeden ve belge eklemeden kayıt gönderemezsiniz!', style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1.5, color: _gold), const SizedBox(width: 8), const Text('RESMİ BELGELER (ADMİN ONAYI ŞART) *', style: TextStyle(fontSize: 9, letterSpacing: 2, color: _black, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 16),
                    ..._belgeler.map((b) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black12)),
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle)),
                          const SizedBox(width: 10),
                          Expanded(child: Text('${b['belgeTuru']} - No: ${b['belgeNo']}', style: const TextStyle(fontSize: 12, color: _black, fontWeight: FontWeight.w600))),
                          const Text('BEKLEMEDE', style: TextStyle(fontSize: 8, letterSpacing: 1, color: _gray, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          GestureDetector(onTap: () => setState(() => _belgeler.remove(b)), child: const Icon(Icons.close, size: 14, color: _gray)),
                        ],
                      ),
                    )),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _addBelge,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _belgeler.isEmpty ? Colors.red.withOpacity(0.5) : const Color(0xFFD6D6D6), width: _belgeler.isEmpty ? 1.2 : 0.8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.upload_file, size: 16, color: _belgeler.isEmpty ? Colors.red : _black), const SizedBox(width: 8), Text(_belgeler.isEmpty ? 'BELGE EKLE * (ZORUNLU)' : 'BELGE EKLE (DİPLOMA / ODA / MYK / YETKİ)', style: TextStyle(fontSize: 11, letterSpacing: 0.5, color: _belgeler.isEmpty ? Colors.red : _black, fontWeight: FontWeight.w600))],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1.5, color: _gold), const SizedBox(width: 8), const Text('ŞİFRE *', style: TextStyle(fontSize: 9, letterSpacing: 2, color: _black, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pass1Ctrl,
                      obscureText: _obscure1,
                      style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600),
                      decoration: _inputDeco('ŞİFRE (8+ 1 BÜYÜK 1 KÜÇÜK 1 NOKTALAMA) *').copyWith(
                        suffixIcon: IconButton(icon: Icon(_obscure1 ? Icons.visibility : Icons.visibility_off, size: 18, color: _black), onPressed: () => setState(() => _obscure1 = !_obscure1)),
                      ),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _pass2Ctrl,
                      obscureText: _obscure2,
                      style: const TextStyle(color: _black, fontSize: 14, fontWeight: FontWeight.w600),
                      decoration: _inputDeco('ŞİFRE TEKRAR *').copyWith(
                        suffixIcon: IconButton(icon: Icon(_obscure2 ? Icons.visibility : Icons.visibility_off, size: 18, color: _black), onPressed: () => setState(() => _obscure2 = !_obscure2)),
                      ),
                      validator: (v) => v != _pass1Ctrl.text ? 'Eşleşmiyor' : null,
                    ),
                    const SizedBox(height: 24),
                    // KVKK - KIRMIZI VE TIKLANIR - GARANTILI FIX - GESTUREDETECTOR ILE
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _kvkkOnay ? Colors.green.withOpacity(0.5) : Colors.black12, width: _kvkkOnay ? 1.2 : 1)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(value: _kvkkOnay, activeColor: _black, checkColor: Colors.white, onChanged: _onKvkkChanged),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: _showKvkkDialog,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.08), border: Border(bottom: BorderSide(color: Colors.red, width: 1.5))),
                                          child: const Text('KVKK Aydınlatma Metnini', style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationColor: Colors.red)),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text('okudum, açık rıza veriyorum *', style: TextStyle(fontSize: 11, color: _black, fontWeight: FontWeight.bold, height: 1.4)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Kırmızı metne tıklayarak metni okuyabilirsiniz', style: TextStyle(fontSize: 8, color: _gray)),
                                  if (_kvkkOnayZamani != null) ...[
                                    const SizedBox(height: 4),
                                    Text('✓ Onaylandı: ${_kvkkOnayZamani!.toDate().toString().substring(0,19)}', style: const TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.w600)),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _loading
                        ? const Center(child: CircularProgressIndicator(color: _gold))
                        : _CtaWithLight(label: 'KAYIT OL - ONAYA GÖNDER', big: true, intensity: 0.85, onTap: _submit),
                    const SizedBox(height: 40),
                    Container(height: 1, color: Colors.black12),
                    const SizedBox(height: 12),
                    const Text('© 2026 HUG PROJE - PROFESSIONAL - MESLEKLER UID YE ÇİVİLİ - R2 RESIM / FIREBASE URL - KVKK CHECKBOX YETERLI', style: TextStyle(color: _gray, fontSize: 7, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProMeslekSecimDialog extends StatefulWidget {
  const _ProMeslekSecimDialog();
  @override
  State<_ProMeslekSecimDialog> createState() => _ProMeslekSecimDialogState();
}

class _ProMeslekSecimDialogState extends State<_ProMeslekSecimDialog> {
  String? _secilenAnaDalId;
  String? _secilenAltDalId;
  String? _secilenUnvanId;
  final Set<String> _secilenUzmanlik = {};
  final Set<String> _secilenHizmet = {};
  final List<ProfesyonelDalSecimi> _geciciSecilenler = [];

  @override
  Widget build(BuildContext context) {
    final anaDallar = HugProMasterOntologyV5.anaDallar;
    final seciliAna = _secilenAnaDalId != null ? anaDallar.firstWhere((e) => e.id == _secilenAnaDalId) : null;
    final seciliAlt = seciliAna != null && _secilenAltDalId != null ? seciliAna.altDallar.firstWhere((e) => e.id == _secilenAltDalId, orElse: () => seciliAna.altDallar.first) : null;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Container(
              color: _black,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(width: 3, height: 20, color: _gold),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('12 ANA DALDAN MESLEK EKLE - SINIRSIZ', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1))),
                  IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 140,
                    color: _offWhite,
                    child: ListView.builder(
                      itemCount: anaDallar.length,
                      itemBuilder: (_, i) {
                        final ana = anaDallar[i];
                        final isSel = _secilenAnaDalId == ana.id;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _secilenAnaDalId = ana.id;
                            _secilenAltDalId = null;
                            _secilenUnvanId = null;
                            _secilenUzmanlik.clear();
                            _secilenHizmet.clear();
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                            decoration: BoxDecoration(color: isSel ? _black : Colors.white, border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5), left: BorderSide(color: isSel ? _gold : Colors.transparent, width: 3))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ana.id, style: TextStyle(fontSize: 8, color: isSel ? _gold : _gray, fontWeight: FontWeight.bold)),
                                Text(ana.ad, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : _black, fontWeight: FontWeight.w700)),
                                Text('${ana.altDallar.length} alt dal', style: TextStyle(fontSize: 8, color: isSel ? Colors.white54 : _gray)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: seciliAna == null
                        ? const Center(child: Text('Soldan ana dal seç', style: TextStyle(color: _gray, fontSize: 12)))
                        : SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${seciliAna.ad} - ALT DALLAR', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: _black)),
                          const SizedBox(height: 8),
                          const Text('Alt dal = Mesleğin kendisi. Tıkla, mesleğin seçilsin!', style: TextStyle(fontSize: 9, color: _gray)),
                          const SizedBox(height: 12),
                          ...seciliAna.altDallar.map((alt) {
                            final isAltSel = _secilenAltDalId == alt.id;
                            return GestureDetector(
                              onTap: () => setState(() {
                                _secilenAltDalId = alt.id;
                                _secilenUnvanId = alt.unvanIds.isNotEmpty ? alt.unvanIds.first : null;
                              }),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isAltSel ? _black : Colors.white,
                                  border: Border.all(color: isAltSel ? _gold : Colors.black12, width: isAltSel ? 1.2 : 0.8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(width: 4, height: 4, decoration: BoxDecoration(color: isAltSel ? _gold : _black, shape: BoxShape.circle)),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text('${alt.id} ${alt.ad}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isAltSel ? Colors.white : _black))),
                                        if (isAltSel) const Icon(Icons.check_circle, size: 16, color: _gold),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${alt.unvanIds.length} unvan • ${alt.uzmanlikIds.length} uzmanlık • ${alt.hizmetIds.length} hizmet', style: TextStyle(fontSize: 8, color: isAltSel ? Colors.white54 : _gray)),
                                  ],
                                ),
                              ),
                            );
                          }),
                          if (seciliAlt != null) ...[
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 8),
                            const Text('UNVAN SEÇ (ZORUNLU)', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _black, letterSpacing: 1)),
                            const SizedBox(height: 8),
                            ...seciliAlt.unvanIds.map((u) => RadioListTile<String>(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(u, style: const TextStyle(fontSize: 12, color: _black, fontWeight: FontWeight.w600)),
                              value: u,
                              groupValue: _secilenUnvanId,
                              activeColor: _gold,
                              onChanged: (v) => setState(() => _secilenUnvanId = v),
                            )),
                            const SizedBox(height: 12),
                            const Text('UZMANLIK (OPSİYONEL - MULTI)', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _black)),
                            ...seciliAlt.uzmanlikIds.map((uz) => CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              value: _secilenUzmanlik.contains(uz),
                              activeColor: _black,
                              checkColor: Colors.white,
                              title: Text(uz, style: const TextStyle(fontSize: 11, color: _black)),
                              onChanged: (v) => setState(() => v! ? _secilenUzmanlik.add(uz) : _secilenUzmanlik.remove(uz)),
                            )),
                            const SizedBox(height: 8),
                            const Text('HİZMET (OPSİYONEL - MULTI)', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _black)),
                            ...seciliAlt.hizmetIds.map((h) => CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              value: _secilenHizmet.contains(h),
                              activeColor: _black,
                              checkColor: Colors.white,
                              title: Text(h, style: const TextStyle(fontSize: 11, color: _black)),
                              onChanged: (v) => setState(() => v! ? _secilenHizmet.add(h) : _secilenHizmet.remove(h)),
                            )),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: _gold, foregroundColor: _black, padding: const EdgeInsets.symmetric(vertical: 14)),
                                onPressed: _secilenUnvanId == null
                                    ? null
                                    : () {
                                  final yeni = ProfesyonelDalSecimi(
                                    anaDalId: seciliAna.id,
                                    altDalId: seciliAlt.id,
                                    unvanId: _secilenUnvanId!,
                                    uzmanlikIds: _secilenUzmanlik.toList(),
                                    hizmetIds: _secilenHizmet.toList(),
                                  );
                                  setState(() {
                                    _geciciSecilenler.add(yeni);
                                    _secilenAltDalId = null;
                                    _secilenUnvanId = null;
                                    _secilenUzmanlik.clear();
                                    _secilenHizmet.clear();
                                  });
                                },
                                child: const Text('BU MESLEĞİ LİSTEYE EKLE + BAŞKA EKLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                          if (_geciciSecilenler.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: _offWhite, border: Border.all(color: _gold.withOpacity(0.3))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('BU OTURUMDA EKLENENLER (${_geciciSecilenler.length})', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _black)),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: _geciciSecilenler.map((m) {
                                      final ana = HugProMasterOntologyV5.anaDallar.firstWhere((a) => a.id == m.anaDalId);
                                      final alt = ana.altDallar.firstWhere((a) => a.id == m.altDalId);
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: _black, borderRadius: BorderRadius.circular(3)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('${ana.ad}/${alt.ad}', style: const TextStyle(fontSize: 9, color: Colors.white)),
                                            const SizedBox(width: 6),
                                            GestureDetector(onTap: () => setState(() => _geciciSecilenler.remove(m)), child: const Icon(Icons.close, size: 12, color: _gold)),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
              child: Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('İPTAL', style: TextStyle(color: _gray)))),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: _geciciSecilenler.isEmpty ? null : () => Navigator.pop(context, _geciciSecilenler),
                      child: Text('TAMAM - ${_geciciSecilenler.length} MESLEK EKLE', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatefulWidget {
  const _HeroHeader();
  @override
  State<_HeroHeader> createState() => _HeroHeaderState();
}

class _HeroHeaderState extends State<_HeroHeader> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _hugFade, _lineFade, _projeFade, _titleFade;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _hugFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.25, curve: Curves.easeOut));
    _lineFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.15, 0.40, curve: Curves.easeOut));
    _projeFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.40, 0.60, curve: Curves.easeOut));
    _titleFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.55, 0.85, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        FadeTransition(opacity: _hugFade, child: const Text('H U G', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300, letterSpacing: 9))),
        const SizedBox(height: 16),
        FadeTransition(opacity: _lineFade, child: const _LightSweepLine(width: 88, height: 1)),
        const SizedBox(height: 16),
        FadeTransition(opacity: _projeFade, child: const Text('P R O J E', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w300, letterSpacing: 7))),
        const SizedBox(height: 20),
        FadeTransition(opacity: _titleFade, child: const Text('BÜYÜK PROJELER - YAPI - TEKNİK', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 3.5))),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _LightSweepLine extends StatefulWidget {
  final double width;
  final double height;
  const _LightSweepLine({this.width = 88, this.height = 1});
  @override
  State<_LightSweepLine> createState() => _LightSweepLineState();
}

class _LightSweepLineState extends State<_LightSweepLine> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(period: const Duration(milliseconds: 4200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(width: widget.width, height: 10, child: AnimatedBuilder(animation: _controller, builder: (_, __) => CustomPaint(painter: _LightSweepPainter(progress: _controller.value))));
}

class _LightSweepPainter extends CustomPainter {
  final double progress;
  _LightSweepPainter({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final basePaint = Paint()..color = _gold.withOpacity(0.7)..strokeWidth = 1;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), basePaint);
    final lightX = progress * (size.width + 30) - 15;
    final gradient = LinearGradient(colors: [Colors.transparent, _gold.withOpacity(0.08), _gold.withOpacity(0.6), Colors.white.withOpacity(0.75), _gold.withOpacity(0.6), _gold.withOpacity(0.08), Colors.transparent]);
    final rect = Rect.fromCenter(center: Offset(lightX, y), width: 30, height: 1.5);
    final lightPaint = Paint()..shader = gradient.createShader(rect)..strokeWidth = 1.5;
    canvas.drawLine(Offset(lightX - 15, y), Offset(lightX + 15, y), lightPaint);
  }

  @override
  bool shouldRepaint(covariant _LightSweepPainter old) => old.progress != progress;
}

class _ArchGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.03)..strokeWidth = 0.5;
    canvas.drawLine(Offset(size.width * 0.15, 0), Offset(size.width * 0.15, size.height), p);
    canvas.drawLine(Offset(size.width * 0.85, 0), Offset(size.width * 0.85, size.height), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _CtaWithLight extends StatefulWidget {
  final String label;
  final bool big;
  final double intensity;
  final VoidCallback? onTap;
  const _CtaWithLight({required this.label, this.big = false, this.intensity = 0.70, this.onTap});
  @override
  State<_CtaWithLight> createState() => _CtaWithLightState();
}

class _CtaWithLightState extends State<_CtaWithLight> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(period: const Duration(milliseconds: 3500));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final whiteOpacity = 0.15 + (widget.intensity * 0.10);
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: widget.big ? 28 : 20, vertical: widget.big ? 16 : 12),
              color: _gold,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.label, style: TextStyle(color: _black, fontSize: widget.big ? 11 : 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const SizedBox(width: 12),
                  Container(width: widget.big ? 28 : 20, height: 1, color: Colors.black54),
                ],
              ),
            ),
            Positioned.fill(
              child: ClipRect(
                child: Transform.translate(
                  offset: Offset((_controller.value * 200) - 50, 0),
                  child: Container(width: 36, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.white.withOpacity(whiteOpacity), Colors.transparent]))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
