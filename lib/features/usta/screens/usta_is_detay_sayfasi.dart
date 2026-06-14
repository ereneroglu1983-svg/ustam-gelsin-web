// lib/features/usta/screens/usta_is_detay_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UstaIsDetaySayfasi extends StatefulWidget {
  final IlanModel ilan;
  const UstaIsDetaySayfasi({super.key, required this.ilan});

  @override
  State<UstaIsDetaySayfasi> createState() => _UstaIsDetaySayfasiState();
}

class _UstaIsDetaySayfasiState extends State<UstaIsDetaySayfasi> {
  final TextEditingController _fiyatController = TextEditingController();
  final TextEditingController _notController = TextEditingController();
  final AdService _adService = AdService();
  bool _yukleniyor = false;
  bool _teklifVerildi = false;
  double _hesaplananKomisyon = 0.0;

  @override
  void initState() {
    super.initState();
    _teklifKontrolEt();
    _fiyatController.addListener(_formatCurrency);
  }

  void _formatCurrency() {
    String text = _fiyatController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) return;
    final value = double.tryParse(text) ?? 0.0;

    // Formatlama ve Komisyon Hesabı
    final formatter = NumberFormat("#,###", "tr_TR");
    String formatted = formatter.format(value).replaceAll(',', '.');

    _fiyatController.removeListener(_formatCurrency);
    _fiyatController.text = formatted;
    _fiyatController.selection = TextSelection.fromPosition(TextPosition(offset: formatted.length));
    _fiyatController.addListener(_formatCurrency);

    setState(() {
      _hesaplananKomisyon = value * 0.01;
    });
  }

  Future<void> _teklifKontrolEt() async {
    final ustaId = FirebaseAuth.instance.currentUser?.uid;
    if (ustaId != null) {
      bool kontrol = await _adService.teklifVerildiMi(widget.ilan.id, ustaId);
      if (mounted) setState(() => _teklifVerildi = kontrol);
    }
  }

  @override
  void dispose() {
    _fiyatController.dispose();
    _notController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (e) {
      debugPrint("Arama hatası: $e");
    }
  }

  Future<void> _isDurumunuGuncelle(String yeniDurum) async {
    setState(() => _yukleniyor = true);
    try {
      await FirebaseFirestore.instance
          .collection('ads')
          .doc(widget.ilan.id)
          .update({'durum': yeniDurum});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("İş durumu güncellendi.")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  Future<void> _handleTeklifVer(String ustaId) async {
    String temizFiyat = _fiyatController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(temizFiyat);

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen geçerli bir teklif fiyatı giriniz!"), backgroundColor: Colors.orange));
      return;
    }

    setState(() => _yukleniyor = true);
    try {
      bool basarili = await _adService.teklifVerVeBakiyeDus(
        ilanId: widget.ilan.id,
        ustaId: ustaId,
        teklifFiyat: price,
        mesaj: _notController.text, // Ustanın notu
        komisyonTutari: _hesaplananKomisyon,
      );
      if (mounted) {
        if (basarili) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teklifiniz başarıyla gönderildi!")));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bakiye yetersiz!"), backgroundColor: Colors.red));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String ustaId = FirebaseAuth.instance.currentUser?.uid ?? "";
    bool isDevamEdenIs = widget.ilan.durum == 'onaylandi' || widget.ilan.durum == 'approved';
    bool isBitti = widget.ilan.durum == 'tamamlandi' || widget.ilan.durum == 'completed';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(isDevamEdenIs ? "İş Yönetimi" : "İlan Detayı",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCustomerHeader(isDevamEdenIs),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.category_outlined, "Kategori", widget.ilan.kategori),
                        const Divider(height: 20),
                        _buildDetailRow(Icons.event_note_outlined, "Tarih", widget.ilan.tarih),
                        const Divider(height: 20),
                        _buildDetailRow(Icons.location_on_outlined, "Konum", widget.ilan.konumMetin),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(" İş Tanımı", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
                    child: Text(widget.ilan.detaylar.isEmpty ? widget.ilan.isTanimi : widget.ilan.detaylar, style: TextStyle(color: Colors.grey[800], fontSize: 15, height: 1.5)),
                  ),
                  const SizedBox(height: 30),
                  if (isDevamEdenIs)
                    _buildUstaYonetimPaneli()
                  else if (isBitti)
                    _buildTamamlandiBilgisi()
                  else if (_teklifVerildi)
                      const Center(child: Text("Bu ilana teklif verdiniz.", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)))
                    else
                      _buildTeklifVermeFormu(ustaId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerHeader(bool isApproved) {
    String gosterilecekAd = isApproved ? widget.ilan.musteriAd : widget.ilan.maskeliAd;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 35, backgroundColor: Colors.grey.shade100, child: Text(gosterilecekAd[0].toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          const SizedBox(height: 12),
          Text(gosterilecekAd, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTeklifVermeFormu(String ustaId) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Teklif Ver", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
              controller: _fiyatController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: "Teklif Tutarı (TL)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.payments_outlined))
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: "Müşteriye Notunuz (Opsiyonel)", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _yukleniyor ? null : () => _handleTeklifVer(ustaId),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: _yukleniyor ? const CircularProgressIndicator(color: Colors.white) : const Text("TEKLİFİ GÖNDER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUstaYonetimPaneli() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _yukleniyor ? null : () async {
          setState(() => _yukleniyor = true);
          try {
            await FirebaseFirestore.instance.collection('ads').doc(widget.ilan.id).update({'durum': 'tamamlandi'});
            await FirebaseFirestore.instance.collection('jobs').add({
              'ilanId': widget.ilan.id,
              'musteriId': widget.ilan.userId,
              'ustaId': FirebaseAuth.instance.currentUser?.uid,
              'title': widget.ilan.baslik,
              'status': 'tamamlandi',
              'timestamp': FieldValue.serverTimestamp(),
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("İş başarıyla tamamlandı!")));
              Navigator.pop(context);
            }
          } catch (e) {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red));
          } finally {
            if (mounted) setState(() => _yukleniyor = false);
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: _yukleniyor ? const CircularProgressIndicator(color: Colors.white) : const Text("İŞİ TAMAMLA VE TESLİM ET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTamamlandiBilgisi() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Bu iş tamamlanmıştır.", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) => Row(children: [Icon(icon), SizedBox(width: 10), Text("$label: $value")]);
}