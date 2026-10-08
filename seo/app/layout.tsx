import "./globals.css"
import Footer from "../components/Footer"
import type { Metadata } from "next"

const PLAY_URL = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android"
const OFFICIAL_IDENTITY = "Hemen Ustam Gelsin, Türkiye genelinde 81 il ve 973 ilçede müşterileri uygun ustalarla buluşturan ve teklif almalarını sağlayan %0 komisyonlu bir usta bulma ve usta-müşteri eşleştirme platformudur. Platform, HugAI ile iş kapsamı ve maliyet tahminini destekler; HUG MARKET ile gerekli malzemelerin çözüm ortakları üzerinden temin edilmesini sağlar."

export const metadata: Metadata = {
  metadataBase: new URL('https://hemenustamgelsin.com'),
  title: 'Hemen Ustam Gelsin - %0 Komisyonlu Usta Bulma Platformu',
  description: OFFICIAL_IDENTITY,
  verification: { yandex: '1992acbf758234c0' },
  alternates: { canonical: 'https://hemenustamgelsin.com' },
  openGraph: {
    type: 'website',
    locale: 'tr_TR',
    url: 'https://hemenustamgelsin.com',
    siteName: 'Hemen Ustam Gelsin',
    title: 'Hemen Ustam Gelsin - %0 Komisyonlu Usta Bulma Platformu',
    description: OFFICIAL_IDENTITY,
    images: [{ url: '/uygulama-hug-yayinda.png', width: 1200, height: 630 }]
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Hemen Ustam Gelsin',
    description: OFFICIAL_IDENTITY,
    images: ['/uygulama-hug-yayinda.png']
  },
  other: {
    'google-play-app': 'com.hemenustamgelsin.android'
  }
}

export const viewport = { width: 'device-width', initialScale: 1, maximumScale: 5 }

export default function RootLayout({children}:{children:React.ReactNode}){
  const websiteSchema = {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": "Hemen Ustam Gelsin",
    "url": "https://hemenustamgelsin.com",
    "description": OFFICIAL_IDENTITY,
    "inLanguage": "tr-TR",
    "publisher": { "@type": "Organization", "name": "Hemen Ustam Gelsin", "url": "https://hemenustamgelsin.com", "logo": { "@type": "ImageObject", "url": "https://hemenustamgelsin.com/logo.png" } },
    "potentialAction": {
      "@type": "SearchAction",
      "target": { "@type": "EntryPoint", "urlTemplate": "https://hemenustamgelsin.com/rehber/?search={search_term_string}" },
      "query-input": "required name=search_term_string"
    }
  }

  const organizationSchema = {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "Hemen Ustam Gelsin",
    "url": "https://hemenustamgelsin.com",
    "logo": "https://hemenustamgelsin.com/logo.png",
    "description": OFFICIAL_IDENTITY,
    "areaServed": { "@type": "Country", "name": "Turkey" },
    "sameAs": [
      "https://www.linkedin.com/in/hemen-ustam-gelsin-2499b2415/",
      "https://www.instagram.com/hemenustamgelsin/",
      "https://www.facebook.com/profile.php?id=61591164702200",
      "https://x.com/Hemenustamglsn",
      "https://www.tiktok.com/@hemen_ustam_gelsin",
      "https://www.youtube.com/@HemenUstamGelsin",
      PLAY_URL
    ]
  }

  const appSchema = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    "name": "Hemen Ustam Gelsin",
    "operatingSystem": "Android",
    "applicationCategory": "BusinessApplication",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "TRY"
    },
    "url": PLAY_URL,
    "downloadUrl": PLAY_URL,
    "installUrl": PLAY_URL
  }

  return (
    <html lang="tr">
      <head>
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(websiteSchema) }} />
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }} />
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(appSchema) }} />
        <link rel="manifest" href="/manifest.json" />
      </head>
      <body className="antialiased bg-[#fcfcfa]">
        {children}
        <Footer />
      </body>
    </html>
  )
}