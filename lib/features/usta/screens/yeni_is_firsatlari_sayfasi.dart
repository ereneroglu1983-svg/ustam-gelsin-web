// lib/features/usta/screens/yeni_is_firsatlari_sayfasi.dart - REVİZE: YENİDEN ESKİYE
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/theme/usta_theme.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'usta_ilan_detay_sayfasi.dart';

class YeniIsFirsatlariSayfasi extends StatefulWidget {
  const YeniIsFirsatlariSayfasi({super.key});

  @override
  State<YeniIsFirsatlariSayfasi> createState() => _YeniIsFirsatlariSayfariState();
}

class _YeniIsFirsatlariSayfariState extends State<YeniIsFirsatlariSayfasi> {
  final AdService _adService = AdService();
  final AuthService _authService = AuthService();

  String _seciliSirala = "Konuma Göre Yakın";
  String _seciliKategori = "Hepsi";
  List<String> _teklifVerilenIlanlar = [];
  Set<String> _engellenenMusteriler = {};

  double _ustaLat = 0.0;
  double _ustaLng = 0.0;

  final List<String> _isKollari = [
    "Hepsi", "Boya", "Tesisat", "Elektrik", "Mobilya", "Tadilat", "Temizlik", "Zemin", "Çatı", "Isıtma"
  ];

  @override
  void initState() {
    super.initState();
    _teklifleriGetir();
    _kullaniciKonumuYukle();
    _engellenenleriGetir();
  }

  bool _isAcil(IlanModel ilan) => ilan.isAcil == true || (ilan.teknikDetaylar['isAcil'] == true);

  Future<void> _kullaniciKonumuYukle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user!= null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()!= null) {
        final data = doc.data()!;
        setState(() {
          _ustaLat = (data['latitude']?? 0.0).toDouble();
          _ustaLng = (data['longitude']?? 0.0).toDouble();
        });
      }
    }
  }

  Future<void> _teklifleriGetir() async {
    final ustaId = FirebaseAuth.instance.currentUser?.uid;
    if (ustaId == null) return;
    final snapshot = await FirebaseFirestore.instance.collection('teklifler')
        .where('ustaId', isEqualTo: ustaId).get();
    if (mounted) {
      setState(() {
        _teklifVerilenIlanlar = snapshot.docs.map((doc) => doc.get('ilanId') as String).toList();
      });
    }
  }

  // ADIM 1 - 【entity-APPLE¦canonical_name=Apple】 1.2: Engelledigim musterileri getir, onlarin ilanlarini gizle
  Future<void> _engellenenleriGetir() async {
    final ustaId = FirebaseAuth.instance.currentUser?.uid;
    if (ustaId == null) return;
    final snap = await FirebaseFirestore.instance
        .collection('blocked_users')
        .where('blockerId', isEqualTo: ustaId)
        .get();
    if (mounted) {
      setState(() {
        _engellenenMusteriler = snap.docs
            .map((d) => (d.data()['blockedId'] ?? '').toString())
            .where((id) => id.isNotEmpty)
            .toSet();
      });
    }
  }

  // ADIM 1 - 【entity-APPLE¦canonical_name=Apple】 1.2: Ilani sikayet et
  Future<void> _sikayetEt(IlanModel ilan) async {
    final ustaId = FirebaseAuth.instance.currentUser?.uid;
    if (ustaId == null) return;
    final sebep = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('İlanı Şikayet Et'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bu ilanı neden şikayet ediyorsun?', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            ListTile(title: const Text('Sahte / Yanıltıcı ilan'), onTap: () => Navigator.pop(c, 'Sahte / Yanıltıcı ilan')),
            ListTile(title: const Text('Küfür / Hakaret'), onTap: () => Navigator.pop(c, 'Küfür / Hakaret')),
            ListTile(title: const Text('Dolandırıcılık'), onTap: () => Navigator.pop(c, 'Dolandırıcılık')),
            ListTile(title: const Text('Diğer'), onTap: () => Navigator.pop(c, 'Diğer')),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('İptal'))],
      ),
    );
    if (sebep == null) return;
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'reporterId': ustaId,
        'reporterRole': 'usta',
        'reportedUserId': ilan.userId,
        'ilanId': ilan.id,
        'ilanBaslik': ilan.baslik,
        'sebep': sebep,
        'type': 'ilan',
        'status': 'bekliyor',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Şikayetiniz alındı, moderasyon inceleyecek.'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  // ADIM 1 - 【entity-APPLE¦canonical_name=Apple】 1.2: Musteriyi engelle - bir daha onun ilanlarini gorme
  Future<void> _musteriyiEngelle(IlanModel ilan) async {
    final ustaId = FirebaseAuth.instance.currentUser?.uid;
    if (ustaId == null) return;
    final onay = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Müşteriyi Engelle?'),
        content: const Text('Bu müşterinin ilanlarını bir daha görmeyeceksin. Emin misin?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('İptal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Engelle'),
          ),
        ],
      ),
    );
    if (onay != true) return;
    try {
      await FirebaseFirestore.instance
          .collection('blocked_users')
          .doc('${ustaId}_${ilan.userId}')
          .set({
        'blockerId': ustaId,
        'blockerRole': 'usta',
        'blockedId': ilan.userId,
        'blockedRole': 'musteri',
        'ilanId': ilan.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        setState(() => _engellenenMusteriler.add(ilan.userId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Müşteri engellendi.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  double _mesafeHesapla(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<String> _getMaskeliIsim(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        String ad = userDoc.get('firstName')?? "";
        String soyad = userDoc.get('lastName')?? "";
        if (ad.isEmpty) return "MÜŞTERİ";
        String soyadHarf = soyad.isNotEmpty? soyad[0].toUpperCase() : "";
        return "${ad[0].toUpperCase()}${ad.substring(1).toLowerCase()} $soyadHarf.";
      }
    } catch (e) { return "MÜŞTERİ"; }
    return "MÜŞTERİ";
  }

  Future<String> _formatKonumMetni(String raw) async {
    if (raw.isEmpty || raw == " / " || raw == "/" || raw.trim() == "") return "Konum Belirtilmedi";
    final parts = raw.split('/').map((e) => e.trim()).toList();
    if (parts.length >= 2 && (RegExp(r'^\d+$').hasMatch(parts[0]))) {
      return "${await LocationService.getSehirIsim(parts[0])} / ${await LocationService.getIlceIsim(parts[1])}";
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: UstaTheme.ustaArkaPlanDecor,
        child: SafeArea(
          child: Column(
            children: [
              _ozelAppBar(),
              _filtreCubugu(),
              Expanded(
                child: StreamBuilder<List<IlanModel>>(
                  stream: _adService.getAktifIlanlar(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                    List<IlanModel> ilanlar = (snapshot.data?? [])
                        .where((i) =>!_isAcil(i) &&!_teklifVerilenIlanlar.contains(i.id) && !_engellenenMusteriler.contains(i.userId))
                        .toList();

                    if (_seciliKategori!= "Hepsi") {
                      ilanlar = ilanlar.where((i) => i.kategori.toLowerCase().contains(_seciliKategori.toLowerCase())).toList();
                    }

                    ilanlar.sort((a, b) {
                      double mesafeA = _mesafeHesapla(_ustaLat, _ustaLng, a.latitude, a.longitude);
                      double mesafeB = _mesafeHesapla(_ustaLat, _ustaLng, b.latitude, b.longitude);
                      if ((mesafeA - mesafeB).abs() < 0.1) {
                        // REVİZE: YENİDEN > ESKİYE
                        return b.tarih.compareTo(a.tarih);
                      }
                      return mesafeA.compareTo(mesafeB);
                    });

                    if (ilanlar.isEmpty) return _bosDurumWidget();
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: ilanlar.length,
                      itemBuilder: (context, index) => _firsatKarti(context, ilanlar[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firsatKarti(BuildContext context, IlanModel ilan) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (c) => UstaIlanDetaySayfasi(ilan: ilan)));
          await Future.delayed(const Duration(milliseconds: 500));
          _teklifleriGetir();
          setState(() {});
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<String>(
                    future: _getMaskeliIsim(ilan.userId),
                    builder: (context, s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFFFA500).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text(s.data?? "MÜŞTERİ", style: const TextStyle(color: Color(0xFFFFA500), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Row(
                    children: [
                      Text(ilan.tarih.contains('T')? ilan.tarih.split('T')[0] : ilan.tarih, style: const TextStyle(color: Colors.white60)),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white70, size: 20),
                        color: const Color(0xFF2A2A2A),
                        onSelected: (val) {
                          if (val == 'sikayet') _sikayetEt(ilan);
                          if (val == 'engelle') _musteriyiEngelle(ilan);
                        },
                        itemBuilder: (c) => [
                          const PopupMenuItem(value: 'sikayet', child: Row(children: [Icon(Icons.flag, color: Colors.orange, size: 18), SizedBox(width: 8), Text('İlanı Şikayet Et', style: TextStyle(color: Colors.white))])),
                          const PopupMenuItem(value: 'engelle', child: Row(children: [Icon(Icons.block, color: Colors.red, size: 18), SizedBox(width: 8), Text('Müşteriyi Engelle', style: TextStyle(color: Colors.white))])),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(ilan.baslik.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              if (ilan.teknikDetaylar.isNotEmpty)...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ilan.teknikDetaylar.entries
                      .where((e) => e.value!= null && e.value.toString().isNotEmpty && e.key!= 'isAcil')
                      .map((e) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text("${e.key}: ${e.value}", style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],

              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Color(0xFFFFA500), size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _formatKonumMetni(ilan.konumMetin),
                      builder: (context, s) => Text(s.data?? "...", style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.handyman_outlined, color: Colors.white60, size: 18),
                  const SizedBox(width: 6),
                  Text(ilan.kategori, style: const TextStyle(color: Colors.white60)),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text("DETAYLARI İNCELE", style: TextStyle(color: const Color(0xFFFFA500), fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ozelAppBar() => const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text("İş Fırsatları", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)));

  Widget _filtreCubugu() => Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Row(children: [Expanded(child: _filtreButonu("Konum", Icons.location_on, () => _siralaMenuGoster(context))), const SizedBox(width: 12), Expanded(child: _filtreButonu(_seciliKategori, Icons.filter_alt_outlined, () => _filtreMenuGoster(context)))]));

  Widget _filtreButonu(String metin, IconData icon, VoidCallback onTap) => OutlinedButton.icon(style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(0.1)), backgroundColor: Colors.white.withOpacity(0.03)), onPressed: onTap, icon: Icon(icon, size: 20, color: Colors.white), label: Text(metin));

  void _siralaMenuGoster(BuildContext context) {}

  void _filtreMenuGoster(BuildContext context) {
    showModalBottomSheet(context: context, builder: (c) => Container(padding: const EdgeInsets.symmetric(vertical: 20), child: Column(mainAxisSize: MainAxisSize.min, children: _isKollari.map((k) => ListTile(title: Text(k), onTap: () { setState(() => _seciliKategori = k); Navigator.pop(c); })).toList())));
  }

  Widget _bosDurumWidget() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search_off_rounded, size: 80, color: Colors.white.withOpacity(0.1)), const SizedBox(height: 20), Text("Uygun iş bulunamadı.", style: const TextStyle(color: Colors.white))]));
}