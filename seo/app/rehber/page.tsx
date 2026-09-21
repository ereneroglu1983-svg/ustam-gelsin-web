// app/rehber/page.tsx - FINAL - ITEMLIST + LINK + SLUG STANDARDI
import { collection, getDocs, orderBy, query } from 'firebase/firestore'
import { db } from '../../lib/firebase'
import Link from 'next/link'
import type { Metadata } from 'next'
import { cities } from '../../data/cities'
import { jobs } from '../../data/jobs'

export const revalidate = 3600
export const dynamic = 'force-static'

export const metadata: Metadata = {
  title: `İnşaat Rehberi - ${jobs.length} Kategoride Usta Tavsiyeleri ve Fiyat Rehberi | Hemen Ustam Gelsin`,
  description: `Boya, elektrik, tesisat, fayans ve ${jobs.length} kategoride usta tavsiyeleri, m2 fiyatları ve püf noktaları. ${cities.length} il için güncel rehberler.`,
  alternates: { canonical: 'https://hemenustamgelsin.com/rehber' },
  openGraph: {
    title: `İnşaat Rehberi - Usta Tavsiyeleri`,
    description: `${jobs.length} kategoride fiyat rehberi ve püf noktaları`,
    url: 'https://hemenustamgelsin.com/rehber',
    type: 'website'
  },
  robots: { index: true, follow: true }
}

async function getBlogs(){
  try {
    const q = query(collection(db, 'icerikler'), orderBy('tarih', 'desc'))
    const snap = await getDocs(q)
    return snap.docs.map(d => ({ id: d.id, ...(d.data() as any) }))
  } catch {
    return []
  }
}

export default async function RehberHub(){
  const blogs = await getBlogs()
  const listCount = Math.min(blogs.length, 50)

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com" },
      { "@type": "ListItem", "position": 2, "name": "İnşaat Rehberi", "item": "https://hemenustamgelsin.com/rehber" }
    ]
  }

  const collectionSchema = {
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    "name": "İnşaat Rehberi",
    "description": `${jobs.length} kategoride usta rehberleri`,
    "url": "https://hemenustamgelsin.com/rehber",
    "mainEntity": {
      "@type": "ItemList",
      "numberOfItems": listCount,
      "itemListElement": blogs.slice(0, 50).map((b:any, i:number) => ({
        "@type": "ListItem",
        "position": i+1,
        "name": b.baslik,
        "url": `https://hemenustamgelsin.com/rehber/${b.slug || b.id}`
      }))
    }
  }

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(collectionSchema) }} />

      <section style={{background:'#111', color:'white', padding:'36px 20px', textAlign:'center'}}>
        <h1 style={{fontSize:'clamp(28px, 4vw, 42px)', fontWeight:900, margin:0}}>İnşaat Rehberi - Usta Tavsiyeleri</h1>
        <p style={{color:'#a8a29e', marginTop:8, maxWidth:600, margin:'8px auto 0'}}>Boya, elektrik, tesisat ve {jobs.length} kategoride m2 fiyatları, püf noktaları ve usta tavsiyeleri.</p>
        <div style={{marginTop:16}}>
          <a href="https://hemenustamgelsin.com?utm_source=seo&utm_medium=rehber_hub" style={{background:'white', color:'black', padding:'12px 22px', borderRadius:10, fontWeight:900, textDecoration:'none', display:'inline-block'}}>HEMEN İLAN VER →</a>
        </div>
      </section>

      <div style={{maxWidth:1120, margin:'0 auto', padding:'24px 20px 60px'}}>
        <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(280px, 1fr))', gap:14}}>
          {blogs.map((b:any)=>(
            <Link key={b.id} href={`/rehber/${b.slug || b.id}`} style={{background:'white', border:'1px solid #e7e5e4', borderRadius:14, padding:16, textDecoration:'none', color:'#111'}}>
              <div style={{fontSize:11, fontWeight:700, color:'#16a34a', textTransform:'uppercase'}}>{b.kategori}</div>
              <div style={{fontWeight:800, marginTop:4, lineHeight:1.3}}>{b.baslik}</div>
              <div style={{fontSize:12, color:'#78716c', marginTop:8}}>Oku →</div>
            </Link>
          ))}
        </div>

        <div style={{marginTop:40, background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:20}}>
          <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>POPÜLER HİZMETLER - HEMEN USTA BUL</div>
          <div style={{display:'flex', flexWrap:'wrap', gap:8}}>
            {jobs.slice(0, 12).map(j => (
              <Link key={j.slug} href={`/istanbul/${j.slug}`} style={{fontSize:12, background:'#fafaf9', border:'1px solid #e7e5e4', padding:'8px 12px', borderRadius:999, textDecoration:'none', color:'#444'}}>
                İstanbul {j.name}
              </Link>
            ))}
            <Link href="/#sehirler" style={{fontSize:12, background:'#111', color:'white', padding:'8px 12px', borderRadius:999, textDecoration:'none'}}>Tüm Şehirler →</Link>
          </div>
        </div>
      </div>
    </main>
  )
}