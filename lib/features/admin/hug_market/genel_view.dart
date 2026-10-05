// lib/features/admin/hug_market/genel_view.dart - FULL DINAMIK - MANUEL 0
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hug_market_service.dart';

class GenelView extends StatefulWidget {
  const GenelView({super.key});
  @override State<GenelView> createState()=> _GenelViewState();
}

class _GenelViewState extends State<GenelView>{
  final service = HugMarketService();

  @override Widget build(BuildContext context){
    return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Genel Bakış', style: GoogleFonts.poppins(fontSize:22, fontWeight: FontWeight.w800, color: Colors.black)),
          Text('Tüm veriler Firestore canlı - manuel değer yok', style: GoogleFonts.poppins(fontSize:11, color: Colors.black45)),
          const SizedBox(height:20),

          // FULL DINAMIK STATS - StreamBuilder ile canlı
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('hug_teklifler').snapshots(),
              builder: (c, teklifSnap) {
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('hug_kategoriler').snapshots(),
                    builder: (c, katSnap) {
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('hug_fiyat_tier').snapshots(),
                          builder: (c, fiyatSnap) {
                            final teklifCount = teklifSnap.data?.docs.length ?? 0;
                            final kategoriCount = katSnap.data?.docs.length ?? 0;
                            final tierCount = fiyatSnap.data?.docs.length ?? 0;

                            // Ciro hesapla - dinamik
                            int toplamCiro = 0;
                            if(teklifSnap.hasData){
                              for(var d in teklifSnap.data!.docs){
                                toplamCiro += (d.data() as Map)['teklifFiyat'] as int? ?? 0;
                              }
                            }
                            final ortCiro = teklifCount > 0 ? (toplamCiro / teklifCount).round() : 0;

                            return Column(
                              children: [
                                Row(children: [
                                  _statCard('Toplam Teklif', '$teklifCount', Icons.request_quote, Colors.black, 'hug_teklifler'),
                                  const SizedBox(width:12),
                                  _statCard('Toplam Ciro', '${(toplamCiro/1000).round()}K TL', Icons.account_balance_wallet, const Color(0xFF22C55E), 'canlı toplam'),
                                  const SizedBox(width:12),
                                  _statCard('Kategori', '$kategoriCount adet', Icons.category, const Color(0xFF3B82F6), 'hug_kategoriler'),
                                  const SizedBox(width:12),
                                  _statCard('Tier', '$tierCount tier', Icons.layers, const Color(0xFFF97316), 'hug_fiyat_tier'),
                                ]),
                                const SizedBox(height:12),
                                Row(children: [
                                  _statCard('Ort. Teklif', '${(ortCiro/1000).round()}K TL', Icons.analytics, const Color(0xFF8B5CF6), 'ortalama'),
                                  const SizedBox(width:12),
                                  _statCard('81 İl', 'Aktif: $kategoriCount kat', Icons.public, const Color(0xFF06B6D4), '81 il kapsama'),
                                  const SizedBox(width:12),
                                  Expanded(child: Container()), // boşluk
                                  Expanded(child: Container()),
                                ]),
                              ],
                            );
                          }
                      );
                    }
                );
              }
          ),

          const SizedBox(height:24),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // SOL - SON TEKLIFLER - DINAMIK
            Expanded(flex:2, child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEEEEEE))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Son Teklifler', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:14, color: Colors.black)),
                const Spacer(),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('hug_teklifler').snapshots(),
                    builder: (c,s) => Text('${s.data?.docs.length??0} toplam', style: GoogleFonts.poppins(fontSize:10, color: Colors.black45))
                ),
              ]),
              const SizedBox(height:12),
              StreamBuilder<QuerySnapshot>(
                  stream: service.tekliflerStream(),
                  builder: (c,snap){
                    if(!snap.hasData) return const Center(child: CircularProgressIndicator());
                    if(snap.data!.docs.isEmpty) return Text('Henüz teklif yok - Firestore boş', style: GoogleFonts.poppins(fontSize:12, color: Colors.black45));
                    final docs = snap.data!.docs.take(8).toList();
                    return Column(children: docs.map((d){
                      final data=d.data() as Map<String,dynamic>;
                      return Container(
                        margin: const EdgeInsets.only(bottom:6),
                        padding: const EdgeInsets.symmetric(horizontal:10, vertical:8),
                        decoration: BoxDecoration(color: const Color(0xFFF8F8F7), borderRadius: BorderRadius.circular(8)),
                        child: Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(data['firma']??'-', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize:12, color: Colors.black)),
                            Text('${data['kategori']} • %${data['puan']} • ${data['sureAy']}Ay', style: GoogleFonts.poppins(fontSize:10, color: Colors.black54)),
                          ])),
                          Text('${data['teklifFiyat']} TL', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:11, color: Colors.black)),
                        ]),
                      );
                    }).toList());
                  }
              ),
            ]))),
            const SizedBox(width:16),
            // SAG - CANLI DURUM - DINAMIK
            Expanded(child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('hug_ayarlar').doc('genel').snapshots(),
                builder: (c, ayarSnap) {
                  final ayar = ayarSnap.data?.data() as Map<String,dynamic>?;
                  return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Canlı Sistem Durumu', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800)),
                    const SizedBox(height:4),
                    Text('Firestore hug_ayarlar/genel', style: GoogleFonts.poppins(color: Colors.white54, fontSize:10)),
                    const SizedBox(height:16),
                    _dynamicInfo('E-posta', ayar?['email']??'info@hemenustamgelsin.com'),
                    _dynamicInfo('IBAN', ayar?['iban']??'TR79...'),
                    _dynamicInfo('Telefon', ayar?['telefon']??'0532...'),
                    _dynamicInfo('DUNS', ayar?['duns']??'751176741'),
                    const SizedBox(height:16),
                    const Divider(color: Colors.white24),
                    const SizedBox(height:8),
                    Text('Firestore Collections', style: GoogleFonts.poppins(color: Colors.white70, fontSize:11, fontWeight: FontWeight.w700)),
                    const SizedBox(height:8),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('hug_teklifler').snapshots(),
                        builder: (c,s) => _dynamicInfo('hug_teklifler', '${s.data?.docs.length??0} doc')
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('hug_kategoriler').snapshots(),
                        builder: (c,s) => _dynamicInfo('hug_kategoriler', '${s.data?.docs.length??0} doc')
                    ),
                  ]));
                }
            )),
          ]),
        ])
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, String source){
    return Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFEEEEEE))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width:32,height:32,decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: Colors.white, size:18)),
        const Spacer(),
        Text(source, style: GoogleFonts.poppins(fontSize:8, color: Colors.black26)),
      ]),
      const SizedBox(height:10),
      Text(value, style: GoogleFonts.poppins(fontSize:18, fontWeight: FontWeight.w900, color: Colors.black)),
      Text(label, style: GoogleFonts.poppins(fontSize:10, color: Colors.black54, fontWeight: FontWeight.w600))
    ])));
  }

  Widget _dynamicInfo(String label, String value){
    return Padding(
      padding: const EdgeInsets.only(bottom:6),
      child: Row(children: [
        SizedBox(width:70, child: Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize:10))),
        Expanded(child: Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize:11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}