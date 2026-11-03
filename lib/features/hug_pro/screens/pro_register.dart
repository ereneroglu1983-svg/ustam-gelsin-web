import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  bool _loading = false;

  final List<ProfesyonelDalSecimi> _secilenMeslekler = [];
  final List<Map<String, dynamic>> _belgeler = [];
  XFile? _profilFoto;
  Uint8List? _profilFotoBytes;

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Şifre zorunlu';
    if (v.length < 8) return 'En az 8 karakter';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return '1 büyük harf';
    if (!RegExp(r'[a-z]').hasMatch(v)) return '1 küçük harf';
    if (!RegExp(r'[^\w\s]').hasMatch(v)) return '1 noktalama (.!*? vs)';
    return null;
  }

  // R2 - DYNAMIC WRAPPER - COMPILE HATASI YEMEMEK İÇİN
  Future<String> _uploadBytesR2(Uint8List bytes, String path) async {
    final dynamic r2d = _r2;
    try {
      final res = await r2d.uploadBytes(bytes, path);
      return res as String;
    } catch (_) {}
    try {
      final res = await r2d.uploadBytes(bytes: bytes, path: path);
      return res as String;
    } catch (_) {}
    try {
      final res = await r2d.uploadBytes(fileBytes: bytes, fileName: path);
      return res as String;
    } catch (_) {}
    try {
      final res = await r2d.uploadBytes(bytes, fileName: path);
      return res as String;
    } catch (e) {
      throw Exception('R2 uploadBytes failed: $e');
    }
  }

  Future<String> _uploadFileR2(File file, String path) async {
    final dynamic r2d = _r2;
    try {
      final res = await r2d.uploadFile(file, path);
      return res as String;
    } catch (_) {}
    try {
      final res = await r2d.uploadFile(file: file, path: path);
      return res as String;
    } catch (_) {}
    try {
      final res = await r2d.uploadFile(file, fileName: path);
      return res as String;
    } catch (e) {
      throw Exception('R2 uploadFile failed: $e');
    }
  }

  Future<void> _openAnaDalSelector() async {
    final seciliAnaDallar = <String>{};
    for (var m in _secilenMeslekler) seciliAnaDallar.add(m.anaDalId);
    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) => _AnaDalMultiSelectDialog(initialSelected: seciliAnaDallar),
    );
    if (result == null) return;
    for (var anaId in result) {
      if (_secilenMeslekler.any((e) => e.anaDalId == anaId)) continue;
      final altSecim = await showDialog<ProfesyonelDalSecimi>(
        context: context,
        builder: (_) => _AltDalSecimDialog(anaDalId: anaId),
      );
      if (altSecim != null) {
        setState(() => _secilenMeslekler.add(altSecim));
      }
    }
    setState(() {});
  }

  Future<void> _pickProfilFoto() async {
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x != null) {
      final bytes = await x.readAsBytes();
      setState(() { _profilFoto = x; _profilFotoBytes = bytes; });
    }
  }

  Future<void> _addBelge() async {
    final belgeTuru = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Belge Türü Seç (Admin onaylayacak)'),
        children: [
          for (var t in ['DIPLOMA','ODA_KAYIT','MYK_BELGE','YETKI_BELGESI','VERGI_LEVHASI','USTALIK_BELGESI','SANTIYE_SEFLIGI','YAPI_DENETIM_YETKI','ISG_YETKI','EKB_YETKI'])
            SimpleDialogOption(child: Text(t), onPressed: () => Navigator.pop(context, t)),
        ],
      ),
    );
    if (belgeTuru == null) return;
    final noCtrl = TextEditingController();
    final no = await showDialog<String>(context: context, builder: (_) => AlertDialog(title: Text('$belgeTuru No'), content: TextField(controller: noCtrl, decoration: const InputDecoration(hintText: 'Belge numarasını gir')), actions: [TextButton(onPressed: () => Navigator.pop(context, noCtrl.text), child: const Text('Tamam'))]));
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    setState(() => _belgeler.add({'belgeTuru': belgeTuru, 'belgeNo': no ?? '', 'file': file, 'dogrulamaDurumu': 'BEKLEMEDE', 'aktifYetki': false}));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_kvkkOnay) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('KVKK onayı zorunlu'))); return; }
    if (_secilenMeslekler.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('En az 1 meslek seç'))); return; }
    if (_pass1Ctrl.text != _pass2Ctrl.text) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Şifreler eşleşmiyor'))); return; }
    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailCtrl.text.trim(), password: _pass1Ctrl.text);
      final uid = cred.user!.uid;

      // FCM TOKEN - PRO'NUN KENDİ TELEFONU İÇİN - ONAYLANDIĞINDA PUSH GİTMESİ İÇİN ŞART
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
        uploadedBelgeler.add({'belgeTuru': b['belgeTuru'], 'belgeNo': b['belgeNo'], 'belgeUrl': url, 'dogrulamaDurumu': 'BEKLEMEDE', 'aktifYetki': false, 'yuklenmeTarihi': FieldValue.serverTimestamp()});
      }
      final maskedTc = _kayitTipi == KayitTipi.sahis && _tcCtrl.text.length == 11 ? '*** *** ${_tcCtrl.text.substring(7)}' : '';
      await FirebaseFirestore.instance.collection('users_pro').doc(uid).set({
        'uid': uid, 'kayitTipi': _kayitTipi.name, 'tcMasked': maskedTc, 'tcHash': _tcCtrl.text.hashCode,
        'ad': _adCtrl.text, 'soyad': _soyadCtrl.text,
        'vergiNo': _vdCtrl.text, 'vergiDairesi': _vergiDairesiCtrl.text, 'mersisNo': _mersisCtrl.text, 'sirketUnvan': _sirketUnvanCtrl.text, 'yetkiliAdSoyad': _yetkiliCtrl.text,
        'email': _emailCtrl.text.trim(), 'telefon': _telCtrl.text, 'adres': _adresCtrl.text,
        'profilFotoUrl': profilFotoUrl,
        'meslekler': _secilenMeslekler.map((e) => e.toJson()).toList(),
        'belgeler': uploadedBelgeler,
        'durum': 'ONAY_BEKLIYOR', 'isActive': false, 'isVerified': false,
        'fcmToken': fcmToken,
        'fcmTokens': fcmToken != null ? [fcmToken] : [],
        'kvkkOnay': true, 'kvkkOnayTarihi': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      await FirebaseFirestore.instance.collection('admin_onay_bekleyenler').doc(uid).set({'uid': uid, 'tip': 'PROFESYONEL', 'email': _emailCtrl.text, 'createdAt': FieldValue.serverTimestamp()});
      if (!mounted) return;
      showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(backgroundColor: _dark, title: const Text('Başvurunuz Alındı', style: TextStyle(color: Colors.white)), content: const Text('Bilgileriniz incelenmek üzere alındı. Kısa süre içinde onaylanacak ve size bildirim göndereceğiz.', style: TextStyle(color: Colors.white70)), actions: [TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('Tamam', style: TextStyle(color: _gold)))]));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Hata')));
    } finally { setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
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
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 48),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Container(width: 32, height: 1, color: _gold), const SizedBox(width: 10), const Text('KAYIT TİPİ', style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: _gray))]),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                      child: SegmentedButton<KayitTipi>(
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? _black : Colors.transparent), foregroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : Colors.black)),
                        segments: const [ButtonSegment(value: KayitTipi.sahis, label: Text('ŞAHIS'), icon: Icon(Icons.person, size: 14)), ButtonSegment(value: KayitTipi.sirket, label: Text('ŞİRKET'), icon: Icon(Icons.business, size: 14))],
                        selected: {_kayitTipi},
                        onSelectionChanged: (s) => setState(() => _kayitTipi = s.first),
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (_kayitTipi == KayitTipi.sahis) ...[
                      Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('ŞAHIS BİLGİLERİ', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                      const SizedBox(height: 16),
                      TextFormField(controller: _tcCtrl, decoration: const InputDecoration(labelText: 'TC NO (11 HANE)', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold))), maxLength: 11, keyboardType: TextInputType.number, validator: (v) => v!.length != 11 ? '11 hane' : null),
                      TextFormField(controller: _adCtrl, decoration: const InputDecoration(labelText: 'AD', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold))), validator: (v) => v!.isEmpty ? 'Zorunlu' : null),
                      TextFormField(controller: _soyadCtrl, decoration: const InputDecoration(labelText: 'SOYAD', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold))), validator: (v) => v!.isEmpty ? 'Zorunlu' : null),
                    ] else ...[
                      Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('ŞİRKET BİLGİLERİ', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                      const SizedBox(height: 16),
                      TextFormField(controller: _vdCtrl, decoration: const InputDecoration(labelText: 'VERGİ NO', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold))), validator: (v) => v!.isEmpty ? 'Zorunlu' : null),
                      TextFormField(controller: _vergiDairesiCtrl, decoration: const InputDecoration(labelText: 'VERGİ DAİRESİ', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold)))),
                      TextFormField(controller: _mersisCtrl, decoration: const InputDecoration(labelText: 'MERSİS NO (VARSA)', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold)))),
                      TextFormField(controller: _sirketUnvanCtrl, decoration: const InputDecoration(labelText: 'ŞİRKET UNVANI', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold))), validator: (v) => v!.isEmpty ? 'Zorunlu' : null),
                      TextFormField(controller: _yetkiliCtrl, decoration: const InputDecoration(labelText: 'YETKİLİ AD SOYAD', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold))), validator: (v) => v!.isEmpty ? 'Zorunlu' : null),
                    ],
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('İLETİŞİM', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                    const SizedBox(height: 16),
                    TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'E-MAIL', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold))), validator: (v) => !v!.contains('@') ? 'Geçersiz' : null),
                    TextFormField(controller: _telCtrl, decoration: const InputDecoration(labelText: 'TELEFON', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold)))),
                    TextFormField(controller: _adresCtrl, decoration: const InputDecoration(labelText: 'ADRES', labelStyle: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _gold))), maxLines: 2),
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('PROFİL FOTOĞRAFI', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _profilFotoBytes != null ? CircleAvatar(radius: 24, backgroundImage: MemoryImage(_profilFotoBytes!)) : Container(width: 48, height: 48, decoration: BoxDecoration(border: Border.all(color: Colors.black12)), child: const Icon(Icons.camera_alt, size: 18, color: _gray)),
                      title: const Text('Profil Fotoğrafı (R2)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      subtitle: const Text('users_pro/{uid}/profil/', style: TextStyle(fontSize: 8, color: _gray)),
                      trailing: Container(width: 36, height: 36, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6D6D6), width: 0.8), shape: BoxShape.circle), child: const Icon(Icons.arrow_outward, size: 14, color: _gray)),
                      onTap: _pickProfilFoto,
                    ),
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('MESLEKİ YETERLİLİK (12 ANA DAL - ÇOKLU)', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                    const SizedBox(height: 16),
                    Wrap(spacing: 8, runSpacing: 8, children: _secilenMeslekler.map((m) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(border: Border.all(color: _gold.withOpacity(0.3))), child: Row(mainAxisSize: MainAxisSize.min, children: [Text('${m.anaDalId}/${m.altDalId} - ${m.unvanId}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)), const SizedBox(width: 8), GestureDetector(onTap: () => setState(() => _secilenMeslekler.remove(m)), child: const Icon(Icons.close, size: 12))]))).toList()),
                    const SizedBox(height: 12),
                    _CtaWithLight(label: '12 ANA DAL\'DAN MESLEK EKLE', intensity: 0.6, onTap: _openAnaDalSelector),
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('RESMİ BELGELER (ADMİN ONAYI ŞART)', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                    const SizedBox(height: 16),
                    ..._belgeler.map((b) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black12)), child: Row(children: [Container(width: 4, height: 4, decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text('${b['belgeTuru']} - No: ${b['belgeNo']}', style: const TextStyle(fontSize: 11))), const Text('BEKLEMEDE', style: TextStyle(fontSize: 7, letterSpacing: 1, color: _gray))]))),
                    const SizedBox(height: 8),
                    GestureDetector(onTap: _addBelge, child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6D6D6), width: 0.8)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.upload_file, size: 14, color: _gray), SizedBox(width: 8), Text('BELGE EKLE (DİPLOMA / ODA / MYK / YETKİ)', style: TextStyle(fontSize: 10, letterSpacing: 1))]))),
                    const SizedBox(height: 32),
                    Row(children: [Container(width: 24, height: 1, color: _gold), const SizedBox(width: 8), const Text('ŞİFRE', style: TextStyle(fontSize: 8, letterSpacing: 2, color: _gray))]),
                    const SizedBox(height: 16),
                    TextFormField(controller: _pass1Ctrl, obscureText: _obscure1, decoration: InputDecoration(labelText: 'ŞİFRE (8+ 1 BÜYÜK 1 KÜÇÜK 1 NOKTALAMA)', labelStyle: const TextStyle(fontSize: 9, letterSpacing: 1, color: _gray), enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _gold)), suffixIcon: IconButton(icon: Icon(_obscure1 ? Icons.visibility : Icons.visibility_off, size: 16), onPressed: () => setState(() => _obscure1 = !_obscure1))), validator: _validatePassword),
                    TextFormField(controller: _pass2Ctrl, obscureText: _obscure2, decoration: InputDecoration(labelText: 'ŞİFRE TEKRAR', labelStyle: const TextStyle(fontSize: 9, letterSpacing: 2, color: _gray), enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _gold)), suffixIcon: IconButton(icon: Icon(_obscure2 ? Icons.visibility : Icons.visibility_off, size: 16), onPressed: () => setState(() => _obscure2 = !_obscure2))), validator: (v) => v != _pass1Ctrl.text ? 'Eşleşmiyor' : null),
                    const SizedBox(height: 24),
                    Row(children: [Checkbox(value: _kvkkOnay, activeColor: _black, onChanged: (v) => setState(() => _kvkkOnay = v!)), const Expanded(child: Text('KVKK Aydınlatma Metnini okudum, açık rıza veriyorum', style: TextStyle(fontSize: 10, color: _gray)))]),
                    const SizedBox(height: 32),
                    _loading ? const Center(child: CircularProgressIndicator(color: _gold)) : _CtaWithLight(label: 'KAYIT OL - ONAYA GÖNDER', big: true, intensity: 0.85, onTap: _submit),
                    const SizedBox(height: 40),
                    Container(height: 1, color: Colors.black12),
                    const SizedBox(height: 12),
                    const Text('© 2026 HUG PROJE - PROFESSIONAL', style: TextStyle(color: _gray, fontSize: 8, letterSpacing: 1)),
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

class _AnaDalMultiSelectDialog extends StatefulWidget {
  final Set<String> initialSelected;
  const _AnaDalMultiSelectDialog({required this.initialSelected});
  @override
  State<_AnaDalMultiSelectDialog> createState() => _AnaDalMultiSelectDialogState();
}
class _AnaDalMultiSelectDialogState extends State<_AnaDalMultiSelectDialog> {
  late Set<String> selected;
  @override
  void initState() { super.initState(); selected = {...widget.initialSelected}; }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _offWhite,
      title: const Text('12 ANA DAL SEÇ (MULTI)', style: TextStyle(fontSize: 11, letterSpacing: 2)),
      content: SizedBox(width: double.maxFinite, child: ListView(children: HugProMasterOntologyV5.anaDallar.map((ana) => CheckboxListTile(value: selected.contains(ana.id), activeColor: _black, title: Text('${ana.id} - ${ana.ad}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), subtitle: Text('${ana.altDallar.length} alt dal', style: const TextStyle(fontSize: 9, color: _gray)), onChanged: (v) => setState(() => v! ? selected.add(ana.id) : selected.remove(ana.id)))).toList())),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('İPTAL', style: TextStyle(color: _gray))), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _black), onPressed: () => Navigator.pop(context, selected.toList()), child: const Text('DEVAM', style: TextStyle(color: Colors.white)))],
    );
  }
}

class _AltDalSecimDialog extends StatefulWidget {
  final String anaDalId;
  const _AltDalSecimDialog({required this.anaDalId});
  @override
  State<_AltDalSecimDialog> createState() => _AltDalSecimDialogState();
}
class _AltDalSecimDialogState extends State<_AltDalSecimDialog> {
  String? secilenAltDalId;
  String? secilenUnvanId;
  final Set<String> secilenUzmanlik = {};
  final Set<String> secilenHizmet = {};
  @override
  Widget build(BuildContext context) {
    final anaDal = HugProMasterOntologyV5.anaDallar.firstWhere((e) => e.id == widget.anaDalId);
    final altDallar = anaDal.altDallar;
    final seciliAlt = secilenAltDalId != null ? altDallar.firstWhere((e) => e.id == secilenAltDalId) : null;
    return AlertDialog(
      backgroundColor: _offWhite,
      title: Text('${anaDal.ad} - ALT DAL SEÇ', style: const TextStyle(fontSize: 11, letterSpacing: 1)),
      content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DropdownButton<String>(value: secilenAltDalId, hint: const Text('Alt Dal Seç', style: TextStyle(fontSize: 11)), isExpanded: true, items: altDallar.map((a) => DropdownMenuItem(value: a.id, child: Text('${a.id} ${a.ad}', style: const TextStyle(fontSize: 11)))).toList(), onChanged: (v) => setState(() { secilenAltDalId = v; secilenUnvanId = null; secilenUzmanlik.clear(); secilenHizmet.clear(); })),
        if (seciliAlt != null) ...[
          const Divider(),
          const Text('UNVAN SEÇ', style: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray, fontWeight: FontWeight.bold)),
          ...seciliAlt.unvanIds.map((u) => RadioListTile<String>(title: Text(u, style: const TextStyle(fontSize: 11)), value: u, groupValue: secilenUnvanId, activeColor: _black, onChanged: (v) => setState(() => secilenUnvanId = v))),
          const Divider(),
          const Text('UZMANLIK (MULTI)', style: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray, fontWeight: FontWeight.bold)),
          ...seciliAlt.uzmanlikIds.map((uz) => CheckboxListTile(value: secilenUzmanlik.contains(uz), activeColor: _black, title: Text(uz, style: const TextStyle(fontSize: 10)), onChanged: (v) => setState(() => v! ? secilenUzmanlik.add(uz) : secilenUzmanlik.remove(uz)))),
          const Divider(),
          const Text('HİZMET (MULTI)', style: TextStyle(fontSize: 9, letterSpacing: 2, color: _gray, fontWeight: FontWeight.bold)),
          ...seciliAlt.hizmetIds.map((h) => CheckboxListTile(value: secilenHizmet.contains(h), activeColor: _black, title: Text(h, style: const TextStyle(fontSize: 10)), onChanged: (v) => setState(() => v! ? secilenHizmet.add(h) : secilenHizmet.remove(h)))),
        ]
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İPTAL', style: TextStyle(color: _gray))),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _black), onPressed: secilenAltDalId != null && secilenUnvanId != null ? () { Navigator.pop(context, ProfesyonelDalSecimi(anaDalId: widget.anaDalId, altDalId: secilenAltDalId!, unvanId: secilenUnvanId!, uzmanlikIds: secilenUzmanlik.toList(), hizmetIds: secilenHizmet.toList())); } : null, child: const Text('EKLE', style: TextStyle(color: Colors.white)))
      ],
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
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        FadeTransition(opacity: _hugFade, child: const Text('H U G', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300, letterSpacing: 9))),
        const SizedBox(height: 20),
        FadeTransition(opacity: _lineFade, child: const _LightSweepLine(width: 88, height: 1)),
        const SizedBox(height: 20),
        FadeTransition(opacity: _projeFade, child: const Text('P R O J E', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w300, letterSpacing: 7))),
        const SizedBox(height: 24),
        FadeTransition(opacity: _titleFade, child: const Text('BÜYÜK PROJELER - YAPI - TEKNİK', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 3.5))),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _LightSweepLine extends StatefulWidget {
  final double width; final double height;
  const _LightSweepLine({this.width = 88, this.height = 1});
  @override
  State<_LightSweepLine> createState() => _LightSweepLineState();
}
class _LightSweepLineState extends State<_LightSweepLine> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(period: const Duration(milliseconds: 4200)); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => SizedBox(width: widget.width, height: 10, child: AnimatedBuilder(animation: _controller, builder: (_, __) => CustomPaint(painter: _LightSweepPainter(progress: _controller.value))));
}
class _LightSweepPainter extends CustomPainter {
  final double progress; _LightSweepPainter({required this.progress});
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
  final String label; final bool big; final double intensity; final VoidCallback? onTap;
  const _CtaWithLight({required this.label, this.big = false, this.intensity = 0.70, this.onTap});
  @override
  State<_CtaWithLight> createState() => _CtaWithLightState();
}
class _CtaWithLightState extends State<_CtaWithLight> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(period: const Duration(milliseconds: 3500)); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final whiteOpacity = 0.15 + (widget.intensity * 0.10);
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Stack(children: [
          Container(padding: EdgeInsets.symmetric(horizontal: widget.big ? 28 : 20, vertical: widget.big ? 16 : 12), color: _gold, child: Row(mainAxisSize: MainAxisSize.min, children: [Text(widget.label, style: TextStyle(color: _black, fontSize: widget.big ? 11 : 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(width: 12), Container(width: widget.big ? 28 : 20, height: 1, color: Colors.black54)])),
          Positioned.fill(child: ClipRect(child: Transform.translate(offset: Offset((_controller.value * 200) - 50, 0), child: Container(width: 36, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.white.withOpacity(whiteOpacity), Colors.transparent])))))),
        ]),
      ),
    );
  }
}