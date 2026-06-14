// lib/features/admin/screens/admin_dashboard.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'moderasyon_view.dart';
import 'finans_view.dart';
import 'stats_view.dart';
import 'user_view.dart';
import 'robot_view.dart';
import 'content_view.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // Fenerbahçe'ye uygun: Kırmızı ve Lacivert tonları
  final Color primaryRed = const Color(0xFFDC143C);
  final Color navyBlue = const Color(0xFF000080); // Lacivert vurgu
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
      // Seçili olduğunda arka planı Lacivert yapıyoruz (Sarıyı sildik)
      indicatorColor: navyBlue,
      selectedIconTheme: IconThemeData(color: Colors.white, size: 22),
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
          const Text(
            "KOMUTA MERKEZİ",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.power_settings_new, color: primaryRed, size: 20),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
    );
  }
}