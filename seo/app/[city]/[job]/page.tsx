// app/[city]/[job]/page.tsx - HugAI REVİZE - SEO TAM
import { cities } from '../../../data/cities'
import { jobs } from '../../../data/jobs'
import { getCityJobData } from '../../../data/cityJobDatabase'
import Link from 'next/link'
import type { Metadata } from 'next'

export function generateStaticParams(){
  const params: {city: string, job: string}[] = []
  for(const c of cities){
    for(const j of jobs){
      params.push({city: c.slug, job: j.slug})
    }
  }
  return params
}

export async function generateMetadata({params}:{params: Promise<{city:string,job:string}>}): Promise<Metadata>{
  const { city: citySlug, job: jobSlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  const job = jobs.find(j=>j.slug===jobSlug)
  if(!city ||!job) return {}
  const seoData = getCityJobData(city.slug, job.slug)
  if(!seoData) return {}
  const canonical = `https://hemenustamgelsin.com/${city.slug}/${job.slug}`
  return {
    title: seoData.metaTitle,
    description: seoData.metaDescription,
    alternates: { canonical },
    openGraph: {
      title: seoData.metaTitle,
      description: seoData.metaDescription,
      url: canonical,
      type: 'website',
      locale: 'tr_TR',
      siteName: 'Hemen Ustam Gelsin'
    },
    twitter: {
      card: 'summary_large_image',
      title: seoData.metaTitle,
      description: seoData.metaDescription
    },
    robots: { index: true, follow: true }
  }
}

const nearbyMap: Record<string, string[]> = {
  'adana': ['mersin','osmaniye','hatay','kahramanmaras','nigde','kayseri'],'adiyaman': ['kahramanmaras','gaziantep','sanliurfa','diyarbakir','malatya'],'afyonkarahisar': ['kutahya','eskisehir','konya','isparta','denizli','usak'],'agri': ['kars','igdir','van','bitlis','mus','erzurum'],'amasya': ['samsun','tokat','corum','yozgat','cankiri'],'ankara': ['kirikkale','konya','eskisehir','cankiri','bolu','kirsehir'],'antalya': ['mugla','burdur','isparta','konya','karaman','mersin'],'artvin': ['rize','erzurum','ardahan','kars'],'aydin': ['izmir','manisa','denizli','mugla'],'balikesir': ['canakkale','bursa','kutahya','manisa','izmir'],'bilecik': ['bursa','kutahya','eskisehir','sakarya','bolu'],'bingol': ['elazig','diyarbakir','mus','erzurum','tunceli'],'bitlis': ['van','mus','siirt','batman','diyarbakir'],'bolu': ['duzce','sakarya','bursa','bilecik','eskisehir','ankara','zonguldak'],'burdur': ['antalya','isparta','afyonkarahisar','denizli','mugla'],'bursa': ['yalova','kocaeli','bilecik','kutahya','balikesir','sakarya'],'canakkale': ['balikesir','tekirdag','edirne'],'cankiri': ['ankara','bolu','karabuk','kastamonu','corum','kirikkale'],'corum': ['samsun','amasya','yozgat','kirikkale','cankiri','sinop'],'denizli': ['mugla','aydin','manisa','usak','afyonkarahisar','burdur'],'diyarbakir': ['batman','mardin','sanliurfa','adiyaman','malatya','elazig','bingol'],'edirne': ['kirklareli','tekirdag','canakkale'],'elazig': ['malatya','diyarbakir','bingol','tunceli'],'erzincan': ['erzurum','tunceli','elazig','sivas','gumushane','bayburt'],'erzurum': ['kars','agri','mus','bingol','erzincan','bayburt','rize','artvin'],'eskisehir': ['bursa','kutahya','afyonkarahisar','ankara','bolu','bilecik'],'gaziantep': ['kilis','hatay','osmaniye','kahramanmaras','adiyaman','sanliurfa'],'giresun': ['trabzon','gumushane','erzincan','sivas','ordu'],'gumushane': ['trabzon','bayburt','erzincan','giresun','rize'],'hakkari': ['van','sirnak'],'hatay': ['adana','osmaniye','gaziantep','kilis'],'isparta': ['burdur','antalya','konya','afyonkarahisar'],'mersin': ['adana','karaman','konya','nigde','antalya','kahramanmaras'],'istanbul': ['kocaeli','tekirdag','yalova','bursa','sakarya'],'izmir': ['manisa','aydin','balikesir','denizli','usak'],'kars': ['ardahan','erzurum','agri','igdir'],'kastamonu': ['sinop','corum','cankiri','karabuk','bartin'],'kayseri': ['sivas','yozgat','nevsehir','nigde','adana','kahramanmaras'],'kirklareli': ['edirne','tekirdag','istanbul'],'kirsehir': ['yozgat','nevsehir','aksaray','ankara','kirikkale'],'kocaeli': ['istanbul','sakarya','bursa','yalova'],'konya': ['ankara','aksaray','karaman','antalya','isparta','afyonkarahisar','eskisehir','nigde'],'kutahya': ['bursa','bilecik','eskisehir','afyonkarahisar','usak','manisa','balikesir'],'malatya': ['elazig','diyarbakir','adiyaman','kahramanmaras','sivas','erzincan'],'manisa': ['izmir','balikesir','kutahya','usak','denizli','aydin'],'kahramanmaras': ['osmaniye','adana','kayseri','sivas','malatya','adiyaman','gaziantep'],'mardin': ['sanliurfa','diyarbakir','batman','sirnak','siirt'],'mugla': ['aydin','denizli','burdur','antalya'],'mus': ['bingol','diyarbakir','batman','bitlis','van','agri','erzurum'],'nevsehir': ['kirsehir','aksaray','nigde','kayseri','yozgat'],'nigde': ['kayseri','adana','mersin','konya','aksaray','nevsehir'],'ordu': ['samsun','tokat','sivas','giresun'],'rize': ['trabzon','artvin','erzurum','bayburt'],'sakarya': ['kocaeli','duzce','bolu','bilecik','bursa','istanbul'],'samsun': ['ordu','tokat','amasya','corum','sinop'],'siirt': ['batman','bitlis','van','sirnak','mardin'],'sinop': ['kastamonu','corum','samsun'],'sivas': ['tokat','ordu','giresun','erzincan','malatya','kayseri','yozgat'],'tekirdag': ['istanbul','kirklareli','edirne','canakkale'],'tokat': ['amasya','samsun','ordu','sivas','yozgat'],'trabzon': ['rize','gumushane','giresun','bayburt'],'tunceli': ['erzincan','elazig','bingol','erzurum'],'sanliurfa': ['gaziantep','adiyaman','diyarbakir','mardin','sirnak'],'usak': ['manisa','kutahya','afyonkarahisar','denizli'],'van': ['agri','bitlis','siirt','sirnak','hakkari','mus'],'yozgat': ['corum','amasya','tokat','sivas','kayseri','kirsehir','cankiri','kirikkale'],'zonguldak': ['duzce','bolu','karabuk','bartin'],'aksaray': ['konya','nigde','nevsehir','kirsehir','ankara'],'bayburt': ['trabzon','rize','erzurum','erzincan','gumushane'],'karaman': ['konya','mersin','antalya'],'kirikkale': ['ankara','cankiri','corum','yozgat','kirsehir'],'batman': ['diyarbakir','mardin','siirt','bitlis','mus'],'sirnak': ['mardin','siirt','van','hakkari','sanliurfa'],'bartin': ['zonguldak','karabuk','kastamonu'],'ardahan': ['kars','artvin','erzurum'],'igdir': ['kars','agri'],'yalova': ['kocaeli','bursa','istanbul','sakarya'],'karabuk': ['bolu','kastamonu','cankiri','bartin','zonguldak'],'kilis': ['gaziantep','hatay'],'osmaniye': ['adana','hatay','gaziantep','kahramanmaras'],'duzce': ['bolu','sakarya','zonguldak'],
}

function getNearbyCities(currentSlug: string) {
  const nearbySlugs = nearbyMap[currentSlug] || []
  let nearby = cities.filter(c => nearbySlugs.includes(c.slug))
  if (nearby.length < 6) {
    const popular = ['istanbul','ankara','izmir','bursa','antalya','adana','konya','gaziantep','mersin','kayseri']
    const extra = cities.filter(c => c.slug!== currentSlug && popular.includes(c.slug) &&!nearbySlugs.includes(c.slug)).slice(0, 12 - nearby.length)
    nearby = [...nearby,...extra]
  }
  return nearby.slice(0, 12)
}

export default async function JobCityPage({params}:{params: Promise<{city:string,job:string}>}){
  const { city: citySlug, job: jobSlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  const job = jobs.find(j=>j.slug===jobSlug)
  if(!city ||!job) return <div>Sayfa bulunamadı</div>
  const seoData = getCityJobData(city.slug, job.slug)
  if(!seoData) return <div>Sayfa bulunamadı</div>
  const slug = job.slug.toLowerCase()
  let icon = '🛠', color = '#111'
  if(slug.includes('boya')) { icon='🎨'; color='#db2777' }
  if(slug.includes('elektrik')) { icon='⚡'; color='#f59e0b' }
  if(slug.includes('tesisat')||slug.includes('su')) { icon='🚿'; color='#0ea5e9' }
  if(slug.includes('fayans')) { icon='🧱'; color='#a16207' }
  if(slug.includes('klima')) { icon='❄'; color='#06b6d4' }
  if(slug.includes('tavan')) { icon='🏗'; color='#57534e' }
  const pageUrl = `https://hemenustamgelsin.com/${city.slug}/${job.slug}`

  const serviceSchema = {
    "@context": "https://schema.org",
    "@type": "Service",
    "name": seoData.h1,
    "serviceType": job.name,
    "description": seoData.metaDescription,
    "provider": {
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
    },
    "areaServed": { "@type": "City", "name": city.name },
    "url": pageUrl
  }
  const breadcrumbSchema = { "@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [ { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com" }, { "@type": "ListItem", "position": 2, "name": `${city.name} Ustaları`, "item": `https://hemenustamgelsin.com/${city.slug}` }, { "@type": "ListItem", "position": 3, "name": `${city.name} ${job.name}`, "item": pageUrl } ] }
  const faqSchema = { "@context": "https://schema.org", "@type": "FAQPage", "mainEntity": seoData.faqs.map((f: any) => ({ "@type": "Question", "name": f.q, "acceptedAnswer": { "@type": "Answer", "text": f.a } })) }

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(serviceSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />
      <div style={{maxWidth:1120, margin:'0 auto', padding:'14px 20px 0', fontSize:12, color:'#a8a29e'}}><Link href={`/${city.slug}`} style={{color:'#78716c', textDecoration:'none'}}>{city.name} Ustaları</Link> <span> / </span> <b style={{color:'#111'}}>{job.name}</b></div>

      <section style={{ background: `radial-gradient(800px 400px at 15% 0%, ${color}15 0%, transparent 60%), #FFFBF5`, padding:'26px 20px 28px' }}>
        <div style={{maxWidth:1120, margin:'0 auto', display:'grid', gridTemplateColumns:'1.15fr 0.85fr', gap:24}}>
          <div>
            <div style={{display:'inline-flex', gap:6, background:'white', border:'1px solid #e7e5e4', borderRadius:999, padding:'6px 10px', fontSize:11, fontWeight:800, marginBottom:14}}><span style={{background:color, color:'white', borderRadius:999, padding:'2px 8px'}}>{icon} {job.name.toUpperCase()}</span><span>{city.name.toUpperCase()} • HugAI • KOMİSYON YOK</span></div>
            <h1 style={{fontSize:'clamp(28px, 4vw, 48px)', fontWeight:900, lineHeight:0.92, margin:0}}>{seoData.h1}<br/> HugAI ile Doğrulanmış Ustalar</h1>
            <p style={{fontSize:16, color:'#44403c', marginTop:12, maxWidth:560}}>{seoData.intro}</p>
            <div style={{marginTop:18, display:'flex', gap:10, flexWrap:'wrap'}}><a href="https://hemenustamgelsin.com" style={{background:'#111', color:'white', padding:'14px 20px', borderRadius:12, fontWeight:900, textDecoration:'none'}}>HEMEN İLAN VER →</a><a href="https://hemenustamgelsin.com" style={{background:'white', color:'#111', padding:'14px 20px', borderRadius:12, fontWeight:800, border:'1px solid #e7e5e4', textDecoration:'none'}}>USTA OL, {city.name.toUpperCase()}'DA İŞ AL</a></div>
            <div style={{marginTop:16, background:'white', border:'1px solid #e7e5e4', borderRadius:12, padding:'12px 14px', display:'flex', gap:10}}>
              <div style={{background:'#dcfce7', color:'#15803d', borderRadius:8, padding:'6px 10px', fontWeight:800, fontSize:12, height:'fit-content'}}>HugAI</div>
              <div>
                <div style={{fontWeight:800, fontSize:13}}>{seoData.fiyatM2} • Yaklaşık {seoData.ortalamaFiyat}</div>
                <div style={{fontSize:11, color:'#78716c'}}>{seoData.degiskenler}</div>
                <div style={{fontSize:11, color:'#15803d', fontWeight:600, marginTop:4}}>✓ Fotoğraf yükle, HugAI analiz etsin • Hakediş %100 ustanın</div>
              </div>
            </div>
            <div style={{marginTop:12, background:'#fffbeb', border:'1px solid #fde68a', borderRadius:12, padding:12}}>
              <div style={{fontWeight:800, fontSize:12}}>🤖 HugAI NASIL FİYAT TAHMİNİ YAPAR?</div>
              <div style={{fontSize:11, color:'#92400e', marginTop:6, lineHeight:1.5}}>
                1. Fotoğraf ve ölçülerini HugAI analiz eder<br/>
                2. {city.name} için {seoData.degiskenler} kontrol eder<br/>
                3. Yaklaşık maliyeti çıkarır: {seoData.ortalamaFiyat}<br/>
                4. Doğrulanmış ustalar komisyonsuz teklif verir
              </div>
            </div>
          </div>
          <div style={{background:'white', borderRadius:18, border:'1px solid #e7e5e4', padding:16}}>
            <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>NASIL ÇALIŞIR?</div>
            <div style={{display:'grid', gap:10}}>
              <div style={{background:'#fafaf9', borderRadius:12, padding:'12px 10px'}}>
                <div style={{fontWeight:800, fontSize:12}}>1. İhtiyacını Anlat</div>
                <div style={{fontSize:11, color:'#57534e', marginTop:2}}>{city.name} {job.name.toLowerCase()} için fotoğraf ve ölçü yükle, 2 dakikada ilan ver.</div>
              </div>
              <div style={{background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:12, padding:'12px 10px'}}>
                <div style={{fontWeight:800, fontSize:12}}>2. HugAI Analiz Etsin</div>
                <div style={{fontSize:11, color:'#166534', marginTop:2}}>HugAI fotoğraflarını analiz eder, {city.name} şartlarına göre yaklaşık {seoData.ortalamaFiyat} tahminini çıkarır.</div>
              </div>
              <div style={{background:'#fafaf9', borderRadius:12, padding:'12px 10px'}}>
                <div style={{fontWeight:800, fontSize:12}}>3. Doğrulanmış Usta Gelsin</div>
                <div style={{fontSize:11, color:'#57534e', marginTop:2}}>{city.name} {seoData.ilceler[0]} dahil doğrulanmış ustalar komisyonsuz teklif verir, aynı gün başlar.</div>
              </div>
            </div>
            <div style={{marginTop:14, display:'flex', flexWrap:'wrap', gap:6}}>{seoData.ilceler.slice(0,8).map((d:string)=>(<span key={d} style={{fontSize:11, background:'#fafaf9', border:'1px solid #e7e5e4', padding:'4px 8px', borderRadius:999}}>{d}</span>))}</div>
          </div>
        </div>
      </section>

      <section style={{maxWidth:1120, margin:'0 auto', padding:'18px 20px 60px', display:'grid', gridTemplateColumns:'1.2fr 0.8fr', gap:18}}>
        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
          <h3>✅ Neden {city.name}'da {job.name} için Hemen Ustam Gelsin?</h3>
          <ul style={{fontSize:13, color:'#44403c', lineHeight:1.6}}>
            <li>{city.name} {seoData.ilceler[0]} için HugAI analizli fiyat - {seoData.fiyatM2}</li>
            <li>81 ilde {seoData.ilceler.length} ilçede aynı gün hizmet - {city.name} genelinde</li>
            <li>Doğrulanmış ustalar - TC ve ustalık belgeli, {city.name} referanslı</li>
            <li>Komisyon %0 - Hakedişin %100'ü ustanın, fiyat şişmez</li>
            <li>HugAI ile keşifsiz ön tahmin - Fotoğraftan analiz</li>
          </ul>
          <h4>Sık Sorulan Sorular</h4>{seoData.faqs.map((faq:any, i:number)=>(<div key={i} style={{marginBottom:10, background:'#fafaf9', borderRadius:10, padding:10}}><div style={{fontWeight:800, fontSize:13}}>{faq.q}</div><div style={{fontSize:12, color:'#444', marginTop:4}}>{faq.a}</div></div>))}
        </div>
        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
          <div style={{fontWeight:800, fontSize:13, marginBottom:8}}>{city.name} Yakın Çevresi - {job.name}</div>
          <div style={{display:'flex', flexWrap:'wrap', gap:6}}>{getNearbyCities(city.slug).map((c)=>(<Link key={c.slug} href={`/${c.slug}/${job.slug}`} style={{fontSize:12, padding:'7px 12px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, textDecoration:'none', color:'#444'}}>{c.name} {job.name}</Link>))}</div>
        </div>
      </section>
    </main>
  )
}