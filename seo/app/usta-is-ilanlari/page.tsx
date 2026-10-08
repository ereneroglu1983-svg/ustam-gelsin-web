// app/usta-is-ilanlari/page.tsx - FINAL v2.1 - PLAY BANNER
import { cities } from '../../data/cities'
import { jobs } from '../../data/jobs'
import Link from 'next/link'
import type { Metadata } from 'next'

const PLAY_URL_CLEAN = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android"
const PLAY_URL_USTA_HUB = `${PLAY_URL_CLEAN}&pcampaignid=web_usta_hub_banner`

export const metadata: Metadata = {
  title: `Usta İş İlanları - 81 İlde ${jobs.length} Kategoride Komisyonsuz İş Bul | Hemen Ustam Gelsin`,
  description: `81 ilde ${jobs.length} kategoride usta iş ilanları. Komisyon yok, hakediş %100 senin. Şehrini ve uzmanlık alanını seç, uygun iş ilanlarını keşfet.`,
  alternates: { canonical: 'https://hemenustamgelsin.com/usta-is-ilanlari/' },
  openGraph: {
    title: `Usta İş İlanları - 81 İlde İş Bul`,
    description: `${jobs.length} kategoride komisyonsuz usta iş ilanları`,
    url: 'https://hemenustamgelsin.com/usta-is-ilanlari/',
    type: 'website',
    locale: 'tr_TR',
    siteName: 'Hemen Ustam Gelsin'
  }
}

export default function UstaIlanlariHub() {
  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com/" },
      { "@type": "ListItem", "position": 2, "name": "Usta İş İlanları", "item": "https://hemenustamgelsin.com/usta-is-ilanlari/" }
    ]
  }

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />

      <section style={{background:'#111', color:'white', padding:'48px 20px', textAlign:'center'}}>
        <h1 style={{fontSize:'clamp(28px, 4.5vw, 48px)', fontWeight:900, lineHeight:0.95, margin:0}}>Usta mısın? 81 İlde İş Hazır.</h1>
        <p style={{color:'#a8a29e', fontSize:16, marginTop:12}}>Komisyon yok, hakediş %100 senin. 2 dakikada kayıt ol, iş al.</p>
        <div style={{marginTop:24, display:'flex', gap:12, justifyContent:'center', flexWrap:'wrap'}}>
          <a href={PLAY_URL_USTA_HUB} target="_blank" rel="noopener"
             style={{background:'white', color:'black', padding:'16px 28px', borderRadius:12, fontWeight:900, textDecoration:'none', display:'inline-block'}}>
            📱 UYGULAMAYI İNDİR, İŞ AL →
          </a>
          <a href="https://hemenustamgelsin.com/?utm_source=seo&utm_medium=usta_hub&utm_campaign=ilan_ver"
             style={{background:'transparent', color:'white', border:'1px solid #333', padding:'16px 28px', borderRadius:12, fontWeight:800, textDecoration:'none', display:'inline-block'}}>
            MÜŞTERİYİM, İLAN VER
          </a>
        </div>
      </section>

      {/* PLAY BANNER */}
      <div style={{maxWidth:1120, margin:'14px auto 0', padding:'0 20px'}}>
        <div style={{background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:14, padding:'12px 16px', display:'flex', justifyContent:'space-between', alignItems:'center', gap:12, flexWrap:'wrap'}}>
          <div style={{display:'flex', alignItems:'center', gap:12}}>
            <div style={{width:36, height:36, background:'#111', color:'white', borderRadius:8, display:'grid', placeItems:'center', fontSize:18}}>⚡</div>
            <div>
              <div style={{color:'#111', fontWeight:800, fontSize:14}}>Android Uygulaması YAYINDA! %0 Komisyon</div>
              <div style={{color:'#166534', fontSize:12}}>{jobs.length} kategoride işleri mobil uygulamadan takip et, anında teklif ver.</div>
            </div>
          </div>
          <a href={PLAY_URL_USTA_HUB} target="_blank" rel="noopener" style={{background:'#111', color:'white', padding:'10px 16px', borderRadius:10, fontWeight:800, fontSize:13, textDecoration:'none', whiteSpace:'nowrap'}}> 【entity-Google Play¦canonical_name=Google Play】 →</a>
        </div>
      </div>

      <section style={{maxWidth:1120, margin:'0 auto', padding:'28px 20px 60px'}}>
        <h2 style={{fontSize:13, fontWeight:800, color:'#78716c', letterSpacing:1, marginBottom:12}}>ŞEHİR SEÇ - {cities.length} İL</h2>
        <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(160px, 1fr))', gap:10}}>
          {cities.map(c => (
            <Link key={c.slug} href={`/usta-is-ilanlari/${c.slug}/`} style={{background:'white', border:'1px solid #e7e5e4', borderRadius:10, padding:'12px', textDecoration:'none', color:'#111', fontWeight:700, fontSize:13}}>
              {c.name} <span style={{color:'#16a34a', fontWeight:600}}>• {jobs.length}</span>
            </Link>
          ))}
        </div>
      </section>
    </main>
  )
}