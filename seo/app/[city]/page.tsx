import { cities } from '../../data/cities'
import { jobs } from '../../data/jobs'
import Link from 'next/link'

export function generateStaticParams(){ 
  return cities.map(c=>({city:c.slug})) 
}

export async function generateMetadata({params}:{params: Promise<{city:string}>}){
  const { city: citySlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  if(!city) return {}
  return {
    title: `${city.name} Ustaları - Komisyonsuz | Hemen Ustam Gelsin`,
    description: `${city.name} bölgesinde komisyonsuz, kesintisiz 42 kategoride doğrulanmış usta. Akıllı fiyat tahmini ile hemen teklif al.`,
    alternates: {
      canonical: `https://hemenustamgelsin.com/${city.slug}`
    }
  }
}

export default async function CityPage({params}:{params: Promise<{city:string}>}){
  const { city: citySlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  if(!city) return <div>Bulunamadı</div>

  const pageUrl = `https://hemenustamgelsin.com/${city.slug}`

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com" },
      { "@type": "ListItem", "position": 2, "name": `${city.name} Ustaları`, "item": pageUrl }
    ]
  }

  const collectionSchema = {
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    "name": `${city.name} Ustaları - 42 Kategoride Usta`,
    "description": `${city.name} bölgesinde komisyonsuz, kesintisiz 42 kategoride doğrulanmış usta.`,
    "url": pageUrl,
    "isPartOf": { "@type": "WebSite", "name": "Hemen Ustam Gelsin", "url": "https://hemenustamgelsin.com" },
    "mainEntity": {
      "@type": "ItemList",
      "name": `${city.name} Hizmetleri`,
      "numberOfItems": jobs.length,
      "itemListElement": jobs.map((job, index) => ({
        "@type": "ListItem",
        "position": index + 1,
        "name": `${city.name} ${job.name}`,
        "url": `https://hemenustamgelsin.com/${city.slug}/${job.slug}`
      }))
    }
  }

  const organizationSchema = {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "Hemen Ustam Gelsin",
    "url": "https://hemenustamgelsin.com",
    "logo": "https://hemenustamgelsin.com/logo.png",
    "description": "Türkiye'nin 81 ilinde 42 kategoride komisyonsuz usta bulma platformu.",
    "areaServed": { "@type": "Country", "name": "Turkey" }
  }

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(collectionSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }} />

      <style>{`
        .hero-grid { display:grid; grid-template-columns:1.2fr 0.8fr; gap:24px; align-items:center; }
        .services-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(240px, 1fr)); gap:12px; }
        .cta-row { display:flex; gap:12px; flex-wrap:wrap; }
        .trust-row { display:flex; gap:16px; color:#78716c; font-size:13px; flex-wrap:wrap; }
        @media (max-width: 900px){
          .hero-grid { grid-template-columns:1fr; }
          .services-grid { grid-template-columns:repeat(auto-fill, minmax(180px, 1fr)); }
        }
        @media (max-width: 600px){
          .services-grid { grid-template-columns:1fr 1fr; gap:10px; }
          .cta-row { flex-direction:column; }
          .cta-row a { width:100%; justify-content:center; }
          .trust-row { gap:10px; font-size:12px; }
        }
      `}</style>

      <section style={{
        background: 'radial-gradient(1200px 600px at 20% -10%, #fef3c7 0%, transparent 60%), radial-gradient(1000px 500px at 90% 0%, #fee2e2 0%, transparent 60%), #FFFBF5',
        borderBottom:'1px solid #f5f5f4', padding:'32px 20px 36px'
      }}>
        <div style={{maxWidth:1120, margin:'0 auto'}}>

          <div style={{display:'flex', gap:8, flexWrap:'wrap', marginBottom:22}}>
            <div style={{display:'flex', alignItems:'center', gap:8, background:'white', border:'1px solid #fecaca', padding:'6px 12px', borderRadius:999, boxShadow:'0 1px 2px rgba(0,0,0,0.05)'}}>
              <span style={{width:22, height:22, background:'#dc2626', borderRadius:'50%', display:'grid', placeItems:'center', color:'white', fontSize:12}}>✓</span>
              <span style={{fontSize:12, fontWeight:800, letterSpacing:0.2, color:'#991b1b'}}>KESİNTİ YOK • KOMİSYON YOK</span>
            </div>
            <div style={{display:'flex', alignItems:'center', gap:8, background:'white', border:'1px solid #e7e5e4', padding:'6px 12px', borderRadius:999}}>
              <span style={{width:22, height:22, background:'black', borderRadius:'50%', display:'grid', placeItems:'center', color:'white', fontSize:12}}>₺</span>
              <span style={{fontSize:12, fontWeight:800, color:'#111'}}>KAZANCIN %100'Ü SENİN</span>
            </div>
            <div style={{display:'flex', alignItems:'center', gap:8, background:'white', border:'1px solid #bbf7d0', padding:'6px 12px', borderRadius:999}}>
              <span style={{fontSize:12, fontWeight:700, color:'#166534'}}>⚡ KEŞİF + AKILLI FİYAT TAHMİNİ</span>
            </div>
          </div>

          <div className="hero-grid">
            <div>
              <h1 style={{fontSize:'clamp(28px, 4.5vw, 56px)', fontWeight:900, lineHeight:0.95, letterSpacing:-1.5, color:'#0f0f0f', margin:0}}>
                {city.name}'da doğru ustayı<br/>
                <span style={{background:'linear-gradient(90deg, #16a34a, #15803d)', WebkitBackgroundClip:'text', WebkitTextFillColor:'transparent'}}>hızlıca</span> bul.
              </h1>
              <p style={{fontSize:'clamp(15px, 1.6vw, 18px)', color:'#57534e', lineHeight:1.5, marginTop:14, maxWidth:560}}>
                Geleneksel yöntemde usta 10 keşfe gider 2 iş alır. Bizde müşteri akıllı formla gelir,
                <b style={{color:'#111'}}> akıllı fiyat tahmini</b> ile doğru ustayla eşleşir. Yakıt yok, zaman kaybı yok.
              </p>

              <div className="cta-row" style={{marginTop:22}}>
                <a href="https://hemenustamgelsin.com"
                   style={{
                     background:'#111', color:'white', padding:'16px 22px', borderRadius:12,
                     fontWeight:800, fontSize:16, textDecoration:'none', display:'flex', alignItems:'center', gap:10,
                     boxShadow:'0 10px 20px rgba(0,0,0,0.15)'
                   }}>
                  <span style={{width:28, height:28, background:'white', borderRadius:8, display:'grid', placeItems:'center', color:'black'}}>→</span>
                  HEMEN İLAN VER
                  <span style={{opacity:0.6, fontWeight:600, fontSize:13, marginLeft:4}}>Ücretsiz teklif al</span>
                </a>
                <a href="https://hemenustamgelsin.com"
                   style={{
                     background:'white', color:'#111', padding:'16px 22px', borderRadius:12,
                     fontWeight:800, fontSize:16, textDecoration:'none', display:'flex', alignItems:'center', gap:10,
                     border:'1px solid #e7e5e4'
                   }}>
                  USTA OL, İŞİNİ BUL
                  <span style={{fontSize:13, background:'#fef3c7', padding:'2px 8px', borderRadius:999}}>Doğrulanmış</span>
                </a>
              </div>

              <div className="trust-row" style={{marginTop:18}}>
                <span>✓ Doğrulanmış ustalar</span>
                <span>✓ Hızlı eşleşme</span>
                <span>✓ Yüksek memnuniyet</span>
                <span>✓ 7/24 destek</span>
              </div>
            </div>

            <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:16, boxShadow:'0 12px 32px rgba(0,0,0,0.08)'}}>
              <div style={{fontWeight:800, fontSize:13, letterSpacing:0.5, color:'#444', marginBottom:12}}>BİZİM SİSTEM VS GELENEKSEL</div>
              <div style={{display:'grid', gap:10}}>
                <div style={{display:'flex', justifyContent:'space-between', fontSize:13}}><span style={{color:'#78716c'}}>10 Eve Keşif</span><span style={{fontWeight:800, color:'#dc2626', textDecoration:'line-through'}}>Yakıt + Zaman</span></div>
                <div style={{display:'flex', justifyContent:'space-between', fontSize:13}}><span style={{color:'#78716c'}}>Akıllı Form</span><span style={{fontWeight:800, color:'#16a34a'}}>Akıllı Tahmin</span></div>
                <div style={{display:'flex', justifyContent:'space-between', fontSize:13}}><span style={{color:'#78716c'}}>Doğru Eşleşme</span><span style={{fontWeight:800}}>Hızlı Sonuç</span></div>
                <div style={{height:1, background:'#f5f5f4', margin:'4px 0'}}/>
                <div style={{display:'flex', gap:8}}>
                  <div style={{flex:1, background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:10, padding:10, textAlign:'center'}}>
                    <div style={{fontWeight:900, color:'#15803d'}}>Akıllı</div><div style={{fontSize:11, color:'#166534'}}>Fiyat Tahmini</div>
                  </div>
                  <div style={{flex:1, background:'#fffbeb', border:'1px solid #fde68a', borderRadius:10, padding:10, textAlign:'center'}}>
                    <div style={{fontWeight:900}}>Hızlı</div><div style={{fontSize:11, color:'#92400e'}}>Eşleşme</div>
                  </div>
                  <div style={{flex:1, background:'#fef2f2', border:'1px solid #fecaca', borderRadius:10, padding:10, textAlign:'center'}}>
                    <div style={{fontWeight:900, color:'#991b1b'}}>%0</div><div style={{fontSize:11, color:'#991b1b'}}>Komisyon</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section style={{maxWidth:1120, margin:'0 auto', padding:'28px 20px 60px'}}>
        <div style={{display:'flex', justifyContent:'space-between', alignItems:'end', marginBottom:14, flexWrap:'wrap', gap:8}}>
          <div>
            <h2 style={{fontSize:'clamp(18px, 2.5vw, 22px)', fontWeight:900, margin:0, letterSpacing:-0.5}}>{city.name}'da en çok aranan hizmetler</h2>
            <p style={{color:'#78716c', fontSize:14, margin:'4px 0 0 0'}}>İhtiyacını seç, {city.name} için doğrulanmış ustadan teklif al</p>
          </div>
          <div style={{fontSize:12, color:'#a8a29e'}}>42 kategori • {city.name}</div>
        </div>

        <div className="services-grid">
          {jobs.map(j=>{
            const slug = j.slug.toLowerCase()
            let icon = '🛠'
            if(slug.includes('boya')) icon='🎨'
            if(slug.includes('elektrik')) icon='⚡'
            if(slug.includes('tesisat')||slug.includes('su')) icon='🚿'
            if(slug.includes('fayans')||slug.includes('seramik')) icon='🧱'
            if(slug.includes('klima')) icon='❄'
            if(slug.includes('tavan')||slug.includes('alcipan')) icon='🏗'
            return (
              <Link key={j.slug} href={`/${city.slug}/${j.slug}`} style={{
                background:'white', border:'1px solid #e7e5e4', borderRadius:14, padding:14,
                textDecoration:'none', color:'#111', display:'flex', gap:12, alignItems:'center',
                boxShadow:'0 1px 2px rgba(0,0,0,0.04)'
              }}>
                <div style={{width:44, height:44, borderRadius:12, background:'#f5f5f4', display:'grid', placeItems:'center', fontSize:20, flexShrink:0}}>{icon}</div>
                <div style={{flex:1, minWidth:0}}>
                  <div style={{fontSize:11, color:'#a8a29e', fontWeight:700, textTransform:'uppercase', overflow:'hidden', textOverflow:'ellipsis', whiteSpace:'nowrap'}}>{city.name}</div>
                  <div style={{fontSize:14, fontWeight:800, lineHeight:1.2}}>{j.name}</div>
                  <div style={{fontSize:12, color:'#16a34a', fontWeight:600, marginTop:2}}>Teklif al →</div>
                </div>
              </Link>
            )
          })}
        </div>

        <div style={{marginTop:28, background:'#111', borderRadius:16, padding:'18px 20px', display:'flex', justifyContent:'space-between', alignItems:'center', flexWrap:'wrap', gap:12}}>
          <div style={{color:'white'}}>
            <div style={{fontWeight:900, fontSize:'clamp(16px, 2vw, 18px)'}}>İşini şansa bırakma, doğru ustayla eşleş.</div>
            <div style={{color:'#a8a29e', fontSize:13, marginTop:2}}>{city.name}'da komisyonsuz sistemle hemen başla.</div>
          </div>
          <a href="https://hemenustamgelsin.com" style={{background:'white', color:'black', padding:'12px 18px', borderRadius:10, fontWeight:800, textDecoration:'none', whiteSpace:'nowrap'}}>hemenustamgelsin.com →</a>
        </div>
      </section>
    </main>
  )
}