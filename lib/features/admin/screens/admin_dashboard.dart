// lib/features/admin/screens/admin_dashboard.dart - KOMUTA MERKEZI + HUG MARKET MOTORU - FINAL ISKELET UYUMLU
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'moderasyon_view.dart';
import 'finans_view.dart';
import 'stats_view.dart';
import 'user_view.dart';
import 'robot_view.dart';
import 'content_view.dart';
import 'b2b.dart';
import 'blog_ekle_screen.dart';
import 'admin_reklam_board.dart';
import '../hug_market/kategori_munhasir_motoru.dart';
import 'usta_poster.dart'; // <-- YENİ EKLENDİ - USTA POSTER SEKME

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final Color primaryRed = const Color(0xFFDC143C);
  final Color navyBlue = const Color(0xFF000080);
  final Color darkBg = const Color(0xFF0F0F0F);
  final Color cardBg = const Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          _buildNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1, color: Colors.white10),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      const StatsView(),
                      UserView(),
                      RobotView(),
                      const ContentView(),
                      FinansView(),
                      ModerasyonView(),
                      const B2BLeadsAdminPage(),
                      BlogEkleScreen(),
                      AdminReklamBoardScreen(),
                      const KategoriMunhasirMotoruPage(),
                      const UstaPosterScreen(), // <-- YENİ EKLENDİ - INDEX 10
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      backgroundColor: cardBg,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
      labelType: NavigationRailLabelType.all,
      indicatorColor: navyBlue,
      selectedIconTheme: const IconThemeData(color: Colors.white, size: 22),
      unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 20),
      selectedLabelTextStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      unselectedLabelTextStyle: const TextStyle(color: Colors.grey, fontSize: 11),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_customize_outlined), label: Text("Veriler")),
        NavigationRailDestination(icon: Icon(Icons.badge_outlined), label: Text("Kullanıcılar")),
        NavigationRailDestination(icon: Icon(Icons.precision_manufacturing_outlined), label: Text("Robot")),
        NavigationRailDestination(icon: Icon(Icons.article_outlined), label: Text("İçerik")),
        NavigationRailDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: Text("Finans")),
        NavigationRailDestination(icon: Icon(Icons.admin_panel_settings_outlined), label: Text("Modere")),
        NavigationRailDestination(icon: Icon(Icons.business_center_outlined), label: Text("B2B")),
        NavigationRailDestination(icon: Icon(Icons.post_add_outlined), label: Text("Blog")),
        NavigationRailDestination(icon: Icon(Icons.campaign_outlined), label: Text("Reklam")),
        NavigationRailDestination(icon: Icon(Icons.category_outlined), label: Text("Kategori")),
        NavigationRailDestination(icon: Icon(Icons.engineering_outlined), label: Text("Usta Poster")), // <-- YENİ EKLENDİ
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: cardBg,
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: primaryRed, size: 20),
          const SizedBox(width: 10),
          const Text("KOMUTA MERKEZİ", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          const Spacer(),
          if (_selectedIndex == 9)
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)), child: const Text("HUG MARKET • Kategori Münhasır Motoru • Firestore Bağlı", style: TextStyle(color: Colors.white70, fontSize: 10))),
          if (_selectedIndex == 10)
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(6)), child: const Text("USTA POSTERLERİ • karisik_slider • R2 Bağlı", style: TextStyle(color: Colors.orange, fontSize: 10))),
          const SizedBox(width: 12),
          IconButton(icon: Icon(Icons.power_settings_new, color: primaryRed, size: 20), onPressed: () => FirebaseAuth.instance.signOut()),
        ],
      ),
    );
  }
}