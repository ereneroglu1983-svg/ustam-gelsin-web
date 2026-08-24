export const dynamic = 'force-static'
import { cities } from '../data/cities'
import { jobs } from '../data/jobs'

export default function sitemap(){
  const base='https://hemenustamgelsin.com'
  const now = new Date()
  const urls: any[] = [
    { url: base, lastModified: now, changeFrequency: 'daily', priority: 1 },
  ]

  for(const c of cities){
    // Şehir sayfası - en önemli
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
  return urls
}