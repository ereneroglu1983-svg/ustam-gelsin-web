// app/sitemap.ts - MÜŞTERİ SITEMAP - DOKUNMADAN DÜZELTİLMİŞ
import type { MetadataRoute } from 'next'
import { cities } from '../data/cities'
import { jobs } from '../data/jobs'
import { collection, getDocs } from 'firebase/firestore'
import { db } from '../lib/firebase'

export const dynamic = 'force-static'
export const revalidate = 86400 // 24 saatte bir yenile, Firebase yüklenmesin

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const base = 'https://hemenustamgelsin.com'
  const now = new Date()

  const urls: MetadataRoute.Sitemap = [
    { url: base, lastModified: now, changeFrequency: 'daily', priority: 1 },
    { url: `${base}/rehber`, lastModified: now, changeFrequency: 'daily', priority: 0.9 },
  ]

  for (const c of cities) {
    urls.push({
      url: `${base}/${c.slug}`,
      lastModified: now,
      changeFrequency: 'daily',
      priority: 0.9
    })

    for (const j of jobs) {
      urls.push({
        url: `${base}/${c.slug}/${j.slug}`,
        lastModified: now,
        changeFrequency: 'weekly',
        priority: 0.7
      })
    }
  }

  // REHBER BLOGLAR - Build patlamasın diye izole
  try {
    const snap = await getDocs(collection(db, 'icerikler'))
    for (const doc of snap.docs) {
      const data = doc.data() as any
      const slug = data.slug || doc.id
      if(!slug) continue

      urls.push({
        url: `${base}/rehber/${slug}`,
        lastModified: data.tarih?.toDate ? data.tarih.toDate() : now,
        changeFrequency: 'weekly',
        priority: 0.8
      })
    }
  } catch (e) {
    console.log('Rehber sitemap skip (build):', e)
  }

  return urls
}