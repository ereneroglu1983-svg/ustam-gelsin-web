// lib/features/profile/screens/musteri_kisisel_bilgiler_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ustam_gelsin/core/services/location_service.dart';

class MusteriKisiselBilgilerSayfasi extends StatefulWidget {
  const MusteriKisiselBilgilerSayfasi({super.key});

  @override
  State<MusteriKisiselBilgilerSayfasi> createState() => _MusteriKisiselBilgilerSayfasiState();
}

class _MusteriKisiselBilgilerSayfasiState extends State<MusteriKisiselBilgilerSayfasi> {
  final user = FirebaseAuth.instance.currentUser;

  Future<String> _getIsim(String? id, bool isSehir, {String? sehirId}) async {
    if (id == null || id.isEmpty) return "Seçilmemiş";
    try {
      if (isSehir) {
        final sehirler = await LocationService.loadSehirler();
        final sehir = sehirler.firstWhere((s) => s['sehir_id'].toString() == id, orElse: () => null);
        return sehir?['sehir_adi'] ?? "Bilinmiyor";
      } else {
        if (sehirId == null || sehirId.isEmpty) return "Bilinmiyor";
        final ilceler = await LocationService.loadIlceler(sehirId);
        final ilce = ilceler.firstWhere((i) => i['ilce_id'].toString() == id, orElse: () => null);
        return ilce?['ilce_adi'] ?? "Bilinmiyor";
      }
    } catch (e) {
      debugPrint("Konum ismi çekilirken hata: $e");
      return "Bilinmiyor";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // İş Geçmişim sayfasındaki koyu gradyan tema
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // --- CUSTOM APPBAR (Ortalanmış Başlık ve Geri Tuşu) ---
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Kişisel Bilgilerim",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 48), // Simetri için boşluk
                  ],
                ),
              ),
            ),

            // --- İÇERİK ALANI ---
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.blue));
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text("Veri bulunamadı.", style: TextStyle(color: Colors.white38)));
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  String sId = userData['sehir_id']?.toString() ?? "";
                  String iId = userData['ilce_id']?.toString() ?? "";

                  String fName = userData['firstName'] ?? "";
                  String lName = userData['lastName'] ?? "";
                  String displayName = (fName.isEmpty && lName.isEmpty)
                      ? "İsim Belirtilmemiş"
                      : "$fName $lName".trim();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildGlassInfoRow(
                          label: "AD SOYAD",
                          value: displayName,
                          isLocked: true,
                        ),
                        _buildGlassInfoRow(
                          label: "TELEFON NUMARASI",
                          value: userData['phone'] ?? "Ekle",
                          onPressed: () => _updateTextField(context, "phone", userData['phone'] ?? ""),
                        ),
                        _buildGlassInfoRow(
                          label: "ADRES",
                          value: userData['adres'] ?? "Ekle",
                          onPressed: () => _updateTextField(context, "adres", userData['adres'] ?? ""),
                        ),
                        FutureBuilder<String>(
                          future: _getIsim(sId, true),
                          builder: (context, res) => _buildGlassInfoRow(
                            label: "ŞEHİR",
                            value: res.data ?? "Yükleniyor...",
                            onPressed: () => _showLocationDialog(context, true, null),
                          ),
                        ),
                        FutureBuilder<String>(
                          future: _getIsim(iId, false, sehirId: sId),
                          builder: (context, res) => _buildGlassInfoRow(
                            label: "İLÇE",
                            value: res.data ?? "Yükleniyor...",
                            onPressed: sId.isEmpty ? null : () => _showLocationDialog(context, false, sId),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MODERN GLASS CARD TASARIMI ---
  Widget _buildGlassInfoRow({required String label, required String value, bool isLocked = false, VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04), // Glass effect
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  Text(value,
                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            if (isLocked)
              const Icon(Icons.lock_outline, color: Colors.white24, size: 20)
            else
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.edit_note, color: Colors.blue, size: 26),
              ),
          ],
        ),
      ),
    );
  }

  // Fonksiyonel kısımlar aynı kalmıştır (Location ve Update metodları)
  void _showLocationDialog(BuildContext context, bool isSehir, String? sehirId) async {
    List<dynamic> liste = isSehir
        ? await LocationService.loadSehirler()
        : await LocationService.loadIlceler(sehirId!);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.dark(), // Dialog'u da koyu tema yapıyoruz
          child: AlertDialog(
            backgroundColor: const Color(0xFF203A43),
            title: Text(isSehir ? "Şehir Seçin" : "İlçe Seçin"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: liste.length,
                itemBuilder: (context, index) {
                  var item = liste[index];
                  return ListTile(
                    title: Text(isSehir ? item['sehir_adi'] : item['ilce_adi']),
                    onTap: () async {
                      String field = isSehir ? "sehir_id" : "ilce_id";
                      String value = isSehir ? item['sehir_id'].toString() : item['ilce_id'].toString();
                      Map<String, dynamic> updateData = {field: value};
                      if (isSehir) updateData["ilce_id"] = "";
                      await FirebaseFirestore.instance.collection('users').doc(user?.uid).update(updateData);
                      if (context.mounted) Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateTextField(BuildContext context, String fieldName, String currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          backgroundColor: const Color(0xFF203A43),
          title: const Text("Bilgiyi Güncelle"),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
                  fieldName: controller.text,
                });
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Kaydet", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}