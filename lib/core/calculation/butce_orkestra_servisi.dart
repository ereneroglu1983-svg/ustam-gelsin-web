// lib/core/calculation/butce_orkestra_servisi.dart

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // debugPrint için gerekli
import '../constants/is_sorulari_data.dart';
import 'meslekler/alci_siva.dart';
import 'meslekler/aluminyum_cephe.dart';
import 'meslekler/asansor_servis.dart';
import 'meslekler/asma_tavan.dart';
import 'meslekler/bahce_peyzaj.dart';
import 'meslekler/banyo_vestiyer.dart';
import 'meslekler/temizlik_hizmetleri.dart';
import 'meslekler/bolme_duvar.dart';
import 'meslekler/cam_balkon.dart';
import 'meslekler/cati_isleri.dart';
import 'meslekler/dis_cephe.dart';
import 'meslekler/dogalgaz_kombi.dart';
import 'meslekler/duvar_kagidi.dart';
import 'meslekler/elektrik_tesisat.dart';
import 'meslekler/epoksi_zemin.dart';
import 'meslekler/fayans_seramik.dart';
import 'meslekler/ferforje_metal.dart';
import 'meslekler/gergi_tavan.dart';
import 'meslekler/gomme_dolap.dart';
import 'meslekler/gunes_enerjisi.dart';
import 'meslekler/havuz_sistemleri.dart';
import 'meslekler/ic_boya.dart';
import 'meslekler/italyan_boya.dart';
import 'meslekler/kapi_sistemleri.dart';
import 'meslekler/kartonpiyer.dart';
import 'meslekler/klima_servis.dart';
import 'meslekler/komple_tadilat.dart';
import 'meslekler/marangozluk.dart';
import 'meslekler/mermer_granit.dart';
import 'meslekler/mutfak_dolabi.dart';
import 'meslekler/otomatik_sulama.dart';
import 'meslekler/panel_singil.dart';
import 'meslekler/parke_doseme.dart';
import 'meslekler/prefabrik_yapi.dart';
import 'meslekler/pvc_dograma.dart';
import 'meslekler/sihhi_tesisat.dart';
import 'meslekler/sineklik_panjur.dart';
import 'meslekler/sistre_cila.dart';
import 'meslekler/su_yalitimi.dart';
import 'meslekler/uydu_kamera.dart';
import 'meslekler/cilingir.dart';
import 'meslekler/hesap_yenilenebilir_enerji/hesap_elektrikli_arac.dart';
import 'meslekler/hesap_yenilenebilir_enerji/hesap_enerji_depolama.dart';
import 'meslekler/hesap_yenilenebilir_enerji/hesap_ges.dart';
import 'meslekler/hesap_yenilenebilir_enerji/hesap_off_grid_mobil_enerji.dart';
import 'meslekler/hesap_yenilenebilir_enerji/hesap_res.dart';

class ButceOrkestraServisi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Map<String, dynamic> yerelRobotHesapla({
    required String kategori,
    required List<dynamic> gelenCevaplar,
  }) {
    final String aranan = kategori.trim().toUpperCase();

    if (aranan.contains("LAMİNAT") || aranan.contains("PARKE")) return ParkeDosemeHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("İÇ CEPHE") || aranan.contains("BOYA")) return IcBoyaHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("FAYANS") || aranan.contains("SERAMİK")) return FayansSeramikHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("MERMER") || aranan.contains("GRANİT")) return MermerGranitHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("ALÇI") || aranan.contains("SIVA")) return AlciSivaHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("ASMA TAVAN")) return AsmaTavanHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("GERGİ TAVAN")) return GergiTavanHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("KARTONPİYER")) return KartonpiyerHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("BÖLME DUVAR")) return BolmeDuvarHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("EPOKSİ")) return EpoksiZeminHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("SİSTRE")) return SistreCilaHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("SIHHİ") || aranan.contains("TESİSAT")) return SihhiTesisatHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("ELEKTRİK")) return ElektrikTesisatHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("DOĞALGAZ") || aranan.contains("KOMBİ")) return DogalgazKombiHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("GÜNEŞ") || aranan.contains("ENERJİ")) return GunesEnerjisiHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("KLİMA")) return KlimaServisHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("PVC")) return PvcDogramaHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("ALÜMİNYUM")) return AluminyumCepheHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("CAM BALKON")) return CamBalkonHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("KAPI")) return KapiSistemleriHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("SİNEKLİK") || aranan.contains("PANJUR")) return SineklikPanjurHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("MUTFAK")) return MutfakDolabiHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("BANYO")) return BanyoVestiyerHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("GÖMME") || aranan.contains("RAY DOLAP")) return RayDolapHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("MARANGOZ")) return MarangozlukHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("ÇATI")) return CatiIsleriHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("SANDVİÇ") || aranan.contains("ŞİNGIL")) return PanelSingilHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("YALITIM") || aranan.contains("SU YALITIMI")) return SuYalitimiHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("BAHÇE") || aranan.contains("PEYZAJ")) return BahcePeyzajHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("SULAMA")) return OtomatikSulamaHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("HAVUZ")) return HavuzSistemleriHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("FERFORJE")) return FerforjeMetalHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("PREFABRİK") || aranan.contains("BUNGALOV")) return PrefabrikYapiHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("UYDU") || aranan.contains("KAMERA")) return UyduKameraHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("ASANSÖR")) return AsansorHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("TADİLAT")) return KompleTadilatHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("TEMİZLİK")) return TemizlikHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("ÇİLİNGİR")) return CilingirHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("ELEKTRİKLİ ARAÇ")) return ElektrikliAracHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("ENERJİ DEPOLAMA")) return EnerjiDepolamaHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("GES")) return GESHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("OFF-GRID")) return OffGridMobilEnerjiHesaplayici.hesapla(gelenCevaplar);
    if (aranan.contains("RÜZGAR")) return RESHesaplayici.hesapla(gelenCevaplar);

    debugPrint("!!! KRİTİK: Kategori eşleşmedi, Fallback devrede. Aranan: $aranan");
    return {
      "hata": "Eşleşen yerel robot hesaplayıcı bulunamadı.",
      "kategori": aranan,
      "minimumButce": 1000.0,
      "muhtemelButce": 3000.0,
      "maksimumButce": 5000.0,
      "durum": "HATA"
    };
  }

  static Future<Map<String, dynamic>> silsileYurut({
    required String talepId,
    required String kategoriAdi,
    required List<dynamic> kullaniciCevaplari,
    required Map<String, dynamic> yerelHafizaVerisi,
    required String anlikBolgeKodu,
    required String anlikKullaniciSegmenti,
  }) async {
    print("--- SİLSİLE MOTORU BAŞLATILDI (Talep ID: $talepId) ---");

    if (yerelHafizaVerisi.containsKey(talepId) && yerelHafizaVerisi[talepId]!= null) {
      print("[SİLSİLE 1] Veri RAM üzerinde bulundu. Doğrudan ekrana basılıyor.");
      return yerelHafizaVerisi[talepId];
    }
    print("[SİLSİLE 1] RAM boş, Firebase Ortak Koleksiyon kontrolüne geçiliyor.");

    String cevapMatrisiKey = jsonEncode(kullaniciCevaplari);
    String normalizeKategori = kategoriAdi.trim().toUpperCase();

    try {
      print("[SİLSİLE 2] Firebase ortak havuzunda aynı arama sorgulanıyor...");
      var havuzSorgusu = await _firestore
          .collection('hazir_teklif_havuzu')
          .where('kategori', isEqualTo: normalizeKategori)
          .where('analizMatrisi', isEqualTo: cevapMatrisiKey)
          .limit(1)
          .get();

      if (havuzSorgusu.docs.isNotEmpty) {
        print("[SİLSİLE 2] AYNEN BULDUM! Daha önce bu arama yapılmış.");
        Map<String, dynamic> hazirRapor = havuzSorgusu.docs.first.data();

        yerelHafizaVerisi[talepId] = hazirRapor;
        return hazirRapor;
      }
      print("[SİLSİLE 2] Ortak havuzda eşleşme yok. Yeni arama olarak işleniyor.");
    } catch (e) {
      print("[SİLSİLE HATA] Firebase sorgulanırken hata oluştu: $e");
    }

    print("[SİLSİLE 4] Veriler yerel hesaplama robotuna gönderiliyor...");
    Map<String, dynamic> robotHesapSonucu = yerelRobotHesapla(
      kategori: normalizeKategori,
      gelenCevaplar: kullaniciCevaplari,
    );

    Map<String, dynamic> nihaiButceRaporu = {
      "talepId": talepId,
      "kategori": normalizeKategori,
      "hesaplamaTarihi": FieldValue.serverTimestamp(),
      "analizMatrisi": cevapMatrisiKey,
      "robotSonucu": robotHesapSonucu,
      "durum": "BAŞARILI"
    };

    try {
      print("[SİLSİLE 5] Rapor Firebase ortak koleksiyonuna yazılıyor...");
      await _firestore.collection('hazir_teklif_havuzu').add(nihaiButceRaporu);

      print("[SİLSİLE 6] AI Uzmanı için gerçek zamanlı veriler app_ai_data koleksiyonuna işleniyor...");
      await _firestore.collection('app_ai_data').add({
        "talepId": talepId,
        "kategori": normalizeKategori,
        "kullaniciCevaplari": kullaniciCevaplari,
        "robotSonucu": robotHesapSonucu,
        "metaVeri": {
          "islemZamani": FieldValue.serverTimestamp(),
          "bolgeKodlari": [anlikBolgeKodu],
          "kullaniciSegmenti": anlikKullaniciSegmenti,
        },
        "aiEtiketleri": ["INS_HESAPLAMA", "SEKTOR_UZMANI_DYNAMIC"],
        "selfCorrectionStatus": "READY"
      });

      yerelHafizaVerisi[talepId] = nihaiButceRaporu;
      print("[SİLSİLE 5 & 6] İşlem tamamlandı ve AI veri seti oluşturuldu.");
    } catch (e) {
      print("[SİLSİLE HATA] Firebase kaydı başarısız: $e");
    }

    return nihaiButceRaporu;
  }
}