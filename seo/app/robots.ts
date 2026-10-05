// app/robots.ts - FINAL v3 - REVIZE - trailingSlash uyumlu
import type { MetadataRoute } from 'next'

export const dynamic = 'force-static'

export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: '*',
      allow: '/',
      disallow: ['/api/', '/api', '/_next/', '/_next', '/admin/', '/admin'],
    },
    sitemap: [
      'https://hemenustamgelsin.com/sitemap.xml',
      'https://hemenustamgelsin.com/usta-sitemap.xml',
      'https://hemenustamgelsin.com/hug-market-sitemap.xml',
    ],
  }
}