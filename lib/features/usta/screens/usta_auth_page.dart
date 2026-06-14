// lib/features/usta/screens/usta_auth_page.dart

import 'package:flutter/material.dart';
// GÜVENLİK PROTOKOLÜ MADDE 3: Dosya yolları iskelet yapısına (Screenshots) göre güncellendi
import 'package:ustam_gelsin/core/theme/app_theme.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_login.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_register.dart';

class UstaAuthPage extends StatelessWidget {
  final String role;

  const UstaAuthPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      // AppColors runtime değerleri içerdiği için BoxDecoration seviyesinde 'const' kullanılmaz
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientMid,
            AppColors.primaryGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
                "Usta İşlemleri",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            // AppColors referansı nedeniyle TabBar üzerindeki 'const' kaldırıldı
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: AppColors.ustaColor, // REVIZE EDILDI: ustaBlue -> ustaColor
              indicatorWeight: 3,
              tabs: const [
                Tab(text: "Giriş Yap"),
                Tab(text: "Kayıt Ol"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              UstaLoginPage(targetRole: role),
              UstaRegisterPage(role: role),
            ],
          ),
        ),
      ),
    );
  }
}