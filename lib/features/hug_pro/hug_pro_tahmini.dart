import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// SADECE ARALIKLI FIYAT - MUSTERIYE GOSTERILECEK

class HugProFiyatKarti extends StatelessWidget {
  final Map<String, dynamic>? valuation;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;
  static const _black = Color(0xFF0B0B0B);
  static const _offWhite = Color(0xFFF7F5F0);
  static const _gold = Color(0xFFC8A45D);
  static const _gray = Color(0xFF8E8E8E);
  const HugProFiyatKarti({super.key, this.valuation, this.isLoading=false, this.error, this.onRetry});
  String _formatTL(num? v){ if(v==null) return "-"; final f=NumberFormat("#,##0","tr_TR"); return "${f.format(v)} TL"; }
  @override
  Widget build(BuildContext context){
    if(isLoading){
      return Container(margin: const EdgeInsets.only(top:24), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color:_offWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color:_gold.withOpacity(0.3))), child: Column(children:[Row(children:[SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2.5,color:_gold)), const SizedBox(width:12), const Text("HUG AI FIYAT HESAPLIYOR...", style: TextStyle(color:_black,fontWeight:FontWeight.w700))]), const SizedBox(height:12), LinearProgressIndicator(color:_gold, backgroundColor:_gray.withOpacity(0.2))]));
    }
    if(error!=null){
      return Container(margin: const EdgeInsets.only(top:24), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.red.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.withOpacity(0.3))), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[const Text("FIYAT HESAPLANAMADI", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)), const SizedBox(height:8), Text(error!, style: const TextStyle(color:_black)), if(onRetry!=null) OutlinedButton(onPressed:onRetry, child: const Text("TEKRAR DENE"))]));
    }
    if(valuation==null) return const SizedBox.shrink();
    final total = valuation!['total'] as Map<String, dynamic>? ?? {};
    num? min = total['min_tl'] as num?;
    num? max = total['max_tl'] as num?;
    final est = total['estimated_tl'] as num?;
    if(min==null||max==null){
      num cMin=0,cMax=0;
      for(final svc in (valuation!['services'] as List? ?? [])){ if(svc['status']=='estimated'){ cMin+= (svc['min_tl'] as num? ?? 0); cMax+= (svc['max_tl'] as num? ?? 0);} }
      min ??= cMin; max ??= cMax;
    }
    return Container(margin: const EdgeInsets.only(top:24), decoration: BoxDecoration(color:_offWhite, borderRadius: BorderRadius.circular(20), border: Border.all(color:_gold.withOpacity(0.5), width:1.5)), child: Column(children:[
      Container(padding: const EdgeInsets.all(22), decoration: const BoxDecoration(color:_black, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))), child: Column(children:[
        Row(children:[Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color:_gold, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.auto_awesome, size:14, color:_black)), const SizedBox(width:8), const Text("TAHMINI PROJE BEDELI", style: TextStyle(color:_offWhite, fontWeight: FontWeight.w800, fontSize:12, letterSpacing:1.2)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:3), decoration: BoxDecoration(color:_gold, borderRadius: BorderRadius.circular(20)), child: const Text("HUG PRO AI", style: TextStyle(color:_black, fontSize:8, fontWeight:FontWeight.w800)))]),
        const SizedBox(height:20),
        Center(child: Column(children:[
          Text("TAHMINI FIYAT ARALIGI", style: TextStyle(color:_gray, fontSize:10, letterSpacing:1.5)),
          const SizedBox(height:10),
          RichText(textAlign: TextAlign.center, text: TextSpan(children:[
            TextSpan(text: NumberFormat("#,##0","tr_TR").format(min), style: const TextStyle(color:_offWhite, fontSize:26, fontWeight:FontWeight.w800)),
            const TextSpan(text:"  -  ", style: TextStyle(color:_gold, fontSize:20)),
            TextSpan(text: NumberFormat("#,##0","tr_TR").format(max), style: const TextStyle(color:_offWhite, fontSize:26, fontWeight:FontWeight.w800)),
            const TextSpan(text:" TL", style: TextStyle(color:_gold, fontSize:14, fontWeight:FontWeight.w700)),
          ])),
          const SizedBox(height:8),
          if(est!=null) Text("Ortalama: ${_formatTL(est)}", style: TextStyle(color:_offWhite.withOpacity(0.6), fontSize:12)),
        ])),
        const SizedBox(height:18),
        Container(height:1, color:_offWhite.withOpacity(0.1)),
        const SizedBox(height:14),
        Row(mainAxisAlignment:MainAxisAlignment.center, children:[Icon(Icons.verified_outlined, size:12, color:_gold.withOpacity(0.8)), const SizedBox(width:6), Text("Guncel piyasa verilerine gore HUG PRO AI tahmini", style: TextStyle(color:_gray, fontSize:10))]),
      ])),
      Padding(padding: const EdgeInsets.all(16), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color:_black.withOpacity(0.04), borderRadius: BorderRadius.circular(10)), child: const Row(children:[Icon(Icons.info_outline, size:14, color:_gray), SizedBox(width:8), Expanded(child: Text("Bu aralik projenizin yaklasik maliyetini gosterir. Kesin teklifler profesyonellerden gelecektir.", style: TextStyle(color:_gray, fontSize:10)))]))),
    ]));
  }
}

class HugProFiyatHesaplaButton extends StatelessWidget {
  final VoidCallback? onPressed; final bool isLoading; final bool fiyatGosterildi;
  static const _black = Color(0xFF0B0B0B); static const _gold = Color(0xFFC8A45D); static const _offWhite = Color(0xFFF7F5F0);
  const HugProFiyatHesaplaButton({super.key, this.onPressed, this.isLoading=false, this.fiyatGosterildi=false});
  @override
  Widget build(BuildContext context){
    return SizedBox(width:double.infinity, height:56, child: ElevatedButton(onPressed: isLoading?null:onPressed, style: ElevatedButton.styleFrom(backgroundColor:_black, foregroundColor:_offWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color:_gold, width:1.2))), child: isLoading? Row(mainAxisAlignment:MainAxisAlignment.center, children:[SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2,color:_gold)), const SizedBox(width:12), const Text("HESAPLANIYOR...")]): Row(mainAxisAlignment:MainAxisAlignment.center, children:[Icon(fiyatGosterildi?Icons.refresh:Icons.calculate_outlined, size:20, color:_gold), const SizedBox(width:10), Text(fiyatGosterildi?"FIYATI YENIDEN HESAPLA":"TAHMINI FIYATI GOR", style: const TextStyle(color:_offWhite, fontWeight:FontWeight.w800, letterSpacing:1.2)), const SizedBox(width:8), const Icon(Icons.auto_awesome, size:16, color:_gold)])));
  }
}
