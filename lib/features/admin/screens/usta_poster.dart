import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minio/minio.dart';
import 'package:ustam_gelsin/env.dart';
import 'package:slugify/slugify.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UstaPosterScreen extends StatefulWidget {
  const UstaPosterScreen({super.key});

  @override
  State<UstaPosterScreen> createState() => _UstaPosterScreenState();
}

class _UstaPosterScreenState extends State<UstaPosterScreen> {
  // --- CONTROLLERS ---
  final idController = TextEditingController(); // YENİ - UID GİRİŞ
  final adController = TextEditingController();
  final ilController = TextEditingController();
  final ilceController = TextEditingController();
  final hizmetController = TextEditingController();

  XFile? secilenResim;
  bool yukleniyor = false;
  bool idSorgulaniyor = false;

  String? duzenlenenDocId;
  String? mevcutImagePath;

  // Şehir/İlçe JSON için
  dynamic _sehirler;
  dynamic _ilceler;
  String? aktifUstaDocId; // çekilen ustanın gerçek uid'si - poster ile ilişkilendirmek için

  @override
  void initState() {
    super.initState();
    _loadLocationData();
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
    return Minio(
      endPoint: host,
      accessKey: Env.r2FlutterAccessKey,
      secretKey: Env.r2FlutterSecretKey,
      useSSL: true,
      region: 'auto',
    );
  }

  // === YENİ - UID İLE USTAYI ÇEK VE FORMA BAS ===
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

      // Şehir / İlçe ID -> İsim çevir
      String sehirIsmi = _getName(_sehirler, data['sehir_id'], 'sehir_id', 'sehir_adi');
      String ilceIsmi = _getName(_ilceler, data['ilce_id'], 'ilce_id', 'ilce_adi');
      // Eğer zaten isim tutuluyorsa fallback
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
    await minio.putObject(
      'ustam-gelsin-medya',
      yol,
      Stream.value(bytes),
      size: bytes.length,
      metadata: {'Content-Type': 'image/webp'},
    );
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
        'ustaRefId': aktifUstaDocId?? idController.text.trim(), // YENİ - hangi ustadan geldiği
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
    return Scaffold(
      appBar: AppBar(title: const Text('Usta Posterleri - ID ile Çek')),
      body: isWide
          ? Row(children: [Expanded(flex: 4, child: _solForm()), const VerticalDivider(width: 1), Expanded(flex: 5, child: _sagListe())])
          : SingleChildScrollView(child: Column(children: [_solForm(), const Divider(), _sagListe()])),
    );
  }

  Widget _solForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(duzenlenenDocId == null? 'Yeni Usta Ekle' : 'Düzenle: $duzenlenenDocId', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // === YENİ ID ALANI ===
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'Usta Sistem ID (UID) - Kopyaladığını yapıştır', hintText: '3OWlEHBsXORKzdtvySYpYDyl5Vk1', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 8),
              idSorgulaniyor
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: ustayiIdIleCek,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(80, 50)),
                child: const Text('ARA'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('ID yazıp ARA deyince ad / il / ilçe / uzmanlık otomatik dolacak', style: TextStyle(fontSize: 11, color: Colors.grey)),
          const Divider(height: 32),
          TextField(controller: adController, decoration: const InputDecoration(labelText: 'Usta Adı Soyadı')),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: TextField(controller: ilController, decoration: const InputDecoration(labelText: 'İl'))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: ilceController, decoration: const InputDecoration(labelText: 'İlçe'))),
            ],
          ),
          const SizedBox(height: 12),
          TextField(controller: hizmetController, decoration: const InputDecoration(labelText: 'Ustalık Alanları (virgülle)', hintText: 'İç cephe boya, Fayans...')),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final resim = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (resim!= null) setState(() => secilenResim = resim);
            },
            child: Text(secilenResim == null? (mevcutImagePath == null? 'Poster Resmi Seç' : 'Mevcut: $mevcutImagePath - Değiştir') : 'Resim Seçildi ✓'),
          ),
          const SizedBox(height: 24),
          yukleniyor
              ? const Center(child: CircularProgressIndicator())
              : Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: kaydet,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)),
                  child: Text(duzenlenenDocId == null? 'POSTERİ YAYINLA' : 'GÜNCELLE', style: const TextStyle(fontSize: 16)),
                ),
              ),
              if (duzenlenenDocId!= null)...[
                const SizedBox(width: 12),
                ElevatedButton(onPressed: temizleForm, child: const Text('İptal')),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _sagListe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.all(16), child: Text('Yayınlanan Posterler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('karisik_slider').orderBy('tarih', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('Henüz poster yok'));
              return ListView.separated(
                itemCount: docs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final data = docs[i].data() as Map<String, dynamic>;
                  final baslik = data['baslik']?? 'İsimsiz';
                  final ilRaw = data['ilRaw']?? data['il']?? '';
                  final ilceRaw = data['ilceRaw']?? data['ilce']?? '';
                  final konum = (ilRaw.toString().isEmpty && ilceRaw.toString().isEmpty)? 'Şehir boş' : '$ilRaw / $ilceRaw';
                  return ListTile(
                    title: Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(konum),
                    trailing: const Icon(Icons.edit),
                    onTap: () => duzenleModunaGec(docs[i]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}