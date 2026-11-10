// lib/features/admin/screens/ilanlar.dart - FINAL V16 - ADMIN FULL GORUR - MASKELI BOZULMAZ - OVERFLOW FIX
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';

class AdminIlanlarView extends StatefulWidget {
  const AdminIlanlarView({super.key});
  @override
  State<AdminIlanlarView> createState() => _AdminIlanlarViewState();
}

class _AdminIlanlarViewState extends State<AdminIlanlarView> {
  String? _selectedIlId;

  static const Map<String, String> ilHaritasi = {
    "1": "ADANA", "2": "ADIYAMAN", "3": "AFYONKARAHİSAR", "4": "AĞRI", "5": "AMASYA",
    "6": "ANKARA", "7": "ANTALYA", "8": "ARTVİN", "9": "AYDIN", "10": "BALIKESİR",
    "11": "BİLECİK", "12": "BİNGÖL", "13": "BİTLİS", "14": "BOLU", "15": "BURDUR",
    "16": "BURSA", "17": "ÇANAKKALE", "18": "ÇANKIRI", "19": "ÇORUM", "20": "DENİZLİ",
    "21": "DİYARBAKIR", "22": "EDİRNE", "23": "ELAZIĞ", "24": "ERZİNCAN", "25": "ERZURUM",
    "26": "ESKİŞEHİR", "27": "GAZİANTEP", "28": "GİRESUN", "29": "GÜMÜŞHANE", "30": "HAKKARİ",
    "31": "HATAY", "32": "ISPARTA", "33": "MERSİN", "34": "İSTANBUL", "35": "İZMİR",
    "36": "KARS", "37": "KASTAMONU", "38": "KAYSERİ", "39": "KIRKLARELİ", "40": "KIRŞEHİR",
    "41": "KOCAELİ", "42": "KONYA", "43": "KÜTAHYA", "44": "MALATYA", "45": "MANİSA",
    "46": "KAHRAMANMARAŞ", "47": "MARDİN", "48": "MUĞLA", "49": "MUŞ", "50": "NEVŞEHİR",
    "51": "NİĞDE", "52": "ORDU", "53": "RİZE", "54": "SAKARYA", "55": "SAMSUN",
    "56": "SİİRT", "57": "SİNOP", "58": "SİVAS", "59": "TEKİRDAĞ", "60": "TOKAT",
    "61": "TRABZON", "62": "TUNCELİ", "63": "ŞANLIURFA", "64": "UŞAK", "65": "VAN",
    "66": "YOZGAT", "67": "ZONGULDAK", "68": "AKSARAY", "69": "BAYBURT", "70": "KARAMAN",
    "71": "KIRIKKALE", "72": "BATMAN", "73": "ŞIRNAK", "74": "BARTIN", "75": "ARDAHAN",
    "76": "IĞDIR", "77": "YALOVA", "78": "KARABÜK", "79": "KİLİS", "80": "OSMANİYE", "81": "DÜZCE",
  };

  String _ilAdiGetir(String ilId, String? konumMetin) {
    if (ilHaritasi.containsKey(ilId)) return ilHaritasi[ilId]!;
    if (konumMetin != null && konumMetin.contains("/")) return konumMetin.split("/").first.trim();
    return "İL $ilId";
  }

  Future<Map<String, dynamic>?> _userGetir(String userId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) return doc.data();
    } catch (_) {}
    return null;
  }

  Future<void> _yayindanKaldir(IlanModel ilan) async {
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text("Yayından Kaldır?"), content: Text("${ilan.ilanCode} - ${ilan.baslik}"), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("İptal")), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(ctx, true), child: const Text("Kaldır", style: TextStyle(color: Colors.white)))]));
    if (ok != true) return;
    await FirebaseFirestore.instance.collection("ilanlar").doc(ilan.id).update({"durum": "pasif", "yayindanKaldiran": "admin", "yayindanKaldirildiTarihi": FieldValue.serverTimestamp()});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${ilan.ilanCode} kaldırıldı"), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text("Aktif İlanlar - İl Bazlı", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("ilanlar").where("durum", isEqualTo: "aktif").snapshots(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text("Hata: ${snap.error}"));
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snap.hasData || snap.data!.docs.isEmpty) return const Center(child: Text("Aktif ilan yok"));

          List<IlanModel> tum = snap.data!.docs.map((d) => IlanModel.fromMap(d.data() as Map<String, dynamic>, d.id)).toList()..sort((a, b) => b.tarih.compareTo(a.tarih));
          Map<String, List<IlanModel>> gruplu = {};
          for (var i in tum) {
            String id = i.ilId.isNotEmpty ? i.ilId : "0";
            gruplu.putIfAbsent(id, () => []).add(i);
          }
          List<String> iller = gruplu.keys.toList()..sort((a, b) => gruplu[b]!.length.compareTo(gruplu[a]!.length));
          _selectedIlId ??= iller.first;
          if (!iller.contains(_selectedIlId)) _selectedIlId = iller.first;

          return Column(children: [
            Container(color: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), child: SizedBox(height: 48, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), itemCount: iller.length, itemBuilder: (context, idx) {
              String ilId = iller[idx];
              bool sel = _selectedIlId == ilId;
              String ad = _ilAdiGetir(ilId, gruplu[ilId]!.first.konumMetin);
              return GestureDetector(onTap: () => setState(() => _selectedIlId = ilId), child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10), decoration: BoxDecoration(color: sel ? const Color(0xFFE53935) : Colors.grey.shade100, borderRadius: BorderRadius.circular(24), border: Border.all(color: sel ? const Color(0xFFE53935) : Colors.grey.shade300)), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(ad, style: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: sel ? FontWeight.bold : FontWeight.w500, fontSize: 13)), const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), decoration: BoxDecoration(color: sel ? Colors.white : const Color(0xFFE53935), borderRadius: BorderRadius.circular(12)), child: Text("${gruplu[ilId]!.length}", style: TextStyle(color: sel ? const Color(0xFFE53935) : Colors.white, fontWeight: FontWeight.bold, fontSize: 11)))])));
            }))),
            Expanded(child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: gruplu[_selectedIlId]!.length, itemBuilder: (context, i) => _kart(context, gruplu[_selectedIlId]![i]))),
          ]);
        },
      ),
    );
  }

  Widget _kart(BuildContext context, IlanModel ilan) {
    return GestureDetector(
      onTap: () => _detayAc(context, ilan),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)), child: SizedBox(width: 96, height: 96, child: ilan.resimler.isNotEmpty ? CachedNetworkImage(imageUrl: ilan.resimler.first, fit: BoxFit.cover) : Container(color: Colors.grey[200], child: const Icon(Icons.build)))),
          Expanded(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(ilan.baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.location_on, size: 12, color: Colors.red), const SizedBox(width: 4), Expanded(child: Text(ilan.konumMetin, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis))]),
            const SizedBox(height: 4),
            Text(ilan.fiyatBilgisi, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE53935)), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Row(children: [Flexible(child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)), child: Text(ilan.kategori, style: TextStyle(fontSize: 10, color: Colors.blue.shade700), maxLines: 1, overflow: TextOverflow.ellipsis))), const SizedBox(width: 6), Text("${ilan.teklifSayisi} teklif", style: const TextStyle(fontSize: 10, color: Colors.grey)), const Spacer(), Flexible(child: Text(ilan.ilanCode, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis))]),
          ]))),
          Column(children: [const Padding(padding: EdgeInsets.only(right: 8, top: 12), child: Icon(Icons.chevron_right, color: Colors.grey, size: 18)), const SizedBox(height: 8), InkWell(onTap: () => _yayindanKaldir(ilan), child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)), child: Icon(Icons.visibility_off, size: 14, color: Colors.red.shade700)))]),
        ]),
      ),
    );
  }

  void _detayAc(BuildContext context, IlanModel ilan) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => DraggableScrollableSheet(initialChildSize: 0.92, maxChildSize: 0.95, minChildSize: 0.6, builder: (context, sc) => Container(decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))), child: ListView(controller: sc, padding: const EdgeInsets.all(16), children: [
      Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
      const SizedBox(height: 16),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Text(ilan.baslik, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)), child: Text(ilan.durum.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 11)))]),
      const SizedBox(height: 12),
      if (ilan.resimler.isNotEmpty) SizedBox(height: 180, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: ilan.resimler.length, itemBuilder: (context, i) => Container(margin: const EdgeInsets.only(right: 8), width: 240, child: ClipRRect(borderRadius: BorderRadius.circular(12), child: CachedNetworkImage(imageUrl: ilan.resimler[i], fit: BoxFit.cover))))),
      const SizedBox(height: 16),
      FutureBuilder<Map<String, dynamic>?>(future: _userGetir(ilan.userId), builder: (context, uSnap) {
        if (uSnap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        var u = uSnap.data;
        String fullName = u?['name']?.toString() ?? u?['adSoyad']?.toString() ?? ilan.musteriAd;
        String phone = u?['phone']?.toString() ?? "-";
        String adres = u?['adres']?.toString() ?? "-";
        String email = u?['email']?.toString() ?? "-";
        String firstName = u?['firstName']?.toString() ?? "";
        String lastName = u?['lastName']?.toString() ?? "";
        String ilceId = u?['ilce_id']?.toString() ?? "";
        String sehirId = u?['sehir_id']?.toString() ?? "";
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("GERÇEK MÜŞTERİ BİLGİSİ - USERS'DAN (ADMIN FULL GÖRÜR)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue)),
            const Divider(),
            _row("Full Ad Soyad", fullName, bold: true),
            _row("FirstName", firstName),
            _row("LastName", lastName),
            _row("Maskeli (İlanda Görünen)", ilan.maskeliAd),
            _row("Telefon (İlanda YOK)", phone, bold: true, color: Colors.red),
            _row("Adres (İlanda YOK)", adres, bold: true, color: Colors.red),
            _row("Email", email),
            _row("User ID", ilan.userId),
            _row("Sehir ID", sehirId),
            _row("Ilce ID", ilceId),
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)), child: const Text("FARE KONTROLÜ: Bu kişi müşteri gibi ilan açıp kendi telefonunu/reklamını koyuyorsa buradan ayıklarsın. İlanda telefon/adres boş, ama users'da dolu. Eğer ilan detayında telefon varsa ve users'daki telefonla aynı değilse şüpheli!", style: TextStyle(fontSize: 11, color: Colors.black87))),
          ])),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), onPressed: () => _yayindanKaldir(ilan), icon: const Icon(Icons.visibility_off, color: Colors.white), label: const Text("Yayından Kaldır", style: TextStyle(color: Colors.white)))), const SizedBox(width: 8), Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800), onPressed: () async { await FirebaseFirestore.instance.collection("ilanlar").doc(ilan.id).delete(); if (context.mounted) Navigator.pop(context); }, icon: const Icon(Icons.delete, color: Colors.white), label: const Text("Sil", style: TextStyle(color: Colors.white))))]),
        ]);
      }),
      const SizedBox(height: 16),
      _sec("İLAN BİLGİSİ (MASKELİ - PUBLIC'TE GÖRÜNEN)", [_row("İlan Kodu", ilan.ilanCode), _row("Başlık", ilan.baslik), _row("Kategori", ilan.kategori), _row("Durum", ilan.durum), _row("Tarih", ilan.tarih), _row("Teklif", "${ilan.teklifSayisi}"), _row("Fiyat", ilan.fiyatBilgisi), _row("Konum (Sadece İl/İlçe)", ilan.konumMetin), _row("AcikAdres (Boş olmalı)", ilan.acikAdres.isEmpty ? "BOŞ - DOĞRU" : ilan.acikAdres), _row("MusteriTelefon (Boş olmalı)", ilan.musteriTelefon.isEmpty ? "BOŞ - DOĞRU" : ilan.musteriTelefon)]),
      _sec("TEKNİK DETAYLAR", ilan.teknikDetaylar.entries.map((e) => _row(e.key, e.value is List ? (e.value as List).join(", ") : e.value.toString())).toList()),
    ]))));
  }

  Widget _sec(String t, List<Widget> c) => Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)), const Divider(), ...c]));
  Widget _row(String l, String v, {bool bold = false, Color? color}) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 140, child: Text(l, style: TextStyle(fontSize: 11, color: Colors.grey[600]))), const SizedBox(width: 8), Expanded(child: Text(v, style: TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.w400, color: color ?? Colors.black87)))]));
}
