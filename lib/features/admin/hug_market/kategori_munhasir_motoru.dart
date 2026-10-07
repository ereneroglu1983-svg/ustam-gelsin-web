// lib/features/admin/hug_market/kategori_munhasir_motoru.dart - V13 MULTI-SELECT - BIRDEN FAZLA KATEGORI
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
  // V13 MULTI - Artık liste!
  Set<String> seciliKategoriKeys = {'boya-dekorasyon'};
  Map<String, Map<String,bool>> seciliAltlarMap = {}; // kategoriKey -> altAlan -> secili mi
  int seciliSure = 3;
  bool _firestoreYukleniyor = false;

  @override
  void initState() {
    super.initState();
    tumKategoriler = _buildKategoriler();
    _initAltlar();
    _firestoreVerileriniDene();
  }

  @override
  void dispose(){
    _firmaCtrl.dispose();
    _yetkiliCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _initAltlar(){
    for(var k in tumKategoriler){
      seciliAltlarMap[k.key] = { for (var e in k.altAlanlar.keys) e: true };
    }
  }

  void _toggleKategori(String key){
    setState(() {
      if(seciliKategoriKeys.contains(key)){
        if(seciliKategoriKeys.length > 1){ // En az 1 kategori kalsın
          seciliKategoriKeys.remove(key);
        }
      } else {
        seciliKategoriKeys.add(key);
      }
    });
  }

  List<KategoriModel> get seciliKategoriler => tumKategoriler.where((k)=> seciliKategoriKeys.contains(k.key)).toList();

  TierPricing _tierFor(KategoriModel kat) => tierList.firstWhere((t)=> t.tier==kat.tier);

  int _toplamPuanFor(KategoriModel kat){
    final altMap = seciliAltlarMap[kat.key] ?? {};
    return altMap.entries.where((e)=> e.value).fold(0,(sum,e)=> sum + (kat.altAlanlar[e.key]??0));
  }

  int get _toplamPuanTumu => seciliKategoriler.fold(0,(sum, kat)=> sum + _toplamPuanFor(kat));

  int _tamFiyatFor(KategoriModel kat){
    final tp = _tierFor(kat);
    if(seciliSure==3) return tp.p3;
    if(seciliSure==6) return tp.p6;
    return tp.p12;
  }

  int _hesapFiyatFor(KategoriModel kat){
    return ((_tamFiyatFor(kat) * _toplamPuanFor(kat)) / 100).round();
  }

  int get _hesaplananFiyatTumu => seciliKategoriler.fold(0,(sum, kat)=> sum + _hesapFiyatFor(kat));

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

  bool get _isMobile => MediaQuery.of(context).size.width < 900;

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
              Text('HUG MARKET', style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: _isMobile ? 13 : 15, color: Colors.white)),
              if(!_isMobile) ...[
                const SizedBox(width: 16),
                _sekmeBtn('Genel', 0),
                _sekmeBtn('Kategoriler', 1),
                _sekmeBtn('Teklifler', 2),
                _sekmeBtn('Raporlar', 3),
                _sekmeBtn('Ayarlar', 4),
              ],
            ],
          ),
          actions: [
            if(_firestoreYukleniyor) const Padding(padding: EdgeInsets.only(right:12), child: Center(child: SizedBox(width:16,height:16,child: CircularProgressIndicator(strokeWidth:2, color: Colors.white)))),
            if(!_isMobile) Container(margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Center(child: Text('${tumKategoriler.length} Kategori • ${seciliKategoriKeys.length} Seçili • 81 İl', style: GoogleFonts.poppins(color: Colors.black, fontSize:11, fontWeight: FontWeight.w800)))),
          ],
        ),
        body: IndexedStack(index: _sekme, children: [_buildGenelTab(), _buildMotorTab(), _buildTekliflerTab(), _buildRaporlarTab(), _buildAyarlarTab()]),
        bottomNavigationBar: _isMobile ? BottomNavigationBar(
          currentIndex: _sekme,
          onTap: (i)=> setState(()=> _sekme=i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF111111),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: GoogleFonts.poppins(fontSize:10, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize:10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Genel'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
            BottomNavigationBarItem(icon: Icon(Icons.request_quote), label: 'Teklifler'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Raporlar'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
          ],
        ) : null,
      ),
    );
  }

  Widget _sekmeBtn(String label, int idx){
    final sel = _sekme==idx;
    return Padding(padding: const EdgeInsets.only(right: 6), child: InkWell(onTap: ()=> setState(()=> _sekme=idx), borderRadius: BorderRadius.circular(8), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: sel? Colors.white : const Color(0xFF222222), borderRadius: BorderRadius.circular(8), border: Border.all(color: sel? Colors.white : const Color(0xFF333333))), child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: sel? FontWeight.w800: FontWeight.w600, color: sel? Colors.black: Colors.white70)))));
  }

  Widget _buildGenelTab(){
    return SingleChildScrollView(padding: const EdgeInsets.fromLTRB(12,12,12,100), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Genel Dashboard - Çoklu Seçim Aktif', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18)),
      const SizedBox(height: 4),
      Text('${seciliKategoriKeys.length} kategori seçili • Toplam ${_hesaplananFiyatTumu} TL', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 16),
      Row(children: [_statBox('Seçili Kategori', '${seciliKategoriKeys.length}', const Color(0xFF3B82F6)), const SizedBox(width: 12), _statBox('Toplam Teklif', '${_hesaplananFiyatTumu~/1000}K TL', const Color(0xFF22C55E)), const SizedBox(width: 12), _statBox('Toplam Puan', '$_toplamPuanTumu', const Color(0xFFF59E0B)), const SizedBox(width: 12), _statBox('Süre', '$seciliSure Ay', const Color(0xFF8B5CF6))]),
    ]));
  }

  Widget _statBox(String title, String val, Color c){
    return Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFDDDDDD))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: c.withValues(alpha:0.15), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.dashboard, color: c, size: 18)), const SizedBox(height: 8), Text(val, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis), Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54)) ])));
  }

  Widget _buildMotorTab(){
    if(_isMobile){
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12,12,12,100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildKategoriListesiMulti(),
            const SizedBox(height: 16),
            // Seçili kategorilerin detayları
            ...seciliKategoriler.map((kat) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildKategoriDetayCard(kat),
            )),
            _buildTeklifOzetiMulti(),
          ],
        ),
      );
    }
    // DESKTOP - 3 kolon ama çoklu
    return Row(children: [
      Container(width: 320, color: Colors.white, child: Column(children: [
        Container(width: double.infinity, color: const Color(0xFF111111), padding: const EdgeInsets.all(12), child: Row(children: [Text('KATEGORİ SEÇ • ÇOKLU', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w800, letterSpacing:1, color: Colors.white)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:3), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Text('${seciliKategoriKeys.length} seçili', style: GoogleFonts.poppins(fontSize:10, fontWeight: FontWeight.w800, color: Colors.black)))])),
        Expanded(child: ListView(padding: const EdgeInsets.only(top:8, bottom:80), children: tierList.map((tier){
          final cats = tumKategoriler.where((c)=> c.tier==tier.tier).toList();
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: const EdgeInsets.symmetric(horizontal:12,vertical:6), padding: const EdgeInsets.symmetric(horizontal:10,vertical:6), decoration: BoxDecoration(color: tier.color.withValues(alpha:0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: tier.color.withValues(alpha:0.3))), child: Row(children: [Container(width:8,height:8,decoration: BoxDecoration(color: tier.color, shape: BoxShape.circle)), const SizedBox(width:6), Text(tier.label, style: GoogleFonts.poppins(fontSize:11,fontWeight: FontWeight.w800, color: Colors.black)), const Spacer(), Text('${tier.p3~/1000}K / ${tier.p6~/1000}K / ${tier.p12~/1000}K', style: GoogleFonts.poppins(fontSize:9, fontWeight: FontWeight.w800, color: Colors.black87))])),
            ...cats.map((cat){ final isSel = seciliKategoriKeys.contains(cat.key); return InkWell(onTap: ()=> _toggleKategori(cat.key), child: Container(margin: const EdgeInsets.symmetric(horizontal:12,vertical:3), padding: const EdgeInsets.symmetric(horizontal:12,vertical:12), decoration: BoxDecoration(color: isSel? Colors.black : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSel? Colors.black : const Color(0xFFDDDDDD), width: 1.2)), child: Row(children: [Expanded(child: Text(cat.ad, style: GoogleFonts.poppins(fontSize:13, fontWeight: FontWeight.w700, color: isSel? Colors.white : Colors.black))), if(isSel) const Icon(Icons.check_circle, size:18, color: Colors.white) else const Icon(Icons.circle_outlined, size:18, color: Colors.black26)]))); }),
            const SizedBox(height:8),
          ]);
        }).toList())),
      ])),
      Expanded(flex: 2, child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: seciliKategoriler.map((kat)=> Padding(padding: const EdgeInsets.only(bottom:16), child: _buildKategoriDetayCard(kat))).toList()))),
      Container(width: 360, color: Colors.white, child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: _buildTeklifOzetiMulti())),
    ]);
  }

  Widget _buildKategoriListesiMulti(){
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFDDDDDD))),
      child: Column(children: [
        Container(width: double.infinity, decoration: const BoxDecoration(color: Color(0xFF111111), borderRadius: BorderRadius.vertical(top: Radius.circular(12))), padding: const EdgeInsets.all(12), child: Row(children: [Text('KATEGORİ SEÇ • ÇOKLU', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w800, letterSpacing:1, color: Colors.white)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:3), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Text('${seciliKategoriKeys.length} seçili • ${tumKategoriler.length} toplam', style: GoogleFonts.poppins(fontSize:9, fontWeight: FontWeight.w800, color: Colors.black))) ])),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: tierList.map((tier){
              final cats = tumKategoriler.where((c)=> c.tier==tier.tier).toList();
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(margin: const EdgeInsets.symmetric(vertical:6), padding: const EdgeInsets.symmetric(horizontal:10,vertical:6), decoration: BoxDecoration(color: tier.color.withValues(alpha:0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: tier.color.withValues(alpha:0.3))), child: Row(children: [Container(width:8,height:8,decoration: BoxDecoration(color: tier.color, shape: BoxShape.circle)), const SizedBox(width:6), Text(tier.label, style: GoogleFonts.poppins(fontSize:11,fontWeight: FontWeight.w800, color: Colors.black)), const Spacer(), Text('${tier.p3~/1000}K / ${tier.p6~/1000}K / ${tier.p12~/1000}K', style: GoogleFonts.poppins(fontSize:9, fontWeight: FontWeight.w800, color: Colors.black87))])),
                ...cats.map((cat){ final isSel = seciliKategoriKeys.contains(cat.key); return InkWell(onTap: ()=> _toggleKategori(cat.key), child: Container(margin: const EdgeInsets.only(bottom:6), padding: const EdgeInsets.symmetric(horizontal:12,vertical:12), decoration: BoxDecoration(color: isSel? Colors.black : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSel? Colors.black : const Color(0xFFDDDDDD), width: 1.2)), child: Row(children: [Expanded(child: Text(cat.ad, style: GoogleFonts.poppins(fontSize:13, fontWeight: FontWeight.w700, color: isSel? Colors.white : Colors.black))), if(isSel) const Icon(Icons.check_circle, size:18, color: Colors.white) else const Icon(Icons.circle_outlined, size:18, color: Colors.black26)]))); }),
              ]);
            }).toList(),
          ),
        ),
      ]),
    );
  }

  Widget _buildKategoriDetayCard(KategoriModel kat){
    final tp = _tierFor(kat);
    final puan = _toplamPuanFor(kat);
    final fiyat = _hesapFiyatFor(kat);
    final altMap = seciliAltlarMap[kat.key] ?? {};
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFDDDDDD), width:1.2)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Container(width: 40, height:40, decoration: BoxDecoration(color: tp.color, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.category, color: Colors.white, size: 20)), const SizedBox(width:10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(kat.ad, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:14, color: Colors.black)), Text('${tp.label} • ${tp.p3~/1000}K / ${tp.p6~/1000}K / ${tp.p12~/1000}K', style: GoogleFonts.poppins(fontSize:10, color: Colors.black54, fontWeight: FontWeight.w600))])), Container(padding: const EdgeInsets.symmetric(horizontal:10,vertical:5), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)), child: Text('$puan / 100', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize:11))), const SizedBox(width:6), Container(padding: const EdgeInsets.symmetric(horizontal:10,vertical:5), decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(20)), child: Text('$fiyat TL', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize:11))) ]),
      const SizedBox(height:12),
      ...kat.altAlanlar.entries.map((e){ final sel = altMap[e.key]??false; return Container(margin: const EdgeInsets.only(bottom:6), padding: const EdgeInsets.symmetric(horizontal:10,vertical:8), decoration: BoxDecoration(color: sel? Colors.white : const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(10), border: Border.all(color: sel? Colors.black : const Color(0xFFCCCCCC), width: sel?1.5:1)), child: Row(children: [Checkbox(value: sel, onChanged: (v){ setState(()=> seciliAltlarMap[kat.key]![e.key]=v!); }, visualDensity: VisualDensity.compact, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, activeColor: Colors.black, checkColor: Colors.white, side: const BorderSide(color: Colors.black, width:1.2)), Expanded(child: Text(e.key, style: GoogleFonts.poppins(fontSize:12, fontWeight: sel? FontWeight.w700: FontWeight.w500, color: Colors.black))), Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:3), decoration: BoxDecoration(color: sel? Colors.black : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black)), child: Text('${e.value} P', style: GoogleFonts.poppins(fontSize:11, color: sel? Colors.white: Colors.black, fontWeight: FontWeight.w800)))])); }),
    ]));
  }

  Widget _buildTeklifOzetiMulti(){
    final seciliAltFlat = <String>[];
    for(var kat in seciliKategoriler){
      final altMap = seciliAltlarMap[kat.key] ?? {};
      for(var entry in altMap.entries.where((e)=> e.value)){
        seciliAltFlat.add('${kat.ad}: ${entry.key}');
      }
    }
    return Container(
      padding: EdgeInsets.all(_isMobile ? 0 : 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFDDDDDD))),
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(color: Colors.black, padding: const EdgeInsets.symmetric(horizontal:10,vertical:6), child: Text('TEKLİF ÖZETİ • ${seciliKategoriKeys.length} KATEGORİ', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w800, letterSpacing:1, color: Colors.white))),
            const SizedBox(height:14),
            TextField(controller: _firmaCtrl, style: GoogleFonts.poppins(fontSize:14, color: Colors.black, fontWeight: FontWeight.w600), decoration: InputDecoration(labelText:'Firma Ünvanı *', labelStyle: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w700), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.5)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.2)))),
            const SizedBox(height:10),
            TextField(controller: _yetkiliCtrl, style: GoogleFonts.poppins(fontSize:14, color: Colors.black, fontWeight: FontWeight.w600), decoration: InputDecoration(labelText:'Yetkili Kişi', labelStyle: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w700), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.5)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.2)))),
            const SizedBox(height:10),
            TextField(controller: _emailCtrl, style: GoogleFonts.poppins(fontSize:14, color: Colors.black, fontWeight: FontWeight.w600), decoration: InputDecoration(labelText:'E-posta *', labelStyle: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w700), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.5)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width:1.2)))),
            const SizedBox(height:16),
            Row(children: [_sureChip('3 Ay', 3), const SizedBox(width:8), _sureChip('6 Ay', 6), const SizedBox(width:8), _sureChip('12 Ay', 12)]),
            const SizedBox(height:16),
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('CANLI TEKLİF - ÇOKLU', style: GoogleFonts.poppins(color: Colors.white70, fontSize:10, fontWeight: FontWeight.w800, letterSpacing:1)),
              const SizedBox(height:8),
              ...seciliKategoriler.map((kat)=> Padding(
                padding: const EdgeInsets.only(bottom:6),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Text(kat.ad, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize:12))),
                  Text('${_toplamPuanFor(kat)} P • ${_hesapFiyatFor(kat)} TL', style: GoogleFonts.poppins(color: Colors.white70, fontSize:11, fontWeight: FontWeight.w700)),
                ]),
              )),
              const Divider(color: Colors.white24, height:20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Toplam Puan', style: GoogleFonts.poppins(color: Colors.white70, fontSize:12)), Text('$_toplamPuanTumu', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize:13))]),
              const SizedBox(height:4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Süre', style: GoogleFonts.poppins(color: Colors.white70, fontSize:12)), Text('$seciliSure Ay', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize:13))]),
              const SizedBox(height:12),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOPLAM BEDEL', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize:12, color: Colors.black)), Text('$_hesaplananFiyatTumu TL', style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize:18, color: Colors.black))]))])),
            const SizedBox(height:16),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: const Icon(Icons.picture_as_pdf, color: Colors.white), label: Text('Antetli PDF Oluştur (${seciliKategoriKeys.length} kategori)', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.white, fontSize:12)), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () async {
              if(_firmaCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _toplamPuanTumu==0){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Firma, e-posta ve en az 1 alt alan seçin'))); return; }
              final pdfService = TeklifPdfService();
              await pdfService.olusturVeKaydetMulti(firma: _firmaCtrl.text, yetkili: _yetkiliCtrl.text, email: _emailCtrl.text, kategoriler: seciliKategoriler.map((k)=> k.ad).toList(), altAlanlar: seciliAltFlat, puan: _toplamPuanTumu, sureAy: seciliSure, teklifFiyat: _hesaplananFiyatTumu);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF oluşturuldu • ${seciliKategoriKeys.length} kategori • $_hesaplananFiyatTumu TL')));
            })),
            const SizedBox(height:8),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: const Icon(Icons.email, color: Colors.white), label: Text('Tek Tuşla Mail At', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () async {
              if(_firmaCtrl.text.isEmpty || _emailCtrl.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Firma ve e-posta girin'))); return; }
              try{
                final callable = FirebaseFunctions.instanceFor(region: 'europe-west3').httpsCallable('sendTeklifMail');
                await callable.call({
                  'firma': _firmaCtrl.text,
                  'yetkili': _yetkiliCtrl.text,
                  'email': _emailCtrl.text,
                  'kategoriler': seciliKategoriler.map((k)=> k.ad).toList(),
                  'altAlanlar': seciliAltFlat,
                  'puan': _toplamPuanTumu,
                  'sureAy': seciliSure,
                  'teklifFiyat': _hesaplananFiyatTumu,
                  'kategoriSayisi': seciliKategoriKeys.length,
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mail gönderildi')));
              }catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mail hatası: $e'))); }
            })),
          ]),
        ),
      ]),
    );
  }

  Widget _buildTekliflerTab(){
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('hug_teklifler').orderBy('olusturmaTarihi', descending: true).limit(100).snapshots(), builder: (context, snap){ if(!snap.hasData) return const Center(child: CircularProgressIndicator()); final docs = snap.data!.docs; return SingleChildScrollView(padding: const EdgeInsets.fromLTRB(12,12,12,100), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Eski Teklifler • ${docs.length} adet', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 12), if(docs.isEmpty) Text('Henüz teklif yok', style: GoogleFonts.poppins()), ...docs.map((d){ final data = d.data() as Map<String,dynamic>; return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFDDDDDD))), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['firma']??'', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)), Text('${data['kategori'] ?? (data['kategoriler'] as List?)?.join(', ') ?? ''} • ${data['teklifFiyat'] ?? data['teklifFiyati'] ?? ''} TL', style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54))])), Text(data['email']??'', style: GoogleFonts.poppins(fontSize: 10, color: Colors.black45))])); })])); });
  }

  Widget _buildRaporlarTab(){
    return SingleChildScrollView(padding: const EdgeInsets.fromLTRB(12,12,12,100), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Raporlar', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 12), Text('Toplam ${seciliKategoriKeys.length} kategori seçili • $_hesaplananFiyatTumu TL', style: GoogleFonts.poppins(fontSize: 12)), const SizedBox(height: 12), Row(children: [_statBox('Toplam Ciro', '2.4M TL', const Color(0xFF22C55E)), const SizedBox(width: 12), _statBox('Ortalama', '185K TL', const Color(0xFF3B82F6))])]));
  }

  Widget _buildAyarlarTab(){
    return SingleChildScrollView(padding: EdgeInsets.fromLTRB(16,16,16,100 + MediaQuery.of(context).viewPadding.bottom), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Ayarlar', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800)),
      const SizedBox(height: 20),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEEEEEE))), child: StreamBuilder<QuerySnapshot>(stream: hugService.fiyatlarStream(), builder: (c, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        return Column(children: snap.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF8F8F7), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: Color(data['color'] ?? 0xFF000000), shape: BoxShape.circle)), const SizedBox(width: 6), Text(data['label'] ?? data['tier'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 12, color: Colors.black))]),
            const SizedBox(height: 10),
            Row(children: [_fiyatFieldEditable(doc.id, 'p3', '3 Ay', data['p3']), const SizedBox(width: 8), _fiyatFieldEditable(doc.id, 'p6', '6 Ay', data['p6']), const SizedBox(width: 8), _fiyatFieldEditable(doc.id, 'p12', '12 Ay', data['p12'])]),
          ]));
        }).toList());
      })),
    ]));
  }

  Widget _fiyatFieldEditable(String docId, String field, String label, dynamic value) {
    final ctrl = TextEditingController(text: value?.toString() ?? '');
    return Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black54)),
      const SizedBox(height: 4),
      TextField(controller: ctrl, keyboardType: TextInputType.number, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700), decoration: InputDecoration(isDense: true, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 1.2)), contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10)), onSubmitted: (v) { final intVal = int.tryParse(v) ?? 0; hugService.fiyatGuncelle(docId, {field: intVal}); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label güncellendi: $intVal TL'))); }),
    ]));
  }

  Widget _sureChip(String label, int ay){
    final sel = seciliSure==ay;
    return ChoiceChip(label: Text(label, style: GoogleFonts.poppins(fontSize:13, fontWeight: sel? FontWeight.w800: FontWeight.w600, color: sel? Colors.white: Colors.black)), selected: sel, selectedColor: Colors.black, backgroundColor: Colors.white, side: const BorderSide(color: Colors.black, width:1.2), onSelected: (v){ setState(()=> seciliSure=ay); });
  }
}
