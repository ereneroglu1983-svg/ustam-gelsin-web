// HUG PROJE - Profesyonel SEO Sayfalari - SUNUM KATMANI
// TEK DOGRULUK KAYNAGI: hug_pro_master_v5_2_P0_FINAL_FIX.dart (MASTER v5.2)
// Bu dosya BAGIMSIZ taksonomi DEGILDIR. Ontolojiyi degistirmez, kopyalamaz, genisletmez.
// Her sayfa yalnizca MASTER v5.2'deki canonical ID'lere referans verir:
// AnaDal.id (01-12) + AltDal.id (01.01 vb) + Unvan ID + Uzmanlik IDs + Hizmet IDs + onerilenYapiTuruIds
// relatedProjectTypes gibi elle yazilmis, ontolojiden bagimsiz iliski listesi YOKTUR.
// Ontolojide olmayan ID veya iliski UYDURULMAMISTIR. Uzmanlik/Hizmet/YapiTuru listeleri
// MASTER v5.2'deki AltDal tanimindan aynen alinmistir.
//
// AYRI BOYUTLAR - KARSITIRMA:
// - YapiTuru: MASTER v5.2 YapiTurleriMaster'daki yapi tipi boyutu (KONUT, KONUT_VILLA, TICARI_OFIS, ENERJI_GES vb).
//   Bu dosyadaki onerilenYapiTuruIds SADECE bu boyutu ifade eder.
// - Proje Turu: Proje sahibi ihtiyac boyutu (kat karsiligi insaat, kentsel donusum vb) AYRI bir boyuttur.
//   Bu dosyada proje turu tanimlanmaz, YapiTuru ile karistirilmaz. Proje turleri ayri dosyada tutulur.
// YapiTuru.matches() mantigi (parent + descendant) MASTER'da korunur, burada tekrar tanimlanmaz.

export type ProfesyonelSeoSayfasi = {
  // SEO sunum - pageName/title/description Turkce karakterli, seoSlug ASCII
  seoSlug: string
  pageName: string
  title: string
  description: string
  // Canonical ontoloji referanslari - MASTER v5.2
  anaDalId: string
  anaDalKod: string
  altDalId: string
  unvanId: string
  // Asagidakiler MASTER v5.2 AltDal tanimindan aynen alinir, elle yazilmaz
  uzmanlikIds: string[]
  hizmetIds: string[]
  onerilenYapiTuruIds: string[]
}

export const profesyonelSeoSayfalari: ProfesyonelSeoSayfasi[] = [
  {
    seoSlug: 'mimar',
    pageName: 'Mimar',
    title: 'Mimar | HUG PROJE',
    description: 'Proje tasarımı, avan proje, ruhsat projesi ve uygulama projesi için mimarlarla eşleşin.',
    anaDalId: '01',
    anaDalKod: 'MIMARLIK_TASARIM',
    altDalId: '01.01',
    unvanId: 'MIMAR',
    uzmanlikIds: ['KONSEPT_TASARIM', 'MIMARI_TASARIM', 'AVAM_PROJE', 'RUHSAT_PROJESI', 'UYGULAMA_PROJESI', 'DETAY_PROJESI', 'BIM'],
    hizmetIds: ['KONSEPT_PROJE', 'AVAM_PROJE', 'RUHSAT_PROJESI_HIZ', 'UYGULAMA_PROJESI_HIZ', 'BIM_MODELLEME'],
    onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT', 'TICARI', 'ENDUSTRIYEL_FABRIKA'],
  },
  {
    seoSlug: 'ic-mimar',
    pageName: 'İç Mimar',
    title: 'İç Mimar | HUG PROJE',
    description: 'Konut, ofis ve otel için iç mekân tasarımı, konsept ve uygulama için iç mimarlarla eşleşin.',
    anaDalId: '01',
    anaDalKod: 'MIMARLIK_TASARIM',
    altDalId: '01.02',
    unvanId: 'IC_MIMAR',
    uzmanlikIds: ['IC_MEKAN_TASARIMI', 'KONSEPT', 'UYGULAMA', 'MOBILYA_YERLESIMI', 'AYDINLATMA_TASARIMI'],
    hizmetIds: ['VILLA_IC_MIMARI', 'OFIS_TASARIMI', 'OTEL_IC_TASARIMI'],
    onerilenYapiTuruIds: ['KONUT_VILLA', 'TICARI_OFIS'],
  },
  {
    seoSlug: 'peyzaj-mimari',
    pageName: 'Peyzaj Mimarı',
    title: 'Peyzaj Mimarı | HUG PROJE',
    description: 'Site, villa ve otel için peyzaj tasarımı, bitkilendirme ve dış mekân düzenlemesi.',
    anaDalId: '01',
    anaDalKod: 'MIMARLIK_TASARIM',
    altDalId: '01.03',
    unvanId: 'PEYZAJ_MIMARI',
    uzmanlikIds: ['PEYZAJ_TASARIMI', 'BITKILENDIRME', 'SERT_ZEMIN', 'SULAMA_PROJE'],
    hizmetIds: ['PEYZAJ_PROJESI', 'BAHCE_TASARIMI'],
    onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT_SITE'],
  },
  {
    seoSlug: 'insaat-muhendisi',
    pageName: 'İnşaat Mühendisi',
    title: 'İnşaat Mühendisi | HUG PROJE',
    description: 'Statik proje, betonarme, çelik, deprem ve güçlendirme için inşaat mühendisleriyle eşleşin.',
    anaDalId: '02',
    anaDalKod: 'MUHENDISLIK',
    altDalId: '02.01',
    unvanId: 'INSAAT_MUHENDISI',
    uzmanlikIds: ['YAPI', 'STATIK', 'BETONARME', 'CELIK', 'DEPREM', 'GUCLENDIRME', 'GEOTEKNIK', 'TEMEL_MUHENDISLIGI', 'YAPI_DINAMIGI', 'YAPI_PERFORMANSI', 'KOPRU_MUHENDISLIGI', 'TUNEL_MUHENDISLIGI', 'ALTYAPI_MUHENDISLIGI'],
    hizmetIds: ['STATIK_PROJE', 'BETONARME_STATIK', 'CELIK_STATIK', 'DEPREM_ANALIZI', 'GUCLENDIRME_PROJESI', 'ISTINAT_DUVARI'],
    onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'ALTYAPI_KOPRU', 'ALTYAPI_TUNEL'],
  },
  {
    seoSlug: 'makine-muhendisi',
    pageName: 'Makine Mühendisi',
    title: 'Makine Mühendisi | HUG PROJE',
    description: 'Mekanik tesisat, HVAC, ısıtma, soğutma ve yangın tesisatı için makine mühendisleriyle eşleşin.',
    anaDalId: '02',
    anaDalKod: 'MUHENDISLIK',
    altDalId: '02.02',
    unvanId: 'MAKINE_MUHENDISI',
    uzmanlikIds: ['MEKANIK_TESISAT', 'HVAC', 'ISITMA', 'SOGUTMA', 'HAVALANDIRMA', 'SIHHI_TESISAT', 'YANGIN_TESISATI', 'DOGALGAZ', 'BUHAR_SISTEMLERI'],
    hizmetIds: ['MEKANIK_TESISAT_PROJESI', 'HVAC_PROJESI', 'YANGIN_TESISAT_PROJESI'],
    onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'TICARI_OTEL'],
  },
  {
    seoSlug: 'elektrik-muhendisi',
    pageName: 'Elektrik Mühendisi',
    title: 'Elektrik Mühendisi | HUG PROJE',
    description: 'Elektrik projesi, kuvvetli akım, zayıf akım ve GES için elektrik mühendisleriyle eşleşin.',
    anaDalId: '02',
    anaDalKod: 'MUHENDISLIK',
    altDalId: '02.03',
    unvanId: 'ELEKTRIK_MUHENDISI',
    uzmanlikIds: ['ELEKTRIK_PROJESI', 'KUVVETLI_AKIM', 'ZAYIF_AKIM', 'AYDINLATMA', 'PANO', 'ENERJI', 'GES', 'TRAFO', 'JENERATOR'],
    hizmetIds: ['ELEKTRIK_PROJESI', 'AYDINLATMA_PROJESI', 'GES_PROJESI', 'TRAFO_PROJESI'],
    onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'ENERJI_GES'],
  },
  {
    seoSlug: 'jeoloji-muhendisi',
    pageName: 'Jeoloji Mühendisi',
    title: 'Jeoloji Mühendisi | HUG PROJE',
    description: 'Jeolojik etüt, zemin etüdü ve sondaj için jeoloji mühendisleriyle eşleşin.',
    anaDalId: '02',
    anaDalKod: 'MUHENDISLIK',
    altDalId: '02.05',
    unvanId: 'JEOLOJI_MUHENDISI',
    uzmanlikIds: ['JEOLOJIK_ETUT', 'ZEMIN', 'SONDAJ', 'ZEMIN_IYILESTIRME', 'SEV', 'HEYELAN'],
    hizmetIds: ['JEOLOJIK_ETUT_RAPORU', 'ZEMIN_ETUDU', 'SONDAJ'],
    onerilenYapiTuruIds: ['KONUT', 'ALTYAPI_YOL'],
  },
  {
    seoSlug: 'harita-muhendisi',
    pageName: 'Harita Mühendisi',
    title: 'Harita Mühendisi | HUG PROJE',
    description: 'Arazi ölçümü, kadastro, aplikasyon ve hâlihazır harita için harita mühendisleriyle eşleşin.',
    anaDalId: '02',
    anaDalKod: 'MUHENDISLIK',
    altDalId: '02.07',
    unvanId: 'HARITA_MUHENDISI',
    uzmanlikIds: ['ARAZI_OLCUMU', 'KADASTRO', 'APLIKASYON', 'PLANKOTE', 'HALIHAZIR_HARITA', 'FOTOGRAMETRI', 'GNSS', 'GIS', 'UCD_ARAZI_MODELLEME'],
    hizmetIds: ['APLIKASYON', 'PLANKOTE', 'HALIHAZIR_HARITA', 'DRONE_OLCUMU'],
    onerilenYapiTuruIds: ['KONUT'],
  },
  {
    seoSlug: 'ana-yuklenici',
    pageName: 'Ana Yüklenici',
    title: 'Ana Yüklenici | HUG PROJE',
    description: 'Anahtar teslim, villa ve fabrika yapımı için ana yüklenicilerle eşleşin.',
    anaDalId: '03',
    anaDalKod: 'MUTEAHHITLIK_YAPIM',
    altDalId: '03.01',
    unvanId: 'ANA_YUKLENICI',
    uzmanlikIds: ['ANAHTAR_TESLIM', 'GENEL_YAPIM', 'KONUT', 'VILLA', 'TICARI', 'ENDUSTRIYEL'],
    hizmetIds: ['ANAHTAR_TESLIM_YAPIM', 'VILLA_YAPIMI', 'FABRIKA_YAPIMI'],
    onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'TICARI_OTEL'],
  },
  {
    seoSlug: 'proje-yoneticisi',
    pageName: 'Proje Yöneticisi',
    title: 'Proje Yöneticisi | HUG PROJE',
    description: 'Proje planlama, iş programı, maliyet ve risk yönetimi için proje yöneticileriyle eşleşin.',
    anaDalId: '04',
    anaDalKod: 'PROJE_SANTIYE',
    altDalId: '04.01',
    unvanId: 'PROJE_YONETICISI',
    uzmanlikIds: ['PROJE_PLANLAMA', 'IS_PROGRAMI', 'ZAMAN_YONETIMI', 'MALIYET_YONETIMI', 'RISK_YONETIMI'],
    hizmetIds: ['PROJE_YONETIM_DANISMANLIGI', 'IS_PROGRAMI_HAZIRLAMA'],
    onerilenYapiTuruIds: ['KONUT', 'ENDUSTRIYEL_FABRIKA'],
  },
  {
    seoSlug: 'yapi-denetim-uzmani',
    pageName: 'Yapı Denetim Uzmanı',
    title: 'Yapı Denetim Uzmanı | HUG PROJE',
    description: 'Yapı denetimi, proje kontrolü ve saha kontrolü için yapı denetim uzmanlarıyla eşleşin.',
    anaDalId: '05',
    anaDalKod: 'YAPI_DENETIM_KONTROL',
    altDalId: '05.01',
    unvanId: 'YAPI_DENETIM_UZMANI',
    uzmanlikIds: ['YAPI_DENETIMI', 'PROJE_KONTROLU', 'SAHA_KONTROLU', 'TEKNIK_KONTROL'],
    hizmetIds: ['YAPI_DENETIMI', 'PROJE_KONTROLU'],
    onerilenYapiTuruIds: ['KONUT', 'KONUT_VILLA'],
  },
  {
    seoSlug: 'celik-konstruksiyon-firmasi',
    pageName: 'Çelik Konstrüksiyon Firması',
    title: 'Çelik Konstrüksiyon Firması | HUG PROJE',
    description: 'Çelik konstrüksiyon, çelik imalat ve montaj için çelik firmalarıyla eşleşin.',
    anaDalId: '09',
    anaDalKod: 'CELIK_METAL_PREFABRIK',
    altDalId: '09.01',
    unvanId: 'CELIK_KONSTRUKSIYON_FIRMASI',
    uzmanlikIds: ['CELIK_KONSTRUKSIYON', 'CELIK_IMALAT', 'CELIK_MONTAJ', 'ENDUSTRIYEL_CELIK', 'DEPO', 'HANGAR', 'CELIK_MERDIVEN', 'CELIK_CATI'],
    hizmetIds: ['CELIK_KONSTRUKSIYON', 'CELIK_IMALAT', 'CELIK_MONTAJ', 'HANGAR_YAPIMI'],
    onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'ENDUSTRIYEL_DEPO', 'SISTEM_CELIK'],
  },
  {
    seoSlug: 'prefabrik-firmasi',
    pageName: 'Prefabrik Firması',
    title: 'Prefabrik Firması | HUG PROJE',
    description: 'Prefabrik yapı ve prefabrik konut için prefabrik firmalarıyla eşleşin.',
    anaDalId: '09',
    anaDalKod: 'CELIK_METAL_PREFABRIK',
    altDalId: '09.03',
    unvanId: 'PREFABRIK_FIRMASI',
    uzmanlikIds: ['PREFABRIK_YAPI', 'BETONARME_PREFABRIK', 'PREFABRIK_KONUT', 'PREFABRIK_TICARI'],
    hizmetIds: ['PREFABRIK_YAPI', 'PREFABRIK_KONUT'],
    onerilenYapiTuruIds: ['SISTEM_PREFABRIK', 'KONUT'],
  },
  {
    seoSlug: 'ges-epc-firmasi',
    pageName: 'GES EPC Firması',
    title: 'GES EPC Firması | HUG PROJE',
    description: 'GES anahtar teslim ve trafo merkezi kurulumu için GES EPC firmalarıyla eşleşin.',
    anaDalId: '12',
    anaDalKod: 'OZEL_PROJELER',
    altDalId: '12.02',
    unvanId: 'GES_EPC_FIRMASI',
    uzmanlikIds: ['GES', 'TRAFO_MERKEZI', 'ENERJI_DEPOLAMA', 'ENERJI_SANTRALI'],
    hizmetIds: ['GES_ANAHTAR_TESLIM', 'TRAFO_MERKEZI_KURULUM'],
    onerilenYapiTuruIds: ['ENERJI_GES', 'ENERJI_TRAFO', 'ENERJI_SANTRAL'],
  },
]

// --- MASTER v5.2 CAPRAZ DOGRULAMA REFERANSI ---
// Bu blok ikinci ontoloji DEGILDIR. MASTER v5.2 Dart dosyasindaki ilgili AltDal
// tanimlarinin dogrulama icin aynen alinmis halidir. Yeni kayit eklenmez, ID uydurulmaz.
// Amac: SEO sayfasindaki ID'lerin gercekten o AltDal'a ait oldugunu kanitlamak.
const MASTER_ANA_DAL_KOD: Record<string, string> = {
  '01': 'MIMARLIK_TASARIM',
  '02': 'MUHENDISLIK',
  '03': 'MUTEAHHITLIK_YAPIM',
  '04': 'PROJE_SANTIYE',
  '05': 'YAPI_DENETIM_KONTROL',
  '09': 'CELIK_METAL_PREFABRIK',
  '12': 'OZEL_PROJELER',
}
type MasterAltDalRef = { anaDalId: string; unvanIds: string[]; uzmanlikIds: string[]; hizmetIds: string[]; onerilenYapiTuruIds: string[] }
const MASTER_ALT_DAL: Record<string, MasterAltDalRef> = {
  '01.01': { anaDalId: '01', unvanIds: ['MIMAR', 'YAPI_MIMARI', 'VILLA_MIMARI'], uzmanlikIds: ['KONSEPT_TASARIM', 'MIMARI_TASARIM', 'AVAM_PROJE', 'RUHSAT_PROJESI', 'UYGULAMA_PROJESI', 'DETAY_PROJESI', 'BIM'], hizmetIds: ['KONSEPT_PROJE', 'AVAM_PROJE', 'RUHSAT_PROJESI_HIZ', 'UYGULAMA_PROJESI_HIZ', 'BIM_MODELLEME'], onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT', 'TICARI', 'ENDUSTRIYEL_FABRIKA'] },
  '01.02': { anaDalId: '01', unvanIds: ['IC_MIMAR'], uzmanlikIds: ['IC_MEKAN_TASARIMI', 'KONSEPT', 'UYGULAMA', 'MOBILYA_YERLESIMI', 'AYDINLATMA_TASARIMI'], hizmetIds: ['VILLA_IC_MIMARI', 'OFIS_TASARIMI', 'OTEL_IC_TASARIMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'TICARI_OFIS'] },
  '01.03': { anaDalId: '01', unvanIds: ['PEYZAJ_MIMARI'], uzmanlikIds: ['PEYZAJ_TASARIMI', 'BITKILENDIRME', 'SERT_ZEMIN', 'SULAMA_PROJE'], hizmetIds: ['PEYZAJ_PROJESI', 'BAHCE_TASARIMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'KONUT_SITE'] },
  '02.01': { anaDalId: '02', unvanIds: ['INSAAT_MUHENDISI'], uzmanlikIds: ['YAPI', 'STATIK', 'BETONARME', 'CELIK', 'DEPREM', 'GUCLENDIRME', 'GEOTEKNIK', 'TEMEL_MUHENDISLIGI', 'YAPI_DINAMIGI', 'YAPI_PERFORMANSI', 'KOPRU_MUHENDISLIGI', 'TUNEL_MUHENDISLIGI', 'ALTYAPI_MUHENDISLIGI'], hizmetIds: ['STATIK_PROJE', 'BETONARME_STATIK', 'CELIK_STATIK', 'DEPREM_ANALIZI', 'GUCLENDIRME_PROJESI', 'ISTINAT_DUVARI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'ALTYAPI_KOPRU', 'ALTYAPI_TUNEL'] },
  '02.02': { anaDalId: '02', unvanIds: ['MAKINE_MUHENDISI'], uzmanlikIds: ['MEKANIK_TESISAT', 'HVAC', 'ISITMA', 'SOGUTMA', 'HAVALANDIRMA', 'SIHHI_TESISAT', 'YANGIN_TESISATI', 'DOGALGAZ', 'BUHAR_SISTEMLERI'], hizmetIds: ['MEKANIK_TESISAT_PROJESI', 'HVAC_PROJESI', 'YANGIN_TESISAT_PROJESI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'TICARI_OTEL'] },
  '02.03': { anaDalId: '02', unvanIds: ['ELEKTRIK_MUHENDISI'], uzmanlikIds: ['ELEKTRIK_PROJESI', 'KUVVETLI_AKIM', 'ZAYIF_AKIM', 'AYDINLATMA', 'PANO', 'ENERJI', 'GES', 'TRAFO', 'JENERATOR'], hizmetIds: ['ELEKTRIK_PROJESI', 'AYDINLATMA_PROJESI', 'GES_PROJESI', 'TRAFO_PROJESI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'ENERJI_GES'] },
  '02.05': { anaDalId: '02', unvanIds: ['JEOLOJI_MUHENDISI'], uzmanlikIds: ['JEOLOJIK_ETUT', 'ZEMIN', 'SONDAJ', 'ZEMIN_IYILESTIRME', 'SEV', 'HEYELAN'], hizmetIds: ['JEOLOJIK_ETUT_RAPORU', 'ZEMIN_ETUDU', 'SONDAJ'], onerilenYapiTuruIds: ['KONUT', 'ALTYAPI_YOL'] },
  '02.07': { anaDalId: '02', unvanIds: ['HARITA_MUHENDISI'], uzmanlikIds: ['ARAZI_OLCUMU', 'KADASTRO', 'APLIKASYON', 'PLANKOTE', 'HALIHAZIR_HARITA', 'FOTOGRAMETRI', 'GNSS', 'GIS', 'UCD_ARAZI_MODELLEME'], hizmetIds: ['APLIKASYON', 'PLANKOTE', 'HALIHAZIR_HARITA', 'DRONE_OLCUMU'], onerilenYapiTuruIds: ['KONUT'] },
  '03.01': { anaDalId: '03', unvanIds: ['ANA_YUKLENICI'], uzmanlikIds: ['ANAHTAR_TESLIM', 'GENEL_YAPIM', 'KONUT', 'VILLA', 'TICARI', 'ENDUSTRIYEL'], hizmetIds: ['ANAHTAR_TESLIM_YAPIM', 'VILLA_YAPIMI', 'FABRIKA_YAPIMI'], onerilenYapiTuruIds: ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'TICARI_OTEL'] },
  '04.01': { anaDalId: '04', unvanIds: ['PROJE_YONETICISI'], uzmanlikIds: ['PROJE_PLANLAMA', 'IS_PROGRAMI', 'ZAMAN_YONETIMI', 'MALIYET_YONETIMI', 'RISK_YONETIMI'], hizmetIds: ['PROJE_YONETIM_DANISMANLIGI', 'IS_PROGRAMI_HAZIRLAMA'], onerilenYapiTuruIds: ['KONUT', 'ENDUSTRIYEL_FABRIKA'] },
  '05.01': { anaDalId: '05', unvanIds: ['YAPI_DENETIM_UZMANI'], uzmanlikIds: ['YAPI_DENETIMI', 'PROJE_KONTROLU', 'SAHA_KONTROLU', 'TEKNIK_KONTROL'], hizmetIds: ['YAPI_DENETIMI', 'PROJE_KONTROLU'], onerilenYapiTuruIds: ['KONUT', 'KONUT_VILLA'] },
  '09.01': { anaDalId: '09', unvanIds: ['CELIK_KONSTRUKSIYON_FIRMASI'], uzmanlikIds: ['CELIK_KONSTRUKSIYON', 'CELIK_IMALAT', 'CELIK_MONTAJ', 'ENDUSTRIYEL_CELIK', 'DEPO', 'HANGAR', 'CELIK_MERDIVEN', 'CELIK_CATI'], hizmetIds: ['CELIK_KONSTRUKSIYON', 'CELIK_IMALAT', 'CELIK_MONTAJ', 'HANGAR_YAPIMI'], onerilenYapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'ENDUSTRIYEL_DEPO', 'SISTEM_CELIK'] },
  '09.03': { anaDalId: '09', unvanIds: ['PREFABRIK_FIRMASI'], uzmanlikIds: ['PREFABRIK_YAPI', 'BETONARME_PREFABRIK', 'PREFABRIK_KONUT', 'PREFABRIK_TICARI'], hizmetIds: ['PREFABRIK_YAPI', 'PREFABRIK_KONUT'], onerilenYapiTuruIds: ['SISTEM_PREFABRIK', 'KONUT'] },
  '12.02': { anaDalId: '12', unvanIds: ['GES_EPC_FIRMASI'], uzmanlikIds: ['GES', 'TRAFO_MERKEZI', 'ENERJI_DEPOLAMA', 'ENERJI_SANTRALI'], hizmetIds: ['GES_ANAHTAR_TESLIM', 'TRAFO_MERKEZI_KURULUM'], onerilenYapiTuruIds: ['ENERJI_GES', 'ENERJI_TRAFO', 'ENERJI_SANTRAL'] },
}
const MASTER_YAPI_TURU_IDS = new Set<string>(['KONUT', 'KONUT_MUSTAKIL', 'KONUT_VILLA', 'KONUT_APARTMAN', 'KONUT_SITE', 'KONUT_REZIDANS', 'KONUT_BUNGALOV', 'TICARI', 'TICARI_OFIS', 'TICARI_MAGAZA', 'TICARI_AVM', 'TICARI_RESTORAN', 'TICARI_KAFE', 'TICARI_OTEL', 'TICARI_TURIZM', 'TICARI_IS_MERKEZI', 'TICARI_PLAZA', 'ENDUSTRIYEL', 'ENDUSTRIYEL_FABRIKA', 'ENDUSTRIYEL_URETIM', 'ENDUSTRIYEL_DEPO', 'ENDUSTRIYEL_HANGAR', 'ENDUSTRIYEL_LOJISTIK', 'ENDUSTRIYEL_ANTREPO', 'ENDUSTRIYEL_SOGUK_DEPO', 'ENDUSTRIYEL_TESIS', 'KAMU', 'KAMU_OKUL', 'KAMU_UNIVERSITE', 'KAMU_HASTANE', 'KAMU_SAGLIK', 'KAMU_BELEDIYE', 'KAMU_ADLIYE', 'KAMU_KULTUR', 'KAMU_MUZE', 'KAMU_KUTUPHANE', 'KAMU_SPOR', 'ALTYAPI', 'ALTYAPI_YOL', 'ALTYAPI_KOPRU', 'ALTYAPI_VIYADUK', 'ALTYAPI_TUNEL', 'ALTYAPI_DEMIRYOLU', 'ALTYAPI_RAYLI', 'ALTYAPI_OTOPARK', 'ENERJI', 'ENERJI_GES', 'ENERJI_RES', 'ENERJI_TRAFO', 'ENERJI_SANTRAL', 'ENERJI_DEPOLAMA', 'SU', 'SU_ARITMA', 'SU_DEPO', 'SU_TERFI', 'SISTEM', 'SISTEM_BETONARME', 'SISTEM_CELIK', 'SISTEM_HAFIF_CELIK', 'SISTEM_PREFABRIK', 'SISTEM_MODULER', 'SISTEM_AHSAP', 'SISTEM_KARMA'])

function sameSet(a: string[], b: string[]): boolean {
  if (a.length !== b.length) return false
  const sb = new Set(b)
  return a.every((x) => sb.has(x))
}

;(() => {
  const seoSlugs = new Set<string>()
  const unvanIds = new Set<string>()
  const canonical = /^[A-Z0-9_]+$/
  for (const p of profesyonelSeoSayfalari) {
    if (!p.seoSlug || p.seoSlug.length < 2) throw new Error(`[profesyoneller.ts] seoSlug bozuk: ${p.seoSlug}`)
    if (seoSlugs.has(p.seoSlug)) throw new Error(`[profesyoneller.ts] seoSlug tekrari: ${p.seoSlug}`)
    seoSlugs.add(p.seoSlug)
    if (unvanIds.has(p.unvanId)) throw new Error(`[profesyoneller.ts] unvanId tekrari: ${p.unvanId}`)
    unvanIds.add(p.unvanId)
    if (!canonical.test(p.unvanId)) throw new Error(`[profesyoneller.ts] unvanId casing: ${p.unvanId}`)
    if (!canonical.test(p.anaDalKod)) throw new Error(`[profesyoneller.ts] anaDalKod casing: ${p.anaDalKod}`)
    if (!/^\d{2}$/.test(p.anaDalId)) throw new Error(`[profesyoneller.ts] anaDalId format: ${p.anaDalId}`)
    if (!/^\d{2}\.\d{2}$/.test(p.altDalId)) throw new Error(`[profesyoneller.ts] altDalId format: ${p.altDalId}`)
    // Capraz dogrulama - MASTER v5.2 gercek kayitlari
    const expectedKod = MASTER_ANA_DAL_KOD[p.anaDalId]
    if (!expectedKod) throw new Error(`[profesyoneller.ts] MASTER'da yok anaDalId: ${p.anaDalId}`)
    if (expectedKod !== p.anaDalKod) throw new Error(`[profesyoneller.ts] anaDalId <-> anaDalKod eslesmiyor: ${p.anaDalId} beklenen ${expectedKod}, gelen ${p.anaDalKod}`)
    const ref = MASTER_ALT_DAL[p.altDalId]
    if (!ref) throw new Error(`[profesyoneller.ts] MASTER'da yok altDalId: ${p.altDalId}`)
    if (ref.anaDalId !== p.anaDalId) throw new Error(`[profesyoneller.ts] altDalId ana dala ait degil: ${p.altDalId} beklenen anaDal ${ref.anaDalId}, gelen ${p.anaDalId}`)
    if (!ref.unvanIds.includes(p.unvanId)) throw new Error(`[profesyoneller.ts] unvanId bu AltDal'a ait degil: ${p.altDalId} -> ${p.unvanId}`)
    if (!sameSet(p.uzmanlikIds, ref.uzmanlikIds)) throw new Error(`[profesyoneller.ts] uzmanlikIds MASTER AltDal ile eslesmiyor: ${p.altDalId}`)
    if (!sameSet(p.hizmetIds, ref.hizmetIds)) throw new Error(`[profesyoneller.ts] hizmetIds MASTER AltDal ile eslesmiyor: ${p.altDalId}`)
    if (!sameSet(p.onerilenYapiTuruIds, ref.onerilenYapiTuruIds)) throw new Error(`[profesyoneller.ts] onerilenYapiTuruIds MASTER AltDal ile eslesmiyor: ${p.altDalId}`)
    for (const id of p.onerilenYapiTuruIds) {
      if (!MASTER_YAPI_TURU_IDS.has(id)) throw new Error(`[profesyoneller.ts] YapiTuru MASTER'da yok: ${id}`)
    }
    for (const id of [...p.uzmanlikIds, ...p.hizmetIds, ...p.onerilenYapiTuruIds]) {
      if (!canonical.test(id)) throw new Error(`[profesyoneller.ts] ID casing: ${p.seoSlug} -> ${id}`)
    }
  }
})()

export const profesyonelSeoSlugs = profesyonelSeoSayfalari.map((p) => p.seoSlug)
export const getProfesyonelSeoBySlug = (slug: string) =>
  profesyonelSeoSayfalari.find((p) => p.seoSlug === slug)
export const getProfesyonelSeoByUnvan = (unvanId: string) =>
  profesyonelSeoSayfalari.find((p) => p.unvanId === unvanId)
