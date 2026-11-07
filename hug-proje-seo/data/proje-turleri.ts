// HUG PROJE - Proje Turu SEO Sayfalari - SUNUM KATMANI
// KULLANICI DILI + ONTOLOJI BAGI - IKISI BIRLIKTE
// Kullanici gunluk hayatta "proje turu" demez, "arsaya kat karsiligi", "apartmana kentsel donusum" der.
// Uygulamada da Proje Olustur'da arsasini / dairesini / istegi (kat karsiligi vb) boyle yazarak yapiyor.
// Bu sayfalar o kullanici dilini korur, ama arkasi Dart'a baglidir, bagimsiz degildir.
// TEK DOGRULUK KAYNAGI: hug_proje_olustur.dart (BRIEF ENGINE v1.3.2) + hug_pro_master_v5_2
// - Proje Turu SEO sayfasi -> YapiTuru (ProjeTuruKaynagi.secilebilirIds) + Ihtiyac (IhtiyacKatalogu) + Asama (ProjeAsamasi)
// - YapiTuru ID'si secilebilirIds disinda OLAMAZ. Ihtiyac ID'si IhtiyacKatalogu disinda OLAMAZ.
// - Asama ID'si ProjeAsamasi disinda OLAMAZ.
// Bu dosya SEO sunum katmanidir. Sahte proje, sahte sayi, sahte yorum icermez.
// YapiTuru ile Proje Turu karistirilmaz: YapiTuru ontoloji boyutu, Proje Turu kullanici diliyle SEO sunumudur.

export type ProjeTuruSeoSayfasi = {
  // SEO sunum - seoSlug ASCII, digerleri Turkce karakterli
  seoSlug: string
  pageName: string
  title: string
  description: string
  audience: 'sahip'
  // Dart baglantilari - hepsi Dart'tan aynen, uydurma yok
  yapiTuruIds: string[]
  ihtiyacIds: string[]
  asamalar: string[]
}

export const projeTurleri: ProjeTuruSeoSayfasi[] = [
  {
    seoSlug: 'kat-karsiligi-insaat',
    pageName: 'Kat Karşılığı İnşaat',
    title: 'Kat Karşılığı İnşaat | HUG PROJE',
    description: 'Arsanız için kat karşılığı inşaat modeliyle doğru müteahhit ve profesyonellerle eşleşin. Arsa sahibi, daire sahibi ve site sakinleri için.',
    audience: 'sahip',
    yapiTuruIds: ['KONUT_MUSTAKIL', 'KONUT_VILLA', 'KONUT_APARTMAN', 'KONUT_SITE', 'KONUT_REZIDANS'],
    ihtiyacIds: ['MIMARI_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'HARITA', 'MUTEAHHIT', 'YAPI_DENETIM', 'PROJE_YONETIMI', 'BIM'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
  {
    seoSlug: 'kentsel-donusum',
    pageName: 'Kentsel Dönüşüm',
    title: 'Kentsel Dönüşüm | HUG PROJE',
    description: 'Apartman ve siteniz için kentsel dönüşüm sürecinde mimar, mühendis ve müteahhitle eşleşin.',
    audience: 'sahip',
    yapiTuruIds: ['KONUT_APARTMAN', 'KONUT_SITE', 'KONUT_REZIDANS', 'KONUT_MUSTAKIL'],
    ihtiyacIds: ['MIMARI_PROJE', 'STATIK_PROJE', 'ZEMIN_ETUDU', 'YAPI_DENETIM', 'MUTEAHHIT', 'PROJE_YONETIMI', 'HARITA'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
  {
    seoSlug: 'arsa-gelistirme',
    pageName: 'Arsa Geliştirme',
    title: 'Arsa Geliştirme | HUG PROJE',
    description: 'Arsanızın imar, değer ve proje potansiyelini harita, zemin ve mimari profesyonellerle değerlendirin.',
    audience: 'sahip',
    yapiTuruIds: ['KONUT_VILLA', 'KONUT_MUSTAKIL', 'KONUT_APARTMAN', 'KONUT_SITE', 'TICARI_OFIS', 'TICARI_MAGAZA', 'TICARI_OTEL', 'ENDUSTRIYEL_FABRIKA'],
    ihtiyacIds: ['HARITA', 'ZEMIN_ETUDU', 'MIMARI_PROJE', 'PROJE_YONETIMI'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER'],
  },
  {
    seoSlug: 'villa-konut-projeleri',
    pageName: 'Villa ve Konut Projeleri',
    title: 'Villa ve Konut Projeleri | HUG PROJE',
    description: 'Villa ve konut projeniz için mimari tasarım, ruhsat ve uygulama profesyonelleriyle eşleşin.',
    audience: 'sahip',
    yapiTuruIds: ['KONUT_VILLA', 'KONUT_MUSTAKIL', 'KONUT_BUNGALOV', 'KONUT_SITE', 'KONUT_REZIDANS', 'KONUT_APARTMAN'],
    ihtiyacIds: ['MIMARI_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'IC_MIMARI', 'PEYZAJ', 'HARITA', 'PROJE_YONETIMI', 'BIM', 'MUTEAHHIT'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
  {
    seoSlug: 'turizm-tesisi-yatirimlari',
    pageName: 'Turizm Tesisi Yatırımları',
    title: 'Turizm Tesisi Yatırımları | HUG PROJE',
    description: 'Otel ve turizm tesisi yatırımınız için tasarım, ruhsat ve uygulama profesyonelleriyle eşleşin.',
    audience: 'sahip',
    yapiTuruIds: ['TICARI_OTEL', 'TICARI_RESTORAN', 'KONUT_VILLA', 'KONUT_SITE'],
    ihtiyacIds: ['MIMARI_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'IC_MIMARI', 'PEYZAJ', 'MUTEAHHIT'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
  {
    seoSlug: 'fabrika-sanayi-yatirimlari',
    pageName: 'Fabrika ve Sanayi Yatırımları',
    title: 'Fabrika ve Sanayi Yatırımları | HUG PROJE',
    description: 'Fabrika ve sanayi tesisiniz için mühendislik, ruhsat ve anahtar teslim profesyonellerle eşleşin.',
    audience: 'sahip',
    yapiTuruIds: ['ENDUSTRIYEL_FABRIKA', 'ENDUSTRIYEL_URETIM', 'ENDUSTRIYEL_DEPO', 'ENDUSTRIYEL_HANGAR'],
    ihtiyacIds: ['MIMARI_PROJE', 'STATIK_PROJE', 'CELIK_YAPI', 'MEKANIK_PROJE', 'ELEKTRIK_PROJE', 'ZEMIN_ETUDU', 'ALTYAPI', 'PROJE_YONETIMI', 'BIM'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
  {
    seoSlug: 'egitim-yatirimlari',
    pageName: 'Eğitim Yatırımları',
    title: 'Eğitim Yatırımları | HUG PROJE',
    description: 'Okul, üniversite ve eğitim tesisiniz için kamu işleri kapsamında tasarım, ruhsat ve uygulama profesyonelleriyle eşleşin.',
    audience: 'sahip',
    yapiTuruIds: ['KAMU_OKUL', 'KAMU_UNIVERSITE', 'KAMU_KUTUPHANE', 'KAMU_KULTUR', 'KAMU_SPOR'],
    ihtiyacIds: ['MIMARI_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'PROJE_YONETIMI'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
  {
    seoSlug: 'saglik-yatirimlari',
    pageName: 'Sağlık Yatırımları',
    title: 'Sağlık Yatırımları | HUG PROJE',
    description: 'Hastane ve sağlık tesisiniz için kamu işleri kapsamında mekanik, elektrik ve mimari profesyonellerle eşleşin.',
    audience: 'sahip',
    yapiTuruIds: ['KAMU_HASTANE', 'KAMU_SAGLIK'],
    ihtiyacIds: ['MIMARI_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'PROJE_YONETIMI'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
  {
    seoSlug: 'ticari-gayrimenkul',
    pageName: 'Ticari Gayrimenkul',
    title: 'Ticari Gayrimenkul | HUG PROJE',
    description: 'Ofis, mağaza ve ticari gayrimenkul projeniz için tasarım ve uygulama profesyonelleriyle eşleşin.',
    audience: 'sahip',
    yapiTuruIds: ['TICARI_OFIS', 'TICARI_MAGAZA', 'TICARI_AVM', 'TICARI_RESTORAN', 'TICARI_OTEL'],
    ihtiyacIds: ['MIMARI_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'IC_MIMARI', 'MUTEAHHIT', 'PROJE_YONETIMI'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
  {
    seoSlug: 'ges-enerji-projeleri',
    pageName: 'GES ve Enerji Projeleri',
    title: 'GES ve Enerji Projeleri | HUG PROJE',
    description: 'GES ve enerji projeniz için mühendislik, EPC ve kurulum profesyonelleriyle eşleşin.',
    audience: 'sahip',
    yapiTuruIds: ['ENERJI_GES', 'ENERJI_RES', 'ENERJI_TRAFO'],
    ihtiyacIds: ['GES_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'ZEMIN_ETUDU', 'PROJE_YONETIMI', 'CELIK_YAPI', 'MUTEAHHIT'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
  {
    seoSlug: 'tarimsal-tesisler',
    pageName: 'Tarımsal Tesisler',
    title: 'Tarımsal Tesisler | HUG PROJE',
    description: 'Tarımsal tesis ve üretim yapınız için tasarım, ruhsat ve uygulama profesyonelleriyle eşleşin.',
    audience: 'sahip',
    yapiTuruIds: ['ENDUSTRIYEL_DEPO', 'ENDUSTRIYEL_URETIM', 'ENDUSTRIYEL_FABRIKA', 'SISTEM_CELIK', 'SISTEM_PREFABRIK'],
    ihtiyacIds: ['MIMARI_PROJE', 'STATIK_PROJE', 'CELIK_YAPI', 'MEKANIK_PROJE', 'ELEKTRIK_PROJE', 'ZEMIN_ETUDU', 'ALTYAPI'],
    asamalar: ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'],
  },
]

// --- DART CAPRAZ DOGRULAMA ---
// Bu blok ikinci ontoloji degildir. Dart'taki secilebilirIds, IhtiyacKatalogu, ProjeAsamasi listelerinin dogrulama icin aynen alinmis halidir.
// NOT: KAMU, MASTER v5.2 YapiTurleriMaster'da VAR, ama Brief Engine secilebilirIds'de YOK.
// SEO, KAMU'yu MASTER'dan alir. Uygulamada secilebilir olmasi istenirse Dart secilebilirIds'e KAMU eklenmeli.
const DART_SECILEBILIR_YAPI_TURU = new Set<string>(['KONUT_MUSTAKIL', 'KONUT_VILLA', 'KONUT_APARTMAN', 'KONUT_SITE', 'KONUT_REZIDANS', 'KONUT_BUNGALOV', 'TICARI_OFIS', 'TICARI_MAGAZA', 'TICARI_AVM', 'TICARI_RESTORAN', 'TICARI_OTEL', 'ENDUSTRIYEL_FABRIKA', 'ENDUSTRIYEL_URETIM', 'ENDUSTRIYEL_DEPO', 'ENDUSTRIYEL_HANGAR', 'ENERJI_GES', 'ENERJI_RES', 'ENERJI_TRAFO', 'SISTEM_BETONARME', 'SISTEM_CELIK', 'SISTEM_PREFABRIK', 'ALTYAPI', 'SU_ARITMA'])
const MASTER_KAMU_YAPI_TURU = new Set<string>(['KAMU', 'KAMU_OKUL', 'KAMU_UNIVERSITE', 'KAMU_HASTANE', 'KAMU_SAGLIK', 'KAMU_BELEDIYE', 'KAMU_ADLIYE', 'KAMU_KULTUR', 'KAMU_MUZE', 'KAMU_KUTUPHANE', 'KAMU_SPOR'])
const DART_IHTIYAC_IDS = new Set<string>(['MIMARI_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'GES_PROJE', 'IC_MIMARI', 'PEYZAJ', 'PEYZAJ_UYGULAMA', 'HARITA', 'PROJE_YONETIMI', 'BIM', 'YAPI_DENETIM', 'CEPHE', 'CATI', 'YALITIM', 'CELIK_YAPI', 'MUTEAHHIT', 'ALTYAPI'])
const DART_ASAMALAR = new Set<string>(['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'])

;(() => {
  const slugs = new Set<string>()
  for (const t of projeTurleri) {
    if (!t.seoSlug || t.seoSlug.length < 2) throw new Error(`[proje-turleri.ts] seoSlug bozuk: ${t.seoSlug}`)
    if (!/^[a-z0-9-]+$/.test(t.seoSlug)) throw new Error(`[proje-turleri.ts] seoSlug ASCII olmali: ${t.seoSlug}`)
    if (slugs.has(t.seoSlug)) throw new Error(`[proje-turleri.ts] seoSlug tekrari: ${t.seoSlug}`)
    slugs.add(t.seoSlug)
    if (!t.pageName || !t.title || !t.description) throw new Error(`[proje-turleri.ts] Alan eksik: ${t.seoSlug}`)
    if (t.audience !== 'sahip') throw new Error(`[proje-turleri.ts] audience sahip olmali: ${t.seoSlug}`)
    if (!t.yapiTuruIds || t.yapiTuruIds.length < 1) throw new Error(`[proje-turleri.ts] yapiTuruIds eksik: ${t.seoSlug}`)
    for (const y of t.yapiTuruIds) {
      if (!DART_SECILEBILIR_YAPI_TURU.has(y) && !MASTER_KAMU_YAPI_TURU.has(y)) throw new Error(`[proje-turleri.ts] YapiTuru ne secilebilir ne MASTER KAMU'da: ${t.seoSlug} -> ${y}`)
    }
    if (!t.ihtiyacIds || t.ihtiyacIds.length < 1) throw new Error(`[proje-turleri.ts] ihtiyacIds eksik: ${t.seoSlug}`)
    for (const i of t.ihtiyacIds) {
      if (!DART_IHTIYAC_IDS.has(i)) throw new Error(`[proje-turleri.ts] Ihtiyac Dart'ta yok: ${t.seoSlug} -> ${i}`)
    }
    if (!t.asamalar || t.asamalar.length < 1) throw new Error(`[proje-turleri.ts] asamalar eksik: ${t.seoSlug}`)
    for (const a of t.asamalar) {
      if (!DART_ASAMALAR.has(a)) throw new Error(`[proje-turleri.ts] Asama Dart'ta yok: ${t.seoSlug} -> ${a}`)
    }
  }
})()

export const projeTuruSlugs = projeTurleri.map((t) => t.seoSlug)
export const getProjeTuruBySlug = (slug: string) => projeTurleri.find((t) => t.seoSlug === slug)
