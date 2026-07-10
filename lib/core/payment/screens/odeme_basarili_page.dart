import 'package:flutter/material.dart';

class OdemeBasariliPage extends StatefulWidget {
  const OdemeBasariliPage({super.key});

  @override
  State<OdemeBasariliPage> createState() => _OdemeBasariliPageState();
}

class _OdemeBasariliPageState extends State<OdemeBasariliPage> {
  String durum = "Ödeme kontrol ediliyor...";

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    final token = uri.queryParameters['token'];

    if (token != null) {
      setState(() => durum = "Token alındı: $token");
      // BİR SONRAKİ ADIMDA: Bu token'ı backend'e yollayacağız
    } else {
      setState(() => durum = "Token bulunamadı!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ödeme Sonucu")),
      body: Center(child: Text(durum, style: const TextStyle(fontSize: 20))),
    );
  }
}