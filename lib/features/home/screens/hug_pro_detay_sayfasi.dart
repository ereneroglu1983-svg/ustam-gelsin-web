// lib/features/home/screens/hug_pro_detay_sayfasi.dart
// HATASIZ - dart analyze test edildi - ORIJINAL KORUNDU + YETKI + SADE KART + TEKLIF INPUTLARI + TEKLIF VERILDI ISE BUTON GIZLE
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../hug_pro/hug_pro_meslek_eslestirme.dart';

const Color _black = Color(0xFF0B0B0B);
const Color _dark = Color(0xFF111111);
const Color _offWhite = Color(0xFFF7F5F0);
const Color _gold = Color(0xFFC8A45D);
const Color _gray = Color(0xFF8E8E8E);

class HugProDetaySayfasi extends StatefulWidget {
  final String projeId;
  const HugProDetaySayfasi({super.key, required this.projeId});
  @override
  State<HugProDetaySayfasi> createState() => _HugProDetaySayfasiState();
}

class _HugProDetaySayfasiState extends State<HugProDetaySayfasi> {
  Map<String, dynamic>? projeData;
  Map<String, dynamic>? aiValuation;
  bool yukleniyor = true;
  bool isYetkiKontrolEdildi = false;
  bool isAuthorized = false;
  String? blockReason;
  List<String> myMatchingIhtiyacIds = [];
  List<Map<String, dynamic>> myServices = [];

  // TEKLIF INPUT CONTROLLERS - HER SERVICE ICIN AYRI
  final Map<String, TextEditingController> _teklifBedeliControllers = {};
  final Map<String, TextEditingController> _teklifNotuControllers = {};

  // TEKLIF VERILDI ISE BUTONU GIZLE - EKLENDI
  final Set<String> _alreadyOfferedServiceIds = {};
  final Map<String, Map<String, dynamic>> _alreadyOfferedData = {};

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  @override
  void dispose() {
    for (final c in _teklifBedeliControllers.values) {
      c.dispose();
    }
    for (final c in _teklifNotuControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _verileriYukle() async {
    try {
      final doc = await FirebaseFirestore.instance.collection("hug_projects").doc(widget.projeId).get();
      if (!doc.exists) {
        setState(() => yukleniyor = false);
        return;
      }
      projeData = doc.data();
      aiValuation = projeData?["aiValuation"] ?? projeData?["ai_valuation"] ?? projeData?["valuation"];

      final user = FirebaseAuth.instance.currentUser;
      final ihtiyacIds = (projeData?["ihtiyacIds"] as List?)?.cast<String>() ?? [];

      if (user == null) {
        setState(() {
          isYetkiKontrolEdildi = true;
          isAuthorized = false;
          blockReason = 'Giriş yapmanız gerekiyor. Bu ilanın detayları sadece doğrulanmış profesyonellere açıktır.';
          yukleniyor = false;
        });
        return;
      }

      final sonuc = await HugProMeslekEslestirmeServisi.checkProYetki(uid: user.uid, ihtiyacIds: ihtiyacIds);
      if (!sonuc.isAuthorized) {
        setState(() {
          isYetkiKontrolEdildi = true;
          isAuthorized = false;
          blockReason = sonuc.failReason;
          yukleniyor = false;
        });
        return;
      }

      myMatchingIhtiyacIds = sonuc.matchingIhtiyacIds;
      myServices = HugProMeslekEslestirmeServisi.filterValuationServices(valuation: aiValuation, matchingIhtiyacIds: myMatchingIhtiyacIds);

      // CONTROLLERLARI OLUSTUR
      for (final svc in myServices) {
        final sid = (svc["service_id"] ?? svc["id"] ?? "").toString();
        if (sid.isNotEmpty && !_teklifBedeliControllers.containsKey(sid)) {
          _teklifBedeliControllers[sid] = TextEditingController();
          _teklifNotuControllers[sid] = TextEditingController();
        }
      }

      // TEKLIF VERILDI MI KONTROL ET - EKLENDI
      try {
        final teklifSnap = await FirebaseFirestore.instance
            .collection("hug_pro_teklifler")
            .where("projeId", isEqualTo: widget.projeId)
            .where("profesyonelId", isEqualTo: user.uid)
            .get();
        for (final d in teklifSnap.docs) {
          final data = d.data();
          final sid = (data["serviceId"] ?? "").toString();
          if (sid.isNotEmpty) {
            _alreadyOfferedServiceIds.add(sid);
            _alreadyOfferedData[sid] = data;
          }
        }
      } catch (_) {}

      setState(() {
        isYetkiKontrolEdildi = true;
        isAuthorized = true;
        yukleniyor = false;
      });
    } catch (e) {
      setState(() {
        yukleniyor = false;
        isYetkiKontrolEdildi = true;
        isAuthorized = false;
        blockReason = 'Veriler yüklenirken hata: $e';
      });
    }
  }

  String _formatYapiAdi(String raw) => raw.replaceAll("_", " / ").replaceAll("TICARI", "TİCARİ");

  String _maskName(String? n) {
    if (n == null || n.trim().isEmpty) return "Müşteri";
    final p = n.trim().split(RegExp(r"\s+"));
    if (p.length == 1) return p[0];
    return "${p.first} ${p.last[0]}....";
  }

  String _timeAgo(Timestamp? ts) {
    if (ts == null) return "Az önce";
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inMinutes < 60) return "${diff.inMinutes} dk önce";
    if (diff.inHours < 24) return "${diff.inHours} saat önce";
    if (diff.inDays == 1) return "Dün";
    return "${diff.inDays} gün önce";
  }

  String _ihtiyacDisplay(String id) {
    const map = {
      "MIMARI_PROJE": "Mimari proje",
      "STATIK_PROJE": "Statik proje",
      "MEKANIK_PROJE": "Mekanik proje",
      "ELEKTRIK_PROJE": "Elektrik tesisatı projesi",
      "PEYZAJ_PROJE": "Peyzaj projesi",
      "IC_MIMARI": "İç mimari",
      "3D_GORSELLESTIRME": "3D görselleştirme",
      "RUHSAT_DANISMANLIGI": "Ruhsat danışmanlığı",
      "ZEMIN_ETUDU": "Zemin etüdü",
      "ENERJI_KIMLIK": "Enerji kimlik belgesi",
      "YAPI_DENETIM": "Yapı denetim",
      "HARITA_KADASTRO": "Harita kadastro",
      "IS_GUVENLIGI": "İş güvenliği",
      "BUTCE_METRAJ": "Bütçe metraj",
      "SANTIE_SEFLIGI": "Şantiye şefliği",
      "MUTEAHHITLIK": "Müteahhitlik",
      "YAPI_MALZEME": "Yapı malzeme",
      "BOYA_BADANA": "Boya badana",
      "YALITIM": "Yalıtım",
      "DIGER": "Diğer",
    };
    return map[id] ?? id.replaceAll("_", " ").toLowerCase();
  }

  String _olcekLabel(String k) {
    const m = {"arsaAlani": "ARSA ALANI", "yapiAlani": "YAPI ALANI", "kapaliAlan": "KAPALI ALAN", "katSayisi": "KAT SAYISI"};
    return m[k] ?? k.toUpperCase();
  }

  String _detayLabel(String k) {
    const m = {"odaSayisi": "ODA SAYISI", "banyoSayisi": "BANYO / WC", "yapiSinifi": "YAPI SINIFI", "catiTipi": "ÇATI TİPİ", "garaj": "GARAJ"};
    return m[k] ?? k.replaceAllMapped(RegExp(r"([A-Z])"), (m) => " ${m.group(1)}").toUpperCase();
  }

  List<MapEntry<String, String>> _parseOlcek(Map<String, dynamic>? o, Map<String, dynamic>? ob) {
    final src = (ob != null && ob.isNotEmpty) ? ob : o;
    if (src == null || src.isEmpty) return [];
    return src.entries.map((e) => MapEntry(e.key, e.value.toString())).toList();
  }

  Future<void> _teklifVer(String serviceId, String serviceName, int hugFee) async {
    final teklifBedeliText = _teklifBedeliControllers[serviceId]?.text.trim() ?? "";
    final teklifNotuText = _teklifNotuControllers[serviceId]?.text.trim() ?? "";

    // ZORUNLU KONTROL - TEKLIF BEDELI
    if (teklifBedeliText.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teklif bedelini yazmanız zorunlu", style: TextStyle(color: Colors.white)), backgroundColor: _black));
      return;
    }

    final teklifBedeliNum = int.tryParse(teklifBedeliText.replaceAll(".", "").replaceAll(",", ""));
    if (teklifBedeliNum == null || teklifBedeliNum <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Geçerli bir teklif bedeli girin", style: TextStyle(color: Colors.white)), backgroundColor: _black));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final userDoc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      final walletBalance = (userDoc.data()?["walletBalance"] ?? userDoc.data()?["cuqdanBakiye"] ?? 0) as num;
      final abonelik = userDoc.data()?["abonelik"] as Map<String, dynamic>?;
      final bedavaHak = (abonelik?["hugProBedavaHak"] ?? 0) as num;
      final hasBedava = bedavaHak > 0;
      if (!hasBedava && walletBalance < hugFee) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (c) => Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: _black,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(children: [Container(width: 16, height: 1, color: _gold), const SizedBox(width: 8), const Text('YETERSİZ BAKİYE', style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold))]),
                  ),
                  const SizedBox(height: 16),
                  Text("Gereken: $hugFee TL, Mevcut: ${walletBalance.toInt()} TL", style: const TextStyle(fontSize: 11, color: _black)),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: GestureDetector(onTap: () => Navigator.pop(c), child: Container(color: _black, padding: const EdgeInsets.symmetric(vertical: 12), child: const Center(child: Text('KAPAT', style: TextStyle(fontSize: 9, letterSpacing: 2, color: Colors.white, fontWeight: FontWeight.bold)))))),
                ],
              ),
            ),
          ),
        );
        return;
      }
      final onay = await showDialog<bool>(
        context: context,
        builder: (c) => Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(color: _black, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [Container(width: 16, height: 1, color: _gold), const SizedBox(width: 8), Text("${serviceName.toLowerCase()} için teklif bedeli", style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 0.3))])),
                const SizedBox(height: 14),
                Text("HUG Bedeli: $hugFee TL", style: const TextStyle(fontSize: 11, color: _black, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text("Teklifiniz: $teklifBedeliNum TL", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _black)),
                if (teklifNotuText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text("Not: $teklifNotuText", style: const TextStyle(fontSize: 10, color: _black)),
                ],
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: GestureDetector(onTap: () => Navigator.pop(c, false), child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.1))), child: const Center(child: Text('İPTAL', style: TextStyle(fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold, color: _black)))))),
                  const SizedBox(width: 8),
                  Expanded(child: GestureDetector(onTap: () => Navigator.pop(c, true), child: Container(color: _gold, padding: const EdgeInsets.symmetric(vertical: 12), child: Center(child: Text(hasBedava ? 'BEDAVA KULLAN' : 'ÖDE - $hugFee TL', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: _black)))))),
                ]),
              ],
            ),
          ),
        ),
      );
      if (onay != true) return;
      final fs = FirebaseFirestore.instance;
      final kartId = "${widget.projeId}_$serviceId";
      if (hasBedava) {
        await fs.collection("users").doc(user.uid).update({"abonelik.hugProBedavaHak": FieldValue.increment(-1)});
      } else {
        await fs.collection("users").doc(user.uid).update({"walletBalance": FieldValue.increment(-hugFee)});
      }
      await fs.collection("hug_pro_hizmet_kartlari").doc(kartId).set({
        "projeId": widget.projeId,
        "serviceId": serviceId,
        "serviceName": serviceName,
        "hugAccessFeeTl": hugFee,
        "teklifBedeli": teklifBedeliNum,
        "teklifNotu": teklifNotuText,
        "odendi": true,
        "odemeYapanId": user.uid,
        "status": "ODEME_YAPILDI",
        "odemeTarihi": FieldValue.serverTimestamp()
      }, SetOptions(merge: true));
      await fs.collection("hug_pro_teklifler").add({
        "projeId": widget.projeId,
        "serviceId": serviceId,
        "serviceName": serviceName,
        "profesyonelId": user.uid,
        "hugAccessFee": hugFee,
        "teklifBedeli": teklifBedeliNum,
        "teklifNotu": teklifNotuText,
        "durum": "BEKLEMEDE",
        "olusturmaTarihi": FieldValue.serverTimestamp()
      });

      // LOCAL STATE GUNCELLE - BUTONU ANINDA GIZLE - EKLENDI
      if (mounted) {
        setState(() {
          _alreadyOfferedServiceIds.add(serviceId);
          _alreadyOfferedData[serviceId] = {
            "teklifBedeli": teklifBedeliNum,
            "teklifNotu": teklifNotuText,
            "hugAccessFee": hugFee,
          };
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$serviceName için teklif verildi! - $teklifBedeliNum TL"), backgroundColor: _black));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red));
      }
    }
  }

  Widget _detayRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 50, child: Text(label, style: const TextStyle(fontSize: 7, color: _gray, letterSpacing: 1))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _black))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (yukleniyor) {
      return Scaffold(
        backgroundColor: _offWhite,
        appBar: AppBar(backgroundColor: _black, title: const Text("YÜKLENİYOR...", style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2))),
        body: const Center(child: CircularProgressIndicator(color: _gold, strokeWidth: 1.5)),
      );
    }
    if (projeData == null) {
      return Scaffold(
        backgroundColor: _offWhite,
        appBar: AppBar(backgroundColor: _black, title: const Text("BULUNAMADI", style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2))),
        body: const Center(child: Text("Proje bulunamadı", style: TextStyle(fontSize: 11, color: _gray))),
      );
    }

    if (isYetkiKontrolEdildi && !isAuthorized) {
      return Scaffold(
        backgroundColor: _offWhite,
        appBar: AppBar(backgroundColor: _black, iconTheme: const IconThemeData(color: Colors.white), title: const Text("ERİŞİM KISITLI", style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold))),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.06))),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(color: _black, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [Container(width: 16, height: 1, color: _gold), const SizedBox(width: 8), const Expanded(child: Text('ERİŞİM KISITLI', style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold)))])),
              const SizedBox(height: 16),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: _black, border: Border.all(color: _gold.withOpacity(0.3))), child: const Icon(Icons.lock, size: 14, color: _gold)), const SizedBox(width: 12), Expanded(child: Text(blockReason ?? 'Bu ilanın detaylarını görüntülemek için yeterli mesleki yetkinliğiniz bulunmamaktadır.', style: const TextStyle(fontSize: 12, height: 1.6, color: _black, fontWeight: FontWeight.w500)))]),
              const SizedBox(height: 20),
              SizedBox(width: double.infinity, child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(color: _black, padding: const EdgeInsets.symmetric(vertical: 12), child: const Center(child: Text('GERİ DÖN', style: TextStyle(fontSize: 9, letterSpacing: 2, color: Colors.white, fontWeight: FontWeight.bold)))))),
            ]),
          ),
        ),
      );
    }

    final data = projeData!;
    final yapiTuru = _formatYapiAdi(data["yapiTuruId"] ?? "-");
    final asama = data["asamaDisplay"] ?? data["asama"] ?? "-";
    final konum = data["konum"] as Map<String, dynamic>? ?? {};
    final il = konum["il"] ?? data["il"] ?? "";
    final ilce = konum["ilce"] ?? data["ilce"] ?? "";
    final olcek = data["olcek"] as Map<String, dynamic>?;
    final olcekBirimli = data["olcekBirimli"] as Map<String, dynamic>?;
    final olcekList = _parseOlcek(olcek, olcekBirimli);
    final ihtiyacIds = (data["ihtiyacIds"] as List?)?.cast<String>() ?? [];
    final aciklama = data["aciklama"] as String? ?? "";
    final fotoUrls = (data["fotoUrls"] as List?)?.cast<String>() ?? [];
    final createdAt = data["createdAt"] as Timestamp?;
    final detaylar = data["detaylar"] as Map<String, dynamic>?;
    final detaySayisi = detaylar?.length ?? 0;
    final musteriAdiRaw = data["musteriAdi"] as String? ?? data["displayName"] as String?;

    return Scaffold(
      backgroundColor: _offWhite,
      appBar: AppBar(
        backgroundColor: _black,
        title: Text(yapiTuru.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.06))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: _black,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Row(
                  children: [
                    Container(width: 20, height: 1, color: _gold),
                    const SizedBox(width: 8),
                    Text("$il / $ilce".toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                    const Spacer(),
                    Text(_timeAgo(createdAt), style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 8, letterSpacing: 1)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 12, color: _gold),
                        const SizedBox(width: 6),
                        Text(_maskName(musteriAdiRaw), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.3, color: _black)),
                        const SizedBox(width: 8),
                        Container(width: 4, height: 4, decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text("$il / $ilce", style: const TextStyle(fontSize: 8, color: _gray, letterSpacing: 1)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _detayRow("YAPI", yapiTuru),
                    _detayRow("AŞAMA", asama.toString().toUpperCase()),
                    if (olcekList.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.06))),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: _black,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Row(
                                children: [
                                  Container(width: 12, height: 1, color: _gold),
                                  const SizedBox(width: 6),
                                  const Text("PROJE ÖLÇEKLERİ", style: TextStyle(color: Colors.white, fontSize: 7, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            for (final entry in olcekList)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.04)))),
                                child: Row(
                                  children: [
                                    SizedBox(width: 95, child: Text(_olcekLabel(entry.key), style: const TextStyle(fontSize: 7, color: _gray, fontWeight: FontWeight.w600, letterSpacing: 1))),
                                    const SizedBox(width: 8),
                                    Container(width: 1, height: 12, color: Colors.black.withOpacity(0.1)),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _black))),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    if (detaylar != null && detaylar.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.06))),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: _black,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Row(
                                children: [
                                  Container(width: 12, height: 1, color: _gold),
                                  const SizedBox(width: 6),
                                  Text("PROJE DETAYLARI - $detaySayisi ALAN", style: const TextStyle(color: Colors.white, fontSize: 7, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            for (final entry in detaylar.entries)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.04)))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 95, child: Text(_detayLabel(entry.key), style: const TextStyle(fontSize: 7, color: _gray, fontWeight: FontWeight.w600, letterSpacing: 1))),
                                    const SizedBox(width: 8),
                                    Container(width: 1, height: 12, color: Colors.black.withOpacity(0.1)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        entry.value is List ? (entry.value as List).join(", ") : entry.value.toString(),
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      color: _offWhite,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 16, height: 1, color: _gold),
                              const SizedBox(width: 8),
                              const Text("PROJE İÇİN ARANAN PROFESYONELLER", style: TextStyle(fontSize: 7, color: _gray, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                color: _black,
                                child: Text("${ihtiyacIds.length}", style: const TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: ihtiyacIds.map((id) {
                              final isMine = myMatchingIhtiyacIds.contains(id);
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: isMine ? _black : Colors.white, border: Border.all(color: isMine ? _gold : Colors.black.withOpacity(0.08))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle)),
                                    const SizedBox(width: 6),
                                    Text(_ihtiyacDisplay(id), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: isMine ? Colors.white : _black)),
                                    if (isMine) ...[
                                      const SizedBox(width: 6),
                                      const Icon(Icons.check_circle, size: 10, color: _gold),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (aciklama.isNotEmpty) ...[
                      Container(height: 1, color: Colors.black.withOpacity(0.06)),
                      const SizedBox(height: 10),
                      Text(aciklama, style: const TextStyle(fontSize: 11, height: 1.5, color: Color(0xFF333333))),
                      const SizedBox(height: 10),
                      Container(height: 1, color: Colors.black.withOpacity(0.06)),
                    ],
                    const SizedBox(height: 14),

                    // === ULTRA SADE TEKLIF KARTLARI + INPUTLAR + GIZLE LOGIGI ===
                    if (myServices.isNotEmpty) ...[
                      for (final svc in myServices)
                        Builder(builder: (context) {
                          final sid = (svc["service_id"] ?? svc["id"] ?? "").toString();
                          final isOffered = _alreadyOfferedServiceIds.contains(sid);
                          final offered = _alreadyOfferedData[sid];
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: isOffered ? _gold.withOpacity(0.4) : Colors.black.withOpacity(0.08))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: isOffered ? _gold : _black,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Row(
                                    children: [
                                      Container(width: 14, height: 1, color: isOffered ? _black : _gold),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          isOffered ? "${_ihtiyacDisplay(sid)} - TEKLİF VERİLDİ" : "${_ihtiyacDisplay(sid)} için teklif bedeli",
                                          style: TextStyle(color: isOffered ? _black : Colors.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3),
                                        ),
                                      ),
                                      if (isOffered) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), color: _black, child: const Text("VERİLDİ", style: TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1))),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (isOffered) ...[
                                        Row(
                                          children: [
                                            Container(width: 32, height: 32, decoration: BoxDecoration(color: _black, border: Border.all(color: _gold.withOpacity(0.3))), child: const Icon(Icons.check, size: 16, color: _gold)),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                const Text("TEKLİFİNİZ", style: TextStyle(fontSize: 7, color: _gray, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                                const SizedBox(height: 2),
                                                Text("${offered?["teklifBedeli"] ?? 0} TL", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _black)),
                                                if ((offered?["teklifNotu"] ?? "").toString().isNotEmpty) ...[
                                                  const SizedBox(height: 4),
                                                  Text(offered?["teklifNotu"] ?? "", style: const TextStyle(fontSize: 10, color: _black, height: 1.3)),
                                                ],
                                              ]),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), color: _offWhite, child: Text("HUG Erişim Bedeli: ${offered?["hugAccessFee"] ?? svc["hug_access_fee_tl"] ?? 0} TL ödendi", style: const TextStyle(fontSize: 8, color: _gray))),
                                      ] else ...[
                                        Text("${svc["hug_access_fee_tl"] ?? svc["hug_access_fee"] ?? 0} TL", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _black, letterSpacing: -0.5)),
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.12))),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                color: _offWhite,
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                child: Row(
                                                  children: [
                                                    const Text("TEKLİF BEDELİNİZ", style: TextStyle(fontSize: 7, color: _black, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                                    const SizedBox(width: 4),
                                                    const Text("*", style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                                                    const SizedBox(width: 6),
                                                    const Text("(TL) - ZORUNLU", style: TextStyle(fontSize: 6, color: _gray, letterSpacing: 1)),
                                                  ],
                                                ),
                                              ),
                                              TextField(
                                                controller: _teklifBedeliControllers[sid],
                                                keyboardType: TextInputType.number,
                                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _black),
                                                decoration: const InputDecoration(
                                                  hintText: "Örn: 50000",
                                                  hintStyle: TextStyle(fontSize: 11, color: _gray),
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.12))),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                color: _offWhite,
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                child: const Text("TEKLİF NOTU (OPSİYONEL)", style: TextStyle(fontSize: 7, color: _black, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                              ),
                                              TextField(
                                                controller: _teklifNotuControllers[sid],
                                                maxLines: 3,
                                                style: const TextStyle(fontSize: 11, color: _black, height: 1.4),
                                                decoration: const InputDecoration(
                                                  hintText: "Örn: 15 günde teslim, 2 revizyon dahil...",
                                                  hintStyle: TextStyle(fontSize: 10, color: _gray),
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        GestureDetector(
                                          onTap: () => _teklifVer(sid, _ihtiyacDisplay(sid), (svc["hug_access_fee_tl"] ?? svc["hug_access_fee"] ?? 0) as int),
                                          child: Container(
                                            width: double.infinity,
                                            color: _gold,
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            child: Center(child: Text("TEKLİF VER - ${svc["hug_access_fee_tl"] ?? 0} TL", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: _black))),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],

                    if (myServices.isEmpty && aiValuation != null && (aiValuation?["services"] as List?)?.isNotEmpty == true && !isYetkiKontrolEdildi) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: _offWhite, border: Border.all(color: Colors.black.withOpacity(0.06))),
                        child: Text("Teklif bedeli hesaplanıyor - Yetki: ${myMatchingIhtiyacIds.length}", style: const TextStyle(fontSize: 9, color: _gray)),
                      ),
                    ],

                    if (fotoUrls.isNotEmpty)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withOpacity(0.06))),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: _black,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Row(
                                children: [
                                  Container(width: 12, height: 1, color: _gold),
                                  const SizedBox(width: 6),
                                  Text("FOTOĞRAFLAR - ${fotoUrls.length} ADET", style: const TextStyle(color: Colors.white, fontSize: 7, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: fotoUrls.map((url) {
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.08))),
                                    child: CachedNetworkImage(
                                      imageUrl: url,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: _gold, strokeWidth: 1))),
                                      errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 20, color: _gray),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}