// lib/features/usta/screens/yeni_is_firsatlari_sayfasi.dart

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
  State<YeniIsFirsatlariSayfasi> createState() => _YeniIsFirsatlariSayfasiState();
}

class _YeniIsFirsatlariSayfasiState extends State<YeniIsFirsatlariSayfasi> {
  final AdService _adService = AdService();
  final AuthService _authService = AuthService();
  String _seciliSirala = "Konuma Göre Yakın";
  String _seciliKategori = "Hepsi";
  List<String> _teklifVerilenIlanlar = [];

  double _ustaLat = 0.0;
  double _ustaLng = 0.0;
  String _ustaSehirId = "";
  String _ustaIlceId = "";

  final List<String> _isKollari = [
    "Hepsi", "Boya", "Tesisat", "Elektrik", "Mobilya", "Tadilat", "Temizlik", "Zemin", "Çatı", "Isıtma"
  ];

  @override
  void initState() {
    super.initState();
    _teklifleriGetir();
    _kullaniciKonumuYukle();
  }

  Future<void> _kullaniciKonumuYukle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          _ustaLat = (data['latitude'] ?? 0.0).toDouble();
          _ustaLng = (data['longitude'] ?? 0.0).toDouble();

          Map<String, dynamic> address = data['address'] ?? {};
          _ustaSehirId = address['il_id']?.toString().trim() ?? "";
          _ustaIlceId = address['ilce_id']?.toString().trim() ?? "";
        });
      }
    }
  }

  Future<void> _teklifleriGetir() async {
    final ustaId = FirebaseAuth.instance.currentUser?.uid;
    if (ustaId == null) return;

    final snapshot = await FirebaseFirestore.instance.collection('teklifler')
        .where('ustaId', isEqualTo: ustaId)
        .get();

    if (mounted) {
      setState(() {
        _teklifVerilenIlanlar = snapshot.docs.map((doc) => doc.get('ilanId') as String).toList();
      });
    }
  }

  double _mesafeHesapla(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<String> _getMaskeliIsim(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        String ad = userDoc.get('firstName') ?? "";
        String soyad = userDoc.get('lastName') ?? "";
        if (ad.isEmpty) return "MÜŞTERİ";

        String soyadHarf = soyad.isNotEmpty ? soyad[0].toUpperCase() : "";
        return "${ad[0].toUpperCase()}${ad.substring(1).toLowerCase()} $soyadHarf.";
      }
    } catch (e) {
      return "MÜŞTERİ";
    }
    return "MÜŞTERİ";
  }

  Future<String> _formatKonumMetni(String raw) async {
    if (raw.isEmpty || raw == " / " || raw == "/" || raw.trim() == "") return "Konum Belirtilmedi";
    final String trimmed = raw.trim();
    if (trimmed.contains('/') && trimmed.split('/').every((e) => e.trim().isEmpty)) return "Konum Belirtilmedi";

    final parts = trimmed.split('/').map((e) => e.trim()).toList();
    if (parts.length >= 2) {
      if (RegExp(r'^\d+$').hasMatch(parts[0]) || RegExp(r'^\d+$').hasMatch(parts[1])) {
        final ilIsim = await LocationService.getSehirIsim(parts[0]);
        final ilceIsim = await LocationService.getIlceIsim(parts[1]);
        return "$ilIsim / $ilceIsim";
      }
    }
    return trimmed;
  }

  double _fiyatSayiyaCevir(String? fiyat) {
    if (fiyat == null) return 0.0;
    String temizFiyat = fiyat.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(temizFiyat) ?? 0.0;
  }

  int _tarihKarsilastir(String a, String b) {
    try {
      DateTime dtA = DateTime.parse(a);
      DateTime dtB = DateTime.parse(b);
      return dtB.compareTo(dtA);
    } catch (e) {
      return b.compareTo(a);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Hata: ${snapshot.error}", style: Theme.of(context).textTheme.bodyMedium));
                    }

                    List<IlanModel> ilanlar = (snapshot.data ?? [])
                        .where((i) => !_teklifVerilenIlanlar.contains(i.id))
                        .toList();

                    if (_seciliKategori != "Hepsi") {
                      ilanlar = ilanlar.where((i) => i.kategori.toLowerCase().contains(_seciliKategori.toLowerCase())).toList();
                    }

                    if (_seciliSirala == "En Yeni") {
                      ilanlar.sort((a, b) => _tarihKarsilastir(a.tarih, b.tarih));
                    } else if (_seciliSirala == "Fiyat: Artan") {
                      ilanlar.sort((a, b) => _fiyatSayiyaCevir(a.fiyatBilgisi).compareTo(_fiyatSayiyaCevir(b.fiyatBilgisi)));
                    } else if (_seciliSirala == "Fiyat: Azalan") {
                      ilanlar.sort((a, b) => _fiyatSayiyaCevir(b.fiyatBilgisi).compareTo(_fiyatSayiyaCevir(a.fiyatBilgisi)));
                    } else if (_seciliSirala == "Konuma Göre Yakın") {
                      ilanlar.sort((a, b) {
                        double mesafeA = _mesafeHesapla(_ustaLat, _ustaLng, a.latitude, a.longitude);
                        double mesafeB = _mesafeHesapla(_ustaLat, _ustaLng, b.latitude, b.longitude);
                        return mesafeA.compareTo(mesafeB);
                      });
                    }

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

  Widget _ozelAppBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text("İş Fırsatları", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
    );
  }

  Widget _firsatKarti(BuildContext context, IlanModel ilan) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UstaIlanDetaySayfasi(ilan: ilan),
            ),
          ).then((_) => _teklifleriGetir());
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
                    builder: (context, snapshot) {
                      return _musteriEtiketi(snapshot.data ?? "MÜŞTERİ");
                    },
                  ),
                  Text(ilan.tarih.contains('T') ? ilan.tarih.split('T')[0] : ilan.tarih, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 16),
              Text(ilan.baslik.toUpperCase(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Theme.of(context).primaryColor, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _formatKonumMetni(ilan.konumMetin),
                      builder: (context, snapshot) {
                        return Text(
                            snapshot.hasData ? snapshot.data! : "Konum yükleniyor...",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                            overflow: TextOverflow.ellipsis
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _altBilgiItem(Icons.handyman_outlined, ilan.kategori),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Divider(color: Colors.white10, height: 1)),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: (ilan.teknikDetaylar).entries
                    .where((e) => !["adet", "alan_kademe", "alan_segmenti"].contains(e.key.toLowerCase()))
                    .map((e) {
                  String baslik = e.key.replaceAll('_', ' ');
                  baslik = baslik.substring(0, 1).toUpperCase() + baslik.substring(1);
                  if (baslik.toLowerCase() == 'alan m2') baslik = 'Tahmini m²';

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.08))),
                    child: Text("$baslik: ${e.value}", style: const TextStyle(color: UstaTheme.griMetin, fontSize: 12)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Align(alignment: Alignment.centerRight, child: Text("DETAYLARI İNCELE", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _altBilgiItem(IconData icon, String deger) {
    return Row(children: [Icon(icon, size: 16, color: UstaTheme.griMetin), const SizedBox(width: 8), Text(deger, style: Theme.of(context).textTheme.bodyMedium)]);
  }

  Widget _musteriEtiketi(String ad) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(ad, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _filtreCubugu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(child: _filtreButonu(_seciliSirala, Icons.swap_vert_rounded, () => _siralaMenuGoster(context))),
          const SizedBox(width: 12),
          Expanded(child: _filtreButonu(_seciliKategori, Icons.filter_alt_outlined, () => _filtreMenuGoster(context))),
        ],
      ),
    );
  }

  Widget _filtreButonu(String metin, IconData icon, VoidCallback onTap) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(0.1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.white.withOpacity(0.03),
      ),
      onPressed: onTap, icon: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
      label: Text(metin, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
    );
  }

  void _siralaMenuGoster(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (c) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ["En Yeni", "Fiyat: Artan", "Fiyat: Azalan", "Konuma Göre Yakın"].map((s) => ListTile(
            leading: Icon(_seciliSirala == s ? Icons.check_circle : Icons.circle_outlined, color: _seciliSirala == s ? Theme.of(context).primaryColor : UstaTheme.griMetin),
            title: Text(s),
            onTap: () { setState(() => _seciliSirala = s); Navigator.pop(c); },
          )).toList(),
        ),
      ),
    );
  }

  void _filtreMenuGoster(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (c) => DraggableScrollableSheet(
        initialChildSize: 0.6, maxChildSize: 0.9, expand: false,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Kategori Seçin",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: ListView(controller: controller, children: _isKollari.map((k) => ListTile(title: Text(k), trailing: _seciliKategori == k ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null, onTap: () { setState(() => _seciliKategori = k); Navigator.pop(c); })).toList())),
          ],
        ),
      ),
    );
  }

  Widget _bosDurumWidget() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search_off_rounded, size: 80, color: Colors.white.withOpacity(0.1)), const SizedBox(height: 20), Text("Uygun iş bulunamadı.", style: Theme.of(context).textTheme.bodyLarge)]));
  }
}