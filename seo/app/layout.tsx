export const metadata = { 
  title: 'Hemen Ustam Gelsin - En Yakın Usta', 
  description: '81 ilde 42 iş kolunda en yakın ustayı bul, Hemen Ustam Gelsin ile hemen teklif al',
  verification: {
    yandex: '1992acbf758234c0'
  },
  alternates: {
    canonical: 'https://hemenustamgelsin.com'
  }
}

export default function RootLayout({children}:{children:React.ReactNode}){
  // --- SCHEMA.ORG - SITE GENELI - START BOSS ---
  const websiteSchema = {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": "Hemen Ustam Gelsin",
    "url": "https://hemenustamgelsin.com",
    "description": "81 ilde 42 iş kolunda en yakın ustayı bul, Hemen Ustam Gelsin ile hemen teklif al",
    "inLanguage": "tr-TR",
    "publisher": {
      "@type": "Organization",
      "name": "Hemen Ustam Gelsin",
      "url": "https://hemenustamgelsin.com",
      "logo": {
        "@type": "ImageObject",
        "url": "https://hemenustamgelsin.com/logo.png"
      }
    },
    "potentialAction": {
      "@type": "SearchAction",
      "target": {
        "@type": "EntryPoint",
        "urlTemplate": "https://hemenustamgelsin.com/search?q={search_term_string}"
      },
      "query-input": "required name=search_term_string"
    }
  }

  const organizationSchema = {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "Hemen Ustam Gelsin",
    "url": "https://hemenustamgelsin.com",
    "logo": "https://hemenustamgelsin.com/logo.png",
    "description": "Türkiye'nin 81 ilinde 42 kategoride komisyonsuz, kesintisiz usta bulma platformu. Keşif + Fiyatlama Motoru ile %80 otomatik fiyat.",
    "slogan": "En Yakın Usta 5 Dakikada Kapında - %0 Komisyon",
    "foundingDate": "2024",
    "areaServed": {
      "@type": "Country",
      "name": "Turkey"
    },
    "sameAs": [
      "https://www.instagram.com/hemenustamgelsin",
      "https://www.facebook.com/hemenustamgelsin"
    ],
    "contactPoint": {
      "@type": "ContactPoint",
      "contactType": "customer support",
      "availableLanguage": ["Turkish"],
      "url": "https://hemenustamgelsin.com"
    }
  }
  // --- SCHEMA.ORG - SITE GENELI - END BOSS ---

  return (
    <html lang="tr">
      <head>
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(websiteSchema) }} />
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }} />
      </head>
      <body style={{margin:0, fontFamily:'system-ui', background:'#f8fafc'}}>{children}</body>
    </html>
  )
}