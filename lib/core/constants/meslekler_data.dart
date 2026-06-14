// lib/core/constants/meslekler_data.dart

class MeslekModel {
  final String isim;
  final String resimYolu;
  final String puan;
  final String yorumSayisi;

  MeslekModel(this.isim, this.resimYolu, this.puan, this.yorumSayisi);
}

class MesleklerData {
  // ESKİ KODUN - HİÇBİR ŞEKİLDE DEĞİŞMEDİ (Diğer sayfaların çalışmaya devam eder)
  static const List<String> tumMeslekler = [
    "İÇ CEPHE BOYA VE BADANA", "DIŞ CEPHE BOYA VE MANTOLAMA", "DUVAR KAĞIDI VE POSTER UYGULAMASI",
    "İTALYAN BOYA VE DEKORATİF SIVA", "ASMA TAVAN", "GERGİ TAVAN SİSTEMLERİ",
    "KARTONPİYER, STROPİYER VE ÇITALAMA", "ALÇI SIVA VE SATEN ALÇI", "BÖLME DUVAR (ALÇIPAN/BETOBAN/CAM)",
    "FAYANS , SERAMİK VE KALEBODUR", "LAMİNAT , LAMİNE VE MASİF PARKE", "MERMER , GRANİT VE TRAVERTEN",
    "EPOKSİ ZEMİN KAPLAMA", "SİSTRE CİLA İŞLERİ", "SIHHİ TESİSAT VE PİS SU TESİSATI",
    "ELEKTRİK TESİSATI", "DOĞALGAZ TESİSATI VE KOMBİ MONTAJI/BAKIMI", "GÜNEŞ ENERJİSİ VE TERMOSİFON",
    "YERDEN ISITMA SİSTEMLERİ", "KLİMA MONTAJ , BAKIM VE GAZ DOLUMU", "PVC DOĞRAMA",
    "ALÜMİNYUM DOĞRAMA VE CEPHE", "CAM BALKON VE GİYOTİN CAM", "ODA KAPISI VE ÇELİK KAPI",
    "SİNEKLİK VE PANJUR SİSTEMLERİ", "MUTFAK DOLABI VE TEZGAHI", "BANYO DOLABI VE VESTİYER",
    "GÖMME DOLAP VE RAY DOLAP", "MARANGOZLUK VE MOBİLYA TAMİRİ", "ÇATI YAPIMI AKTARMA VE İZALASYON",
    "SANDVİÇ PANEL VE ŞİNGIL KAPLAMA", "TEMEL VE BODRUM SU YALITIMI", "BAHÇE PEYZAJ VE ÇİM EKİMİ",
    "OTAMATİK SULAMA SİSTEMLERİ", "HAVUZ YAPIMI VE BAKIMI", "FERFORJE KORKULUK VE BAHÇE KAPISI",
    "KONTEYNER, BUNGALOV VE PREFABRİK", "UYDU, INTERNET VE KAMERA SİTEMLERİ", "ASANSÖR BAKIM VE ONARIM",
    "ANAHTAR TESLİM KOMPLE TADİLAT"
  ];

  // YENİ EKLENEN - SadeceSlider ve resimli alanlarda kullanacaksın
  static final List<MeslekModel> hizmetlerDetayli = [
    MeslekModel("ALÇI SIVA VE SATEN ALÇI", "assets/meslek_resimleri/alcisiva.png", "4.9", "124"),
    MeslekModel("ALÜMİNYUM DOĞRAMA", "assets/meslek_resimleri/aluminyum.png", "4.8", "89"),
    MeslekModel("ANAHTAR TESLİM TADİLAT", "assets/meslek_resimleri/anahtar_teslim.png", "5.0", "210"),
    MeslekModel("ASANSÖR BAKIM", "assets/meslek_resimleri/asansor.png", "4.7", "56"),
    MeslekModel("ASMA TAVAN", "assets/meslek_resimleri/asmatavan.png", "4.8", "92"),
    MeslekModel("BANYO DOLABI", "assets/meslek_resimleri/banyo.png", "4.9", "77"),
    MeslekModel("İÇ CEPHE BOYA VE BADANA", "assets/meslek_resimleri/boya.png", "4.9", "340"), // Eşleşen isim
    MeslekModel("CAM BALKON", "assets/meslek_resimleri/cambalkon.png", "4.8", "155"),
    MeslekModel("CAM BÖLME", "assets/meslek_resimleri/cambolme.png", "4.7", "45"),
    MeslekModel("UYDU, INTERNET VE KAMERA SİTEMLERİ", "assets/meslek_resimleri/camera.png", "4.9", "112"),
    MeslekModel("ÇATI YAPIMI AKTARMA VE İZALASYON", "assets/meslek_resimleri/cati.png", "4.8", "88"),
    MeslekModel("DOĞALGAZ TESİSATI VE KOMBİ MONTAJI/BAKIMI", "assets/meslek_resimleri/dogalgaz.png", "5.0", "205"),
    MeslekModel("DUVAR KAĞIDI VE POSTER UYGULAMASI", "assets/meslek_resimleri/duvarkagidi.png", "4.7", "63"),
    MeslekModel("ELEKTRİK TESİSATI", "assets/meslek_resimleri/elektrik.png", "4.9", "270"),
    MeslekModel("EPOKSİ ZEMİN KAPLAMA", "assets/meslek_resimleri/epoksi.png", "4.8", "41"),
    MeslekModel("FERFORJE KORKULUK VE BAHÇE KAPISI", "assets/meslek_resimleri/ferforje.png", "4.6", "38"),
    MeslekModel("GERGİ TAVAN SİSTEMLERİ", "assets/meslek_resimleri/gergitavan.png", "4.7", "52"),
    MeslekModel("GÖMME DOLAP VE RAY DOLAP", "assets/meslek_resimleri/gomme.png", "4.9", "98"),
    MeslekModel("GÜNEŞ ENERJİSİ VE TERMOSİFON", "assets/meslek_resimleri/gunes.png", "4.8", "74"),
    MeslekModel("HAVUZ YAPIMI VE BAKIMI", "assets/meslek_resimleri/havuz.png", "5.0", "30"),
    MeslekModel("İTALYAN BOYA VE DEKORATİF SIVA", "assets/meslek_resimleri/italyan.png", "4.9", "25"),
    MeslekModel("ODA KAPISI VE ÇELİK KAPI", "assets/meslek_resimleri/kapi.png", "4.8", "130"),
    MeslekModel("KARTONPİYER, STROPİYER VE ÇITALAMA", "assets/meslek_resimleri/kartonpiyer.png", "4.7", "115"),
    MeslekModel("KLİMA MONTAJ , BAKIM VE GAZ DOLUMU", "assets/meslek_resimleri/klima.png", "4.9", "185"),
    MeslekModel("LAMİNAT , LAMİNE VE MASİF PARKE", "assets/meslek_resimleri/laminat.png", "4.9", "220"),
    MeslekModel("DIŞ CEPHE BOYA VE MANTOLAMA", "assets/meslek_resimleri/mantoloma.png", "4.8", "145"),
    MeslekModel("MARANGOZLUK VE MOBİLYA TAMİRİ", "assets/meslek_resimleri/marangoz.png", "4.7", "95"),
    MeslekModel("MERMER , GRANİT VE TRAVERTEN", "assets/meslek_resimleri/mermer.png", "4.9", "82"),
    MeslekModel("MUTFAK DOLABI VE TEZGAHI", "assets/meslek_resimleri/mutfak.png", "4.9", "160"),
    MeslekModel("SİNEKLİK VE PANJUR SİSTEMLERİ", "assets/meslek_resimleri/panjur.png", "4.7", "68"),
    MeslekModel("BAHÇE PEYZAJ VE ÇİM EKİMİ", "assets/meslek_resimleri/peyzaj.png", "4.8", "55"),
    MeslekModel("KONTEYNER, BUNGALOV VE PREFABRİK", "assets/meslek_resimleri/prefabrik.png", "4.9", "40"),
    MeslekModel("PVC DOĞRAMA", "assets/meslek_resimleri/pvc.png", "4.8", "190"),
    MeslekModel("SANDVİÇ PANEL VE ŞİNGIL KAPLAMA", "assets/meslek_resimleri/sandvic.png", "4.7", "35"),
    MeslekModel("FAYANS , SERAMİK VE KALEBODUR", "assets/meslek_resimleri/seramik.png", "4.9", "280"),
    MeslekModel("SIHHİ TESİSAT VE PİS SU TESİSATI", "assets/meslek_resimleri/sihhi.png", "5.0", "450"),
    MeslekModel("SİSTRE CİLA İŞLERİ", "assets/meslek_resimleri/sistre.png", "4.7", "48"),
    MeslekModel("OTAMATİK SULAMA SİSTEMLERİ", "assets/meslek_resimleri/sulama.png", "4.6", "22"),
    MeslekModel("TEMEL VE BODRUM SU YALITIMI", "assets/meslek_resimleri/temel.png", "4.9", "60"),
    MeslekModel("YERDEN ISITMA SİSTEMLERİ", "assets/meslek_resimleri/yerdenisitma.png", "4.8", "75"),
  ];
}