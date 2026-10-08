// app/sitemap.ts - FINAL v13.0 - HUG App Architecture - /uygulama eklendi - Play URL YOK
import type { MetadataRoute } from 'next'
import { cities } from '../data/cities'
import { jobs } from '../data/jobs'
import { collection, getDocs } from 'firebase/firestore'
import { db } from '../lib/firebase'

export const dynamic = 'force-static'
export const revalidate = 86400 // 24 saat

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const base = 'https://hemenustamgelsin.com'
  const contentDate = new Date('2026-10-01')

  const urls: MetadataRoute.Sitemap = [
    { url: `${base}/`, lastModified: contentDate, changeFrequency: 'daily', priority: 1 },
    { url: `${base}/rehber/`, lastModified: contentDate, changeFrequency: 'daily', priority: 0.8 },
    // ✅ YENİ - ADIM 1: Uygulama landing page sitemap'e giriyor
    // Play Store URL'i ASLA buraya eklenmiyor
    { url: `${base}/uygulama/`, lastModified: contentDate, changeFrequency: 'monthly', priority: 0.9 },
  ]

  // Şehir + Hizmet + İlçe kombinasyonları
  for (const c of cities) {
    urls.push({
      url: `${base}/${c.slug}/`,
      lastModified: contentDate,
      changeFrequency: 'weekly',
      priority: 0.8,
    })

    for (const j of jobs) {
      urls.push({
        url: `${base}/${c.slug}/${j.slug}/`,
        lastModified: contentDate,
        changeFrequency: 'weekly',
        priority: 0.6,
      })
    }

    for (const d of c.districts) {
      urls.push({
        url: `${base}/${c.slug}/${d.slug}/`,
        lastModified: contentDate,
        changeFrequency: 'weekly',
        priority: 0.7,
      })
    }
  }

  // Firestore - Rehber içerikleri
  try {
    const snap = await getDocs(collection(db, 'icerikler'))
    for (const doc of snap.docs) {
      const data = doc.data() as any
      const slug = data.slug || doc.id
      if (!slug) continue

      urls.push({
        url: `${base}/rehber/${slug}/`,
        lastModified: data.tarih?.toDate ? data.tarih.toDate() : undefined,
        changeFrequency: 'weekly',
        priority: 0.7,
      })
    }
  } catch (e) {
    console.log('Rehber sitemap skip (build):', e)
  }

  console.log(`[SITEMAP v13.0] Toplam URL: ${urls.length} | /uygulama eklendi | Play URL yok`)

  return urls
}