// app/hug-proje-sitemap.xml/route.ts - HUG PROJE sitemap - hug-market-sitemap.xml düzeniyle
export const dynamic = 'force-static'
export const revalidate = 86400
import { cities } from '../../data/cities'
import ilcelerData from '../../data/ilceler.json'
import { profesyonelSeoSayfalari } from '../../data/hug-proje-profesyoneller'
import { projeTurleri } from '../../data/hug-proje-proje-turleri'
import { ihtiyaclar } from '../../data/hug-proje-ihtiyaclar'

const BASE = 'https://hemenustamgelsin.com'

function urlEntry(loc: string, changefreq = 'weekly', priority = '0.7') {
  return `  <url>\n    <loc>${loc}</loc>\n    <changefreq>${changefreq}</changefreq>\n    <priority>${priority}</priority>\n  </url>`
}

export async function GET() {
  const urls: string[] = []

  // Ana hub
  urls.push(urlEntry(`${BASE}/hug-proje/`, 'daily', '1.0'))

  // Profesyoneller - 14
  for (const pr of profesyonelSeoSayfalari) {
    urls.push(urlEntry(`${BASE}/hug-proje/profesyonel/${pr.seoSlug}/`, 'weekly', '0.8'))
  }

  // Proje türleri - 11
  for (const t of projeTurleri) {
    urls.push(urlEntry(`${BASE}/hug-proje/proje-turu/${t.seoSlug}/`, 'weekly', '0.8'))
  }

  // İhtiyaçlar - 19
  for (const i of ihtiyaclar) {
    urls.push(urlEntry(`${BASE}/hug-proje/ihtiyac/${i.seoSlug}/`, 'weekly', '0.8'))
  }

  // İller - 81 + İlçeler - 973
  for (const c of cities as any[]) {
    urls.push(urlEntry(`${BASE}/hug-proje/iller/${c.slug}/`, 'weekly', '0.8'))
    const districts: any[] = c.districts?.length
      ? c.districts
      : (ilcelerData as any[]).filter((d: any) => d.sehir_slug === c.slug || d.city_slug === c.slug || d.il_slug === c.slug || d.sehir === c.name)
    for (const d of districts) {
      urls.push(urlEntry(`${BASE}/hug-proje/iller/${c.slug}/ilceler/${d.slug}/`, 'monthly', '0.6'))
    }
  }

  const xml = `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${urls.join('\n')}\n</urlset>`

  return new Response(xml, {
    headers: { 'Content-Type': 'application/xml; charset=utf-8' },
  })
}