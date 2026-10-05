// app/usta-sitemap.xml/route.ts - FINAL v2.2 - REVIZE - trailingSlash fix - 3565 URL
export const dynamic = 'force-static'
export const revalidate = 86400

import { cities } from '../../data/cities'
import { jobs } from '../../data/jobs'

export async function GET() {
  const base = 'https://hemenustamgelsin.com'
  const contentDate = new Date('2026-10-01').toISOString()

  const urls: string[] = []
  urls.push(`${base}/usta-is-ilanlari/`)

  for (const c of cities) {
    urls.push(`${base}/usta-is-ilanlari/${c.slug}/`)
    for (const j of jobs) {
      urls.push(`${base}/usta-is-ilanlari/${c.slug}/${j.slug}/`)
    }
  }

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls.map(u => `  <url><loc>${u}</loc><lastmod>${contentDate}</lastmod></url>`).join('\n')}
</urlset>`

  return new Response(xml, {
    headers: { 'Content-Type': 'application/xml; charset=utf-8' },
  })
}
