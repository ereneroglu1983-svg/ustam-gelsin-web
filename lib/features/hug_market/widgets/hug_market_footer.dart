import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ustam_gelsin/features/hug_market/theme/hug_market_theme.dart';

// lib/features/hug_market/widgets/hug_market_footer.dart
// v3 - SADECE GERÇEK BİLGİLER - Fake 444 ve Hadımköy silindi

class HugMarketFooter extends StatelessWidget {
  const HugMarketFooter({super.key});

  // GERÇEK FİRMA BİLGİLERİ - Sadece bunlar
  static const String FIRMA_UNVANI = "Hemen Ustam Gelsin";
  static const String FIRMA_ADRES = "Sağlık Mh. Kurudere Cd. No:76/9 Salihli - MANİSA";
  static const String FIRMA_TELEFON = "0532 163 59 66";
  static const String FIRMA_MAIL = "hemenustamgelsin@gmail.com";
  static const String FIRMA_VERGI_DAIRESI = "Salihli";
  static const String FIRMA_VERGI_NO = "3650145075";
  static const String DUNS_NO = "751176741";

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAF8),
        border: Border(top: BorderSide(color: Color(0xFFEAE8E3))),
      ),
      child: Column(
        children: [
          Container(height: 3, decoration: const BoxDecoration(gradient: HugMarketTheme.accentGradient)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 48 : 20, vertical: 32),
            child: isWeb ? _buildWeb4Col(context) : _buildMobile4Col(context),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEAE8E3)))),
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 48 : 20, vertical: 16),
            child: isWeb ? _buildBottomWeb() : _buildBottomMobile(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeb4Col(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _colKategoriler(context)),
        const SizedBox(width: 32),
        Expanded(child: _colKurumsal(context)),
        const SizedBox(width: 32),
        Expanded(child: _colYardim(context)),
        const SizedBox(width: 32),
        Expanded(child: _colIletisimGercek(context)),
      ],
    );
  }

  Widget _buildMobile4Col(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _colKategoriler(context)),
            const SizedBox(width: 20),
            Expanded(child: _colKurumsal(context)),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _colYardim(context)),
            const SizedBox(width: 20),
            Expanded(child: _colIletisimGercek(context)),
          ],
        ),
      ],
    );
  }

  Widget _colKategoriler(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _colTitle('Kategoriler'),
        _footerLink(context, 'Zemin & Fayans', '/hugmarket/kategoriler/zemin-fayans'),
        _footerLink(context, 'Boya & Alçı', '/hugmarket/kategoriler/boya-alci'),
        _footerLink(context, 'Tesisat', '/hugmarket/kategoriler/tesisat'),
        _footerLink(context, 'Elektrik', '/hugmarket/kategoriler/elektrik'),
        _footerLink(context, 'Doğrama & Cam', '/hugmarket/kategoriler/dograma-cam'),
        _footerLink(context, 'Mutfak & Banyo', '/hugmarket/kategoriler/mutfak-banyo'),
      ],
    );
  }

  Widget _colKurumsal(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _colTitle('Kurumsal'),
        _footerLink(context, 'Hakkımızda', '/hugmarket/kurumsal/hakkimizda'),
        _footerLink(context, 'Mağazalarımız', '/hugmarket/kurumsal/magazalar'),
        _footerLink(context, 'Kariyer', '/hugmarket/kurumsal/kariyer'),
        _footerLink(context, 'B2B Çözümler', '/hugmarket/kurumsal/b2b'),
        const SizedBox(height: 16),
        _colTitle('Hemen Ustam Gelsin'),
        _footerLink(context, 'Usta Çağır', '/'),
        _footerLink(context, 'AI Maliyet Hesapla', '/ai-hesapla'),
      ],
    );
  }

  Widget _colYardim(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _colTitle('Yardım'),
        _footerLink(context, 'Sıkça Sorulanlar', '/hugmarket/yardim/sss', isMarketContract: true),
        _footerLink(context, 'Kargo & Teslimat', '/hugmarket/yardim/kargo-teslimat', isMarketContract: true, highlight: true),
        _footerLink(context, 'İade & Değişim', '/hugmarket/yardim/iade-degisim', isMarketContract: true),
        _footerLink(context, 'Garanti Koşulları', '/hugmarket/yardim/garanti', isMarketContract: true),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: HugMarketTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
          child: Text('3 iş gününde şantiyede', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: HugMarketTheme.primary)),
        ),
      ],
    );
  }

  // SADECE GERÇEK İLETİŞİM
  Widget _colIletisimGercek(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _colTitle('İletişim'),
        const SizedBox(height: 4),
        Row(children: [
          const Icon(Icons.phone_outlined, size: 16, color: HugMarketTheme.primary),
          const SizedBox(width: 6),
          Text(FIRMA_TELEFON, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: HugMarketTheme.textDark)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.mail_outline, size: 16, color: HugMarketTheme.textMuted),
          const SizedBox(width: 6),
          Expanded(child: Text(FIRMA_MAIL, style: GoogleFonts.poppins(fontSize: 12, color: HugMarketTheme.textMuted))),
        ]),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFEAE8E3))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 14, color: HugMarketTheme.textMuted),
                const SizedBox(width: 4),
                Text('Merkez', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: HugMarketTheme.textMuted)),
              ]),
              const SizedBox(height: 4),
              Text(FIRMA_ADRES, style: GoogleFonts.poppins(fontSize: 11, color: HugMarketTheme.textMuted, height: 1.3)),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text('$FIRMA_VERGI_DAIRESI V.D. / $FIRMA_VERGI_NO', style: GoogleFonts.poppins(fontSize: 10, color: HugMarketTheme.textMuted)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.verified, size: 12, color: HugMarketTheme.primary),
                  const SizedBox(width: 4),
                  Expanded(child: Text('D-U-N-S® $DUNS_NO Registered', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: HugMarketTheme.textDark))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _colTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: HugMarketTheme.textDark)),
    );
  }

  Widget _footerLink(BuildContext context, String label, String route, {bool isMarketContract = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          if (isMarketContract) _showMarketContractDialog(context, label);
        },
        child: Row(
          children: [
            if (highlight) Container(width: 4, height: 4, decoration: const BoxDecoration(color: HugMarketTheme.accent, shape: BoxShape.circle)),
            if (highlight) const SizedBox(width: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 13, color: highlight ? HugMarketTheme.textDark : HugMarketTheme.textMuted, fontWeight: highlight ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  void _showMarketContractDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text(
          '$title - HUG Market\n\nBu sözleşme market alışverişine özeldir, platform sözleşmelerinden farklıdır.\n\n• Sponsor depodan direkt\n• Faturalı & Garantili\n• 3 iş gününde şantiyeye teslim\n• $FIRMA_UNVANI güvencesi - D-U-N-S® $DUNS_NO\n\nDetaylı metin eklenecek.',
          style: GoogleFonts.poppins(fontSize: 13, height: 1.5),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat'))],
      ),
    );
  }

  Widget _buildBottomWeb() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('© 2026 HUG Market • Profesyonel Yapı Marketi • $FIRMA_UNVANI güvencesiyle', style: GoogleFonts.poppins(fontSize: 12, color: HugMarketTheme.textMuted)),
              const SizedBox(height: 4),
              Text('$FIRMA_ADRES • $FIRMA_VERGI_DAIRESI V.D. / $FIRMA_VERGI_NO • D-U-N-S® $DUNS_NO Registered • Tüm hakları saklıdır.', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF9CA3AF))),
            ],
          ),
        ),
        Row(children: [_sslBadge(), const SizedBox(width: 16), _paymentRow()]),
      ],
    );
  }

  Widget _buildBottomMobile() {
    return Column(
      children: [
        _sslBadge(),
        const SizedBox(height: 12),
        _paymentRow(),
        const SizedBox(height: 16),
        Text('© 2026 HUG Market • $FIRMA_UNVANI', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 11, color: HugMarketTheme.textMuted)),
        const SizedBox(height: 4),
        Text(FIRMA_ADRES, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF9CA3AF))),
        const SizedBox(height: 4),
        Text('D-U-N-S® $DUNS_NO • $FIRMA_VERGI_DAIRESI V.D. / $FIRMA_VERGI_NO', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF9CA3AF))),
      ],
    );
  }

  Widget _sslBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.lock_outline, size: 16, color: Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Text('256-bit SSL • Güvenli Ödeme', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF6B7280))),
      ]),
    );
  }

  Widget _paymentRow() {
    return Wrap(spacing: 6, children: [
      _payBox('iyzico', isText: true, bold: true),
      _payBox('VISA', isText: true, color: const Color(0xFF1A1F71)),
      _payBox('MC', isMaster: true),
      _payBox('TROY', isText: true, bold: true),
      _payBox('AMEX', isText: true),
    ]);
  }

  Widget _payBox(String label, {bool isText = false, bool isMaster = false, bool bold = false, Color? color}) {
    return Container(
      width: 48,
      height: 32,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Center(
        child: isMaster
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle)),
          Transform.translate(offset: const Offset(-4, 0), child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFFF79E1B), shape: BoxShape.circle))),
        ])
            : Text(label, style: GoogleFonts.poppins(fontSize: isText ? 9 : 10, fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: color ?? const Color(0xFF111827))),
      ),
    );
  }
}
