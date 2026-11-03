// lib/features/hug_pro/profil/pro_profil_karti.dart
// PRO PROFIL KARTI - PROFIL KARTI, ILAN KARTI DEGIL - FIREBASE CANLI PUAN + TAMAMLANAN
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

const Color _black = Color(0xFF0B0B0B);
const Color _dark = Color(0xFF111111);
const Color _offWhite = Color(0xFFF7F5F0);
const Color _gold = Color(0xFFC8A45D);
const Color _gray = Color(0xFF8E8E8E);

class ProProfilKarti extends StatelessWidget {
  final Map<String, dynamic> proData;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onSelectChanged;

  const ProProfilKarti({
    super.key,
    required this.proData,
    this.isSelected = false,
    this.onTap,
    this.onSelectChanged,
  });

  // SAHIS: Isim acik soyisim perdeli - Eren E....
  String _maskSahis(String? ad, String? soyad) {
    if (ad == null || ad.trim().isEmpty) return "Müşteri";
    final a = ad.trim();
    if (soyad == null || soyad.trim().isEmpty) return a;
    final s = soyad.trim();
    return "$a ${s[0].toUpperCase()}....";
  }

  // SIRKET: Ilk 3 harf acik gerisi perdeli - LIN....
  String _maskSirket(String? sirketAdi) {
    if (sirketAdi == null || sirketAdi.trim().isEmpty) return "Şirket";
    final clean = sirketAdi.trim().toUpperCase();
    if (clean.length <= 3) return clean;
    return "${clean.substring(0, 3)}....";
  }

  String _meslekDisplay(dynamic meslekler) {
    // meslekler: List<Map> [{anaDalId: MIMARLIK, altDalId: MIMARI_PROJE}]
    // Okunakli meslek mutlaka
    const anaMap = {
      "MIMARLIK": "MİMAR",
      "IC_MIMARLIK": "İÇ MİMAR",
      "PEYZAJ_MIMARLIGI": "PEYZAJ MİMARI",
      "INSAAT_MUHENDISLIGI": "İNŞAAT MÜHENDİSİ",
      "ELEKTRIK_MUHENDISLIGI": "ELEKTRİK MÜHENDİSİ",
      "MAKINE_MUHENDISLIGI": "MAKİNE MÜHENDİSİ",
      "HARITA_MUHENDISLIGI": "HARİTA MÜHENDİSİ",
      "DIGER": "PROFESYONEL",
    };
    const altMap = {
      "MIMARI_PROJE": "Mimari Proje",
      "STATIK_PROJE": "Statik Proje",
      "MEKANIK_PROJE": "Mekanik Proje",
      "ELEKTRIK_PROJE": "Elektrik Projesi",
      "PEYZAJ_PROJE": "Peyzaj Projesi",
      "IC_MIMARI": "İç Mimari",
      "3D_GORSELLESTIRME": "3D Görselleştirme",
      "ZEMIN_ETUDU": "Zemin Etüdü",
    };

    if (meslekler == null) return "PROFESYONEL";
    if (meslekler is List && meslekler.isNotEmpty) {
      final first = meslekler.first;
      if (first is Map) {
        final ana = (first['anaDalId'] ?? first['anaDal'] ?? '').toString();
        final alt = (first['altDalId'] ?? first['altDal'] ?? first['serviceId'] ?? '').toString();
        final anaLabel = anaMap[ana] ?? ana.replaceAll("_", " ");
        final altLabel = altMap[alt] ?? alt.replaceAll("_", " ").toLowerCase();
        if (alt.isNotEmpty) return "$anaLabel / $altLabel";
        return anaLabel;
      }
    }
    return "PROFESYONEL";
  }

  @override
  Widget build(BuildContext context) {
    final hesapTuru = (proData['hesapTuru'] ?? 'SAHIS').toString(); // SAHIS veya SIRKET
    final ad = proData['ad']?.toString();
    final soyad = proData['soyad']?.toString();
    final sirketAdi = proData['sirketAdi']?.toString() ?? proData['firmaAdi']?.toString();
    final profilFotoUrl = proData['profilFotoUrl']?.toString() ?? proData['fotoUrl']?.toString();
    final konum = proData['konum'] as Map<String, dynamic>?;
    final il = (konum?['il'] ?? proData['il'] ?? '').toString();
    final ilce = (konum?['ilce'] ?? proData['ilce'] ?? '').toString();
    final meslekler = proData['meslekler'] ?? proData['uzmanliklar'];

    // FIREBASE CANLI VERILER - MANUEL GIRME YOK - MUSTERI PUAN VERDIKCE ARTAR AZALIR
    // users_pro/{uid} -> tamamlananProjeSayisi, ortalamaPuan, degerlendirmeSayisi
    // hug_pro_degerlendirmeler collection'dan hesaplanir, ortalamaPuan = toplamPuan / degerlendirmeSayisi
    final tamamlanan = (proData['tamamlananProjeSayisi'] ?? 0) as int;
    final ortalamaPuan = (proData['ortalamaPuan'] ?? proData['puan'] ?? 0.0) is int ? (proData['ortalamaPuan'] ?? 0).toDouble() : (proData['ortalamaPuan'] ?? proData['puan'] ?? 0.0) as double;
    final degerlendirmeSayisi = (proData['degerlendirmeSayisi'] ?? 0) as int;

    final displayName = hesapTuru == 'SIRKET' ? _maskSirket(sirketAdi) : _maskSahis(ad, soyad);
    final meslekLabel = _meslekDisplay(meslekler);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? _gold.withOpacity(0.6) : Colors.black.withOpacity(0.08), width: isSelected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER - SIYAH + GOLD CIZGI - DETAY KARTI ILE AYNI DNA AMA PROFIL KARTI
            Container(
              width: double.infinity,
              color: _black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(width: 14, height: 1, color: _gold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      meslekLabel.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600, letterSpacing: 1.2),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      color: _gold,
                      child: const Text("SEÇİLDİ", style: TextStyle(fontSize: 7, color: _black, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                ],
              ),
            ),

            // ICERIK
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PROFIL FOTOSU - VARSA VAR YOKSA BOS
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: _offWhite,
                      border: Border.all(color: Colors.black.withOpacity(0.08)),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: profilFotoUrl != null && profilFotoUrl.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: profilFotoUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: _offWhite, child: const Icon(Icons.person, size: 28, color: _gray)),
                        errorWidget: (_, __, ___) => Container(color: _offWhite, child: const Icon(Icons.person, size: 28, color: _gray)),
                      )
                          : Container(color: _offWhite, child: const Icon(Icons.person_outline, size: 28, color: _gray)),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ISIM + MESLEK + KONUM
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ISIM - SAHIS ISE ISIM + SOYISIM PERDELI, SIRKET ISE ILK 3 HARF
                        Text(
                          displayName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _black, letterSpacing: 0.2),
                        ),
                        const SizedBox(height: 4),

                        // MESLEK - MUTLAKA OKUNAKLI
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: _offWhite, border: Border.all(color: Colors.black.withOpacity(0.06))),
                          child: Text(
                            meslekLabel,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _black, letterSpacing: 0.3),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // KONUM - TABIKI OLSUN
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 11, color: _gold),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "$il / $ilce".toUpperCase(),
                                style: const TextStyle(fontSize: 8, color: _gray, letterSpacing: 0.8, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // SECIM CHECKBOX - KART GIBI
                  GestureDetector(
                    onTap: onSelectChanged,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSelected ? _gold : Colors.white,
                        border: Border.all(color: isSelected ? _gold : Colors.black.withOpacity(0.15)),
                      ),
                      child: Icon(Icons.check, size: 16, color: isSelected ? _black : Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 1, color: Colors.black.withOpacity(0.06)),

            // ALT - PUAN + TAMAMLANAN - FIREBASE CANLI - MANUEL YOK
            Container(
              width: double.infinity,
              color: _offWhite,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("PUAN", style: TextStyle(fontSize: 7, color: _gray, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 12, color: _gold),
                            const SizedBox(width: 4),
                            Text(
                              ortalamaPuan > 0 ? ortalamaPuan.toStringAsFixed(1) : "-",
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _black),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "($degerlendirmeSayisi)",
                              style: const TextStyle(fontSize: 8, color: _gray),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 24, color: Colors.black.withOpacity(0.08)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("TAMAMLANAN İŞ", style: TextStyle(fontSize: 7, color: _gray, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 2),
                        Text(
                          "$tamamlanan",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: _gold.withOpacity(0.4))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 10, color: _gold),
                        const SizedBox(width: 4),
                        const Text("KÜNYE", style: TextStyle(color: _black, fontSize: 7, letterSpacing: 1, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}