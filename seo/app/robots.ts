export const dynamic = 'force-static'

export default function robots() {
  return {
    rules: {
      userAgent: '*',
      allow: '/',
      disallow: ['/api/', '/_next/', '/admin'],
    },
    sitemap: 'https://hemenustamgelsin.com/sitemap.xml',
  }
}