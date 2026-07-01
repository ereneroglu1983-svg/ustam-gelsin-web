import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserMenuWidget extends StatelessWidget {
  final String userName;
  final bool isUsta; // Usta mı Müşteri mi olduğunu buradan anlayacağız

  const UserMenuWidget({
    super.key,
    required this.userName,
    required this.isUsta,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.person, color: Color(0xFFDC143C)),
            const SizedBox(width: 8),
            Text(userName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
      onSelected: (value) {
        // Yönlendirme mantığı buraya gelecek
        Navigator.pushNamed(context, value);
      },
      itemBuilder: (context) => isUsta
          ? _buildUstaMenu(context)
          : _buildMusteriMenu(context),
    );
  }

  List<PopupMenuEntry<String>> _buildUstaMenu(BuildContext context) {
    return [
      _buildMenuItem("/usta-mesajlar", "Mesajlar", Icons.message),
      _buildMenuItem("/usta-profil", "Profil Bilgisi", Icons.person_outline),
      _buildMenuItem("/usta-is-yonetim", "Teklif ve İş Yönetimi", Icons.work),
      _buildMenuItem("/usta-cuzdan", "Cüzdanım", Icons.account_balance_wallet),
    ];
  }

  List<PopupMenuEntry<String>> _buildMusteriMenu(BuildContext context) {
    return [
      _buildMenuItem("/musteri-mesajlar", "Mesajlar", Icons.message),
      _buildMenuItem("/musteri-profil", "Profil Bilgisi", Icons.person_outline),
      _buildMenuItem("/musteri-ilanlarim", "İlanlarım", Icons.list_alt),
      _buildMenuItem("/musteri-is-gecmisi", "İş Geçmişi", Icons.history),
    ];
  }

  PopupMenuItem<String> _buildMenuItem(String route, String text, IconData icon) {
    return PopupMenuItem(
      value: route,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 10),
          Text(text, style: GoogleFonts.poppins()),
        ],
      ),
    );
  }
}