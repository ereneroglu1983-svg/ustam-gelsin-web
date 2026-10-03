// app/robots.ts - FINAL v2 - llms.txt sitemap listesinden çıkarıldı
export const dynamic = 'force-static'

export default function robots() {
  return {
    rules: {
      userAgent: '*',
      allow: '/',
      disallow: ['/api/', '/_next/', '/admin'],
    },
    sitemap: [
      'https://hemenustamgelsin.com/sitemap.xml',
      'https://hemenustamgelsin.com/usta-sitemap.xml',
      'https://hemenustamgelsin.com/hug-market-sitemap.xml',
    ],
  }
}