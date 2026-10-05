// teklifler_view.dart - Tarihli PDF listesi
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hug_market_service.dart';

class TekliflerView extends StatefulWidget { const TekliflerView({super.key}); @override State<TekliflerView> createState()=> _TekliflerViewState(); }
class _TekliflerViewState extends State<TekliflerView>{
  final service = HugMarketService();
  String arama = '';
  @override Widget build(BuildContext context){
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Teklifler', style: GoogleFonts.poppins(fontSize:22, fontWeight: FontWeight.w800, color: Colors.black)),
          Text('Hangi tarihte hangi firmaya ne teklif vermişim - PDF\'li tarihli liste', style: GoogleFonts.poppins(fontSize:11, color: Colors.black54)),
        ]),
        SizedBox(width:300, child: TextField(onChanged: (v)=> setState(()=> arama=v), decoration: InputDecoration(hintText: 'Firma ara...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), isDense: true), style: GoogleFonts.poppins(color: Colors.black))),
      ]),
      const SizedBox(height:20),
      Expanded(child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEEEEEE))), child: StreamBuilder<QuerySnapshot>(stream: service.tekliflerStream(), builder: (c,snap){
        if(!snap.hasData) return const Center(child: CircularProgressIndicator());
        var docs = snap.data!.docs.where((d){ final data=d.data() as Map<String,dynamic>; return (data['firma']??'').toString().toLowerCase().contains(arama.toLowerCase()); }).toList();
        return SingleChildScrollView(scrollDirection: Axis.horizontal, child: SingleChildScrollView(child: DataTable(
          columns: [
            DataColumn(label: Text('Tarih', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black, fontSize:12))),
            DataColumn(label: Text('Teklif No', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black, fontSize:12))),
            DataColumn(label: Text('Firma', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black, fontSize:12))),
            DataColumn(label: Text('Kategori', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black, fontSize:12))),
            DataColumn(label: Text('Kapsam', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black, fontSize:12))),
            DataColumn(label: Text('Süre', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black, fontSize:12))),
            DataColumn(label: Text('Bedel', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black, fontSize:12))),
            DataColumn(label: Text('PDF', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black, fontSize:12))),
          ],
          rows: docs.map((doc){
            final data = doc.data() as Map<String,dynamic>;
            final tarih = (data['olusturulmaTarihi'] as Timestamp?)?.toDate();
            final tarihStr = tarih!=null ? '${tarih.day.toString().padLeft(2,'0')}.${tarih.month.toString().padLeft(2,'0')}.${tarih.year} ${tarih.hour}:${tarih.minute.toString().padLeft(2,'0')}' : '-';
            return DataRow(cells: [
              DataCell(Text(tarihStr, style: GoogleFonts.poppins(fontSize:11, color: Colors.black))),
              DataCell(Text(data['teklifNo']??data['fileName']??'-', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w700, color: Colors.black))),
              DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['firma']??'-', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w700, color: Colors.black)), Text(data['yetkili']??'', style: GoogleFonts.poppins(fontSize:10, color: Colors.black54))])),
              DataCell(Text(data['kategori']??'-', style: GoogleFonts.poppins(fontSize:11, color: Colors.black))),
              DataCell(Text('%${data['puan']??''} • ${(data['altAlanlar'] as List?)?.take(2).join(', ')??''}', style: GoogleFonts.poppins(fontSize:10, color: Colors.black87), overflow: TextOverflow.ellipsis)),
              DataCell(Text('${data['sureAy']??''} Ay', style: GoogleFonts.poppins(fontSize:11, color: Colors.black))),
              DataCell(Text('${data['teklifFiyat']??data['teklifBedeli']??''} TL', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w800, color: Colors.black))),
              DataCell(Row(children: [
                if(data['pdfUrl']!=null) IconButton(icon: const Icon(Icons.picture_as_pdf, color: Colors.red), onPressed: () async { final url=Uri.parse(data['pdfUrl']); if(await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication); }, tooltip: 'PDF Aç'),
                IconButton(icon: const Icon(Icons.visibility, color: Colors.black), onPressed: ()=> _detayGoster(data), tooltip: 'Detay'),
              ])),
            ]);
          }).toList(),
        )));
      }))),
    ]));
  }
  void _detayGoster(Map<String,dynamic> data){
    showDialog(context: context, builder: (c)=> AlertDialog(
      title: Text('${data['firma']} • ${data['kategori']}', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black)),
      content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Teklif No: ${data['teklifNo']??'-'}', style: GoogleFonts.poppins(fontSize:12, color: Colors.black)),
        Text('Tarih: ${(data['olusturulmaTarihi'] as Timestamp?)?.toDate()}', style: GoogleFonts.poppins(fontSize:12, color: Colors.black)),
        Text('Firma: ${data['firma']}', style: GoogleFonts.poppins(fontSize:12, color: Colors.black)),
        Text('Yetkili: ${data['yetkili']}', style: GoogleFonts.poppins(fontSize:12, color: Colors.black)),
        Text('Email: ${data['email']}', style: GoogleFonts.poppins(fontSize:12, color: Colors.black)),
        Text('Kategori: ${data['kategori']}', style: GoogleFonts.poppins(fontSize:12, color: Colors.black)),
        Text('Kapsam: %${data['puan']} • ${data['altAlanlar']}', style: GoogleFonts.poppins(fontSize:12, color: Colors.black)),
        Text('Süre: ${data['sureAy']} Ay', style: GoogleFonts.poppins(fontSize:12, color: Colors.black)),
        Text('Bedel: ${data['teklifFiyat']} TL', style: GoogleFonts.poppins(fontSize:14, fontWeight: FontWeight.w800, color: Colors.black)),
      ])),
      actions: [TextButton(onPressed: ()=> Navigator.pop(c), child: const Text('Kapat'))],
    ));
  }
}
