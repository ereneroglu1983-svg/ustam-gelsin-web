// lib/core/calculation/butce_orkestra_servisi.dart

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/is_sorulari_data.dart';

// 41 Mesleğin Güncel Hesaplayıcı Servis Importları
import 'meslekler/alci_siva.dart';
import 'meslekler/aluminyum_cephe.dart';
import 'meslekler/asansor_servis.dart';
import 'meslekler/asma_tavan.dart';
import 'meslekler/bahce_peyzaj.dart';
import 'meslekler/banyo_vestiyer.dart';
import 'meslekler/bina_temizlik_hesaplayici.dart';
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

class ButceOrkestraServisi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Map<String, dynamic> yerelRobotHesapla({
    required String kategori,
    required List<dynamic> gelenCevaplar,
  }) {
    final String arananKategori = kategori.trim().toUpperCase();

    switch (arananKategori) {
      case "İÇ CEPHE BOYA VE BADANA":
        return IcBoyaHesaplayici.hesapla(gelenCevaplar);
      case "DIŞ CEPHE BOYA VE MANTOLAMA":
        return DisCepheHesaplayici.hesapla(gelenCevaplar);
      case "DUVAR KAĞIDI VE POSTER UYGULAMASI":
        return DuvarKagidiHesaplayici.hesapla(gelenCevaplar);
      case "İTALYAN BOYA VE DEKORATİF SIVA":
        return ItalyanBoyaHesaplayici.hesapla(gelenCevaplar);
      case "ASMA TAVAN":
        return AsmaTavanHesaplayici.hesapla(gelenCevaplar);
      case "GERGİ TAVAN SİSTEMLERİ":
        return GergiTavanHesaplayici.hesapla(gelenCevaplar);
      case "KARTONPİYER, STROPİYER VE ÇITALAMA":
        return KartonpiyerHesaplayici.hesapla(gelenCevaplar);
      case "ALÇI SIVA VE SATEN ALÇI":
        return AlciSivaHesaplayici.hesapla(gelenCevaplar);
      case "BÖLME DUVAR (ALÇIPAN/BETOBAN/CAM)":
        return BolmeDuvarHesaplayici.hesapla(gelenCevaplar);
      case "FAYANS , SERAMİK VE KALEBODUR":
        return FayansSeramikHesaplayici.hesapla(gelenCevaplar);
      case "LAMİNAT , LAMİNE VE MASİF PARKE":
        return ParkeDosemeHesaplayici.hesapla(gelenCevaplar);
      case "MERMER , GRANİT VE TRAVERTEN":
        return MermerGranitHesaplayici.hesapla(gelenCevaplar);
      case "EPOKSİ ZEMİN KAPLAMA":
        return EpoksiZeminHesaplayici.hesapla(gelenCevaplar);
      case "SİSTRE CİLA İŞLERİ":
        return SistreCilaHesaplayici.hesapla(gelenCevaplar);
      case "SIHHİ TESİSAT VE PİS SU TESİSATI":
        return SihhiTesisatHesaplayici.hesapla(gelenCevaplar);
      case "ELEKTRİK TESİSATI":
        return ElektrikTesisatHesaplayici.hesapla(gelenCevaplar);
      case "DOĞALGAZ TESİSATI VE KOMBİ MONTAJI/BAKIMI":
        return DogalgazKombiHesaplayici.hesapla(gelenCevaplar);
      case "GÜNEŞ ENERJİSİ VE TERMOSİFON":
        return GunesEnerjisiHesaplayici.hesapla(gelenCevaplar);
      case "KLİMA MONTAJ , BAKIM VE GAZ DOLUMU":
        return KlimaServisHesaplayici.hesapla(gelenCevaplar);
      case "PVC DOĞRAMA":
        return PvcDogramaHesaplayici.hesapla(gelenCevaplar);
      case "ALÜMİNYUM DOĞRAMA VE CEPHE":
        return AluminyumCepheHesaplayici.hesapla(gelenCevaplar);
      case "CAM BALKON VE GİYOTİN CAM":
        return CamBalkonHesaplayici.hesapla(gelenCevaplar);
      case "ODA KAPISI VE ÇELİK KAPI":
        return KapiSistemleriHesaplayici.hesapla(gelenCevaplar);
      case "SİNEKLİK VE PANJUR SİSTEMLERİ":
        return SineklikPanjurHesaplayici.hesapla(gelenCevaplar);
      case "MUTFAK DOLABI VE TEZGAHI":
        return MutfakDolabiHesaplayici.hesapla(gelenCevaplar);
      case "BANYO DOLABI VE VESTİYER":
        return BanyoVestiyerHesaplayici.hesapla(gelenCevaplar);
      case "GÖMME DOLAP VE RAY DOLAP":
        return RayDolapHesaplayici.hesapla(gelenCevaplar);
      case "MARANGOZLUK VE MOBİLYA TAMİRİ":
        return MarangozlukHesaplayici.hesapla(gelenCevaplar);
      case "ÇATI YAPIMI AKTARMA VE İZALASYON":
        return CatiIsleriHesaplayici.hesapla(gelenCevaplar);
      case "SANDVİÇ PANEL VE ŞİNGIL KAPLAMA":
        return PanelSingilHesaplayici.hesapla(gelenCevaplar);
      case "TEMEL VE BODRUM SU YALITIMI":
        return SuYalitimiHesaplayici.hesapla(gelenCevaplar);
      case "BAHÇE PEYZAJ VE ÇİM EKİMİ":
        return BahcePeyzajHesaplayici.hesapla(gelenCevaplar);
      case "OTAMATİK SULAMA SİSTEMLERİ":
        return OtomatikSulamaHesaplayici.hesapla(gelenCevaplar);
      case "HAVUZ YAPIMI VE BAKIMI":
        return HavuzSistemleriHesaplayici.hesapla(gelenCevaplar);
      case "FERFORJE KORKULUK VE BAHÇE KAPISI":
        return FerforjeMetalHesaplayici.hesapla(gelenCevaplar);
      case "KONTEYNER, BUNGALOV VE PREFABRİK":
        return PrefabrikYapiHesaplayici.hesapla(gelenCevaplar);
      case "UYDU, INTERNET VE KAMERA SİTEMLERİ":
        return UyduKameraHesaplayici.hesapla(gelenCevaplar);
      case "ASANSÖR BAKIM VE ONARIM":
        return AsansorHesaplayici.hesapla(gelenCevaplar);
      case "ANAHTAR TESLİM KOMPLE TADİLAT":
        return KompleTadilatHesaplayici.hesapla(gelenCevaplar);
      case "BİNA, OFİS VE DIŞ CEPHE TEMİZLİĞİ":
        return BinaTemizlikHesaplayici.hesapla(gelenCevaplar);

      default:
        print("!!! HATA: ButceOrkestraServisi'nde eşleşen case bulunamadı. Kategori: $arananKategori");
        return {
          "hata": "Eşleşen yerel robot hesaplayıcı bulunamadı.",
          "kategori": kategori
        };
    }
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

    if (yerelHafizaVerisi.containsKey(talepId) && yerelHafizaVerisi[talepId] != null) {
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
      print("[SİLSİLE HATA] Firebase sorgulanırken hata oluştu (İndeks gerekiyorsa logdaki linki kullan): $e");
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