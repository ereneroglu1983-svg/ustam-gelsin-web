// lib/features/musteri/screens/musteri_login.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
// GÜVENLİK PROTOKOLÜ MADDE 3: Dosya yolları iskelet yapısına (Screenshots) göre güncellendi
import 'package:ustam_gelsin/core/theme/app_theme.dart';
import 'package:ustam_gelsin/features/musteri/screens/musteri_profil_sayfasi.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/features/admin/screens/admin_dashboard.dart';

class MusteriLoginPage extends StatefulWidget {
  final String targetRole;

  const MusteriLoginPage({super.key, required this.targetRole});

  @override
  State<MusteriLoginPage> createState() => _MusteriLoginPageState();
}

class _MusteriLoginPageState extends State<MusteriLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _hataMesaji;
  bool _yukleniyor = false;
  bool _isError = false;
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

  Future<void> _girisYap() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      setState(() {
        _hataMesaji = "E-mail ve şifre alanları boş bırakılamaz.";
        _isError = true;
      });
      return;
    }

    setState(() {
      _yukleniyor = true;
      _hataMesaji = null;
      _isError = false;
    });

    try {
      await _authService.signIn(_emailController.text.trim(), _passwordController.text.trim());

      bool yetkiliMi = await _authService.isAdmin();
      String? actualRole = await _authService.getUserRole();

      if (!mounted) return;

      if (yetkiliMi) {
        await _bilgileriKaydet();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else if (actualRole == widget.targetRole) {
        await _bilgileriKaydet();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MusteriProfilSayfasi()),
        );
      } else {
        await _authService.signOut();
        throw "YETKİSİZ ERİŞİM: Bu hesap bir ${actualRole?.toUpperCase()} hesabıdır. Lütfen doğru giriş sayfasını kullanın.";
      }
    } catch (e) {
      setState(() {
        _hataMesaji = e.toString();
        _isError = true;
      });
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isError
                ? [Colors.red.shade900, Colors.black]
                : [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientMid,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "Müşteri Girişi",
                  style: AppTextStyles.buttonTitle.copyWith(
                    fontSize: 28,
                    letterSpacing: 1.2,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 50),
                if (_hataMesaji != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _hataMesaji!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8),
                      child: Text("E-Mail",
                          style:
                          TextStyle(color: AppColors.white70, fontSize: 14)),
                    ),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: AppColors.white),
                      decoration: AppDecorations.inputDecoration.copyWith(
                        hintText: "E-mail adresinizi giriniz",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8),
                      child: Text("Şifre",
                          style:
                          TextStyle(color: AppColors.white70, fontSize: 14)),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: AppColors.white),
                      decoration: AppDecorations.inputDecoration.copyWith(
                        hintText: "Şifrenizi giriniz",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Theme(
                        data: ThemeData(unselectedWidgetColor: AppColors.white70),
                        child: CheckboxListTile(
                          title: const Text(
                            "Beni Hatırla",
                            style: TextStyle(color: AppColors.white70, fontSize: 14),
                          ),
                          value: _beniHatirla,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColors.white,
                          checkColor: const Color(0xFF2D4B2A),
                          onChanged: (bool? value) {
                            setState(() {
                              _beniHatirla = value ?? false;
                            });
                          },
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_emailController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen önce E-Mail adresinizi yazın.")));
                          return;
                        }
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şifre sıfırlama bağlantısı gönderildi.")));
                        } catch (e) {
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
                        }
                      },
                      child: const Text("Şifremi Unuttum", style: TextStyle(color: AppColors.white70)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _yukleniyor ? null : _girisYap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5E9),
                      foregroundColor: const Color(0xFF2D4B2A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 4,
                    ),
                    child: _yukleniyor
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF2D4B2A))),
                    )
                        : const Text("GİRİŞ YAP",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1)),
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