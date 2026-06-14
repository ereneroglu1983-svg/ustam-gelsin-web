// lib/core/constants/is_sorulari_data.dart

import '../calculation/meslek_sorulari/alci_siva.dart';
import '../calculation/meslek_sorulari/aluminyum_cephe.dart';
import '../calculation/meslek_sorulari/asansor_servis.dart';
import '../calculation/meslek_sorulari/asma_tavan.dart';
import '../calculation/meslek_sorulari/bahce_peyzaj.dart';
import '../calculation/meslek_sorulari/banyo_vestiyer.dart';
import '../calculation/meslek_sorulari/bina_temizlik.dart';
import '../calculation/meslek_sorulari/bolme_duvar.dart';
import '../calculation/meslek_sorulari/cam_balkon.dart';
import '../calculation/meslek_sorulari/cati_isleri.dart';
import '../calculation/meslek_sorulari/dis_cephe.dart';
import '../calculation/meslek_sorulari/dogalgaz_kombi.dart';
import '../calculation/meslek_sorulari/duvar_kagidi.dart';
import '../calculation/meslek_sorulari/elektrik_tesisat.dart';
import '../calculation/meslek_sorulari/epoksi_zemin.dart';
import '../calculation/meslek_sorulari/fayans_seramik.dart';
import '../calculation/meslek_sorulari/ferforje_metal.dart';
import '../calculation/meslek_sorulari/gergi_tavan.dart';
import '../calculation/meslek_sorulari/gomme_dolap.dart';
import '../calculation/meslek_sorulari/gunes_enerjisi.dart';
import '../calculation/meslek_sorulari/havuz_sistemleri.dart';
import '../calculation/meslek_sorulari/ic_boya.dart';
import '../calculation/meslek_sorulari/italyan_boya.dart';
import '../calculation/meslek_sorulari/kapi_sistemleri.dart';
import '../calculation/meslek_sorulari/kartonpiyer.dart';
import '../calculation/meslek_sorulari/klima_servis.dart';
import '../calculation/meslek_sorulari/komple_tadilat.dart';
import '../calculation/meslek_sorulari/marangozluk.dart';
import '../calculation/meslek_sorulari/mermer_granit.dart';
import '../calculation/meslek_sorulari/mutfak_dolabi.dart';
import '../calculation/meslek_sorulari/otomatik_sulama.dart';
import '../calculation/meslek_sorulari/panel_singil.dart';
import '../calculation/meslek_sorulari/parke_doseme.dart';
import '../calculation/meslek_sorulari/prefabrik_yapi.dart';
import '../calculation/meslek_sorulari/pvc_dograma.dart';
import '../calculation/meslek_sorulari/sihhi_tesisat.dart';
import '../calculation/meslek_sorulari/sineklik_panjur.dart';
import '../calculation/meslek_sorulari/sistre_cila.dart';
import '../calculation/meslek_sorulari/su_yalitimi.dart';
import '../calculation/meslek_sorulari/uydu_kamera.dart';

class IsSorulariData {
  static final Map<String, List<Map<String, dynamic>>> banka = {
    "İÇ CEPHE BOYA VE BADANA": IcBoyaSorulari.sorular,
    "DIŞ CEPHE BOYA VE MANTOLAMA": DisCepheSorulari.sorular,
    "DUVAR KAĞIDI VE POSTER UYGULAMASI": DuvarKagidiSorulari.sorular,
    "İTALYAN BOYA VE DEKORATİF SIVA": ItalyanBoyaSorulari.sorular,
    "ASMA TAVAN": AsmaTavanSorulari.sorular,
    "GERGİ TAVAN SİSTEMLERİ": GergiTavanSorulari.sorular,
    "KARTONPİYER, STROPİYER VE ÇITALAMA": KartonpiyerSorulari.sorular,
    "ALÇI SIVA VE SATEN ALÇI": AlciSivaSorulari.sorular,
    "BÖLME DUVAR (ALÇIPAN/BETOBAN/CAM)": BolmeDuvarSorulari.sorular,
    "FAYANS , SERAMİK VE KALEBODUR": FayansSeramikSorulari.sorular,
    "LAMİNAT , LAMİNE VE MASİF PARKE": ParkeDosemeSorulari.sorular,
    "MERMER , GRANİT VE TRAVERTEN": MermerGranitSorulari.sorular,
    "EPOKSİ ZEMİN KAPLAMA": EpoksiZeminSorulari.sorular,
    "SİSTRE CİLA İŞLERİ": SistreCilaSorulari.sorular,
    "SIHHİ TESİSAT VE PİS SU TESİSATI": SihhiTesisatSorulari.sorular,
    "ELEKTRİK TESİSATI": ElektrikTesisatiSorulari.sorular,
    "DOĞALGAZ TESİSATI VE KOMBİ MONTAJI/BAKIMI": DogalgazKombiSorulari.sorular,
    "GÜNEŞ ENERJİSİ VE TERMOSİFON": GunesEnerjisiSorulari.sorular,
    "KLİMA MONTAJ , BAKIM VE GAZ DOLUMU": KlimaSorulari.sorular,
    "PVC DOĞRAMA": PvcDogramaSorulari.sorular,
    "ALÜMİNYUM DOĞRAMA VE CEPHE": AluminyumCepheSorulari.sorular,
    "CAM BALKON VE GİYOTİN CAM": CamBalkonSorulari.sorular,
    "ODA KAPISI VE ÇELİK KAPI": KapiSistemleriSorulari.sorular,
    "SİNEKLİK VE PANJUR SİSTEMLERİ": SineklikPanjurSorulari.sorular,
    "MUTFAK DOLABI VE TEZGAHI": MutfakDolabiSorulari.sorular,
    "BANYO DOLABI VE VESTİYER": BanyoVestiyerSorulari.sorular,
    "GÖMME DOLAP VE RAY DOLAP": RayDolapSorulari.sorular,
    "MARANGOZLUK VE MOBİLYA TAMİRİ": MarangozlukSorulari.sorular,
    "ÇATI YAPIMI AKTARMA VE İZALASYON": CatiIsleriSorulari.sorular,
    "SANDVİÇ PANEL VE ŞİNGIL KAPLAMA": PanelSingilSorulari.sorular,
    "TEMEL VE BODRUM SU YALITIMI": SuYalitimiSorulari.sorular,
    "BAHÇE PEYZAJ VE ÇİM EKİMİ": BahcePeyzajSorulari.sorular,
    "OTAMATİK SULAMA SİSTEMLERİ": OtomatikSulamaSorulari.sorular,
    "HAVUZ YAPIMI VE BAKIMI": HavuzSistemleriSorulari.sorular,
    "FERFORJE KORKULUK VE BAHÇE KAPISI": FerforjeMetalSorulari.sorular,
    "KONTEYNER, BUNGALOV VE PREFABRİK": PrefabrikYapiSorulari.sorular,
    "UYDU, INTERNET VE KAMERA SİTEMLERİ": UyduKameraSorulari.sorular,
    "ASANSÖR BAKIM VE ONARIM": AsansorSorulari.sorular,
    "ANAHTAR TESLİM KOMPLE TADİLAT": KompleTadilatSorulari.sorular,
    "BİNA, OFİS VE DIŞ CEPHE TEMİZLİĞİ": BinaTemizlikSorulari.sorular,
  };

  static String _enYalinHaleGetir(String metin) {
    return metin
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '') // Her türlü özel karakteri temizle
        .replaceAll('ş', 's')
        .replaceAll('ı', 'i')
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o');
  }

  static List<Map<String, dynamic>> getSorularByKategori(String kategoriAdi) {
    if (kategoriAdi.isEmpty) return [];

    String arananTemiz = _enYalinHaleGetir(kategoriAdi);

    for (var key in banka.keys) {
      if (_enYalinHaleGetir(key) == arananTemiz) {
        return banka[key] ?? [];
      }
    }
    return [];
  }
}