// kategoriler_yonetim_view.dart - Kodla ugrasmadan kategori/alt alan/puan duzenle
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hug_market_service.dart';

class KategorilerYonetimView extends StatefulWidget { const KategorilerYonetimView({super.key}); @override State<KategorilerYonetimView> createState()=> _KategorilerYonetimViewState(); }
class _KategorilerYonetimViewState extends State<KategorilerYonetimView>{
  final service = HugMarketService();
  @override Widget build(BuildContext context){
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Kategoriler', style: GoogleFonts.poppins(fontSize:22, fontWeight: FontWeight.w800, color: Colors.black)),
          Text('Kodla uğraşmadan kategori ve alt alanları ekle/çıkar, yüzde oranlarını değiştir', style: GoogleFonts.poppins(fontSize:11, color: Colors.black54)),
        ]),
        ElevatedButton.icon(icon: const Icon(Icons.add, color: Colors.white), label: Text('Yeni Kategori', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)), style: ElevatedButton.styleFrom(backgroundColor: Colors.black), onPressed: ()=> _kategoriDialog()),
      ]),
      const SizedBox(height:20),
      Expanded(child: StreamBuilder<QuerySnapshot>(stream: service.kategorilerStream(), builder: (c,snap){
        if(!snap.hasData) return const Center(child: CircularProgressIndicator());
        if(snap.data!.docs.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Henüz kategori yok', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.black)), const SizedBox(height:8), Text('Varsayılan 18 kategoriyi yüklemek için', style: GoogleFonts.poppins(fontSize:12, color: Colors.black54)), ElevatedButton(onPressed: ()=> _varsayilanlariYukle(), child: const Text('Varsayılanları Yükle'))]));
        return ListView(children: snap.data!.docs.map((doc){
          final data = doc.data() as Map<String,dynamic>;
          final altAlanlar = Map<String,dynamic>.from(data['altAlanlar']??{});
          final toplam = altAlanlar.values.fold(0,(a,b)=> a + (b as int));
          return Container(margin: const EdgeInsets.only(bottom:12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEEEEEE))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(data['ad']??'', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:14, color: Colors.black)),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:4), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)), child: Text(data['tier']??'', style: GoogleFonts.poppins(color: Colors.white, fontSize:10, fontWeight: FontWeight.w700))),
                const SizedBox(width:8),
                Text('$toplam/100 PUAN', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w800, color: toplam==100? Colors.green: Colors.red)),
                IconButton(icon: const Icon(Icons.edit, size:18), onPressed: ()=> _kategoriDialog(docId: doc.id, data: data)),
                IconButton(icon: const Icon(Icons.delete, size:18, color: Colors.red), onPressed: ()=> service.kategoriSil(doc.id)),
              ]),
            ]),
            const SizedBox(height:8),
            Wrap(spacing:6, runSpacing:6, children: altAlanlar.entries.map((e)=> Container(padding: const EdgeInsets.symmetric(horizontal:10,vertical:5), decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black12)), child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(e.key, style: GoogleFonts.poppins(fontSize:11, color: Colors.black, fontWeight: FontWeight.w600)),
              const SizedBox(width:6),
              Container(padding: const EdgeInsets.symmetric(horizontal:6,vertical:2), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)), child: Text('${e.value}%', style: GoogleFonts.poppins(color: Colors.white, fontSize:10, fontWeight: FontWeight.w700))),
            ]))).toList()),
          ]));
        }).toList());
      })),
    ]));
  }

  void _kategoriDialog({String? docId, Map<String,dynamic>? data}){
    final adCtrl = TextEditingController(text: data?['ad']??'');
    final tierCtrl = TextEditingController(text: data?['tier']??'B');
    final altAlanlarCtrl = TextEditingController(text: data?['altAlanlar']!=null ? (data!['altAlanlar'] as Map).entries.map((e)=> '${e.key}:${e.value}').join(', ') : 'İç Cephe Boya:20, Dış Cephe:20');
    showDialog(context: context, builder: (c)=> AlertDialog(
      title: Text(docId==null? 'Yeni Kategori':'Kategoriyi Düzenle', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black)),
      content: SingleChildScrollView(child: Column(children: [
        TextField(controller: adCtrl, decoration: const InputDecoration(labelText: 'Kategori Adı'), style: GoogleFonts.poppins(color: Colors.black)),
        const SizedBox(height:8),
        TextField(controller: tierCtrl, decoration: const InputDecoration(labelText: 'Tier (A/B/C/D)'), style: GoogleFonts.poppins(color: Colors.black)),
        const SizedBox(height:8),
        TextField(controller: altAlanlarCtrl, maxLines:5, decoration: const InputDecoration(labelText: 'Alt Alanlar (Ad:Puan, Ad:Puan)', helperText: 'Örn: İç Boya:20, Dış Boya:20, Astar:12 - Toplam 100 olmalı'), style: GoogleFonts.poppins(color: Colors.black, fontSize:12)),
      ])),
      actions: [
        TextButton(onPressed: ()=> Navigator.pop(c), child: const Text('İptal')),
        ElevatedButton(onPressed: () async {
          final map = <String,int>{};
          for(var item in altAlanlarCtrl.text.split(',')){ final parts=item.split(':'); if(parts.length==2){ map[parts[0].trim()] = int.tryParse(parts[1].trim())??0; } }
          final toplam = map.values.fold(0,(a,b)=> a+b);
          if(toplam!=100){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Toplam 100 olmalı, şu an $toplam'))); return; }
          final payload = {'ad': adCtrl.text.trim(), 'key': adCtrl.text.trim().toLowerCase().replaceAll(' ', '-'), 'tier': tierCtrl.text.trim().toUpperCase(), 'altAlanlar': map, 'sira': DateTime.now().millisecondsSinceEpoch};
          if(docId==null) await service.kategoriEkle(payload); else await service.kategoriGuncelle(docId, payload);
          Navigator.pop(c);
        }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black), child: Text('Kaydet', style: GoogleFonts.poppins(color: Colors.white))),
      ],
    ));
  }

  Future<void> _varsayilanlariYukle() async {
    // 18 varsayilan kategoriyi Firestore'a yukle
    final varsayilan = [
      {'key':'banyo-mutfak','ad':'Banyo & Mutfak','tier':'A','altAlanlar':{'Seramik & Vitrifiye':15,'Banyo Mobilya':15,'Armatür & Batarya':12,'Duş Sistemleri':12,'Küvet & Jakuzi':8,'Gömme Rezervuar':8,'Eviye & Batarya':10,'Fonksiyonel Aksesuar':10,'Aksesuar & Tamamlayıcı':10},'sira':0},
      {'key':'elektrik-aydinlatma','ad':'Elektrik & Aydınlatma','tier':'A','altAlanlar':{'Alçak Gerilim Kablo':20,'Dağıtım & Pano':18,'Anahtar & Priz':15,'Aydınlatma Armatür':15,'LED & Kontrol':12,'Otomasyon KNX':10,'Busbar & Topraklama':5,'Enerji & UPS':5},'sira':1},
      {'key':'boya-dekorasyon','ad':'Boya & Dekorasyon','tier':'B','altAlanlar':{'İç Cephe Boya':20,'Dış Cephe Boya':20,'Astar':12,'Macun & Alçı':10,'Ahşap & Metal Boya':12,'Yalıtım & Kaplama':14,'Özel & Sprey':6,'Yardımcı':6},'sira':5},
    ];
    for(var k in varsayilan){ await service.kategoriEkle(k); }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Varsayılan kategoriler yüklendi')));
  }
}
