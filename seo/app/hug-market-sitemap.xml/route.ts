// app/hug-market-sitemap.xml/route.ts - FINAL v3.1 - IMPORT FIX - BUILD GEÇER
export const dynamic = 'force-static'
export const revalidate = 86400

import { cities } from '../../data/cities'

const HUG_CATS = [
  "banyo-mutfak",
  "temizlik-hijyen",
  "elektrik-aydinlatma",
  "hirdavat-el-aletleri-is-guvenligi",
  "bahce-peyzaj-dis-mekan",
  "tesisat-su-sistemleri",
  "yapi-malzemeleri-insaat",
  "boya-dekorasyon",
  "cati-cephe-sistemleri",
  "havuz-spa-sistemleri",
  "isitma-sogutma-iklimlendirme",
  "seramik-fayans-zemin",
  "yalitim-izolasyon",
  "cam-aluminyum-cephe-sistemleri",
  "yenilenebilir-enerji-guc-sistemleri",
  "kapi-kilit-gecis-kontrol",
  "guvenlik-yangin-zayif-akim",
  "asansor-yuruyen-merdiven"
] as const

export async function GET() {
  const base = 'https://hemenustamgelsin.com'
  const now = new Date().toISOString()

  const urls = [
    `${base}/hug-market`,
    `${base}/hug-market/cozum-ortagi`,
    ...HUG_CATS.map(c => `${base}/hug-market/cozum-ortakligi/${c}`),
    ...cities.flatMap(city => HUG_CATS.map(cat => `${base}/hug-market/${city.slug}/${cat}`))
  ]

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls.map(u => `  <url><loc>${u}</loc><lastmod>${now}</lastmod></url>`).join("\n")}
</urlset>`

  return new Response(xml, {
    headers: { "Content-Type": "application/xml; charset=utf-8" },
  })
}