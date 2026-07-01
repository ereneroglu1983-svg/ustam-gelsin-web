// lib/features/usta/screens/usta_profil_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ustam_gelsin/core/services/auth_service.dart';
import 'package:ustam_gelsin/core/services/ad_service.dart';
import 'package:ustam_gelsin/core/services/wallet_service.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/profile_image_service.dart';
import 'package:ustam_gelsin/core/services/acil_is_yonetim_servisi.dart';
import 'package:ustam_gelsin/core/services/notification_service.dart';

import 'package:ustam_gelsin/features/usta/screens/yeni_is_firsatlari_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/acil_ilanlar.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_tekliflerim_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_ilan_detay_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/profil_bilgilerim.dart';
import 'package:ustam_gelsin/features/chat/screens/mesajlarim_sayfasi.dart';
import 'package:ustam_gelsin/features/usta/screens/usta_acil_is_detay_sayfasi.dart';

class UstaProfilSayfasi extends StatefulWidget {
  const UstaProfilSayfasi({super.key});

  @override
  State<UstaProfilSayfasi> createState() => _UstaProfilSayfasiState();
}

class _UstaProfilSayfasiState extends State<UstaProfilSayfasi> {
  final AuthService _authService = AuthService();
  final AdService _adService = AdService();
  final WalletService _walletService = WalletService();
  final ProfileImageService _imageService = ProfileImageService();
  final AcilIsYonetimServisi _acilServisi = AcilIsYonetimServisi();
  final NotificationService _notificationService = NotificationService();
  final TextEditingController _tutarController = TextEditingController();

  StreamSubscription? _cagriSubscription;

  @override
  void initState() {
    super.initState();
    _acilCagriDinle();
  }

  void _updateUstaBildirimBilgisi(String uid, dynamic uzmanlikData) {
    List<String> uzmanliklar = [];
    if (uzmanlikData is String) {
      uzmanliklar = [uzmanlikData];
    } else if (uzmanlikData is List) {
      uzmanliklar = List<String>.from(uzmanlikData);
    }

    if (uzmanliklar.isNotEmpty) {
      _notificationService.updateUserToken(uid, uzmanliklar);
    }
  }

  void _acilCagriDinle() {
    final user = _authService.currentUser;
    if (user == null) return;

    _cagriSubscription = FirebaseFirestore.instance
        .collection('acil_cagri')
        .where('ustaId', isEqualTo: user.uid)
        .where('durum', isEqualTo: 'bekliyor')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _alarmDialogGoster(snapshot.docs.first);
      }
    });
  }

  void _alarmDialogGoster(DocumentSnapshot doc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("🚨 ACİL İŞ ÇAĞRISI!"),
        content: const Text("Size acil bir iş talebi geldi, kabul etmek ister misiniz?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Reddet")
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _acilServisi.acilIsiKap(doc.id);
                if (!mounted) return;
                Navigator.pop(context);

                // İş kabul edildiği an detay sayfasına yönlendir
                Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaAcilIsDetaySayfasi()));
              } catch (e) {
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Hata oluştu: ${e.toString()}")),
                );
              }
            },
            child: const Text("KABUL ET"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cagriSubscription?.cancel();
    _tutarController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} TL";
  }

  void _resimGuncelle(String uid) async {
    File? secilenDosya = await _imageService.resimSec(ImageSource.gallery);
    if (secilenDosya != null) {
      String? downloadUrl = await _imageService.resimYukle(secilenDosya);
      if (downloadUrl != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({'photoUrl': downloadUrl});
      }
    }
  }

  void _show724InfoDialog(bool is724Active) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("7/24 Acil Servis"),
        content: const Text(
          "Online olduğunuzda konumunuz güncellenir ve yakın bölgenizdeki çağrılar size düşer. Lütfen konum izni verdiğinizden emin olun.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("KAPAT")),
          Switch(
            value: is724Active,
            activeColor: Colors.green,
            onChanged: (val) async {
              await _acilServisi.usta724DurumunuGuncelle(val);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(val ? "Artık acil işlere açıksınız!" : "Acil iş bildirimleri kapandı."),
                    backgroundColor: val ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text("Oturum bulunamadı.")));

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        title: const Text("USTA PANELİ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var userData = userSnapshot.data?.data() as Map<String, dynamic>?;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateUstaBildirimBilgisi(user.uid, userData?['uzmanliklar'] ?? userData?['uzmanlikAlani']);
          });

          String ad = userData?['firstName'] ?? "";
          String soyad = userData?['lastName'] ?? "";
          String ustaAdi = (ad.isNotEmpty || soyad.isNotEmpty)
              ? "$ad $soyad".trim()
              : (userData?['name'] ?? "İsimsiz Usta");

          String? photoUrl = userData?['photoUrl'];
          bool is724Active = userData?['is724Active'] ?? false;
          bool ustalikiBelgesiVar = userData?['ustalikBelgesiVarMi'] ?? false;

          double rating = (userData?['rating'] ?? 0.0).toDouble();
          int ratingCount = (userData?['ratingCount'] ?? 0).toInt();

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                _buildProfileCardWithWallet(user.uid, ustaAdi, photoUrl, rating, ratingCount, is724Active, ustalikiBelgesiVar),
                _buildUstaMesajBildirimHanesi(user.uid),
                _buildStatsRow(user.uid, rating),
                _buildIsDurumOzeti(user.uid),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // AKTİF İŞ KONTROLÜ VE BUTON
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('acil_cagri')
                            .where('secilenUstaId', isEqualTo: user.uid)
                            .where('durum', isEqualTo: 'atandi')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                            return GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaAcilIsDetaySayfasi())),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                width: double.infinity,
                                decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(12)),
                                child: const Center(child: Text("DEVAM EDEN ACİL İŞLERİM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      if (is724Active)
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AcilIlanlarSayfasi())),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                            child: const Center(child: Text("7/24 ACİL USTA İLANLARI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                          ),
                        ),

                      _menuItem(icon: Icons.explore_outlined, baslik: "Yeni İş Fırsatları", altBaslik: "Bölgendeki yeni ilanlara teklif ver", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const YeniIsFirsatlariSayfasi()))),
                      _menuItem(icon: Icons.assignment_turned_in_outlined, baslik: "Teklif ve İş Yönetimi", altBaslik: "Tekliflerini takip et, devam eden ve tamamlanan işlerini yönet", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UstaTekliflerimSayfasi()))),
                      _menuItem(icon: Icons.account_balance_wallet_outlined, baslik: "Cüzdanım", altBaslik: "Bakiye yükle ve işlem geçmişini gör", onTap: () => _cuzdanSayfasiniAc(context, user.uid)),
                      _menuItem(icon: Icons.manage_accounts_outlined, baslik: "Profil Bilgilerim", altBaslik: "Kişisel bilgilerini düzenle", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilBilgilerim()))),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildLogoutButton(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIsDurumOzeti(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('teklifler').where('ustaId', isEqualTo: uid).snapshots(),
      builder: (context, teklifSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tamamlanan_isler').where('ustaId', isEqualTo: uid).snapshots(),
          builder: (context, tamamlananSnapshot) {
            int bekleyen = 0;
            int devamEden = 0;
            int tamamlanan = 0;

            if (teklifSnapshot.hasData) {
              for (var doc in teklifSnapshot.data!.docs) {
                var data = doc.data() as Map<String, dynamic>;
                String durum = (data['durum'] ?? '').toString();
                if (durum == 'beklemede') {
                  bekleyen++;
                } else if (durum == 'onaylandi') {
                  devamEden++;
                }
              }
            }

            if (tamamlananSnapshot.hasData) {
              tamamlanan = tamamlananSnapshot.data!.docs.length;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaTekliflerimSayfasi())), child: _ozetCard("Bekleyen", "$bekleyen", Icons.access_time, Colors.orange))),
                  const SizedBox(width: 10),
                  Expanded(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaTekliflerimSayfasi())), child: _ozetCard("Devam Eden", "$devamEden", Icons.build, Colors.blue))),
                  const SizedBox(width: 10),
                  Expanded(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UstaTekliflerimSayfasi())), child: _ozetCard("Tamamlanan", "$tamamlanan", Icons.check_circle, Colors.green))),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _ozetCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _cuzdanSayfasiniAc(BuildContext context, String uid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('wallets').doc(uid).snapshots(),
          builder: (context, snapshot) {
            double bakiye = 0.0;
            if (snapshot.hasData && snapshot.data!.exists) {
              bakiye = (snapshot.data!.data() as Map<String, dynamic>)['balance']?.toDouble() ?? 0.0;
            }
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(color: Color(0xFFF8F9FA), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Cüzdanım", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                  _buildCuzdanKarti(bakiye),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Align(alignment: Alignment.centerLeft, child: Text("Son İşlemler", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  ),
                  Expanded(child: _buildIslemGecmisi(uid)),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: ElevatedButton(
                      onPressed: () => _sanalPosEkraniniAc(context, uid),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE30613), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 4),
                      child: const Text("BAKİYE YÜKLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _buildUstaMesajBildirimHanesi(String ustaId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chats').where('aliciId', isEqualTo: ustaId).where('okundu', isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox.shrink();
        var mesajData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
        String ilanId = mesajData['ilanId'];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue.shade200, width: 1.0)),
          child: ListTile(
            onTap: () async {
              var ilanDoc = await FirebaseFirestore.instance.collection('ilanlar').doc(ilanId).get();
              if (!ilanDoc.exists) ilanDoc = await FirebaseFirestore.instance.collection('ads').doc(ilanId).get();
              if (ilanDoc.exists && context.mounted) {
                IlanModel ilan = IlanModel.fromMap(ilanDoc.data()!, ilanDoc.id);
                Navigator.push(context, MaterialPageRoute(builder: (context) => UstaIlanDetaySayfasi(ilan: ilan)));
                for (var doc in snapshot.data!.docs) doc.reference.update({'okundu': true});
              }
            },
            leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.chat_bubble, color: Colors.white, size: 20)),
            title: const Text("YENİ MESAJ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
            subtitle: Text(mesajData['mesajMetni'] ?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right, color: Colors.blue),
          ),
        );
      },
    );
  }

  Widget _buildProfileCardWithWallet(String uid, String ad, String? photoUrl, double rating, int count, bool is724Active, bool ustalikiBelgesiVar) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('wallets').doc(uid).snapshots(),
        builder: (context, snapshot) {
          double bakiye = 0.0;
          if (snapshot.hasData && snapshot.data!.exists) {
            bakiye = (snapshot.data!.data() as Map<String, dynamic>)['balance']?.toDouble() ?? 0.0;
          }
          return _buildProfileCard(uid, ad, photoUrl, bakiye, rating, count, is724Active, ustalikiBelgesiVar);
        }
    );
  }

  Widget _buildProfileCard(String uid, String ad, String? photoUrl, double bakiye, double rating, int count, bool is724Active, bool ustalikiBelgesiVar) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _resimGuncelle(uid),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                      child: photoUrl == null ? const Icon(Icons.person, size: 40, color: Colors.grey) : null,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Color(0xFFE30613), size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              if (ustalikiBelgesiVar)
                Column(
                  children: [
                    const Icon(Icons.verified, color: Colors.green, size: 28),
                    const SizedBox(height: 4),
                    Text("BELGELİ", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                  ],
                ),

              GestureDetector(
                onTap: () => _show724InfoDialog(is724Active),
                child: Image.asset('assets/images/acil_logo.png', width: 80, height: 80),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(ad, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MesajlarimSayfasi())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFFE30613), borderRadius: BorderRadius.circular(10)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text("Müşteri Mesajları", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text("$rating ($count Değerlendirme)", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text("Bakiye", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text(_formatPrice(bakiye), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              Container(height: 30, width: 1, color: Colors.grey.shade300),
              Expanded(
                child: Column(
                  children: [
                    const Text("7/24 Durumu", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text(is724Active ? "ONLİNE" : "OFFLİNE", style: TextStyle(color: is724Active ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(String uid, double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _statCard("Başarı Oranı", "%98", Icons.trending_up, Colors.blue)),
          const SizedBox(width: 10),
          Expanded(child: _statCard("Puan", rating.toString(), Icons.star_border, Colors.orange)),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem({required IconData icon, required String baslik, required String altBaslik, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: const Color(0xFFE30613), size: 28),
        title: Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
        subtitle: Text(altBaslik, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton.icon(
        onPressed: () async {
          await _authService.signOut();
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          }
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text("Çıkış Yap", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }

  Widget _buildCuzdanKarti(double bakiye) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF203A43)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mevcut Bakiyeniz", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 10),
          Text(_formatPrice(bakiye), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildIslemGecmisi(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('wallets').doc(uid).collection('transactions').orderBy('date', descending: true).limit(10).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("Henüz bir işlem bulunmuyor.", style: TextStyle(color: Colors.grey)));
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            bool isPositive = data['type'] == 'deposit';
            return ListTile(
              leading: Icon(isPositive ? Icons.add_circle : Icons.remove_circle, color: isPositive ? Colors.green : Colors.red),
              title: Text(data['description'] ?? "İşlem"),
              subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format((data['date'] as Timestamp).toDate())),
              trailing: Text("${isPositive ? '+' : '-'}${data['amount']} TL", style: TextStyle(fontWeight: FontWeight.bold, color: isPositive ? Colors.green : Colors.red)),
            );
          },
        );
      },
    );
  }

  void _sanalPosEkraniniAc(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bakiye Yükle (Test)"),
        content: TextField(
          controller: _tutarController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Tutar (TL)"),
        ),
        actions: [
          TextButton(onPressed: () { _tutarController.clear(); Navigator.pop(context); }, child: const Text("İptal")),
          ElevatedButton(
            onPressed: () async {
              double miktar = double.tryParse(_tutarController.text) ?? 0;
              if (miktar > 0) {
                await _walletService.bakiyeYukle(uid, miktar, "Kredi Kartı Yükleme (Test)");
                if (context.mounted) { _tutarController.clear(); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bakiye başarıyla yüklendi!"))); }
              }
            },
            child: const Text("YÜKLE"),
          ),
        ],
      ),
    );
  }
}