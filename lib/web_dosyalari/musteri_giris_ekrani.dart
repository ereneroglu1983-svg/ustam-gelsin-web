import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';

class MusteriGirisEkrani extends StatefulWidget {
  const MusteriGirisEkrani({super.key});

  @override
  State<MusteriGirisEkrani> createState() => _MusteriGirisEkraniState();
}

class _MusteriGirisEkraniState extends State<MusteriGirisEkrani> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _yukleniyor = false;
  bool _beniHatirla = false;

  @override
  void initState() {
    super.initState();
    _beniHatirlaBilgileriniYukle();
  }

  Future<void> _beniHatirlaBilgileriniYukle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('musteri_email') ?? "";
      _passwordController.text = prefs.getString('musteri_password') ?? "";
      _beniHatirla = prefs.getBool('musteri_remember') ?? false;
    });
  }

  Future<void> _bilgileriKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    if (_beniHatirla) {
      await prefs.setString('musteri_email', _emailController.text.trim());
      await prefs.setString('musteri_password', _passwordController.text.trim());
      await prefs.setBool('musteri_remember', true);
    } else {
      await prefs.remove('musteri_email');
      await prefs.remove('musteri_password');
      await prefs.setBool('musteri_remember', false);
    }
  }

  Future<void> _sifremiUnuttum() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen önce e-posta adresinizi girin.")));
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şifre sıfırlama bağlantısı e-postanıza gönderildi.")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  Future<void> _girisYap() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("E-mail ve şifre alanları boş bırakılamaz.")));
      return;
    }

    setState(() => _yukleniyor = true);

    try {
      await _authService.signIn(_emailController.text.trim(), _passwordController.text.trim());
      await _bilgileriKaydet();

      bool isAdminUser = false;
      try {
        isAdminUser = await _authService.isAdmin();
      } catch (_) {
        isAdminUser = false;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAdminUser ? '✅ Admin girişi başarılı! Panele yönlendiriliyorsunuz...' : '✅ Giriş başarılı! Ana sayfaya yönlendiriliyorsunuz...'),
          backgroundColor: const Color(0xFF2DB34A),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;
      setState(() => _yukleniyor = false);

      if (isAdminUser) {
        context.go('/admin');
      } else {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _yukleniyor = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildDarkTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white24)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDC143C))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    const Text("Müşteri Girişi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => context.go('/home'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _buildDarkTextField(_emailController, "E-Mail"),
                const SizedBox(height: 20),
                _buildDarkTextField(_passwordController, "Şifre", obscure: true),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: _beniHatirla, onChanged: (v) => setState(() => _beniHatirla = v!), activeColor: const Color(0xFFDC143C), checkColor: Colors.white),
                        const Text("Beni Hatırla", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    TextButton(onPressed: _sifremiUnuttum, child: const Text("Şifremi Unuttum", style: TextStyle(color: Colors.orange))),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _yukleniyor ? null : _girisYap,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: _yukleniyor ? const CircularProgressIndicator(color: Colors.white) : const Text("GİRİŞ YAP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}