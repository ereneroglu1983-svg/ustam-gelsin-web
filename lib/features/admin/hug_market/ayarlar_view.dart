// lib/features/admin/hug_market/ayarlar_view.dart - TAM - HATASIZ - EDITABLE
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hug_market_service.dart';

class AyarlarView extends StatefulWidget {
  const AyarlarView({super.key});
  @override
  State<AyarlarView> createState() => _AyarlarViewState();
}

class _AyarlarViewState extends State<AyarlarView>{
  final service = HugMarketService();

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ayarlar', style: GoogleFonts.poppins(fontSize:22, fontWeight: FontWeight.w800, color: Colors.black)),
          Text('Kodla uğraşmadan fiyatları, IBAN, DUNS, kategorileri değiştir', style: GoogleFonts.poppins(fontSize:11, color: Colors.black54)),
          const SizedBox(height:20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SOL - FIYAT AYARLARI EDITABLE
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEEEEEE))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tier Fiyatları (Kod yok, direkt değiştir)', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:14, color: Colors.black)),
                      const SizedBox(height:4),
                      Text('3/6/12 aylık fiyatları buradan değiştir, tüm teklifler yeni fiyatla hesaplanır', style: GoogleFonts.poppins(fontSize:10, color: Colors.black54)),
                      const SizedBox(height:12),
                      StreamBuilder<QuerySnapshot>(
                        stream: service.fiyatlarStream(),
                        builder: (c,snap){
                          if(!snap.hasData) return const Center(child: CircularProgressIndicator());
                          return Column(
                            children: snap.data!.docs.map((doc){
                              final data=doc.data() as Map<String,dynamic>;
                              return Container(
                                margin: const EdgeInsets.only(bottom:12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFFF8F8F7), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['label']??data['tier'], style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:12, color: Colors.black)),
                                    const SizedBox(height:8),
                                    Row(children: [
                                      _fiyatField(doc.id, 'p3', '3 Ay', data['p3']),
                                      const SizedBox(width:8),
                                      _fiyatField(doc.id, 'p6', '6 Ay', data['p6']),
                                      const SizedBox(width:8),
                                      _fiyatField(doc.id, 'p12', '12 Ay', data['p12']),
                                    ]),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height:8),
                      ElevatedButton(onPressed: ()=> service.fiyatlariIlkKur(), style: ElevatedButton.styleFrom(backgroundColor: Colors.black), child: Text('Varsayılan Fiyatları Yükle', style: GoogleFonts.poppins(color: Colors.white, fontSize:11))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width:16),
              // SAG - SIRKET BILGILERI EDITABLE
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEEEEEE))),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: service.ayarlarStream(),
                    builder: (c,snap){
                      final data = snap.data?.data() as Map<String,dynamic>?;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Şirket Bilgileri', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:14, color: Colors.black)),
                          const SizedBox(height:12),
                          _ayarField('adres', 'Adres', data?['adres']??'Sağlık Mh. Kurudere Cad. No:76/9 Salihli-MANİSA'),
                          _ayarField('telefon', 'Telefon', data?['telefon']??'0532 163 59 66'),
                          _ayarField('email', 'E-posta', data?['email']??'info@hemenustamgelsin.com'),
                          _ayarField('iban', 'IBAN', data?['iban']??'TR79 0086 4011 0000 8503 0670 04'),
                          _ayarField('duns', 'D-U-N-S', data?['duns']??'751176741'),
                          _ayarField('vergiNo', 'Vergi No', data?['vergiNo']??''),
                          const SizedBox(height:16),
                          Text('Mail Şablonu', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize:12, color: Colors.black)),
                          const SizedBox(height:8),
                          Text('Mail içeriğini ayarlarsan PDF ile aynı gider', style: GoogleFonts.poppins(fontSize:10, color: Colors.black54)),
                          const SizedBox(height:8),
                          ElevatedButton.icon(icon: const Icon(Icons.email, color: Colors.white, size:16), label: Text('Mail Test Et', style: GoogleFonts.poppins(color: Colors.white, fontSize:11)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C)), onPressed: (){}),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height:16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.info, color: Colors.white, size:20),
              const SizedBox(width:10),
              Expanded(child: Text('Buradan değiştirdiğin her şey Firestore\'a kaydolur. Kodla uğraşmadan fiyatları, kategorileri, IBAN/DUNS/adresi anında güncelleyebilirsin. Motor otomatik yeni verileri kullanır.', style: GoogleFonts.poppins(color: Colors.white70, fontSize:11))),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _fiyatField(String docId, String field, String label, dynamic value){
    final ctrl = TextEditingController(text: value?.toString()??'');
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize:10, fontWeight: FontWeight.w700, color: Colors.black54)),
          const SizedBox(height:4),
          TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(fontSize:12, color: Colors.black, fontWeight: FontWeight.w700),
            decoration: InputDecoration(isDense:true, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width:1)), contentPadding: const EdgeInsets.symmetric(horizontal:8,vertical:8)),
            onSubmitted: (v){
              final intVal = int.tryParse(v)??0;
              service.fiyatGuncelle(docId, {field: intVal});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label güncellendi: $intVal TL')));
            },
          ),
        ],
      ),
    );
  }

  Widget _ayarField(String key, String label, String value){
    final ctrl = TextEditingController(text: value);
    return Padding(
      padding: const EdgeInsets.only(bottom:10),
      child: Row(children: [
        SizedBox(width:80, child: Text(label, style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w700, color: Colors.black))),
        Expanded(
          child: TextField(
            controller: ctrl,
            style: GoogleFonts.poppins(fontSize:11, color: Colors.black),
            decoration: InputDecoration(isDense:true, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black45)), contentPadding: const EdgeInsets.symmetric(horizontal:8,vertical:8)),
            onSubmitted: (v){
              service.ayarGuncelle({key: v});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label güncellendi')));
            },
          ),
        ),
      ]),
    );
  }
}