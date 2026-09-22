// app/rehber/page.tsx - FINAL - SEO + YENI TASARIM + INAKTIF CHIPLER + R2 FIX
import { collection, getDocs, orderBy, query, limit } from 'firebase/firestore'
import { db } from '../../lib/firebase'
import Link from 'next/link'
import type { Metadata } from 'next'
import { cities } from '../../data/cities'
import { jobs } from '../../data/jobs'

export const revalidate = 3600
export const dynamic = 'force-static'

function fixR2Url(path: string) {
  if (!path) return "";
  path = path.trim();
  const cdnBase = "https://cdn.hemenustamgelsin.com";
  const oldR2 = "https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev";
  path = path.replaceAll(oldR2, cdnBase);
  path = path.replaceAll(`${cdnBase}/ustam-gelsin-medya/`, `${cdnBase}/`);
  path = path.replaceAll("/ustam-gelsin-medya/", "/");
  path = path.replaceAll("ustam-gelsin-medya/", "");
  if (path.startsWith("http")) return path;
  if (path.startsWith("/")) return `${cdnBase}${path}`;
  return `${cdnBase}/${path}`;
}

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
  } catch { return [] }
}

async function getYeniUstalar(){
  try {
    const q = query(collection(db, 'karisik_slider'), orderBy('tarih', 'desc'), limit(8))
    const snap = await getDocs(q)
    return snap.docs.map(d => ({ id: d.id, ...(d.data() as any) }))
  } catch { return [] }
}

export default async function RehberHub(){
  const blogs = await getBlogs()
  const yeniUstalar = await getYeniUstalar()
  const listCount = Math.min(blogs.length, 50)

  const breadcrumbSchema = {
    "@context": "https://schema.org", "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com" },
      { "@type": "ListItem", "position": 2, "name": "İnşaat Rehberi", "item": "https://hemenustamgelsin.com/rehber" }
    ]
  }
  const collectionSchema = {
    "@context": "https://schema.org", "@type": "CollectionPage",
    "name": "İnşaat Rehberi", "description": `${jobs.length} kategoride usta rehberleri`,
    "url": "https://hemenustamgelsin.com/rehber",
    "mainEntity": {
      "@type": "ItemList", "numberOfItems": listCount,
      "itemListElement": blogs.slice(0, 50).map((b:any, i:number) => ({
        "@type": "ListItem", "position": i+1, "name": b.baslik, "url": `https://hemenustamgelsin.com/rehber/${b.slug || b.id}`
      }))
    }
  }

  const seoChips = [
    'Tadilat Rehberi','Dekorasyon Fikirleri','Mutfak Tadilatı','Banyo Yenileme',
    'Elektrik Tesisatı','Su Tesisatı','Boya Badana','Isı Yalıtım',
    'Çatı Tamiri','Fayans Döşeme','Parke Döşeme','Alçıpan İşleri'
  ]

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(collectionSchema) }} />

      <section style={{background:'#0f2233', color:'white', padding:'36px 20px'}}>
        <div style={{maxWidth:1120, margin:'0 auto'}}>
          <h1 style={{fontSize:'clamp(26px, 3vw, 32px)', fontWeight:900, margin:0, display:'flex', alignItems:'center', gap:8}}>📖 İnşaat Rehberi</h1>
          <p style={{color:'#a8a29e', marginTop:8, fontSize:14}}>Ev tadilatı, dekorasyon ve inşaat hakkında bilmeniz gereken her şey. {jobs.length} kategoride rehber.</p>
        </div>
      </section>

      <div style={{maxWidth:1120, margin:'0 auto', padding:'20px 20px 60px'}}>

        {/* INAKTIF SEO CHIPLER - TIKLANMAZ, SADECE KELIME GUCU */}
        <div style={{display:'flex', flexWrap:'wrap', gap:8, marginBottom:20}}>
          {seoChips.map(k => (
            <span key={k} style={{fontSize:12, background:'white', border:'1px solid #e7e5e4', padding:'6px 12px', borderRadius:999, color:'#57534e', fontWeight:500}}>
              {k}
            </span>
          ))}
        </div>

        {/* KOMPAKT YATAY KARTLAR - MOCKUP AYNISI */}
        <div style={{display:'grid', gap:12}}>
          {blogs.map((b:any)=>{
            const tarihStr = b.tarih?.toDate ? new Date(b.tarih.toDate()).toLocaleDateString('tr-TR', {day:'numeric', month:'long', year:'numeric'}) : '12 Nisan 2025'
            return (
              <Link key={b.id} href={`/rehber/${b.slug || b.id}`} style={{display:'flex', gap:16, background:'white', border:'1px solid #e7e5e4', borderRadius:14, padding:12, textDecoration:'none', color:'#111'}}>
                <div style={{position:'relative', width:132, height:96, flexShrink:0, borderRadius:10, overflow:'hidden', background:'#f5f5f4'}}>
                  <img src={fixR2Url(b.imagePath)} alt={b.baslik} style={{width:'100%', height:'100%', objectFit:'cover'}} loading="lazy" />
                  <span style={{position:'absolute', top:6, left:6, fontSize:9, fontWeight:800, background:'#ff6b00', color:'white', padding:'2px 6px', borderRadius:4}}>{(b.kategori || 'TADİLAT').toUpperCase()}</span>
                </div>
                <div style={{flex:1, minWidth:0, display:'flex', flexDirection:'column', justifyContent:'center'}}>
                  <span style={{fontSize:11, color:'#a8a29e'}}>📅 {tarihStr}</span>
                  <div style={{fontWeight:700, fontSize:14, lineHeight:1.3, marginTop:4, display:'-webkit-box', WebkitLineClamp:2, WebkitBoxOrient:'vertical', overflow:'hidden'}}>{b.baslik}</div>
                  <span style={{fontSize:12, color:'#2563eb', marginTop:8, fontWeight:600}}>Devamını oku →</span>
                </div>
              </Link>
            )
          })}
        </div>

        {/* YENI KATILAN USTALAR - SABIT GRID */}
        {yeniUstalar.length > 0 && (
          <div style={{marginTop:40}}>
            <div style={{fontWeight:900, fontSize:16, marginBottom:12}}>Yeni Katılan Ustalar</div>
            <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(160px, 1fr))', gap:12}}>
              {yeniUstalar.map((u:any)=>(
                <Link key={u.id} href={`/usta/${u.id}`} style={{background:'white', border:'1px solid #e7e5e4', borderRadius:12, overflow:'hidden', textDecoration:'none', color:'#111'}}>
                  <div style={{aspectRatio:'3/4', background:'#f5f5f4', position:'relative'}}>
                    <img src={fixR2Url(u.imagePath)} alt={u.baslik} style={{width:'100%', height:'100%', objectFit:'cover'}} loading="lazy" />
                    <div style={{position:'absolute', bottom:0, left:0, right:0, padding:8, background:'linear-gradient(to top, rgba(0,0,0,0.8), transparent)', color:'white', fontSize:11, fontWeight:700, whiteSpace:'nowrap', overflow:'hidden', textOverflow:'ellipsis'}}>{u.baslik}</div>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        )}

        {/* POPULER HIZMETLER - KORUNDU */}
        <div style={{marginTop:40, background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:20}}>
          <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>POPÜLER HİZMETLER - HEMEN USTA BUL</div>
          <div style={{display:'flex', flexWrap:'wrap', gap:8}}>
            {jobs.slice(0, 12).map((j:any) => (
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