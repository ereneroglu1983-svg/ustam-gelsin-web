import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ustam_gelsin/core/models/ilan_model.dart';
import 'package:ustam_gelsin/core/services/wallet_service.dart';
import 'package:ustam_gelsin/core/services/notification_service.dart';
import 'package:ustam_gelsin/core/services/sosyal_medya.dart';
import 'package:ustam_gelsin/core/services/analytics_service.dart';

class AdService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WalletService _walletService = WalletService();
  final NotificationService _notificationService = NotificationService();
  final AnalyticsService _analyticsService = AnalyticsService();
  final String _collectionName = "ilanlar";

  // --- BAKİYE İŞLEMLERİ ---
  Future<void> addBalance(String uid, double amount) async {
    try {
      await _walletService.bakiyeYukle(uid, amount, "Manuel Bakiye Yükleme");
    } catch (e) {
      throw Exception("Bakiye yüklenemedi: $e");
    }
  }

  // --- İLAN YÖNETİMİ ---
  Future<void> ilanOlustur(IlanModel ilan) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Kullanıcı giriş yapmadı");

      DocumentReference docRef = _firestore.collection(_collectionName).doc();

      Map<String, dynamic> ilanVerisi = ilan.toMap();
      ilanVerisi['id'] = docRef.id;

      if (ilan.ilanCode.isEmpty) {
        ilanVerisi['ilanCode'] = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
      }

      await docRef.set(ilanVerisi);

      // --- ANALYTICS REVİZE: Şehir parametresi kaldırıldı, GENEL kayıt tetiklendi ---
      await _analyticsService.logIlanOlusturuldu(ilan.kategori);

      await SosyalMedyaMotoru.facebookPaylas(
          ilan.baslik,
          ilan.konumMetin,
          ilan.kategori,
          ilan.teknikDetaylar,
          ""
      );
    } catch (e) {
      throw Exception("İlan kaydedilemedi: $e");
    }
  }

  Future<void> ilanDurumGuncelle(String ilanId, String yeniDurum) async {
    try {
      bool odendiMi = (yeniDurum == "komisyon_odendi");
      await _firestore.collection(_collectionName).doc(ilanId).update({
        'durum': odendiMi ? 'aktif' : yeniDurum,
        'komisyonOdendiMi': odendiMi,
        'guncellenmeTarihi': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Durum güncellenemedi: $e");
    }
  }

  // --- MÜŞTERİ & USTA STREAMLERİ ---
  Stream<List<IlanModel>> aktifIlanlariGetir(String userId) {
    return _firestore.collection(_collectionName).where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final ilan = IlanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        _zamanAsimiKontrolEt(ilan);
        return ilan;
      }).toList();
    });
  }

  Stream<List<IlanModel>> devamEdenIsleriGetir(String userId) {
    return _firestore.collection(_collectionName).where('userId', isEqualTo: userId).where('durum', isEqualTo: 'is_verildi').snapshots().map((snapshot) => snapshot.docs.map((doc) => IlanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Stream<List<IlanModel>> ustaDevamEdenIsleriGetir(String ustaId) {
    return _firestore.collection(_collectionName)
        .where('atananUstaId', isEqualTo: ustaId)
        .where('durum', isEqualTo: 'is_verildi')
        .snapshots().map((snapshot) => snapshot.docs.map((doc) => IlanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Stream<List<IlanModel>> arsivlenmisIsleriGetir(String userId) {
    return _firestore.collection(_collectionName).where('userId', isEqualTo: userId).snapshots().map((snapshot) => snapshot.docs.map((doc) => IlanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).where((ilan) => ilan.durum == 'zaman_asimi' || ilan.durum == 'tamamlandi').toList());
  }

  Stream<List<IlanModel>> getAktifIlanlar() {
    return _firestore.collection(_collectionName).where('durum', isEqualTo: 'aktif').snapshots().map((snapshot) => snapshot.docs.map((doc) => IlanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<bool> teklifVerildiMi(String ilanId, String ustaId) async {
    try {
      final snap = await _firestore.collection("teklifler").where('ilanId', isEqualTo: ilanId).where('ustaId', isEqualTo: ustaId).get();
      return snap.docs.isNotEmpty;
    } catch (e) { return false; }
  }

  Stream<QuerySnapshot> ustaAktifTeklifleriniGetir(String ustaId) {
    return _firestore.collection('teklifler')
        .where('ustaId', isEqualTo: ustaId)
        .where('durum', isEqualTo: 'beklemede')
        .snapshots();
  }

  Stream<QuerySnapshot> ustaGecmisTeklifleriniGetir(String ustaId) {
    return _firestore.collection('teklifler')
        .where('ustaId', isEqualTo: ustaId)
        .where('durum', whereIn: ['onaylandi', 'reddedildi'])
        .snapshots();
  }

  Future<bool> teklifVerVeBakiyeDus({
    required String ilanId,
    required String ustaId,
    required String kategoriId,
    required double teklifFiyat,
    required String mesaj,
    required double komisyonTutari,
    bool isMuaf = false,
  }) async {
    try {
      var checkQuery = await _firestore.collection("teklifler").where('ilanId', isEqualTo: ilanId).where('ustaId', isEqualTo: ustaId).get();
      if (checkQuery.docs.isNotEmpty) throw Exception("Bu ilana zaten teklif verdiniz.");

      if (!isMuaf) {
        bool basarili = await _walletService.bakiyeDus(ustaId, komisyonTutari);
        if (!basarili) return false;
      }

      await _firestore.collection("teklifler").doc().set({
        'ilanId': ilanId,
        'ustaId': ustaId,
        'teklifFiyat': teklifFiyat,
        'mesaj': mesaj,
        'komisyonTutari': isMuaf ? 0.0 : komisyonTutari,
        'tarih': DateTime.now().toIso8601String(),
        'durum': 'beklemede',
        'isAdminTeklifi': isMuaf,
      });

      // --- ANALYTICS REVİZE: Şehir parametresi kaldırıldı ---
      await _analyticsService.logTeklifVerildi(kategoriId, teklifFiyat);

      return true;
    } catch (e) { rethrow; }
  }

  Future<void> isiUstayaAta({
    required String ilanId, required String secilenTeklifId, required String ustaId,
    required String musteriAdi, required String musteriTel, required String musteriAdres,
    required String ilanBaslik, required String konumMetin,
  }) async {
    WriteBatch batch = _firestore.batch();
    try {
      DocumentSnapshot ustaDoc = await _firestore.collection('users').doc(ustaId).get();
      String ustaAd = "Bilinmiyor";
      if (ustaDoc.exists) {
        var data = ustaDoc.data() as Map<String, dynamic>;
        ustaAd = data['ad'] ?? data['name'] ?? "Bilinmiyor";
      }

      batch.update(_firestore.collection(_collectionName).doc(ilanId), {
        'durum': 'is_verildi',
        'atananUstaId': ustaId,
        'secilenTeklifId': secilenTeklifId,
        'guncellenmeTarihi': FieldValue.serverTimestamp(),
      });
      batch.update(_firestore.collection("teklifler").doc(secilenTeklifId), {
        'durum': 'onaylandi',
        'onayTarihi': FieldValue.serverTimestamp(),
        'musteriAdi': musteriAdi,
        'musteriTel': musteriTel,
        'musteriAdres': musteriAdres,
      });
      batch.set(_firestore.collection("jobs").doc(), {
        'ilanId': ilanId,
        'title': ilanBaslik,
        'musteriAd': musteriAdi,
        'konumMetin': konumMetin,
        'ustaId': ustaId,
        'ustaAd': ustaAd,
        'status': 'devam_ediyor',
        'timestamp': FieldValue.serverTimestamp(),
      });
      await batch.commit();
    } catch (e) { rethrow; }
  }

  Future<void> _zamanAsimiKontrolEt(IlanModel ilan) async {
    if (ilan.durum != 'aktif') return;
    try {
      DateTime ilanTarihi = DateTime.parse(ilan.tarih);
      if (DateTime.now().difference(ilanTarihi).inDays >= 7) {
        await _firestore.collection(_collectionName).doc(ilan.id).update({
          'durum': 'zaman_asimi',
          'guncellenmeTarihi': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {}
  }

  Stream<List<IlanModel>> ilanlariGetir() {
    return _firestore.collection(_collectionName).snapshots().map((snapshot) {
      var ilanlar = snapshot.docs.map((doc) => IlanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      ilanlar.sort((a, b) => b.tarih.compareTo(a.tarih));
      return ilanlar;
    });
  }
}