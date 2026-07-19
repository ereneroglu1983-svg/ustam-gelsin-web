// lib/core/calculation/butce_orkestra_servisi.dart

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../constants/is_sorulari_data.dart';
import '../services/ai_price_provider.dart';
import '../services/groq_provider.dart';

class ButceOrkestraServisi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final AiPriceProvider _aiProvider = GroqProvider();

  static const Set<String> _gecerliMeslekIdler = {
    'alci_siva','aluminyum_cephe','asansor_servis','asma_tavan','bahce_peyzaj',
    'banyo_vestiyer','bina_temizlik_hesaplayici','bolme_duvar','cam_balkon','cati_isleri',
    'dis_cephe','dogalgaz_kombi','duvar_kagidi','elektrik_tesisat','elektrikli_arac',
    'enerji_depolama','epoksi_zemin','fayans_seramik','ferforje_metal','gergi_tavan',
    'ges','gomme_dolap','gunes_enerjisi','havuz_sistemleri','ic_boya','italyan_boya',
    'kapi_sistemleri','kartonpiyer','klima_servis','komple_tadilat','marangozluk',
    'mermer_granit','mutfak_dolabi','off_grid_mobil_enerji','otomatik_sulama','panel_singil',
    'parke_doseme','prefabrik_yapi','pvc_dograma','res','sihhi_tesisat','sineklik_panjur',
    'sistre_cila','su_yalitimi','temizlik_hizmetleri','uydu_kamera'
  };

  static String _stabilHashOlustur(String kategoriId, List<dynamic> cevaplar) {
    final String ham = "$kategoriId-${jsonEncode(cevaplar)}";
    return sha256.convert(utf8.encode(ham)).toString().substring(0, 32);
  }

  static Map<String, dynamic> _zenginDetayOlustur(String kategoriAdi, List<dynamic> kullaniciCevaplari) {
    final sorular = IsSorulariData.getSorularByKategori(kategoriAdi);
    final Map<String, dynamic> cevapMap = {};
    for (var item in kullaniciCevaplari) {
      if (item is Map && item.containsKey('id')) {
        cevapMap[item['id'].toString()] = item['cevap'];
      }
    }
    List<Map<String, String>> zenginListe = [];
    for (var s in sorular) {
      final String id = s['id'].toString();
      if (cevapMap.containsKey(id)) {
        zenginListe.add({
          "soru": s['label']?.toString()?? id,
          "cevap": cevapMap[id].toString(),
        });
      }
    }
    return {"ham_cevaplar": cevapMap, "zengin_aciklama": zenginListe};
  }

  static Future<Map<String, dynamic>> _firebaseTabanliJenerikHesapla({
    required String meslekId,
    required List<dynamic> kullaniciCevaplari,
    required String bolgeKodu,
  }) async {
    try {
      if (!_gecerliMeslekIdler.contains(meslekId)) {
        throw Exception("Geçersiz meslekId, tarifede yok: $meslekId");
      }

      final doc = await _firestore.collection('meslek_fiyat_tarifeleri').doc(meslekId).get();
      if (!doc.exists) throw Exception("Tarife dokümanı yok: $meslekId");

      final data = doc.data()!;
      final Map<String, dynamic> iscilik = Map<String, dynamic>.from(data['iscilik']?? {});
      final Map<String, dynamic> ekstralar = Map<String, dynamic>.from(data['ekstralar']?? {});
      final Map<String, dynamic> alanKatsayilari = Map<String, dynamic>.from(data['alanKatsayilari']?? {});
      final Map<String, dynamic> carpanlar = Map<String, dynamic>.from(data['carpanlar']?? {});
      final Map<String, dynamic> sehirCarpani = Map<String, dynamic>.from(data['sehirCarpani']?? {});
      final Map<String, dynamic> katFarki = Map<String, dynamic>.from(data['katFarki']?? {});

      Map<String, String> cevapStrMap = {};
      for (var c in kullaniciCevaplari) {
        if (c is Map && c['id']!= null) {
          cevapStrMap[c['id'].toString().toLowerCase()] = c['cevap'].toString().toLowerCase();
        }
      }
      final String tumCevaplar = cevapStrMap.values.join(' ').toLowerCase();

      final num tabanNum = (iscilik['asgariKucuk'] as num?)?? (iscilik['asgariBuyuk'] as num?)?? 3000;
      double taban = tabanNum.toDouble();

      double alanKatsayi = 1.0;
      alanKatsayilari.forEach((k, v) {
        if (tumCevaplar.contains(k.split('_').first)) {
          alanKatsayi = (v as num).toDouble();
        }
      });

      double ekstraToplam = 0;
      List<String> kullanilanEkstralar = [];
      ekstralar.forEach((k, v) {
        if (v is Map && tumCevaplar.contains(k.split('_').first)) {
          final num fiyatNum = (v['fiyat'] as num?)?? 0;
          ekstraToplam += fiyatNum.toDouble();
          kullanilanEkstralar.add(v['etiket']?.toString()?? k);
        }
      });

      double sehirCarpan = 1.0;
      String bolge = bolgeKodu.toLowerCase();
      if (bolge.contains('istanbul') || bolge == '34') {
        final num sc = (sehirCarpani['istanbul'] as num?)?? 1.28;
        sehirCarpan = sc.toDouble();
      } else if (bolge.contains('ankara') || bolge.contains('izmir') || bolge.contains('antalya') || bolge.contains('bursa')) {
        final num sc = (sehirCarpani['ankara_izmir_antalya_bursa'] as num?)?? 1.14;
        sehirCarpan = sc.toDouble();
      } else {
        final num sc = (sehirCarpani['diger_iller'] as num?)?? 1.0;
        sehirCarpan = sc.toDouble();
      }

      double katEk = 0;
      katFarki.forEach((k, v) {
        if (tumCevaplar.contains(k.split('_').first)) katEk += (v as num).toDouble();
      });

      double carpanToplam = 1.0;
      carpanlar.forEach((k, v) {
        if (tumCevaplar.contains(k.split('_').first)) carpanToplam *= (v as num).toDouble();
      });

      double muhtemel = (taban * alanKatsayi + ekstraToplam + katEk) * sehirCarpan * carpanToplam;

      return {
        "kaynak": "FIREBASE_JENERIK_ROBOT",
        "meslekId": meslekId,
        "minimumButce": muhtemel * 0.85,
        "muhtemelButce": muhtemel,
        "maksimumButce": muhtemel * 1.25,
        "fiyatBilgisi": "${muhtemel.toInt()} ₺",
        "komisyonTutari": muhtemel * 0.01,
        "detay": {"taban": taban, "alanKatsayi": alanKatsayi, "sehirCarpan": sehirCarpan, "ekstraToplam": ekstraToplam, "kullanilanEkstralar": kullanilanEkstralar},
        "durum": "BASARILI"
      };
    } catch (e) {
      debugPrint("FIREBASE JENERIK HATA: $e");
      return {
        "kaynak": "FIREBASE_HATA",
        "minimumButce": 3000.0,
        "muhtemelButce": 5000.0,
        "maksimumButce": 8000.0,
        "fiyatBilgisi": "5000 ₺",
        "komisyonTutari": 50.0,
        "hata": e.toString(),
        "durum": "HATA"
      };
    }
  }

  static Future<Map<String, dynamic>> silsileYurut({
    required String talepId,
    required String kategoriAdi,
    required String kategoriId,
    required List<dynamic> kullaniciCevaplari,
    required Map<String, dynamic> yerelHafizaVerisi,
    required String anlikBolgeKodu,
    required String anlikKullaniciSegmenti,
  }) async {
    final String normalizeKategori = kategoriAdi.trim().toUpperCase();
    final String meslekId = kategoriId.trim().toLowerCase();
    final String stabilKey = _stabilHashOlustur(meslekId, kullaniciCevaplari);

    if (yerelHafizaVerisi.containsKey(talepId) && yerelHafizaVerisi[talepId]!= null) {
      return yerelHafizaVerisi[talepId];
    }

    try {
      var havuz = await _firestore.collection('hazir_teklif_havuzu').where('stabilKey', isEqualTo: stabilKey).limit(1).get();
      if (havuz.docs.isNotEmpty) {
        final data = havuz.docs.first.data();
        yerelHafizaVerisi[talepId] = data;
        return data;
      }
    } catch (e) {
      debugPrint("[SİLSİLE 2 HATA] $e");
    }

    try {
      final zengin = _zenginDetayOlustur(kategoriAdi, kullaniciCevaplari);
      String aiRaw = await _aiProvider.getFiyatTahmini(
        musteriId: talepId,
        isAdi: kategoriAdi,
        kategoriAdi: kategoriAdi,
        kategoriId: meslekId,
        detaylar: {"bolge": anlikBolgeKodu,...zengin},
      ).timeout(const Duration(seconds: 12));

      // DÜZELTİLDİ - TEK SATIR, HATASIZ
      double aiFiyat = double.tryParse(aiRaw.replaceAll(RegExp(r'[^0-9.]'), ''))?? 0;

      if (aiFiyat > 500) {
        final rapor = {
          "talepId": talepId,
          "kategori": normalizeKategori,
          "meslekId": meslekId,
          "stabilKey": stabilKey,
          "hesaplamaTarihi": FieldValue.serverTimestamp(),
          "kaynak": "AI_${_aiProvider.providerName}",
          "robotSonucu": {
            "kaynak": "AI",
            "minimumButce": aiFiyat * 0.85,
            "muhtemelButce": aiFiyat,
            "maksimumButce": aiFiyat * 1.25,
            "fiyatBilgisi": "${aiFiyat.toInt()} ₺",
            "komisyonTutari": aiFiyat * 0.01,
            "durum": "BASARILI"
          },
          "durum": "BASARILI"
        };
        yerelHafizaVerisi[talepId] = rapor;
        _firestore.collection('hazir_teklif_havuzu').add(rapor);
        return rapor;
      }
      throw Exception("AI anlamsız: $aiRaw");
    } catch (e) {
      debugPrint("[SİLSİLE 3] AI FAIL -> Firebase: $e");
    }

    final robotSonuc = await _firebaseTabanliJenerikHesapla(
      meslekId: meslekId,
      kullaniciCevaplari: kullaniciCevaplari,
      bolgeKodu: anlikBolgeKodu,
    );

    final nihaiRapor = {
      "talepId": talepId,
      "kategori": normalizeKategori,
      "meslekId": meslekId,
      "stabilKey": stabilKey,
      "hesaplamaTarihi": FieldValue.serverTimestamp(),
      "analizMatrisi": jsonEncode(kullaniciCevaplari),
      "robotSonucu": robotSonuc,
      "durum": "BASARILI"
    };

    try {
      await _firestore.collection('hazir_teklif_havuzu').add(nihaiRapor);
      yerelHafizaVerisi[talepId] = nihaiRapor;
    } catch (_) {}

    return nihaiRapor;
  }
}