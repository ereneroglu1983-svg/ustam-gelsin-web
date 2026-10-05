// lib/features/admin/hug_market/kategori_munhasir_motoru.dart - V11 FIXED EDITABLE
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../services/teklif_pdf_service.dart';
import 'hug_market_service.dart';

enum Tier { A, B, C, D }

class TierPricing {
  final Tier tier;
  final String label;
  final Color color;
  final int p3, p6, p12;
  TierPricing({required this.tier, required this.label, required this.color, required this.p3, required this.p6, required this.p12});
}

class KategoriModel {
  final String key;
  final String ad;
  final Tier tier;
  final Map<String,int> altAlanlar;
  KategoriModel({required this.key, required this.ad, required this.tier, required this.altAlanlar});
}

class KategoriMunhasirMotoruPage extends StatefulWidget {
  const KategoriMunhasirMotoruPage({super.key});
  @override
  State<KategoriMunhasirMotoruPage> createState() => _KategoriMunhasirMotoruPageState();
}

class _KategoriMunhasirMotoruPageState extends State<KategoriMunhasirMotoruPage> {
  int _sekme = 1;
  final _firmaCtrl = TextEditingController();
  final _yetkiliCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final hugService = HugMarketService();

  List<TierPricing> tierList = [
    TierPricing(tier: Tier.A, label: 'TIER A • Premium', color: const Color(0xFF3B82F6), p3: 300000, p6: 550000, p12: 950000),
    TierPricing(tier: Tier.B, label: 'TIER B • Güçlü', color: const Color(0xFF22C55E), p3: 250000, p6: 450000, p12: 800000),
    TierPricing(tier: Tier.C, label: 'TIER C • Orta', color: const Color(0xFFEAB308), p3: 200000, p6: 375000, p12: 675000),
    TierPricing(tier: Tier.D, label: 'TIER D • Niş', color: const Color(0xFFF97316), p3: 150000, p6: 275000, p12: 500000),
  ];

  late List<KategoriModel> tumKategoriler;
  KategoriModel? seciliKategori;
  Map<String,bool> seciliAltlar = {};
  int seciliSure = 3;
  bool _firestoreYukleniyor = false;

  @override
  void initState() {
    super.initState();
    tumKategoriler = _buildKategoriler();
    seciliKategori = tumKategoriler.firstWhere((k)=> k.key=='boya-dekorasyon');
    _resetAltlar();
    _firestoreVerileriniDene();
  }

  @override
  void dispose(){
    _firmaCtrl.dispose();
    _yetkiliCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _firestoreVerileriniDene() async {
    setState(()=> _firestoreYukleniyor=true);
    try{
      final db = FirebaseFirestore.instance;
      final fiyatSnap = await db.collection('hug_fiyat_tier').orderBy('sira').get();
      if(fiyatSnap.docs.isNotEmpty){
        final newTierList = fiyatSnap.docs.map((d){
          final data = d.data();
          Tier t = Tier.B;
          if(data['tier']=='A') t = Tier.A;
          else if(data['tier']=='B') t = Tier.B;
          else if(data['tier']=='C') t = Tier.C;
          else if(data['tier']=='D') t = Tier.D;
          return TierPricing(tier: t, label: data['label']??'TIER', color: Color(data['color'] as int), p3: (data['p3'] as num).toInt(), p6: (data['p6'] as num).toInt(), p12: (data['p12'] as num).toInt());
        }).toList();
        if(newTierList.isNotEmpty) setState(()=> tierList = newTierList);
      }
      final katSnap = await db.collection('hug_kategoriler').orderBy('sira').get();
      if(katSnap.docs.isNotEmpty){
        final newKats = katSnap.docs.map((d){
          final data = d.data();
          Tier t = Tier.B;
          if(data['tier']=='A') t = Tier.A;
          else if(data['tier']=='B') t = Tier.B;
          else if(data['tier']=='C') t = Tier.C;
          else if(data['tier']=='D') t = Tier.D;
          return KategoriModel(key: data['key'], ad: data['ad'], tier: t, altAlanlar: Map<String,int>.from((data['altAlanlar'] as Map).map((k,v)=> MapEntry(k.toString(), (v as num).toInt()))));
        }).toList();
        if(newKats.isNotEmpty){
          setState((){
            tumKategoriler = newKats;
            seciliKategori = tumKategoriler.firstWhere((k)=> k.key=='boya-dekorasyon', orElse: ()=> tumKategoriler.first);
            _resetAltlar();
          });
        }
      }
    }catch(_){}
    setState(()=> _firestoreYukleniyor=false);
  }

  List<KategoriModel> _buildKategoriler() {
    return [
      KategoriModel(key: 'banyo-mutfak', ad: 'Banyo & Mutfak', tier: Tier.A, altAlanlar: {'Seramik & Vitrifiye':15,'Banyo Mobilya':15,'Armatür & Batarya':12,'Duş Sistemleri':12,'Küvet & Jakuzi':8,'Gömme Rezervuar':8,'Eviye & Batarya':10,'Fonksiyonel Aksesuar':10,'Aksesuar & Tamamlayıcı':10}),
      KategoriModel(key: 'elektrik-aydinlatma', ad: 'Elektrik & Aydınlatma', tier: Tier.A, altAlanlar: {'Alçak Gerilim Kablo':20,'Dağıtım & Pano':18,'Anahtar & Priz':15,'Aydınlatma Armatür':15,'LED & Kontrol':12,'Otomasyon KNX':10,'Busbar & Topraklama':5,'Enerji & UPS':5}),
      KategoriModel(key: 'seramik-fayans-zemin', ad: 'Seramik Fayans Zemin', tier: Tier.A, altAlanlar: {'Seramik Karo':20,'Büyük Ebat Porselen':18,'Doğal Taş & Mermer':10,'Parke & Laminat':15,'LVT & Vinil':12,'Epoksi & Zemin':10,'Profil & Aksesuar':8,'Dekoratif 3D':7}),
      KategoriModel(key: 'yapi-malzemeleri-insaat', ad: 'Yapı Malzemeleri', tier: Tier.A, altAlanlar: {'Çimento & Beton':18,'Hazır Beton & Harç':15,'Gazbeton & Tuğla':12,'Alçı & Alçıpan':15,'Kuru Harç & Şap':12,'Yapıştırıcı & Derz':10,'Donatı & Kalıp':10,'Güçlendirme Kimyasalı':8}),
      KategoriModel(key: 'yenilenebilir-enerji-guc-sistemleri', ad: 'Yenilenebilir Enerji & Güç', tier: Tier.A, altAlanlar: {'Çatı GES':20,'Arazi GES':15,'Panel':12,'İnvertör':12,'Montaj & Taşıyıcı':8,'Enerji Depolama':10,'RES Rüzgar':8,'EV Şarj':5,'İzleme & Yönetim':10}),
      KategoriModel(key: 'boya-dekorasyon', ad: 'Boya & Dekorasyon', tier: Tier.B, altAlanlar: {'İç Cephe Boya':20,'Dış Cephe Boya':20,'Astar':12,'Macun & Alçı':10,'Ahşap & Metal Boya':12,'Yalıtım & Kaplama':14,'Özel & Sprey':6,'Yardımcı':6}),
      KategoriModel(key: 'isitma-sogutma-iklimlendirme', ad: 'Isıtma Soğutma İklimlendirme', tier: Tier.B, altAlanlar: {'Kombi & Kazan':20,'Radyatör & Yerden':18,'Isı Pompası':12,'Split Klima':15,'VRF & Chiller':12,'Havalandırma HRV':10,'Radyant & Infrared':8,'Otomasyon':5}),
      KategoriModel(key: 'tesisat-su-sistemleri', ad: 'Tesisat & Su Sistemleri', tier: Tier.B, altAlanlar: {'Temiz Su Boru':20,'Atık Su & Drenaj':15,'Fittings & Pres':12,'Vana & Kontrol':12,'Pompa & Hidrofor':15,'Depolama & Arıtma':10,'Yangın & Sprinkler':8,'Altyapı':8}),
      KategoriModel(key: 'yalitim-izolasyon', ad: 'Yalıtım & İzolasyon', tier: Tier.B, altAlanlar: {'Isı Mantolama ETICS':22,'Su Membran':18,'Çatı & Temel':15,'Cephe Kaplama':12,'Ses & Akustik':10,'Yangın Pasif':10,'Teknik Tesisat':8,'Bant & Aksesuar':5}),
      KategoriModel(key: 'kapi-kilit-gecis-kontrol', ad: 'Kapı Kilit Geçiş', tier: Tier.B, altAlanlar: {'Çelik Kapı':22,'İç Kapı':18,'Yangın Kapısı':12,'Endüstriyel Seksiyonel':10,'Kilit & Barel':12,'Kol & Menteşe':10,'Otomatik Fotoselli':8,'Kartlı Geçiş':8}),
      KategoriModel(key: 'cati-cephe-sistemleri', ad: 'Çatı & Cephe', tier: Tier.C, altAlanlar: {'Çatı Kaplama':20,'Sandviç Panel':15,'Yalıtım Buhar':15,'Cephe Kaplama':18,'Mantolama':12,'Konstrüksiyon':8,'Oluk & İniş':7,'Işıklık & Aksesuar':5}),
      KategoriModel(key: 'cam-aluminyum-cephe-sistemleri', ad: 'Cam Alüminyum Cephe', tier: Tier.C, altAlanlar: {'Cam & Şişecam':20,'Doğrama Pencere':20,'Giydirme Curtain Wall':15,'Sürme & Katlanır':12,'Küpeşte & Korkuluk':10,'Güneş Kırıcı':8,'Otomatik Kapı':8,'Kompozit & Aksesuar':7}),
      KategoriModel(key: 'hirdavat-el-aletleri-is-guvenligi', ad: 'Hırdavat & El Aletleri', tier: Tier.C, altAlanlar: {'El Aletleri':15,'Elektrikli Akülü':18,'Kesici & Delici':10,'Ölçüm & Lazer':8,'Kompresör & Pnömatik':10,'Bağlantı & Ankraj':12,'Yapıştırıcı Kimya':10,'KKD İş Güvenliği':10,'Depolama Atölye':7}),
      KategoriModel(key: 'bahce-peyzaj-dis-mekan', ad: 'Bahçe Peyzaj Dış Mekan', tier: Tier.C, altAlanlar: {'Bahçe Makine':18,'Sulama Damlama':15,'Peyzaj Zemin':12,'Dış Zemin Duvar':12,'Pergola Yapı':10,'Dış Mobilya':8,'Bakım El Aleti':8,'Dış Aydınlatma':7,'Ahşap WPC':10}),
      KategoriModel(key: 'guvenlik-yangin-zayif-akim', ad: 'Güvenlik Yangın Zayıf Akım', tier: Tier.C, altAlanlar: {'Yangın Algılama':20,'Acil Anons':12,'CCTV Kamera':18,'Hırsız Alarm':12,'Interkom Diafon':10,'Data & Zayıf Akım':12,'PDKS & Takip':8,'Paratoner & Topraklama':8}),
      KategoriModel(key: 'temizlik-hijyen', ad: 'Temizlik & Hijyen', tier: Tier.D, altAlanlar: {'Yüzey Kimyasal':20,'Endüstriyel Teknik':15,'Mutfak Hijyen':15,'Çamaşırhane':10,'Dezenfeksiyon':10,'Makine Ekipman':12,'Kağıt Sarf':10,'Dispenser Koku':8}),
      KategoriModel(key: 'havuz-spa-sistemleri', ad: 'Havuz & Spa', tier: Tier.D, altAlanlar: {'Yapı & Kaplama':15,'Filtrasyon & Pompa':18,'Dezenfeksiyon Dozaj':15,'Isıtma & Isı Pompası':12,'Aydınlatma Robot':8,'Otomasyon Kontrol':10,'Örtü Lamel':7,'Kimyasal Bakım':8,'Spa Sauna':7}),
      KategoriModel(key: 'asansor-yuruyen-merdiven', ad: 'Asansör & Yürüyen Merdiven', tier: Tier.D, altAlanlar: {'İnsan & Konut':22,'Yük & Sedye':15,'Yürüyen Merdiven':12,'Panoramik Özel':10,'Engelli Platform':10,'Kabin Kapı Ray':12,'Otopark Park':9,'Modernizasyon Bakım':10}),
    ];
  }

  void _resetAltlar(){
    seciliAltlar = { for (var e in seciliKategori!.altAlanlar.keys) e: true };
  }

  TierPricing get _tierPricing => tierList.firstWhere((t)=> t.tier==seciliKategori!.tier);
  int get _toplamPuan => seciliAltlar.entries.where((e)=> e.value).fold(0,(sum,e)=> sum + (seciliKategori!.altAlanlar[e.key]??0));
  int get _tamFiyat {
    if(seciliSure==3) return _tierPricing.p3;
    if(seciliSure==6) return _tierPricing.p6;
    return _tierPricing.p12;
  }
  int get _hesaplananFiyat => ((_tamFiyat * _toplamPuan) / 100).round();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states){
            if(states.contains(WidgetState.selected)) return Colors.black;
            return Colors.white;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: const BorderSide(color: Colors.black, width:1.5),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111111),
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(
            children: [
              const SizedBox(width: 12),
              InkWell(onTap: ()=> Navigator.of(context).maybePop(), child: const Icon(Icons.arrow_back, color: Colors.white, size: 22)),
              const SizedBox(width: 12),
              Text('HUG MARKET', style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.white, letterSpacing: 0.5)),
              const SizedBox(width: 16),
              _sekmeBtn('Genel', 0),
              _sekmeBtn('Kategoriler', 1),
              _sekmeBtn('Teklifler', 2),
              _sekmeBtn('Raporlar', 3),
              _sekmeBtn('Ayarlar', 4),
            ],
          ),
          actions: [
            if(_firestoreYukleniyor) const Padding(padding: EdgeInsets.only(right:12), child: Center(child: SizedBox(width:16,height:16,child: CircularProgressIndicator(strokeWidth:2, color: Colors.white)))),
            Container(margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Center(child: Text('${tumKategoriler.length} Kategori • 81 İl • ${_firestoreYukleniyor ? 'Yükleniyor' : 'Hazır'}', style: GoogleFonts.poppins(color: Colors.black, fontSize:11, fontWeight: FontWeight.w800)))),
          ],
        ),
        body: IndexedStack(index: _sekme, children: [_buildGenelTab(), _buildMotorTab(), _buildTekliflerTab(), _buildRaporlarTab(), _buildAyarlarTabEditable()]),
      ),
    );
  }

  Widget _sekmeBtn(String label, int idx){
    final sel = _sekme==idx;
    return Padding(padding: const EdgeInsets.only(right: 6), child: InkWell(onTap: ()=> setState(()=> _sekme=idx), borderRadius: BorderRadius.circular(8), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: sel? Colors.white : const Color(0xFF222222), borderRadius: BorderRadius.circular(8), border: Border.all(color: sel? Colors.white : const Color(0xFF333333))), child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: sel? FontWeight.w800: FontWeight.w600, color: sel? Colors.black: Colors.white70)))));
  }

  Widget _buildGenelTab(){
    return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Genel Dashboard', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 20)),
      const SizedBox(height: 16),
      Row(children: [_statBox('Toplam Kategori', '${tumKategoriler.length}', const Color(0xFF3B82F6)), const SizedBox(width: 12), _statBox('Aktif Teklif', '42', const Color(0xFF22C55E)), const SizedBox(width: 12), _statBox('Bekleyen', '3', const Color(0xFFF59E0B)), const SizedBox(width: 12), _statBox('Ciro', '1.2M TL', const Color(0xFF8B5CF6))]),
    ]));
  }

  Widget _statBox(String title, String val, Color c){
    return Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFDDDDDD))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: c.withValues(alpha:0.15), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.dashboard, color: c, size: 18)), const SizedBox(height: 8), Text(val, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 20)), Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54)) ])));
  }

  Widget _buildMotorTab(){
    return Row(children: [
      Container(width: 300, color: Colors.white, child: Column(children: [
        Container(width: double.infinity, color: const Color(0xFF111111), padding: const EdgeInsets.all(12), child: Row(children: [Text('KATEGORİ SEÇ', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w800, letterSpacing:1, color: Colors.white)), const Spacer(), InkWell(onTap: _firestoreVerileriniDene, child: const Icon(Icons.refresh, color: Colors.white, size:16)) ])),
        Expanded(child: ListView(padding: const EdgeInsets.only(top:8), children: tierList.map((tier){
          final cats = tumKategoriler.where((c)=> c.tier==tier.tier).toList();
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: const EdgeInsets.symmetric(horizontal:12,vertical:6), padding: const EdgeInsets.symmetric(horizontal:10,vertical:6), decoration: BoxDecoration(color: tier.color.withValues(alpha:0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: tier.color.withValues(alpha:0.3))), child: Row(children: [Container(width:8,height:8,decoration: BoxDecoration(color: tier.color, shape: BoxShape.circle)), const SizedBox(width:6), Text(tier.label, style: GoogleFonts.poppins(fontSize:11,fontWeight: FontWeight.w800, color: Colors.black)), const Spacer(), Text('${tier.p3~/1000}K / ${tier.p6~/1000}K / ${tier.p12~/1000}K', style: GoogleFonts.poppins(fontSize:9, fontWeight: FontWeight.w800, color: Colors.black87))])),
            ...cats.map((cat){ final isSel = seciliKategori?.key==cat.key; return InkWell(onTap: (){ setState((){ seciliKategori=cat; _resetAltlar(); }); }, child: Container(margin: const EdgeInsets.symmetric(horizontal:12,vertical:3), padding: const EdgeInsets.symmetric(horizontal:12,vertical:12), decoration: BoxDecoration(color: isSel? Colors.black : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSel? Colors.black : const Color(0xFFDDDDDD), width: 1.2)), child: Row(children: [Expanded(child: Text(cat.ad, style: GoogleFonts.poppins(fontSize:13, fontWeight: FontWeight.w700, color: isSel? Colors.white : Colors.black))), if(isSel) const Icon(Icons.check_circle, size:18, color: Colors.white)]))); }),
            const SizedBox(height:8),
          ]);
        }).toList())),
      ])),
      Expanded(flex: 2, child: seciliKategori==null? const SizedBox(): SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFDDDDDD), width:1.2)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Container(width: 48, height:48, decoration: BoxDecoration(color: _tierPricing.color, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.category, color: Colors.white, size: 24)), const SizedBox(width:12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(seciliKategori!.ad, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:18, color: Colors.black)), Text('${_tierPricing.label} • Tam Fiyat ${_tierPricing.p3~/1000}K / ${_tierPricing.p6~/1000}K / ${_tierPricing.p12~/1000}K • 81 İl', style: GoogleFonts.poppins(fontSize:11, color: Colors.black87, fontWeight: FontWeight.w600))])), Container(padding: const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)), child: Text('$_toplamPuan / 100 PUAN', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize:12)))]),
          const SizedBox(height:16),
          Container(color: Colors.black, padding: const EdgeInsets.symmetric(horizontal:10,vertical:6), child: Text('ALT ALANLAR & AĞIRLIK (100 PUAN)', style: GoogleFonts.poppins(fontSize:10, fontWeight: FontWeight.w800, letterSpacing:1, color: Colors.white))),
          const SizedBox(height:10),
          ...seciliKategori!.altAlanlar.entries.map((e){ final sel = seciliAltlar[e.key]??false; return Container(margin: const EdgeInsets.only(bottom:8), padding: const EdgeInsets.symmetric(horizontal:12,vertical:12), decoration: BoxDecoration(color: sel? Colors.white : const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(12), border: Border.all(color: sel? Colors.black : const Color(0xFFCCCCCC), width: sel?1.8:1.2)), child: Row(children: [Checkbox(value: sel, onChanged: (v){ setState(()=> seciliAltlar[e.key]=v!); }, activeColor: Colors.black, checkColor: Colors.white, side: const BorderSide(color: Colors.black, width:1.5)), Expanded(child: Text(e.key, style: GoogleFonts.poppins(fontSize:14, fontWeight: sel? FontWeight.w700: FontWeight.w500, color: Colors.black))), Container(padding: const EdgeInsets.symmetric(horizontal:10,vertical:5), decoration: BoxDecoration(color: sel? Colors.black : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black)), child: Text('${e.value} P', style: GoogleFonts.poppins(fontSize:12, color: sel? Colors.white: Colors.black, fontWeight: FontWeight.w800)))])); }),
          const SizedBox(height:16),
          Row(children: [Expanded(child: ElevatedButton(onPressed: (){ setState(()=> seciliAltlar.updateAll((k,v)=> true)); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white), child: Text('Tümünü Seç (100 Puan = Full)', style: GoogleFonts.poppins(fontSize:12, fontWeight: FontWeight.w700, color: Colors.white)))), const SizedBox(width:8), Expanded(child: OutlinedButton(onPressed: (){ setState(()=> seciliAltlar.updateAll((k,v)=> false)); }, style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black, width:1.5)), child: Text('Temizle', style: GoogleFonts.poppins(fontSize:12, fontWeight: FontWeight.w700, color: Colors.black))))]),
        ])),
        const SizedBox(height:16),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFDDDDDD), width:1.2)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(color: Colors.black, padding: const EdgeInsets.symmetric(horizontal:10,vertical:6), child: Text('SÜRE SEÇ', style: GoogleFonts.poppins(fontSize:10, fontWeight: FontWeight.w800, letterSpacing:1, color: Colors.white))), const SizedBox(height:12), Row(children: [_sureChip('3 Ay', 3), const SizedBox(width:8), _sureChip('6 Ay', 6), const SizedBox(width:8), _sureChip('12 Ay', 12)]), const SizedBox(height:14), Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(12)), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('HESAPLAMA FORMÜLÜ', style: GoogleFonts.poppins(fontSize:10, fontWeight: FontWeight.w800, color: Colors.white70, letterSpacing:1)), const SizedBox(height:6), Text('$_toplamPuan / 100 x ${_tamFiyat} TL = $_hesaplananFiyat TL', style: GoogleFonts.poppins(fontSize:14, fontWeight: FontWeight.w800, color: Colors.white)), const SizedBox(height:4), Text('Tam kategori: ${_tamFiyat} TL • Seçili kapsam: %$_toplamPuan • Aylık: ${(_hesaplananFiyat / seciliSure).round()} TL', style: GoogleFonts.poppins(fontSize:12, color: Colors.white70, fontWeight: FontWeight.w600))]))]))])),
      ]))),
      Container(width: 360, color: Colors.white, child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(color: Colors.black, padding: const EdgeInsets.symmetric(horizontal:10,vertical:6), child: Text('TEKLİF ÖZETİ', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w800, letterSpacing:1, color: Colors.white))),
        const SizedBox(height:14),
        TextField(controller: _firmaCtrl, style: GoogleFonts.poppins(fontSize:14, color: Colors.black, fontWeight: FontWeight.w600), decoration: InputDecoration(labelText:'Firma Ünvanı *', labelStyle: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w700), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.5)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.2)))),
        const SizedBox(height:10),
        TextField(controller: _yetkiliCtrl, style: GoogleFonts.poppins(fontSize:14, color: Colors.black, fontWeight: FontWeight.w600), decoration: InputDecoration(labelText:'Yetkili Kişi', labelStyle: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w700), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.5)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.2)))),
        const SizedBox(height:10),
        TextField(controller: _emailCtrl, style: GoogleFonts.poppins(fontSize:14, color: Colors.black, fontWeight: FontWeight.w600), decoration: InputDecoration(labelText:'E-posta *', labelStyle: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w700), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.5)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.2)))),
        const SizedBox(height:16),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CANLI TEKLİF', style: GoogleFonts.poppins(color: Colors.white70, fontSize:10, fontWeight: FontWeight.w800, letterSpacing:1)), const SizedBox(height:8), Text(seciliKategori?.ad??'-', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize:16)), const SizedBox(height:6), Text(seciliAltlar.entries.where((e)=> e.value).map((e)=> e.key).join(', '), style: GoogleFonts.poppins(color: Colors.white70, fontSize:11, fontWeight: FontWeight.w500), maxLines:3, overflow: TextOverflow.ellipsis), const Divider(color: Colors.white24, height:24), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Kapsam', style: GoogleFonts.poppins(color: Colors.white70, fontSize:12, fontWeight: FontWeight.w600)), Text('%$_toplamPuan', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize:13))]), const SizedBox(height:6), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Süre', style: GoogleFonts.poppins(color: Colors.white70, fontSize:12, fontWeight: FontWeight.w600)), Text('$seciliSure Ay', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize:13))]), const SizedBox(height:12), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TEKLİF BEDELİ', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:12, color: Colors.black)), Text('$_hesaplananFiyat TL', style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize:16, color: Colors.black))]))])),
        const SizedBox(height:16),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: const Icon(Icons.picture_as_pdf, color: Colors.white), label: Text('Antetli PDF Oluştur', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () async { if(_firmaCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _toplamPuan==0){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Firma, e-posta ve en az 1 alt alan seçin'))); return; } final pdfService = TeklifPdfService(); await pdfService.olusturVeKaydet(firma: _firmaCtrl.text, yetkili: _yetkiliCtrl.text, email: _emailCtrl.text, kategori: seciliKategori!.ad, altAlanlar: seciliAltlar.entries.where((e)=> e.value).map((e)=> e.key).toList(), puan: _toplamPuan, sureAy: seciliSure, tamFiyat: _tamFiyat, teklifFiyat: _hesaplananFiyat, tierLabel: _tierPricing.label); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF oluşturuldu'))); })),
        const SizedBox(height:8),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: const Icon(Icons.email, color: Colors.white), label: Text('Tek Tuşla Mail At', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () async { if(_firmaCtrl.text.isEmpty || _emailCtrl.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Firma ve e-posta girin'))); return; } try{ final callable = FirebaseFunctions.instanceFor(region: 'europe-west3').httpsCallable('sendTeklifMail'); await callable.call({'firma': _firmaCtrl.text, 'yetkili': _yetkiliCtrl.text, 'email': _emailCtrl.text, 'kategori': seciliKategori!.ad, 'altAlanlar': seciliAltlar.entries.where((e)=> e.value).map((e)=> e.key).toList(), 'puan': _toplamPuan, 'sureAy': seciliSure, 'tier': _tierPricing.label}); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mail gönderildi: info@hemenustamgelsin.com'))); }catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mail hatası: $e'))); } })),
      ]))),
    ]);
  }

  Widget _buildTekliflerTab(){
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('hug_teklifler').orderBy('olusturmaTarihi', descending: true).limit(100).snapshots(), builder: (context, snap){ if(!snap.hasData) return const Center(child: CircularProgressIndicator()); final docs = snap.data!.docs; return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Eski Teklifler • ${docs.length} adet', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 12), if(docs.isEmpty) Text('Henüz teklif yok', style: GoogleFonts.poppins()), ...docs.map((d){ final data = d.data() as Map<String,dynamic>; return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFDDDDDD))), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['firma']??'', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)), Text('${data['kategori']} • ${data['teklifFiyat']} TL • %${data['puan']} • ${data['sureAy']} Ay', style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54))])), Text(data['email']??'', style: GoogleFonts.poppins(fontSize: 10, color: Colors.black45))])); })])); });
  }

  Widget _buildRaporlarTab(){
    return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Raporlar', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 12), Row(children: [_statBox('Toplam Ciro', '2.4M TL', const Color(0xFF22C55E)), const SizedBox(width: 12), _statBox('Ortalama', '185K TL', const Color(0xFF3B82F6))])]));
  }

  // FIXED - EDITABLE AYARLAR - V12
  Widget _buildAyarlarTabEditable(){
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Ayarlar • Fiyat Değiştir • info@hemenustamgelsin.com', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black)),
        const SizedBox(height: 4),
        Text('Aşağıdaki kutulara yeni fiyatı yazıp ENTER bas - anında Firestore hug_fiyat_tier güncellenir, motor yeni fiyatla çalışır', style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEEEEEE))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Tier Fiyatları (Kod yok, direkt değiştir)', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black)),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(stream: hugService.fiyatlarStream(), builder: (c, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              return Column(children: snap.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF8F8F7), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: Color(data['color'] ?? 0xFF000000), shape: BoxShape.circle)), const SizedBox(width: 6), Text(data['label'] ?? data['tier'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 12, color: Colors.black))]),
                  const SizedBox(height: 10),
                  Row(children: [_fiyatFieldEditable(doc.id, 'p3', '3 Ay', data['p3']), const SizedBox(width: 8), _fiyatFieldEditable(doc.id, 'p6', '6 Ay', data['p6']), const SizedBox(width: 8), _fiyatFieldEditable(doc.id, 'p12', '12 Ay', data['p12'])]),
                ]));
              }).toList());
            }),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => hugService.fiyatlariIlkKur(), style: ElevatedButton.styleFrom(backgroundColor: Colors.black), child: Text('Varsayılan Fiyatları Yükle', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11))),
          ]))),
          const SizedBox(width: 16),
          Expanded(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEEEEEE))), child: StreamBuilder<DocumentSnapshot>(stream: hugService.ayarlarStream(), builder: (c, snap) {
            final data = snap.data?.data() as Map<String, dynamic>?;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Şirket Bilgileri', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black)),
              const SizedBox(height: 12),
              _ayarFieldEditable('adres', 'Adres', data?['adres'] ?? 'Sağlık Mh. Kurudere Cad. No:76/9 Salihli-MANİSA'),
              _ayarFieldEditable('telefon', 'Telefon', data?['telefon'] ?? '0532 163 59 66'),
              _ayarFieldEditable('email', 'E-posta', data?['email'] ?? 'info@hemenustamgelsin.com'),
              _ayarFieldEditable('iban', 'IBAN', data?['iban'] ?? 'TR79 0086 4011 0000 8503 0670 04'),
              _ayarFieldEditable('duns', 'D-U-N-S', data?['duns'] ?? '751176741'),
              _ayarFieldEditable('vergiNo', 'Vergi No', data?['vergiNo'] ?? ''),
            ]);
          }))),
        ]),
      ]),
    );
  }

  Widget _fiyatFieldEditable(String docId, String field, String label, dynamic value) {
    final ctrl = TextEditingController(text: value?.toString() ?? '');
    return Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black54)),
      const SizedBox(height: 4),
      TextField(controller: ctrl, keyboardType: TextInputType.number, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700), decoration: InputDecoration(isDense: true, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)), contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10)), onSubmitted: (v) { final intVal = int.tryParse(v) ?? 0; hugService.fiyatGuncelle(docId, {field: intVal}); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label güncellendi: $intVal TL • Firestore hug_fiyat_tier'))); }),
    ]));
  }

  Widget _ayarFieldEditable(String key, String label, String value) {
    final ctrl = TextEditingController(text: value);
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
      SizedBox(width: 80, child: Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black))),
      Expanded(child: TextField(controller: ctrl, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black), decoration: InputDecoration(isDense: true, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black45)), contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8)), onSubmitted: (v) { hugService.ayarGuncelle({key: v}); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label güncellendi • Firestore hug_ayarlar'))); })),
    ]));
  }

  Widget _sureChip(String label, int ay){
    final sel = seciliSure==ay;
    return ChoiceChip(label: Text(label, style: GoogleFonts.poppins(fontSize:13, fontWeight: sel? FontWeight.w800: FontWeight.w600, color: sel? Colors.white: Colors.black)), selected: sel, selectedColor: Colors.black, backgroundColor: Colors.white, side: const BorderSide(color: Colors.black, width:1.2), onSelected: (v){ setState(()=> seciliSure=ay); });
  }
}