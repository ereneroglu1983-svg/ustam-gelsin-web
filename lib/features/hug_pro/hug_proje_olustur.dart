/// hug_proje_olustur.dart
/// HUG PROJE - BRIEF ENGINE v1.3.2 - CANONICAL LOCK
/// TAMAMLANDI YOK - 6 ASAMA - FALLBACK [] - FULL KATALOG

import 'hug_ontoloji.dart' as master;

typedef YapiTuru = master.YapiTuru;
typedef ProfesyonelDalSecimi = master.ProfesyonelDalSecimi;

enum ProjeAsamasi {
  FIKIR,
  TASARIM,
  TEKNIK_PROJELER,
  RUHSAT,
  TEKLIF,
  UYGULAMA;

  String get displayName {
    switch (this) {
      case ProjeAsamasi.FIKIR: return 'Fikir';
      case ProjeAsamasi.TASARIM: return 'Tasarim';
      case ProjeAsamasi.TEKNIK_PROJELER: return 'Teknik Projeler';
      case ProjeAsamasi.RUHSAT: return 'Ruhsat';
      case ProjeAsamasi.TEKLIF: return 'Teklif';
      case ProjeAsamasi.UYGULAMA: return 'Uygulama';
    }
  }
}

enum OlcekAlaniTuru { ARSA_ALANI, YAPI_ALANI, KAPALI_ALAN, KAT_SAYISI, KURULU_GUC, BIRIM_SAYISI }

class ProjeTuruKaynagi {
  static const Set<String> secilebilirIds = {
    'KONUT_MUSTAKIL','KONUT_VILLA','KONUT_APARTMAN','KONUT_SITE','KONUT_REZIDANS','KONUT_BUNGALOV',
    'TICARI_OFIS','TICARI_MAGAZA','TICARI_AVM','TICARI_RESTORAN','TICARI_OTEL',
    'ENDUSTRIYEL_FABRIKA','ENDUSTRIYEL_URETIM','ENDUSTRIYEL_DEPO','ENDUSTRIYEL_HANGAR',
    'ENERJI_GES','ENERJI_RES','ENERJI_TRAFO',
    'SISTEM_BETONARME','SISTEM_CELIK','SISTEM_PREFABRIK',
    'ALTYAPI','SU_ARITMA',
  };
  static List<YapiTuru> get secilebilirTurler {
    return master.YapiTurleriMaster.tumYapiTurleri.where((e) => secilebilirIds.contains(e.id)).toList();
  }
}

class ProjeIhtiyacMapping {
  final String id; final String displayName; final String aciklama; final List<ProfesyonelDalSecimi> baglanti; final String grup;
  const ProjeIhtiyacMapping({required this.id, required this.displayName, required this.aciklama, required this.baglanti, this.grup='ANA'});
  List<String> validate() { final h=<String>[]; for(final b in baglanti) h.addAll(master.HugProOntologyValidator.validateDalSecimi(b)); return h; }
}

class IhtiyacKatalogu {
  static final Map<String, ProjeIhtiyacMapping> katalog = {
    'MIMARI_PROJE': ProjeIhtiyacMapping(id:'MIMARI_PROJE', displayName:'Mimari Proje', aciklama:'Konsept', baglanti:[ProfesyonelDalSecimi(anaDalId:'01', altDalId:'01.01', unvanId:'MIMAR', uzmanlikIds:['KONSEPT_TASARIM'], hizmetIds:['KONSEPT_PROJE'])]),
    'STATIK_PROJE': ProjeIhtiyacMapping(id:'STATIK_PROJE', displayName:'Statik', aciklama:'Tasiyici', baglanti:[ProfesyonelDalSecimi(anaDalId:'02', altDalId:'02.01', unvanId:'INSAAT_MUHENDISI', uzmanlikIds:['STATIK','BETONARME'], hizmetIds:['STATIK_PROJE'])]),
    'ELEKTRIK_PROJE': ProjeIhtiyacMapping(id:'ELEKTRIK_PROJE', displayName:'Elektrik', aciklama:'Elektrik', baglanti:[ProfesyonelDalSecimi(anaDalId:'02', altDalId:'02.03', unvanId:'ELEKTRIK_MUHENDISI', uzmanlikIds:['ELEKTRIK_PROJESI'], hizmetIds:['ELEKTRIK_PROJESI'])]),
    'MEKANIK_PROJE': ProjeIhtiyacMapping(id:'MEKANIK_PROJE', displayName:'Mekanik', aciklama:'HVAC', baglanti:[ProfesyonelDalSecimi(anaDalId:'02', altDalId:'02.02', unvanId:'MAKINE_MUHENDISI', uzmanlikIds:['MEKANIK_TESISAT'], hizmetIds:['MEKANIK_TESISAT_PROJESI'])]),
    'ZEMIN_ETUDU': ProjeIhtiyacMapping(id:'ZEMIN_ETUDU', displayName:'Zemin', aciklama:'Zemin', baglanti:[ProfesyonelDalSecimi(anaDalId:'02', altDalId:'02.05', unvanId:'JEOLOJI_MUHENDISI', uzmanlikIds:['ZEMIN'], hizmetIds:['ZEMIN_ETUDU'])]),
    'GES_PROJE': ProjeIhtiyacMapping(id:'GES_PROJE', displayName:'GES', aciklama:'GES', baglanti:[ProfesyonelDalSecimi(anaDalId:'12', altDalId:'12.02', unvanId:'GES_EPC_FIRMASI', uzmanlikIds:['GES'], hizmetIds:['GES_ANAHTAR_TESLIM'])]),
    'IC_MIMARI': ProjeIhtiyacMapping(id:'IC_MIMARI', displayName:'Ic Mimarlik', aciklama:'Ic', baglanti:[ProfesyonelDalSecimi(anaDalId:'01', altDalId:'01.02', unvanId:'IC_MIMAR', uzmanlikIds:['IC_MEKAN_TASARIMI'], hizmetIds:['VILLA_IC_MIMARI'])], grup:'DIGER'),
    'PEYZAJ': ProjeIhtiyacMapping(id:'PEYZAJ', displayName:'Peyzaj', aciklama:'Peyzaj', baglanti:[ProfesyonelDalSecimi(anaDalId:'01', altDalId:'01.03', unvanId:'PEYZAJ_MIMARI', uzmanlikIds:['PEYZAJ_TASARIMI'], hizmetIds:['PEYZAJ_PROJESI'])], grup:'DIGER'),
    'PEYZAJ_UYGULAMA': ProjeIhtiyacMapping(id:'PEYZAJ_UYGULAMA', displayName:'Peyzaj Uyg', aciklama:'Peyzaj', baglanti:[ProfesyonelDalSecimi(anaDalId:'11', altDalId:'11.05', unvanId:'PEYZAJ_UYGULAMA_FIRMASI', uzmanlikIds:['PEYZAJ_UYGULAMASI'], hizmetIds:['PEYZAJ_UYGULAMA'])], grup:'DIGER'),
    'HARITA': ProjeIhtiyacMapping(id:'HARITA', displayName:'Harita', aciklama:'Harita', baglanti:[ProfesyonelDalSecimi(anaDalId:'06', altDalId:'06.01', unvanId:'HARITA_MUHENDISI', uzmanlikIds:['ARAZI_OLCUMU'], hizmetIds:['HALIHAZIR_HARITA'])], grup:'DIGER'),
    'PROJE_YONETIMI': ProjeIhtiyacMapping(id:'PROJE_YONETIMI', displayName:'Proje Yonetimi', aciklama:'Yonetim', baglanti:[ProfesyonelDalSecimi(anaDalId:'04', altDalId:'04.01', unvanId:'PROJE_YONETICISI', uzmanlikIds:['PROJE_PLANLAMA'], hizmetIds:['PROJE_YONETIM_DANISMANLIGI'])], grup:'DIGER'),
    'BIM': ProjeIhtiyacMapping(id:'BIM', displayName:'BIM', aciklama:'BIM', baglanti:[ProfesyonelDalSecimi(anaDalId:'04', altDalId:'04.04', unvanId:'BIM_KOORDINATORU', uzmanlikIds:['BIM_YONETIMI'], hizmetIds:['BIM_YONETIMI'])], grup:'DIGER'),
    'YAPI_DENETIM': ProjeIhtiyacMapping(id:'YAPI_DENETIM', displayName:'Yapi Denetim', aciklama:'Denetim', baglanti:[ProfesyonelDalSecimi(anaDalId:'05', altDalId:'05.01', unvanId:'YAPI_DENETIM_UZMANI', uzmanlikIds:['YAPI_DENETIMI'], hizmetIds:['YAPI_DENETIMI'])], grup:'DIGER'),
    'CEPHE': ProjeIhtiyacMapping(id:'CEPHE', displayName:'Cephe', aciklama:'Cephe', baglanti:[ProfesyonelDalSecimi(anaDalId:'08', altDalId:'08.01', unvanId:'CEPHE_FIRMASI', uzmanlikIds:['GIYDIRME_CEPHE'], hizmetIds:['GIYDIRME_CEPHE'])], grup:'DIGER'),
    'CATI': ProjeIhtiyacMapping(id:'CATI', displayName:'Cati', aciklama:'Cati', baglanti:[ProfesyonelDalSecimi(anaDalId:'08', altDalId:'08.02', unvanId:'CATI_FIRMASI', uzmanlikIds:['CELIK_CATI'], hizmetIds:['CATI_YAPIMI'])], grup:'DIGER'),
    'YALITIM': ProjeIhtiyacMapping(id:'YALITIM', displayName:'Yalitim', aciklama:'Yalitim', baglanti:[ProfesyonelDalSecimi(anaDalId:'08', altDalId:'08.03', unvanId:'YALITIM_FIRMASI', uzmanlikIds:['TEMEL_YALITIMI'], hizmetIds:['SU_YALITIMI'])], grup:'DIGER'),
    'CELIK_YAPI': ProjeIhtiyacMapping(id:'CELIK_YAPI', displayName:'Celik Yapi', aciklama:'Celik', baglanti:[ProfesyonelDalSecimi(anaDalId:'09', altDalId:'09.01', unvanId:'CELIK_KONSTRUKSIYON_FIRMASI', uzmanlikIds:['CELIK_KONSTRUKSIYON'], hizmetIds:['CELIK_KONSTRUKSIYON'])], grup:'DIGER'),
    'MUTEAHHIT': ProjeIhtiyacMapping(id:'MUTEAHHIT', displayName:'Muteahhit', aciklama:'Muteahhit', baglanti:[ProfesyonelDalSecimi(anaDalId:'03', altDalId:'03.01', unvanId:'ANA_YUKLENICI', uzmanlikIds:['ANAHTAR_TESLIM'], hizmetIds:['ANAHTAR_TESLIM_YAPIM'])], grup:'DIGER'),
    'ALTYAPI': ProjeIhtiyacMapping(id:'ALTYAPI', displayName:'Altyapi', aciklama:'Altyapi', baglanti:[ProfesyonelDalSecimi(anaDalId:'11', altDalId:'11.01', unvanId:'ALTYAPI_FIRMASI', uzmanlikIds:['KANALIZASYON'], hizmetIds:['KANALIZASYON'])], grup:'DIGER'),
  };
  static bool isValidId(String id) => katalog.containsKey(id);
  static List<String> validateAll() {
    final h=<String>[];
    for(final e in katalog.entries){
      if(e.key!=e.value.id) h.add('key/id uyusmazligi '+e.key);
      h.addAll(e.value.validate().map((x)=>e.key+' -> '+x));
    }
    return h;
  }
}

class IhtiyacSablonlari {
  static final Map<String, Map<ProjeAsamasi, List<String>>> _map = {
    'KONUT_VILLA': {
      ProjeAsamasi.FIKIR: ['MIMARI_PROJE','STATIK_PROJE','ELEKTRIK_PROJE','MEKANIK_PROJE','ZEMIN_ETUDU','IC_MIMARI','PEYZAJ','HARITA','PROJE_YONETIMI','BIM','MUTEAHHIT'],
      ProjeAsamasi.TASARIM: ['MIMARI_PROJE','IC_MIMARI','PEYZAJ','BIM'],
      ProjeAsamasi.TEKNIK_PROJELER: ['STATIK_PROJE','ELEKTRIK_PROJE','MEKANIK_PROJE','ZEMIN_ETUDU','HARITA'],
      ProjeAsamasi.RUHSAT: ['MIMARI_PROJE','YAPI_DENETIM'],
      ProjeAsamasi.TEKLIF: ['MUTEAHHIT','CEPHE','CATI','YALITIM','IC_MIMARI','PEYZAJ_UYGULAMA','ALTYAPI'],
      ProjeAsamasi.UYGULAMA: ['MUTEAHHIT','YAPI_DENETIM','PROJE_YONETIMI','BIM'],
    },
    'ENDUSTRIYEL_FABRIKA': {
      ProjeAsamasi.FIKIR: ['MIMARI_PROJE','STATIK_PROJE','CELIK_YAPI','ZEMIN_ETUDU','MEKANIK_PROJE','ELEKTRIK_PROJE','ALTYAPI','PROJE_YONETIMI','BIM'],
      ProjeAsamasi.TASARIM: ['MIMARI_PROJE','CELIK_YAPI','BIM'],
      ProjeAsamasi.TEKNIK_PROJELER: ['STATIK_PROJE','CELIK_YAPI','MEKANIK_PROJE','ELEKTRIK_PROJE','ZEMIN_ETUDU'],
      ProjeAsamasi.RUHSAT: ['MIMARI_PROJE','YAPI_DENETIM'],
      ProjeAsamasi.TEKLIF: ['CELIK_YAPI','MUTEAHHIT','ALTYAPI','CEPHE','CATI'],
      ProjeAsamasi.UYGULAMA: ['MUTEAHHIT','YAPI_DENETIM','PROJE_YONETIMI'],
    },
    'ENERJI_GES': {
      ProjeAsamasi.FIKIR: ['GES_PROJE','STATIK_PROJE','ELEKTRIK_PROJE','ZEMIN_ETUDU','PROJE_YONETIMI'],
      ProjeAsamasi.TASARIM: ['GES_PROJE','STATIK_PROJE'],
      ProjeAsamasi.TEKNIK_PROJELER: ['GES_PROJE','STATIK_PROJE','ELEKTRIK_PROJE'],
      ProjeAsamasi.RUHSAT: ['GES_PROJE'],
      ProjeAsamasi.TEKLIF: ['GES_PROJE','CELIK_YAPI','MUTEAHHIT'],
      ProjeAsamasi.UYGULAMA: ['GES_PROJE','MUTEAHHIT','YAPI_DENETIM'],
    },
  };
  static List<ProjeIhtiyacMapping> getOnerilenIhtiyaclar({required String yapiTuruId, required ProjeAsamasi asama}) {
    if(_map.containsKey(yapiTuruId) && _map[yapiTuruId]!.containsKey(asama)){
      return _map[yapiTuruId]![asama]!.map((id)=>IhtiyacKatalogu.katalog[id]).whereType<ProjeIhtiyacMapping>().toList();
    }
    if(_map.containsKey(yapiTuruId) && _map[yapiTuruId]!.containsKey(ProjeAsamasi.FIKIR)){
      return _map[yapiTuruId]![ProjeAsamasi.FIKIR]!.map((id)=>IhtiyacKatalogu.katalog[id]).whereType<ProjeIhtiyacMapping>().toList();
    }
    return const [];
  }
  static List<String> validateAll() {
    final h=<String>[];
    h.addAll(IhtiyacKatalogu.validateAll());
    for(final yapiEntry in _map.entries){
      if(!master.YapiTurleriMaster.isValid(yapiEntry.key)) h.add('Bilinmeyen YapiTuru '+yapiEntry.key);
      for(final asamaEntry in yapiEntry.value.entries){
        for(final id in asamaEntry.value){
          if(!IhtiyacKatalogu.isValidId(id)) h.add(yapiEntry.key+'/'+asamaEntry.key.name+' -> '+id);
        }
      }
    }
    return h;
  }
}

class ProjeBrief {
  final String id; final String yapiTuruId; final ProjeAsamasi asama; final List<String> ihtiyacIds;
  const ProjeBrief({required this.id, required this.yapiTuruId, required this.asama, required this.ihtiyacIds});
  List<ProjeIhtiyacMapping> get secilen => ihtiyacIds.map((id)=>IhtiyacKatalogu.katalog[id]).whereType<ProjeIhtiyacMapping>().toList();
  List<ProjeIhtiyacMapping> get onerilen => IhtiyacSablonlari.getOnerilenIhtiyaclar(yapiTuruId:yapiTuruId, asama:asama);
  List<ProfesyonelDalSecimi> get eslesen => secilen.expand((e)=>e.baglanti).toList();
  List<String> validate() {
    final hatalar=<String>[];
    if(!master.YapiTurleriMaster.isValid(yapiTuruId)) hatalar.add('Bilinmeyen YapiTuru: '+yapiTuruId);
    final gorulen=<String>{};
    for(final id in ihtiyacIds){
      if(!gorulen.add(id)) hatalar.add('Duplicate ihtiyacId: '+id);
      if(!IhtiyacKatalogu.isValidId(id)) hatalar.add('Bilinmeyen ihtiyacId: '+id);
    }
    for(final dal in eslesen) hatalar.addAll(master.HugProOntologyValidator.validateDalSecimi(dal));
    final izinli = onerilen.map((e)=>e.id).toSet();
    for(final id in ihtiyacIds){
      if(!izinli.contains(id) && IhtiyacKatalogu.isValidId(id)) hatalar.add('Ihtiyac bu proje/asama icin tanimli degil: '+id);
    }
    return hatalar;
  }
}
