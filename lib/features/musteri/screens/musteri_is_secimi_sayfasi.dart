// lib/features/musteri/screens/musteri_is_secimi_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'musteri_ilan_detay_sayfasi.dart';

class MusteriIsSecimiSayfasi extends StatefulWidget {
  const MusteriIsSecimiSayfasi({super.key});

  @override
  State<MusteriIsSecimiSayfasi> createState() => _MusteriIsSecimiSayfasiState();
}

class _MusteriIsSecimiSayfasiState extends State<MusteriIsSecimiSayfasi> {
  final List<String> tumMeslekler = [
    "İÇ CEPHE BOYA VE BADANA", "DIŞ CEPHE BOYA VE MANTOLAMA", "DUVAR KAĞIDI VE POSTER UYGULAMASI",
    "İTALYAN BOYA VE DEKORATİF SIVA", "ASMA TAVAN", "GERGİ TAVAN SİSTEMLERİ",
    "KARTONPİYER, STROPİYER VE ÇITALAMA", "ALÇI SIVA VE SATEN ALÇI", "BÖLME DUVAR (ALÇIPAN/BETOBAN/CAM)",
    "FAYANS , SERAMİK VE KALEBODUR", "LAMİNAT , LAMİNE VE MASİF PARKE", "MERMER , GRANİT VE TRAVERTEN",
    "EPOKSİ ZEMİN KAPLAMA", "SİSTRE CİLA İŞLERİ", "SIHHİ TESİSAT VE PİS SU TESİSATI",
    "ELEKTRİK TESİSATI", "DOĞALGAZ TESİSATI VE KOMBİ MONTAJI/BAKIMI", "GÜNEŞ ENERJİSİ VE TERMOSİFON",
    "YERDEN ISITMA SİSTEMLERİ", "KLİMA MONTAJ , BAKIM VE GAZ DOLUMU", "PVC DOĞRAMA",
    "ALÜMİNYUM DOĞRAMA VE CEPHE", "CAM BALKON VE GİYOTİN CAM", "ODA KAPISI VE ÇELİK KAPI",
    "SİNEKLİK VE PANJUR SİSTEMLERİ", "MUTFAK DOLABI VE TEZGAHI", "BANYO DOLABI VE VESTİYER",
    "GÖMME DOLAP VE RAY DOLAP", "MARANGOZLUK VE MOBİLYA TAMİRİ", "ÇATI YAPIMI AKTARMA VE İZALASYON",
    "SANDVİÇ PANEL VE ŞİNGIL KAPLAMA", "TEMEL VE BODRUM SU YALITIMI", "BAHÇE PEYZAJ VE ÇİM EKİMİ",
    "OTAMATİK SULAMA SİSTEMLERİ", "HAVUZ YAPIMI VE BAKIMI", "FERFORJE KORKULUK VE BAHÇE KAPISI",
    "KONTEYNER, BUNGALOV VE PREFABRİK", "UYDU, INTERNET VE KAMERA SİTEMLERİ", "ASANSÖR BAKIM VE ONARIM",
    "ANAHTAR TESLİM KOMPLE TADİLAT"
  ];

  List<String> filtrelenmisListe = [];

  @override
  void initState() {
    super.initState();
    filtrelenmisListe = tumMeslekler;
  }

  void _filtrele(String query) {
    setState(() {
      filtrelenmisListe = tumMeslekler
          .where((meslek) => meslek.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🛠️ Cihazın alt kısmındaki sanal navigasyon tuşlarının veya home çentiğinin yüksekliğini milimetrik yakalıyoruz
    final double altGuvenliAlan = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Hizmet Seçimi", style: TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filtrele,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "İş arayın...",
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2DB34A)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              // 🛠️ DÜZELTİLDİ: Yatayda 16, üstte 0 pay bırakırken; altta ise standart 16 birim sabite cihazın donanımsal alt boşluğunu (altGuvenliAlan) ekledik.
              // Böylece "Komple Tadilat" kartı tuşların altında ezilmeyecek, otomatik olarak yukarı itilecek.
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: altGuvenliAlan > 0 ? altGuvenliAlan + 16 : 24,
              ),
              itemCount: filtrelenmisListe.length,
              itemBuilder: (context, index) {
                final meslek = filtrelenmisListe[index];
                return Card(
                  color: Colors.white.withOpacity(0.03),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(meslek, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white24),
                    onTap: () {
                      final user = FirebaseAuth.instance.currentUser;

                      final yeniIlan = IlanModel(
                        id: "",
                        baslik: meslek,
                        detaylar: "",
                        kategoriId: (tumMeslekler.indexOf(meslek) + 1).toString(),
                        kategori: meslek,
                        durum: 'aktif',
                        tarih: DateTime.now().toIso8601String(),
                        userId: user?.uid ?? 'misafir',
                        konumMetin: 'Konum Seçilmedi',
                        fiyatBilgisi: 'Hesaplanıyor...',
                        teknikDetaylar: {},
                        ilId: '',
                        ilceId: '',
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusteriIlanDetaySayfasi(ilan: yeniIlan),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}