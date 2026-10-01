// app/robots.ts
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
      'https://hemenustamgelsin.com/llms.txt',
      'https://hemenustamgelsin.com/llms-full.txt',
      'https://hemenustamgelsin.com/llms-hug-full.txt',
    ],
  }
}