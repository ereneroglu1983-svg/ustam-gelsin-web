// lib/features/musteri/screens/musteri_ilanlarim_sayfasi.dart

import 'package:flutter/material.dart';
import 'musteri_aktif_ilanlar_listesi.dart';
import 'musteri_onaylanan_ilanlar.dart';

class MusteriIlanlarimSayfasi extends StatelessWidget {
  const MusteriIlanlarimSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Aktif ve Onaylananlar olmak üzere 2 sekme
      child: Scaffold(
        backgroundColor: const Color(0xFF0F2027),
        appBar: AppBar(
          title: const Text("İlanlarım", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Aktif İlanlar"),
              Tab(text: "Onaylanan Teklifler"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const TabBarView(
            children: [
              // Sol sekme: Sadece aktif ilanlar
              MusteriAktifIlanlarListesi(),

              // Sağ sekme: Sadece onaylanan ilanlar ve usta detayları
              MusteriOnaylananIlanlar(),
            ],
          ),
        ),
      ),
    );
  }
}