// lib/features/admin/screens/usta_poster.dart - V3 FINAL - BEYAZDA OKUNAN - TAM
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minio/minio.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:slugify/slugify.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UstaPosterScreen extends StatefulWidget {
  final VoidCallback? onNavigateHome;
  const UstaPosterScreen({super.key, this.onNavigateHome});

  @override
  State<UstaPosterScreen> createState() => _UstaPosterScreenState();
}

class _UstaPosterScreenState extends State<UstaPosterScreen> {
  final idController = TextEditingController();
  final adController = TextEditingController();
  final ilController = TextEditingController();
  final ilceController = TextEditingController();
  final hizmetController = TextEditingController();

  XFile? secilenResim;
  bool yukleniyor = false;
  bool idSorgulaniyor = false;

  String? duzenlenenDocId;
  String? mevcutImagePath;

  dynamic _sehirler;
  dynamic _ilceler;
  String? aktifUstaDocId;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  @override
  void dispose() {
    idController.dispose();
    adController.dispose();
    ilController.dispose();
    ilceController.dispose();
    hizmetController.dispose();
    super.dispose();
  }

  Future<void> _loadLocationData() async {
    try {
      final sehirJson = await rootBundle.loadString('assets/data/sehirler.json');
      final ilceJson = await rootBundle.loadString('assets/data/ilceler.json');
      setState(() {
        _sehirler = json.decode(sehirJson);
        _ilceler = json.decode(ilceJson);
      });
    } catch (_) {}
  }

  String _getName(dynamic data, dynamic id, String idKey, String nameKey) {
    if (id == null || data == null || data is! List) return id?.toString()?? "";
    for (var item in data) {
      if (item[idKey]?.toString() == id.toString()) {
        return item[nameKey]?.toString()?? id.toString();
      }
    }
    return id.toString();
  }

  Minio _minioClient() {
    final endpoint = Env.r2FlutterEndpoint;
    final host = endpoint.replaceAll('https://', '').replaceAll('http://', '').split('/').first.trim();
    return Minio(endPoint: host, accessKey: Env.r2FlutterAccessKey, secretKey: Env.r2FlutterSecretKey, useSSL: true, region: 'auto');
  }

  Future<void> ustayiIdIleCek() async {
    final uid = idController.text.trim();
    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Önce ID yapıştır kanka')));
      return;
    }
    setState(() => idSorgulaniyor = true);
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bu ID ile usta bulunamadı')));
        return;
      }
      final data = doc.data() as Map<String, dynamic>;
      final firstName = data['firstName']?? data['name']?? "";
      final lastName = data['lastName']?? "";
      final adSoyad = "$firstName $lastName".trim();
      String sehirIsmi = _getName(_sehirler, data['sehir_id'], 'sehir_id', 'sehir_adi');
      String ilceIsmi = _getName(_ilceler, data['ilce_id'], 'ilce_id', 'ilce_adi');
      if (sehirIsmi.isEmpty) sehirIsmi = data['sehir']?? data['il']?? "";
      if (ilceIsmi.isEmpty) ilceIsmi = data['ilce']?? "";
      List<dynamic> uzmanliklar = data['uzmanliklar']?? [];
      setState(() {
        aktifUstaDocId = doc.id;
        adController.text = adSoyad;
        ilController.text = sehirIsmi;
        ilceController.text = ilceIsmi;
        hizmetController.text = uzmanliklar.join(', ');
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Çekildi: $adSoyad - $sehirIsmi/$ilceIsmi')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    } finally {
      if (mounted) setState(() => idSorgulaniyor = false);
    }
  }

  Future<String?> resimYukle(String slug, int ts) async {
    if (secilenResim == null) return mevcutImagePath;
    final minio = _minioClient();
    final bytes = await secilenResim!.readAsBytes();
    final dosyaAdi = '$slug-$ts.webp';
    final yol = 'images/ustalar/$dosyaAdi';
    await minio.putObject('ustam-gelsin-medya', yol, Stream.value(bytes), size: bytes.length, metadata: {'Content-Type': 'image/webp'});
    return yol;
  }

  Future<void> kaydet() async {
    if (adController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usta adı zorunlu kanka')));
      return;
    }
    if (secilenResim == null && mevcutImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Poster resmi zorunlu')));
      return;
    }
    setState(() => yukleniyor = true);
    try {
      final slug = slugify(adController.text.trim(), lowercase: true, delimiter: '-');
      final ts = DateTime.now().millisecondsSinceEpoch;
      final imagePath = await resimYukle(slug, ts);
      final docId = duzenlenenDocId?? slug;
      final data = {
        'baslik': adController.text.trim(),
        'slug': slug,
        'imagePath': imagePath,
        'il': ilController.text.trim().toLowerCase(),
        'ilce': ilceController.text.trim().toLowerCase(),
        'ilRaw': ilController.text.trim(),
        'ilceRaw': ilceController.text.trim(),
        'hizmetler': hizmetController.text.trim().split(',').map((e) => e.trim().toLowerCase()).where((e) => e.isNotEmpty).toList(),
        'hizmetlerRaw': hizmetController.text.trim(),
        'tamKonum': '${ilController.text.trim().toLowerCase()}/${ilceController.text.trim().toLowerCase()}',
        'tarih': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'aktif': true,
        'ustaRefId': aktifUstaDocId?? idController.text.trim(),
      };
      await FirebaseFirestore.instance.collection('karisik_slider').doc(docId).set(data, SetOptions(merge: true));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(duzenlenenDocId == null? 'YAYINDA: $slug OK' : 'GÜNCELLENDİ: $slug')));
      temizleForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), duration: const Duration(seconds: 5)));
    } finally {
      if (mounted) setState(() => yukleniyor = false);
    }
  }

  void temizleForm() {
    idController.clear();
    adController.clear();
    ilController.clear();
    ilceController.clear();
    hizmetController.clear();
    setState(() {
      secilenResim = null;
      duzenlenenDocId = null;
      mevcutImagePath = null;
      aktifUstaDocId = null;
    });
  }

  void duzenleModunaGec(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    setState(() {
      duzenlenenDocId = doc.id;
      aktifUstaDocId = data['ustaRefId'];
      idController.text = data['ustaRefId']?? "";
      adController.text = data['baslik']?? '';
      ilController.text = data['ilRaw']?? data['il']?? '';
      ilceController.text = data['ilceRaw']?? data['ilce']?? '';
      hizmetController.text = data['hizmetlerRaw']?? (data['hizmetler'] as List?)?.join(', ')?? '';
      mevcutImagePath = data['imagePath'];
      secilenResim = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(duzenlenenDocId == null? 'Usta Posterleri - ID ile Çek' : 'Düzenleniyor: $duzenlenenDocId',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
          backgroundColor: const Color(0xFF111111),
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            if (widget.onNavigateHome!= null)
              IconButton(icon: const Icon(Icons.home, color: Colors.white), onPressed: widget.onNavigateHome),
          ],
        ),
        body: isWide
            ? Row(children: [Expanded(flex: 4, child: _solForm()), const VerticalDivider(width: 1, color: Color(0xFFDDDDDD)), Expanded(flex: 5, child: _sagListeWide())])
            : _solFormMobile(),
      ),
    );
  }

  Widget _solFormMobile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _solFormContent(),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFDDDDDD), thickness: 1),
          const SizedBox(height: 12),
          const Text('Yayınlanan Posterler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 12),
          _sagListeContent(isMobile: true),
        ],
      ),
    );
  }

  Widget _solForm() {
    return Container(color: Colors.white, child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: _solFormContent()));
  }

  Widget _solFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(duzenlenenDocId == null? 'Yeni Usta Ekle' : 'Düzenle: $duzenlenenDocId',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: TextField(
              controller: idController,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Usta Sistem ID (UID)',
                hintText: '3OWlEHBsXORKzdtvySYpYDyl5Vk1',
                labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12),
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 11),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.8)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          idSorgulaniyor
              ? const SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator(color: Colors.black)))
              : ElevatedButton(
            onPressed: ustayiIdIleCek,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, foregroundColor: Colors.white, minimumSize: const Size(80, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('ARA', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ]),
        const SizedBox(height: 8),
        const Text('ID yazıp ARA deyince ad / il / ilçe / uzmanlık otomatik dolacak',
            style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500)),
        const Divider(height: 32, color: Color(0xFFDDDDDD)),
        TextField(
          controller: adController,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            labelText: 'Usta Adı Soyadı *',
            labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.8)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: TextField(
              controller: ilController,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: 'İl',
                labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: ilceController,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: 'İlçe',
                labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        TextField(
          controller: hizmetController,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13),
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Ustalık Alanları (virgülle)',
            hintText: 'İç cephe boya, Fayans, Kalebodur...',
            labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              final resim = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (resim!= null) setState(() => secilenResim = resim);
            },
            icon: Icon(secilenResim!= null? Icons.check_circle : Icons.image, color: secilenResim!= null? Colors.green : Colors.black),
            label: Text(
              secilenResim == null
                  ? (mevcutImagePath == null? 'Poster Resmi Seç *' : 'Mevcut: ${mevcutImagePath!.split('/').last} - Değiştir')
                  : 'Resim Seçildi ✓ ${secilenResim!.name}',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              side: const BorderSide(color: Colors.black, width: 1.5),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        if (secilenResim!= null || mevcutImagePath!= null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(secilenResim!= null? 'Yeni resim yüklenecek: ${secilenResim!.name}' : 'Mevcut resim kullanılacak: $mevcutImagePath',
                style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w600)),
          ),
        const SizedBox(height: 24),
        yukleniyor
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : Row(children: [
          Expanded(
            child: ElevatedButton(
              onPressed: kaydet,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: Text(duzenlenenDocId == null? 'POSTERİ YAYINLA' : 'GÜNCELLE',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          if (duzenlenenDocId!= null)...[
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: temizleForm,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, foregroundColor: Colors.black, side: const BorderSide(color: Colors.black, width: 1.5), minimumSize: const Size(80, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('İptal', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
            )
          ]
        ]),
      ],
    );
  }

  Widget _sagListeWide() {
    return Container(
      color: const Color(0xFFFAFAFA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: const Text('Yayınlanan Posterler', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1))),
          Expanded(child: _sagListeContent(isMobile: false)),
        ],
      ),
    );
  }

  Widget _sagListeContent({required bool isMobile}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('karisik_slider').orderBy('tarih', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.black));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Henüz poster yok kanka', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))));
        }
        final docs = snapshot.data!.docs;
        return isMobile
            ? ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final baslik = data['baslik']?? 'İsimsiz';
            final ilRaw = data['ilRaw']?? data['il']?? '';
            final ilceRaw = data['ilceRaw']?? data['ilce']?? '';
            final konum = (ilRaw.toString().isEmpty && ilceRaw.toString().isEmpty)? 'Şehir boş' : '$ilRaw / $ilceRaw';
            return _buildTile(baslik, konum, data, docs[i]);
          },
        )
            : ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final baslik = data['baslik']?? 'İsimsiz';
            final ilRaw = data['ilRaw']?? data['il']?? '';
            final ilceRaw = data['ilceRaw']?? data['ilce']?? '';
            final konum = (ilRaw.toString().isEmpty && ilceRaw.toString().isEmpty)? 'Şehir boş' : '$ilRaw / $ilceRaw';
            return _buildTile(baslik, konum, data, docs[i]);
          },
        );
      },
    );
  }

  Widget _buildTile(String baslik, String konum, Map<String, dynamic> data, DocumentSnapshot doc) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFDDDDDD), width: 1.2)),
      child: ListTile(
        leading: Container(
            width: 40, height: 40, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.person, color: Colors.white, size: 20)),
        title: Text(baslik, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.black)),
        subtitle: Text(konum, style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500)),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (data['ustaRefId']!= null)
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                child: const Text('ID OK', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
          const SizedBox(width: 6),
          const Icon(Icons.edit, size: 18, color: Colors.black),
        ]),
        onTap: () => duzenleModunaGec(doc),
      ),
    );
  }
}