import { cities } from '../../../data/cities'
import { jobs } from '../../../data/jobs'
import Link from 'next/link'

export function generateStaticParams(){
  const params=[]
  for(const c of cities){ for(const j of jobs){ params.push({city:c.slug,job:j.slug}) } }
  return params
}

export async function generateMetadata({params}:{params: Promise<{city:string,job:string}>}){
  const { city: citySlug, job: jobSlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  const job = jobs.find(j=>j.slug===jobSlug)
  if(!city||!job) return {}
  return {
    title: `${city.name} ${job.name} Ustası - Komisyonsuz | Hemen Ustam Gelsin`,
    description: `${city.name} ${job.name} için akıllı fiyat tahmini ile doğrulanmış usta bul. Komisyon yok, kesinti yok. Hemen teklif al.`,
    alternates: {
      canonical: `https://hemenustamgelsin.com/${city.slug}/${job.slug}`
    }
  }
}

// 81 İL İÇİN YAKIN ŞEHİR HARİTASI - TAM LİSTE
const nearbyMap: Record<string, string[]> = {
  'adana': ['mersin','osmaniye','hatay','kahramanmaras','nigde','kayseri'],
  'adiyaman': ['kahramanmaras','gaziantep','sanliurfa','diyarbakir','malatya'],
  'afyonkarahisar': ['kutahya','eskisehir','konya','isparta','denizli','usak'],
  'agri': ['kars','igdir','van','bitlis','mus','erzurum'],
  'amasya': ['samsun','tokat','corum','yozgat','cankiri'],
  'ankara': ['kirikkale','konya','eskisehir','cankiri','bolu','kirsehir'],
  'antalya': ['mugla','burdur','isparta','konya','karaman','mersin'],
  'artvin': ['rize','erzurum','ardahan','kars'],
  'aydin': ['izmir','manisa','denizli','mugla'],
  'balikesir': ['canakkale','bursa','kutahya','manisa','izmir'],
  'bilecik': ['bursa','kutahya','eskisehir','sakarya','bolu'],
  'bingol': ['elazig','diyarbakir','mus','erzurum','tunceli'],
  'bitlis': ['van','mus','siirt','batman','diyarbakir'],
  'bolu': ['duzce','sakarya','bursa','bilecik','eskisehir','ankara','zonguldak'],
  'burdur': ['antalya','isparta','afyonkarahisar','denizli','mugla'],
  'bursa': ['yalova','kocaeli','bilecik','kutahya','balikesir','sakarya'],
  'canakkale': ['balikesir','tekirdag','edirne'],
  'cankiri': ['ankara','bolu','karabuk','kastamonu','corum','kirikkale'],
  'corum': ['samsun','amasya','yozgat','kirikkale','cankiri','sinop'],
  'denizli': ['mugla','aydin','manisa','usak','afyonkarahisar','burdur'],
  'diyarbakir': ['batman','mardin','sanliurfa','adiyaman','malatya','elazig','bingol'],
  'edirne': ['kirklareli','tekirdag','canakkale'],
  'elazig': ['malatya','diyarbakir','bingol','tunceli'],
  'erzincan': ['erzurum','tunceli','elazig','sivas','gumushane','bayburt'],
  'erzurum': ['kars','agri','mus','bingol','erzincan','bayburt','rize','artvin'],
  'eskisehir': ['bursa','kutahya','afyonkarahisar','ankara','bolu','bilecik'],
  'gaziantep': ['kilis','hatay','osmaniye','kahramanmaras','adiyaman','sanliurfa'],
  'giresun': ['trabzon','gumushane','erzincan','sivas','ordu'],
  'gumushane': ['trabzon','bayburt','erzincan','giresun','rize'],
  'hakkari': ['van','sirnak'],
  'hatay': ['adana','osmaniye','gaziantep','kilis'],
  'isparta': ['burdur','antalya','konya','afyonkarahisar'],
  'mersin': ['adana','karaman','konya','nigde','antalya','kahramanmaras'],
  'istanbul': ['kocaeli','tekirdag','yalova','bursa','sakarya'],
  'izmir': ['manisa','aydin','balikesir','denizli','usak'],
  'kars': ['ardahan','erzurum','agri','igdir'],
  'kastamonu': ['sinop','corum','cankiri','karabuk','bartin'],
  'kayseri': ['sivas','yozgat','nevsehir','nigde','adana','kahramanmaras'],
  'kirklareli': ['edirne','tekirdag','istanbul'],
  'kirsehir': ['yozgat','nevsehir','aksaray','ankara','kirikkale'],
  'kocaeli': ['istanbul','sakarya','bursa','yalova'],
  'konya': ['ankara','aksaray','karaman','antalya','isparta','afyonkarahisar','eskisehir','nigde'],
  'kutahya': ['bursa','bilecik','eskisehir','afyonkarahisar','usak','manisa','balikesir'],
  'malatya': ['elazig','diyarbakir','adiyaman','kahramanmaras','sivas','erzincan'],
  'manisa': ['izmir','balikesir','kutahya','usak','denizli','aydin'],
  'kahramanmaras': ['osmaniye','adana','kayseri','sivas','malatya','adiyaman','gaziantep'],
  'mardin': ['sanliurfa','diyarbakir','batman','sirnak','siirt'],
  'mugla': ['aydin','denizli','burdur','antalya'],
  'mus': ['bingol','diyarbakir','batman','bitlis','van','agri','erzurum'],
  'nevsehir': ['kirsehir','aksaray','nigde','kayseri','yozgat'],
  'nigde': ['kayseri','adana','mersin','konya','aksaray','nevsehir'],
  'ordu': ['samsun','tokat','sivas','giresun'],
  'rize': ['trabzon','artvin','erzurum','bayburt'],
  'sakarya': ['kocaeli','duzce','bolu','bilecik','bursa','istanbul'],
  'samsun': ['ordu','tokat','amasya','corum','sinop'],
  'siirt': ['batman','bitlis','van','sirnak','mardin'],
  'sinop': ['kastamonu','corum','samsun'],
  'sivas': ['tokat','ordu','giresun','erzincan','malatya','kayseri','yozgat'],
  'tekirdag': ['istanbul','kirklareli','edirne','canakkale'],
  'tokat': ['amasya','samsun','ordu','sivas','yozgat'],
  'trabzon': ['rize','gumushane','giresun','bayburt'],
  'tunceli': ['erzincan','elazig','bingol','erzurum'],
  'sanliurfa': ['gaziantep','adiyaman','diyarbakir','mardin','sirnak'],
  'usak': ['manisa','kutahya','afyonkarahisar','denizli'],
  'van': ['agri','bitlis','siirt','sirnak','hakkari','mus'],
  'yozgat': ['corum','amasya','tokat','sivas','kayseri','kirsehir','cankiri','kirikkale'],
  'zonguldak': ['duzce','bolu','karabuk','bartin'],
  'aksaray': ['konya','nigde','nevsehir','kirsehir','ankara'],
  'bayburt': ['trabzon','rize','erzurum','erzincan','gumushane'],
  'karaman': ['konya','mersin','antalya'],
  'kirikkale': ['ankara','cankiri','corum','yozgat','kirsehir'],
  'batman': ['diyarbakir','mardin','siirt','bitlis','mus'],
  'sirnak': ['mardin','siirt','van','hakkari','sanliurfa'],
  'bartin': ['zonguldak','karabuk','kastamonu'],
  'ardahan': ['kars','artvin','erzurum'],
  'igdir': ['kars','agri'],
  'yalova': ['kocaeli','bursa','istanbul','sakarya'],
  'karabuk': ['bolu','kastamonu','cankiri','bartin','zonguldak'],
  'kilis': ['gaziantep','hatay'],
  'osmaniye': ['adana','hatay','gaziantep','kahramanmaras'],
  'duzce': ['bolu','sakarya','zonguldak'],
}

function getNearbyCities(currentSlug: string, allCities: readonly { name: string; slug: string }[]) {
  const nearbySlugs = nearbyMap[currentSlug] || []
  const all = [...allCities]
  let nearby = all.filter(c => nearbySlugs.includes(c.slug))
  if (nearby.length < 6) {
    const popular = ['istanbul','ankara','izmir','bursa','antalya','adana','konya','gaziantep','mersin','kayseri']
    const extra = all.filter(c => c.slug!== currentSlug && popular.includes(c.slug) &&!nearbySlugs.includes(c.slug)).slice(0, 12 - nearby.length)
    nearby = [...nearby,...extra]
  }
  return nearby.slice(0, 12)
}

export default async function JobCityPage({params}:{params: Promise<{city:string,job:string}>}){
  const { city: citySlug, job: jobSlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  const job = jobs.find(j=>j.slug===jobSlug)
  if(!city||!job) return <div>Sayfa bulunamadı</div>

  const slug = job.slug.toLowerCase()
  let icon = '🛠', color = '#111'
  if(slug.includes('boya')) { icon='🎨'; color='#db2777' }
  if(slug.includes('elektrik')) { icon='⚡'; color='#f59e0b' }
  if(slug.includes('tesisat')||slug.includes('su')) { icon='🚿'; color='#0ea5e9' }
  if(slug.includes('fayans')) { icon='🧱'; color='#a16207' }
  if(slug.includes('klima')) { icon='❄'; color='#06b6d4' }
  if(slug.includes('tavan')) { icon='🏗'; color='#57534e' }

  // --- SCHEMA.ORG - GÜVENLİ VERSİYON ---
  const pageUrl = `https://hemenustamgelsin.com/${city.slug}/${job.slug}`
  const serviceSchema = {
    "@context": "https://schema.org",
    "@type": "Service",
    "name": `${city.name} ${job.name} Ustası`,
    "serviceType": job.name,
    "description": `${city.name} ${job.name} için akıllı fiyat tahmini ile doğrulanmış usta bulma hizmeti. Komisyon yok, kesinti yok.`,
    "provider": {
      "@type": "Organization",
      "name": "Hemen Ustam Gelsin",
      "url": "https://hemenustamgelsin.com",
      "logo": "https://hemenustamgelsin.com/logo.png"
    },
    "areaServed": {
      "@type": "City",
      "name": city.name
    },
    "url": pageUrl,
    "offers": {
      "@type": "Offer",
      "availability": "https://schema.org/InStock",
      "priceCurrency": "TRY",
      "price": "0"
    }
  }

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com" },
      { "@type": "ListItem", "position": 2, "name": `${city.name} Ustaları`, "item": `https://hemenustamgelsin.com/${city.slug}` },
      { "@type": "ListItem", "position": 3, "name": `${city.name} ${job.name}`, "item": pageUrl }
    ]
  }

  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": `${city.name} ${job.name} fiyatı ne kadar?`,
        "acceptedAnswer": {
          "@type": "Answer",
          "text": `${city.name} ${job.name} fiyatı yapılacak işe göre değişir. Hemen Ustam Gelsin akıllı fiyat tahmini ile net fiyat alabilirsin, komisyon yok.`
        }
      },
      {
        "@type": "Question",
        "name": `${city.name} ${job.name} ustası ne kadar sürede gelir?`,
        "acceptedAnswer": {
          "@type": "Answer",
          "text": `${city.name} içinde talebin doğrulanmış ustalara iletilir ve hızlıca eşleşme sağlanır, aynı gün içinde hizmet alabilirsin.`
        }
      },
      {
        "@type": "Question",
        "name": `${job.name} hizmetinde garanti var mı?`,
        "acceptedAnswer": {
          "@type": "Answer",
          "text": `Evet, Hemen Ustam Gelsin üzerinden gelen ustalarda doğrulanmış usta sistemi ve işçilik takibi vardır.`
        }
      }
    ]
  }
  // --- SCHEMA END ---

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(serviceSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />

      <style>{`
       .hero-grid { display:grid; grid-template-columns:1.15fr 0.85fr; gap:24px; align-items:center; }
       .content-grid { display:grid; grid-template-columns:1.2fr 0.8fr; gap:18px; }
       .cta-row { display:flex; gap:10px; flex-wrap:wrap; }
        @media (max-width: 900px){
         .hero-grid,.content-grid { grid-template-columns:1fr; }
        }
        @media (max-width: 600px){
         .cta-row { flex-direction:column; }
         .cta-row a { width:100%; justify-content:center; text-align:center; }
        }
      `}</style>

      <div style={{maxWidth:1120, margin:'0 auto', padding:'14px 20px 0', fontSize:12, color:'#a8a29e'}}>
        <Link href={`/${city.slug}`} style={{color:'#78716c', textDecoration:'none'}}>{city.name} Ustaları</Link> <span> / </span> <b style={{color:'#111'}}>{job.name}</b>
      </div>

      <section style={{
        background: `radial-gradient(800px 400px at 15% 0%, ${color}15 0%, transparent 60%), radial-gradient(900px 500px at 85% -10%, #fef3c7 0%, transparent 60%), #FFFBF5`,
        padding:'26px 20px 28px'
      }}>
        <div style={{maxWidth:1120, margin:'0 auto'}} className="hero-grid">
          <div>
            <div style={{display:'inline-flex', gap:6, background:'white', border:'1px solid #e7e5e4', borderRadius:999, padding:'6px 10px', fontSize:11, fontWeight:800, marginBottom:14}}>
              <span style={{background:color, color:'white', borderRadius:999, padding:'2px 8px'}}>{icon} {job.name.toUpperCase()}</span>
              <span style={{color:'#57534e'}}>{city.name.toUpperCase()} • KOMİSYON YOK</span>
            </div>
            <h1 style={{fontSize:'clamp(28px, 4vw, 48px)', fontWeight:900, lineHeight:0.92, letterSpacing:-1.2, margin:0, color:'#0f0f0f'}}>
              {city.name}'da <span style={{color}}>{job.name}</span> Ustası<br/> Doğrulanmış Ustalarla
            </h1>
            <p style={{fontSize:'clamp(15px, 1.7vw, 17px)', color:'#44403c', lineHeight:1.5, marginTop:12, maxWidth:560}}>
              {city.name}'da <b>{job.name}</b> arıyorsan doğru yerdesin. Akıllı form ile talebin doğrudan doğrulanmış ustaya gider. Kazancının tamamı ustanın, komisyon yok.
            </p>
            <div className="cta-row" style={{marginTop:18}}>
              <a href="https://hemenustamgelsin.com" style={{background:'#111', color:'white', padding:'14px 20px', borderRadius:12, fontWeight:900, textDecoration:'none', display:'flex', alignItems:'center', gap:8, boxShadow:'0 10px 20px rgba(0,0,0,0.15)'}}>
                HEMEN İLAN VER → <span style={{fontWeight:600, opacity:0.7, fontSize:12}}>{city.name} {job.name}</span>
              </a>
              <a href="https://hemenustamgelsin.com" style={{background:'white', color:'#111', padding:'14px 20px', borderRadius:12, fontWeight:800, textDecoration:'none', border:'1px solid #e7e5e4'}}>
                USTA OL, {city.name.toUpperCase()}'DA İŞ AL
              </a>
            </div>
          </div>
          <div style={{background:'white', borderRadius:18, border:'1px solid #e7e5e4', padding:16, boxShadow:'0 16px 40px rgba(0,0,0,0.08)'}}>
            <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>NASIL ÇALIŞIR?</div>
            <div style={{display:'grid', gap:10}}>
              <div style={{display:'flex', gap:10, alignItems:'center', background:'#fafaf9', borderRadius:12, padding:10}}><div style={{width:32, height:32, borderRadius:10, background:'#e0f2fe', display:'grid', placeItems:'center', fontWeight:900}}>1</div><div><div style={{fontWeight:800, fontSize:13}}>İhtiyaç Analizi</div><div style={{fontSize:11, color:'#78716c'}}>Akıllı form</div></div></div>
              <div style={{display:'flex', gap:10, alignItems:'center', background:'#fafaf9', borderRadius:12, padding:10}}><div style={{width:32, height:32, borderRadius:10, background:'#fef3c7', display:'grid', placeItems:'center', fontWeight:900}}>2</div><div><div style={{fontWeight:800, fontSize:13}}>Akıllı Fiyat Tahmini</div><div style={{fontSize:11, color:'#78716c'}}>Keşfe gerek yok</div></div></div>
              <div style={{display:'flex', gap:10, alignItems:'center', background:'#fafaf9', borderRadius:12, padding:10}}><div style={{width:32, height:32, borderRadius:10, background:'#dcfce7', display:'grid', placeItems:'center', fontWeight:900}}>3</div><div><div style={{fontWeight:800, fontSize:13}}>Doğru Usta Eşleşmesi</div><div style={{fontSize:11, color:'#78716c'}}>{city.name} ustası</div></div></div>
            </div>
          </div>
        </div>
      </section>

      <section style={{maxWidth:1120, margin:'0 auto', padding:'18px 20px 60px'}} className="content-grid">
        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
          <h3 style={{margin:'0 0 8px 0', fontWeight:900}}>✅ Neden {city.name}'da {job.name} için Hemen Ustam Gelsin?</h3>
          <ul style={{margin:0, paddingLeft:18, color:'#44403c', lineHeight:1.7, fontSize:14}}>
            <li><b>81 ilde 42 iş kolu</b> - Türkiye geneli</li>
            <li><b>Doğrulanmış ustalar</b> - Güvenli hizmet</li>
            <li><b>Kesinti yok, komisyon %0</b> - Gerçek kazanç</li>
            <li><b>Yakıt masrafı yok</b> - Akıllı eşleşme</li>
            <li><b>Hızlı eşleşme</b> - Zaman kaybetme</li>
          </ul>
          <div style={{display:'flex', gap:8, marginTop:14, flexWrap:'wrap'}}>
            <a href="https://hemenustamgelsin.com" style={{background:'#16a34a', color:'white', padding:'10px 16px', borderRadius:10, fontWeight:800, textDecoration:'none'}}>Hemen İlan Ver</a>
            <Link href={`/${city.slug}`} style={{background:'#f5f5f4', color:'#111', padding:'10px 16px', borderRadius:10, fontWeight:700, textDecoration:'none'}}>← {city.name} Tüm Ustalar</Link>
          </div>
        </div>
        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
          <div style={{fontWeight:800, fontSize:13, marginBottom:8}}>{city.name} Yakın Çevresi - {job.name}</div>
          <div style={{display:'flex', flexWrap:'wrap', gap:6}}>
            {getNearbyCities(city.slug, cities).map((c:any)=>(
              <Link key={c.slug} href={`/${c.slug}/${job.slug}`} style={{fontSize:12, padding:'7px 12px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, textDecoration:'none', color:'#44403c', fontWeight:600}}>
                {c.name} {job.name}
              </Link>
            ))}
          </div>
          <div style={{marginTop:10, fontSize:11, color:'#16a34a', fontWeight:700}}>📍 {city.name} ve çevresinde hızlı usta bul • Komisyon %0</div>
        </div>
      </section>
    </main>
  )
}