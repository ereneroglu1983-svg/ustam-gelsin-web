// lib/web_dosyalari/musteri_profil_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ustam_gelsin/features/musteri/screens/musteri_is_secimi_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_kisisel_bilgiler_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_ilanlarim_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_is_gecmisi_sayfasi.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_acil_ustam_sayfasi.dart';
import 'package:ustam_gelsin/features/chat/screens/mesajlarim_sayfasi.dart';

class MusteriProfilSayfasi extends StatefulWidget {
  const MusteriProfilSayfasi({super.key});

  @override
  State<MusteriProfilSayfasi> createState() => _MusteriProfilSayfasiState();
}

class _MusteriProfilSayfasiState extends State<MusteriProfilSayfasi> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              String ad = userData['firstName'] ?? "";
              String soyad = userData['lastName'] ?? "";
              String tamIsim = (ad.isNotEmpty || soyad.isNotEmpty)
                  ? "$ad $soyad"
                  : (userData['name'] ?? "KULLANICI");

              return Text(
                "HOŞ GELDİNİZ, ${tamIsim.trim().toUpperCase()}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.1),
              );
            }
            return const Text("YÜKLENİYOR...", style: TextStyle(color: Colors.white, fontSize: 14));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 600,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                _buildMesajBildirimHanesi(user?.uid, context),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriIsSecimiSayfasi())),
                    child: _buildGradientCard(
                      title: "Hemen Usta Bul",
                      subtitle: "Yeni bir ilan oluşturun",
                      gradient: const [Color(0xFF0F4C81), Color(0xFF0A3356)],
                      icon: Icons.add_circle,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriAcilUstamSayfasi())),
                    child: _buildGradientCard(
                      title: "7/24 ACİL USTA",
                      subtitle: "Tesisat, Elektrik, Çilingir, Klima...",
                      gradient: const [Color(0xFFBA1A1A), Color(0xFF680003)],
                      icon: Icons.emergency,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Divider(color: Colors.white10, thickness: 1, indent: 20, endIndent: 20),

                _menuItem(
                  icon: Icons.chat_bubble_outline, baslik: "Mesajlarım", altBaslik: "Ustalar ile görüşmeleriniz",
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MesajlarimSayfasi())),
                ),
                _menuItem(
                  icon: Icons.person_outline, baslik: "Kişisel Bilgilerim", altBaslik: "Ad, adres, telefon ve güvenlik",
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriKisiselBilgilerSayfasi())),
                ),
                _menuItem(
                  icon: Icons.assignment_outlined, baslik: "İlanlarım", altBaslik: "Verilen ilanlar ve gelen teklifler",
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriIlanlarimSayfasi())),
                ),
                _menuItem(
                  icon: Icons.history, baslik: "İş Geçmişim", altBaslik: "Tamamlanmış işler ve usta bilgileri",
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriIsGecmisiSayfasi())),
                ),

                const SizedBox(height: 40),
                TextButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                  label: const Text("Hesaptan Çıkış Yap", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====================== YARDIMCI WIDGETLAR ======================

  Widget _buildGradientCard({required String title, required String subtitle, required List<Color> gradient, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
          Icon(icon, color: Colors.white, size: 40),
        ],
      ),
    );
  }

  Widget _menuItem({required IconData icon, required String baslik, required String altBaslik, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFF0F4C81)),
      ),
      title: Text(baslik, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(altBaslik, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
    );
  }

  Widget _buildMesajBildirimHanesi(String? userId, BuildContext context) {
    if (userId == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('aliciId', isEqualTo: userId)
          .where('okundu', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox.shrink();

        int mesajSayisi = snapshot.data!.docs.length;

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MesajlarimSayfasi())),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withOpacity(0.5), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.mark_chat_unread, color: Colors.orange),
                const SizedBox(width: 15),
                Expanded(child: Text("$mesajSayisi adet yeni mesajınız var!", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600))),
                const Icon(Icons.chevron_right, color: Colors.orange),
              ],
            ),
          ),
        );
      },
    );
  }
}