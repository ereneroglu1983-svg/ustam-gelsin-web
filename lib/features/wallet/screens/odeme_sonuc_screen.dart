// lib/features/wallet/screens/odeme_sonuc_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_profil_sayfasi.dart';

class OdemeSonucScreen extends StatefulWidget {
  final bool isSuccess;
  final String message;
  const OdemeSonucScreen({super.key, required this.isSuccess, this.message = ''});

  @override
  State<OdemeSonucScreen> createState() => _OdemeSonucScreenState();
}

class _OdemeSonucScreenState extends State<OdemeSonucScreen> {
  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        if (mounted) {
          // SENİN PROFİL SAYFANA DÖN - STACK TEMİZ
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const UstaProfilSayfasi()),
                (route) => false,
          );
        }
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: widget.isSuccess ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isSuccess ? Icons.check_rounded : Icons.close_rounded,
                  size: 80,
                  color: widget.isSuccess ? Colors.green.shade600 : Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                widget.isSuccess ? "ÖDEME BAŞARILI" : "ÖDEME BAŞARISIZ",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: widget.isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.isSuccess
                    ? "Bakiyeniz güncellendi.\n${widget.message}"
                    : "Ödeme tamamlanamadı.\n${widget.message}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 40),
              Text(
                "$_countdown saniye sonra profile dönülüyor...",
                style: const TextStyle(fontSize: 13, color: Colors.black38),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: (3 - _countdown + 1) / 3,
                  backgroundColor: Colors.grey.shade200,
                  color: widget.isSuccess ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}