// HUG PROJE - Ihtiyac Katalogu SEO Sunum Katmani
// TEK DOGRULUK KAYNAGI: hug_proje_olustur.dart (BRIEF ENGINE v1.3.2) + MASTER v5.2
// Bu dosya IhtiyacKatalogu'nun SEO sunumudur. Bagimsiz taksonomi degildir.
// Her ihtiyac -> ProfesyonelDalSecimi(anaDalId, altDalId, unvanId, uzmanlikIds, hizmetIds) ile ontolojiye baglidir.
// ID'ler Dart'tan aynen alinmistir, uydurma yok.
// SEO'da pageName/title/description Turkce karakterli, ID'ler ve seoSlug ASCII'dir.

export type IhtiyacBaglanti = {
  anaDalId: string
  altDalId: string
  unvanId: string
  uzmanlikIds: string[]
  hizmetIds: string[]
}

export type Ihtiyac = {
  id: string
  seoSlug: string
  pageName: string
  title: string
  description: string
  grup: 'ANA' | 'DIGER'
  baglanti: IhtiyacBaglanti[]
}

export const ihtiyaclar: Ihtiyac[] = [
  {
    id: 'MIMARI_PROJE',
    seoSlug: 'mimari-proje',
    pageName: 'Mimari Proje',
    title: 'Mimari Proje | HUG PROJE',
    description: 'Konsept, avan proje, ruhsat ve uygulama projesi için mimarlarla eşleşin.',
    grup: 'ANA',
    baglanti: [{ anaDalId: '01', altDalId: '01.01', unvanId: 'MIMAR', uzmanlikIds: ['KONSEPT_TASARIM'], hizmetIds: ['KONSEPT_PROJE'] }],
  },
  {
    id: 'STATIK_PROJE',
    seoSlug: 'statik-proje',
    pageName: 'Statik Proje',
    title: 'Statik Proje | HUG PROJE',
    description: 'Taşıyıcı sistem, betonarme ve statik proje için inşaat mühendisleriyle eşleşin.',
    grup: 'ANA',
    baglanti: [{ anaDalId: '02', altDalId: '02.01', unvanId: 'INSAAT_MUHENDISI', uzmanlikIds: ['STATIK', 'BETONARME'], hizmetIds: ['STATIK_PROJE'] }],
  },
  {
    id: 'ELEKTRIK_PROJE',
    seoSlug: 'elektrik-proje',
    pageName: 'Elektrik Projesi',
    title: 'Elektrik Projesi | HUG PROJE',
    description: 'Elektrik projesi için elektrik mühendisleriyle eşleşin.',
    grup: 'ANA',
    baglanti: [{ anaDalId: '02', altDalId: '02.03', unvanId: 'ELEKTRIK_MUHENDISI', uzmanlikIds: ['ELEKTRIK_PROJESI'], hizmetIds: ['ELEKTRIK_PROJESI'] }],
  },
  {
    id: 'MEKANIK_PROJE',
    seoSlug: 'mekanik-proje',
    pageName: 'Mekanik Proje',
    title: 'Mekanik Proje | HUG PROJE',
    description: 'HVAC, mekanik tesisat projesi için makine mühendisleriyle eşleşin.',
    grup: 'ANA',
    baglanti: [{ anaDalId: '02', altDalId: '02.02', unvanId: 'MAKINE_MUHENDISI', uzmanlikIds: ['MEKANIK_TESISAT'], hizmetIds: ['MEKANIK_TESISAT_PROJESI'] }],
  },
  {
    id: 'ZEMIN_ETUDU',
    seoSlug: 'zemin-etudu',
    pageName: 'Zemin Etüdü',
    title: 'Zemin Etüdü | HUG PROJE',
    description: 'Zemin etüdü için jeoloji mühendisleriyle eşleşin.',
    grup: 'ANA',
    baglanti: [{ anaDalId: '02', altDalId: '02.05', unvanId: 'JEOLOJI_MUHENDISI', uzmanlikIds: ['ZEMIN'], hizmetIds: ['ZEMIN_ETUDU'] }],
  },
  {
    id: 'GES_PROJE',
    seoSlug: 'ges-proje',
    pageName: 'GES Projesi',
    title: 'GES Projesi | HUG PROJE',
    description: 'GES projesi için GES EPC firmalarıyla eşleşin.',
    grup: 'ANA',
    baglanti: [{ anaDalId: '12', altDalId: '12.02', unvanId: 'GES_EPC_FIRMASI', uzmanlikIds: ['GES'], hizmetIds: ['GES_ANAHTAR_TESLIM'] }],
  },
  {
    id: 'IC_MIMARI',
    seoSlug: 'ic-mimarlik',
    pageName: 'İç Mimarlık',
    title: 'İç Mimarlık | HUG PROJE',
    description: 'İç mekân tasarımı için iç mimarlarla eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '01', altDalId: '01.02', unvanId: 'IC_MIMAR', uzmanlikIds: ['IC_MEKAN_TASARIMI'], hizmetIds: ['VILLA_IC_MIMARI'] }],
  },
  {
    id: 'PEYZAJ',
    seoSlug: 'peyzaj',
    pageName: 'Peyzaj',
    title: 'Peyzaj | HUG PROJE',
    description: 'Peyzaj tasarımı için peyzaj mimarlarıyla eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '01', altDalId: '01.03', unvanId: 'PEYZAJ_MIMARI', uzmanlikIds: ['PEYZAJ_TASARIMI'], hizmetIds: ['PEYZAJ_PROJESI'] }],
  },
  {
    id: 'PEYZAJ_UYGULAMA',
    seoSlug: 'peyzaj-uygulama',
    pageName: 'Peyzaj Uygulama',
    title: 'Peyzaj Uygulama | HUG PROJE',
    description: 'Peyzaj uygulaması için peyzaj uygulama firmalarıyla eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '11', altDalId: '11.05', unvanId: 'PEYZAJ_UYGULAMA_FIRMASI', uzmanlikIds: ['PEYZAJ_UYGULAMASI'], hizmetIds: ['PEYZAJ_UYGULAMA'] }],
  },
  {
    id: 'HARITA',
    seoSlug: 'harita',
    pageName: 'Harita',
    title: 'Harita | HUG PROJE',
    description: 'Arazi ölçümü ve hâlihazır harita için harita mühendisleriyle eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '06', altDalId: '06.01', unvanId: 'HARITA_MUHENDISI', uzmanlikIds: ['ARAZI_OLCUMU'], hizmetIds: ['HALIHAZIR_HARITA'] }],
  },
  {
    id: 'PROJE_YONETIMI',
    seoSlug: 'proje-yonetimi',
    pageName: 'Proje Yönetimi',
    title: 'Proje Yönetimi | HUG PROJE',
    description: 'Proje yönetimi için proje yöneticileriyle eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '04', altDalId: '04.01', unvanId: 'PROJE_YONETICISI', uzmanlikIds: ['PROJE_PLANLAMA'], hizmetIds: ['PROJE_YONETIM_DANISMANLIGI'] }],
  },
  {
    id: 'BIM',
    seoSlug: 'bim',
    pageName: 'BIM',
    title: 'BIM | HUG PROJE',
    description: 'BIM yönetimi ve modelleme için BIM koordinatörleriyle eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '04', altDalId: '04.04', unvanId: 'BIM_KOORDINATORU', uzmanlikIds: ['BIM_YONETIMI'], hizmetIds: ['BIM_YONETIMI'] }],
  },
  {
    id: 'YAPI_DENETIM',
    seoSlug: 'yapi-denetim',
    pageName: 'Yapı Denetim',
    title: 'Yapı Denetim | HUG PROJE',
    description: 'Yapı denetimi için yapı denetim uzmanlarıyla eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '05', altDalId: '05.01', unvanId: 'YAPI_DENETIM_UZMANI', uzmanlikIds: ['YAPI_DENETIMI'], hizmetIds: ['YAPI_DENETIMI'] }],
  },
  {
    id: 'CEPHE',
    seoSlug: 'cephe',
    pageName: 'Cephe',
    title: 'Cephe | HUG PROJE',
    description: 'Giydirme cephe için cephe firmalarıyla eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '08', altDalId: '08.01', unvanId: 'CEPHE_FIRMASI', uzmanlikIds: ['GIYDIRME_CEPHE'], hizmetIds: ['GIYDIRME_CEPHE'] }],
  },
  {
    id: 'CATI',
    seoSlug: 'cati',
    pageName: 'Çatı',
    title: 'Çatı | HUG PROJE',
    description: 'Çelik çatı ve çatı yapımı için çatı firmalarıyla eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '08', altDalId: '08.02', unvanId: 'CATI_FIRMASI', uzmanlikIds: ['CELIK_CATI'], hizmetIds: ['CATI_YAPIMI'] }],
  },
  {
    id: 'YALITIM',
    seoSlug: 'yalitim',
    pageName: 'Yalıtım',
    title: 'Yalıtım | HUG PROJE',
    description: 'Temel yalıtımı ve su yalıtımı için yalıtım firmalarıyla eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '08', altDalId: '08.03', unvanId: 'YALITIM_FIRMASI', uzmanlikIds: ['TEMEL_YALITIMI'], hizmetIds: ['SU_YALITIMI'] }],
  },
  {
    id: 'CELIK_YAPI',
    seoSlug: 'celik-yapi',
    pageName: 'Çelik Yapı',
    title: 'Çelik Yapı | HUG PROJE',
    description: 'Çelik konstrüksiyon için çelik yapı firmalarıyla eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '09', altDalId: '09.01', unvanId: 'CELIK_KONSTRUKSIYON_FIRMASI', uzmanlikIds: ['CELIK_KONSTRUKSIYON'], hizmetIds: ['CELIK_KONSTRUKSIYON'] }],
  },
  {
    id: 'MUTEAHHIT',
    seoSlug: 'muteahhit',
    pageName: 'Müteahhit',
    title: 'Müteahhit | HUG PROJE',
    description: 'Anahtar teslim yapım için ana yüklenicilerle eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '03', altDalId: '03.01', unvanId: 'ANA_YUKLENICI', uzmanlikIds: ['ANAHTAR_TESLIM'], hizmetIds: ['ANAHTAR_TESLIM_YAPIM'] }],
  },
  {
    id: 'ALTYAPI',
    seoSlug: 'altyapi',
    pageName: 'Altyapı',
    title: 'Altyapı | HUG PROJE',
    description: 'Kanalizasyon ve altyapı için altyapı firmalarıyla eşleşin.',
    grup: 'DIGER',
    baglanti: [{ anaDalId: '11', altDalId: '11.01', unvanId: 'ALTYAPI_FIRMASI', uzmanlikIds: ['KANALIZASYON'], hizmetIds: ['KANALIZASYON'] }],
  },
]

;(() => {
  const ids = new Set<string>()
  const slugs = new Set<string>()
  for (const it of ihtiyaclar) {
    if (!it.id) throw new Error('[ihtiyaclar.ts] id eksik')
    if (ids.has(it.id)) throw new Error(`[ihtiyaclar.ts] id tekrari: ${it.id}`)
    ids.add(it.id)
    if (!it.seoSlug || !/^[a-z0-9-]+$/.test(it.seoSlug)) throw new Error(`[ihtiyaclar.ts] seoSlug ASCII olmali: ${it.seoSlug}`)
    if (slugs.has(it.seoSlug)) throw new Error(`[ihtiyaclar.ts] seoSlug tekrari: ${it.seoSlug}`)
    slugs.add(it.seoSlug)
    if (!it.pageName || !it.title || !it.description) throw new Error(`[ihtiyaclar.ts] Alan eksik: ${it.id}`)
    if (it.grup !== 'ANA' && it.grup !== 'DIGER') throw new Error(`[ihtiyaclar.ts] grup gecersiz: ${it.id}`)
    if (!it.baglanti || it.baglanti.length < 1) throw new Error(`[ihtiyaclar.ts] baglanti eksik: ${it.id}`)
    for (const b of it.baglanti) {
      if (!/^\d{2}$/.test(b.anaDalId)) throw new Error(`[ihtiyaclar.ts] anaDalId format: ${it.id}`)
      if (!/^\d{2}\.\d{2}$/.test(b.altDalId)) throw new Error(`[ihtiyaclar.ts] altDalId format: ${it.id}`)
      if (!b.unvanId || !/^[A-Z0-9_]+$/.test(b.unvanId)) throw new Error(`[ihtiyaclar.ts] unvanId casing: ${it.id}`)
      if (!b.uzmanlikIds || b.uzmanlikIds.length < 1) throw new Error(`[ihtiyaclar.ts] uzmanlikIds eksik: ${it.id}`)
      if (!b.hizmetIds || b.hizmetIds.length < 1) throw new Error(`[ihtiyaclar.ts] hizmetIds eksik: ${it.id}`)
    }
  }
  if (ihtiyaclar.length !== 19) throw new Error(`[ihtiyaclar.ts] 19 ihtiyac olmali, gelen: ${ihtiyaclar.length}`)
})()

export const ihtiyacSlugs = ihtiyaclar.map((i) => i.seoSlug)
export const getIhtiyacById = (id: string) => ihtiyaclar.find((i) => i.id === id)
export const getIhtiyacBySlug = (slug: string) => ihtiyaclar.find((i) => i.seoSlug === slug)
