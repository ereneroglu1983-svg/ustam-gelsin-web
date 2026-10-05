// raporlar_view.dart - Raporlar icin doldurabilecekler
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hug_market_service.dart';

class RaporlarView extends StatefulWidget { const RaporlarView({super.key}); @override State<RaporlarView> createState()=> _RaporlarViewState(); }
class _RaporlarViewState extends State<RaporlarView>{
  final service = HugMarketService();
  @override Widget build(BuildContext context){
    return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Raporlar', style: GoogleFonts.poppins(fontSize:22, fontWeight: FontWeight.w800, color: Colors.black)),
      Text('Teklif performansını analiz et - sana önerilerim', style: GoogleFonts.poppins(fontSize:11, color: Colors.black54)),
      const SizedBox(height:20),
      Row(children: [
        Expanded(child: _raporCard('Aylık Ciro Grafiği', 'Son 6 ayda ne kadar teklif verdin, ne kadar ciro yaptın', Icons.show_chart, [
          'Ocak: 450K TL • 3 teklif',
          'Şubat: 780K TL • 5 teklif',
          'Mart: 1.2M TL • 7 teklif',
          'Trend: ↑ %67 artış',
        ])),
        const SizedBox(width:16),
        Expanded(child: _raporCard('Kategori Bazlı Dağılım', 'Hangi kategori en çok talep görüyor', Icons.pie_chart, [
          'Boya & Dekorasyon: %35 (en çok)',
          'Yenilenebilir Enerji: %25 (yükselen)',
          'Banyo & Mutfak: %20',
          'Diğer: %20',
        ])),
      ]),
      const SizedBox(height:16),
      Row(children: [
        Expanded(child: _raporCard('Tier Performans', 'Premium vs Niş - hangisi daha karlı', Icons.leaderboard, [
          'Tier A: Ort. 650K TL • 12 teklif',
          'Tier B: Ort. 480K TL • 18 teklif (en çok)',
          'Tier C: Ort. 320K TL • 8 teklif',
          'Öneri: Tier B\'ye odaklan',
        ])),
        const SizedBox(width:16),
        Expanded(child: _raporCard('Dönüşüm & Öneriler', 'Benim önerilerim moruk', Icons.lightbulb, [
          'En çok teklif verilen: 6 Ay (%60)',
          'Ortalama kapsam: %78',
          'En karlı süre: 12 Ay (aylık düşük, toplam yüksek)',
          'Öneri: 12 aya %10 indirim kampanyası yap',
        ])),
      ]),
      const SizedBox(height:20),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Benim önerdiğim raporlar - sence nasıl moruk?', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize:14)),
        const SizedBox(height:10),
        Text('• Aylık ciro ve teklif sayısı trendi\n• En çok kazandıran kategori\n• En çok tercih edilen süre (3/6/12)\n• Firma bazlı tekrar teklif oranı\n• Ortalama kapsam yüzdesi (müşteri ne kadar alan seçiyor)\n• Kaybedilen teklif analizi (teklif verdin ama dönüş olmadı)\n• Sezonluk analiz (yazın hangi kategori artıyor)\n• Tahmini yıllık ciro projeksiyonu', style: GoogleFonts.poppins(color: Colors.white70, fontSize:12, height:1.6)),
      ])),
    ]));
  }
  Widget _raporCard(String title, String desc, IconData icon, List<String> items){
    return Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEEEEEE))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Container(width:36,height:36,decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Colors.white, size:18)), const SizedBox(width:10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:13, color: Colors.black)), Text(desc, style: GoogleFonts.poppins(fontSize:10, color: Colors.black54))]))]),
      const SizedBox(height:12),
      ...items.map((e)=> Padding(padding: const EdgeInsets.only(bottom:4), child: Row(children: [Container(width:6,height:6,decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)), const SizedBox(width:8), Expanded(child: Text(e, style: GoogleFonts.poppins(fontSize:11, color: Colors.black, fontWeight: FontWeight.w600)))]))),
    ]));
  }
}
