export const dynamic = 'force-static'

import { cities } from '../../data/cities'
import { jobs } from '../../data/jobs'

export async function GET() {
  const base = 'https://hemenustamgelsin.com'
  const now = new Date().toISOString()

  const urls: string[] = []
  urls.push(`${base}/usta-is-ilanlari`)

  for (const c of cities) {
    urls.push(`${base}/usta-is-ilanlari/${c.slug}`)
    for (const j of jobs) {
      urls.push(`${base}/usta-is-ilanlari/${c.slug}/${j.slug}`)
    }
  }

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls.map(u => `  <url><loc>${u}</loc><lastmod>${now}</lastmod><changefreq>weekly</changefreq><priority>0.7</priority></url>`).join('\n')}
</urlset>`

  return new Response(xml, {
    headers: { 'Content-Type': 'application/xml' },
  })
}