// app/sitemap.ts
export const dynamic = 'force-static'

import { cities } from '../data/cities'
import { jobs } from '../data/jobs'
import { collection, getDocs } from 'firebase/firestore'
import { db } from '../lib/firebase' // <-- SENİN FİREBASE DOSYAN, YOLU KONTROL ET

export default async function sitemap(){
  const base='https://hemenustamgelsin.com'
  const now = new Date()
  const urls: any[] = [
    { url: base, lastModified: now, changeFrequency: 'daily', priority: 1 },
    { url: `${base}/rehber`, lastModified: now, changeFrequency: 'daily', priority: 0.9 }, // REHBER HUB EKLENDİ
  ]

  for(const c of cities){
    // Şehir sayfası - 81 sayfa
    urls.push({ url: `${base}/${c.slug}`, lastModified: now, changeFrequency: 'daily', priority: 0.9 })

    for(const j of jobs){
      // İş + Şehir sayfası - 3402 sayfa
      urls.push({
        url: `${base}/${c.slug}/${j.slug}`,
        lastModified: now,
        changeFrequency: 'weekly',
        priority: 0.7
      })
    }
  }

  // --- YENİ EKLENEN KISIM: REHBER BLOGLAR ---
  try {
    const snap = await getDocs(collection(db, 'icerikler'))
    for(const doc of snap.docs){
      const data = doc.data() as any
      // Senin Flutter'da doc ID = slug yaptığın için doc.id = slug
      const slug = data.slug || doc.id
      urls.push({
        url: `${base}/rehber/${slug}`,
        lastModified: data.tarih?.toDate ? data.tarih.toDate() : now,
        changeFrequency: 'weekly' as const,
        priority: 0.8
      })
    }
  } catch (e) {
    console.log('Rehber sitemap hatası (build sırasında normal olabilir):', e)
  }

  return urls
}