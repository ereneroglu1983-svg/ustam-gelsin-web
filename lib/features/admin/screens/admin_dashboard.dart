// lib/features/admin/screens/admin_dashboard.dart - V7 BAKIYE YUKLE EKLI - TAM
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
import 'usta_poster.dart';
import 'system_messages_view.dart';
import 'bakiye_yukle_view.dart'; // YENİ EKLENDİ MORUK!

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  String? _userRoleFilter;

  final Color primaryOrange = const Color(0xFFFF7A00);
  final Color darkBg = const Color(0xFF0F0F0F);
  final Color cardBg = const Color(0xFF1A1A1A);

  void _handleStatsUserTap({String? role}) { setState(() { _userRoleFilter = role; _selectedIndex = 1; }); }
  void _handleNavigateToRobot() { setState(() { _userRoleFilter = null; _selectedIndex = 2; }); }
  void _handleNavigateToFinans() { setState(() { _userRoleFilter = null; _selectedIndex = 4; }); }
  void _handleNavigateToB2B() { setState(() { _userRoleFilter = null; _selectedIndex = 6; }); }
  void _handleNavigateToSystemMessages() { setState(() { _userRoleFilter = null; _selectedIndex = 11; }); }
  void _handleNavigateToBakiyeYukle() { setState(() { _userRoleFilter = null; _selectedIndex = 12; }); } // YENİ

  Widget _getView(int index) {
    switch (index) {
      case 0: return StatsView(onNavigateToUsers: _handleStatsUserTap, onNavigateToRobot: _handleNavigateToRobot, onNavigateToFinans: _handleNavigateToFinans, onNavigateToB2B: _handleNavigateToB2B, onNavigateToSystemMessages: _handleNavigateToSystemMessages);
      case 1: return UserView(initialRoleFilter: _userRoleFilter);
      case 2: return const RobotView();
      case 3: return const ContentView();
      case 4: return const FinansView();
      case 5: return const ModerasyonView();
      case 6: return const B2BLeadsAdminPage();
      case 7: return BlogEkleScreen();
      case 8: return AdminReklamBoardScreen();
      case 9: return const KategoriMunhasirMotoruPage();
      case 10: return const UstaPosterScreen();
      case 11: return const SystemMessagesView();
      case 12: return const BakiyeYukleView(); // YENİ EKLENDİ!
      default: return StatsView(onNavigateToUsers: _handleStatsUserTap, onNavigateToRobot: _handleNavigateToRobot, onNavigateToFinans: _handleNavigateToFinans, onNavigateToB2B: _handleNavigateToB2B, onNavigateToSystemMessages: _handleNavigateToSystemMessages);
    }
  }

  String _getTitle(int index) {
    const titles = ["Ana Sayfa","Kullanıcılar","Yeni Katılanlar","İçerik","Finans","Modere","B2B","Blog","Reklam","Kategori","Usta Poster","Sistem Mesajları","Bakiye Yükle"];
    return titles[index];
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(backgroundColor: darkBg, drawer: isMobile? _buildDrawer() : null, appBar: isMobile? _buildMobileAppBar() : null, body: isMobile? _buildMobileBody() : _buildDesktopBody());
  }
  Widget _buildDesktopBody() => Row(children: [_buildNavigationRail(), const VerticalDivider(thickness: 1, width: 1, color: Colors.white10), Expanded(child: Column(children: [_buildHeader(), Expanded(child: _getView(_selectedIndex))]))]);
  Widget _buildMobileBody() => Column(children: [_buildHeader(isMobile: true), Expanded(child: _getView(_selectedIndex))]);
  AppBar _buildMobileAppBar() => AppBar(backgroundColor: cardBg, iconTheme: const IconThemeData(color: Colors.white), title: Text(_getTitle(_selectedIndex), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), actions: [IconButton(tooltip: "Paneli Kapat", icon: Icon(Icons.close_rounded, color: primaryOrange), onPressed: () { if (Navigator.canPop(context)) Navigator.pop(context); })]);

  Widget _buildNavigationRail() {
    return NavigationRail(
      backgroundColor: cardBg,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) => setState(() { _selectedIndex = index; if (index!= 1) _userRoleFilter = null; }),
      labelType: NavigationRailLabelType.all,
      indicatorColor: primaryOrange.withOpacity(0.2),
      selectedIconTheme: IconThemeData(color: primaryOrange, size: 22),
      unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 20),
      selectedLabelTextStyle: TextStyle(color: primaryOrange, fontSize: 11, fontWeight: FontWeight.bold),
      unselectedLabelTextStyle: const TextStyle(color: Colors.grey, fontSize: 11),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home_outlined), label: Text("Ana Sayfa")),
        NavigationRailDestination(icon: Icon(Icons.badge_outlined), label: Text("Kullanıcılar")),
        NavigationRailDestination(icon: Icon(Icons.person_add_alt_1_outlined), label: Text("Yeni Katılanlar")),
        NavigationRailDestination(icon: Icon(Icons.article_outlined), label: Text("İçerik")),
        NavigationRailDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: Text("Finans")),
        NavigationRailDestination(icon: Icon(Icons.admin_panel_settings_outlined), label: Text("Modere")),
        NavigationRailDestination(icon: Icon(Icons.business_center_outlined), label: Text("B2B")),
        NavigationRailDestination(icon: Icon(Icons.post_add_outlined), label: Text("Blog")),
        NavigationRailDestination(icon: Icon(Icons.campaign_outlined), label: Text("Reklam")),
        NavigationRailDestination(icon: Icon(Icons.category_outlined), label: Text("Kategori")),
        NavigationRailDestination(icon: Icon(Icons.engineering_outlined), label: Text("Usta Poster")),
        NavigationRailDestination(icon: Icon(Icons.mail_outline), label: Text("Sistem Msj")),
        NavigationRailDestination(icon: Icon(Icons.account_balance_wallet, color: Colors.green), label: Text("Bakiye Yükle")), // YENİ!
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: cardBg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(decoration: BoxDecoration(color: darkBg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.shield, color: primaryOrange, size: 32), const SizedBox(height: 10), const Text("KOMUTA MERKEZİ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const Text("Hemen Ustam Gelsin", style: TextStyle(color: Colors.white54, fontSize: 12))])),
          _drawerItem(0, Icons.home_outlined, "Ana Sayfa"),
          _drawerItem(1, Icons.badge_outlined, "Kullanıcılar"),
          _drawerItem(2, Icons.person_add_alt_1_outlined, "Yeni Katılanlar"),
          _drawerItem(3, Icons.article_outlined, "İçerik"),
          _drawerItem(4, Icons.account_balance_wallet_outlined, "Finans"),
          _drawerItem(5, Icons.admin_panel_settings_outlined, "Modere"),
          _drawerItem(6, Icons.business_center_outlined, "B2B"),
          _drawerItem(7, Icons.post_add_outlined, "Blog"),
          _drawerItem(8, Icons.campaign_outlined, "Reklam"),
          _drawerItem(9, Icons.category_outlined, "Kategori"),
          _drawerItem(10, Icons.engineering_outlined, "Usta Poster"),
          _drawerItem(11, Icons.mail_outline, "Sistem Mesajları"),
          const Divider(color: Colors.white10),
          _drawerItem(12, Icons.account_balance_wallet, "Bakiye Yükle", isGreen: true), // YENİ! YEŞİL İKON!
          const Divider(color: Colors.white10),
          ListTile(leading: const Icon(Icons.logout, color: Colors.grey), title: const Text("Çıkış Yap (Firebase)", style: TextStyle(color: Colors.grey, fontSize: 12)), onTap: () => FirebaseAuth.instance.signOut()),
        ],
      ),
    );
  }

  ListTile _drawerItem(int index, IconData icon, String title, {bool isGreen = false}) {
    final bool selected = _selectedIndex == index;
    return ListTile(
        leading: Icon(icon, color: selected? primaryOrange : (isGreen? Colors.green : Colors.grey)),
        title: Text(title, style: TextStyle(color: selected? primaryOrange : (isGreen? Colors.green.shade300 : Colors.white70), fontWeight: selected? FontWeight.bold : FontWeight.normal)),
        selected: selected,
        selectedTileColor: isGreen? Colors.green.withOpacity(0.1) : primaryOrange.withOpacity(0.1),
        onTap: () { setState(() { _selectedIndex = index; if (index!= 1) _userRoleFilter = null; }); Navigator.pop(context); }
    );
  }
  Widget _buildHeader({bool isMobile = false}) => Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), color: cardBg, child: Row(children: [if (!isMobile) Icon(Icons.shield_outlined, color: primaryOrange, size: 20), if (!isMobile) const SizedBox(width: 10), if (!isMobile) const Text("KOMUTA MERKEZİ", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)), if (isMobile) Text(_getTitle(_selectedIndex), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const Spacer(), const SizedBox(width: 12), if (!isMobile) IconButton(tooltip: "Kapat ve Anasayfaya Dön", icon: Icon(Icons.close_rounded, color: primaryOrange, size: 22), onPressed: () { if (Navigator.canPop(context)) Navigator.pop(context); })]));
}