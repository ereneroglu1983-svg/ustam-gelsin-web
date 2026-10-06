// lib/web_dosyalari/usta_giris_ekrani.dart - FINAL WEB - POP FIX - LOCKED

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/main.dart';

class UstaGirisEkrani extends StatefulWidget {
  const UstaGirisEkrani({super.key});

  @override
  State<UstaGirisEkrani> createState() => _UstaGirisEkraniState();
}

class _UstaGirisEkraniState extends State<UstaGirisEkrani> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _beniHatirla = false;

  String _normalizeRole(String? role) {
    if (role == null) return 'musteri';
    final r = role.toLowerCase().trim();
    if (r == 'customer') return 'musteri';
    if (r == 'master') return 'usta';
    if (r == 'musteri' || r == 'usta' || r == 'admin') return r;
    return 'musteri';
  }

  @override
  void initState() {
    super.initState();
    _beniHatirlaBilgileriniYukle();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _beniHatirlaBilgileriniYukle() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _emailController.text = prefs.getString('usta_email') ?? "";
      _beniHatirla = prefs.getBool('usta_remember') ?? false;
    });
  }

  Future<void> _bilgileriKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    if (_beniHatirla) {
      await prefs.setString('usta_email', _emailController.text.trim());
      await prefs.setBool('usta_remember', true);
    } else {
      await prefs.remove('usta_email');
      await prefs.setBool('usta_remember', false);
    }
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("E-mail ve şifre alanları boş bırakılamaz.")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signIn(_emailController.text.trim(), _passwordController.text.trim());

      final profile = await _authService.getUserProfile(refresh: true);
      final String actualRole = _normalizeRole(profile?['role']);
      final bool isAdminUser = actualRole == 'admin';

      if (!mounted) return;

      // Yetki kontrolü - müşteri usta girişine giremez
      if (!isAdminUser && actualRole != 'usta') {
        await _authService.signOut();
        throw "YETKİSİZ ERİŞİM: Bu hesap bir ${actualRole.toUpperCase()} hesabıdır. Lütfen MÜŞTERİ GİRİŞİ'ni kullanın.";
      }

      await _bilgileriKaydet();

      if (!mounted) return;

      // KRİTİK FIX
      Navigator.of(context).pop();

      if (isAdminUser) {
        Future.microtask(() {
          if (navigatorKey.currentContext != null) {
            GoRouter.of(navigatorKey.currentContext!).go('/admin');
          }
        });
      }

    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red, duration: const Duration(seconds: 4)),
      );
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
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    const Text("Usta Girişi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(), // FIX
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildDarkTextField(_emailController, "E-Mail"),
                const SizedBox(height: 20),
                _buildDarkTextField(_passwordController, "Şifre", obscure: true),
                const SizedBox(height: 20),
                Material(
                  color: Colors.transparent,
                  child: CheckboxListTile(
                    title: const Text("Beni Hatırla", style: TextStyle(color: Colors.white70)),
                    value: _beniHatirla,
                    onChanged: (v) => setState(() => _beniHatirla = v!),
                    activeColor: const Color(0xFFDC143C),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC143C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("GİRİŞ YAP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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