// lib/features/usta/screens/usta_login.dart - FINAL APP - TEST EDİLDİ - LOCKED

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/theme/app_theme.dart';
import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/features/home/screens/home_screen.dart';
import 'package:ustam_gelsin/features/admin/screens/admin_dashboard.dart';

class UstaLoginPage extends StatefulWidget {
  final String targetRole;
  const UstaLoginPage({super.key, required this.targetRole});

  @override
  State<UstaLoginPage> createState() => _UstaLoginPageState();
}

class _UstaLoginPageState extends State<UstaLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _beniHatirla = false;

  String _normalizeRole(String? role) {
    if (role == null) return 'musteri';
    final r = role.toLowerCase().trim();
    if (r == 'customer') return 'musteri';
    if (r == 'musteri' || r == 'usta' || r == 'master' || r == 'admin') return r == 'master' ? 'usta' : r;
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
      final String target = _normalizeRole(widget.targetRole);
      final bool isAdminUser = actualRole == 'admin';

      if (!mounted) return;

      if (isAdminUser) {
        await _bilgileriKaydet();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
              (route) => false,
        );
      } else if (actualRole == target) {
        await _bilgileriKaydet();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
        );
      } else {
        await _authService.signOut();
        throw "YETKİSİZ ERİŞİM: Bu hesap bir ${actualRole.toUpperCase()} hesabıdır. Lütfen doğru giriş sayfasını kullanın.";
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Usta Girişi",
              style: AppTextStyles.buttonTitle.copyWith(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.white),
              decoration: AppDecorations.inputDecoration.copyWith(
                labelText: "E-Mail",
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              style: const TextStyle(color: Colors.white),
              decoration: AppDecorations.inputDecoration.copyWith(
                labelText: "Şifre",
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
              ),
              onSubmitted: (_) => _handleLogin(),
            ),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white70),
              child: CheckboxListTile(
                title: const Text("Beni Hatırla", style: TextStyle(color: Colors.white70, fontSize: 14)),
                value: _beniHatirla,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.ustaColor,
                onChanged: (bool? value) {
                  setState(() {
                    _beniHatirla = value ?? false;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
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
                child: const Text("Şifremi Unuttum", style: TextStyle(color: Colors.white70)),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ustaColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("GİRİŞ YAP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}