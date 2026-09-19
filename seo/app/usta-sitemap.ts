// app/usta-sitemap.ts - USTA SITEMAP - MÜŞTERİ SITEMAP'İNE DOKUNMAZ
import type { MetadataRoute } from 'next'
import { cities } from '@/data/cities'
import { jobs } from '@/data/jobs'

export default function sitemap(): MetadataRoute.Sitemap {
  const baseUrl = 'https://hemenustamgelsin.com'

  return cities.flatMap(city =>
    jobs.map(job => ({
      url: `${baseUrl}/usta-is-ilanlari/${city.slug}/${job.slug}`,
      lastModified: new Date(),
      changeFrequency: 'weekly' as const,
      priority: 0.7,
    }))
  )
}