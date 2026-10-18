// app/sitemap.ts - FINAL v14.0 - FIXED
import type { MetadataRoute } from 'next'
import { cities } from '../data/cities'
import { jobs } from '../data/jobs'
import { collection, getDocs } from 'firebase/firestore'
import { db } from '../lib/firebase'

export const dynamic = 'force-static'
export const revalidate = 86400

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const base = 'https://hemenustamgelsin.com'
  const contentDate = new Date()

  const urls: MetadataRoute.Sitemap = [
    { url: `${base}/`, lastModified: contentDate, changeFrequency: 'daily', priority: 1 },
    { url: `${base}/rehber/`, lastModified: contentDate, changeFrequency: 'daily', priority: 0.8 },
    { url: `${base}/uygulama/`, lastModified: contentDate, changeFrequency: 'monthly', priority: 0.9 },
    { url: `${base}/indir/`, lastModified: contentDate, changeFrequency: 'monthly', priority: 0.9 }, // ✅ EKLENDİ
    { url: `${base}/hakkimizda/`, lastModified: contentDate, changeFrequency: 'monthly', priority: 0.5 },
  ]

  for (const c of cities) {
    urls.push({ url: `${base}/${c.slug}/`, lastModified: contentDate, changeFrequency: 'weekly', priority: 0.8 })
    for (const j of jobs) {
      urls.push({ url: `${base}/${c.slug}/${j.slug}/`, lastModified: contentDate, changeFrequency: 'weekly', priority: 0.6 })
    }
    for (const d of c.districts) {
      urls.push({ url: `${base}/${c.slug}/${d.slug}/`, lastModified: contentDate, changeFrequency: 'weekly', priority: 0.7 })
    }
  }

  try {
    const snap = await getDocs(collection(db, 'icerikler'))
    for (const doc of snap.docs) {
      const data = doc.data() as any
      const slug = data.slug || doc.id
      if (!slug) continue
      urls.push({
        url: `${base}/rehber/${slug}/`,
        lastModified: data.tarih?.toDate ? data.tarih.toDate() : contentDate,
        changeFrequency: 'weekly',
        priority: 0.7,
      })
    }
  } catch {}

  console.log(`[SITEMAP v14.0] Toplam URL: ${urls.length} | /uygulama + /indir OK`)

  return urls
}