import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'usta_aktif_teklif.dart';
import 'usta_tamamlanan_teklif.dart';
import 'usta_reddedilen_teklif.dart';

class UstaTekliflerimSayfasi extends StatelessWidget {
  const UstaTekliflerimSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final String? ustaId = authService.currentUser?.uid;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
          title: const Text("Teklif Yönetimi", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.white, elevation: 0, centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [Tab(text: "Aktif"), Tab(text: "Tamamlanan"), Tab(text: "Reddedilen")],
          ),
        ),
        body: ustaId == null
            ? const Center(child: Text("Oturum açmanız gerekiyor."))
            : TabBarView(
          children: [
            UstaAktifTeklif(ustaId: ustaId),
            UstaTamamlananTeklif(ustaId: ustaId),
            UstaReddedilenTeklif(ustaId: ustaId),
          ],
        ),
      ),
    );
  }
}