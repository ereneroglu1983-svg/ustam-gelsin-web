// lib/features/home/widgets/ilan_akisi_slider.dart - TAMAMEN FIXLENDI
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/constants/meslekler_data.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_auth_page.dart';

class IlanAkisiSlider extends StatelessWidget {
  final double? ustaLat;
  final double? ustaLng;
  const IlanAkisiSlider({super.key, this.ustaLat, this.ustaLng});

  String? _getKategoriResmi(String kategori) {
    try {
      final meslek = MesleklerData.hizmetlerDetayli.firstWhere((m) => m.isim.toUpperCase() == kategori.toUpperCase());
      return meslek.resimYolu;
    } catch (_) { return null; }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return StreamBuilder<List<IlanModel>>(
      stream: AdService().getAktifIlanlar(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Hata oluştu."));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("İlan bulunmuyor."));

        List<IlanModel> ilanlar = snapshot.data!.where((i){
          bool acil1 = i.isAcil == true;
          bool acil2 = i.teknikDetaylar['isAcil'] == true;
          return!acil1 &&!acil2;
        }).toList()..sort((a,b)=> b.tarih.compareTo(a.tarih));
        ilanlar = ilanlar.take(6).toList();
        if (ilanlar.isEmpty) return const SizedBox.shrink();

        // WEB'DE YATAY, MOBIL'DE DIKEY - TAKILMA BITTI
        if (isWeb) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch}, scrollbars: false),
            child: SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                cacheExtent: 1000,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ilanlar.length,
                itemBuilder: (context, index)=> SizedBox(width: 380, child: _ilanKarti(context, ilanlar[index])),
              ),
            ),
          );
        } else {
          return Column(
            children: ilanlar.map((e)=> _ilanKarti(context, e)).toList(),
          );
        }
      },
    );
  }

  Widget _ilanKarti(BuildContext context, IlanModel ilan) {
    final kategoriResim = _getKategoriResmi(ilan.kategori);
    return RepaintBoundary(
      child: GestureDetector(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const UstaAuthPage(role: "usta"))),
        child: Container(
          margin: const EdgeInsets.only(bottom:12, right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.2))),
          child: Row(children:[
            ClipRRect(borderRadius: BorderRadius.circular(8),
              child: SizedBox(width:80, height:80,
                child: (ilan.resimler.isNotEmpty && ilan.resimler.first.isNotEmpty)
                    ? CachedNetworkImage(imageUrl: ilan.resimler.first, fit: BoxFit.cover, memCacheWidth: 200, memCacheHeight: 200,
                    errorWidget: (_,__,___)=> kategoriResim!=null? Image.asset(kategoriResim, fit:BoxFit.cover) : Container(color:Colors.grey[200], child: const Icon(Icons.build)))
                    : (kategoriResim!=null? Image.asset(kategoriResim, fit:BoxFit.cover, cacheWidth: 200) : Container(color:Colors.grey[200], child: const Icon(Icons.build))),
              ),
            ),
            const SizedBox(width:12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
              // FutureBuilder SİLDİM - her kartta Firestore read yapıyordu, lag sebebi oydu
              Text("${ilan.kategori} - ${ilan.sehirIlceMetni??''}", style: const TextStyle(fontWeight:FontWeight.bold, fontSize:13), maxLines:1, overflow:TextOverflow.ellipsis),
              const SizedBox(height:4),
              Row(children:[const Icon(Icons.location_on, size:12, color:Colors.red), const SizedBox(width:6), Expanded(child: Text(ilan.sehirIlceMetni??"Konum yok", style: const TextStyle(fontSize:11, color:Colors.grey), maxLines:1))]),
              const SizedBox(height:6),
              if (ilan.teknikDetaylar.isNotEmpty)
                Wrap(spacing:4, children: ilan.teknikDetaylar.values.where((e)=> e!=null && e.toString().isNotEmpty && e.toString()!="false").take(3).map((e)=> Container(padding: const EdgeInsets.symmetric(horizontal:6, vertical:2), decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(e.toString(), style: const TextStyle(fontSize:10, color:Colors.black54)))).toList()),
            ])),
            Column(children:[
              ElevatedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const UstaAuthPage(role: "usta"))), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal:12)), child: const Text("Teklif Ver", style: TextStyle(fontSize:11, color:Colors.white))),
              const SizedBox(height:4),
              Text("${ilan.teklifSayisi} Teklif", style: const TextStyle(fontSize:10, color:Colors.grey)),
            ])
          ]),
        ),
      ),
    );
  }
}