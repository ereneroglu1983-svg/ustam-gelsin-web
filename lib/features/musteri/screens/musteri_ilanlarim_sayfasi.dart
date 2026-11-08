// lib/features/musteri/screens/musteri_ilanlarim_sayfasi.dart - FINAL v2 - NORMAL / PROJE ANAHTARLI
import 'package:flutter/material.dart';
import 'musteri_aktif_ilanlar_listesi.dart';
import 'musteri_onaylanan_ilanlar.dart';
import 'musteri_proje_aktif_ilanlar_listesi.dart';
import 'musteri_proje_onaylanan_ilanlar.dart';

class MusteriIlanlarimSayfasi extends StatefulWidget {
  const MusteriIlanlarimSayfasi({super.key});

  @override
  State<MusteriIlanlarimSayfasi> createState() => _MusteriIlanlarimSayfasiState();
}

class _MusteriIlanlarimSayfasiState extends State<MusteriIlanlarimSayfasi> {
  // 0 = Normal İlanlar, 1 = Proje İlanları
  int _seciliTur = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Aktif ve Onaylananlar olmak üzere 2 sekme - AYNEN
      child: Scaffold(
        backgroundColor: const Color(0xFF0F2027),
        appBar: AppBar(
          title: const Text("İlanlarım", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(96),
            child: Column(
              children: [
                // --- YENİ: NORMAL / PROJE ANAHTARI ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _turButonu(0, "Normal İlanlar", Icons.handyman_outlined)),
                        Expanded(child: _turButonu(1, "Proje İlanları", Icons.architecture_outlined)),
                      ],
                    ),
                  ),
                ),
                const TabBar(
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
              ],
            ),
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
          child: TabBarView(
            children: _seciliTur == 0
                ? const [
              // NORMAL - ESKİSİ AYNEN
              MusteriAktifIlanlarListesi(),
              MusteriOnaylananIlanlar(),
            ]
                : const [
              // PROJE - YENİ
              MusteriProjeAktifIlanlarListesi(),
              MusteriProjeOnaylananIlanlar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _turButonu(int index, String label, IconData icon) {
    final secili = _seciliTur == index;
    return GestureDetector(
      onTap: () => setState(() => _seciliTur = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: secili ? (index == 0 ? Colors.blue : const Color(0xFFC8A45D)) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: secili ? Colors.white : Colors.white54),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: secili ? Colors.white : Colors.white54, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}