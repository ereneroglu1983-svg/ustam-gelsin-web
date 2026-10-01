import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class CozumOrtagiPage extends StatefulWidget {
  const CozumOrtagiPage({super.key});
  @override
  State<CozumOrtagiPage> createState() => _CozumOrtagiPageState();
}

class _CozumOrtagiPageState extends State<CozumOrtagiPage> {
  final _formKey = GlobalKey<FormState>();
  final _formSectionKey = GlobalKey();
  final _journeySectionKey = GlobalKey();
  final _scrollController = ScrollController();

  final _firmaCtrl = TextEditingController();
  final _yetkiliCtrl = TextEditingController();
  final _pozisyonCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _webCtrl = TextEditingController();
  final _mesajCtrl = TextEditingController();

  final Set<String> _seciliIsBirligi = {};
  bool _isSubmitting = false;
  bool _isSuccess = false;

  final Map<String, List<String>> _urunOntoloji = {
    'Banyo & Mutfak': [
      'Seramik Sağlık Gereçleri & Vitrifiye Sistemleri',
      'Banyo Mobilyaları & Dolap Sistemleri',
      'Armatür & Batarya Sistemleri',
      'Duş Sistemleri',
      'Küvet, Jakuzi & Hidromasaj Sistemleri',
      'Gömme Rezervuar & Kumanda Paneli Sistemleri',
      'Mutfak Eviye Sistemleri',
      'Mutfak Fonksiyonel Sistemler',
      'Banyo Aksesuar & Tamamlayıcı Sistemleri'
    ],
    'Temizlik & Hijyen': [
      'Profesyonel Yüzey & Zemin Temizlik Kimyasalları',
      'Endüstriyel & Teknik Temizlik Sistemleri',
      'Profesyonel Mutfak Hijyeni & Gıda Güvenliği Sistemleri',
      'Çamaşırhane & Tekstil Hijyen Sistemleri',
      'Dezenfeksiyon & Sterilizasyon Sistemleri',
      'Temizlik Makine & Ekipman Sistemleri',
      'Profesyonel Kağıt, Sarf & Tek Kullanımlık Sistemler',
      'Hijyen Dispenser & Koku Sistemleri'
    ],
    'Elektrik & Aydınlatma': [
      'Alçak Gerilim Kablo & Kablo Taşıma Sistemleri',
      'Elektrik Dağıtım, Koruma & Pano Sistemleri',
      'Anahtar, Priz & Mekanizma Sistemleri',
      'Busbar, Topraklama & Yıldırımdan Korunma Sistemleri',
      'Aydınlatma Armatür Sistemleri',
      'LED, Aydınlatma Kontrol & Driver Sistemleri',
      'Otomasyon, Akıllı Bina & KNX Sistemleri',
      'Enerji Yönetim, Kompanzasyon & Kesintisiz Güç Sistemleri'
    ],
    'Hırdavat, El Aletleri & İş Güvenliği': [
      'Profesyonel El Aletleri & Takım Setleri',
      'Elektrikli & Akülü El Aletleri & Makine Sistemleri',
      'Kesici Takım, Delici Uç & Aşındırıcı Sarf Sistemleri',
      'Ölçüm, Lazer, Nivo & Test Cihazları',
      'Kompresör, Pnömatik Alet & Hava Sistemleri',
      'Bağlantı, Sabitleme & Ankraj Elemanları',
      'Yapıştırıcı, Sızdırmazlık & Teknik Kimyasallar',
      'Kişisel Koruyucu Donanım & İş Güvenliği Sistemleri',
      'Takım Depolama, Taşıma & Atölye Sistemleri'
    ],
    'Bahçe, Peyzaj & Dış Mekân': [
      'Profesyonel Bahçe Makine & Motor Sistemleri',
      'Otomatik Sulama & Damlama Sistemleri',
      'Peyzaj Zemin & Yeşil Alan Sistemleri',
      'Dış Mekân Zemin Kaplama & Duvar Sistemleri',
      'Pergola, Gölgeleme & Dış Mekân Yapı Sistemleri',
      'Dış Mekân Mobilya & Aksesuar Sistemleri',
      'Bahçe El Aletleri & Bakım Ekipmanları',
      'Dış Mekân Aydınlatma & Elektrik Sistemleri',
      'Ahşap, Kompozit & WPC Dış Mekân Sistemleri'
    ],
    'Tesisat & Su Sistemleri': [
      'Temiz Su Tesisat & Boru Sistemleri',
      'Atık Su, Drenaj & Yağmur Suyu Sistemleri',
      'Fittings, Pres & Bağlantı Sistemleri',
      'Vana, Kontrol & Armatür Sistemleri',
      'Pompa, Hidrofor & Basınçlandırma Sistemleri',
      'Su Depolama, Arıtma & Filtrasyon Sistemleri',
      'Yangın Tesisat & Sprinkler Sistemleri',
      'Altyapı, Kanalizasyon & Yağ Ayırıcı Sistemleri'
    ],
    'Yapı Malzemeleri & İnşaat': [
      'Çimento & Bağlayıcı Sistemleri',
      'Hazır Beton & Beton Katkı Sistemleri',
      'Gazbeton, Tuğla & Duvar Blok Sistemleri',
      'Alçı, Alçıpan & Bölme Duvar Sistemleri',
      'Kuru Harç, Şap & Sıva Sistemleri',
      'Yapıştırıcı, Derz & Yüzey Hazırlık Sistemleri',
      'Donatı, Çelik Hasır & Kalıp Sistemleri',
      'Yapısal Güçlendirme, Tamir & İnşaat Kimyasalları'
    ],
    'Boya & Dekorasyon': [
      'İç Cephe Boya Sistemleri',
      'Dış Cephe Boya & Cephe Kaplama Sistemleri',
      'Ahşap Boya, Vernik & Ahşap Koruyucu Sistemleri',
      'Metal Boya, Antipas & Korozyon Koruma Sistemleri',
      'Endüstriyel, Epoksi & Zemin Kaplama Sistemleri',
      'Koruyucu Kaplama & Yangın Geciktirici Sistemler',
      'Astar, Macun, Alçı & Yüzey Hazırlık Sistemleri',
      'Dekoratif, Efekt & İtalyan Boya Sistemleri'
    ],
    'Çatı & Cephe Sistemleri': [
      'Çatı Kaplama Sistemleri',
      'Endüstriyel & Sandviç Panel Çatı Sistemleri',
      'Çatı Yalıtım, Buhar Kesici & Su Yalıtım Sistemleri',
      'Cephe Kaplama Sistemleri',
      'Cephe Mantolama & ETICS Isı Yalıtım Sistemleri',
      'Cephe Alt Konstrüksiyon, Taşıyıcı & Ankraj Sistemleri',
      'Yağmur Suyu Tahliye, Oluk & İniş Sistemleri',
      'Çatı Aksesuar, Işıklık & Güvenlik Sistemleri'
    ],
    'Havuz & Spa Sistemleri': [
      'Havuz Yapı, Betonarme & Kaplama Sistemleri',
      'Filtrasyon, Sirkülasyon, Pompa & Vana Sistemleri',
      'Dezenfeksiyon, Dozajlama & Tuz Klor Jeneratör Sistemleri',
      'Havuz Isıtma & Isı Pompası Sistemleri',
      'Havuz Aydınlatma, Robot & Temizlik Sistemleri',
      'Havuz Otomasyon & Akıllı Kontrol Sistemleri',
      'Havuz Örtü, Lamel Cover & Güvenlik Sistemleri',
      'Havuz Kimyasalları & Su Bakım Sistemleri',
      'Spa, Jakuzi, Sauna & Wellness Sistemleri'
    ],
    'Isıtma, Soğutma & İklimlendirme': [
      'Kombi, Yoğuşmalı Kazan & Merkezi Isıtma Sistemleri',
      'Radyatör, Yerden Isıtma & Isı Dağıtım Sistemleri',
      'Isı Pompası & Hibrit Isıtma Sistemleri',
      'Split, Multi Split & Bireysel Klima Sistemleri',
      'VRF, Chiller, Fan Coil & Ticari İklimlendirme Sistemleri',
      'Havalandırma, HRV & Hava Temizleme Sistemleri',
      'Radyant, İnfrared & Endüstriyel Isıtma Sistemleri',
      'İklimlendirme Otomasyonu & Kontrol Sistemleri'
    ],
    'Seramik, Fayans & Zemin': [
      'Seramik & Porselen Karo Sistemleri',
      'Büyük Ebat & Teknik Porselen Sistemleri',
      'Doğal Taş, Mermer & Mozaik Sistemleri',
      'Parke, Laminat & Ahşap Zemin Sistemleri',
      'LVT, PVC, Vinil & Kauçuk Zemin Sistemleri',
      'Endüstriyel, Epoksi & Yükseltilmiş Döşeme Sistemleri',
      'Zemin Aksesuar, Profil & Uygulama Sistemleri',
      'Dekoratif, 3D & Tasarım Zemin Sistemleri'
    ],
    'Yalıtım & İzolasyon': [
      'Isı Yalıtım & Mantolama Sistemleri',
      'Su Yalıtım & Membran Sistemleri',
      'Çatı, Temel & Bohçalama Yalıtım Sistemleri',
      'Cephe & Giydirme Cephe İzolasyon Sistemleri',
      'Ses Yalıtım & Akustik Düzenleme Sistemleri',
      'Yangın Yalıtım & Pasif Yangın Durdurucu Sistemler',
      'Teknik İzolasyon & Tesisat Yalıtım Sistemleri',
      'Yalıtım Aksesuar, Bant & Tamamlayıcı Sistemleri'
    ],
    'Cam, Alüminyum & Cephe Sistemleri': [
      'Cam & Şişecam Sistemleri',
      'Alüminyum Doğrama & Pencere Sistemleri',
      'Cephe Giydirme & Curtain Wall Sistemleri',
      'Sürme, Hebeschiebe & Katlanır Kapı Sistemleri',
      'Küpeşte, Korkuluk & Balkon Sistemleri',
      'Güneş Kırıcı, Louver & Gölgeleme Sistemleri',
      'Otomatik Kapı, Fotoselli & Geçiş Sistemleri',
      'Alüminyum Kompozit & Kaplama Aksesuar Sistemleri'
    ],
    'Yenilenebilir Enerji & Güç Sistemleri': [
      'GES - Çatı Üstü Güneş Enerji Sistemleri',
      'GES - Arazi Tipi Güneş Enerji Sistemleri',
      'Fotovoltaik Panel Sistemleri',
      'İnvertör Sistemleri',
      'Güneş Montaj & Taşıyıcı Sistemleri',
      'Enerji Depolama Sistemleri',
      'Rüzgar Enerjisi Sistemleri (RES)',
      'On-Grid / Off-Grid / Hibrit Enerji Sistemleri',
      'EV Şarj Sistemleri & Altyapısı',
      'Enerji Yönetim & İzleme Sistemleri'
    ],
    'Kapı, Kilit & Geçiş Kontrol Sistemleri': [
      'Çelik Kapı & Güvenlik Kapı Sistemleri',
      'İç Kapı, Ahşap & Melamin Kapı Sistemleri',
      'Yangın Kapısı, Acil Çıkış & Duman Sızdırmaz Kapı Sistemleri',
      'Endüstriyel, Seksiyonel & Garaj Kapı Sistemleri',
      'Kilit, Barel & Silindir Güvenlik Sistemleri',
      'Kapı Kol, Menteşe & Kapı Donanım Sistemleri',
      'Otomatik Kapı, Fotoselli & Döner Kapı Sistemleri',
      'Kartlı Geçiş, Turnike & Access Control Sistemleri'
    ],
    'Güvenlik, Yangın Algılama & Zayıf Akım Sistemleri': [
      'Yangın Algılama, İhbar & Duman Tahliye Sistemleri',
      'Acil Anons, Seslendirme & Acil Aydınlatma Sistemleri',
      'CCTV, Kamera & Video Gözetim Sistemleri',
      'Hırsız Alarm, Akıllı Ev Güvenlik & İhbar Sistemleri',
      'İnterkom, Diafon & Görüntülü Konuşma Sistemleri',
      'Zayıf Akım, Data, Network & Rack Kabinet Sistemleri',
      'Personel Takip, PDKS & Ziyaretçi Yönetim Sistemleri',
      'Paratoner, Yıldırımdan Korunma & Topraklama Sistemleri'
    ],
    'Asansör, Yürüyen Merdiven & Mekanik Taşıma Sistemleri': [
      'İnsan Asansörü & Konut Asansör Sistemleri',
      'Yük, Sedye, Araç & Monşarj Asansör Sistemleri',
      'Yürüyen Merdiven & Yürüyen Bant Sistemleri',
      'Panoramik, Cam & Özel Tasarım Asansör Sistemleri',
      'Engelli Platform, Merdiven Asansörü & Lift Sistemleri',
      'Asansör Kabin, Kapı, Ray & Aksam Sistemleri',
      'Mekanik Otopark & Araç Park Sistemleri',
      'Asansör Modernizasyon, Bakım & Kurtarma Sistemleri'
    ],
  };

  final Map<String, Set<String>> _seciliUrunAlanlari = {};
  // REVİZE EDİLDİ: Form chipleri artık yukarıdaki 3 kart ile birebir aynı niyete göre
  final List<String> isBirlikleri = ['Kategori Liderliği','Proje & Ürün Entegrasyonu','Marka & Kampanya Görünürlüğü','Diğer'];

  @override
  void initState() {
    super.initState();
    for (var k in _urunOntoloji.keys) { _seciliUrunAlanlari[k] = {}; }
  }

  @override
  void dispose() {
    _firmaCtrl.dispose();_yetkiliCtrl.dispose();_pozisyonCtrl.dispose();_emailCtrl.dispose();_telCtrl.dispose();_webCtrl.dispose();_mesajCtrl.dispose();_scrollController.dispose();
    super.dispose();
  }

  void _scrollToForm() { Scrollable.ensureVisible(_formSectionKey.currentContext!, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic); }
  void _scrollToJourney() { Scrollable.ensureVisible(_journeySectionKey.currentContext!, duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic); }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final toplamSecili = _seciliUrunAlanlari.values.fold<int>(0, (p, e) => p + e.length);
    if (toplamSecili == 0) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen en az bir ürün alanı seçin'))); return; }
    if (_seciliIsBirligi.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen en az bir iş birliği modeli seçin'))); return; }
    setState(() => _isSubmitting = true);
    try {
      final urunAlanlariMap = <String, List<String>>{};
      _seciliUrunAlanlari.forEach((k, v) { if (v.isNotEmpty) urunAlanlariMap[k] = v.toList(); });
      await FirebaseFirestore.instance.collection('corporate_leads').add({
        'firma': _firmaCtrl.text.trim(),'yetkili': _yetkiliCtrl.text.trim(),'pozisyon': _pozisyonCtrl.text.trim(),'email': _emailCtrl.text.trim(),'telefon': _telCtrl.text.trim(),'webSitesi': _webCtrl.text.trim(),
        'urunAlanlari': urunAlanlariMap,
        'kategoriler': urunAlanlariMap.keys.toList(),
        'isBirlikleri': _seciliIsBirligi.toList(),'mesaj': _mesajCtrl.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),'status': 'Yeni','source': 'hug-market-cozum-ortagi-page-v3-kafa-modeli',
      });
      if (!mounted) return;
      setState(() => _isSuccess = true);
      _firmaCtrl.clear();_yetkiliCtrl.clear();_pozisyonCtrl.clear();_emailCtrl.clear();_telCtrl.clear();_webCtrl.clear();_mesajCtrl.clear();
      for (var k in _seciliUrunAlanlari.keys) { _seciliUrunAlanlari[k]!.clear(); }
      _seciliIsBirligi.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Başvurunuz gönderilemedi. Lütfen tekrar deneyin.')));
    } finally { if (mounted) setState(() => _isSubmitting = false); }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;
    final isTablet = w >= 700 && w < 1100;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(children: [
          _buildTopBar(isMobile),
          _buildHero(isMobile, isTablet),
          _buildTrustBar(isMobile),
          _buildNedenHug(isMobile),
          _buildNasilCalisiyor(isMobile),
          _buildPaketler(isMobile),
          _buildSektorler(isMobile),
          _buildForm(isMobile),
          _buildFooter(isMobile),
        ]),
      ),
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Container(
      height: isMobile? 72 : 84,
      padding: EdgeInsets.symmetric(horizontal: isMobile? 16 : 40),
      decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(children: [
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 18)),
        const SizedBox(width: 4),
        Image.asset('assets/web_logo.png', height: isMobile? 36 : 46, fit: BoxFit.contain),
        const SizedBox(width: 12),
        Image.asset('assets/hug_market/hug_logo.png', height: isMobile? 32 : 40, fit: BoxFit.contain),
        const SizedBox(width: 14),
        Container(width: 1, height: 28, color: Colors.grey.shade300),
        const SizedBox(width: 14),
        Expanded(child: Text('Proje Odaklı Yapı Malzemeleri Ekosistemi', overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: isMobile? 12 : 15, fontWeight: FontWeight.w600, color: Colors.black87, letterSpacing: 0.1))),
      ]),
    );
  }

  Widget _buildHero(bool isMobile, bool isTablet) {
    return Container(width: double.infinity, color: const Color(0xFF0F0F0F), padding: EdgeInsets.symmetric(horizontal: isMobile? 20 : 40, vertical: isMobile? 40 : 80), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFDC143C).withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFDC143C).withOpacity(0.3))), child: Text('MARKANIZ İÇİN YENİ DİJİTAL KANAL', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFDC143C), letterSpacing: 1))),
      const SizedBox(height: 20),
      RichText(text: TextSpan(style: GoogleFonts.poppins(fontSize: isMobile? 32 : 54, fontWeight: FontWeight.w800, height: 1.05, color: Colors.white), children: const [TextSpan(text: 'Markanızı\nDoğru '), TextSpan(text: 'Usta ve\n', style: TextStyle(color: Color(0xFFDC143C))), TextSpan(text: 'Doğru Projeyle\nBuluşturun') ])),
      const SizedBox(height: 16),
      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: Text('© HUG MARKET Çözüm Ortaklığı ile markanızı ihtiyaç anında, sahada ürünü kullanan usta ile buluşturuyoruz. Reklam değil, ihtiyacın içinde yer alın.', style: GoogleFonts.poppins(fontSize: isMobile? 14 : 16, color: Colors.white54, height: 1.6))),
      const SizedBox(height: 28),
      Wrap(spacing: 12, runSpacing: 12, children: [
        SizedBox(height: 48, child: ElevatedButton(onPressed: _scrollToForm, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 28)), child: Text('Çözüm Ortağı Ol', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)))),
        SizedBox(height: 48, child: OutlinedButton(onPressed: _scrollToJourney, style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white.withOpacity(0.2)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 28)), child: Text('Markanızın Yolculuğu', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)))),
      ]),
    ]));
  }

  Widget _buildTrustBar(bool isMobile) {
    return Container(padding: EdgeInsets.symmetric(horizontal: isMobile? 20 : 40, vertical: 18), decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))), child: Wrap(spacing: isMobile? 16 : 32, runSpacing: 12, children: [
      _trustItem(Icons.verified_outlined, 'Doğru İhtiyaçta Görünürlük'),_trustItem(Icons.handyman_outlined, 'Usta Odaklı Ekosistem'),_trustItem(Icons.analytics_outlined, 'Ölçülebilir Performans'),_trustItem(Icons.category_outlined, 'Kategori Konumlandırması'),
    ]));
  }
  Widget _trustItem(IconData icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 16, color: Colors.black87)), const SizedBox(width: 8), Text(text, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600))]);

  Widget _buildNedenHug(bool isMobile) {
    final card1 = _InfoCard(icon: Icons.visibility, title: 'İhtiyaç Anında Görünürlük', desc: 'Bir reklam alanında değil, gerçek bir işin içinde görünür olun.\n\nHUG MARKET\'teki yolculuk, ürünle değil ihtiyaçla başlar.\n\nMüşteri Hemen Ustam Gelsin\'de işini oluşturur. Ustalar teklif verir, iş alınır ve uygulama aşamasına geçilir. Tam bu noktada, yapılacak işe uygun ürün ihtiyacı ortaya çıkar.\n\nHUG MARKET, bu ihtiyacı doğru ürünlerle buluşturur.\n\nBöylece markanız, kullanıcıya rastgele gösterilen bir reklam olarak değil; gerçek bir projenin, gerçek bir ustanın ve gerçek bir satın alma ihtiyacının doğal parçası olarak karşısına çıkar.\n\nİş Hemen Ustam Gelsin\'de başlar, ürün HUG MARKET\'te projeye dahil olur.');
    final card2 = _InfoCard(icon: Icons.hub_outlined, title: 'Usta + Müşteri Eşleşmesi', desc: 'Hemen Ustam Gelsin\'de müşteri işini oluşturur, usta teklifiyle projeye dahil olur. İş alındığında ise ihtiyaç duyulan ürünler ve malzemeler belirlenir.\n\nHUG MARKET, tam bu noktada devreye girerek projeyi, ustayı ve doğru ürünü aynı ekosistemde buluşturur.\n\nBöylece marka yalnızca ürünüyle değil, ürünü uygulayan usta ve gerçek proje üzerinden oluşan ihtiyaçla buluşur.\n\nMüşteri işi başlatır. Usta işi üstlenir. Ürün projeye dahil olur. HUG ekosistemi bu üç noktayı birbirine bağlar.');
    final card3 = _InfoCard(icon: Icons.tune_outlined, title: 'Kategori Bazlı Konumlanma', desc: 'Genel reklam değil, doğru kategoride güçlü görünürlük.\n\nHUG MARKET\'te markanız, geniş ve dağınık bir reklam alanında değil; ürünlerinizin gerçekten ihtiyaç duyulduğu kategori ve projelerde konumlanır.\n\nBoya, seramik, tesisat, elektrik, yalıtım veya yapı malzemeleri…\n\nÜrününüz, ilgili işin ve proje ihtiyacının doğal akışı içinde doğru kullanıcıya ulaşır.\n\nMarkanızı herkese göstermek yerine, ürününüze ihtiyaç duyan projede görünür kılıyoruz.');
    final card4 = _InfoCard(icon: Icons.bar_chart, title: 'Raporlanabilir Performans', desc: 'Görüntüleme, etkileşim ve kampanya performansını şeffaf şekilde takip edin.\n\nMarkanızın HUG ekosistemindeki görünürlüğünü yalnızca tahmini rakamlarla değil, ölçülebilir verilerle takip edin.\n\nHangi kategoride ne kadar görünürlük sağlandı, kullanıcılar hangi içeriklerle etkileşime geçti ve kampanyanız nasıl performans gösterdi; tüm süreç raporlanabilir ve takip edilebilir.');
    return Container(padding: EdgeInsets.symmetric(horizontal: isMobile? 20 : 40, vertical: isMobile? 40 : 64), color: const Color(0xFFFAFAFA), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Neden HUG MARKET?', style: GoogleFonts.poppins(fontSize: isMobile? 24 : 32, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text('Reklam alanı değil, ürün ihtiyacının doğal parçası olun.', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)), const SizedBox(height: 32),
      if (isMobile) Column(children: [card1, const SizedBox(height: 16), card2, const SizedBox(height: 16), card3, const SizedBox(height: 16), card4])
      else Column(children: [IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Expanded(child: card1), const SizedBox(width: 16), Expanded(child: card2)])), const SizedBox(height: 16), IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Expanded(child: card3), const SizedBox(width: 16), Expanded(child: card4)]))]),
    ]));
  }

  Widget _buildNasilCalisiyor(bool isMobile) {
    return Container(
      key: _journeySectionKey,
      padding: EdgeInsets.symmetric(horizontal: isMobile? 20 : 40, vertical: isMobile? 40 : 64),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Markanızın Yolculuğu', style: GoogleFonts.poppins(fontSize: isMobile? 24 : 32, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        RichText(text: TextSpan(style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]), children: [
          TextSpan(text: 'Markanız '),
          TextSpan(text: '© HUG MARKET', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: const Color(0xFFDC143C))),
          const TextSpan(text: '\'te bir reklam alanında değil, gerçek bir projenin ihtiyaç listesinde yer alır.'),
        ])),
        const SizedBox(height: 32),
        isMobile
            ? Column(children: [
          _journeyStep('01','İhtiyaç Doğar','- Müşteri','Hemen Ustam Gelsin\'de ilan oluşturulur'),
          _journeyLine(isMobile),
          _journeyStep('02','Eşleşme Olur','- Usta + Hemen Ustam Gelsin','Ustalar bu ilana teklif verir'),
          _journeyLine(isMobile),
          _journeyStep('03','HugAI Sepeti Hazırlar','','Projenin ihtiyaç listesi hazırlanır'),
          _journeyLine(isMobile),
          _journeyStep('04','HUG MARKET','Markayı Gösterir','Ürününüz bu ihtiyacın içinde konumlanır'),
          _journeyLine(isMobile),
          _journeyStep('05','Satışa Dönüşür','','İhtiyaç, satın almaya dönüşür'),
        ])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _journeyStep('01','İhtiyaç Doğar','- Müşteri','Hemen Ustam Gelsin\'de ilan oluşturulur')),
          _journeyHLine(),
          Expanded(child: _journeyStep('02','Eşleşme Olur','- Usta + Hemen Ustam Gelsin','Ustalar bu ilana teklif verir')),
          _journeyHLine(),
          Expanded(child: _journeyStep('03','HugAI Sepeti Hazırlar','','Projenin ihtiyaç listesi hazırlanır')),
          _journeyHLine(),
          Expanded(child: _journeyStep('04','HUG MARKET','Markayı Gösterir','Ürününüz bu ihtiyacın içinde konumlanır')),
          _journeyHLine(),
          Expanded(child: _journeyStep('05','Satışa Dönüşür','','İhtiyaç, satın almaya dönüşür')),
        ]),
      ]),
    );
  }

  Widget _journeyStep(String no, String title, String sub, String desc) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 64, height: 64, decoration: BoxDecoration(color: const Color(0xFF0F0F0F), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]), child: Center(child: Text(no, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)))),
      const SizedBox(height: 6), Container(height: 3, width: 36, decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(10))), const SizedBox(height: 10),
      Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 14)),
      if (sub.isNotEmpty) Text(sub, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.black54)),
      const SizedBox(height: 6), Text(desc, style: GoogleFonts.poppins(fontSize: 11.5, color: Colors.grey[600], height: 1.4)),
    ]);
  }
  Widget _journeyLine(bool isMobile) => Container(margin: const EdgeInsets.symmetric(vertical: 12), height: 24, width: 1, color: Colors.grey.shade300);
  Widget _journeyHLine() => Container(margin: const EdgeInsets.only(top: 32, left: 8, right: 8), height: 1, width: 40, color: Colors.grey.shade300);

  // REVİZE EDİLDİ: İş Birliği Modelleri - Kafaya oynayacak yeni yapı
  Widget _buildPaketler(bool isMobile) {
    return Container(padding: EdgeInsets.symmetric(horizontal: isMobile? 20 : 40, vertical: isMobile? 40 : 64), color: const Color(0xFF0F0F0F), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('İş Birliği Modelleri', style: GoogleFonts.poppins(fontSize: isMobile? 24 : 32, fontWeight: FontWeight.w800, color: Colors.white)),
      const SizedBox(height: 8),
      Text('Reklam değil, projenin içinde yer alın. Marka niyetine göre konumlanın.', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
      const SizedBox(height: 32),
      Wrap(spacing: 16, runSpacing: 16, children: [
        _packageCard('01','KATEGORİ LİDERLİĞİ','Kategori Sahipliği - En kapsamlı model',[
          'Kategori sahipliği & görünürlüğü',
          'HugAI Sepet Entegrasyonu',
          'Ürün görünürlüğü',
          'Banner alanı',
          'Kampanya alanları',
          'Usta prim sistemi',
          'Performans & dönüşüm raporu'
        ], true),
        _packageCard('02','PROJE & ÜRÜN ENTEGRASYONU','Satış odaklı - Projenin içinde yer alın',[
          'HugAI Sepet Entegrasyonu',
          'Proje bazlı ürün konumlandırması',
          'Usta odaklı satış & prim',
          'Ürün kampanyaları',
          'Kategori bağlantısı',
          'Dönüşüm & satış raporu'
        ], false),
        _packageCard('03','MARKA & KAMPANYA GÖRÜNÜRLÜĞÜ','Bilinirlik odaklı - Premium görünürlük',[
          'Ana sayfa görünürlüğü',
          'HUG banner & kategori banner',
          'Kampanya alanları & yönlendirmesi',
          'Marka tanıtımı',
          'Usta odaklı iletişim',
          'Kampanya raporu'
        ], false)
      ]),
    ]));
  }
  Widget _packageCard(String no, String title, String desc, List<String> items, bool featured) {
    return Container(width: 360, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: featured? Colors.white : const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(20), border: Border.all(color: featured? const Color(0xFFDC143C) : Colors.white10, width: featured? 1.5 : 1)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(no, style: GoogleFonts.poppins(fontWeight: FontWeight.w900, color: const Color(0xFFDC143C), fontSize: 12)), if (featured) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(6)), child: Text('POPÜLER', style: GoogleFonts.poppins(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)))]),
      const SizedBox(height: 12),Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 15, color: featured? Colors.black : Colors.white)),const SizedBox(height: 4),Text(desc, style: GoogleFonts.poppins(fontSize: 12, color: featured? Colors.grey[600] : Colors.grey[400])),const SizedBox(height: 16),Divider(color: featured? Colors.grey.shade200 : Colors.white10, height: 1),const SizedBox(height: 16),
      ...items.map((e) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [Container(width: 20, height: 20, decoration: BoxDecoration(color: featured? const Color(0xFFFFE8E8) : const Color(0xFFDC143C).withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.check, size: 12, color: Color(0xFFDC143C))), const SizedBox(width: 10), Expanded(child: Text(e, style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500, color: featured? Colors.black87 : Colors.white70)))]))),
    ]));
  }

  Widget _buildSektorler(bool isMobile) => Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile? 20 : 40, vertical: isMobile? 40 : 64),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Hangi kategoriler?', style: GoogleFonts.poppins(fontSize: isMobile? 20 : 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: [
          'Banyo & Mutfak','Temizlik & Hijyen','Elektrik & Aydınlatma','Hırdavat, El Aletleri & İş Güvenliği','Bahçe, Peyzaj & Dış Mekân','Tesisat & Su Sistemleri','Yapı Malzemeleri & İnşaat','Boya & Dekorasyon','Çatı & Cephe Sistemleri','Havuz & Spa Sistemleri','Isıtma, Soğutma & İklimlendirme','Seramik, Fayans & Zemin','Yalıtım & İzolasyon','Cam, Alüminyum & Cephe Sistemleri','Yenilenebilir Enerji & Güç Sistemleri','Kapı, Kilit & Geçiş Kontrol Sistemleri','Güvenlik, Yangın Algılama & Zayıf Akım Sistemleri','Asansör, Yürüyen Merdiven & Mekanik Taşıma Sistemleri'
        ].map((e) => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)), child: Text(e, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)))).toList())
      ])
  );

  Widget _buildForm(bool isMobile) {
    return Container(key: _formSectionKey, color: const Color(0xFFFAFAFA), padding: EdgeInsets.symmetric(horizontal: isMobile? 20 : 40, vertical: isMobile? 40 : 64), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 800), child: _isSuccess? _buildSuccessPanel() : Form(key: _formKey, child: Container(padding: EdgeInsets.all(isMobile? 20 : 32), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 10))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('ÇÖZÜM ORTAKLIĞI BAŞVURUSU', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
      const SizedBox(height: 6),
      Text('Markanızı HUG MARKET ekosistemine dahil etmek ve çözüm ortaklığı modelimizi görüşmek için bilgilerinizi paylaşın.', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13, height: 1.5)),
      const SizedBox(height: 24),
      _buildTextField(_firmaCtrl, 'Firma Adı*', true), const SizedBox(height: 14),
      Row(children: [Expanded(child: _buildTextField(_yetkiliCtrl, 'Yetkili Ad Soyad*', true)), const SizedBox(width: 14), Expanded(child: _buildTextField(_pozisyonCtrl, 'Pozisyon', false))]), const SizedBox(height: 14),
      _buildTextField(_emailCtrl, 'Kurumsal E-posta*', true, isEmail: true), const SizedBox(height: 14),
      Row(children: [Expanded(child: _buildTextField(_telCtrl, 'Telefon*', true, isPhone: true)), const SizedBox(width: 14), Expanded(child: _buildTextField(_webCtrl, 'Web Sitesi', false, isWebsite: true))]), const SizedBox(height: 32),

      Text('Markanızın HUG MARKET\'te yer almasını istediğiniz ürün alanlarını seçin.', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 15, color: const Color(0xFF111827))),
      const SizedBox(height: 4),
      Text('Birden fazla alan seçebilirsiniz.', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
      const SizedBox(height: 16),

      Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300, width: 1), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: _urunOntoloji.entries.map((entry) {
            final anaKategori = entry.key;
            final altAlanlar = entry.value;
            final seciliSayisi = _seciliUrunAlanlari[anaKategori]?.length?? 0;
            return Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent, listTileTheme: const ListTileThemeData(textColor: Color(0xFF111827), iconColor: Color(0xFF111827))),
                child: ExpansionTile(
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  title: Row(children: [
                    Expanded(child: Text(anaKategori, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 14, color: const Color(0xFF111827)))),
                    if (seciliSayisi > 0) Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFDC143C), borderRadius: BorderRadius.circular(20)), child: Text('$seciliSayisi seçildi', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))),
                  ]),
                  trailing: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF111827), size: 20),
                  children: altAlanlar.map((alt) {
                    final isChecked = _seciliUrunAlanlari[anaKategori]?.contains(alt)?? false;
                    return CheckboxListTile(
                      dense: true, contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, activeColor: const Color(0xFFDC143C), checkColor: Colors.white,
                      title: Text(alt, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
                      value: isChecked,
                      onChanged: (v) { setState(() { if (v == true) { _seciliUrunAlanlari[anaKategori]!.add(alt); } else { _seciliUrunAlanlari[anaKategori]!.remove(alt); } }); },
                    );
                  }).toList(),
                ),
              ),
            );
          }).toList(),
        ),
      ),

      const SizedBox(height: 24), Text('İş birliği modeli*', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14)), const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: isBirlikleri.map((k){final sel=_seciliIsBirligi.contains(k); return InkWell(onTap: ()=>setState(()=>sel? _seciliIsBirligi.remove(k) : _seciliIsBirligi.add(k)), borderRadius: BorderRadius.circular(20), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: sel? Colors.black : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: sel? Colors.black : Colors.grey.shade300)), child: Text(k, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: sel? Colors.white : Colors.black87))));}).toList()),
      const SizedBox(height: 20), Text('Mesajınız', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14)), const SizedBox(height: 10),
      TextFormField(controller: _mesajCtrl, maxLines: 5, minLines: 4, style: GoogleFonts.poppins(color: Colors.black, fontSize: 14), decoration: InputDecoration(hintText: 'Eklemek istedikleriniz...', hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 13), filled: true, fillColor: const Color(0xFFFAFAFA), contentPadding: const EdgeInsets.all(14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDC143C), width: 1.2)))),
      const SizedBox(height: 28),
      SizedBox(width: double.infinity, height: 54, child: ElevatedButton(onPressed: _isSubmitting? null : _submitForm, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: _isSubmitting? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text('ÇÖZÜM ORTAKLIĞI TALEP ET', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.3)))),
    ]))))));
  }

  Widget _buildSuccessPanel() => Container(width: double.infinity, padding: const EdgeInsets.all(32), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green.shade200)), child: Column(children: [Container(width: 64, height: 64, decoration: const BoxDecoration(color: Color(0xFFDC143C), shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 32)), const SizedBox(height: 16), Text('Başvurunuz Alındı', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text('Ekibimiz 24 saat içinde dönüş yapacak.', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])), const SizedBox(height: 20), OutlinedButton(onPressed: () => setState(() => _isSuccess = false), child: Text('Yeni Başvuru', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)))]));
  Widget _buildTextField(TextEditingController ctrl, String label, bool required, {bool isEmail=false, bool isPhone=false, bool isWebsite=false}) => TextFormField(controller: ctrl, keyboardType: isPhone? TextInputType.phone : isEmail? TextInputType.emailAddress : isWebsite? TextInputType.url : TextInputType.text, style: GoogleFonts.poppins(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500), validator: (v){if(required && (v==null||v.isEmpty)) return 'Zorunlu'; if(isEmail && v!=null &&!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Geçerli e-posta'; return null;}, decoration: InputDecoration(labelText: label, labelStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500), filled: true, fillColor: const Color(0xFFFAFAFA), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDC143C), width: 1.2))));
  Widget _buildFooter(bool isMobile) => Container(width: double.infinity, color: const Color(0xFF0F0F0F), padding: EdgeInsets.symmetric(horizontal: isMobile? 20 : 40, vertical: 24), child: Text('© ${DateTime.now().year} Hemen Ustam Gelsin - HUG MARKET Çözüm Ortaklığı', style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 11)));
}

class _InfoCard extends StatelessWidget {
  final IconData icon; final String title; final String desc;
  const _InfoCard({required this.icon, required this.title, required this.desc});
  List<TextSpan> _parseBrands(String text) {
    final brands = {'Hemen Ustam Gelsin': '© Hemen Ustam Gelsin','HUG MARKET': '© HUG MARKET','HugAI': '© HugAI','HUG': '© HUG'};
    final pattern = RegExp(r'(Hemen Ustam Gelsin|HUG MARKET|HugAI|\bHUG\b)');
    final spans = <TextSpan>[]; int last = 0;
    for (final m in pattern.allMatches(text)) {
      if (m.start > last) spans.add(TextSpan(text: text.substring(last, m.start), style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey[700], height: 1.6)));
      final original = m.group(0)!; final replaced = brands[original]?? '© $original';
      spans.add(TextSpan(text: replaced, style: GoogleFonts.poppins(fontSize: 12.5, color: const Color(0xFFDC143C), fontWeight: FontWeight.w800, height: 1.6)));
      last = m.end;
    }
    if (last < text.length) spans.add(TextSpan(text: text.substring(last), style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey[700], height: 1.6)));
    return spans;
  }
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF0F0F0F), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 18, color: Colors.white)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF111827))), const SizedBox(height: 8), RichText(text: TextSpan(children: _parseBrands(desc)))])),
    ]));
  }
}
