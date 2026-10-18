// app/sitemap.ts - FINAL v15.0 - TAM & EKSİKSİZ
import type { MetadataRoute } from 'next'
import { cities } from '../data/cities'
import { jobs } from '../data/jobs'
import { collection, getDocs } from 'firebase/firestore'
import { db } from '../lib/firebase'

export const dynamic = 'force-static'
export const revalidate = 86400 // 24 saatte bir yenile

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const base = 'https://hemenustamgelsin.com'
  const contentDate = new Date()

  const urls: MetadataRoute.Sitemap = [
    { url: `${base}/`, lastModified: contentDate, changeFrequency: 'daily', priority: 1 },
    { url: `${base}/rehber/`, lastModified: contentDate, changeFrequency: 'daily', priority: 0.8 },
    { url: `${base}/uygulama/`, lastModified: contentDate, changeFrequency: 'monthly', priority: 0.9 },
    { url: `${base}/indir/`, lastModified: contentDate, changeFrequency: 'monthly', priority: 0.9 },
    { url: `${base}/hakkimizda/`, lastModified: contentDate, changeFrequency: 'monthly', priority: 0.5 },
    { url: `${base}/usta-kayit/`, lastModified: contentDate, changeFrequency: 'monthly', priority: 0.8 },
  ]

  // 1. HİZMET sayfaları (43 adet) - EKSİKTİ, EKLENDİ
  for (const j of jobs) {
    urls.push({
      url: `${base}/hizmet/${j.slug}/`,
      lastModified: contentDate,
      changeFrequency: 'weekly',
      priority: 0.7
    })
  }

  // 2. ŞEHİR + İLÇE + KOMBİNASYONLAR
  for (const c of cities) {
    // Şehir ana sayfa
    urls.push({ url: `${base}/${c.slug}/`, lastModified: contentDate, changeFrequency: 'weekly', priority: 0.8 })

    // Şehir + Hizmet kombinasyonu (3483 sayfa)
    for (const j of jobs) {
      urls.push({ url: `${base}/${c.slug}/${j.slug}/`, lastModified: contentDate, changeFrequency: 'weekly', priority: 0.6 })
    }

    // İlçe sayfaları (973 ilçe)
    for (const d of c.districts) {
      urls.push({ url: `${base}/${c.slug}/${d.slug}/`, lastModified: contentDate, changeFrequency: 'weekly', priority: 0.7 })

      // İlçe + Hizmet (İstersen bunu da açabilirsin - devasa olur: 973x43 = 41k URL)
      // for (const j of jobs) {
      //   urls.push({ url: `${base}/${c.slug}/${d.slug}/${j.slug}/`, lastModified: contentDate, changeFrequency: 'weekly', priority: 0.5 })
      // }
    }
  }

  // 3. REHBER içerikleri (Firebase'den)
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
  } catch (e) {
    console.error('[SITEMAP] Firebase okuma hatası:', e)
  }

  console.log(`[SITEMAP v15.0] Toplam URL: ${urls.length} | 43 hizmet + 81 il + 3483 kombine + ilçeler + rehber OK`)

  return urls
}