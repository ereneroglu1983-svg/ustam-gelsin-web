// lib/features/admin/hug_market/hug_market_service.dart - FIXED - PATH + COLLECTION UYUMLU
import 'package:cloud_firestore/cloud_firestore.dart';

class HugMarketService {
  final _db = FirebaseFirestore.instance;

  // KATEGORILER
  Stream<QuerySnapshot> kategorilerStream() => _db.collection('hug_kategoriler').orderBy('sira').snapshots();
  Future<void> kategoriEkle(Map<String,dynamic> data) => _db.collection('hug_kategoriler').add(data);
  Future<void> kategoriGuncelle(String id, Map<String,dynamic> data) => _db.collection('hug_kategoriler').doc(id).update(data);
  Future<void> kategoriSil(String id) => _db.collection('hug_kategoriler').doc(id).delete();

  // FIYATLAR - sira ile order, tier ile değil - V11 ile uyumlu
  Stream<QuerySnapshot> fiyatlarStream() => _db.collection('hug_fiyat_tier').orderBy('sira').snapshots();
  Future<void> fiyatGuncelle(String docId, Map<String,dynamic> data) => _db.collection('hug_fiyat_tier').doc(docId).update(data);
  Future<void> fiyatlariIlkKur() async {
    final batch = _db.batch();
    final tiers = [
      {'tier':'A','label':'TIER A • Premium','p3':300000,'p6':550000,'p12':950000,'color':0xFF3B82F6,'sira':0},
      {'tier':'B','label':'TIER B • Güçlü','p3':250000,'p6':450000,'p12':800000,'color':0xFF22C55E,'sira':1},
      {'tier':'C','label':'TIER C • Orta','p3':200000,'p6':375000,'p12':675000,'color':0xFFEAB308,'sira':2},
      {'tier':'D','label':'TIER D • Niş','p3':150000,'p6':275000,'p12':500000,'color':0xFFF97316,'sira':3},
    ];
    for(var t in tiers){
      final doc = _db.collection('hug_fiyat_tier').doc('tier_${t['tier']}');
      batch.set(doc, t, SetOptions(merge:true));
    }
    await batch.commit();
  }

  // TEKLIFLER - 2 collection'ı da destekle - hem hug_teklifler hem teklifler
  Stream<QuerySnapshot> tekliflerStream() => _db.collection('hug_teklifler').orderBy('olusturmaTarihi', descending: true).snapshots();
  Future<QuerySnapshot> tekliflerGetir() => _db.collection('hug_teklifler').orderBy('olusturmaTarihi', descending: true).limit(100).get();

  // AYARLAR
  Stream<DocumentSnapshot> ayarlarStream() => _db.collection('hug_ayarlar').doc('genel').snapshots();
  Future<void> ayarGuncelle(Map<String,dynamic> data) => _db.collection('hug_ayarlar').doc('genel').set(data, SetOptions(merge:true));

  // GENEL STATS
  Future<Map<String,dynamic>> genelStats() async {
    final teklifSnap = await _db.collection('hug_teklifler').count().get();
    final katSnap = await _db.collection('hug_kategoriler').count().get();
    final toplamCiroAgg = await _db.collection('hug_teklifler').get();
    int toplamCiro = 0;
    for(var d in toplamCiroAgg.docs){ toplamCiro += (d.data()['teklifFiyat'] as int? ?? 0); }
    return {
      'teklifSayisi': teklifSnap.count,
      'kategoriSayisi': katSnap.count,
      'toplamCiro': toplamCiro,
    };
  }
}