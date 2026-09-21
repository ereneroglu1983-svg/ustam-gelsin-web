// app/usta-is-ilanlari/[city]/page.tsx - FINAL - notFound
import { cities } from '../../../data/cities'
import { jobs } from '../../../data/jobs'
import Link from 'next/link'
import type { Metadata } from 'next'
import { notFound } from 'next/navigation'

export function generateStaticParams(){
  return cities.map(c=>({city:c.slug}))
}

export async function generateMetadata({params}:{params: Promise<{city:string}>}): Promise<Metadata>{
  const { city: citySlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  if(!city) return {}
  const canonical = `https://hemenustamgelsin.com/usta-is-ilanlari/${city.slug}`
  return {
    title: `${city.name} Usta İş İlanları - ${jobs.length} Kategoride Komisyonsuz İş Bul | Hemen Ustam Gelsin`,
    description: `${city.name} bölgesinde ${jobs.length} kategoride usta iş ilanları. Komisyon yok, hakediş %100 senin. ${city.name} için hemen iş al.`,
    alternates: { canonical },
    openGraph: {
      title: `${city.name} Usta İş İlanları`,
      description: `${city.name} bölgesinde komisyonsuz iş ilanları`,
      url: canonical,
      type: 'website',
      locale: 'tr_TR'
    },
    robots: { index: true, follow: true }
  }
}

export default async function UstaCityPage({params}:{params: Promise<{city:string}>}){
  const { city: citySlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  if(!city) notFound()

  const pageUrl = `https://hemenustamgelsin.com/usta-is-ilanlari/${city.slug}`

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com" },
      { "@type": "ListItem", "position": 2, "name": "Usta İş İlanları", "item": "https://hemenustamgelsin.com/usta-is-ilanlari" },
      { "@type": "ListItem", "position": 3, "name": `${city.name} Usta İş İlanları`, "item": pageUrl }
    ]
  }

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />

      <section style={{background:'#111', color:'white', padding:'32px 20px'}}>
        <div style={{maxWidth:1120, margin:'0 auto', display:'flex', justifyContent:'space-between', alignItems:'center', flexWrap:'wrap', gap:16}}>
          <div>
            <div style={{fontSize:12, color:'#a8a29e'}}><Link href="/" style={{color:'#a8a29e'}}>Ana Sayfa</Link> / <Link href="/usta-is-ilanlari" style={{color:'#a8a29e'}}>Usta İş İlanları</Link> / {city.name}</div>
            <h1 style={{fontSize:'clamp(24px, 3.5vw, 36px)', fontWeight:900, margin:'8px 0 0 0'}}>{city.name} Usta İş İlanları</h1>
            <p style={{color:'#a8a29e', marginTop:6, fontSize:14}}>{city.name} genelinde {jobs.length} kategoride komisyonsuz iş.</p>
          </div>
          <a href={`https://hemenustamgelsin.com?utm_source=seo&utm_medium=usta_city&utm_campaign=${city.slug}`}
             style={{background:'white', color:'black', padding:'14px 24px', borderRadius:12, fontWeight:900, textDecoration:'none', whiteSpace:'nowrap'}}>
            USTA OL, {city.name.toUpperCase()}'DA İŞ AL →
          </a>
        </div>
      </section>

      <section style={{maxWidth:1120, margin:'0 auto', padding:'24px 20px 60px'}}>
        <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(200px, 1fr))', gap:12}}>
          {jobs.map(j => (
            <Link key={j.slug} href={`/usta-is-ilanlari/${city.slug}/${j.slug}`} style={{background:'white', border:'1px solid #e7e5e4', borderRadius:12, padding:'14px', textDecoration:'none', color:'#111'}}>
              <div style={{fontSize:11, color:'#a8a29e', fontWeight:700, textTransform:'uppercase'}}>{city.name}</div>
              <div style={{fontWeight:800, fontSize:14, marginTop:2}}>{j.name}</div>
              <div style={{fontSize:12, color:'#16a34a', fontWeight:600, marginTop:6}}>İşleri gör →</div>
            </Link>
          ))}
        </div>
      </section>
    </main>
  )
}