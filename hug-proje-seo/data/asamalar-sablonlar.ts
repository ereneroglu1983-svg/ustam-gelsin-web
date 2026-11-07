// HUG PROJE - Proje Asamalari + Ihtiyac Sablonlari - SEO Sunum Katmani
// DOGRULAMA: Bu dosya veriyi DEGISTIRMEZ. Sadece asagidaki kontrolleri guclendirir:
// - 3 YapiTuru ID'si tam eslesme, 6 Asama ID'si tam eslesme, 19 Ihtiyac ID'si ihtiyaclar.ts ile tam eslesme
// - Sablon kapsama: ihtiyaclar.ts'teki her ID en az bir sablonda gecmeli
// - FIKIR fallback davranisi korunur, degistirilmez.

import { ihtiyaclar } from './ihtiyaclar'
// TEK DOGRULUK KAYNAGI: hug_proje_olustur.dart (BRIEF ENGINE v1.3.2)
// - ProjeAsamasi: FIKIR, TASARIM, TEKNIK_PROJELER, RUHSAT, TEKLIF, UYGULAMA
// - IhtiyacSablonlari: YapiTuru + Asama -> Ihtiyac ID listesi
// Dart'ta sadece 3 YapiTuru'nda sablon var: KONUT_VILLA, ENDUSTRIYEL_FABRIKA, ENERJI_GES.
// Diger YapiTuru'larda: once o YapiTuru + o Asama aranir, yoksa o YapiTuru + FIKIR'a dusulur, o da yoksa [] doner.
// Bu dosya o mantigi aynen korur, uydurma sablon eklemez.
// SEO'da displayName Turkce karakterli, ID'ler Dart'tan aynen.

export type ProjeAsamasi = {
  id: string
  displayName: string
}

export const projeAsamalari: ProjeAsamasi[] = [
  { id: 'FIKIR', displayName: 'Fikir' },
  { id: 'TASARIM', displayName: 'Tasarım' },
  { id: 'TEKNIK_PROJELER', displayName: 'Teknik Projeler' },
  { id: 'RUHSAT', displayName: 'Ruhsat' },
  { id: 'TEKLIF', displayName: 'Teklif' },
  { id: 'UYGULAMA', displayName: 'Uygulama' },
]

// IhtiyacSablonlari - Dart _map'ten aynen
export const ihtiyacSablonlari: Record<string, Record<string, string[]>> = {
  'KONUT_VILLA': {
    'FIKIR': ['MIMARI_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'IC_MIMARI', 'PEYZAJ', 'HARITA', 'PROJE_YONETIMI', 'BIM', 'MUTEAHHIT'],
    'TASARIM': ['MIMARI_PROJE', 'IC_MIMARI', 'PEYZAJ', 'BIM'],
    'TEKNIK_PROJELER': ['STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'HARITA'],
    'RUHSAT': ['MIMARI_PROJE', 'YAPI_DENETIM'],
    'TEKLIF': ['MUTEAHHIT', 'CEPHE', 'CATI', 'YALITIM', 'IC_MIMARI', 'PEYZAJ_UYGULAMA', 'ALTYAPI'],
    'UYGULAMA': ['MUTEAHHIT', 'YAPI_DENETIM', 'PROJE_YONETIMI', 'BIM'],
  },
  'ENDUSTRIYEL_FABRIKA': {
    'FIKIR': ['MIMARI_PROJE', 'STATIK_PROJE', 'CELIK_YAPI', 'ZEMIN_ETUDU', 'MEKANIK_PROJE', 'ELEKTRIK_PROJE', 'ALTYAPI', 'PROJE_YONETIMI', 'BIM'],
    'TASARIM': ['MIMARI_PROJE', 'CELIK_YAPI', 'BIM'],
    'TEKNIK_PROJELER': ['STATIK_PROJE', 'CELIK_YAPI', 'MEKANIK_PROJE', 'ELEKTRIK_PROJE', 'ZEMIN_ETUDU'],
    'RUHSAT': ['MIMARI_PROJE', 'YAPI_DENETIM'],
    'TEKLIF': ['CELIK_YAPI', 'MUTEAHHIT', 'ALTYAPI', 'CEPHE', 'CATI'],
    'UYGULAMA': ['MUTEAHHIT', 'YAPI_DENETIM', 'PROJE_YONETIMI'],
  },
  'ENERJI_GES': {
    'FIKIR': ['GES_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'ZEMIN_ETUDU', 'PROJE_YONETIMI'],
    'TASARIM': ['GES_PROJE', 'STATIK_PROJE'],
    'TEKNIK_PROJELER': ['GES_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE'],
    'RUHSAT': ['GES_PROJE'],
    'TEKLIF': ['GES_PROJE', 'CELIK_YAPI', 'MUTEAHHIT'],
    'UYGULAMA': ['GES_PROJE', 'MUTEAHHIT', 'YAPI_DENETIM'],
  },
}

// Beklenen sabitler - Dart'tan aynen, degistirilmez
const BEKLENEN_YAPI_TURU_IDS = ['KONUT_VILLA', 'ENDUSTRIYEL_FABRIKA', 'ENERJI_GES'] as const
const BEKLENEN_ASAMA_IDS = ['FIKIR', 'TASARIM', 'TEKNIK_PROJELER', 'RUHSAT', 'TEKLIF', 'UYGULAMA'] as const
const BEKLENEN_ASAMA_DISPLAY: Record<string, string> = {
  'FIKIR': 'Fikir',
  'TASARIM': 'Tasarım',
  'TEKNIK_PROJELER': 'Teknik Projeler',
  'RUHSAT': 'Ruhsat',
  'TEKLIF': 'Teklif',
  'UYGULAMA': 'Uygulama',
}
// 19 ihtiyac ID'si - ihtiyaclar.ts'teki GERCEK liste, elle yazilmis ikinci liste degil
const GERCEK_IHTIYAC_IDS = new Set<string>(ihtiyaclar.map((i) => i.id))

export function getOnerilenIhtiyaclar(yapiTuruId: string, asama: string): string[] {
  const byYapi = ihtiyacSablonlari[yapiTuruId]
  if (!byYapi) return []
  if (byYapi[asama]) return [...byYapi[asama]]
  if (byYapi['FIKIR']) return [...byYapi['FIKIR']]
  return []
}

;(() => {
  // --- 1) 6 Asama - tam eslesme ---
  if (projeAsamalari.length !== 6) throw new Error('[asamalar-sablonlar.ts] 6 asama olmali')
  const asamaIdsSet = new Set<string>()
  for (const a of projeAsamalari) {
    if (!a.id || !/^[A-Z_]+$/.test(a.id)) throw new Error(`[asamalar-sablonlar.ts] asama id casing: ${a.id}`)
    if (asamaIdsSet.has(a.id)) throw new Error(`[asamalar-sablonlar.ts] asama tekrari: ${a.id}`)
    asamaIdsSet.add(a.id)
    if (!a.displayName) throw new Error(`[asamalar-sablonlar.ts] displayName eksik: ${a.id}`)
    if (BEKLENEN_ASAMA_DISPLAY[a.id] !== a.displayName) throw new Error(`[asamalar-sablonlar.ts] Asama displayName eslesmiyor: ${a.id} beklenen ${BEKLENEN_ASAMA_DISPLAY[a.id]}, gelen ${a.displayName}`)
  }
  for (const beklenen of BEKLENEN_ASAMA_IDS) {
    if (!asamaIdsSet.has(beklenen)) throw new Error(`[asamalar-sablonlar.ts] Eksik asama: ${beklenen}`)
  }
  for (const gelen of asamaIdsSet) {
    if (!((BEKLENEN_ASAMA_IDS as readonly string[]).includes(gelen))) throw new Error(`[asamalar-sablonlar.ts] Fazla / bilinmeyen asama: ${gelen}`)
  }

  // --- 2) 19 Ihtiyac - ihtiyaclar.ts ile birebir ---
  if (ihtiyaclar.length !== 19) throw new Error(`[asamalar-sablonlar.ts] ihtiyaclar.ts 19 olmali, gelen: ${ihtiyaclar.length}`)
  const beklenenIhtiyac = new Set<string>(['MIMARI_PROJE', 'STATIK_PROJE', 'ELEKTRIK_PROJE', 'MEKANIK_PROJE', 'ZEMIN_ETUDU', 'GES_PROJE', 'IC_MIMARI', 'PEYZAJ', 'PEYZAJ_UYGULAMA', 'HARITA', 'PROJE_YONETIMI', 'BIM', 'YAPI_DENETIM', 'CEPHE', 'CATI', 'YALITIM', 'CELIK_YAPI', 'MUTEAHHIT', 'ALTYAPI'])
  for (const id of beklenenIhtiyac) {
    if (!GERCEK_IHTIYAC_IDS.has(id)) throw new Error(`[asamalar-sablonlar.ts] ihtiyaclar.ts'te eksik ihtiyac: ${id}`)
  }
  for (const id of GERCEK_IHTIYAC_IDS) {
    if (!beklenenIhtiyac.has(id)) throw new Error(`[asamalar-sablonlar.ts] ihtiyaclar.ts'te fazla / bilinmeyen ihtiyac: ${id}`)
  }

  // --- 3) 3 YapiTuru - tam eslesme, fazla / eksik yok ---
  const yapiKeys = Object.keys(ihtiyacSablonlari)
  if (yapiKeys.length !== 3) throw new Error(`[asamalar-sablonlar.ts] 3 YapiTuru sablonu olmali, gelen: ${yapiKeys.length}`)
  const yapiSet = new Set(yapiKeys)
  for (const beklenen of BEKLENEN_YAPI_TURU_IDS) {
    if (!yapiSet.has(beklenen)) throw new Error(`[asamalar-sablonlar.ts] Eksik YapiTuru sablonu: ${beklenen}`)
  }
  for (const gelen of yapiSet) {
    if (!((BEKLENEN_YAPI_TURU_IDS as readonly string[]).includes(gelen))) throw new Error(`[asamalar-sablonlar.ts] Fazla / bilinmeyen YapiTuru sablonu: ${gelen}`)
  }

  // --- 4) 3 x 6 sablon butunlugu + kapsama ---
  const kapsanan = new Set<string>()
  for (const y of yapiKeys) {
    const byAsama = ihtiyacSablonlari[y]
    const asamaKeys = Object.keys(byAsama)
    if (asamaKeys.length !== 6) throw new Error(`[asamalar-sablonlar.ts] ${y} icin 6 asama olmali`)
    for (const beklenen of BEKLENEN_ASAMA_IDS) {
      if (!byAsama[beklenen]) throw new Error(`[asamalar-sablonlar.ts] ${y} icin eksik asama sablonu: ${beklenen}`)
    }
    for (const gelen of asamaKeys) {
      if (!((BEKLENEN_ASAMA_IDS as readonly string[]).includes(gelen))) throw new Error(`[asamalar-sablonlar.ts] ${y} icin fazla asama: ${gelen}`)
    }
    if (!byAsama['FIKIR'] || byAsama['FIKIR'].length < 1) throw new Error(`[asamalar-sablonlar.ts] ${y} icin FIKIR fallback sablonu eksik / bos`)
    for (const asama of asamaKeys) {
      if (!asamaIdsSet.has(asama)) throw new Error(`[asamalar-sablonlar.ts] Bilinmeyen asama: ${asama}`)
      const liste = byAsama[asama]
      if (!liste || liste.length < 1) throw new Error(`[asamalar-sablonlar.ts] Bos sablon: ${y}/${asama}`)
      const seen = new Set<string>()
      for (const ihtiyacId of liste) {
        if (!GERCEK_IHTIYAC_IDS.has(ihtiyacId)) throw new Error(`[asamalar-sablonlar.ts] Bilinmeyen ihtiyac: ${y}/${asama} -> ${ihtiyacId}`)
        if (seen.has(ihtiyacId)) throw new Error(`[asamalar-sablonlar.ts] Duplicate ihtiyac: ${y}/${asama} -> ${ihtiyacId}`)
        seen.add(ihtiyacId)
        kapsanan.add(ihtiyacId)
      }
    }
  }

  // --- 5) Kapsama: ihtiyaclar.ts'teki her ID en az bir sablonda gecmeli ---
  for (const id of GERCEK_IHTIYAC_IDS) {
    if (!kapsanan.has(id)) throw new Error(`[asamalar-sablonlar.ts] Kapsanmayan ihtiyac (hicbir sablonda yok): ${id}`)
  }

  // --- 6) FIKIR fallback davranisi - degistirilmedi, sadece dogrulandi ---
  // Bilinmeyen YapiTuru -> []
  if (getOnerilenIhtiyaclar('BILINMEYEN_YAPI', 'FIKIR').length !== 0) throw new Error('[asamalar-sablonlar.ts] Fallback bozulmus: bilinmeyen YapiTuru [] donmeli')
  // Bilinmeyen Asama -> o YapiTuru'nun FIKIR listesi
  for (const y of BEKLENEN_YAPI_TURU_IDS) {
    const fallback = getOnerilenIhtiyaclar(y, 'BILINMEYEN_ASAMA')
    const fikir = ihtiyacSablonlari[y]['FIKIR']
    if (fallback.length !== fikir.length || !fallback.every((v, i) => v === fikir[i])) throw new Error(`[asamalar-sablonlar.ts] FIKIR fallback bozulmus: ${y}`)
  }
  // Bilinen Asama -> o Asama'nin listesi (FIKIR'a dusmemeli)
  const tasarimVilla = getOnerilenIhtiyaclar('KONUT_VILLA', 'TASARIM')
  if (tasarimVilla.length !== 4 || tasarimVilla[0] !== 'MIMARI_PROJE') throw new Error('[asamalar-sablonlar.ts] TASARIM sablonu bozulmus: KONUT_VILLA/TASARIM')
})()

export const asamaIds = projeAsamalari.map((a) => a.id)