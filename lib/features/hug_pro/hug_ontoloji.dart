/// HUG PROJE MASTER v5.2 P0 FINAL FIX - CANONICAL LOCK
/// v5.1 korunuyor, sadece: rol getter temizlendi + duplicate uzmanlik/hizmet validator eklendi
/// YapiTuru.matches() korunuyor, unvanId mimari borcu v6 notu olarak tutuluyor

// ignore_for_file: constant_identifier_names

class YapiTuru {
  final String id;
  final String displayName;
  final String? parentId;
  final String kategori;
  const YapiTuru({required this.id, required this.displayName, this.parentId, required this.kategori});
}

class YapiTurleriMaster {
  static const List<YapiTuru> tumYapiTurleri = [
    const YapiTuru(id: 'KONUT', displayName: 'Konut', kategori: 'KONUT'),
    const YapiTuru(id: 'KONUT_MUSTAKIL', displayName: 'Müstakil Konut', parentId: 'KONUT', kategori: 'KONUT'),
    const YapiTuru(id: 'KONUT_VILLA', displayName: 'Villa', parentId: 'KONUT', kategori: 'KONUT'),
    const YapiTuru(id: 'KONUT_APARTMAN', displayName: 'Apartman', parentId: 'KONUT', kategori: 'KONUT'),
    const YapiTuru(id: 'KONUT_SITE', displayName: 'Site / Toplu Konut', parentId: 'KONUT', kategori: 'KONUT'),
    const YapiTuru(id: 'KONUT_REZIDANS', displayName: 'Rezidans', parentId: 'KONUT', kategori: 'KONUT'),
    const YapiTuru(id: 'KONUT_BUNGALOV', displayName: 'Bungalov', parentId: 'KONUT', kategori: 'KONUT'),
    const YapiTuru(id: 'TICARI', displayName: 'Ticari Yapı', kategori: 'TICARI'),
    const YapiTuru(id: 'TICARI_OFIS', displayName: 'Ofis', parentId: 'TICARI', kategori: 'TICARI'),
    const YapiTuru(id: 'TICARI_MAGAZA', displayName: 'Mağaza', parentId: 'TICARI', kategori: 'TICARI'),
    const YapiTuru(id: 'TICARI_AVM', displayName: 'AVM', parentId: 'TICARI', kategori: 'TICARI'),
    const YapiTuru(id: 'TICARI_RESTORAN', displayName: 'Restoran', parentId: 'TICARI', kategori: 'TICARI'),
    const YapiTuru(id: 'TICARI_KAFE', displayName: 'Kafe', parentId: 'TICARI', kategori: 'TICARI'),
    const YapiTuru(id: 'TICARI_OTEL', displayName: 'Otel', parentId: 'TICARI', kategori: 'TICARI'),
    const YapiTuru(id: 'TICARI_TURIZM', displayName: 'Turizm Tesisi', parentId: 'TICARI', kategori: 'TICARI'),
    const YapiTuru(id: 'TICARI_IS_MERKEZI', displayName: 'İş Merkezi', parentId: 'TICARI', kategori: 'TICARI'),
    const YapiTuru(id: 'TICARI_PLAZA', displayName: 'Plaza', parentId: 'TICARI', kategori: 'TICARI'),
    const YapiTuru(id: 'ENDUSTRIYEL', displayName: 'Endüstriyel Yapı', kategori: 'ENDUSTRIYEL'),
    const YapiTuru(id: 'ENDUSTRIYEL_FABRIKA', displayName: 'Fabrika', parentId: 'ENDUSTRIYEL', kategori: 'ENDUSTRIYEL'),
    const YapiTuru(id: 'ENDUSTRIYEL_URETIM', displayName: 'Üretim Tesisi', parentId: 'ENDUSTRIYEL', kategori: 'ENDUSTRIYEL'),
    const YapiTuru(id: 'ENDUSTRIYEL_DEPO', displayName: 'Depo', parentId: 'ENDUSTRIYEL', kategori: 'ENDUSTRIYEL'),
    const YapiTuru(id: 'ENDUSTRIYEL_HANGAR', displayName: 'Hangar', parentId: 'ENDUSTRIYEL', kategori: 'ENDUSTRIYEL'),
    const YapiTuru(id: 'ENDUSTRIYEL_LOJISTIK', displayName: 'Lojistik Merkezi', parentId: 'ENDUSTRIYEL', kategori: 'ENDUSTRIYEL'),
    const YapiTuru(id: 'ENDUSTRIYEL_ANTREPO', displayName: 'Antrepo', parentId: 'ENDUSTRIYEL', kategori: 'ENDUSTRIYEL'),
    const YapiTuru(id: 'ENDUSTRIYEL_SOGUK_DEPO', displayName: 'Soğuk Hava Deposu', parentId: 'ENDUSTRIYEL', kategori: 'ENDUSTRIYEL'),
    const YapiTuru(id: 'ENDUSTRIYEL_TESIS', displayName: 'Endüstriyel Tesis', parentId: 'ENDUSTRIYEL', kategori: 'ENDUSTRIYEL'),
    const YapiTuru(id: 'KAMU', displayName: 'Kamu Yapısı', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_OKUL', displayName: 'Okul', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_UNIVERSITE', displayName: 'Üniversite', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_HASTANE', displayName: 'Hastane', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_SAGLIK', displayName: 'Sağlık Tesisi', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_BELEDIYE', displayName: 'Belediye / Kamu Binası', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_ADLIYE', displayName: 'Adliye', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_KULTUR', displayName: 'Kültür Merkezi', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_MUZE', displayName: 'Müze', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_KUTUPHANE', displayName: 'Kütüphane', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'KAMU_SPOR', displayName: 'Spor Tesisi', parentId: 'KAMU', kategori: 'KAMU'),
    const YapiTuru(id: 'ALTYAPI', displayName: 'Altyapı', kategori: 'ALTYAPI'),
    const YapiTuru(id: 'ALTYAPI_YOL', displayName: 'Yol', parentId: 'ALTYAPI', kategori: 'ALTYAPI'),
    const YapiTuru(id: 'ALTYAPI_KOPRU', displayName: 'Köprü', parentId: 'ALTYAPI', kategori: 'ALTYAPI'),
    const YapiTuru(id: 'ALTYAPI_VIYADUK', displayName: 'Viyadük', parentId: 'ALTYAPI', kategori: 'ALTYAPI'),
    const YapiTuru(id: 'ALTYAPI_TUNEL', displayName: 'Tünel', parentId: 'ALTYAPI', kategori: 'ALTYAPI'),
    const YapiTuru(id: 'ALTYAPI_DEMIRYOLU', displayName: 'Demiryolu', parentId: 'ALTYAPI', kategori: 'ALTYAPI'),
    const YapiTuru(id: 'ALTYAPI_RAYLI', displayName: 'Raylı Sistem', parentId: 'ALTYAPI', kategori: 'ALTYAPI'),
    const YapiTuru(id: 'ALTYAPI_OTOPARK', displayName: 'Otopark', parentId: 'ALTYAPI', kategori: 'ALTYAPI'),
    const YapiTuru(id: 'ENERJI', displayName: 'Enerji Tesisi', kategori: 'ENERJI'),
    const YapiTuru(id: 'ENERJI_GES', displayName: 'GES', parentId: 'ENERJI', kategori: 'ENERJI'),
    const YapiTuru(id: 'ENERJI_RES', displayName: 'RES', parentId: 'ENERJI', kategori: 'ENERJI'),
    const YapiTuru(id: 'ENERJI_TRAFO', displayName: 'Trafo Merkezi', parentId: 'ENERJI', kategori: 'ENERJI'),
    const YapiTuru(id: 'ENERJI_SANTRAL', displayName: 'Enerji Santrali', parentId: 'ENERJI', kategori: 'ENERJI'),
    const YapiTuru(id: 'ENERJI_DEPOLAMA', displayName: 'Enerji Depolama Tesisi', parentId: 'ENERJI', kategori: 'ENERJI'),
    const YapiTuru(id: 'SU', displayName: 'Su / Çevre Yapısı', kategori: 'SU'),
    const YapiTuru(id: 'SU_ARITMA', displayName: 'Arıtma Tesisi', parentId: 'SU', kategori: 'SU'),
    const YapiTuru(id: 'SU_DEPO', displayName: 'Su Deposu', parentId: 'SU', kategori: 'SU'),
    const YapiTuru(id: 'SU_TERFI', displayName: 'Terfi Merkezi', parentId: 'SU', kategori: 'SU'),
    const YapiTuru(id: 'SISTEM', displayName: 'Yapı Sistemi', kategori: 'SISTEM'),
    const YapiTuru(id: 'SISTEM_BETONARME', displayName: 'Betonarme Yapı', parentId: 'SISTEM', kategori: 'SISTEM'),
    const YapiTuru(id: 'SISTEM_CELIK', displayName: 'Çelik Yapı', parentId: 'SISTEM', kategori: 'SISTEM'),
    const YapiTuru(id: 'SISTEM_HAFIF_CELIK', displayName: 'Hafif Çelik Yapı', parentId: 'SISTEM', kategori: 'SISTEM'),
    const YapiTuru(id: 'SISTEM_PREFABRIK', displayName: 'Prefabrik Yapı', parentId: 'SISTEM', kategori: 'SISTEM'),
    const YapiTuru(id: 'SISTEM_MODULER', displayName: 'Modüler Yapı', parentId: 'SISTEM', kategori: 'SISTEM'),
    const YapiTuru(id: 'SISTEM_AHSAP', displayName: 'Ahşap Yapı', parentId: 'SISTEM', kategori: 'SISTEM'),
    const YapiTuru(id: 'SISTEM_KARMA', displayName: 'Karma Sistem', parentId: 'SISTEM', kategori: 'SISTEM'),
  ];

  static YapiTuru? byId(String id) {
    try {
      return tumYapiTurleri.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  static bool isValid(String id) => byId(id) != null;

  static bool isDescendantOf(String childId, String parentId) {
    var current = byId(childId);
    final visited = <String>{};
    while (current != null && current.parentId != null) {
      if (!visited.add(current.id)) break;
      if (current.parentId == parentId) return true;
      current = byId(current.parentId!);
    }
    return false;
  }

  // KORUNUYOR - dogru mantik
  static bool matches(String selectedId, String queryId) {
    if (selectedId == queryId) return true;
    return isDescendantOf(selectedId, queryId);
  }
}

class PublicYetkiOzeti {
  final bool verified;
  final List<String> verifiedTypes;
  const PublicYetkiOzeti({required this.verified, required this.verifiedTypes});
  Map<String, dynamic> toJson() => {'verified': verified, 'verifiedTypes': verifiedTypes};
}

class PrivateYetkiBelge {
  final String id;
  final String belgeTuru;
  final String? belgeNo;
  final String? verenKurum;
  final DateTime? gecerlilikTarihi;
  final String dogrulamaDurumu;
  final bool aktifYetki;
  final DateTime? dogrulamaTarihi;
  final String? dogrulayanSistem;
  const PrivateYetkiBelge({required this.id, required this.belgeTuru, this.belgeNo, this.verenKurum, this.gecerlilikTarihi, required this.dogrulamaDurumu, required this.aktifYetki, this.dogrulamaTarihi, this.dogrulayanSistem});
  Map<String, dynamic> toJson() => {'id': id, 'belgeTuru': belgeTuru, 'belgeNo': belgeNo, 'verenKurum': verenKurum, 'gecerlilikTarihi': gecerlilikTarihi?.toIso8601String(), 'dogrulamaDurumu': dogrulamaDurumu, 'aktifYetki': aktifYetki};
}

enum HUGRoleType { PROJE, USTA }

class ProjeUstaSiniri {
  static const Set<String> hugProjeUnvanIds = {
    'MIMAR',
    'YAPI_MIMARI',
    'VILLA_MIMARI',
    'IC_MIMAR',
    'PEYZAJ_MIMARI',
    'RESTORASYON_UZMANI',
    'GORSELLISTIRME_UZMANI',
    'INSAAT_MUHENDISI',
    'MAKINE_MUHENDISI',
    'ELEKTRIK_MUHENDISI',
    'EE_MUHENDISI',
    'JEOLOJI_MUHENDISI',
    'JEOFIZIK_MUHENDISI',
    'HARITA_MUHENDISI',
    'CEVRE_MUHENDISI',
    'ENERJI_MUHENDISI',
    'ENDUSTRI_MUHENDISI',
    'PROJE_YONETICISI',
    'SANTIYE_SEFI',
    'TEKNIK_OFIS_SEFI',
    'BIM_KOORDINATORU',
    'YAPI_DENETIM_UZMANI',
    'KALITE_KONTROL_FIRMASI',
    'YAPI_LABORATUVARI',
    'YAPI_PERFORMANS_UZMANI',
    'ISG_UZMANI',
    'ISG_FIRMASI',
    'ENERJI_PERFORMANS_UZMANI',
    'ELEKTRIK_TAAHHUT_FIRMASI',
    'ELEKTRIK_SISTEMLERI_FIRMASI',
    'MEKANIK_TAAHHUT_FIRMASI',
    'CEPHE_FIRMASI',
    'CATI_FIRMASI',
    'YALITIM_FIRMASI',
    'AKUSTIK_FIRMASI',
    'YANGIN_YALITIM_FIRMASI',
    'CELIK_KONSTRUKSIYON_FIRMASI',
    'METAL_IMALAT_FIRMASI',
    'PREFABRIK_FIRMASI',
    'HAFIF_CELIK_FIRMASI',
    'MODULER_YAPI_FIRMASI',
    'MOBILYA_FIRMASI',
    'ZEMIN_KAPLAMA_FIRMASI',
    'ALCI_SIVA_FIRMASI',
    'ASMA_TAVAN_FIRMASI',
    'BOLME_SISTEMLERI_FIRMASI',
    'BOYA_FIRMASI',
    'DOGRAMACI_FIRMASI',
    'CAM_FIRMASI',
    'ALTYAPI_FIRMASI',
    'YOL_FIRMASI',
    'HAFRIYAT_FIRMASI',
    'IS_MAKINESI_FIRMASI',
    'VINC_FIRMASI',
    'BETON_POMPASI_FIRMASI',
    'PEYZAJ_UYGULAMA_FIRMASI',
    'GES_EPC_FIRMASI',
    'YOL_MUTEAHHIDI',
    'ENDUSTRIYEL_TESIS_MUTEAHHIDI',
    'ANA_YUKLENICI',
    'ALT_YUKLENICI',
    'YAPI_UYGULAMA_FIRMASI',
    'OZEL_YAPI_MUTEAHHIDI',
    'ASANSOR_FIRMASI',
  };
  static const Set<String> hugUstaUnvanIds = {
    'ELEKTRIK_USTASI',
    'KAYNAK_USTASI',
    'IS_MAKINESI_OPERATORU',
    'BOYACI',
    'SIVACI',
    'DUVARCI',
    'SERAMIKCI',
    'KALIPCI',
    'BETONCU',
  };
  static HUGRoleType? getRoleForUnvan(String unvanId) {
    if (hugProjeUnvanIds.contains(unvanId)) return HUGRoleType.PROJE;
    if (hugUstaUnvanIds.contains(unvanId)) return HUGRoleType.USTA;
    return null;
  }
}

class AnaDal {
  final String id;
  final String kod;
  final String ad;
  final List<AltDal> altDallar;
  const AnaDal({required this.id, required this.kod, required this.ad, required this.altDallar});
}

class AltDal {
  final String id;
  final String ad;
  final List<String> unvanIds;
  final List<String> uzmanlikIds;
  final List<String> hizmetIds;
  final List<String> onerilenYapiTuruIds;
  const AltDal({required this.id, required this.ad, required this.unvanIds, required this.uzmanlikIds, required this.hizmetIds, required this.onerilenYapiTuruIds});
}

// v6 NOTU: unvanId altinda kisi meslegi + firma tipi karisik
// v6'da PROFESYONEL TIP diye ayrilmali: Mimar vs Cephe Firmasi
// v5.2 icin degistirilmiyor, sadece not

class HugProMasterOntologyV5 {
  static const List<AnaDal> anaDallar = [
    const AnaDal(id: '01', kod: 'MIMARLIK_TASARIM', ad: 'MİMARLIK & TASARIM', altDallar: [
      const AltDal(id: '01.01', ad: 'Mimarlık', unvanIds: ['MIMAR', 'YAPI_MIMARI', 'VILLA_MIMARI'], uzmanlikIds: ['KONSEPT_TASARIM', 'MIMARI_TASARIM', 'AVAM_PROJE', 'RUHSAT_PROJESI', 'UYGULAMA_PROJESI', 'DETAY_PROJESI', 'BIM'], hizmetIds: ['KONSEPT_PROJE', 'AVAM_PROJE', 'RUHSAT_PROJESI_HIZ', 'UYGULAMA_PROJESI_HIZ', 'BIM_MODELLEME'], onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT', 'TICARI', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '01.02', ad: 'İç Mimarlık', unvanIds: ['IC_MIMAR'], uzmanlikIds: ['IC_MEKAN_TASARIMI', 'KONSEPT', 'UYGULAMA', 'MOBILYA_YERLESIMI', 'AYDINLATMA_TASARIMI'], hizmetIds: ['VILLA_IC_MIMARI', 'OFIS_TASARIMI', 'OTEL_IC_TASARIMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'TICARI_OFIS']),
      const AltDal(id: '01.03', ad: 'Peyzaj Mimarlığı', unvanIds: ['PEYZAJ_MIMARI'], uzmanlikIds: ['PEYZAJ_TASARIMI', 'BITKILENDIRME', 'SERT_ZEMIN', 'SULAMA_PROJE'], hizmetIds: ['PEYZAJ_PROJESI', 'BAHCE_TASARIMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT_SITE']),
      const AltDal(id: '01.04', ad: 'Restorasyon & Koruma', unvanIds: ['RESTORASYON_UZMANI'], uzmanlikIds: ['ROLOVE', 'RESTITUSYON', 'RESTORASYON', 'KORUMA'], hizmetIds: ['ROLOVE_PROJESI', 'RESTORASYON_PROJESI'], onerilenYapiTuruIds: ['KONUT', 'KAMU']),
      const AltDal(id: '01.05', ad: 'Görselleştirme', unvanIds: ['GORSELLISTIRME_UZMANI'], uzmanlikIds: ['MODELLEME_3D', 'RENDER', 'ANIMASYON', 'SANAL_TUR', 'VR', 'AR'], hizmetIds: ['DIS_CEPHE_RENDER', 'IC_MEKAN_RENDER'], onerilenYapiTuruIds: ['KONUT_VILLA', 'TICARI']),
    ]),
    const AnaDal(id: '02', kod: 'MUHENDISLIK', ad: 'MÜHENDİSLİK', altDallar: [
      const AltDal(id: '02.01', ad: 'İnşaat Mühendisliği', unvanIds: ['INSAAT_MUHENDISI'], uzmanlikIds: ['YAPI', 'STATIK', 'BETONARME', 'CELIK', 'DEPREM', 'GUCLENDIRME', 'GEOTEKNIK', 'TEMEL_MUHENDISLIGI', 'YAPI_DINAMIGI', 'YAPI_PERFORMANSI', 'KOPRU_MUHENDISLIGI', 'TUNEL_MUHENDISLIGI', 'ALTYAPI_MUHENDISLIGI'], hizmetIds: ['STATIK_PROJE', 'BETONARME_STATIK', 'CELIK_STATIK', 'DEPREM_ANALIZI', 'GUCLENDIRME_PROJESI', 'ISTINAT_DUVARI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'ALTYAPI_KOPRU', 'ALTYAPI_TUNEL']),
      const AltDal(id: '02.02', ad: 'Makine Mühendisliği', unvanIds: ['MAKINE_MUHENDISI'], uzmanlikIds: ['MEKANIK_TESISAT', 'HVAC', 'ISITMA', 'SOGUTMA', 'HAVALANDIRMA', 'SIHHI_TESISAT', 'YANGIN_TESISATI', 'DOGALGAZ', 'BUHAR_SISTEMLERI'], hizmetIds: ['MEKANIK_TESISAT_PROJESI', 'HVAC_PROJESI', 'YANGIN_TESISAT_PROJESI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'TICARI_OTEL']),
      const AltDal(id: '02.03', ad: 'Elektrik Mühendisliği', unvanIds: ['ELEKTRIK_MUHENDISI'], uzmanlikIds: ['ELEKTRIK_PROJESI', 'KUVVETLI_AKIM', 'ZAYIF_AKIM', 'AYDINLATMA', 'PANO', 'ENERJI', 'GES', 'TRAFO', 'JENERATOR'], hizmetIds: ['ELEKTRIK_PROJESI', 'AYDINLATMA_PROJESI', 'GES_PROJESI', 'TRAFO_PROJESI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'ENERJI_GES']),
      const AltDal(id: '02.04', ad: 'Elektrik-Elektronik', unvanIds: ['EE_MUHENDISI'], uzmanlikIds: ['OTOMASYON', 'KONTROL', 'BINA_OTOMASYONU', 'ENDUSTRIYEL_OTOMASYON', 'GUVENLIK_SISTEMLERI'], hizmetIds: ['BINA_OTOMASYONU_PROJESI', 'GUVENLIK_SISTEMI_PROJESI'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'TICARI_OFIS']),
      const AltDal(id: '02.05', ad: 'Jeoloji Mühendisliği', unvanIds: ['JEOLOJI_MUHENDISI'], uzmanlikIds: ['JEOLOJIK_ETUT', 'ZEMIN', 'SONDAJ', 'ZEMIN_IYILESTIRME', 'SEV', 'HEYELAN'], hizmetIds: ['JEOLOJIK_ETUT_RAPORU', 'ZEMIN_ETUDU', 'SONDAJ'], onerilenYapiTuruIds: ['KONUT', 'ALTYAPI_YOL']),
      const AltDal(id: '02.06', ad: 'Jeofizik Mühendisliği', unvanIds: ['JEOFIZIK_MUHENDISI'], uzmanlikIds: ['SISMIK', 'REZISTIVITE', 'YER_ARASTIRMALARI', 'ZEMIN_DINAMIKLERI', 'MIKROBOLGELEME'], hizmetIds: ['JEOFIZIK_ETUT', 'SISMIK_ETUT'], onerilenYapiTuruIds: ['KONUT', 'ALTYAPI']),
      const AltDal(id: '02.07', ad: 'Harita / Geomatik Mühendisliği', unvanIds: ['HARITA_MUHENDISI'], uzmanlikIds: ['ARAZI_OLCUMU', 'KADASTRO', 'APLIKASYON', 'PLANKOTE', 'HALIHAZIR_HARITA', 'FOTOGRAMETRI', 'GNSS', 'GIS', 'UCD_ARAZI_MODELLEME'], hizmetIds: ['APLIKASYON', 'PLANKOTE', 'HALIHAZIR_HARITA', 'DRONE_OLCUMU'], onerilenYapiTuruIds: ['KONUT']),
      const AltDal(id: '02.08', ad: 'Çevre Mühendisliği', unvanIds: ['CEVRE_MUHENDISI'], uzmanlikIds: ['CEVRE_PROJELERI', 'ATIK_YONETIMI', 'ATIK_SU', 'ARITMA', 'CED', 'EMISYON'], hizmetIds: ['CEVRE_DANISMANLIGI', 'CED_RAPORU'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'SU_ARITMA']),
      const AltDal(id: '02.09', ad: 'Enerji Sistemleri Mühendisliği', unvanIds: ['ENERJI_MUHENDISI'], uzmanlikIds: ['GES', 'ENERJI_VERIMLILIGI', 'ENERJI_YONETIMI', 'ENERJI_DEPOLAMA', 'YENILENEBILIR_ENERJI'], hizmetIds: ['GES_KURULUM', 'ENERJI_VERIMLILIK_RAPORU'], onerilenYapiTuruIds: ['ENERJI_GES', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '02.10', ad: 'Endüstri Mühendisliği', unvanIds: ['ENDUSTRI_MUHENDISI'], uzmanlikIds: ['PROJE_PLANLAMA', 'SUREC_YONETIMI', 'MALIYET', 'MALIYET_YONETIMI', 'VERIMLILIK', 'IS_AKISI', 'URETIM_PLANLAMA', 'LOJISTIK'], hizmetIds: ['PROJE_PLANLAMA', 'SUREC_IYILESTIRME', 'MALIYET_ANALIZI'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'ENDUSTRIYEL_LOJISTIK']),
    ]),
    const AnaDal(id: '03', kod: 'MUTEAHHITLIK_YAPIM', ad: 'MÜTEAHHİTLİK & YAPIM', altDallar: [
      const AltDal(id: '03.01', ad: 'Ana Yüklenici', unvanIds: ['ANA_YUKLENICI'], uzmanlikIds: ['ANAHTAR_TESLIM', 'GENEL_YAPIM', 'KONUT', 'VILLA', 'TICARI', 'ENDUSTRIYEL'], hizmetIds: ['ANAHTAR_TESLIM_YAPIM', 'VILLA_YAPIMI', 'FABRIKA_YAPIMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'TICARI_OTEL']),
      const AltDal(id: '03.02', ad: 'Alt Yüklenici', unvanIds: ['ALT_YUKLENICI'], uzmanlikIds: ['KABA_YAPI', 'INCE_YAPI', 'MEKANIK', 'ELEKTRIK', 'CEPHE'], hizmetIds: ['KABA_INSAAT', 'INCE_ISLER'], onerilenYapiTuruIds: ['KONUT', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '03.03', ad: 'Yapı Uygulama / Yapım', unvanIds: ['YAPI_UYGULAMA_FIRMASI'], uzmanlikIds: ['KABA_YAPI', 'INCE_YAPI', 'ANAHTAR_TESLIM'], hizmetIds: ['KABA_INSAAT', 'ANAHTAR_TESLIM_YAPIM'], onerilenYapiTuruIds: ['SISTEM_BETONARME', 'SISTEM_CELIK', 'SISTEM_PREFABRIK', 'SISTEM_AHSAP', 'KONUT_VILLA']),
      const AltDal(id: '03.04', ad: 'Özel Yapım', unvanIds: ['OZEL_YAPI_MUTEAHHIDI'], uzmanlikIds: ['VILLA', 'BUNGALOV', 'FABRIKA', 'DEPO', 'HANGAR'], hizmetIds: ['VILLA_YAPIMI', 'BUNGALOV_YAPIMI', 'DEPO_YAPIMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT_BUNGALOV', 'ENDUSTRIYEL_FABRIKA']),
    ]),
    const AnaDal(id: '04', kod: 'PROJE_SANTIYE', ad: 'PROJE & ŞANTİYE YÖNETİMİ', altDallar: [
      const AltDal(id: '04.01', ad: 'Proje Yönetimi', unvanIds: ['PROJE_YONETICISI'], uzmanlikIds: ['PROJE_PLANLAMA', 'IS_PROGRAMI', 'ZAMAN_YONETIMI', 'MALIYET_YONETIMI', 'RISK_YONETIMI'], hizmetIds: ['PROJE_YONETIM_DANISMANLIGI', 'IS_PROGRAMI_HAZIRLAMA'], onerilenYapiTuruIds: ['KONUT', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '04.02', ad: 'Şantiye Yönetimi', unvanIds: ['SANTIYE_SEFI'], uzmanlikIds: ['TEKNIK_YONETIM', 'SAHA_YONETIMI', 'IS_PROGRAMI'], hizmetIds: ['SANTIYE_YONETIMI', 'SAHA_ORGANIZASYONU'], onerilenYapiTuruIds: ['KONUT', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '04.03', ad: 'Teknik Ofis', unvanIds: ['TEKNIK_OFIS_SEFI'], uzmanlikIds: ['METRAJ', 'KESIF', 'HAKEDIS', 'BIRIM_FIYAT', 'MALIYET', 'IHALE_DOSYASI', 'AS_BUILT'], hizmetIds: ['METRAJ', 'KESIF', 'HAKEDIS', 'IHALE_DOSYASI'], onerilenYapiTuruIds: ['KONUT', 'ENDUSTRIYEL_FABRIKA', 'KAMU']),
      const AltDal(id: '04.04', ad: 'BIM', unvanIds: ['BIM_KOORDINATORU'], uzmanlikIds: ['BIM_YONETIMI', 'BIM_KOORDINASYONU', 'BIM_MODELLEME', 'CLASH_DETECTION', 'BIM_4D', 'BIM_5D'], hizmetIds: ['BIM_YONETIMI', 'BIM_KOORDINASYONU', 'CLASH_DETECTION'], onerilenYapiTuruIds: ['KONUT', 'ENDUSTRIYEL_FABRIKA', 'TICARI_OTEL']),
      const AltDal(id: '04.05', ad: 'Sözleşme & Ticari Yönetim', unvanIds: ['PROJE_YONETICISI'], uzmanlikIds: ['SOZLESME_YONETIMI', 'HAKEDIS', 'TASERON_YONETIMI', 'SATIN_ALMA', 'TEKNIK_SATIN_ALMA', 'MALIYET_KONTROLU'], hizmetIds: ['SOZLESME_YONETIMI', 'TASERON_YONETIMI'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'KAMU']),
    ]),
    const AnaDal(id: '05', kod: 'YAPI_DENETIM_KONTROL', ad: 'YAPI DENETİM & KONTROL', altDallar: [
      const AltDal(id: '05.01', ad: 'Yapı Denetim', unvanIds: ['YAPI_DENETIM_UZMANI'], uzmanlikIds: ['YAPI_DENETIMI', 'PROJE_KONTROLU', 'SAHA_KONTROLU', 'TEKNIK_KONTROL'], hizmetIds: ['YAPI_DENETIMI', 'PROJE_KONTROLU'], onerilenYapiTuruIds: ['KONUT', 'KONUT_VILLA']),
      const AltDal(id: '05.02', ad: 'Kalite Kontrol', unvanIds: ['KALITE_KONTROL_FIRMASI'], uzmanlikIds: ['QA_QC', 'BETON', 'CELIK', 'KAYNAK', 'MALZEME', 'UYGULAMA_KALITESI'], hizmetIds: ['KALITE_KONTROL', 'BETON_KONTROLU'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'SISTEM_CELIK']),
      const AltDal(id: '05.03', ad: 'Laboratuvar', unvanIds: ['YAPI_LABORATUVARI'], uzmanlikIds: ['BETON_TESTLERI', 'ZEMIN_TESTLERI', 'MALZEME_TESTLERI'], hizmetIds: ['BETON_TESTI', 'ZEMIN_TESTI'], onerilenYapiTuruIds: ['KONUT', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '05.04', ad: 'Yapı Performansı', unvanIds: ['YAPI_PERFORMANS_UZMANI'], uzmanlikIds: ['DEPREM_PERFORMANS_ANALIZI', 'YAPI_SAGLIGI', 'MEVCUT_YAPI_ANALIZI'], hizmetIds: ['DEPREM_PERFORMANS_ANALIZI', 'MEVCUT_YAPI_ANALIZI'], onerilenYapiTuruIds: ['KONUT', 'KONUT_VILLA']),
      const AltDal(id: '05.05', ad: 'İSG', unvanIds: ['ISG_UZMANI', 'ISG_FIRMASI'], uzmanlikIds: ['IS_GUVENLIGI', 'SANTIYE_ISG', 'RISK_ANALIZI', 'ACIL_DURUM_PLANI'], hizmetIds: ['ISG_DANISMANLIGI', 'RISK_ANALIZI'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'ALTYAPI']),
      const AltDal(id: '05.06', ad: 'Enerji & Uygunluk', unvanIds: ['ENERJI_PERFORMANS_UZMANI'], uzmanlikIds: ['ENERJI_PERFORMANSI', 'ENERJI_KIMLIK_BELGESI', 'TEKNIK_UYGUNLUK'], hizmetIds: ['ENERJI_KIMLIK_BELGESI', 'TEKNIK_UYGUNLUK_RAPORU'], onerilenYapiTuruIds: ['KONUT', 'TICARI_OFIS']),
    ]),
    const AnaDal(id: '06', kod: 'HARITA_ARAZI', ad: 'HARİTA & ARAZİ', altDallar: [
      const AltDal(id: '06.01', ad: 'Harita', unvanIds: ['HARITA_MUHENDISI'], uzmanlikIds: ['HALIHAZIR_HARITA', 'ARAZI_OLCUMU', 'PLANKOTE', 'APLIKASYON', 'KOTLANDIRMA'], hizmetIds: ['HALIHAZIR_HARITA', 'ARAZI_OLCUMU', 'PLANKOTE'], onerilenYapiTuruIds: ['KONUT']),
      const AltDal(id: '06.02', ad: 'Kadastro', unvanIds: ['HARITA_MUHENDISI'], uzmanlikIds: ['KADASTRO', 'PARSEL', 'PARSELASYON', 'BIRLESTIRME', 'AYIRMA'], hizmetIds: ['KADASTRO_ISLEMI', 'PARSELASYON', 'IFRAZ'], onerilenYapiTuruIds: ['KONUT']),
      const AltDal(id: '06.03', ad: 'Arazi & Ölçüm', unvanIds: ['HARITA_MUHENDISI'], uzmanlikIds: ['GNSS', 'TOTAL_STATION', 'DRONE_OLCUMU', 'FOTOGRAMETRI', 'UCD_TARAMA'], hizmetIds: ['GNSS_OLCUMU', 'DRONE_OLCUMU', 'UCD_TARAMA'], onerilenYapiTuruIds: ['KONUT', 'ALTYAPI']),
      const AltDal(id: '06.04', ad: 'GIS', unvanIds: ['HARITA_MUHENDISI'], uzmanlikIds: ['CBS', 'SAYISAL_HARITA', 'ARAZI_VERISI', 'UCD_ARAZI_MODELI'], hizmetIds: ['CBS_HIZMETI', 'SAYISAL_HARITA'], onerilenYapiTuruIds: ['KONUT', 'ALTYAPI']),
    ]),
    const AnaDal(id: '07', kod: 'YAPI_SISTEMLERI_TESISAT', ad: 'YAPI SİSTEMLERİ & TESİSAT', altDallar: [
      const AltDal(id: '07.01', ad: 'Elektrik Sistemleri', unvanIds: ['ELEKTRIK_TAAHHUT_FIRMASI', 'ELEKTRIK_SISTEMLERI_FIRMASI'], uzmanlikIds: ['KUVVETLI_AKIM', 'ZAYIF_AKIM', 'AYDINLATMA', 'PANO', 'JENERATOR', 'UPS', 'DATA', 'KAMERA', 'YANGIN_ALGILAMA', 'KARTLI_GECIS'], hizmetIds: ['ELEKTRIK_TESISAT', 'PANO_KURULUM', 'KAMERA_SISTEMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'TICARI_OTEL']),
      const AltDal(id: '07.02', ad: 'Mekanik Sistemler', unvanIds: ['MEKANIK_TAAHHUT_FIRMASI'], uzmanlikIds: ['HVAC', 'ISITMA', 'SOGUTMA', 'HAVALANDIRMA', 'KLIMA', 'SIHHI_TESISAT', 'POMPA', 'YANGIN_TESISATI'], hizmetIds: ['HVAC_KURULUM', 'KLIMA', 'SIHHI_TESISAT', 'YANGIN_TESISATI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '07.03', ad: 'Doğalgaz', unvanIds: ['MEKANIK_TAAHHUT_FIRMASI'], uzmanlikIds: ['DOGALGAZ_PROJESI', 'DOGALGAZ_TESISATI', 'ENDUSTRIYEL_DOGALGAZ'], hizmetIds: ['DOGALGAZ_PROJESI', 'DOGALGAZ_TESISATI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '07.04', ad: 'Asansör', unvanIds: ['ASANSOR_FIRMASI'], uzmanlikIds: ['ASANSOR', 'YUK_ASANSORU', 'PANORAMIK_ASANSOR', 'YURUYEN_MERDIVEN', 'PLATFORM', 'BAKIM'], hizmetIds: ['ASANSOR_KURULUM', 'ASANSOR_BAKIM'], onerilenYapiTuruIds: ['KONUT', 'TICARI', 'TICARI_OFIS']),
      const AltDal(id: '07.05', ad: 'Otomasyon', unvanIds: ['OTOMASYON_FIRMASI'], uzmanlikIds: ['BINA_OTOMASYONU', 'ENDUSTRIYEL_OTOMASYON', 'AKILLI_EV', 'AKILLI_BINA', 'ENERJI_OTOMASYONU'], hizmetIds: ['AKILLI_EV_SISTEMI', 'BINA_OTOMASYONU'], onerilenYapiTuruIds: ['KONUT_VILLA', 'TICARI_OFIS', 'ENDUSTRIYEL_FABRIKA']),
    ]),
    const AnaDal(id: '08', kod: 'CEPHE_CATI_YALITIM', ad: 'CEPHE, ÇATI & YALITIM', altDallar: [
      const AltDal(id: '08.01', ad: 'Cephe', unvanIds: ['CEPHE_FIRMASI'], uzmanlikIds: ['GIYDIRME_CEPHE', 'ALUMINYUM_CEPHE', 'CAM_CEPHE', 'KOMPOZIT_CEPHE', 'DOGAL_TAS_CEPHE', 'SERAMIK_CEPHE', 'PREKAST_CEPHE'], hizmetIds: ['GIYDIRME_CEPHE', 'CEPHE_KAPLAMA'], onerilenYapiTuruIds: ['TICARI', 'TICARI_OFIS', 'TICARI_OTEL']),
      const AltDal(id: '08.02', ad: 'Çatı', unvanIds: ['CATI_FIRMASI'], uzmanlikIds: ['CELIK_CATI', 'KENET_CATI', 'PANEL_CATI', 'KIREMIT_CATI', 'SHINGLE', 'MEMBRAN_CATI', 'TERAS_CATI', 'ENDUSTRIYEL_CATI'], hizmetIds: ['CATI_KAPLAMA', 'CATI_YAPIMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_DEPO', 'ENDUSTRIYEL_HANGAR']),
      const AltDal(id: '08.03', ad: 'Su Yalıtımı', unvanIds: ['YALITIM_FIRMASI'], uzmanlikIds: ['TEMEL_YALITIMI', 'TERAS', 'CATI_YALITIM', 'ISLAK_HACIM', 'HAVUZ', 'SU_DEPOSU'], hizmetIds: ['SU_YALITIMI', 'TEMEL_YALITIMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT']),
      const AltDal(id: '08.04', ad: 'Isı Yalıtımı', unvanIds: ['YALITIM_FIRMASI'], uzmanlikIds: ['MANTOLAMA', 'CATI_YALITIMI', 'TEMEL_YALITIMI', 'ENDUSTRIYEL_YALITIM'], hizmetIds: ['MANTOLAMA', 'ISI_YALITIMI'], onerilenYapiTuruIds: ['KONUT', 'KONUT_VILLA']),
      const AltDal(id: '08.05', ad: 'Ses Yalıtımı', unvanIds: ['AKUSTIK_FIRMASI'], uzmanlikIds: ['YAPI_AKUSTIGI', 'IC_MEKAN_AKUSTIGI', 'ENDUSTRIYEL_AKUSTIK'], hizmetIds: ['SES_YALITIMI', 'AKUSTIK_DUZENLEME'], onerilenYapiTuruIds: ['TICARI_OFIS', 'KAMU_KULTUR']),
      const AltDal(id: '08.06', ad: 'Yangın Yalıtımı', unvanIds: ['YANGIN_YALITIM_FIRMASI'], uzmanlikIds: ['YANGIN_DURDURUCU', 'YANGIN_IZOLASYONU', 'YANGIN_KAPLAMA'], hizmetIds: ['YANGIN_YALITIMI'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'TICARI']),
    ]),
    const AnaDal(id: '09', kod: 'CELIK_METAL_PREFABRIK', ad: 'ÇELİK, METAL & PREFABRİK', altDallar: [
      const AltDal(id: '09.01', ad: 'Çelik Yapı', unvanIds: ['CELIK_KONSTRUKSIYON_FIRMASI'], uzmanlikIds: ['CELIK_KONSTRUKSIYON', 'CELIK_IMALAT', 'CELIK_MONTAJ', 'ENDUSTRIYEL_CELIK', 'DEPO', 'HANGAR', 'CELIK_MERDIVEN', 'CELIK_CATI'], hizmetIds: ['CELIK_KONSTRUKSIYON', 'CELIK_IMALAT', 'CELIK_MONTAJ', 'HANGAR_YAPIMI'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'ENDUSTRIYEL_DEPO', 'SISTEM_CELIK']),
      const AltDal(id: '09.02', ad: 'Kaynak & Metal', unvanIds: ['METAL_IMALAT_FIRMASI', 'CELIK_KONSTRUKSIYON_FIRMASI'], uzmanlikIds: ['ARK_KAYNAGI', 'GAZALTI_KAYNAGI', 'TIG', 'MIG_MAG', 'METAL_IMALAT', 'OZEL_METAL_IMALAT'], hizmetIds: ['KAYNAK', 'METAL_IMALAT'], onerilenYapiTuruIds: ['SISTEM_CELIK', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '09.03', ad: 'Prefabrik', unvanIds: ['PREFABRIK_FIRMASI'], uzmanlikIds: ['PREFABRIK_YAPI', 'BETONARME_PREFABRIK', 'PREFABRIK_KONUT', 'PREFABRIK_TICARI'], hizmetIds: ['PREFABRIK_YAPI', 'PREFABRIK_KONUT'], onerilenYapiTuruIds: ['SISTEM_PREFABRIK', 'KONUT']),
      const AltDal(id: '09.04', ad: 'Hafif Çelik', unvanIds: ['HAFIF_CELIK_FIRMASI'], uzmanlikIds: ['HAFIF_CELIK_KONUT', 'HAFIF_CELIK_VILLA', 'HAFIF_CELIK_TICARI'], hizmetIds: ['HAFIF_CELIK_YAPI', 'HAFIF_CELIK_VILLA'], onerilenYapiTuruIds: ['SISTEM_HAFIF_CELIK', 'KONUT_VILLA', 'KONUT_BUNGALOV']),
      const AltDal(id: '09.05', ad: 'Modüler Yapı', unvanIds: ['MODULER_YAPI_FIRMASI'], uzmanlikIds: ['MODULER_KONUT', 'MODULER_OFIS', 'MODULER_TICARI', 'KONTEYNER_YAPILAR'], hizmetIds: ['MODULER_YAPI', 'KONTEYNER_YAPI'], onerilenYapiTuruIds: ['SISTEM_MODULER', 'TICARI_OFIS']),
    ]),
    const AnaDal(id: '10', kod: 'IC_MEKAN_IMALAT', ad: 'İÇ MEKAN & YAPI İMALATLARI', altDallar: [
      const AltDal(id: '10.01', ad: 'Mobilya & Ahşap', unvanIds: ['MOBILYA_FIRMASI'], uzmanlikIds: ['MUTFAK', 'BANYO_MOBILYASI', 'GARDROP', 'SABIT_MOBILYA', 'OZEL_MOBILYA', 'AHSAP_IMALAT'], hizmetIds: ['MUTFAK_DOLABI', 'BANYO_DOLABI', 'GARDROP'], onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT']),
      const AltDal(id: '10.02', ad: 'Zemin', unvanIds: ['ZEMIN_KAPLAMA_FIRMASI'], uzmanlikIds: ['SERAMIK', 'GRANIT', 'MERMER', 'DOGAL_TAS', 'PARKE', 'LAMINAT', 'EPOKSI', 'ENDUSTRIYEL_ZEMIN'], hizmetIds: ['SERAMIK_KAPLAMA', 'PARKE_DOSEME', 'MERMER_KAPLAMA'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '10.03', ad: 'Duvar & Tavan', unvanIds: ['ALCI_SIVA_FIRMASI', 'ASMA_TAVAN_FIRMASI', 'BOLME_SISTEMLERI_FIRMASI'], uzmanlikIds: ['ALCI', 'SIVA', 'ALCI_LEVHA', 'ALCIPAN', 'ASMA_TAVAN', 'BOLME_SISTEMLERI'], hizmetIds: ['ALCI', 'ALCIPAN', 'ASMA_TAVAN'], onerilenYapiTuruIds: ['KONUT', 'TICARI_OFIS']),
      const AltDal(id: '10.04', ad: 'Boya', unvanIds: ['BOYA_FIRMASI'], uzmanlikIds: ['IC_CEPHE', 'DIS_CEPHE', 'DEKORATIF_BOYA', 'ENDUSTRIYEL_BOYA'], hizmetIds: ['IC_CEPHE_BOYA', 'DIS_CEPHE_BOYA'], onerilenYapiTuruIds: ['KONUT', 'KONUT_VILLA']),
      const AltDal(id: '10.05', ad: 'Kapı & Pencere', unvanIds: ['DOGRAMACI_FIRMASI'], uzmanlikIds: ['PVC', 'ALUMINYUM', 'AHSAP', 'CAM', 'IC_KAPI', 'DIS_KAPI', 'OTOMATIK_KAPI'], hizmetIds: ['PVC_PENCERE', 'KAPI_MONTAJI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT']),
      const AltDal(id: '10.06', ad: 'Cam', unvanIds: ['CAM_FIRMASI'], uzmanlikIds: ['TEMPERLI_CAM', 'LAMINE_CAM', 'DUSAKABIN', 'CAM_BOLME', 'CEPHE_CAMI'], hizmetIds: ['CAM_BOLME', 'DUSAKABIN'], onerilenYapiTuruIds: ['TICARI_OFIS', 'KONUT_VILLA']),
      const AltDal(id: '10.07', ad: 'Akustik', unvanIds: ['AKUSTIK_FIRMASI'], uzmanlikIds: ['AKUSTIK_PANEL', 'SES_YALITIM_UYGULAMASI', 'AKUSTIK_TAVAN', 'STUDYO_AKUSTIGI'], hizmetIds: ['AKUSTIK_PANEL_MONTAJI'], onerilenYapiTuruIds: ['TICARI_OFIS', 'KAMU_KULTUR']),
    ]),
    const AnaDal(id: '11', kod: 'ALTYAPI_PEYZAJ', ad: 'ALTYAPI & PEYZAJ', altDallar: [
      const AltDal(id: '11.01', ad: 'Altyapı', unvanIds: ['ALTYAPI_FIRMASI'], uzmanlikIds: ['KANALIZASYON', 'YAGMUR_SUYU', 'ICME_SUYU', 'DRENAJ', 'ALTYAPI_HATLARI'], hizmetIds: ['KANALIZASYON', 'YAGMUR_SUYU_HATTI'], onerilenYapiTuruIds: ['ALTYAPI', 'KONUT_SITE']),
      const AltDal(id: '11.02', ad: 'Yol & Saha', unvanIds: ['YOL_FIRMASI'], uzmanlikIds: ['YOL', 'OTOPARK', 'SAHA_BETONU', 'ASFALT', 'BORDUR', 'KALDIRIM'], hizmetIds: ['YOL_YAPIMI', 'OTOPARK_YAPIMI', 'ASFALT'], onerilenYapiTuruIds: ['ALTYAPI_YOL', 'ALTYAPI_OTOPARK']),
      const AltDal(id: '11.03', ad: 'Hafriyat', unvanIds: ['HAFRIYAT_FIRMASI'], uzmanlikIds: ['KAZI', 'DOLGU', 'TESVIYE', 'ARAZI_DUZENLEME', 'HAFRIYAT_TASIMA'], hizmetIds: ['KAZI', 'DOLGU', 'TESVIYE'], onerilenYapiTuruIds: ['KONUT', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '11.04', ad: 'İş Makineleri', unvanIds: ['IS_MAKINESI_FIRMASI', 'VINC_FIRMASI', 'BETON_POMPASI_FIRMASI'], uzmanlikIds: ['EKSKAVATOR', 'LOADER', 'DOZER', 'GREYDER', 'SILINDIR', 'VINC', 'BETON_POMPASI', 'BETON_SANTRALI'], hizmetIds: ['EKSKAVATOR_KIRALAMA', 'VINC_KIRALAMA', 'BETON_POMPASI_KIRALAMA'], onerilenYapiTuruIds: ['ALTYAPI', 'ENDUSTRIYEL_FABRIKA']),
      const AltDal(id: '11.05', ad: 'Peyzaj Uygulama', unvanIds: ['PEYZAJ_UYGULAMA_FIRMASI'], uzmanlikIds: ['PEYZAJ_UYGULAMASI', 'BITKILENDIRME', 'SULAMA', 'SERT_ZEMIN', 'BAHCE', 'ACIK_ALAN', 'OTOMATIK_SULAMA'], hizmetIds: ['PEYZAJ_UYGULAMA', 'BITKILENDIRME', 'SULAMA_SISTEMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT_SITE', 'TICARI_OTEL']),
    ]),
    const AnaDal(id: '12', kod: 'OZEL_PROJELER', ad: 'ÖZEL PROJELER', altDallar: [
      const AltDal(id: '12.01', ad: 'Ulaştırma', unvanIds: ['YOL_MUTEAHHIDI'], uzmanlikIds: ['YOL', 'KOPRU', 'VIYADUK', 'TUNEL', 'DEMIRYOLU', 'RAYLI_SISTEM'], hizmetIds: ['YOL_YAPIMI', 'KOPRU_YAPIMI', 'TUNEL_YAPIMI'], onerilenYapiTuruIds: ['ALTYAPI_YOL', 'ALTYAPI_KOPRU', 'ALTYAPI_TUNEL', 'ALTYAPI_DEMIRYOLU']),
      const AltDal(id: '12.02', ad: 'Enerji Tesisleri', unvanIds: ['GES_EPC_FIRMASI'], uzmanlikIds: ['GES', 'TRAFO_MERKEZI', 'ENERJI_DEPOLAMA', 'ENERJI_SANTRALI'], hizmetIds: ['GES_ANAHTAR_TESLIM', 'TRAFO_MERKEZI_KURULUM'], onerilenYapiTuruIds: ['ENERJI_GES', 'ENERJI_TRAFO', 'ENERJI_SANTRAL']),
      const AltDal(id: '12.03', ad: 'Endüstriyel Tesisler', unvanIds: ['ENDUSTRIYEL_TESIS_MUTEAHHIDI'], uzmanlikIds: ['FABRIKA', 'URETIM_TESISI', 'PROSES_TESISI', 'ENDUSTRIYEL_HAT', 'ENDUSTRIYEL_BORULAMA'], hizmetIds: ['FABRIKA_KURULUM', 'URETIM_TESISI_KURULUM', 'ENDUSTRIYEL_HAT_KURULUM'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'ENDUSTRIYEL_URETIM', 'ENDUSTRIYEL_TESIS']),
      const AltDal(id: '12.04', ad: 'Su & Arıtma', unvanIds: ['ENDUSTRIYEL_TESIS_MUTEAHHIDI'], uzmanlikIds: ['ICME_SUYU_TESISI', 'ATIKSU_ARITMA', 'ARITMA_TESISI', 'SU_DEPOSU', 'TERFI_MERKEZI'], hizmetIds: ['ARITMA_TESISI_KURULUM', 'SU_DEPOSU_YAPIMI'], onerilenYapiTuruIds: ['SU_ARITMA', 'SU_DEPO', 'SU_TERFI']),
      const AltDal(id: '12.05', ad: 'Lojistik & Depolama', unvanIds: ['ENDUSTRIYEL_TESIS_MUTEAHHIDI'], uzmanlikIds: ['DEPO', 'LOJISTIK_MERKEZI', 'ANTREPO', 'SOGUK_HAVA_DEPOSU'], hizmetIds: ['DEPO_YAPIMI', 'LOJISTIK_MERKEZI_YAPIMI'], onerilenYapiTuruIds: ['ENDUSTRIYEL_DEPO', 'ENDUSTRIYEL_LOJISTIK', 'ENDUSTRIYEL_ANTREPO']),
      const AltDal(id: '12.06', ad: 'Madencilik & Özel Saha', unvanIds: ['ENDUSTRIYEL_TESIS_MUTEAHHIDI'], uzmanlikIds: ['MADEN_SAHASI', 'OCAK', 'SONDAJ', 'KAZISIZ_TEKNOLOJILER', 'YATAY_DELGI'], hizmetIds: ['MADEN_SAHASI_HAZIRLAMA', 'SONDAJ', 'YATAY_DELGI'], onerilenYapiTuruIds: ['ALTYAPI', 'SU']),
    ]),
  ];
}

class ProfesyonelDalSecimi {
  final String anaDalId;
  final String altDalId;
  final String unvanId;
  final List<String> uzmanlikIds;
  final List<String> hizmetIds;
  const ProfesyonelDalSecimi({required this.anaDalId, required this.altDalId, required this.unvanId, required this.uzmanlikIds, required this.hizmetIds});
  Map<String, dynamic> toJson() => {'anaDalId': anaDalId, 'altDalId': altDalId, 'unvanId': unvanId, 'uzmanlikIds': uzmanlikIds, 'hizmetIds': hizmetIds};
}

class ProfessionalProfileV5 {
  final List<ProfesyonelDalSecimi> dallar;
  final List<String> yapiTuruIds;
  final PublicYetkiOzeti publicYetki;
  final List<PrivateYetkiBelge> privateYetkiBelgeleri;
  final List<String> calismaAlanlari;
  const ProfessionalProfileV5({required this.dallar, required this.yapiTuruIds, required this.publicYetki, required this.privateYetkiBelgeleri, required this.calismaAlanlari});

  // FIX P0 #2: rol temizlendi - sadece tekil ise doner, karisik PROJE+USTA -> null
  // Sadece PROJE -> PROJE, sadece USTA -> USTA, karisik -> null, bos/bilinmeyen -> null
  HUGRoleType? get rol {
    final roller = this.roller;
    if (roller == null || roller.length != 1) return null;
    return roller.first;
  }

  Set<HUGRoleType>? get roller {
    final set = <HUGRoleType>{};
    for (final dal in dallar) {
      final role = ProjeUstaSiniri.getRoleForUnvan(dal.unvanId);
      if (role == null) return null;
      set.add(role);
    }
    return set.isEmpty ? null : set;
  }

  Map<String, dynamic> toJsonPublic() => {'dallar': dallar.map((e) => e.toJson()).toList(), 'yapiTuruIds': yapiTuruIds, 'publicYetki': publicYetki.toJson(), 'calismaAlanlari': calismaAlanlari, 'rol': rol?.name, 'roller': roller?.map((e) => e.name).toList()};
}

class HugProOntologyValidator {
  static const int expectedAnaDalCount = 12;
  static const Set<String> expectedAnaDalIds = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'};

  static AnaDal? findAnaDal(String id) {
    try {
      return HugProMasterOntologyV5.anaDallar.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  static AltDal? findAltDal(String anaDalId, String altDalId) {
    final anaDal = findAnaDal(anaDalId);
    if (anaDal == null) return null;
    try {
      return anaDal.altDallar.firstWhere((e) => e.id == altDalId);
    } catch (_) {
      return null;
    }
  }

  static List<String> validateDalSecimi(ProfesyonelDalSecimi secim) {
    final hatalar = <String>[];
    final anaDal = findAnaDal(secim.anaDalId);
    if (anaDal == null) {
      hatalar.add('Bilinmeyen AnaDal: ${secim.anaDalId}');
      return hatalar;
    }
    final altDal = findAltDal(secim.anaDalId, secim.altDalId);
    if (altDal == null) {
      hatalar.add('${secim.anaDalId} -> bilinmeyen AltDal: ${secim.altDalId}');
      return hatalar;
    }
    if (!altDal.unvanIds.contains(secim.unvanId)) hatalar.add('${secim.altDalId} -> unvan bu AltDal\'a ait degil: ${secim.unvanId}');
    for (final id in secim.uzmanlikIds) {
      if (!altDal.uzmanlikIds.contains(id)) hatalar.add('${secim.altDalId} -> uzmanlik bu AltDal\'a ait degil: $id');
    }
    for (final id in secim.hizmetIds) {
      if (!altDal.hizmetIds.contains(id)) hatalar.add('${secim.altDalId} -> hizmet bu AltDal\'a ait degil: $id');
    }
    // duplicate uzmanlik/hizmet icinde
    _checkUnique(secim.uzmanlikIds, '${secim.altDalId} uzmanlik', hatalar);
    _checkUnique(secim.hizmetIds, '${secim.altDalId} hizmet', hatalar);
    return hatalar;
  }

  static List<String> validateProfile(ProfessionalProfileV5 profile) {
    final hatalar = <String>[];
    for (final dal in profile.dallar) {
      hatalar.addAll(validateDalSecimi(dal));
    }
    for (final yapiId in profile.yapiTuruIds) {
      if (!YapiTurleriMaster.isValid(yapiId)) hatalar.add('Profile -> bilinmeyen YapiTuru: $yapiId');
    }
    for (final dal in profile.dallar) {
      if (ProjeUstaSiniri.getRoleForUnvan(dal.unvanId) == null) hatalar.add('Profile -> unvan icin rol tanimlanmamis: ${dal.unvanId}');
    }
    final seen = <String>{};
    for (final dal in profile.dallar) {
      final key = '${dal.anaDalId}|${dal.altDalId}|${dal.unvanId}';
      if (!seen.add(key)) hatalar.add('Profile duplicate dal secimi: $key');
    }
    // duplicate uzmanlik/hizmet profile seviyesinde de kontrol edildi (validateDalSecimi icinde)
    return hatalar;
  }

  static List<String> validate() {
    final hatalar = <String>[];
    if (HugProMasterOntologyV5.anaDallar.length != expectedAnaDalCount) {
      hatalar.add('Ana Dal sayisi ${HugProMasterOntologyV5.anaDallar.length}, beklenen $expectedAnaDalCount');
    }
    final actualAnaDalIds = HugProMasterOntologyV5.anaDallar.map((e) => e.id).toSet();
    if (actualAnaDalIds.length != expectedAnaDalIds.length || !actualAnaDalIds.containsAll(expectedAnaDalIds)) {
      hatalar.add('Ana Dal ID seti 01-12 uyusmuyor. Mevcut: $actualAnaDalIds');
    }
    final anaDalIdRegex = RegExp(r'^[0-9]{2}$');
    final altDalIdRegex = RegExp(r'^[0-9]{2}\.[0-9]{2}$');
    final canonicalIdRegex = RegExp(r'^[A-Z0-9_]+$');
    for (final anaDal in HugProMasterOntologyV5.anaDallar) {
      if (!anaDalIdRegex.hasMatch(anaDal.id)) hatalar.add('AnaDal ID format: ${anaDal.id}');
      if (!canonicalIdRegex.hasMatch(anaDal.kod)) hatalar.add('AnaDal kod casing: ${anaDal.kod}');
    }
    for (final altDal in HugProMasterOntologyV5.anaDallar.expand((e) => e.altDallar)) {
      if (!altDalIdRegex.hasMatch(altDal.id)) hatalar.add('AltDal ID format: ${altDal.id}');
    }
    for (final yapi in YapiTurleriMaster.tumYapiTurleri) {
      if (!canonicalIdRegex.hasMatch(yapi.id)) hatalar.add('YapiTuru ID casing: ${yapi.id}');
    }
    _checkUnique(HugProMasterOntologyV5.anaDallar.map((e) => e.id), 'AnaDal', hatalar);
    _checkUnique(HugProMasterOntologyV5.anaDallar.expand((e) => e.altDallar).map((e) => e.id), 'AltDal', hatalar);
    _checkUnique(YapiTurleriMaster.tumYapiTurleri.map((e) => e.id), 'YapiTuru', hatalar);
    for (final yapi in YapiTurleriMaster.tumYapiTurleri) {
      if (yapi.parentId != null && !YapiTurleriMaster.isValid(yapi.parentId!)) {
        hatalar.add('${yapi.id} -> bilinmeyen parentId: ${yapi.parentId}');
      }
    }
    for (final yapi in YapiTurleriMaster.tumYapiTurleri) {
      final visited = <String>{};
      var currentParentId = yapi.parentId;
      while (currentParentId != null) {
        if (!visited.add(currentParentId)) {
          hatalar.add('YapiTuru cycle: ${yapi.id} -> $currentParentId');
          break;
        }
        final parent = YapiTurleriMaster.byId(currentParentId);
        if (parent == null) break;
        currentParentId = parent.parentId;
        if (visited.length > 100) {
          hatalar.add('YapiTuru derin/cycle supheli: ${yapi.id}');
          break;
        }
      }
    }
    for (final anaDal in HugProMasterOntologyV5.anaDallar) {
      for (final altDal in anaDal.altDallar) {
        for (final yapiTuruId in altDal.onerilenYapiTuruIds) {
          if (!YapiTurleriMaster.isValid(yapiTuruId)) hatalar.add('${altDal.id} -> bilinmeyen onerilenYapiTuru: $yapiTuruId');
        }
        for (final id in [...altDal.unvanIds, ...altDal.uzmanlikIds, ...altDal.hizmetIds]) {
          if (!canonicalIdRegex.hasMatch(id)) hatalar.add('${altDal.id} -> ID casing: $id');
        }
        for (final unvanId in altDal.unvanIds) {
          if (ProjeUstaSiniri.getRoleForUnvan(unvanId) == null) hatalar.add('${altDal.id} -> rol tanimsiz unvan: $unvanId');
        }
      }
    }
    return hatalar;
  }

  static void _checkUnique(Iterable<String> ids, String label, List<String> hatalar) {
    final seen = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) hatalar.add('$label duplicate ID: $id');
    }
  }
}
