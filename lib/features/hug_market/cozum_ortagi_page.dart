import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CozumOrtagiPage extends StatefulWidget {
  const CozumOrtagiPage({super.key});

  @override
  State<CozumOrtagiPage> createState() => _CozumOrtagiPageState();
}

class _CozumOrtagiPageState extends State<CozumOrtagiPage> {
  final _formKey = GlobalKey<FormState>();
  final _formSectionKey = GlobalKey();
  final _scrollController = ScrollController();

  final _firmaCtrl = TextEditingController();
  final _yetkiliCtrl = TextEditingController();
  final _pozisyonCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _webCtrl = TextEditingController();
  final _mesajCtrl = TextEditingController();

  final Set<String> _seciliKategoriler = {};
  final Set<String> _seciliIsBirligi = {};
  bool _isSubmitting = false;
  bool _isSuccess = false;

  final List<String> kategoriler = [
    'Boya & Dekorasyon',
    'Seramik & Fayans',
    'Banyo & Mutfak',
    'Elektrik & Aydınlatma',
    'Tesisat',
    'Isıtma & Soğutma',
    'Yalıtım',
    'Diğer',
  ];

  final List<String> isBirlikleri = [
    'Kategori Çözüm Ortaklığı',
    'Marka Görünürlüğü',
    'Kampanya',
    'Ürün Entegrasyonu',
    'Diğer',
  ];

  @override
  void dispose() {
    _firmaCtrl.dispose();
    _yetkiliCtrl.dispose();
    _pozisyonCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _webCtrl.dispose();
    _mesajCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToForm() {
    Scrollable.ensureVisible(
      _formSectionKey.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_seciliKategoriler.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir kategori seçin')),
      );
      return;
    }
    if (_seciliIsBirligi.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir iş birliği modeli seçin')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await FirebaseFirestore.instance.collection('corporate_leads').add({
        'firma': _firmaCtrl.text.trim(),
        'yetkili': _yetkiliCtrl.text.trim(),
        'pozisyon': _pozisyonCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'telefon': _telCtrl.text.trim(),
        'webSitesi': _webCtrl.text.trim(),
        'kategoriler': _seciliKategoriler.toList(),
        'isBirlikleri': _seciliIsBirligi.toList(),
        'mesaj': _mesajCtrl.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'Yeni',
        'source': 'hug-market-cozum-ortagi-page',
      });
      if (!mounted) return;
      setState(() => _isSuccess = true);
      _firmaCtrl.clear();
      _yetkiliCtrl.clear();
      _pozisyonCtrl.clear();
      _emailCtrl.clear();
      _telCtrl.clear();
      _webCtrl.clear();
      _mesajCtrl.clear();
      _seciliKategoriler.clear();
      _seciliIsBirligi.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başvurunuz gönderilemedi. Lütfen tekrar deneyin.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      resizeToAvoidBottomInset: true,
      appBar: isMobile
          ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Çözüm Ortaklığı',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16)),
        centerTitle: true,
      )
          : null,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile) _buildTopBar(),
              _buildHero(w),
              _buildStratejikMesaj(w),
              _buildNedenHug(w),
              _buildNasilCalisiyor(w),
              _buildSponsorlukAvantajlari(w),
              _buildPaketler(w),
              _buildSektorler(w),
              _buildForm(w),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_ios_new, size: 18)),
          const SizedBox(width: 8),
          const Text('HUG MARKET', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5, color: Colors.black)),
          const Spacer(),
          TextButton(onPressed: _scrollToForm, child: const Text('Kurumsal Görüşme Talep Et', style: TextStyle(color: Color(0xFF0B3D91), fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  Widget _buildHero(double w) {
    final isMobile = w < 600;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 32 : 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFFFE4E6), borderRadius: BorderRadius.circular(20)),
            child: const Text('Markanız İçin Yapı Sektöründe Yeni Bir Dijital Kanal', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF8B0A1A))),
          ),
          const SizedBox(height: 16),
          Text('Markanızı Doğru Usta\nve Doğru Projeyle\nBuluşturun', style: TextStyle(fontSize: isMobile ? 28 : 44, fontWeight: FontWeight.w900, height: 1.1, color: Colors.black)),
          const SizedBox(height: 16),
          const Text('HUG MARKET Çözüm Ortaklığı ile markanızı doğru ürün ihtiyacı, doğru usta ve doğru proje ile buluşturuyoruz.', style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          const Wrap(spacing: 24, runSpacing: 16, children: [
            _HeroAdvantage(title: 'Doğru Ürün', desc: 'İhtiyaca göre ürün eşleşmesi'),
            _HeroAdvantage(title: 'Doğru Usta', desc: 'Ürünü kullanan ustalar ve proje ihtiyaçlarıyla buluşma'),
            _HeroAdvantage(title: 'Doğru Zaman', desc: 'İhtiyaç oluştuğu anda ürünün karşısına çıkma'),
          ]),
          const SizedBox(height: 24),
          const Text('Ürün Görünürlüğü · Kategori Konumlandırması · Usta Odaklı Ekosistem · Performans Raporlama', style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
          const SizedBox(height: 28),
          Wrap(spacing: 12, runSpacing: 12, children: [
            SizedBox(height: 48, child: ElevatedButton(onPressed: _scrollToForm, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B0A1A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 24)), child: const Text('Çözüm Ortağı Ol', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            SizedBox(height: 48, child: OutlinedButton(onPressed: _scrollToForm, style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF0B3D91)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 24)), child: const Text('Kurumsal Görüşme Talep Et', style: TextStyle(color: Color(0xFF0B3D91), fontWeight: FontWeight.bold)))),
          ]),
        ],
      ),
    );
  }

  Widget _buildStratejikMesaj(double w) {
    final isMobile = w < 600;
    return Container(
      width: double.infinity,
      color: const Color(0xFF0B3D91),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 32 : 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Reklam Alanı Değil, Ürün İhtiyacının İçinde Yer Alın', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 12),
        const Text('HUG MARKET, kullanıcı ve usta tarafından oluşan iş ihtiyacını ürün ve marka eşleşmesine dönüştürmek üzere tasarlanmıştır. Boya ihtiyacı oluştuğunda markanız o ihtiyacın doğal parçası olsun.', style: TextStyle(fontSize: 13, color: Colors.white, height: 1.5, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _buildNedenHug(double w) {
    final isMobile = w < 600;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 32 : 48),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Markanız İçin Yeni Bir Dijital Satış Kanalı', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black)),
        const SizedBox(height: 24),
        GridView.count(crossAxisCount: isMobile ? 1 : 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), childAspectRatio: isMobile ? 3.5 : 3.8, mainAxisSpacing: 16, crossAxisSpacing: 16, children: const [
          _InfoCard(icon: Icons.visibility_outlined, title: 'Ürün Görünürlüğü', desc: 'Markanızı, ürün ihtiyacının oluştuğu noktada görünür hale getirin.'),
          _InfoCard(icon: Icons.sync_alt_outlined, title: 'İhtiyaç Bazlı Eşleşme', desc: 'HUGAI tarafından belirlenen ihtiyaçlar, uygun ürün ve markalarla eşleştirilebilir.'),
          _InfoCard(icon: Icons.handyman_outlined, title: 'Usta Odaklı Ekosistem', desc: 'Ürünleri yalnızca son kullanıcıya değil, sahada ürünü kullanan ustaların ihtiyaçlarıyla buluşturuyoruz.'),
          _InfoCard(icon: Icons.bar_chart_outlined, title: 'Ölçülebilir Performans', desc: 'Kategori, ürün, kampanya ve etkileşim performansına ilişkin raporlama imkanları.'),
        ]),
      ]),
    );
  }

  Widget _buildNasilCalisiyor(double w) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: w < 600 ? 16 : 32, vertical: w < 600 ? 32 : 48),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('HUG MARKET\'te Markanızın Yolculuğu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black)),
        SizedBox(height: 24),
        _StepItem(no: '01', title: 'İhtiyaç oluşur', desc: 'Müşteri veya usta yapılacak işi belirler.'),
        _StepLine(),
        _StepItem(no: '02', title: 'HUGAI ihtiyacı analiz eder', desc: 'İş için gerekli malzeme ve ürün grubu belirlenir.'),
        _StepLine(),
        _StepItem(no: '03', title: 'Uygun ürünler eşleştirilir', desc: 'İhtiyaca uygun ürünler ve markalar HUG MARKET içerisinde eşleştirilir.'),
        _StepLine(),
        _StepItem(no: '04', title: 'Marka görünür hale gelir', desc: 'Çözüm ortağı markalar, ilgili kategori ve ihtiyaç bağlamında kullanıcıyla buluşur.'),
        _StepLine(),
        _StepItem(no: '05', title: 'Performans ölçülür', desc: 'Görüntüleme, etkileşim, ürün ilgisi ve kampanya performansının raporlanması hedeflenmektedir.'),
      ]),
    );
  }

  Widget _buildSponsorlukAvantajlari(double w) {
    final isMobile = w < 600;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 32 : 48),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Kategori Çözüm Ortaklığı', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black)),
        const SizedBox(height: 8),
        const Text('Bir kategoride markanız için daha güçlü görünürlük ve ürün konumlandırması.', style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF8B0A1A), width: 1.2)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('BOYA & DEKORASYON', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: Colors.black)),
            SizedBox(height: 4),
            Text('Çözüm Ortaklığı Örneği', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 12)),
            SizedBox(height: 16),
            Text('• Kategori görünürlüğü\n• Ürün konumlandırması\n• Kampanya alanları\n• İhtiyaç bazlı ürün eşleşmesi\n• Öncelikli marka görünürlüğü', style: TextStyle(fontSize: 13, height: 1.6, color: Colors.black)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildPaketler(double w) {
    return Container(
      color: const Color(0xFF0B3D91),
      padding: EdgeInsets.symmetric(horizontal: w < 600 ? 16 : 32, vertical: w < 600 ? 32 : 48),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('İş Birliği Modelleri', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
        SizedBox(height: 24),
        Wrap(spacing: 16, runSpacing: 16, children: [
          _PackageCard(no: '01', title: 'KATEGORİ ÇÖZÜM ORTAĞI', desc: 'En kapsamlı model.', items: ['Kategori görünürlüğü', 'Marka konumlandırması', 'Ürün görünürlüğü', 'Kategori banner alanı', 'Kampanya alanları', 'Performans raporlaması']),
          _PackageCard(no: '02', title: 'MARKA GÖRÜNÜRLÜK ORTAĞI', desc: 'Markanız için premium görünürlük modeli.', items: ['Ana sayfa görünürlüğü', 'HUG MARKET banner alanı', 'Kategori bağlantısı', 'Kampanya yönlendirmesi', 'Marka/ürün tanıtımı']),
          _PackageCard(no: '03', title: 'KAMPANYA ORTAĞI', desc: 'Kampanyalarınızı doğru kullanıcılarla buluşturun.', items: ['Kampanya alanları', 'Marka görünürlüğü', 'Ürün kampanyaları', 'Usta odaklı iletişim', 'Kampanya performans raporu']),
        ]),
      ]),
    );
  }

  Widget _buildSektorler(double w) {
    final isMobile = w < 600;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 32 : 48),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Yapı Sektörünün Farklı Kategorileri İçin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black)),
        const SizedBox(height: 8),
        const Text('Boya, seramik, banyo, elektrik, tesisat, ısıtma, yalıtım ve daha fazlası.', style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: ['Boya & Dekorasyon', 'Seramik & Zemin', 'Banyo & Mutfak', 'Elektrik & Aydınlatma', 'Tesisat', 'Isıtma & Soğutma', 'Yalıtım'].map((e) => _SektorChip(text: e)).toList()),
        const SizedBox(height: 16),
        const Text('Markanızın da HUG MARKET Çözüm Ortakları arasında yer almasını ister misiniz?', style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _buildForm(double w) {
    return Container(
      key: _formSectionKey,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: w < 600 ? 16 : 32, vertical: w < 600 ? 32 : 48),
      child: _isSuccess
          ? _buildSuccessPanel()
          : Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Kurumsal İş Birliği Başvurusu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black)),
          const SizedBox(height: 24),
          _buildTextField(_firmaCtrl, 'Firma Adı*', true),
          const SizedBox(height: 14),
          _buildTextField(_yetkiliCtrl, 'Yetkili Ad Soyad*', true),
          const SizedBox(height: 14),
          _buildTextField(_pozisyonCtrl, 'Pozisyon', false),
          const SizedBox(height: 14),
          _buildTextField(_emailCtrl, 'Kurumsal E-posta*', true, isEmail: true),
          const SizedBox(height: 14),
          _buildTextField(_telCtrl, 'Telefon*', true, isPhone: true),
          const SizedBox(height: 14),
          _buildTextField(_webCtrl, 'Web Sitesi', false, isWebsite: true),
          const SizedBox(height: 28),
          const Text('İlgilendiğiniz kategori*', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.black)),
          const SizedBox(height: 8),
          ...kategoriler.map((k) => Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: CheckboxListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              tileColor: Colors.white,
              title: Text(k, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
              value: _seciliKategoriler.contains(k),
              activeColor: const Color(0xFF8B0A1A),
              checkColor: Colors.white,
              onChanged: (v) => setState(() { if (v == true) _seciliKategoriler.add(k); else _seciliKategoriler.remove(k); }),
            ),
          )),
          const SizedBox(height: 20),
          const Text('İlgilendiğiniz iş birliği*', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.black)),
          const SizedBox(height: 8),
          ...isBirlikleri.map((k) => Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: CheckboxListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              tileColor: Colors.white,
              title: Text(k, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
              value: _seciliIsBirligi.contains(k),
              activeColor: const Color(0xFF8B0A1A),
              checkColor: Colors.white,
              onChanged: (v) => setState(() { if (v == true) _seciliIsBirligi.add(k); else _seciliIsBirligi.remove(k); }),
            ),
          )),
          const SizedBox(height: 20),
          const Text('Mesajınız', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.black)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _mesajCtrl,
            maxLines: 5,
            minLines: 4,
            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
              hintText: 'Eklemek istedikleriniz...',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0B3D91), width: 1.5)),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D91), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: _isSubmitting
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : const Text('Kurumsal Görüşme Talep Et', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)))),
        ]),
      ),
    );
  }

  Widget _buildSuccessPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: const Color(0xFFF0FFF4), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF10B981), width: 1)),
      child: Column(children: [
        Container(width: 64, height: 64, decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(32)), child: const Icon(Icons.check, color: Colors.white, size: 36)),
        const SizedBox(height: 16),
        const Text('Başvurunuz Alındı', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black)),
        const SizedBox(height: 12),
        const Text('Kurumsal iş birliği talebiniz başarıyla iletildi.\nEkibimiz başvurunuzu inceleyerek sizinle en kısa sürede iletişime geçecektir.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5, fontWeight: FontWeight.w500)),
        const SizedBox(height: 24),
        OutlinedButton(onPressed: () => setState(() => _isSuccess = false), child: const Text('Yeni Başvuru Yap', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700))),
      ]),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, bool required, {bool isEmail = false, bool isPhone = false, bool isWebsite = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isPhone ? TextInputType.phone : isEmail ? TextInputType.emailAddress : isWebsite ? TextInputType.url : TextInputType.text,
      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      textInputAction: TextInputAction.next,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      validator: (v) {
        if (required && (v == null || v.isEmpty)) return 'Zorunlu alan';
        if (isEmail && v != null && v.isNotEmpty && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Geçerli e-posta girin';
        if (isPhone && v != null && v.isNotEmpty) {
          final cleaned = v.replaceAll(RegExp(r'\D'), '');
          if (cleaned.length != 10 && cleaned.length != 11) return 'Geçerli telefon girin';
          if (cleaned.length == 11 && !cleaned.startsWith('05')) return 'Telefon 05 ile başlamalı';
          if (cleaned.length == 10 && !cleaned.startsWith('5')) return 'Geçerli telefon girin';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.w600, fontSize: 13),
        floatingLabelStyle: const TextStyle(color: Color(0xFF0B3D91), fontWeight: FontWeight.w700),
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0B3D91), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
      ),
    );
  }
}

class _SektorChip extends StatelessWidget {
  final String text;
  const _SektorChip({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)));
  }
}

class _HeroAdvantage extends StatelessWidget {
  final String title; final String desc; const _HeroAdvantage({required this.title, required this.desc});
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.black)), const SizedBox(height: 2), Text(desc, style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500))]);
}
class _InfoCard extends StatelessWidget {
  final IconData icon; final String title; final String desc; const _InfoCard({required this.icon, required this.title, required this.desc});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFFFE4E6), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18, color: const Color(0xFF8B0A1A))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.black)), const SizedBox(height: 4), Text(desc, style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.4, fontWeight: FontWeight.w500))]))]));
}
class _StepItem extends StatelessWidget {
  final String no; final String title; final String desc; const _StepItem({required this.no, required this.title, required this.desc});
  @override Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFF8B0A1A), borderRadius: BorderRadius.circular(18)), child: Center(child: Text(no, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black)), const SizedBox(height: 2), Text(desc, style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500)), const SizedBox(height: 8)]))]);
}
class _StepLine extends StatelessWidget { const _StepLine(); @override Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(left: 17, bottom: 8), width: 2, height: 16, color: Colors.grey.shade300); }
class _PackageCard extends StatelessWidget {
  final String no; final String title; final String desc; final List<String> items; const _PackageCard({required this.no, required this.title, required this.desc, required this.items});
  @override Widget build(BuildContext context) => Container(width: 300, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(no, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF8B0A1A), fontSize: 12)), const SizedBox(height: 4), Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black)), const SizedBox(height: 4), Text(desc, style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500)), const SizedBox(height: 12), const Divider(height: 1), const SizedBox(height: 12), ...items.map((e) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [const Icon(Icons.check, size: 14, color: Color(0xFF8B0A1A)), const SizedBox(width: 6), Expanded(child: Text(e, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)))]))) ]));
}