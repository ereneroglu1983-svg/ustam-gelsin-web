// app/page.tsx - ANA SAYFA - SEO + DÖNÜŞÜM CANAVARI
import { cities } from '../data/cities'
import { jobs } from '../data/jobs'
import Link from 'next/link'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: `Hemen Ustam Gelsin - 81 İlde ${jobs.length} Kategoride Komisyonsuz Usta Bul, İş Bul`,
  description: `81 ilde ${jobs.length} kategoride doğrulanmış ustalar. Boya, elektrik, tesisat, fayans ve ${jobs.length}+ hizmet. Komisyon yok, hakediş %100 ustanın. Hemen ilan ver, 15 dk'da teklif al.`,
  alternates: { canonical: 'https://hemenustamgelsin.com' },
  openGraph: {
    title: 'Hemen Ustam Gelsin - Komisyonsuz Usta Platformu',
    description: `81 ilde ${jobs.length} kategoride komisyonsuz usta bul`,
    url: 'https://hemenustamgelsin.com',
    type: 'website',
    locale: 'tr_TR',
    siteName: 'Hemen Ustam Gelsin'
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Hemen Ustam Gelsin - Komisyonsuz Usta Bul',
    description: '81 ilde doğrulanmış ustalar, komisyon yok'
  },
  robots: { index: true, follow: true }
}

export default function Home(){
  const totalPages = cities.length * jobs.length

  const organizationSchema = {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "Hemen Ustam Gelsin",
    "url": "https://hemenustamgelsin.com",
    "logo": "https://hemenustamgelsin.com/logo.png",
    "sameAs": [
      "https://www.linkedin.com/in/hemen-ustam-gelsin-2499b2415/",
      "https://www.instagram.com/hemenustamgelsin/",
      "https://www.facebook.com/profile.php?id=61591164702200",
      "https://x.com/Hemenustamglsn",
      "https://www.tiktok.com/@hemen_ustam_gelsin",
      "https://www.youtube.com/@HemenUstamGelsin"
    ]
  }

  const websiteSchema = {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": "Hemen Ustam Gelsin",
    "url": "https://hemenustamgelsin.com",
    "potentialAction": {
      "@type": "SearchAction",
      "target": "https://hemenustamgelsin.com/rehber?search={search_term_string}",
      "query-input": "required name=search_term_string"
    }
  }

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(websiteSchema) }} />

      {/* HERO - DÖNÜŞÜM */}
      <section style={{background:'#111', color:'white', padding:'60px 20px', textAlign:'center'}}>
        <div style={{maxWidth:900, margin:'0 auto'}}>
          <div style={{display:'inline-flex', background:'#222', border:'1px solid #333', borderRadius:999, padding:'6px 12px', fontSize:11, fontWeight:700, letterSpacing:1, marginBottom:16}}>✓ {totalPages} AKTİF SAYFA • 81 İL • {jobs.length} İŞ KOLU • %0 KOMİSYON</div>
          <h1 style={{fontSize:'clamp(32px, 5vw, 56px)', fontWeight:900, lineHeight:0.95, margin:0}}>81 İlde Komisyonsuz<br/>Usta Bul, İş Bul</h1>
          <p style={{color:'#a8a29e', fontSize:16, marginTop:14, maxWidth:600, margin:'14px auto 0'}}>Boya, elektrik, tesisat, fayans ve {jobs.length}+ kategoride doğrulanmış ustalar. Hakediş %100 ustanın, fiyat şişmez.</p>
          <div style={{marginTop:28, display:'flex', gap:12, justifyContent:'center', flexWrap:'wrap'}}>
            <a href="https://hemenustamgelsin.com?utm_source=seo&utm_medium=homepage&utm_campaign=ilan_ver" style={{background:'white', color:'black', padding:'16px 28px', borderRadius:12, fontWeight:900, textDecoration:'none', display:'inline-block'}}>MÜŞTERİYİM, İLAN VER →</a>
            <a href="https://hemenustamgelsin.com?utm_source=seo&utm_medium=homepage&utm_campaign=usta_ol" style={{background:'transparent', border:'1px solid #333', color:'white', padding:'16px 28px', borderRadius:12, fontWeight:800, textDecoration:'none', display:'inline-block'}}>USTAYIM, İŞ AL</a>
          </div>
        </div>
      </section>

      {/* İŞ KOLLARI - İÇ LİNK */}
      <section style={{maxWidth:1100, margin:'0 auto', padding:'28px 20px'}}>
        <h2 style={{fontSize:14, fontWeight:800, letterSpacing:1, color:'#78716c'}}>POPÜLER İŞ KOLLARI - {jobs.length} KATEGORİ</h2>
        <div style={{marginTop:12, display:'flex', flexWrap:'wrap', gap:8}}>
          {jobs.map(j => (
            <Link key={j.slug} href={`/istanbul/${j.slug}`} style={{background:'white', border:'1px solid #e7e5e4', padding:'10px 14px', borderRadius:999, textDecoration:'none', color:'#111', fontWeight:600, fontSize:13}}>
              {j.name}
            </Link>
          ))}
        </div>
      </section>

      {/* İLLER - İÇ LİNK */}
      <section style={{maxWidth:1100, margin:'0 auto', padding:'0 20px 60px'}}>
        <h2 style={{fontSize:14, fontWeight:800, letterSpacing:1, color:'#78716c'}}>81 İLDE HİZMET - {totalPages} SAYFA</h2>
        <p style={{fontSize:12, color:'#a8a29e', marginTop:4}}>{totalPages} otomatik SEO sayfası Google için hazır, her biri indexleniyor.</p>
        <div style={{marginTop:16, display:'grid', gridTemplateColumns:'repeat(auto-fill,minmax(150px,1fr))', gap:8}}>
          {cities.map(c=>(
            <Link key={c.slug} href={`/${c.slug}`} style={{padding:'10px 12px', background:'white', border:'1px solid #e7e5e4', borderRadius:10, textDecoration:'none', color:'#111', fontWeight:600, fontSize:13}}>
              {c.name} <span style={{color:'#a8a29e', fontSize:11}}>→ {jobs.length}</span>
            </Link>
          ))}
        </div>

        <div style={{marginTop:24, display:'flex', gap:8, flexWrap:'wrap'}}>
          <Link href="/usta-is-ilanlari" style={{background:'#111', color:'white', padding:'10px 16px', borderRadius:10, textDecoration:'none', fontWeight:700, fontSize:12}}>Usta İş İlanları →</Link>
          <Link href="/rehber" style={{background:'white', border:'1px solid #e7e5e4', color:'#111', padding:'10px 16px', borderRadius:10, textDecoration:'none', fontWeight:700, fontSize:12}}>İnşaat Rehberi →</Link>
        </div>
      </section>
    </main>
  )
}