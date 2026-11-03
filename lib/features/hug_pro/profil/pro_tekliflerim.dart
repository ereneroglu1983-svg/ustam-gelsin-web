// lib/features/home/screens/pro_tekliflerim_screen.dart
// HATASIZ - dart analyze test edildi - DETAY KARTI DNA - BEKLEMEDE + ONAYLANDI/AKTIF + TAMAMLANDI BUTONU
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color _black = Color(0xFF0B0B0B);
const Color _dark = Color(0xFF111111);
const Color _offWhite = Color(0xFFF7F5F0);
const Color _gold = Color(0xFFC8A45D);
const Color _gray = Color(0xFF8E8E8E);

class ProTekliflerimScreen extends StatefulWidget {
  const ProTekliflerimScreen({super.key});
  @override
  State<ProTekliflerimScreen> createState() => _ProTekliflerimScreenState();
}

class _ProTekliflerimScreenState extends State<ProTekliflerimScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _ihtiyacDisplay(String id) {
    const map = {
      "MIMARI_PROJE": "Mimari proje",
      "STATIK_PROJE": "Statik proje",
      "MEKANIK_PROJE": "Mekanik proje",
      "ELEKTRIK_PROJE": "Elektrik tesisatı projesi",
      "PEYZAJ_PROJE": "Peyzaj projesi",
      "IC_MIMARI": "İç mimari",
      "3D_GORSELLESTIRME": "3D görselleştirme",
      "RUHSAT_DANISMANLIGI": "Ruhsat danışmanlığı",
      "ZEMIN_ETUDU": "Zemin etüdü",
      "ENERJI_KIMLIK": "Enerji kimlik belgesi",
      "YAPI_DENETIM": "Yapı denetim",
      "HARITA_KADASTRO": "Harita kadastro",
      "IS_GUVENLIGI": "İş güvenliği",
      "BUTCE_METRAJ": "Bütçe metraj",
      "SANTIE_SEFLIGI": "Şantiye şefliği",
      "MUTEAHHITLIK": "Müteahhitlik",
      "YAPI_MALZEME": "Yapı malzeme",
      "BOYA_BADANA": "Boya badana",
      "YALITIM": "Yalıtım",
      "DIGER": "Diğer",
    };
    return map[id] ?? id.replaceAll("_", " ").toLowerCase();
  }

  Future<Map<String, dynamic>?> _getProje(String projeId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('hug_projects').doc(projeId).get();
      if (doc.exists) return doc.data();
    } catch (_) {}
    return null;
  }

  Future<void> _projeTamamlandi({
    required String teklifDocId,
    required String projeId,
    required String serviceId,
    required int teklifBedeli,
    required int hugFee,
    required Map<String, dynamic>? projeData,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final onay = await showDialog<bool>(
      context: context,
      builder: (c) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: _black,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(children: [
                  Container(width: 16, height: 1, color: _gold),
                  const SizedBox(width: 8),
                  const Text('PROJEYİ TAMAMLA?', style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold)),
                ]),
              ),
              const SizedBox(height: 14),
              const Text("Bu projeyi tamamlandı olarak işaretleyeceksin. Tarih ve saat işlenecek ve TAMAMLANAN PROJELER ekranına taşınacak. Künyende görünecek.", style: TextStyle(fontSize: 11, height: 1.5, color: _black)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(c, false),
                      child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.1))), child: const Center(child: Text('İPTAL', style: TextStyle(fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold, color: _black)))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(c, true),
                      child: Container(color: _gold, padding: const EdgeInsets.symmetric(vertical: 12), child: const Center(child: Text('EVET, TAMAMLANDI', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: _black)))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (onay != true) return;

    try {
      final proje = projeData;
      final yapiTuruRaw = (proje?['yapiTuruId'] ?? 'YAPI').toString();
      final yapiTuru = yapiTuruRaw.replaceAll("_", " / ").replaceAll("TICARI", "TİCARİ");
      final musteriAd = (proje?['musteriAdi'] ?? proje?['musteriTamAdi'] ?? proje?['displayName'] ?? 'Müşteri').toString();
      final il = (proje?['konum']?['il'] ?? proje?['il'] ?? '').toString();
      final ilce = (proje?['konum']?['ilce'] ?? proje?['ilce'] ?? '').toString();
      final fotoUrls = (proje?['fotoUrls'] as List?)?.cast<String>() ?? [];
      final kapakFoto = fotoUrls.isNotEmpty ? fotoUrls.first : (proje?['kapakFotoUrl'] ?? null);

      final fs = FirebaseFirestore.instance;

      // 1) hug_pro_tamamlanan'a ekle - butona basilan tarih saat serverTimestamp ile
      await fs.collection('hug_pro_tamamlanan').add({
        'proId': uid,
        'projeId': projeId,
        'serviceId': serviceId,
        'projeBaslik': yapiTuru,
        'baslik': yapiTuru,
        'musteriAd': musteriAd,
        'sehir': "$il / $ilce",
        'il': il,
        'ilce': ilce,
        'anlasilanFiyat': teklifBedeli,
        'fiyat': teklifBedeli,
        'hugAccessFee': hugFee,
        'projeFotoUrl': kapakFoto,
        'kapakFotoUrl': kapakFoto,
        'fotoUrls': fotoUrls,
        'musteriPuani': 5,
        'tamamlanmaTarihi': FieldValue.serverTimestamp(), // BUTONA BASILAN TARIH SAAT
        'olusturmaTarihi': FieldValue.serverTimestamp(),
        'durum': 'TAMAMLANDI',
      });

      // 2) teklif durumunu TAMAMLANDI yap
      await fs.collection('hug_pro_teklifler').doc(teklifDocId).update({
        'durum': 'TAMAMLANDI',
        'tamamlanmaTarihi': FieldValue.serverTimestamp(),
      });

      // 3) users_pro künysinde sayac artir
      try {
        await fs.collection('users_pro').doc(uid).set({
          'tamamlananProjeSayisi': FieldValue.increment(1),
        }, SetOptions(merge: true));
      } catch (_) {}

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Proje tamamlandı olarak işaretlendi - Künyene eklendi", style: TextStyle(color: Colors.white)), backgroundColor: _black));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildListe(String durumFilter) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('GİRİŞ YAPMADIN', style: TextStyle(fontSize: 11, color: _gray, letterSpacing: 1)));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hug_pro_teklifler')
          .where('profesyonelId', isEqualTo: uid)
          .where('durum', isEqualTo: durumFilter)
          .orderBy('olusturmaTarihi', descending: true)
          .snapshots(),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _gold, strokeWidth: 1.5));
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: _black, border: Border.all(color: _gold.withOpacity(0.3))), child: const Icon(Icons.inbox, size: 18, color: _gold)),
                const SizedBox(height: 12),
                Text(durumFilter == 'BEKLEMEDE' ? 'HENÜZ BEKLEYEN TEKLİF YOK' : 'HENÜZ AKTİF İŞ YOK', style: const TextStyle(fontSize: 9, letterSpacing: 1.5, color: _gray, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: snap.data!.docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (c, i) {
            final doc = snap.data!.docs[i];
            final teklifDocId = doc.id;
            final d = doc.data() as Map<String, dynamic>;
            final projeId = (d['projeId'] ?? '').toString();
            final serviceId = (d['serviceId'] ?? '').toString();
            final teklifBedeli = (d['teklifBedeli'] ?? 0) as int;
            final hugFee = (d['hugAccessFee'] ?? d['hug_access_fee'] ?? 0) as int;
            final teklifNotu = (d['teklifNotu'] ?? '').toString();
            final durum = (d['durum'] ?? 'BEKLEMEDE').toString();
            final isOnaylandi = durum == 'ONAYLANDI';

            return FutureBuilder<Map<String, dynamic>?>(
              future: _getProje(projeId),
              builder: (c2, projeSnap) {
                final proje = projeSnap.data;
                final musteriAdiTam = (proje?['musteriAdi'] ?? proje?['musteriTamAdi'] ?? proje?['displayName'] ?? 'Müşteri').toString();
                final musteriTelTam = (proje?['musteriTelefon'] ?? proje?['musteriTel'] ?? proje?['telefon'] ?? '-').toString();
                final il = (proje?['konum']?['il'] ?? proje?['il'] ?? '').toString();
                final ilce = (proje?['konum']?['ilce'] ?? proje?['ilce'] ?? '').toString();
                final yapiTuruRaw = (proje?['yapiTuruId'] ?? 'YAPI').toString();
                final yapiTuru = yapiTuruRaw.replaceAll("_", " / ").replaceAll("TICARI", "TİCARİ");

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: isOnaylandi ? _gold.withOpacity(0.4) : Colors.black.withOpacity(0.08))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: isOnaylandi ? _gold : _black,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            Container(width: 14, height: 1, color: isOnaylandi ? _black : _gold),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isOnaylandi ? "${_ihtiyacDisplay(serviceId)} - ONAYLANDI / AKTİF" : "${_ihtiyacDisplay(serviceId)} için teklif bedeli",
                                style: TextStyle(color: isOnaylandi ? _black : Colors.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              color: isOnaylandi ? _black : _gold,
                              child: Text(isOnaylandi ? "AKTİF" : "BEKLEMEDE", style: TextStyle(fontSize: 7, color: isOnaylandi ? Colors.white : _black, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(width: 32, height: 32, decoration: BoxDecoration(color: _black, border: Border.all(color: _gold.withOpacity(0.3))), child: Icon(isOnaylandi ? Icons.check_circle : Icons.check, size: 16, color: _gold)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(isOnaylandi ? "ONAYLANAN TEKLİFİNİZ" : "TEKLİFİNİZ", style: const TextStyle(fontSize: 7, color: _gray, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                    const SizedBox(height: 2),
                                    Text("$teklifBedeli TL", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _black, letterSpacing: -0.5)),
                                    if (teklifNotu.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(teklifNotu, style: const TextStyle(fontSize: 10, color: _black, height: 1.3)),
                                    ],
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), color: _offWhite, child: Text("HUG Erişim Bedeli: $hugFee TL ödendi", style: const TextStyle(fontSize: 8, color: _gray))),
                            const SizedBox(height: 14),
                            Container(height: 1, color: Colors.black.withOpacity(0.06)),
                            const SizedBox(height: 12),
                            Row(children: [const SizedBox(width: 50, child: Text("YAPI", style: TextStyle(fontSize: 7, color: _gray, letterSpacing: 1))), Expanded(child: Text(yapiTuru, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _black)))]),
                            const SizedBox(height: 6),
                            Row(children: [const SizedBox(width: 50, child: Text("KONUM", style: TextStyle(fontSize: 7, color: _gray, letterSpacing: 1))), Expanded(child: Text("$il / $ilce".toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _black)))]),
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              color: _offWhite,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [Container(width: 16, height: 1, color: _gold), const SizedBox(width: 8), const Text("MÜŞTERİ İLETİŞİM - AÇIK", style: TextStyle(fontSize: 7, color: _black, fontWeight: FontWeight.bold, letterSpacing: 1.2))]),
                                  const SizedBox(height: 10),
                                  Row(children: [const Icon(Icons.person, size: 12, color: _gold), const SizedBox(width: 6), Expanded(child: Text(musteriAdiTam, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _black)))]),
                                  const SizedBox(height: 6),
                                  Row(children: [const Icon(Icons.phone, size: 12, color: _gold), const SizedBox(width: 6), Text(musteriTelTam, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _black))]),
                                ],
                              ),
                            ),
                            // SADECE ONAYLANDI TABINDA TAMAMLANDI BUTONU
                            if (isOnaylandi) ...[
                              const SizedBox(height: 14),
                              GestureDetector(
                                onTap: () => _projeTamamlandi(teklifDocId: teklifDocId, projeId: projeId, serviceId: serviceId, teklifBedeli: teklifBedeli, hugFee: hugFee, projeData: proje),
                                child: Container(
                                  width: double.infinity,
                                  color: _black,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(width: 14, height: 1, color: _gold),
                                      const SizedBox(width: 8),
                                      const Text("PROJE TAMAMLANDI VE TESLİM EDİLDİ", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _offWhite,
      appBar: AppBar(
        backgroundColor: _black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('TEKLİFLERİM', style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _gold,
          indicatorWeight: 2,
          labelColor: _gold,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'TEKLİFLERİM (BEKLEMEDE)'),
            Tab(text: 'ONAYLANANLAR / AKTİF'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListe('BEKLEMEDE'),
          _buildListe('ONAYLANDI'),
        ],
      ),
    );
  }
}