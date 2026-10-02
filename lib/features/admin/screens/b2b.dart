// lib/features/admin/screens/b2b.dart - HATASIZ FINAL V2
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/b2b_notification_service.dart';

class B2BLeadsAdminPage extends StatefulWidget {
  const B2BLeadsAdminPage({super.key});
  @override
  State<B2BLeadsAdminPage> createState() => _B2BLeadsAdminPageState();
}

class _B2BLeadsAdminPageState extends State<B2BLeadsAdminPage> {
  String _filterStatus = 'Tümü';
  String _filterCat = 'Tümü';
  final _notificationService = B2BNotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          'B2B Başvuruları',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.black),
        ),
        actions: [
          StreamBuilder<int>(
            stream: _notificationService.unreadCountStream(),
            builder: (context, snap) {
              final count = snap.data?? 0;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.black), onPressed: (){ setState(()=> _filterStatus = 'Yeni'); }),
                  if (count > 0) Positioned(right: 6, top: 6, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Color(0xFFDC143C), shape: BoxShape.circle), child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(child: DropdownButtonFormField<String>(
                  isExpanded: true, // <-- BU KRİTİK FIX
                  value: _filterStatus,
                  decoration: InputDecoration(isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  items: ['Tümü','Yeni','Görüşüldü','Olumlu','Olumsuz'].map((e)=> DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 13)))).toList(),
                  onChanged: (v)=> setState(()=> _filterStatus = v!))),
              const SizedBox(width: 8),
              Expanded(child: DropdownButtonFormField<String>(
                  isExpanded: true, // <-- BU KRİTİK FIX
                  value: _filterCat,
                  decoration: InputDecoration(isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  items: ['Tümü','Banyo & Mutfak','Boya & Dekorasyon','Elektrik & Aydınlatma','Tesisat & Su Sistemleri'].map((e)=> DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 12)))).toList(),
                  onChanged: (v)=> setState(()=> _filterCat = v!))),
            ]),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('corporate_leads').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var docs = snapshot.data!.docs;
                if (_filterStatus!= 'Tümü') docs = docs.where((d)=> (d.data() as Map)['status'] == _filterStatus).toList();
                if (_filterCat!= 'Tümü') docs = docs.where((d)=> ((d.data() as Map)['kategoriler'] as List?)?.contains(_filterCat)?? false).toList();
                if (docs.isEmpty) return Center(child: Text('Başvuru yok', style: GoogleFonts.poppins()));
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  separatorBuilder: (_, __)=> const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final id = docs[i].id;
                    final firma = data['firma']?? '-';
                    final yetkili = data['yetkili']?? '-';
                    final telefon = data['telefon']?? '';
                    final kategoriler = (data['kategoriler'] as List?)?.join(', ')?? '';
                    final status = data['status']?? 'Yeni';
                    final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
                    final isYeni = status == 'Yeni';
                    return InkWell(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => B2BDetailPage(leadId: id, data: data))),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: isYeni? const Color(0xFFDC143C).withValues(alpha: 0.3) : Colors.grey.shade200, width: isYeni? 1.5 : 1)),
                        child: Row(children: [
                          Container(width: 44, height: 44, decoration: BoxDecoration(color: isYeni? const Color(0xFFDC143C) : Colors.black, shape: BoxShape.circle), child: Center(child: Text(firma.isNotEmpty? firma[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [Expanded(child: Text(firma, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14))), if(isYeni) Container(width: 8, height: 8, margin: const EdgeInsets.only(left: 6), decoration: const BoxDecoration(color: Color(0xFFDC143C), shape: BoxShape.circle))]),
                            Text('$yetkili • $telefon', overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                            const SizedBox(height: 4),
                            Text(kategoriler, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ])),
                          const SizedBox(width: 8),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: isYeni? const Color(0xFFDC143C) : Colors.grey.shade200, borderRadius: BorderRadius.circular(20)), child: Text(status, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: isYeni? Colors.white : Colors.black87))),
                            const SizedBox(height: 6),
                            Text(createdAt!= null? '${createdAt.day}.${createdAt.month} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2,'0')}' : '', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
                          ]),
                        ]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class B2BDetailPage extends StatelessWidget {
  final String leadId;
  final Map<String, dynamic> data;
  const B2BDetailPage({super.key, required this.leadId, required this.data});

  @override
  Widget build(BuildContext context) {
    final firma = data['firma']?? '-';
    final yetkili = data['yetkili']?? '-';
    final pozisyon = data['pozisyon']?? '';
    final email = data['email']?? '-';
    final telefon = data['telefon']?? '-';
    final web = data['webSitesi']?? '-';
    final urunAlanlari = data['urunAlanlari'] as Map<String, dynamic>?? {};
    final isBirlikleri = (data['isBirlikleri'] as List?)?.cast<String>()?? [];
    final mesaj = data['mesaj']?? '';
    final source = data['source']?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(firma, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _section('İLETİŞİM', [
            Text('$yetkili ${pozisyon.isNotEmpty? '• $pozisyon' : ''}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            Text(email),
            Text(telefon),
            Text(web)
          ]),
          const SizedBox(height: 16),
          _section('ÜRÜN ALANLARI (ONTOLOJİ)',
            urunAlanlari.entries.map((entry) {
              final cat = entry.key;
              final alts = (entry.value as List).cast<String>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: alts.map<Widget>((altText) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          altText,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _section('İŞ BİRLİĞİ MODELİ', [Wrap(spacing: 6, children: isBirlikleri.map((i)=> Chip(label: Text(i, style: GoogleFonts.poppins(fontSize: 12)))).toList())]),
          if (mesaj.isNotEmpty)...[const SizedBox(height: 16), _section('MESAJ', [Text(mesaj, style: GoogleFonts.poppins(fontSize: 13))])],
          const SizedBox(height: 16),
          Text('Source: $source', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: (){ FirebaseFirestore.instance.collection('corporate_leads').doc(leadId).update({'status':'Görüşüldü'}); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black), child: Text('Görüşüldü Yap', style: GoogleFonts.poppins(color: Colors.white)))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(onPressed: (){ FirebaseFirestore.instance.collection('corporate_leads').doc(leadId).update({'status':'Olumlu'}); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C)), child: Text('Olumlu', style: GoogleFonts.poppins(color: Colors.white)))),
          ]),
        ]),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1, color: Colors.grey[600])),
          const SizedBox(height: 8),
          ...children
        ])
    );
  }
}