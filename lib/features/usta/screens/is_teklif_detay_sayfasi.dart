// lib/features/usta/screens/is_teklif_detay_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/core/theme/usta_theme.dart';

class IsTeklifDetaySayfasi extends StatefulWidget {
  final IlanModel ilan;

  const IsTeklifDetaySayfasi({super.key, required this.ilan});

  @override
  State<IsTeklifDetaySayfasi> createState() => _IsTeklifDetaySayfasiState();
}

class _IsTeklifDetaySayfasiState extends State<IsTeklifDetaySayfasi> {
  final TextEditingController _fiyatController = TextEditingController();
  final TextEditingController _mesajController = TextEditingController();
  final AdService _adService = AdService();
  final AuthService _authService = AuthService();

  String _formatDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('d MMMM yyyy', 'tr_TR').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} TL";
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  void dispose() {
    _fiyatController.dispose();
    _mesajController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const BackButton(color: UstaTheme.beyazMetin),
        title: const Text("İş Detayı"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<bool>(
              future: _adService.teklifVerildiMi(widget.ilan.id, user?.uid ?? ""),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final teklifVerildi = snapshot.data ?? false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: UstaTheme.kartArkaPlan,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 30,
                              backgroundColor: UstaTheme.anaTuruncu.withOpacity(0.1),
                              child: Text(
                                  teklifVerildi
                                      ? (widget.ilan.musteriAd.isNotEmpty ? widget.ilan.musteriAd[0].toUpperCase() : "?")
                                      : (widget.ilan.maskeliAd.isNotEmpty ? widget.ilan.maskeliAd[0].toUpperCase() : "?"),
                                  style: const TextStyle(fontSize: 22, color: UstaTheme.anaTuruncu, fontWeight: FontWeight.bold)
                              )
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                                teklifVerildi ? widget.ilan.musteriAd : widget.ilan.maskeliAd,
                                style: Theme.of(context).textTheme.titleLarge
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    _bilgiSatiri(Icons.handyman_outlined, widget.ilan.baslik, isHighlight: true),
                    _bilgiSatiri(Icons.calendar_today_outlined, _formatDate(widget.ilan.tarih)),
                    _bilgiSatiri(Icons.location_on_outlined, widget.ilan.konumMetin),

                    if (teklifVerildi) ...[
                      _bilgiSatiri(Icons.phone_android, widget.ilan.musteriTelefon.isEmpty ? "Telefon Belirtilmemiş" : widget.ilan.musteriTelefon),
                      _bilgiSatiri(Icons.map_outlined, widget.ilan.acikAdres.isEmpty ? "Açık Adres Belirtilmemiş" : widget.ilan.acikAdres),

                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.withOpacity(0.2))
                          ),
                          child: const Text(
                            "Bu işin iletişim bilgileri açılmıştır.",
                            style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ] else ...[
                      _bilgiSatiri(Icons.lock_outline, "İletişim bilgileri teklif sonrası açılır", isLocked: true),
                    ],

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(color: Colors.white12),
                    ),

                    Text("İŞ ÖZETİ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).primaryColor, letterSpacing: 1.2)),
                    const SizedBox(height: 12),
                    Text(widget.ilan.isTanimi,
                        style: const TextStyle(color: UstaTheme.beyazMetin, fontSize: 15, height: 1.6)),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            const Text("Teklif Ver",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: UstaTheme.beyazMetin)),
            const SizedBox(height: 15),
            TextField(
              controller: _fiyatController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _BinlikAyiriciFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: "Teklif Fiyatınız",
                hintText: "Örn: 15.000",
                suffixText: "TL",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _mesajController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Müşteriye kısa bir not iletin...",
              ),
            ),
            const SizedBox(height: 180),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(user),
    );
  }

  Widget _buildBottomBar(user) {
    return FutureBuilder<bool>(
        future: _adService.teklifVerildiMi(widget.ilan.id, user?.uid ?? ""),
        builder: (context, snapshot) {
          final teklifVerildi = snapshot.data ?? false;

          return Container(
            padding: EdgeInsets.fromLTRB(20, 15, 20, MediaQuery.of(context).padding.bottom + 15),
            decoration: BoxDecoration(
              color: UstaTheme.koyuArkaPlan,
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: teklifVerildi
                ? ElevatedButton.icon(
              onPressed: () => _makePhoneCall(widget.ilan.musteriTelefon),
              icon: const Icon(Icons.phone),
              label: const Text("Müşteriyi Ara"),
            )
                : ElevatedButton(
              onPressed: () async {
                if (_fiyatController.text.isNotEmpty && user != null) {
                  final temizFiyat = double.parse(_fiyatController.text.replaceAll('.', ''));

                  // REVİZE UYGULANDI: isMuaf parametresi eklendi.
                  bool basarili = await _adService.teklifVerVeBakiyeDus(
                    ilanId: widget.ilan.id,
                    ustaId: user.uid,
                    teklifFiyat: temizFiyat,
                    mesaj: _mesajController.text,
                    komisyonTutari: widget.ilan.komisyonTutari,
                    kategoriId: widget.ilan.kategoriId,
                    sehir: widget.ilan.konumMetin,
                    isMuaf: false,
                  );

                  if (basarili && context.mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Teklif başarıyla gönderildi!"), backgroundColor: UstaTheme.anaTuruncu),
                    );
                  }
                }
              },
              child: Text("Teklif Ver (${_formatPrice(widget.ilan.komisyonTutari)})"),
            ),
          );
        }
    );
  }

  Widget _bilgiSatiri(IconData icon, String text, {bool isLocked = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: [
          Icon(icon, size: 22, color: isLocked ? UstaTheme.anaTuruncu : (isHighlight ? UstaTheme.anaTuruncu : UstaTheme.griMetin)),
          const SizedBox(width: 15),
          Expanded(
              child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 15,
                      color: isLocked ? UstaTheme.anaTuruncu : UstaTheme.beyazMetin,
                      fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal
                  )
              )
          ),
        ],
      ),
    );
  }
}

class _BinlikAyiriciFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    String clean = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) return const TextEditingValue();
    final intValue = int.parse(clean);
    final formatted = NumberFormat("#,###", "tr_TR").format(intValue).replaceAll(',', '.');
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}