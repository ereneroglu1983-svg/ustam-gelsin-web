// app/sitemap.ts - FINAL v12.6 - 973 İLÇE EKLENDİ - 4456 URL
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

  // 81 şehir + 3483 hizmet + 973 ilçe = 4537 + 2 base = 4539 + rehber bloglar
  for (const c of cities) {
    // Şehir sayfası
    urls.push({
      url: `${base}/${c.slug}`,
      lastModified: now,
      changeFrequency: 'daily',
      priority: 0.9
    })

    // Hizmet sayfaları (43 x 81 = 3483)
    for (const j of jobs) {
      urls.push({
        url: `${base}/${c.slug}/${j.slug}`,
        lastModified: now,
        changeFrequency: 'weekly',
        priority: 0.7
      })
    }

    // İLÇE SAYFALARI - YENİ EKLENDİ (973 ilçe)
    // Bu kısım eski sitemap'te yoktu, Google ilçeleri görmüyordu
    for (const d of c.districts) {
      urls.push({
        url: `${base}/${c.slug}/${d.slug}`,
        lastModified: now,
        changeFrequency: 'weekly',
        priority: 0.9 // İlçe sayfaları yüksek öncelikli - lokal SEO için kritik
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

  console.log(`[SITEMAP] Toplam URL: ${urls.length} (Base:2 + Şehir:81 + Hizmet:3483 + İlçe:973 + Rehber:${urls.length - 4539})`)

  return urls
}
