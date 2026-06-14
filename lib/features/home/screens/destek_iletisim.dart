// lib/features/home/screens/destek_iletisim.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DestekIletisimPage extends StatefulWidget {
  const DestekIletisimPage({super.key});

  @override
  State<DestekIletisimPage> createState() => _DestekIletisimPageState();
}

class _DestekIletisimPageState extends State<DestekIletisimPage> {
  final TextEditingController _msgController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendMessage() async {
    if (_msgController.text.isEmpty) return;

    setState(() => _isSending = true);
    try {
      // Mesajı Firestore'a eklerken bildirim tetikleyici alanı da ekliyoruz
      await FirebaseFirestore.instance.collection('admin_messages').add({
        'msg': _msgController.text,
        'time': DateTime.now(),
        'status': 'yeni',
        'isNotificationNeeded': true, // Admin uygulamasının bildirim göstermesi için tetikleyici
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mesajınız iletildi, teşekkürler!")),
        );
        _msgController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bir hata oluştu, lütfen tekrar deneyin.")),
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Destek & İletişim", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset('assets/images/destek_iletisim.png', height: 180, fit: BoxFit.contain),
            const SizedBox(height: 20),
            Text("DESTEK & İLETİŞİM", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text(
              "HEMEN USTAM GELSİN olarak kullanıcı deneyimini sürekli geliştirmeye çalışıyoruz.\n\n"
                  "Bu alan;\n- uygulama içerisinde karşılaştığınız teknik sorunları,\n"
                  "- sistemsel aksaklıkları,\n- hata bildirimlerini,\n- öneri ve geri bildirimlerinizi\n"
                  "bizlere iletebilmeniz amacıyla oluşturulmuştur.\n\n"
                  "Destek taleplerinizi uygulama içerisindeki mesaj alanı üzerinden veya aşağıdaki e-posta adresi aracılığıyla bize iletebilirsiniz.\n\n"
                  "Gönderdiğiniz bildirimler ilgili ekip tarafından incelenerek değerlendirmeye alınacaktır.\n"
                  "Bu iletişim alanı anlık canlı destek hizmeti sunmamakta olup; teknik inceleme ve sistem geliştirme süreçleri için kullanılmaktadır.",
              style: TextStyle(height: 1.5, fontSize: 14),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _msgController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Mesajınızı buraya yazın...",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendMessage,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                child: _isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("GÖNDER"),
              ),
            ),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, color: Colors.blueAccent),
                SizedBox(width: 10),
                Text("hemenustamgelsin@gmail.com", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}