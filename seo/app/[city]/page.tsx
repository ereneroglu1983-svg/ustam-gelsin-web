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
    title: `${city.name} Ustaları - Hemen Ustam Gelsin | %0 Komisyon`,
    description: `${city.name} bölgesinde komisyonsuz, kesintisiz 42 kategoride usta. Keşif + Fiyatlama Motoru ile %80 otomatik fiyat.`,
    alternates: {
      canonical: `https://hemenustamgelsin.com/${city.slug}`
    }
  }
}

export default async function CityPage({params}:{params: Promise<{city:string}>}){
  const { city: citySlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  if(!city) return <div>Bulunamadı</div>

  // --- SCHEMA.ORG - START BOSS ---
  const pageUrl = `https://hemenustamgelsin.com/${city.slug}`

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Ana Sayfa",
        "item": "https://hemenustamgelsin.com"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": `${city.name} Ustaları`,
        "item": pageUrl
      }
    ]
  }

  const collectionSchema = {
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    "name": `${city.name} Ustaları - 42 Kategoride Usta`,
    "description": `${city.name} bölgesinde komisyonsuz, kesintisiz 42 kategoride usta.`,
    "url": pageUrl,
    "isPartOf": {
      "@type": "WebSite",
      "name": "Hemen Ustam Gelsin",
      "url": "https://hemenustamgelsin.com"
    },
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
    "description": "81 ilde komisyonsuz usta bulma platformu",
    "areaServed": {
      "@type": "Country",
      "name": "Turkey"
    }
  }
  // --- SCHEMA.ORG - END BOSS ---

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      {/* SCHEMA INJECTION */}
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(collectionSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }} />

      {/* ===== PRO HERO - META SEVIYESI ===== */}
      <section style={{
        background: 'radial-gradient(1200px 600px at 20% -10%, #fef3c7 0%, transparent 60%), radial-gradient(1000px 500px at 90% 0%, #fee2e2 0%, transparent 60%), #FFFBF5',
        borderBottom:'1px solid #f5f5f4', padding:'32px 20px 36px'
      }}>
        <div style={{maxWidth:1120, margin:'0 auto'}}>

          {/* Top Trust Bar - Senin USP'lerin */}
          <div style={{display:'flex', gap:8, flexWrap:'wrap', marginBottom:22}}>
            <div style={{display:'flex', alignItems:'center', gap:8, background:'white', border:'1px solid #fecaca', padding:'6px 12px', borderRadius:999, boxShadow:'0 1px 2px rgba(0,0,0,0.05)'}}>
              <span style={{width:22, height:22, background:'#dc2626', borderRadius:'50%', display:'grid', placeItems:'center', color:'white', fontSize:12}}>✓</span>
              <span style={{fontSize:12, fontWeight:800, letterSpacing:0.2, color:'#991b1b'}}>KESİNTİ YOK • KOMİSYON YOK</span>
            </div>
            <div style={{display:'flex', alignItems:'center', gap:8, background:'white', border:'1px solid #e7e5e4', padding:'6px 12px', borderRadius:999, boxShadow:'0 1px 2px rgba(0,0,0,0.05)'}}>
              <span style={{width:22, height:22, background:'black', borderRadius:'50%', display:'grid', placeItems:'center', color:'white', fontSize:12}}>₺</span>
              <span style={{fontSize:12, fontWeight:800, color:'#111'}}>KAZANCIN %100'Ü SENİN</span>
            </div>
            <div style={{display:'flex', alignItems:'center', gap:8, background:'white', border:'1px solid #bbf7d0', padding:'6px 12px', borderRadius:999}}>
              <span style={{fontSize:12, fontWeight:700, color:'#166534'}}>⚡ KEŞİF + FİYATLAMA MOTORU • %80 OTOMATİK</span>
            </div>
          </div>

          <div style={{display:'grid', gridTemplateColumns:'1.2fr 0.8fr', gap:24, alignItems:'center'}}>
            <div>
              <h1 style={{fontSize:'clamp(32px, 4.5vw, 56px)', fontWeight:900, lineHeight:0.95, letterSpacing:-1.5, color:'#0f0f0f', margin:0}}>
                {city.name}’de doğru ustayı<br/>
                <span style={{background:'linear-gradient(90deg, #16a34a, #15803d)', WebkitBackgroundClip:'text', WebkitTextFillColor:'transparent'}}>5 dakikada</span> bul.
              </h1>
              <p style={{fontSize:'clamp(15px, 1.6vw, 18px)', color:'#57534e', lineHeight:1.5, marginTop:14, maxWidth:560}}>
                Geleneksel yöntemde usta 10 keşfe gider 2 iş alır. Bizde müşteri akıllı formla gelir,
                <b style={{color:'#111'}}> %80 fiyatı otomatik</b> çıkar, doğru ustayla eşleşir. Yakıt yok, zaman kaybı yok.
              </p>

              {/* DUAL CTA - IKISI DE ANA SAYFAYA */}
              <div style={{display:'flex', gap:12, marginTop:22, flexWrap:'wrap'}}>
                <a href="https://hemenustamgelsin.com"
                   style={{
                     background:'#111', color:'white', padding:'16px 22px', borderRadius:12,
                     fontWeight:800, fontSize:16, textDecoration:'none', display:'flex', alignItems:'center', gap:10,
                     boxShadow:'0 10px 20px rgba(0,0,0,0.15)', transition:'transform 0.15s'
                   }}>
                  <span style={{width:28, height:28, background:'white', borderRadius:8, display:'grid', placeItems:'center', color:'black'}}>→</span>
                  HEMEN İLAN VER
                  <span style={{opacity:0.6, fontWeight:600, fontSize:13, marginLeft:4}}>Ücretsiz teklif al</span>
                </a>

                <a href="https://hemenustamgelsin.com"
                   style={{
                     background:'white', color:'#111', padding:'16px 22px', borderRadius:12,
                     fontWeight:800, fontSize:16, textDecoration:'none', display:'flex', alignItems:'center', gap:10,
                     border:'1px solid #e7e5e4', boxShadow:'0 4px 12px rgba(0,0,0,0.06)'
                   }}>
                  USTA OL, İŞİNİ BUL
                  <span style={{fontSize:13, background:'#fef3c7', padding:'2px 8px', borderRadius:999}}>10.000+ Müşteri</span>
                </a>
              </div>

              <div style={{display:'flex', gap:16, marginTop:18, color:'#78716c', fontSize:13, flexWrap:'wrap'}}>
                <span>✓ 1000+ doğrulanmış usta</span>
                <span>✓ Ort. 5 dk eşleşme</span>
                <span>✓ %4,9 memnuniyet</span>
                <span>✓ 7/24 destek</span>
              </div>
            </div>

            {/* Sağ taraf - Mini özellik kartı - senin neden_biz.png'den */}
            <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:16, boxShadow:'0 12px 32px rgba(0,0,0,0.08)'}}>
              <div style={{fontWeight:800, fontSize:13, letterSpacing:0.5, color:'#444', marginBottom:12}}>BİZİM SİSTEM VS GELENEKSEL</div>
              <div style={{display:'grid', gap:10}}>
                <div style={{display:'flex', justifyContent:'space-between', fontSize:13}}><span style={{color:'#78716c'}}>10 Eve Keşif</span><span style={{fontWeight:800, color:'#dc2626', textDecoration:'line-through'}}>Yakıt + Zaman</span></div>
                <div style={{display:'flex', justifyContent:'space-between', fontSize:13}}><span style={{color:'#78716c'}}>Akıllı Form</span><span style={{fontWeight:800, color:'#16a34a'}}>%80 Otomatik Fiyat</span></div>
                <div style={{display:'flex', justifyContent:'space-between', fontSize:13}}><span style={{color:'#78716c'}}>Doğru Eşleşme</span><span style={{fontWeight:800}}>8/10 işe dönüşür</span></div>
                <div style={{height:1, background:'#f5f5f4', margin:'4px 0'}}/>
                <div style={{display:'flex', gap:8}}>
                  <div style={{flex:1, background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:10, padding:10, textAlign:'center'}}>
                    <div style={{fontWeight:900, color:'#15803d'}}>%80</div><div style={{fontSize:11, color:'#166534'}}>Oto Fiyat</div>
                  </div>
                  <div style={{flex:1, background:'#fffbeb', border:'1px solid #fde68a', borderRadius:10, padding:10, textAlign:'center'}}>
                    <div style={{fontWeight:900}}>%60</div><div style={{fontSize:11, color:'#92400e'}}>Zaman Tasarrufu</div>
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

      {/* GRID - Senin eski yapı ama Instagram kalitesinde */}
      <section style={{maxWidth:1120, margin:'0 auto', padding:'28px 20px 60px'}}>
        <div style={{display:'flex', justifyContent:'space-between', alignItems:'end', marginBottom:14, flexWrap:'wrap', gap:8}}>
          <div>
            <h2 style={{fontSize:22, fontWeight:900, margin:0, letterSpacing:-0.5}}>{city.name}’de en çok aranan hizmetler</h2>
            <p style={{color:'#78716c', fontSize:14, margin:'4px 0 0 0'}}>İhtiyacını seç, {city.name} için doğrulanmış ustadan anında teklif al</p>
          </div>
          <div style={{fontSize:12, color:'#a8a29e'}}>42 kategori • {city.name}</div>
        </div>

        <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(240px, 1fr))', gap:12}}>
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
                boxShadow:'0 1px 2px rgba(0,0,0,0.04)', transition:'all .15s'
              }}>
                <div style={{width:44, height:44, borderRadius:12, background:'#f5f5f4', display:'grid', placeItems:'center', fontSize:20}}>{icon}</div>
                <div style={{flex:1}}>
                  <div style={{fontSize:12, color:'#a8a29e', fontWeight:700, textTransform:'uppercase'}}>{city.name}</div>
                  <div style={{fontSize:15, fontWeight:800, lineHeight:1.2}}>{j.name}</div>
                  <div style={{fontSize:12, color:'#16a34a', fontWeight:600, marginTop:2}}>Hemen teklif al →</div>
                </div>
              </Link>
            )
          })}
        </div>

        {/* Bottom CTA - Yine ana sayfaya */}
        <div style={{marginTop:28, background:'#111', borderRadius:16, padding:'18px 20px', display:'flex', justifyContent:'space-between', alignItems:'center', flexWrap:'wrap', gap:12}}>
          <div style={{color:'white'}}>
            <div style={{fontWeight:900, fontSize:18}}>İşini şansa bırakma, doğru ustayla eşleş.</div>
            <div style={{color:'#a8a29e', fontSize:13, marginTop:2}}>{city.name}’de komisyonsuz sistemle hemen başla.</div>
          </div>
          <a href="https://hemenustamgelsin.com" style={{background:'white', color:'black', padding:'12px 18px', borderRadius:10, fontWeight:800, textDecoration:'none'}}>hemenustamgelsin.com →</a>
        </div>

      </section>
    </main>
  )
}