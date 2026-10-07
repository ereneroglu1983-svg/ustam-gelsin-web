
// lib/features/admin/screens/finans_view.dart - V4 PUBLIC HTTP - KESİN ÇÖZÜM
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FinansView extends StatefulWidget {
  const FinansView({super.key});
  @override
  State<FinansView> createState() => _FinansViewState();
}

class _FinansViewState extends State<FinansView> {
  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);

  bool _loading = true;
  Map<String, dynamic>? _data;
  String _error = '';

  // BURAYI KENDİ PROJE URL'N İLE DEĞİŞTİR MORUK
  // Firebase Console -> Functions -> finansOzet -> URL'i kopyala
  final String functionUrl = "https://europe-west3-device-streaming-6f29b03c.cloudfunctions.net/finansOzet";

  @override
  void initState() {
    super.initState();
    _fetchFinans();
  }

  Future<void> _fetchFinans() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final response = await http.get(Uri.parse(functionUrl)).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() { _data = json; _loading = false; });
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  String _tl(double v) {
    final f = NumberFormat.currency(locale: 'tr_TR', symbol: '₺', decimalDigits: 2);
    return f.format(v);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return _shimmer();
    if (_error.isNotEmpty) return Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, color: Colors.white24, size: 48),
      const SizedBox(height: 12),
      Text("Hata: $_error", style: const TextStyle(color: Colors.white54, fontSize: 11)),
      const SizedBox(height: 12),
      ElevatedButton(onPressed: _fetchFinans, style: ElevatedButton.styleFrom(backgroundColor: primaryRed), child: const Text("Tekrar Dene"))
    ])));

    final gunluk = _data!['gunluk'];
    final haftalik = _data!['haftalik'];
    final aylik = _data!['aylik'];
    final yillik = _data!['yillik'];
    final meta = _data!['meta'];

    return RefreshIndicator(
      color: primaryRed,
      backgroundColor: cardBg,
      onRefresh: _fetchFinans,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header(meta),
          const SizedBox(height: 16),
          _card(title: "GÜNLÜK", subtitle: "Bugün • ${meta['bugunStr']}", komisyon: (gunluk['k'] as num).toDouble(), cuzdan: (gunluk['c'] as num).toDouble()),
          const SizedBox(height: 12),
          _card(title: "HAFTALIK", subtitle: "Bu Hafta • ${meta['haftaStr']}", komisyon: (haftalik['k'] as num).toDouble(), cuzdan: (haftalik['c'] as num).toDouble(), btnText: "Detay Gör >>", onBtn: () => _showHaftalik(_data!['haftalikDetay'])),
          const SizedBox(height: 12),
          _card(title: "AYLIK - ${meta['ayAdi'].toString().toUpperCase()}", subtitle: "${meta['ayStr']}", komisyon: (aylik['k'] as num).toDouble(), cuzdan: (aylik['c'] as num).toDouble()),
          const SizedBox(height: 12),
          _card(title: "YILLIK TOPLAM ${meta['yil']}", subtitle: "Ocak - Aralık • Toplam ${meta['toplamIslem']} işlem", komisyon: (yillik['k'] as num).toDouble(), cuzdan: (yillik['c'] as num).toDouble(), isYear: true, btnText: "Yıllık Detay >>", onBtn: () => _showYillik(_data!['yillikDetay'])),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10)), child: Row(children: [
            const Icon(Icons.bolt, color: Colors.amber, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text("HTTP ile ${meta['okunanDokuman']} doküman • Maliyet: ~${meta['maliyet']} • Süre: ${meta['sureMs']}ms", style: const TextStyle(color: Colors.white24, fontSize: 10)))
          ])),
        ],
      ),
    );
  }

  Widget _card({required String title, required String subtitle, required double komisyon, required double cuzdan, String? btnText, VoidCallback? onBtn, bool isYear = false}) {
    final netKar = komisyon - cuzdan;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: isYear ? Border.all(color: primaryRed.withOpacity(0.6), width: 1.2) : Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
        Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _box("KOMİSYON", komisyon, Colors.greenAccent)),
          const SizedBox(width: 10),
          Expanded(child: _box("CÜZDAN", cuzdan, Colors.orangeAccent)),
        ]),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: netKar >= 0 ? Colors.green.withOpacity(0.08) : Colors.red.withOpacity(0.08), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("NET KAR", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
          Text(_tl(netKar), style: TextStyle(color: netKar >= 0 ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
        ])),
        if (onBtn != null) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: onBtn, child: Text(btnText!, style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 12)))),
      ]),
    );
  }

  Widget _box(String label, double v, Color accent) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(10)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      const SizedBox(height: 6),
      Text(_tl(v), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
    ]),
  );

  Widget _header(Map meta) => Row(children: [
    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryRed.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.account_balance_wallet, color: primaryRed, size: 18)),
    const SizedBox(width: 10),
    const Text("FİNANSAL AKIŞ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    const Spacer(),
    Text("${meta['toplamIslem']} işlem", style: const TextStyle(color: Colors.white24, fontSize: 11)),
  ]);

  Widget _shimmer() => ListView(padding: const EdgeInsets.all(16), children: List.generate(4, (i) => Container(margin: const EdgeInsets.only(bottom: 12), height: 140, decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)))));

  void _showHaftalik(List detay) {
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF121212), isScrollControlled: true, builder: (_) => DraggableScrollableSheet(initialChildSize: 0.6, minChildSize: 0.4, maxChildSize: 0.9, expand: false, builder: (context, scrollController) {
      return ListView.builder(controller: scrollController, padding: const EdgeInsets.all(16), itemCount: detay.length, itemBuilder: (_, i) {
        final d = detay[i];
        return ListTile(title: Text(d['gunAdi'], style: const TextStyle(color: Colors.white)), subtitle: Text(d['tarih'], style: const TextStyle(color: Colors.white30, fontSize: 11)), trailing: Text("${_tl((d['k'] as num).toDouble())} / ${_tl((d['c'] as num).toDouble())}", style: const TextStyle(color: Colors.white70, fontSize: 12)));
      });
    }));
  }

  void _showYillik(List detay) {
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF121212), isScrollControlled: true, builder: (_) => DraggableScrollableSheet(initialChildSize: 0.7, minChildSize: 0.5, maxChildSize: 0.9, expand: false, builder: (context, scrollController) {
      return ListView.builder(controller: scrollController, padding: const EdgeInsets.all(16), itemCount: detay.length, itemBuilder: (_, i) {
        final d = detay[i];
        return ListTile(title: Text(d['ayAdi'], style: const TextStyle(color: Colors.white)), subtitle: Text("${d['islem']} işlem", style: const TextStyle(color: Colors.white30, fontSize: 11)), trailing: Text("K:${_tl((d['k'] as num).toDouble())}", style: const TextStyle(color: Colors.white70, fontSize: 12)));
      });
    }));
  }
}
