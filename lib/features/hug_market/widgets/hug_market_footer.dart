import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HugMarketFooter extends StatelessWidget {
  const HugMarketFooter({super.key});

  static const String DUNS_NO = "751176741";

  Future<void> _launchMail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: 'info@hemenustamgelsin.com');
    await launchUrl(emailUri);
  }

  Future<void> _launchWeb() async {
    final Uri webUri = Uri.parse('https://hemenustamgelsin.com/');
    // Web'de garanti çalışması için
    await launchUrl(
      webUri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFEAE8E3))),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            16 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '©HUG Market • © Hemen Ustam Gelsin',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _launchMail,
                child: Text(
                  'info@hemenustamgelsin.com',
                  style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A), decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: _launchWeb,
                child: Text(
                  'www.hemenustamgelsin.com',
                  style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A), decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'D-U-N-S® Registered Business Identifier: $DUNS_NO',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF475569)),
              ),
              const SizedBox(height: 2),
              Text(
                'Tüm hakları saklıdır.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF475569)),
              ),
              const SizedBox(height: 20),
              Text(
                'GÜVENLİ ÖDEME',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A), letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _payImage('assets/visa.png'),
                  _payImage('assets/master.png'),
                  _payImage('assets/troy.png'),
                  _payImage('assets/iyzico.png'),
                  _payImage('assets/3D_secure.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _payImage(String path) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Image.asset(
        path,
        height: 20,
        fit: BoxFit.contain,
      ),
    );
  }
}