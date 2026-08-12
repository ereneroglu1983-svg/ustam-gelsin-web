// lib/features/usta/screens/usta_profil_sayfasi.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

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
import 'package:ustam_gelsin/features/usta/screens/usta_cuzdanim.dart';

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
    super.dispose();
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###", "tr_TR");
    return "${formatter.format(price).replaceAll(',', '.')} TL";
  }

  void _resimGuncelle(String uid) async {
    File? secilenDosya = await _imageService.resimSec(ImageSource.gallery);
    if (secilenDosya!= null) {
      String? downloadUrl = await _imageService.resimYukle(secilenDosya);
      if (downloadUrl!= null) {
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
                    content: Text(val? "Artık acil işlere açıksınız!" : "Acil iş bildirimleri kapandı."),
                    backgroundColor: val? Colors.green : Colors.red,
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
            _updateUstaBildirimBilgisi(user.uid, userData?['uzmanliklar']?? userData?['uzmanlikAlani']);
          });

          String ad = userData?['firstName']?? "";
          String soyad = userData?['lastName']?? "";
          String ustaAdi = (ad.isNotEmpty || soyad.isNotEmpty)
              ? "$ad $soyad".trim()
              : (userData?['name']?? "İsimsiz Usta");

          String? photoUrl = userData?['photoUrl'];
          bool is724Active = userData?['is724Active']?? false;
          bool ustalikiBelgesiVar = userData?['ustalikBelgesiVarMi']?? false;

          double rating = (userData?['rating']?? 0.0).toDouble();
          int ratingCount = (userData?['ratingCount']?? 0).toInt();

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
                String durum = (data['durum']?? '').toString();
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UstaCuzdanim(uid: uid),
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
            subtitle: Text(mesajData['mesajMetni']?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
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
            bakiye = (snapshot.data!.data() as Map<String, dynamic>)['balance']?.toDouble()?? 0.0;
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
                      backgroundImage: photoUrl!= null? NetworkImage(photoUrl) : null,
                      child: photoUrl == null? const Icon(Icons.person, size: 40, color: Colors.grey) : null,
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
                    Text(is724Active? "ONLİNE" : "OFFLİNE", style: TextStyle(color: is724Active? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
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

  // === SADECE BURASI DÜZELTİLDİ - BAŞKA HİÇBİR YERE DOKUNULMADI ===
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () async {
            final onay = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text("Çıkış Yap"),
                content: const Text("Hesabınızdan çıkmak istediğinize emin misiniz?"),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("İptal")),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text("Çıkış Yap"),
                  ),
                ],
              ),
            );
            if (onay!= true) return;

            try {
              await _cagriSubscription?.cancel();
              _cagriSubscription = null;

              await _authService.signOut();
              await FirebaseAuth.instance.signOut();

              if (!mounted) return;
              GoRouter.of(context).go('/home');

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("✅ Başarıyla çıkış yapıldı"),
                  backgroundColor: Color(0xFF2DB34A),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Çıkış hatası: $e"), backgroundColor: Colors.red),
              );
            }
          },
          icon: const Icon(Icons.logout_rounded, color: Colors.red),
          label: const Text("Çıkış Yap", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFFFCDD2)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}