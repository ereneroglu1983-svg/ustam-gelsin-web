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

  // --- BAKİYE VE YARDIMCI ---
  Future<void> addBalance(String uid, double amount) async {
    try {
      await _walletService.bakiyeYukle(uid, amount, "Manuel Bakiye Yükleme");
    } catch (e) {
      throw Exception("Bakiye yüklenemedi: $e");
    }
  }

  Future<bool> teklifVerildiMi(String ilanId, String ustaId) async {
    try {
      final snap = await _firestore.collection("teklifler")
          .where('ilanId', isEqualTo: ilanId)
          .where('ustaId', isEqualTo: ustaId).get();
      return snap.docs.isNotEmpty;
    } catch (e) { return false; }
  }

  // --- İLAN YÖNETİMİ ---
  Future<void> ilanOlustur(IlanModel ilan) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Kullanıcı giriş yapmadı");

      bool acilDurumu = ilan.isAcil == true || (ilan.teknikDetaylar['isAcil'] == true);
      final String hedefKoleksiyon = acilDurumu ? 'acil_cagri' : _collectionName;

      DocumentReference docRef = _firestore.collection(hedefKoleksiyon).doc();

      Map<String, dynamic> ilanVerisi = ilan.toMap();
      ilanVerisi['id'] = docRef.id;

      if (ilan.ilanCode.isEmpty) {
        ilanVerisi['ilanCode'] = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
      }

      await docRef.set(ilanVerisi);
      await _analyticsService.logIlanOlusturuldu(ilan.kategori);

      try {
        await SosyalMedyaMotoru.facebookPaylas(ilan.baslik, ilan.konumMetin, ilan.kategori, ilan.teknikDetaylar, "");
      } catch (e) {
        debugPrint("Facebook paylaşım hatası: $e");
      }
    } catch (e) {
      throw Exception("İlan kaydedilemedi: $e");
    }
  }

  // SADECE NORMAL İLANLAR İÇİN (Dokunulmadı)
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

  // --- ACİL İŞ KAPMA METODU ---
  Future<bool> acilIsiKap(String ilanId, double komisyon) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Kullanıcı giriş yapmadı");

    return await _firestore.runTransaction((transaction) async {
      DocumentReference ilanRef = _firestore.collection("acil_cagri").doc(ilanId);
      DocumentSnapshot ilanSnap = await transaction.get(ilanRef);

      if (!ilanSnap.exists) throw Exception("İlan bulunamadı.");

      var ilanData = ilanSnap.data() as Map<String, dynamic>;

      if (ilanData['durum'] == 'eslesti') return false;

      bool bakiyeDustu = await _walletService.bakiyeDus(user.uid, komisyon);
      if (!bakiyeDustu) return false;

      transaction.update(ilanRef, {
        'durum': 'eslesti',
        'secilenUstaId': user.uid,
        'islemTarihi': FieldValue.serverTimestamp(),
      });

      return true;
    });
  }

  // --- ACİL İLAN STREAMLERİ (REVİZE EDİLDİ: 'bekliyor' sorgusu) ---

  Stream<List<IlanModel>> getAcilCagrilar(List<String> ustaUzmanliklari) {
    if (ustaUzmanliklari.isEmpty) return Stream.value([]);

    return _firestore.collection("acil_cagri")
        .where('durum', isEqualTo: 'bekliyor') // Müşteri tarafıyla uyumlu hale getirildi
        .where('kategoriId', whereIn: ustaUzmanliklari)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => IlanModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // --- NORMAL İLAN STREAMLERİ (Dokunulmadı) ---

  Stream<List<IlanModel>> aktifIlanlariGetir(String userId) {
    return _firestore.collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => IlanModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  Stream<List<IlanModel>> getAktifIlanlar() {
    return _firestore.collection(_collectionName)
        .where('durum', isEqualTo: 'aktif')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => IlanModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // --- TEKLİF İŞLEMLERİ ---
  Future<bool> teklifVerVeBakiyeDus({
    required String ilanId,
    required String ustaId,
    required String kategoriId,
    required double teklifFiyat,
    required String mesaj,
    required double komisyonTutari,
    required String sehir,
    bool isMuaf = false,
  }) async {
    return await _firestore.runTransaction((transaction) async {
      var acilSnap = await transaction.get(_firestore.collection("acil_cagri").doc(ilanId));
      bool acilMi = acilSnap.exists;
      double finalKomisyon = acilMi ? 250.0 : komisyonTutari;

      var checkQuery = await _firestore.collection("teklifler")
          .where('ilanId', isEqualTo: ilanId)
          .where('ustaId', isEqualTo: ustaId).get();

      if (checkQuery.docs.isNotEmpty) throw Exception("Bu ilana zaten teklif verdiniz.");

      if (!isMuaf) {
        bool basarili = await _walletService.bakiyeDus(ustaId, finalKomisyon);
        if (!basarili) return false;
      }

      transaction.set(_firestore.collection("teklifler").doc(), {
        'ilanId': ilanId,
        'ustaId': ustaId,
        'teklifFiyat': teklifFiyat,
        'mesaj': mesaj,
        'komisyonTutari': isMuaf ? 0.0 : finalKomisyon,
        'sehir': sehir,
        'tarih': DateTime.now().toIso8601String(),
        'durum': 'beklemede',
        'isAdminTeklifi': isMuaf,
        'acilMi': acilMi,
      });

      await _analyticsService.logTeklifVerildi(kategoriId, teklifFiyat);
      return true;
    });
  }

  Future<void> isiUstayaAta({
    required String ilanId, required String secilenTeklifId, required String ustaId,
    required String musteriAdi, required String musteriTel, required String musteriAdres,
    required String ilanBaslik, required String konumMetin,
  }) async {
    WriteBatch batch = _firestore.batch();
    try {
      batch.update(_firestore.collection(_collectionName).doc(ilanId), {
        'durum': 'is_verildi',
        'atananUstaId': ustaId,
        'secilenTeklifId': secilenTeklifId,
      });
      batch.update(_firestore.collection("teklifler").doc(secilenTeklifId), {'durum': 'onaylandi'});
      batch.set(_firestore.collection("jobs").doc(), {
        'ilanId': ilanId, 'title': ilanBaslik, 'ustaId': ustaId, 'status': 'devam_ediyor',
      });
      await batch.commit();
    } catch (e) { rethrow; }
  }
}