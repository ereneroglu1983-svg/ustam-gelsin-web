// lib/slugMaps.ts - P0.2 - FINAL v2 - cities.ts + jobs.ts göre - VARSAYIM YOK
import { cities } from '../data/cities'
import { jobs } from '../data/jobs'

// 81 İl: plate -> slug
export const sehirIdToSlug: Record<string, string> = {}
export const sehirAdiToSlug: Record<string, string> = {}
export const ilceAdiToSlug: Record<string, string> = {}

for (const city of cities) {
  sehirIdToSlug[String(city.plate)] = city.slug

  // ANTALYA, Antalya, antalya -> antalya
  sehirAdiToSlug[city.name.toUpperCase()] = city.slug
  sehirAdiToSlug[city.name.toLocaleUpperCase('tr-TR')] = city.slug
  sehirAdiToSlug[city.name] = city.slug
  sehirAdiToSlug[city.slug] = city.slug

  for (const dist of city.districts) {
    ilceAdiToSlug[dist.name.toUpperCase()] = dist.slug
    ilceAdiToSlug[dist.name.toLocaleUpperCase('tr-TR')] = dist.slug
    ilceAdiToSlug[dist.name] = dist.slug
  }
}

// İş Kolu: name -> slug (jobs.ts'te id yok, isimle map)
export const kategoriAdiToSlug: Record<string, string> = {}

for (const job of jobs) {
  // Epoksi Zemin Kaplama -> epoksi-zemin-kaplama
  kategoriAdiToSlug[job.name.toUpperCase()] = job.slug
  kategoriAdiToSlug[job.name.toLocaleUpperCase('tr-TR')] = job.slug
  kategoriAdiToSlug[job.name] = job.slug
  kategoriAdiToSlug[job.slug] = job.slug
}

export function normalizeTR(text: string): string {
  if (!text) return ""
  return text.toLocaleLowerCase('tr-TR')
    .replace(/ğ/g,'g').replace(/ü/g,'u').replace(/ş/g,'s')
    .replace(/ı/g,'i').replace(/ö/g,'o').replace(/ç/g,'c')
    .normalize('NFD').replace(/[\u0300-\u036f]/g,'')
    .replace(/[^a-z0-9]+/g,'-').replace(/^-|-$/g,'').trim()
}

export function getUstaSehirSlug(doc: any): string | null {
  if (doc.sehir_slug) return doc.sehir_slug
  if (doc.sehir_id && sehirIdToSlug[String(doc.sehir_id)]) return sehirIdToSlug[String(doc.sehir_id)]
  if (doc.ilId && sehirIdToSlug[String(doc.ilId)]) return sehirIdToSlug[String(doc.ilId)]
  if (doc.sehir_adi && sehirAdiToSlug[doc.sehir_adi]) return sehirAdiToSlug[doc.sehir_adi]
  if (doc.sehir_adi && sehirAdiToSlug[doc.sehir_adi.toUpperCase()]) return sehirAdiToSlug[doc.sehir_adi.toUpperCase()]
  if (doc.sehir_adi && sehirAdiToSlug[doc.sehir_adi.toLocaleUpperCase('tr-TR')]) return sehirAdiToSlug[doc.sehir_adi.toLocaleUpperCase('tr-TR')]
  if (doc.sehir_adi) return normalizeTR(doc.sehir_adi)
  return null
}

export function getUstaIlceSlug(doc: any): string | null {
  if (doc.ilce_slug) return doc.ilce_slug
  if (doc.ilce_adi && ilceAdiToSlug[doc.ilce_adi]) return ilceAdiToSlug[doc.ilce_adi]
  if (doc.ilce_adi && ilceAdiToSlug[doc.ilce_adi.toUpperCase()]) return ilceAdiToSlug[doc.ilce_adi.toUpperCase()]
  if (doc.ilce_adi && ilceAdiToSlug[doc.ilce_adi.toLocaleUpperCase('tr-TR')]) return ilceAdiToSlug[doc.ilce_adi.toLocaleUpperCase('tr-TR')]
  if (doc.ilce_adi) return normalizeTR(doc.ilce_adi)
  return null
}

export function getKategoriSlug(doc: any): string | null {
  const raw = doc.kategori || doc.kategori_adi || doc.uzmanlik || (doc.uzmanliklar && doc.uzmanliklar[0])
  if (!raw) return null
  if (typeof raw === 'string') {
    if (kategoriAdiToSlug[raw]) return kategoriAdiToSlug[raw]
    if (kategoriAdiToSlug[raw.toUpperCase()]) return kategoriAdiToSlug[raw.toUpperCase()]
    if (kategoriAdiToSlug[raw.toLocaleUpperCase('tr-TR')]) return kategoriAdiToSlug[raw.toLocaleUpperCase('tr-TR')]
    return normalizeTR(raw)
  }
  return null
}

console.log(`[slugMaps] ${cities.length} il, ${jobs.length} iş kolu maplendi`)