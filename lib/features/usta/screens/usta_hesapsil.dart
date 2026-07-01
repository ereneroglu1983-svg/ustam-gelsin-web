import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UstaHesapSil extends StatelessWidget {
  const UstaHesapSil({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _uyariGoster(context),
      icon: const Icon(Icons.delete_forever, color: Colors.red),
      label: const Text("HESABIMI KALICI OLARAK SİL", style: TextStyle(color: Colors.red)),
    );
  }

  void _uyariGoster(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Uyarı"),
        content: const Text(
            "BU İŞLEMİN SONUNDA SİSTEMİMİZDE BULUNAN TÜM KİŞİSEL BİLGİLERİNİZ (TC KİMLİK NO, ADRES BİLGİLERİNİZ, TELEFON NUMARALARINIZ, MESLEK BİLGİLERİNİZ VB.) KALICI OLARAK SİLİNECEKTİR."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("HAYIR DEVAM ETMEK İSTEMİYORUM")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sifreDogrula(context);
            },
            child: const Text("EVET DEVAM ETMEK İSTİYORUM"),
          ),
        ],
      ),
    );
  }

  void _sifreDogrula(BuildContext context) {
    final TextEditingController sifreController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("LÜTFEN ŞİFRENİZİ GİRİNİZ"),
        content: TextField(controller: sifreController, obscureText: true, decoration: const InputDecoration(border: OutlineInputBorder())),
        actions: [
          ElevatedButton(
            onPressed: () => _hesabiKalicisil(context, sifreController.text),
            child: const Text("HESABIMI SİL"),
          ),
        ],
      ),
    );
  }

  Future<void> _hesabiKalicisil(BuildContext context, String sifre) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Şifre ile yeniden kimlik doğrulama
      AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: sifre);
      await user.reauthenticateWithCredential(credential);

      // Firestore verilerini sil
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

      // Auth hesabını sil
      await user.delete();

      // Silme sonrası çıkış
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: Şifreniz yanlış veya işlem başarısız!")));
    }
  }
}